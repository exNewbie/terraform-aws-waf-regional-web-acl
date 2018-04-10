output "BadBotHoneypotEndpoint" {
  description = "Bad Bot Honeypot Endpoint"
  value       = "https://${aws_api_gateway_rest_api.ApiGatewayBadBot.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.ApiGatewayBadBotStage.stage_name}"
}

output "WAFWebACL" {
  description = "AWS WAF WebACL ID"
  value       = "${aws_wafregional_web_acl.WAFWebACL.id}"
}
