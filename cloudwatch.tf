resource "aws_cloudwatch_event_rule" "LambdaWAFReputationListsParserEventsRule" {
  count               = "${local.ReputationListsProtectionActivated}"
  depends_on          = ["aws_lambda_function.LambdaWAFReputationListsParserFunction", "aws_wafregional_ipset.WAFReputationListsSet1", "aws_wafregional_ipset.WAFReputationListsSet2"]
  name                = "${var.stack_prefix}-LambdaWAFReputationListsParserEventsRule"
  description         = "Security Automations - WAF Reputation Lists"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "LambdaWAFReputationListsParserEventsRule-Target" {
  rule = "${aws_cloudwatch_event_rule.LambdaWAFReputationListsParserEventsRule.name}"
  arn  = "${aws_lambda_function.LambdaWAFReputationListsParserFunction.arn}"

  input = <<EOF
{
  "lists": [
    {
      "url": "https://www.spamhaus.org/drop/drop.txt"
    },
    {
      "url": "https://check.torproject.org/exit-addresses",
      "prefix": "ExitAddress "
    },
    {
      "url": "https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt"
    }
  ],
  "logType": "alb",
  "region": "${var.aws_region}",
  "ipSetIds": [
    "${aws_wafregional_ipset.WAFReputationListsSet1.id}",
    "${aws_wafregional_ipset.WAFReputationListsSet2.id}"
  ]
}
EOF
}
