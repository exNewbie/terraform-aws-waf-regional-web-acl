### Variables ###

variable "aws_region" {
  type = "string"
}

variable "stack_prefix" {
  type        = "string"
  description = "Stack name"
}

variable "alb_arn" {
  type        = "list"
  description = "ARN of Application Load Balancer"
}

variable "SqlInjectionProtectionParam" {
  "type"        = "string"
  "default"     = "yes"
  "description" = "Choose yes to enable the component designed to block common SQL injection attacks. AllowedValues: yes, no"
}

variable "CrossSiteScriptingProtectionParam" {
  "type"        = "string"
  "default"     = "yes"
  "description" = "Choose yes to enable the component designed to block common XSS attacks. AllowedValues: yes, no"
}

variable "ActivateHttpFloodProtectionParam" {
  "type"        = "string"
  "default"     = "yes"
  "description" = "Choose yes to enable the component designed to block HTTP flood attacks. AllowedValues: yes, no"
}

variable "ActivateScansProbesProtectionParam" {
  "type"        = "string"
  "default"     = "yes"
  "description" = "Choose yes to enable the component designed to block scanners and probes. AllowedValues: yes, no"
}

variable "ActivateReputationListsProtectionParam" {
  "type"        = "string"
  "default"     = "yes"
  "description" = "Choose yes to block requests from IP addresses on third-party reputation lists (supported lists: spamhaus, torproject, and emergingthreats). AllowedValues: yes, no"
}

variable "ActivateBadBotProtectionParam" {
  "type"        = "string"
  "default"     = "no"
  "description" = "Choose yes to enable the component designed to block bad bots and content scrapers. AllowedValues: yes, no"
}

variable "AccessLogBucket" {
  "type"        = "string"
  "description" = "(Required) Enter a name for the Amazon S3 bucket where you want to store Amazon ALB access logs. This can be the name of either an existing S3 bucket, or a new bucket that the template will create during stack launch (if it does not find a matching bucket name). The solution will modify the bucket's notification configuration to trigger the Log Parser AWS Lambda function whenever a new log file is saved in this bucket. More about bucket name restriction here: http://amzn.to/1p1YlU5"
}

variable "SendAnonymousUsageData" {
  "type"        = "string"
  "default"     = "yes"
  "description" = "Send anonymous data to AWS to help us understand solution usage across our customer base as a whole. To opt out of this feature, select No. AllowedValues: yes, no"
}

variable "RequestThreshold" {
  "type"        = "string"
  "default"     = "2000"
  "description" = "If you chose yes for the Activate HTTP Flood Protection parameter, enter the maximum acceptable requests per FIVE-minute period per IP address. Minimum value of 2000. If you chose to deactivate this protection, ignore this parameter. MinValue=2000"
}

variable "ErrorThreshold" {
  "type"        = "string"
  "default"     = "50"
  "description" = "If you chose yes for the Activate Scanners & Probes Protection parameter, enter the maximum acceptable bad requests per minute per IP. If you chose to deactivate Scanners & Probes protection, ignore this parameter. MinValue=0"
}

variable "WAFBlockPeriod" {
  "type"        = "string"
  "default"     = "240"
  "description" = "If you chose yes for the Activate Scanners & Probes Protection parameters, enter the period (in minutes) to block applicable IP addresses. If you chose to deactivate this protection, ignore this parameter. MinValue=0"
}

variable "WAFWhitelistedIPSets" {
  "type"        = "list"
  "description" = "List of Whitelisted IP addresses"
}

### Data ###

data "aws_caller_identity" "current" {}

resource "random_string" "UniqueID" {
  length  = 32
  special = false
}

### Conditions ###

locals {
  SqlInjectionProtectionActivated       = "${var.SqlInjectionProtectionParam == "yes" ? 1 : 0}"
  CrossSiteScriptingProtectionActivated = "${var.CrossSiteScriptingProtectionParam == "yes" ? 1 : 0}"
  HttpFloodProtectionActivated          = "${var.ActivateHttpFloodProtectionParam == "yes" ? 1 : 0}"
  ScansProbesProtectionActivated        = "${var.ActivateScansProbesProtectionParam == "yes" ? 1 : 0}"
  ReputationListsProtectionActivated    = "${var.ActivateReputationListsProtectionParam == "yes" ? 1 : 0}"
  BadBotProtectionActivated             = "${var.ActivateBadBotProtectionParam == "yes" ? 1 : 0}"
  LogParserActivated                    = "${var.ActivateScansProbesProtectionParam == "yes" ? 1 : 0}"
}
