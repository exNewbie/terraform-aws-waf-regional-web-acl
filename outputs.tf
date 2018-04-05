/*
output "BadBotHoneypotEndpoint" {
  #https://vglt0cgixf.execute-api.ap-northeast-1.amazonaws.com/ProdStage
  "value" = "https://${aws_api_gateway_rest_api.ApiGatewayBadBot.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.ApiGatewayBadBotStage.stage_name}"
}

output "WAFWebACL" {
  "value" = "${aws_wafregional_web_acl.WAFWebACL.id}"
}
*/
