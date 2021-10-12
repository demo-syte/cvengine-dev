# Application Load balancer on port TCP 80/443

/*resource "aws_elb" "devcvengine-elb" {
  name            = "dev-cvengine-elb"
  subnets         = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups = [aws_security_group.elb-securitygroup.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
instance_port = 80
instance_protocol = "tcp"
lb_port = 443
lb_protocol = "tcp"
}
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances                   = [aws_instance.ec2-web-1.id, aws_instance.ec2-web-2.id]
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Owner       = "Roshan"
    Environment = "dev"
    Project     = "dev-cvengine"
  }

}*/
#access_logs = {
# bucket = "elb-access-logs-bucket"
# }



# S3 bucket for ELB logs

/*data "aws_elb_service_account" "devengine" {}

resource "aws_s3_bucket" "logs" {
  bucket        = "elb-logs-${terraform.workspace}"
  acl           = "private"
  policy        = data.aws_iam_policy_document.logs.json
  force_destroy = true
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.devengine.arn]
    }

    resources = [
      "arn:aws:s3:::elb-logs-${terraform.workspace}/*",
    ]
  }
}*/


# Autoscaling

# *********************************************************
# Autoscaling in AWS
# define at least 2 resources in the begining
#
# resources:
#       - "aws_launch_configuration"
#       - "aws_autoscaling_group"
#
#
# *********************************************************


# *********************************************************
# this resource: "aws_launch_configuration"
# named  as:     "devcvengine-launchconfig"
#
# is basically something like pattern or template for a new
# instance (server). It has standard specification:
#      - AMIS (OS image)
#      - AWS_REGION
#      - t2.micro (instance_type)
#      - aws_key_pair (public/private key-pair)
#      - aws_security_group (allows ssh)
#
#
# *********************************************************

/*resource "aws_launch_configuration" "devcvengine-launchconfig" {
  name_prefix     = "web-cvengine-"
  image_id        = lookup(var.AMIS, var.REGION)
  instance_type   = var.instance_type
  key_name        = aws_key_pair.cvengine.key_name
  security_groups = [aws_security_group.cvengine-backend-sg.id]
  user_data       = file("apache-install.sh")
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "devcvengine-autoscaling" {
  name                      = "devcvengine-autoscaling"
  vpc_zone_identifier       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  launch_configuration      = aws_launch_configuration.devcvengine-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  #load_balancers            = [aws_elb.devcvengine-elb]
  force_delete              = true
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }

  depends_on = [module.elb_http]
}



# Uncomment if you want to have autoscaling notifications

#resource "aws_sns_topic" "dev-cvengine-sns" {
#  name         = "sg-sns"
#  display_name = "dev-cvengine ASG SNS topic"
#} # email subscription is currently unsupported in terraform and can be done using the AWS Web Console
#
#resource "aws_autoscaling_notification" "devcvengine-notify" {
#  group_names = ["${aws_autoscaling_group.devcvengine-autoscaling.name}"]
#  topic_arn     = "${aws_sns_topic.dev-cvengine-sns.arn}"
#  notifications  = [
#    "autoscaling:EC2_INSTANCE_LAUNCH",
#    "autoscaling:EC2_INSTANCE_TERMINATE",
#    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
#  ]
#}*/