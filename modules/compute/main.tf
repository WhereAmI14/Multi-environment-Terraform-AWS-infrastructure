# Security group for the web EC2 instance.
resource "aws_security_group" "web" {
  name        = "${var.name}-web-sg"
  description = "Allow web and SSH traffic"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP traffic to the web server.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access only from the configured admin CIDR.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Allow all outbound traffic for updates and dependencies.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
  user_data_replace_on_change = true
  user_data                   = var.user_data

  tags = merge(var.tags, {
    Name = "${var.name}-web"
  })
}
