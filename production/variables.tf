variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
  default     = "terra3-prod"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.30.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
  default     = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
  default     = ["10.30.101.0/24", "10.30.102.0/24"]
}

variable "ami_id" {
  type        = string
  description = "AMI for app server"
  default     = "ami-0bae57ee7c4478e01"
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
