# Module Reference

This repository keeps reusable infrastructure in small Terraform modules. The
environment roots in `dev`, `staging`, and `production` compose these modules
with environment-specific defaults.

## `global`

Baseline resources shared by each environment.

Resources:
- CloudWatch log group
- S3 artifacts bucket
- S3 bucket encryption
- S3 bucket versioning
- S3 public access block

Inputs:
- `name` - resource name prefix
- `log_retention_days` - CloudWatch log retention period
- `tags` - common resource tags

Outputs:
- `artifact_bucket_name`
- `app_log_group_name`

## `modules/network`

Network foundation for each environment.

Resources:
- VPC
- Internet Gateway
- Public subnets
- Private subnets
- Public route table and associations
- RDS DB subnet group

Inputs:
- `name` - resource name prefix
- `vpc_cidr` - VPC CIDR block
- `azs` - Availability Zones used by subnets
- `public_subnet_cidrs` - public subnet CIDR blocks
- `private_subnet_cidrs` - private subnet CIDR blocks
- `tags` - common resource tags

Outputs:
- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `db_subnet_group_name`

## `modules/compute`

Public web tier for the example application.

Resources:
- EC2 instance
- Web security group

Inputs:
- `name` - resource name prefix
- `ami_id` - AMI ID for the EC2 instance
- `instance_type` - EC2 instance type
- `subnet_id` - public subnet for the instance
- `vpc_id` - VPC where the security group is created
- `key_name` - existing EC2 key pair
- `allowed_ssh_cidr` - administrator SSH CIDR
- `user_data` - EC2 bootstrap script
- `tags` - common resource tags

Outputs:
- `instance_id`
- `public_ip`
- `web_security_group_id`

## `modules/database`

Private database tier for the example application.

Resources:
- RDS MySQL instance
- Database security group

Inputs:
- `name` - resource name prefix
- `vpc_id` - VPC where the DB security group is created
- `db_subnet_group_name` - private DB subnet group
- `app_security_group_id` - app security group allowed to connect to MySQL
- `db_name` - application database name
- `db_username` - master database username
- `db_password` - master database password
- `instance_class` - RDS instance class
- `allocated_storage` - storage in GB
- `engine_version` - MySQL engine version
- `backup_retention_period` - automated backup retention
- `deletion_protection` - accidental deletion protection
- `skip_final_snapshot` - final snapshot behavior during deletion
- `multi_az` - Multi-AZ deployment flag
- `tags` - common resource tags

Outputs:
- `db_endpoint`
- `db_port`
