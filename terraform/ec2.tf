data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = var.ami.names
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.ami.owners
}

resource "aws_launch_template" "web_server_conf" {
  name_prefix   = "web-server-"
  image_id      = local.ec2_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  description = "Web server to show the hostname"

  monitoring {
    enabled = true
  }

  # User data script to install and start a web server
  user_data = filebase64("${path.module}/user_data.sh")

  tags = var.common_tags
}

resource "aws_autoscaling_group" "web_server_asg" {
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.min_size
  health_check_type       = "ELB"
  health_check_grace_period = 300
  force_delete            = true
  target_group_arns       = [aws_lb_target_group.web_app_tg.arn]
  vpc_zone_identifier     = [for i, subnet in var.private_subnets : aws_subnet.private_subnets[i].id]

  launch_template {
    id      = aws_launch_template.web_server_conf.id
    version = aws_launch_template.web_server_conf.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}

# Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = [for rule in var.security_group_rules : rule if rule.type == "ingress"]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = [for rule in var.security_group_rules : rule if rule.type == "egress"]
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }
}

# Application Load Balancer
resource "aws_lb" "web_app_lb" {
  name               = var.alb_settings.name
  internal           = var.alb_settings.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets     = [for i, subnet in var.public_subnets : aws_subnet.public_subnets[i].id]

  preserve_host_header = true

  tags = var.common_tags
}

resource "aws_lb_target_group" "web_app_tg" {
  name        = "web-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 20
    interval            = 30
  }

  tags = var.common_tags
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}