output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC identifier."
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]
  description = "Public subnet identifiers."
}

output "app_subnet_ids" {
  value = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id,
  ]
  description = "Application subnet identifiers."
}

output "db_subnet_ids" {
  value = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id,
  ]
  description = "Database subnet identifiers."
}

output "nat_gateway_ids" {
  value = [
    aws_nat_gateway.nat_a.id,
    aws_nat_gateway.nat_b.id,
  ]
  description = "NAT gateway identifiers."
}

output "security_group_ids" {
  value = {
    alb = aws_security_group.alb.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
  }
  description = "Security group identifiers for the main layers."
}

