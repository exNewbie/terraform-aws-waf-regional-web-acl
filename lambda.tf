resource "aws_lambda_function" "LambdaWAFLogParserFunction" {
  count         = "${local.LogParserActivated}"
  depends_on    = ["aws_iam_role.LambdaRoleLogParser", "aws_wafregional_ipset.WAFBlacklistSet", "aws_wafregional_ipset.WAFScansProbesSet", "aws_wafregional_ipset.WAFHttpFloodSet"]
  function_name = "${var.stack_prefix}-LambdaWAFLogParserFunction"
  description   = "This function parses ALB access logs to identify suspicious behavior, such as an abnormal amount of errors. It then blocks those IP addresses for a customer-defined period of time. Parameters: ${var.ErrorThreshold} ${var.WAFBlockPeriod}"
  role          = "${aws_iam_role.LambdaRoleLogParser.arn}"
  handler       = "log-parser.lambda_handler"
  runtime       = "python2.7"
  timeout       = "300"
  memory_size   = "512"
  s3_bucket     = "${join("-", list("solutions", var.aws_region))}"
  s3_key        = "aws-waf-security-automations/v2/log-parser.zip"

  environment {
    variables = {
      OUTPUT_BUCKET                                  = "${var.AccessLogBucket}"
      IP_SET_ID_BLACKLIST                            = "${aws_wafregional_ipset.WAFBlacklistSet.id}"
      IP_SET_ID_AUTO_BLOCK                           = "${aws_wafregional_ipset.WAFScansProbesSet.id}"
      IP_SET_ID_HTTP_FLOOD                           = "${aws_wafregional_ipset.WAFHttpFloodSet.id}"
      BLACKLIST_BLOCK_PERIOD                         = "${var.WAFBlockPeriod}"
      ERROR_PER_MINUTE_LIMIT                         = "${var.ErrorThreshold}"
      SEND_ANONYMOUS_USAGE_DATA                      = "${var.SendAnonymousUsageData}"
      UUID                                           = "${local.CreateUniqueID}"
      LIMIT_IP_ADDRESS_RANGES_PER_IP_MATCH_CONDITION = "10000"
      MAX_AGE_TO_UPDATE                              = "30"
      REGION                                         = "${var.aws_region}"
      LOG_TYPE                                       = "alb"
    }
  }
}

resource "aws_lambda_function" "LambdaWAFReputationListsParserFunction" {
  count         = "${local.ReputationListsProtectionActivated}"
  depends_on    = ["aws_iam_role.LambdaRoleReputationListsParser"]
  function_name = "${var.stack_prefix}-LambdaWAFReputationListsParserFunction"
  description   = "This lambda function checks third-party IP reputation lists hourly for new IP ranges to block. These lists include the Spamhaus Dont Route Or Peer (DROP) and Extended Drop (EDROP) lists, the Proofpoint Emerging Threats IP list, and the Tor exit node list."
  role          = "${aws_iam_role.LambdaRoleReputationListsParser.arn}"
  handler       = "reputation-lists-parser.handler"
  s3_bucket     = "${join("-", list("solutions", var.aws_region))}"
  s3_key        = "aws-waf-security-automations/v3/reputation-lists-parser.zip"
  runtime       = "nodejs6.10"
  timeout       = "300"
  memory_size   = "128"

  environment {
    variables = {
      SEND_ANONYMOUS_USAGE_DATA = "${var.SendAnonymousUsageData}"
      UUID                      = "${local.CreateUniqueID}"
    }
  }
}

resource "aws_lambda_function" "LambdaWAFBadBotParserFunction" {
  count         = "${local.BadBotProtectionActivated}"
  depends_on    = ["aws_iam_role.LambdaRoleBadBot"]
  function_name = "${var.stack_prefix}-LambdaWAFBadBotParserFunction"
  description   = "This lambda function intercepts and inspects trap endpoint requests to extract its IP address, and then add it to an AWS WAF block list."
  role          = "${aws_iam_role.LambdaRoleBadBot.arn}"
  handler       = "access-handler.lambda_handler"
  runtime       = "python2.7"
  timeout       = "300"
  memory_size   = "128"

  s3_bucket = "${join("-", list("solutions", var.aws_region))}"
  s3_key    = "aws-waf-security-automations/v2/access-handler.zip"

  environment {
    variables = {
      IP_SET_ID_BAD_BOT         = "${aws_wafregional_ipset.WAFBadBotSet.id}"
      SEND_ANONYMOUS_USAGE_DATA = "${var.SendAnonymousUsageData}"
      UUID                      = "${local.CreateUniqueID}"
      REGION                    = "${var.aws_region}"
      LOG_TYPE                  = "alb"
    }
  }
}

resource "aws_lambda_function" "LambdaWAFCustomResourceFunction" {
  depends_on    = ["aws_iam_role.LambdaRoleCustomResource"]
  function_name = "${var.stack_prefix}-LambdaWAFCustomResourceFunction"
  description   = "This lambda function configures the Web ACL rules based on the features enabled in the CloudFormation template."
  role          = "${aws_iam_role.LambdaRoleCustomResource.arn}"
  handler       = "custom-resource.lambda_handler"
  runtime       = "python2.7"
  timeout       = "300"
  memory_size   = "128"

  s3_bucket = "${join("-", list("solutions", var.aws_region))}"
  s3_key    = "aws-waf-security-automations/v4/custom-resource.zip"
}

resource "aws_lambda_function" "SolutionHelper" {
  function_name = "${var.stack_prefix}-SolutionHelper"
  description   = "This lambda function executes generic common tasks to support this solution."
  role          = "${aws_iam_role.SolutionHelperRole.arn}"
  handler       = "solution-helper.lambda_handler"
  runtime       = "python2.7"
  timeout       = "300"

  s3_bucket = "${join("-", list("solutions", var.aws_region))}"
  s3_key    = "library/solution-helper/v1/solution-helper.zip"
}

### Lambda permits services to execute ###

resource "aws_lambda_permission" "LambdaWAFLogParserFunction-Permission" {
  count          = "${local.LogParserActivated}"
  depends_on     = ["aws_lambda_function.LambdaWAFLogParserFunction"]
  statement_id   = "LambdaInvokePermissionLogParser"
  action         = "lambda:*"
  function_name  = "${aws_lambda_function.LambdaWAFLogParserFunction.function_name}"
  principal      = "s3.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
}

resource "aws_lambda_permission" "LambdaInvokePermissionReputationListsParser-Permission" {
  count         = "${local.ReputationListsProtectionActivated}"
  depends_on    = ["aws_lambda_function.LambdaWAFReputationListsParserFunction", "aws_cloudwatch_event_rule.LambdaWAFReputationListsParserEventsRule"]
  statement_id  = "LambdaInvokePermissionReputationListsParser"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.LambdaWAFReputationListsParserFunction.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.LambdaWAFReputationListsParserEventsRule.arn}"
}

resource "aws_lambda_permission" "LambdaInvokePermissionBadBot-Permission" {
  count         = "${local.BadBotProtectionActivated}"
  depends_on    = ["aws_lambda_function.LambdaWAFBadBotParserFunction"]
  statement_id  = "LambdaInvokePermissionBadBot"
  action        = "lambda:*"
  function_name = "${aws_lambda_function.LambdaWAFBadBotParserFunction.function_name}"
  principal     = "apigateway.amazonaws.com"
}
