# Secret يخزن بيانات اتصال الداتابيز بأمان (بدل ما تتكتب صريح في الكود)
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.project_name}-db-credentials"

  tags = {
    Name = "${var.project_name}-db-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

# IAM Role يسمح لـ RDS Proxy يقرأ الـ Secret
resource "aws_iam_role" "rds_proxy_role" {
  name = "${var.project_name}-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "rds_proxy_secrets_policy" {
  name = "${var.project_name}-rds-proxy-secrets-policy"
  role = aws_iam_role.rds_proxy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = aws_secretsmanager_secret.db_credentials.arn
    }]
  })
}

# RDS Proxy نفسه
resource "aws_db_proxy" "postgres_proxy" {
  name                   = "${var.project_name}-rds-proxy"
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_subnet_ids         = [var.db_subnet_a_id, var.db_subnet_b_id]
  vpc_security_group_ids = [aws_security_group.rds_proxy_sg.id]
  require_tls            = true

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.db_credentials.arn
    iam_auth    = "DISABLED"
  }

  tags = {
    Name = "${var.project_name}-rds-proxy"
  }
}

# ربط الـ Proxy بالـ RDS instance
resource "aws_db_proxy_default_target_group" "main" {
  db_proxy_name = aws_db_proxy.postgres_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "postgres_target" {
  db_instance_identifier = aws_db_instance.postgres.identifier
  db_proxy_name          = aws_db_proxy.postgres_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.main.name
}