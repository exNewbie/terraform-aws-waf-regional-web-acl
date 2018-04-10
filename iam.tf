## LambdaRoleLogParser ##

resource "aws_iam_role" "LambdaRoleLogParser" {
  name = "LambdaRoleLogParser"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "S3Access" {
  name = "S3Access"
  role = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${var.AccessLogBucket}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "S3AccessPut" {
  name = "S3AccessPut"
  role = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${var.AccessLogBucket}/aws-waf-security-automations-current-blocked-ips.json"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-WAFGetChangeToken" {
  name = "LambdaRoleLogParser-WAFGetChangeToken"
  role = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetChangeToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-WAFGetAndUpdateIPSet" {
  name = "LambdaRoleLogParser-WAFGetAndUpdateIPSet"
  role = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet"
            ],
            "Resource": [
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFBlacklistSet.id}",
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFScansProbesSet.id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-LogsAccess" {
  name = "LambdaRoleLogParser-LogsAccess"
  role = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup", 
                "logs:CreateLogStream", 
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-CloudWatchAccess" {
  name = "LambdaRoleLogParser-CloudWatchAccess"
  role = "${aws_iam_role.LambdaRoleLogParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:GetMetricStatistics",
            "Resource": "*"
        }
    ]
}
EOF
}

## LambdaRoleReputationListsParser ##

resource "aws_iam_role" "LambdaRoleReputationListsParser" {
  name = "LambdaRoleReputationListsParser"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "CloudWatchLogs" {
  name = "CloudWatchLogs"
  role = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleReputationListsParser-WAFGetChangeToken" {
  name = "LambdaRoleReputationListsParser-WAFGetChangeToken"
  role = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet" {
  name = "LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet"
  role = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "waf-regional:GetIPSet",
              "waf-regional:UpdateIPSet"
            ],
            "Resource": [
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFReputationListsSet1.id}",
              "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFReputationListsSet2.id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleLogParser-CloudFormationAccess" {
  name = "LambdaRoleLogParser-CloudFormationAccess"
  role = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudformation:DescribeStacks",
            "Resource": "arn:aws:cloudformation:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stack/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleReputationListsParser-CloudWatchAccess" {
  name = "LambdaRoleReputationListsParser-CloudWatchAccess"
  role = "${aws_iam_role.LambdaRoleReputationListsParser.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:GetMetricStatistics",
            "Resource": "*"
        }
    ]
}
EOF
}

## LambdaRoleBadBot ##

resource "aws_iam_role" "LambdaRoleBadBot" {
  name = "LambdaRoleBadBot"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-WAFGetChangeToken" {
  name = "LambdaRoleBadBot-WAFGetChangeToken"
  role = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-WAFGetAndUpdateIPSet" {
  name = "LambdaRoleBadBot-WAFGetAndUpdateIPSet"
  role = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet"
            ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFBadBotSet.id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-LogsAccess" {
  name = "LambdaRoleBadBot-LogsAccess"
  role = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-CloudFormationAccess" {
  name = "LambdaRoleBadBot-CloudFormationAccess"
  role = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudformation:DescribeStacks",
            "Resource": "arn:aws:cloudformation:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stack/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleBadBot-CloudWatchAccess" {
  name = "LambdaRoleBadBot-CloudWatchAccess"
  role = "${aws_iam_role.LambdaRoleBadBot.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:GetMetricStatistics",
            "Resource": "*"
        }
    ]
}
EOF
}

## LambdaRoleCustomResource ##

resource "aws_iam_role" "LambdaRoleCustomResource" {
  depends_on = ["aws_wafregional_web_acl.WAFWebACL"]

  name = "LambdaRoleCustomResource"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-S3Access" {
  name = "LambdaRoleCustomResource-S3Access"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:CreateBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketNotification",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutBucketNotification"
            ],
            "Resource": "arn:aws:s3:::${var.AccessLogBucket}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFAccess" {
  name = "LambdaRoleCustomResource-WAFAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetWebACL",
                "waf-regional:UpdateWebACL"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:webacl/${aws_wafregional_web_acl.WAFWebACL.id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFRuleAccess" {
  name = "LambdaRoleCustomResource-WAFRuleAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetRule",
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet",
                "waf-regional:UpdateWebACL"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:rule/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFIPSetAccess" {
  name = "LambdaRoleCustomResource-WAFIPSetAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetIPSet",
                "waf-regional:UpdateIPSet"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}::ipset/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFRateBasedRuleAccess" {
  name = "LambdaRoleCustomResource-WAFRateBasedRuleAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetRateBasedRule",
                "waf-regional:CreateRateBasedRule",
                "waf-regional:DeleteRateBasedRule",
                "waf-regional:ListRateBasedRules",
                "waf-regional:UpdateWebACL"
              ],
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ratebasedrule/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-CloudFormationAccess" {
  name = "LambdaRoleCustomResource-CloudFormationAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudformation:DescribeStacks",
            "Resource": "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stack/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-WAFGetChangeToken" {
  name = "LambdaRoleCustomResource-WAFGetChangeToken"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "waf-regional:GetChangeToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-LogsAccess" {
  name = "LambdaRoleCustomResource-LogsAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaRoleCustomResource-LambdaAccess" {
  name = "LambdaRoleCustomResource-LambdaAccess"
  role = "${aws_iam_role.LambdaRoleCustomResource.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "${aws_lambda_function.LambdaWAFReputationListsParserFunction.arn}"
        }
    ]
}
EOF
}

## SolutionHelperRole ##

resource "aws_iam_role" "SolutionHelperRole" {
  name = "SolutionHelperRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "SolutionHelperRole-Solution_Helper_Permissions" {
  name = "LambdaRoleCustomResource-Solution_Helper_Permissions"
  role = "${aws_iam_role.SolutionHelperRole.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup", 
              "logs:CreateLogStream", 
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}
