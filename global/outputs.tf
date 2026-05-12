output "artifact_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}

output "app_log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}
