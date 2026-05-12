output "web_public_ip" {
  value = module.compute.public_ip
}

output "web_url" {
  value = "http://${module.compute.public_ip}"
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "artifact_bucket_name" {
  value = module.global.artifact_bucket_name
}

output "app_log_group_name" {
  value = module.global.app_log_group_name
}
