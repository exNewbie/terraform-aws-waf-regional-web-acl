### Module settings ###
aws_region = "ap-southeast-2"
stack_prefix = "alb-waf"
alb_arn = [ "arn:aws:elasticloadbalancing:ap-southeast-2:68********10:loadbalancer/app/alb/e3************cd" ]

### WAF settings ###
AccessLogBucket = "alb-waf-logs"

WAFWhitelistedIPSets = [
    {
      type  = "IPV4"
      value = "123.456.789.0/32" 

    }
  ]
