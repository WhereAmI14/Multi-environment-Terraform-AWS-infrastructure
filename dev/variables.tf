variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name used for common tags and the example web page"
  default     = "terraform-aws-web-stack"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
  default     = "web-stack-dev"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.10.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones. Leave empty to use the first two available zones in aws_region."
  default     = []
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
  default     = ["10.10.101.0/24", "10.10.102.0/24"]
}

variable "ami_id" {
  type        = string
  description = "Optional AMI for the app server. Leave null to use the latest Amazon Linux 2023 AMI."
  default     = null
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_pair_name" {
  type        = string
  description = "Existing EC2 key pair"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed for SSH"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "DB admin username"
  default     = "appadmin"
}

variable "db_password" {
  type        = string
  description = "DB admin password"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "RDS storage in GB"
  default     = 20
}

variable "db_engine_version" {
  type        = string
  description = "MySQL engine version"
  default     = "8.0"
}
