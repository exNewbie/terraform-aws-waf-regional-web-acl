/* output.BadBotHoneypotEndpoint: Resource 'aws_api_gateway_rest_api.ApiGatewayBadBot' not found for variable 'aws_api_gateway_rest_api.ApiGatewayBadBot.0.id'
output "BadBotHoneypotEndpoint" {
  depends_on  = [ "aws_api_gateway_rest_api.ApiGatewayBadBot", "aws_api_gateway_stage.ApiGatewayBadBotStage" ]
  description = "Bad Bot Honeypot Endpoint"
  value       = "${local.BadBotProtectionActivated == 1 ? join("", list("https://", aws_api_gateway_rest_api.ApiGatewayBadBot.0.id, ".execute-api.", var.aws_region, ".amazonaws.com/", aws_api_gateway_stage.ApiGatewayBadBotStage.0.stage_name)) : ""}"
}
*/

output "WAFWebACL" {
  description = "AWS WAF WebACL ID"
  value       = "${aws_wafregional_web_acl.WAFWebACL.id}"
}
