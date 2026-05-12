variable "name" {
  description = "Project/environment prefix for naming."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the application server."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string

  validation {
    condition     = contains(["t3.micro"], var.instance_type)
    error_message = "Use t3.micro to stay aligned with AWS Free Tier-eligible EC2 size."
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
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into app server."
  type        = string
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
