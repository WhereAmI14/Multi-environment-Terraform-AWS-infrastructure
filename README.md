# aws-terra-3

Production-style Terraform example for deploying a small AWS web stack across
`dev`, `staging`, and `production` environments.

The project is intentionally simple enough for learning, but structured like a
real infrastructure repository: reusable modules, isolated environment roots,
remote state examples, validation tooling, linting, and security scanning.

## Architecture

```mermaid
flowchart TB
  subgraph env["Environment root: dev / staging / production"]
    global["global\nCloudWatch Logs\nS3 artifacts bucket"]
    network["modules/network\nVPC\nPublic/private subnets\nInternet Gateway\nDB subnet group"]
    compute["modules/compute\nEC2 web instance\nWeb security group"]
    database["modules/database\nRDS MySQL\nDB security group"]
  end

  global --> network
  network --> compute
  network --> database
  compute --> database
```

## What It Creates

- VPC with DNS support and public/private subnets
- Internet Gateway and public route table
- EC2 web instance running Apache
- RDS MySQL instance in private subnets
- Security groups for web and database tiers
- CloudWatch log group
- Encrypted, versioned S3 artifacts bucket with public access blocked

## Repository Layout

```text
.
|-- dev/                    # Development environment root module
|-- staging/                # Staging environment root module
|-- production/             # Production environment root module
|-- global/                 # Shared baseline resources used by each env
|-- modules/
|   |-- network/            # VPC, subnets, routing, DB subnet group
|   |-- compute/            # EC2 instance and web security group
|   `-- database/           # RDS instance and DB security group
|-- scripts/
|   `-- plan-all.sh         # Plans all environments
|-- Makefile                # Common local commands
|-- .pre-commit-config.yaml # Terraform fmt/validate/tflint/checkov hooks
`-- .tflint.hcl             # TFLint plugin config
```

## Prerequisites

- Terraform `>= 1.6`
- AWS CLI configured with credentials
- Existing EC2 key pair in the target AWS region
- S3 bucket for Terraform remote state
- DynamoDB table for Terraform state locking, or S3 native locking if you remove
  the DynamoDB setting
- Optional local quality tools:
  - `make`
  - `pre-commit`
  - `tflint`
  - `checkov`
  - `infracost`

## Quick Start

The examples below use `dev`. Repeat the same pattern for `staging` and
`production`.

1. Copy the example files:

   ```bash
   cp dev/backend.hcl.example dev/backend.hcl
   cp dev/terraform.tfvars.example dev/terraform.tfvars
   ```

2. Edit the local files:

   ```bash
   $EDITOR dev/backend.hcl
   $EDITOR dev/terraform.tfvars
   ```

3. Initialize Terraform:

   ```bash
   make init-dev
   ```

4. Review the plan:

   ```bash
   make plan-dev
   ```

5. Apply when the plan looks correct:

   ```bash
   terraform -chdir=dev apply
   ```

6. Destroy when you are finished testing:

   ```bash
   terraform -chdir=dev destroy
   ```

## Required Inputs

Each environment needs local values that should not be committed:

```hcl
key_pair_name    = "your-existing-ec2-key-pair"
allowed_ssh_cidr = "203.0.113.10/32"
db_password      = "replace-with-a-strong-password"
```

You can also override defaults such as the AWS region, VPC CIDR, AMI ID,
instance type, database class, and database storage size.

## Common Commands

```bash
make setup           # install pre-commit hooks and initialize tflint
make fmt             # format Terraform files
make fmt-check       # check formatting
make validate        # validate dev, staging, and production
make lint            # run tflint recursively
make security        # run checkov
make plan-dev        # plan dev
make plan-staging    # plan staging
make plan-production # plan production
make cost-dev        # run infracost for dev
```

## State And Secrets

Do not commit real `terraform.tfvars`, `backend.hcl`, state files, plan files, or
crash logs. The repository includes example files only:

- `*.tfvars.example`
- `backend.hcl.example`

Before making a public repository, run:

```bash
git status --ignored
git ls-files | grep -E '(^|/)(terraform.tfvars|backend.hcl|.*\.tfstate.*)$'
```

If the second command prints real secret/state files, remove them from git
history before publishing.

## Cost Notes

Defaults are kept small for learning:

- EC2: `t3.micro`
- RDS: `db.t3.micro`
- RDS storage: `20 GB`

AWS Free Tier is account-wide, not per environment. Running `dev`, `staging`,
and `production` at the same time can still create billable usage. For learning,
apply one environment at a time and destroy it when finished.

## CI/CD Ideas

A practical GitHub Actions setup for this repo would use two workflows:

1. Pull request checks:
   - `terraform fmt -check -recursive`
   - `terraform init -backend=false` and `terraform validate` per environment
   - `tflint --recursive`
   - `checkov -d . --framework terraform`
   - optional `infracost breakdown` with a PR comment

2. Deployment workflow:
   - Runs only after merge to `main`
   - Uses GitHub Environments named `dev`, `staging`, and `production`
   - Requires manual approval for `production`
   - Authenticates to AWS with OIDC instead of long-lived AWS keys
   - Runs `terraform plan` first, stores the plan as an artifact, then applies
     the reviewed plan

Avoid automatic `apply` from pull requests, especially from forks.

## Improvement Ideas

- Replace the fixed AMI ID with an `aws_ami` data source so each region can use
  the latest approved Amazon Linux image.
- Add variable validation for CIDR ranges, environment names, instance sizes,
  and database settings.
- Split production settings further from lower environments: stricter SSH
  access, deletion protection, longer backups, final snapshots, and Multi-AZ RDS.
- Add HTTPS with an Application Load Balancer and ACM certificate instead of
  exposing a single EC2 instance directly.
- Move SSH access to AWS Systems Manager Session Manager and remove public SSH.
- Add NAT Gateway or VPC endpoints if private workloads need outbound access.
- Add generated module documentation with `terraform-docs`.
- Add examples or screenshots showing the deployed web page and AWS resource
  layout.
