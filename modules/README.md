# Terraform Modules (aws-terra-3)

This folder contains reusable Terraform modules used by all environments (`dev`, `staging`, `production`).

## Global module (applies to every environment)

Directory: `global/`

Creates baseline resources in every environment:
- CloudWatch Log Group for app logs
- S3 artifacts bucket with:
  - server-side encryption
  - versioning
  - public access block

Every env root calls it with:

```hcl
module "global" {
  source = "../global"

  name = var.name_prefix
  tags = local.tags
}
```

## Feature modules

### 1) `modules/network`
Creates:
- VPC
- Internet Gateway
- Public and private subnets
- Public route table + associations
- DB subnet group

### 2) `modules/compute`
Creates:
- Web security group (HTTP + SSH)
- EC2 application instance

### 3) `modules/database`
Creates:
- DB security group (MySQL from app SG)
- RDS MySQL instance

## Module dependency flow

1. `global` (baseline shared services)
2. `network`
3. `compute` (depends on `network`)
4. `database` (depends on `network` + `compute`)
