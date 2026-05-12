variable "name" {
  description = "Project/environment prefix for naming."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where DB SG will be created."
  type        = string
}

variable "db_subnet_group_name" {
  description = "DB subnet group name for RDS placement."
  type        = string
}

variable "app_security_group_id" {
  description = "Application security group allowed to connect to DB."
  type        = string
}

variable "db_name" {
  description = "Application database name."
  type        = string
}

variable "db_username" {
  description = "Master DB username."
  type        = string
}

variable "db_password" {
  description = "Master DB password."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 16
    error_message = "Database password must be at least 16 characters."
  }
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string

  validation {
    condition     = contains(["db.t3.micro", "db.t3.small", "db.t3.medium"], var.instance_class)
    error_message = "Use one of: db.t3.micro, db.t3.small, db.t3.medium."
  }
}

variable "allocated_storage" {
  description = "Allocated storage in GB."
  type        = number

  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 100
    error_message = "Allocated storage must be between 20 and 100 GB."
  }
}

variable "engine_version" {
  description = "MySQL engine version."
  type        = string

  validation {
    condition     = can(regex("^8\\.0", var.engine_version))
    error_message = "Use a MySQL 8.0 engine version."
  }
}

variable "backup_retention_period" {
  description = "Number of days to retain automated RDS backups."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}

variable "deletion_protection" {
  description = "Whether to prevent accidental RDS deletion."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot creation during RDS deletion."
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Whether to deploy RDS across multiple Availability Zones."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}
