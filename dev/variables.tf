variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "AWS region must look like us-east-1."
  }
}

variable "project_name" {
  type        = string
  description = "Project name used for common tags and the example web page"
  default     = "terraform-aws-web-stack"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,62}$", var.project_name))
    error_message = "Project name must use lowercase letters, numbers, and hyphens."
  }
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
  default     = "web-stack-dev"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,40}$", var.name_prefix))
    error_message = "Name prefix must use lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.10.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "azs" {
  type        = list(string)
  description = "Availability zones. Leave empty to use the first two available zones in aws_region."
  default     = []

  validation {
    condition     = length(var.azs) == 0 || alltrue([for az in var.azs : can(regex("^[a-z]{2}-[a-z]+-[0-9]+[a-z]$", az))])
    error_message = "Availability zones must look like us-east-1a."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
  default     = ["10.10.1.0/24", "10.10.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2 && alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Provide at least two valid public subnet CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
  default     = ["10.10.101.0/24", "10.10.102.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2 && alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Provide at least two valid private subnet CIDR blocks."
  }
}

variable "ami_id" {
  type        = string
  description = "Optional AMI for the app server. Leave null to use the latest Amazon Linux 2023 AMI."
  default     = null

  validation {
    condition     = var.ami_id == null || can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "AMI ID must look like ami-0123456789abcdef0."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Use one of: t3.micro, t3.small, t3.medium."
  }
}

variable "key_pair_name" {
  type        = string
  description = "Existing EC2 key pair"

  validation {
    condition     = length(trimspace(var.key_pair_name)) > 0
    error_message = "Key pair name cannot be empty."
  }
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed for SSH"

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0)) && var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "SSH CIDR must be valid and cannot be open to 0.0.0.0/0."
  }
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "appdb"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,63}$", var.db_name))
    error_message = "Database name must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "db_username" {
  type        = string
  description = "DB admin username"
  default     = "appadmin"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,31}$", var.db_username))
    error_message = "Database username must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "db_password" {
  type        = string
  description = "DB admin password"
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 16
    error_message = "Database password must be at least 16 characters."
  }
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"

  validation {
    condition     = contains(["db.t3.micro", "db.t3.small", "db.t3.medium"], var.db_instance_class)
    error_message = "Use one of: db.t3.micro, db.t3.small, db.t3.medium."
  }
}

variable "db_allocated_storage" {
  type        = number
  description = "RDS storage in GB"
  default     = 20

  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 100
    error_message = "RDS storage must be between 20 and 100 GB."
  }
}

variable "db_engine_version" {
  type        = string
  description = "MySQL engine version"
  default     = "8.0"

  validation {
    condition     = can(regex("^8\\.0", var.db_engine_version))
    error_message = "Use a MySQL 8.0 engine version."
  }
}

variable "db_backup_retention_period" {
  type        = number
  description = "Number of days to retain automated RDS backups"
  default     = 7

  validation {
    condition     = var.db_backup_retention_period >= 1 && var.db_backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}

variable "db_deletion_protection" {
  type        = bool
  description = "Whether to prevent accidental RDS deletion"
  default     = false
}

variable "db_skip_final_snapshot" {
  type        = bool
  description = "Whether to skip final snapshot creation during RDS deletion"
  default     = true
}

variable "db_multi_az" {
  type        = bool
  description = "Whether to deploy RDS across multiple Availability Zones"
  default     = false
}
