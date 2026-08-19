output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.postgres.id
}

output "rds_endpoint" {
  description = "RDS PostgreSQL connection endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_proxy_endpoint" {
  description = "RDS Proxy connection endpoint"
  value       = aws_db_proxy.postgres_proxy.endpoint
}

output "rds_sg_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds_sg.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for application data"
  value       = aws_s3_bucket.app_data.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for application data"
  value       = aws_s3_bucket.app_data.arn
}