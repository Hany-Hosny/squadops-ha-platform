variable "project_name" {
  description = "Name used for tags and resource prefixes."
  type        = string
  default     = "squadops-ha-platform"
}

variable "aws_region" {
  description = "AWS region where the networking stack will be created."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone_a" {
  description = "First availability zone."
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Second availability zone."
  type        = string
  default     = "us-east-1b"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "app_subnet_a_cidr" {
  type    = string
  default = "10.0.11.0/24"
}

variable "app_subnet_b_cidr" {
  type    = string
  default = "10.0.12.0/24"
}

variable "db_subnet_a_cidr" {
  type    = string
  default = "10.0.21.0/24"
}

variable "db_subnet_b_cidr" {
  type    = string
  default = "10.0.22.0/24"
}
