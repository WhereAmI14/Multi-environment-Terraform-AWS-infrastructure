variable "name" {
  description = "Project/environment prefix for naming."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the application server."
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "AMI ID must look like ami-0123456789abcdef0."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Use one of: t3.micro, t3.small, t3.medium."
  }
}

variable "subnet_id" {
  description = "Public subnet ID for the instance."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where SG will be created."
  type        = string
}

variable "key_name" {
  description = "AWS EC2 key pair name."
  type        = string

  validation {
    condition     = length(trimspace(var.key_name)) > 0
    error_message = "Key pair name cannot be empty."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into app server."
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0)) && var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "SSH CIDR must be valid and cannot be open to 0.0.0.0/0."
  }
}

variable "user_data" {
  description = "User data script for EC2 bootstrap."
  type        = string
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}
