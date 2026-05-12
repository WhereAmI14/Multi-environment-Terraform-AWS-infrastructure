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
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string

  validation {
    condition     = contains(["db.t3.micro"], var.instance_class)
    error_message = "Use db.t3.micro to stay aligned with AWS Free Tier-eligible RDS size."
  }
}

variable "allocated_storage" {
  description = "Allocated storage in GB."
  type        = number

  validation {
    condition     = var.allocated_storage == 20
    error_message = "Use 20 GB allocated storage to stay aligned with AWS Free Tier-eligible RDS storage."
  }
}

variable "engine_version" {
  description = "MySQL engine version."
  type        = string
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}
