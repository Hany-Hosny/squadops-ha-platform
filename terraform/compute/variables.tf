variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "project_name" {
  type        = string
  default     = "squadops"
  description = "Project prefix for resource naming"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-0fc4814e13c4c4d6d"
  description = "VPC ID from Networking module"
}

variable "app_subnet_ids" {
  type        = list(string)
  default     = ["subnet-0acaaaa9b27dd86f7", "subnet-019ba432f2ffe2942"]
  description = "Private App Subnet IDs"
}

variable "app_security_group_id" {
  type        = string
  default     = "sg-00a7aa86f64e8339c"
  description = "App Security Group ID"
}
