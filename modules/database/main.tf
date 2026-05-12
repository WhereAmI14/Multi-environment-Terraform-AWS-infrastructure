# Security group limiting MySQL access to the app security group.
resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "Allow MySQL from app security group"
  vpc_id      = var.vpc_id

  # Accept database traffic only from application instances.
  ingress {
    description     = "Allow MySQL from application security group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-db-sg"
  })
}

# Provision the MySQL RDS instance for the application.
resource "aws_db_instance" "this" {
  identifier                 = "${var.name}-mysql"
  db_name                    = var.db_name
  allocated_storage          = var.allocated_storage
  engine                     = "mysql"
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  username                   = var.db_username
  password                   = var.db_password
  parameter_group_name       = "default.mysql8.0"
  db_subnet_group_name       = var.db_subnet_group_name
  vpc_security_group_ids     = [aws_security_group.db.id]
  deletion_protection        = var.deletion_protection
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.name}-final-snapshot"
  skip_final_snapshot        = var.skip_final_snapshot
  publicly_accessible        = false
  backup_retention_period    = var.backup_retention_period
  multi_az                   = var.multi_az
  storage_encrypted          = true
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery",
  ]

  tags = merge(var.tags, {
    Name = "${var.name}-mysql"
  })
}
