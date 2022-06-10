resource "aws_instance" "VM" {
  ami           = "ami-0e81507e2b228b761"           # Choose Microsoft Windows Server 2019 with Containers Locale English AMI provided by Amazon
  instance_type = "t3.micro"
  subnet_id  = "subnet-03b8af12098b0b275"              # after run vpc then we can get it from AWS
  security_groups  = ["sg-002957ad761a65613"]           # after run vpc then we can get it from AWS
  key_name   = aws_key_pair.key.id

  tags = {
    Name = "Nexops_tf_vm"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5Dlpba9OjN34DSurkd+u+IdYn8+Vv5frFg4dXCEZ9UdqIs0UZdpN/cu89KWIL8AwjlAqBEtciX9D/V8hmTKRRC43Z4OrAZg5jVbG7SVT8Ub5In/8Ux1b8apVFT7+IOGmavzdWwXDnbAoqoMBYKHB5koeLkpSKBAOqRiBtNOTQKjb94SizwIqSqpFq0FNj1pW2rrk1aRZwzRyAwF7YHqBR15mbAyytPWwTKMtEEKr7fuf6zvQnBe41/iR7HbGR6NYJSoAQBN1za32Lb0vECVAEvnnYQtavbMCR0XNQgzpRkR4RKZY3iCjO4/y5It0JFnpEill/r4tYds3O7qP/7LHOydIsUgCgA+exlmd8R++iunVhLsbYcenSuvwb/5o06812mL9P3ODVpZetKk+PBXnDjEQ9a2XmBVaEkVTDXViR2jluc1E/1VxCz5S42VVbGOu5C73e9KImNKVLNmLTQJL0AJp5uXK9bsXvVgqy1hGvIXTXlGUxptrwtVjddlBUZUk= quinnox"
}   # This created from powershell by typing ssh-keygen


resource aws_sns_topic "notification" {
  name = "Alert-Notifications"
  display_name = "Alert Notifications"
  }

resource "aws_ses_domain_identity" "example" {
  domain = "quinnox.com"
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.example.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "example" {
  identity = aws_ses_domain_identity.example.arn
  name     = "example"
  policy   = data.aws_iam_policy_document.example.json
}

resource "aws_ses_email_identity" "example" {
  email = "gajulapallen@quinnox.com"
}
resource "aws_sns_topic_subscription" "snstoemail_email_target" {
  topic_arn = aws_sns_topic.notification.arn
  protocol  = "email"
  endpoint  = aws_ses_email_identity.example.email
}

resource "aws_cloudwatch_metric_alarm" "metric" {
  alarm_name                = "EC2 Monitoring"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [aws_sns_topic.notification.arn]
  insufficient_data_actions = []
}
