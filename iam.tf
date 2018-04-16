## LambdaRoleLogParser ##

resource "aws_iam_role" "LambdaRoleLogParser" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-LambdaRoleLogParser"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "S3Access" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-S3Access"
  role  = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${var.AccessLogBucket}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "S3AccessPut" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-S3AccessPut"
  role  = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${var.AccessLogBucket}/aws-waf-security-automations-current-blocked-ips.json"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-WAFGetChangeToken" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-LambdaRoleLogParser-WAFGetChangeToken"
  role  = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-WAFGetAndUpdateIPSet" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-LambdaRoleLogParser-WAFGetAndUpdateIPSet"
  role  = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet"
            ],
            "Resource": [
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFBlacklistSet.id}",
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFScansProbesSet.id}",
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFHttpFloodSet.id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-LogsAccess" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-LambdaRoleLogParser-LogsAccess"
  role  = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup", 
                "logs:CreateLogStream", 
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-CloudWatchAccess" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-LambdaRoleLogParser-CloudWatchAccess"
  role  = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:GetMetricStatistics",
            "Resource": "*"
        }
    ]
}
EOF
}

## LambdaRoleReputationListsParser ##

resource "aws_iam_role" "LambdaRoleReputationListsParser" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleReputationListsParser"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "CloudWatchLogs" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-CloudWatchLogs"
  role  = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleReputationListsParser-WAFGetChangeToken" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleReputationListsParser-WAFGetChangeToken"
  role  = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet"
  role  = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "waf-regional:GetIPSet",
              "waf-regional:UpdateIPSet"
            ],
            "Resource": [
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFReputationListsSet1.id}",
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFReputationListsSet2.id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-CloudFormationAccess" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleLogParser-CloudFormationAccess"
  role  = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudformation:DescribeStacks",
            "Resource": "arn:aws:cloudformation:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stack/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleReputationListsParser-CloudWatchAccess" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleReputationListsParser-CloudWatchAccess"
  role  = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:GetMetricStatistics",
            "Resource": "*"
        }
    ]
}
EOF
}

## LambdaRoleBadBot ##

resource "aws_iam_role" "LambdaRoleBadBot" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleBadBot"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-WAFGetChangeToken" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleBadBot-WAFGetChangeToken"
  role  = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-WAFGetAndUpdateIPSet" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleBadBot-WAFGetAndUpdateIPSet"
  role  = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet"
            ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFBadBotSet.id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-LogsAccess" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleBadBot-LogsAccess"
  role  = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-CloudFormationAccess" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleBadBot-CloudFormationAccess"
  role  = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudformation:DescribeStacks",
            "Resource": "arn:aws:cloudformation:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stack/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-CloudWatchAccess" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleBadBot-CloudWatchAccess"
  role  = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:GetMetricStatistics",
            "Resource": "*"
        }
    ]
}
EOF
}

## LambdaRoleCustomResource ##

resource "aws_iam_role" "LambdaRoleCustomResource" {
  depends_on = ["aws_wafregional_web_acl.WAFWebACL"]
  name       = "${var.stack_prefix}-LambdaRoleCustomResource"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-S3Access" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-S3Access"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:CreateBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketNotification",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutBucketNotification"
            ],
            "Resource": "arn:aws:s3:::${var.AccessLogBucket}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-LambdaAccess" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-LambdaRoleCustomResource-LambdaAccess"
  role  = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "${aws_lambda_function.LambdaWAFReputationListsParserFunction.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFAccess" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-WAFAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetWebACL",
                "waf-regional:UpdateWebACL"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:webacl/${aws_wafregional_web_acl.WAFWebACL.id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFRuleAccess" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-WAFRuleAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetRule",
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet",
                "waf-regional:UpdateWebACL"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:rule/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFIPSetAccess" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-WAFIPSetAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}::ipset/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFRateBasedRuleAccess" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-WAFRateBasedRuleAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetRateBasedRule",
                "waf-regional:CreateRateBasedRule",
                "waf-regional:DeleteRateBasedRule",
                "waf-regional:ListRateBasedRules",
                "waf-regional:UpdateWebACL"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ratebasedrule/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-CloudFormationAccess" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-CloudFormationAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudformation:DescribeStacks",
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stack/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFGetChangeToken" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-WAFGetChangeToken"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-LogsAccess" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-LogsAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

## SolutionHelperRole ##

resource "aws_iam_role" "SolutionHelperRole" {
  name = "${var.stack_prefix}-SolutionHelperRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "SolutionHelperRole-Solution_Helper_Permissions" {
  name = "${var.stack_prefix}-LambdaRoleCustomResource-Solution_Helper_Permissions"
  role = "${aws_iam_role.SolutionHelperRole.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}
