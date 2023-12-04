variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default = "us-west-2"
}

variable "vpc" {
  description = "Configuration for the VPC"
  type = object({
    cidr_block = string
  })
}

variable "ami" {
  description = "AMI image configration"
  type = object({
    names = list(string)
    owners = list(string)
  })
}

variable "private_subnets" {
  description = "List of private subnet configurations"
  type = list
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type = list
}

variable "nat_subnet" {
  description = "Subnet for NAT gateway"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags associated to resources created"
  default = {
    name     = "web-server"
    project = "terraform-test"
  }
}

# Security Group rules
variable "security_group_rules" {
  description = "List of security group rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
    type        = string # 'ingress' or 'egress'
  }))
}

# ALB settings
variable "alb_settings" {
  description = "Settings for the Application Load Balancer"
  type = object({
    name     = string
    internal = bool
  })
}
