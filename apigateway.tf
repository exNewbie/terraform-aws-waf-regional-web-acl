resource "aws_api_gateway_rest_api" "ApiGatewayBadBot" {
  name        = "ApiGatewayBadBot"
  description = "This endpoint will be used to capture bad bots."
}

resource "aws_api_gateway_resource" "ApiGatewayBadBotResource" {
  rest_api_id = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  parent_id   = "${aws_api_gateway_rest_api.ApiGatewayBadBot.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "ApiGatewayBadBotMethodRoot" {
  rest_api_id   = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  resource_id   = "${aws_api_gateway_rest_api.ApiGatewayBadBot.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.X-Forwarded-For" = false
  }
}

resource "aws_api_gateway_method" "ApiGatewayBadBotMethod" {
  rest_api_id   = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  resource_id   = "${aws_api_gateway_resource.ApiGatewayBadBotResource.id}"
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.X-Forwarded-For" = false
  }
}

resource "aws_api_gateway_integration" "ApiGatewayBadBotMethodRoot-Integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  resource_id             = "${aws_api_gateway_rest_api.ApiGatewayBadBot.root_resource_id}"
  http_method             = "${aws_api_gateway_method.ApiGatewayBadBotMethodRoot.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.LambdaWAFBadBotParserFunction.arn}/invocations"
}

resource "aws_api_gateway_integration" "ApiGatewayBadBotMethod-Integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  resource_id             = "${aws_api_gateway_resource.ApiGatewayBadBotResource.id}"
  http_method             = "${aws_api_gateway_method.ApiGatewayBadBotMethod.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.LambdaWAFBadBotParserFunction.arn}/invocations"
}

resource "aws_api_gateway_deployment" "ApiGatewayBadBotDeployment" {
  depends_on = ["aws_api_gateway_method.ApiGatewayBadBotMethod"]

  rest_api_id = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  description = "CloudFormation Deployment Stage"
  stage_name  = "CFDeploymentStage"
}

resource "aws_api_gateway_stage" "ApiGatewayBadBotStage" {
  depends_on    = ["aws_api_gateway_deployment.ApiGatewayBadBotDeployment"]
  description   = "Production Stage"
  stage_name    = "ProdStage"
  rest_api_id   = "${aws_api_gateway_rest_api.ApiGatewayBadBot.id}"
  deployment_id = "${aws_api_gateway_deployment.ApiGatewayBadBotDeployment.id}"
}
