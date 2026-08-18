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

output "public_subnet_a_id" {
  value       = aws_subnet.public_a.id
  description = "Public subnet A identifier."
}

output "public_subnet_b_id" {
  value       = aws_subnet.public_b.id
  description = "Public subnet B identifier."
}

output "app_subnet_ids" {
  value = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id,
  ]
  description = "Application subnet identifiers."
}

output "app_subnet_a_id" {
  value       = aws_subnet.app_a.id
  description = "Application subnet A identifier."
}

output "app_subnet_b_id" {
  value       = aws_subnet.app_b.id
  description = "Application subnet B identifier."
}

output "db_subnet_ids" {
  value = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id,
  ]
  description = "Database subnet identifiers."
}

output "db_subnet_a_id" {
  value       = aws_subnet.db_a.id
  description = "Database subnet A identifier."
}

output "db_subnet_b_id" {
  value       = aws_subnet.db_b.id
  description = "Database subnet B identifier."
}

output "nat_gateway_ids" {
  value = [
    aws_nat_gateway.nat_a.id,
    aws_nat_gateway.nat_b.id,
  ]
  description = "NAT gateway identifiers."
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "Public route table identifier."
}

output "app_route_table_a_id" {
  value       = aws_route_table.app_a.id
  description = "Application route table A identifier."
}

output "app_route_table_b_id" {
  value       = aws_route_table.app_b.id
  description = "Application route table B identifier."
}

output "db_route_table_id" {
  value       = aws_route_table.db.id
  description = "Database route table identifier."
}

output "security_group_ids" {
  value = {
    alb = aws_security_group.alb.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
  }
  description = "Security group identifiers for the main layers."
}
