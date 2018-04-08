### IPSet ###

resource "aws_wafregional_ipset" "WAFWhitelistSet" {
  name = "WAFWhitelistSet"
}

resource "aws_wafregional_ipset" "WAFBlacklistSet" {
  name = "WAFBlacklistSet"
}

resource "aws_wafregional_ipset" "WAFScansProbesSet" {
  name = "WAFScansProbesSet"
}

resource "aws_wafregional_ipset" "WAFReputationListsSet1" {
  name = "WAFReputationListsSet1"
}

resource "aws_wafregional_ipset" "WAFReputationListsSet2" {
  name = "WAFReputationListsSet2"
}

resource "aws_wafregional_ipset" "WAFBadBotSet" {
  name = "WAFBadBotSet"
}

### SqlInjectionMatchSet ###

resource "aws_wafregional_sql_injection_match_set" "WAFSqlInjectionDetection" {
  name = "WAFSqlInjectionDetection"

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
  name = "WAFXssDetection"

  xss_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "URI"
    }
  }

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
  name        = "WAFWhitelistRule"
  metric_name = "SecurityAutomationsWhitelistRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFWhitelistSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFBlacklistRule" {
  name        = "WAFBlacklistRule"
  metric_name = "SecurityAutomationsBlacklistRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFBlacklistSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFScansProbesRule" {
  name        = "WAFScansProbesRule"
  metric_name = "SecurityAutomationsScansProbesRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFScansProbesSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFIPReputationListsRule1" {
  name        = "WAFIPReputationListsRule1"
  metric_name = "SecurityAutomationsIPReputationListsRule1"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFReputationListsSet1.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFIPReputationListsRule2" {
  name        = "WAFIPReputationListsRule1"
  metric_name = "SecurityAutomationsIPReputationListsRule2"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFReputationListsSet2.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFBadBotRule" {
  name        = "WAFBadBotRule"
  metric_name = "SecurityAutomationsBadBotRule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.WAFBadBotSet.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFSqlInjectionRule" {
  name        = "WAFSqlInjectionRule"
  metric_name = "SecurityAutomationsSqlInjectionRule"

  predicate {
    type    = "SqlInjectionMatch"
    data_id = "${aws_wafregional_sql_injection_match_set.WAFSqlInjectionDetection.id}"
    negated = false
  }
}

resource "aws_wafregional_rule" "WAFXssRule" {
  name        = "WAFXssRule"
  metric_name = "SecurityAutomationsXssRule"

  predicate {
    type    = "XssMatch"
    data_id = "${aws_wafregional_xss_match_set.WAFXssDetection.id}"
    negated = false
  }
}
