resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-app-data-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "${var.project_name}-app-data"
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}

# Block Public Access كامل
resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning (اختياري حسب المستند، هنفعله للحماية من الحذف بالغلط)
resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# IAM Policy مخصص بس للتطبيق يوصل للـ Bucket ده
resource "aws_iam_policy" "app_s3_access" {
  name        = "${var.project_name}-app-s3-access-policy"
  description = "Least-privilege access to the application S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        aws_s3_bucket.app_data.arn,
        "${aws_s3_bucket.app_data.arn}/*"
      ]
    }]
  })
}