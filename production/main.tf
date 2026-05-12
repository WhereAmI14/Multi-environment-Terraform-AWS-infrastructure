# Local values for shared tags and EC2 bootstrap script.
locals {
  tags = {
    Project     = var.project_name
    Environment = "production"
    ManagedBy   = "terraform"
  }

  web_user_data = <<-EOT
    #!/bin/bash
    set -euxo pipefail
    exec > /var/log/user-data.log 2>&1

    if command -v dnf >/dev/null 2>&1; then
      dnf -y update
      dnf -y install httpd
    else
      yum -y update
      yum -y install httpd
    fi

    systemctl enable --now httpd
    cat <<HTML > /var/www/html/index.html
    <html><body><h1>${var.project_name} production</h1></body></html>
    HTML
  EOT
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Apply baseline shared resources for this environment.
module "global" {
  source = "../global"

  name = var.name_prefix
  tags = local.tags
}

# Build the environment network layer.
module "network" {
  source = "../modules/network"

  name                 = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  azs                  = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.tags
}

# Deploy web compute resources.
module "compute" {
  source = "../modules/compute"

  name             = var.name_prefix
  ami_id           = coalesce(var.ami_id, data.aws_ami.amazon_linux.id)
  instance_type    = var.instance_type
  subnet_id        = module.network.public_subnet_ids[0]
  vpc_id           = module.network.vpc_id
  key_name         = var.key_pair_name
  allowed_ssh_cidr = var.allowed_ssh_cidr
  user_data        = local.web_user_data
  tags             = local.tags
}

# Deploy the application database resources.
module "database" {
  source = "../modules/database"

  name                  = var.name_prefix
  vpc_id                = module.network.vpc_id
  db_subnet_group_name  = module.network.db_subnet_group_name
  app_security_group_id = module.compute.web_security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  engine_version        = var.db_engine_version
  tags                  = local.tags
}
