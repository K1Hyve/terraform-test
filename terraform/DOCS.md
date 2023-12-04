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
