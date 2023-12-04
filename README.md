# Terraform AWS Infrastructure Setup

This Terraform setup provisions a VPC with public and private subnets, EC2 instances within an Auto Scaling Group in private subnets, an Internet Gateway, a load balancer in a public subnet, and necessary security groups.

## Configuration Files

`terraform.tfvars` Provides values for the defined variables.

## Deployment Steps

1. **Initialize Terraform**:
   Navigate to the directory containing your Terraform files and run the following command to initialize Terraform: `terraform init`
2. **Review the Plan**:
   To see the changes Terraform will make, execute: `terraform plan`
3. **Apply the Configuration**:
   To create the resources in AWS, run: `terraform apply`

## Known issues

- Due to networking misconfiguration instances can't make egress connection to the internet. In order to have a web server the workaround has been using an AMI that required applications preinstalled.
- Home page of the web server shows Bitnami landing page and not hostname of the instance which received the request.

## To Do

- Fix egress connection
- Customize autoscaling configuration
- Improve documentation
- Enable TLS
- Add Session manager
- Add WAF

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.28.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.web_server_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.main_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.web_server_conf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.web_app_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.web_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.web_app_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.main_ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_rta](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rta](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.web_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.nat_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_settings"></a> [alb\_settings](#input\_alb\_settings) | Settings for the Application Load Balancer | <pre>object({<br>    name     = string<br>    internal = bool<br>  })</pre> | n/a | yes |
| <a name="input_ami"></a> [ami](#input\_ami) | AMI image configration | <pre>object({<br>    names = list(string)<br>    owners = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags associated to resources created | `map(string)` | <pre>{<br>  "name": "web-server",<br>  "project": "terraform-test"<br>}</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum size of the Auto Scaling Group | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum size of the Auto Scaling Group | `number` | n/a | yes |
| <a name="input_nat_subnet"></a> [nat\_subnet](#input\_nat\_subnet) | Subnet for NAT gateway | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet configurations | `list` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet configurations | `list` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy resources in | `string` | `"us-west-2"` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | List of security group rules | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    type        = string # 'ingress' or 'egress'<br>  }))</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Configuration for the VPC | <pre>object({<br>    cidr_block = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_dns_name"></a> [load\_balancer\_dns\_name](#output\_load\_balancer\_dns\_name) | The DNS name of the load balancer |