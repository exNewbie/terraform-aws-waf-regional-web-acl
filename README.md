# tf-waf-web-acl
Stimulate the AWS WAF Web ACLs template in Terraform

Following template https://docs.aws.amazon.com/solutions/latest/aws-waf-security-automations/template.html

```python
module "app_alb_waf" {
  source = "git::https://github.com/exNewbie/terraform-aws-waf-regional-web-acl.git"

  providers = {
    "aws" = "aws.default"
  }

  # Module variables
  aws_region      = "ap-southeast-2"
  stack_prefix    = "${var.stack_prefix}"
  AccessLogBucket = "${var.AccessLogBucket}"
  alb_arn         = "${var.alb_arn}"
  WAFWhitelistedIPSets = "${var.WAFWhitelistedIPSets}"
```
