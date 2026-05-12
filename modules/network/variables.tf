variable "name" {
  description = "Project/environment prefix for naming."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "azs" {
  description = "Availability zones used by the environment."
  type        = list(string)

  validation {
    condition     = length(var.azs) >= max(length(var.public_subnet_cidrs), length(var.private_subnet_cidrs))
    error_message = "Provide at least as many availability zones as the largest subnet list."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2 && alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Provide at least two valid public subnet CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2 && alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Provide at least two valid private subnet CIDR blocks."
  }
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}
