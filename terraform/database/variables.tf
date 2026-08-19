variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming resources"
  type        = string
  default     = "squadops-ha-platform"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "db_username" {
  description = "Master username for RDS PostgreSQL"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}

variable "db_password" {
  description = "Master password for RDS PostgreSQL"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID from the networking team"
  type        = string
}

variable "db_subnet_a_id" {
  description = "Database subnet A ID from the networking team"
  type        = string
}

variable "db_subnet_b_id" {
  description = "Database subnet B ID from the networking team"
  type        = string
}

variable "app_security_group_id" {
  description = "Application security group ID from the networking team"
  type        = string
}