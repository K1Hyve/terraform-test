provider "aws" {
  region = var.region
}

locals {
  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
  ec2_ami           = data.aws_ami.ubuntu.id
}


# Output for the Load Balancer
output "load_balancer_dns_name" {
  value = aws_lb.web_app_lb.dns_name
  description = "The DNS name of the load balancer"
}