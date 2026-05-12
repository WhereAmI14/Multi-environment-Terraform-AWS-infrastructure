# Security group for the web EC2 instance.
resource "aws_security_group" "web" {
  name        = "${var.name}-web-sg"
  description = "Allow web and SSH traffic"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP traffic to the web server.
  ingress {
    description = "Allow inbound HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access only from the configured admin CIDR.
  ingress {
    description = "Allow inbound SSH from the configured administrator CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Allow package manager access for updates and dependencies.
  egress {
    description = "Allow outbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-web-sg"
  })
}

# Deploy the application EC2 instance in a public subnet.
resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  monitoring                  = true
  user_data_replace_on_change = true
  user_data                   = var.user_data

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = merge(var.tags, {
    Name = "${var.name}-web"
  })
}
