### IPSet ###

resource "aws_wafregional_ipset" "WAFWhitelistSet" {
  name = "${var.stack_prefix}-WAFWhitelistSet"

  ip_set_descriptor = "${var.WAFWhitelistedIPSets}"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

resource "aws_wafregional_ipset" "WAFBlacklistSet" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-WAFBlacklistSet"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

resource "aws_wafregional_ipset" "WAFHttpFloodSet" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-WAFHttpFloodSet"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

resource "aws_wafregional_ipset" "WAFScansProbesSet" {
  count = "${local.LogParserActivated}"
  name  = "${var.stack_prefix}-WAFScansProbesSet"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

resource "aws_wafregional_ipset" "WAFReputationListsSet1" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-WAFReputationListsSet1"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

resource "aws_wafregional_ipset" "WAFReputationListsSet2" {
  count = "${local.ReputationListsProtectionActivated}"
  name  = "${var.stack_prefix}-WAFReputationListsSet2"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

resource "aws_wafregional_ipset" "WAFBadBotSet" {
  count = "${local.BadBotProtectionActivated}"
  name  = "${var.stack_prefix}-WAFBadBotSet"

  lifecycle {
    ignore_changes = ["ip_set_descriptor"]
  }
}

### SqlInjectionMatchSet ###

resource "aws_wafregional_sql_injection_match_set" "WAFSqlInjectionDetection" {
  count = "${local.SqlInjectionProtectionActivated}"
  name  = "${var.stack_prefix}-WAFSqlInjectionDetection"

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "QUERY_STRING"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "BODY"
    }

    text_transformation = "URL_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "BODY"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "URI"
    }

    text_transformation = "URL_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "URI"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Cookie"
    }

    text_transformation = "URL_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Cookie"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Authorization"
    }

    text_transformation = "URL_DECODE"
  }

  sql_injection_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Authorization"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }
}

### XssMatchSet ###

resource "aws_wafregional_xss_match_set" "WAFXssDetection" {
  count = "${local.CrossSiteScriptingProtectionActivated}"
  name  = "${var.stack_prefix}-WAFXssDetection"

  xss_match_tuple {
    field_to_match {
      type = "QUERY_STRING"
    }

    text_transformation = "URL_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "QUERY_STRING"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "BODY"
    }

    text_transformation = "URL_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "BODY"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "URI"
    }

    text_transformation = "URL_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "URI"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Cookie"
    }

    text_transformation = "URL_DECODE"
  }

  xss_match_tuple {
    field_to_match {
      type = "HEADER"
      data = "Cookie"
    }

    text_transformation = "HTML_ENTITY_DECODE"
  }
}

### Rules ###

resource "aws_wafregional_rule" "WAFWhitelistRule" {
  depends_on  = ["aws_wafregional_ipset.WAFWhitelistSet"]
  name        = "${var.stack_prefix}-WAFWhitelistRule"
  metric_name = "SecurityAutomationsWhitelistRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFWhitelistSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFBlacklistRule" {
  depends_on  = ["aws_wafregional_ipset.WAFBlacklistSet"]
  name        = "${var.stack_prefix}-WAFBlacklistRule"
  metric_name = "SecurityAutomationsBlacklistRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFBlacklistSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rate_based_rule" "WAFHttpFloodRule" {
  depends_on  = ["aws_wafregional_ipset.WAFHttpFloodSet"]
  name        = "${var.stack_prefix}-WAFHttpFloodRule"
  metric_name = "SecurityAutomationsHttpFloodRule"

  rate_key   = "IP"
  rate_limit = "${var.RequestThreshold}"

  predicate {
    data_id = "${aws_wafregional_ipset.WAFHttpFloodSet.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_rule" "WAFScansProbesRule" {
  count       = "${local.LogParserActivated}"
  depends_on  = ["aws_wafregional_ipset.WAFScansProbesSet"]
  name        = "${var.stack_prefix}-WAFScansProbesRule"
  metric_name = "SecurityAutomationsScansProbesRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFScansProbesSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFIPReputationListsRule1" {
  count       = "${local.ReputationListsProtectionActivated}"
  depends_on  = ["aws_wafregional_ipset.WAFReputationListsSet1"]
  name        = "${var.stack_prefix}-WAFIPReputationListsRule1"
  metric_name = "SecurityAutomationsIPReputationListsRule1"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFReputationListsSet1.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFIPReputationListsRule2" {
  count       = "${local.ReputationListsProtectionActivated}"
  depends_on  = ["aws_wafregional_ipset.WAFReputationListsSet2"]
  name        = "${var.stack_prefix}-WAFIPReputationListsRule2"
  metric_name = "SecurityAutomationsIPReputationListsRule2"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFReputationListsSet2.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFBadBotRule" {
  count       = "${local.BadBotProtectionActivated}"
  depends_on  = ["aws_wafregional_ipset.WAFBadBotSet"]
  name        = "${var.stack_prefix}-WAFBadBotRule"
  metric_name = "SecurityAutomationsBadBotRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFBadBotSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFSqlInjectionRule" {
  count       = "${local.SqlInjectionProtectionActivated}"
  depends_on  = ["aws_wafregional_sql_injection_match_set.WAFSqlInjectionDetection"]
  name        = "${var.stack_prefix}-WAFSqlInjectionRule"
  metric_name = "SecurityAutomationsSqlInjectionRule"

  predicate {
    type    = "SqlInjectionMatch"
    data_id = "${aws_wafregional_sql_injection_match_set.WAFSqlInjectionDetection.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFXssRule" {
  count       = "${local.CrossSiteScriptingProtectionActivated}"
  depends_on  = ["aws_wafregional_xss_match_set.WAFXssDetection"]
  name        = "${var.stack_prefix}-WAFXssRule"
  metric_name = "SecurityAutomationsXssRule"

  predicate {
    type    = "XssMatch"
    data_id = "${aws_wafregional_xss_match_set.WAFXssDetection.id}"
    negated = false
  }
}

### Web ACL and associations ###

resource "aws_wafregional_web_acl" "WAFWebACL" {
  depends_on  = ["aws_wafregional_rule.WAFWhitelistRule"]
  name        = "${var.stack_prefix}-WAFWebACL"
  metric_name = "SecurityAutomationsMaliciousRequesters"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "ALLOW"
    }

    priority = 201
    rule_id  = "${aws_wafregional_rule.WAFWhitelistRule.id}"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 401
    rule_id  = "${aws_wafregional_rule.WAFBlacklistRule.id}"
  }

  /* Terraform bug https://github.com/terraform-providers/terraform-provider-aws/issues/4184
  rule {
    action {
      type = "BLOCK"
    }

    priority = 402
    rule_id  = "${aws_wafregional_rate_based_rule.WAFHttpFloodRule.id}"
  }
*/

  rule {
    action {
      type = "BLOCK"
    }

    priority = 403
    rule_id  = "${aws_wafregional_rule.WAFScansProbesRule.id}"
  }
  rule {
    action {
      type = "BLOCK"
    }

    priority = 404
    rule_id  = "${aws_wafregional_rule.WAFIPReputationListsRule1.id}"
  }
  rule {
    action {
      type = "BLOCK"
    }

    priority = 405
    rule_id  = "${aws_wafregional_rule.WAFIPReputationListsRule2.id}"
  }

  /* disabled together with API Gateway
  rule {
    action {
      type = "BLOCK"
    }

    priority = 406
    rule_id  = "${aws_wafregional_rule.WAFBadBotRule.id}"
  }
*/

  rule {
    action {
      type = "BLOCK"
    }

    priority = 407
    rule_id  = "${aws_wafregional_rule.WAFSqlInjectionRule.id}"
  }
  rule {
    action {
      type = "BLOCK"
    }

    priority = 408
    rule_id  = "${aws_wafregional_rule.WAFXssRule.id}"
  }
}

resource "aws_wafregional_web_acl_association" "WAFWebACL-Association" {
  depends_on   = ["aws_wafregional_web_acl.WAFWebACL"]
  count        = "${length(var.alb_arn)}"
  resource_arn = "${element(var.alb_arn, count.index)}"
  web_acl_id   = "${aws_wafregional_web_acl.WAFWebACL.id}"
}
