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

resource "aws_iam_policy" "S3Access" {
  name = "S3Access"

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

resource "aws_iam_policy" "S3AccessPut" {
  name = "S3AccessPut"

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

resource "aws_iam_policy" "LambdaRoleLogParser-WAFGetChangeToken" {
  name = "LambdaRoleLogParser-WAFGetChangeToken"

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

resource "aws_iam_policy" "LambdaRoleLogParser-WAFGetAndUpdateIPSet" {
  name = "LambdaRoleLogParser-WAFGetAndUpdateIPSet"

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

resource "aws_iam_policy" "LambdaRoleLogParser-LogsAccess" {
  name = "LambdaRoleLogParser-LogsAccess"

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

resource "aws_iam_policy" "LambdaRoleLogParser-CloudWatchAccess" {
  name = "LambdaRoleLogParser-CloudWatchAccess"

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

resource "aws_iam_role_policy_attachment" "LambdaRoleLogParser-Attach-S3Access" {
  role       = "${aws_iam_role.LambdaRoleLogParser.name}"
  policy_arn = "${aws_iam_policy.S3Access.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleLogParser-Attach-S3AccessPut" {
  role       = "${aws_iam_role.LambdaRoleLogParser.name}"
  policy_arn = "${aws_iam_policy.S3AccessPut.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleLogParser-Attach-WAFGetChangeToken" {
  role       = "${aws_iam_role.LambdaRoleLogParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleLogParser-WAFGetChangeToken.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleLogParser-Attach-WAFGetAndUpdateIPSet" {
  role       = "${aws_iam_role.LambdaRoleLogParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleLogParser-WAFGetAndUpdateIPSet.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleLogParser-Attach-LogsAccess" {
  role       = "${aws_iam_role.LambdaRoleLogParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleLogParser-LogsAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleLogParser-Attach-CloudWatchAccess" {
  role       = "${aws_iam_role.LambdaRoleLogParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleLogParser-CloudWatchAccess.arn}"
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

resource "aws_iam_policy" "CloudWatchLogs" {
  name = "CloudWatchLogs"

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

resource "aws_iam_policy" "LambdaRoleReputationListsParser-WAFGetChangeToken" {
  name = "LambdaRoleReputationListsParser-WAFGetChangeToken"

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

resource "aws_iam_policy" "LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet" {
  name = "LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet"

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

resource "aws_iam_policy" "LambdaRoleLogParser-CloudFormationAccess" {
  name = "LambdaRoleLogParser-CloudFormationAccess"

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

resource "aws_iam_policy" "LambdaRoleReputationListsParser-CloudWatchAccess" {
  name = "LambdaRoleReputationListsParser-CloudWatchAccess"

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

resource "aws_iam_role_policy_attachment" "LambdaRoleReputationListsParser-Attach-CloudWatchLogs" {
  role       = "${aws_iam_role.LambdaRoleReputationListsParser.name}"
  policy_arn = "${aws_iam_policy.CloudWatchLogs.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleReputationListsParser-Attach-WAFGetChangeToken" {
  role       = "${aws_iam_role.LambdaRoleReputationListsParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleReputationListsParser-WAFGetChangeToken.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleReputationListsParser-Attach-WAFGetAndUpdateIPSet" {
  role       = "${aws_iam_role.LambdaRoleReputationListsParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleReputationListsParser-WAFGetAndUpdateIPSet.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleReputationListsParser-Attach-CloudFormationAccess" {
  role       = "${aws_iam_role.LambdaRoleReputationListsParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleLogParser-CloudFormationAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleReputationListsParser-Attach-CloudWatchAccess" {
  role       = "${aws_iam_role.LambdaRoleReputationListsParser.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleReputationListsParser-CloudWatchAccess.arn}"
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

resource "aws_iam_policy" "LambdaRoleBadBot-WAFGetChangeToken" {
  name = "LambdaRoleBadBot-WAFGetChangeToken"

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

resource "aws_iam_policy" "LambdaRoleBadBot-WAFGetAndUpdateIPSet" {
  name = "LambdaRoleBadBot-WAFGetAndUpdateIPSet"

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

resource "aws_iam_policy" "LambdaRoleBadBot-LogsAccess" {
  name = "LambdaRoleBadBot-LogsAccess"

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

resource "aws_iam_policy" "LambdaRoleBadBot-CloudFormationAccess" {
  name = "LambdaRoleBadBot-CloudFormationAccess"

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

resource "aws_iam_policy" "LambdaRoleBadBot-CloudWatchAccess" {
  name = "LambdaRoleBadBot-CloudWatchAccess"

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

resource "aws_iam_role_policy_attachment" "LambdaRoleBadBot-Attach-WAFGetChangeToken" {
  role       = "${aws_iam_role.LambdaRoleBadBot.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleBadBot-WAFGetChangeToken.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleBadBot-Attach-WAFGetAndUpdateIPSet" {
  role       = "${aws_iam_role.LambdaRoleBadBot.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleBadBot-WAFGetAndUpdateIPSet.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleBadBot-Attach-LogsAccess" {
  role       = "${aws_iam_role.LambdaRoleBadBot.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleBadBot-LogsAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleBadBot-Attach-CloudFormationAccess" {
  role       = "${aws_iam_role.LambdaRoleBadBot.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleBadBot-CloudFormationAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "LambdaRoleBadBot-Attach-CloudWatchAccess" {
  role       = "${aws_iam_role.LambdaRoleBadBot.name}"
  policy_arn = "${aws_iam_policy.LambdaRoleBadBot-CloudWatchAccess.arn}"
}
