output "BadBotHoneypotEndpoint" {
  #https://vglt0cgixf.execute-api.ap-northeast-1.amazonaws.com/ProdStage
  "value" = "https://${ApiGatewayBadBot"
                        },
                        ".execute-api.",
                        {
                            "Ref": "AWS::Region"
                        },
                        ".amazonaws.com/",
                        {
                            "Ref": "ApiGatewayBadBotStage"
                        }
                    ]
                ]
            },
            "Condition": "BadBotProtectionActivated"
}

output "WAFWebACL" {
  "value" = "${aws_wafregional_web_acl.WAFWebACL.id}"
}
