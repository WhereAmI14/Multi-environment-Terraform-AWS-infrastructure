# Security group limiting MySQL access to the app security group.
resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "Allow MySQL from app security group"
  vpc_id      = var.vpc_id

  # Accept database traffic only from application instances.
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  # Allow outbound traffic for managed DB operations.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-db-sg"
  })
}

# Provision the MySQL RDS instance for the application.
resource "aws_db_instance" "this" {
  identifier              = "${var.name}-mysql"
  db_name                 = var.db_name
  allocated_storage       = var.allocated_storage
  engine                  = "mysql"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql8.0"
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = [aws_security_group.db.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 7
  storage_encrypted       = true

  tags = merge(var.tags, {
    Name = "${var.name}-mysql"
  })
}
