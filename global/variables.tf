variable "name" {
  description = "Project/environment prefix for naming."
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs."
  type        = number
  default     = 365

  validation {
    condition     = var.log_retention_days >= 365
    error_message = "Log retention should be at least 365 days."
  }
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}
