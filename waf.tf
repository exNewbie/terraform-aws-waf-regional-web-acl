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

resource "aws_waf_sql_injection_match_set" "WAFSqlInjectionDetection" {
  name = "WAFSqlInjectionDetection"

  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

