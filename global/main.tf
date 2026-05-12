# Central log group used by workloads in this environment.
resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.name}/app"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name}-app-logs"
  })
}

## Shared artifacts bucket for app/build outputs.
resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "${var.name}-artifacts-"

  tags = merge(var.tags, {
    Name = "${var.name}-artifacts"
  })
}

# Enforce encryption at rest for artifacts bucket objects.
resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Keep previous object versions for recovery/auditing.
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access paths on the artifacts bucket.
resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
