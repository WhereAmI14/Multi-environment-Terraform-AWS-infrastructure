variable "name" {
  description = "Project/environment prefix for naming."
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}
