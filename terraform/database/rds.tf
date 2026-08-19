resource "aws_db_instance" "postgres" {
  identifier     = "${var.project_name}-postgres-db"
  engine         = "postgres"
  engine_version = "16.4"

  instance_class = "db.t3.small"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  backup_retention_period   = 7
  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-postgres-final-snapshot"

  tags = {
    Name        = "${var.project_name}-postgres-db"
    Environment = var.environment
  }
}