resource "aws_security_group" "foo_app_ec2_sg" {
  name   = "foo_app_ec2_sg"
  vpc_id = var.vpc_id
  tags = {
    Name         = "foo-app-ec2-servers-sg"
    "spire:name" = "foo-app-ec2-servers-sg"
  }
}

resource "aws_security_group" "pre_processing_sg" {
  name   = "pre_processing_sg"
  vpc_id = var.vpc_id
  tags = {
    Name         = "foo-app-ecs-tasks-sg"
    "spire:name" = "foo-app-ecs-tasks-sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-security-group"
  vpc_id = var.vpc_id

  tags = {
    Name         = "bastion-host-sg"
    "spire:name" = "bastion-host-sg"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = split(",", var.bastion_ip_whitelist)
    description = "home users"
  }

  egress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_server_sg" {
  name   = "private-server-security-group"
  vpc_id = var.vpc_id

  tags = {
    Name         = "foo-app-ec2-servers-private-sg"
    "spire:name" = "foo-app-ec2-servers-private-sg"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// restricts traffic to and from the EFS subnet to only the foo_app_ec2 security group
resource "aws_security_group" "foo_app_efs_sg" {
  name   = "foo_app_efs_sg"
  vpc_id = var.vpc_id

  tags = {
    Name         = "foo-app-efs-sg"
    "spire:name" = "foo-app-efs-sg"
  }
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    description     = "EC2 ACCESS"
    security_groups = ["sg-c13964b1", aws_security_group.private_server_sg.id]
  }
}

resource "aws_security_group" "rds_postgres_sg" {
  name = "rds_postgres_sg"

  description = "RDS postgres servers (terraform-managed)"
  vpc_id      = var.vpc_id

  tags = {
    Name         = "rds-servers-sg"
    "spire:name" = "rds-servers-sg"
    description  = "Restricts public access to home IP's for SpWx staff, office IP's and geckoboard IPs."
  }

  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = split(",", var.bastion_ip_whitelist)
    description = "home users."
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = split(",", var.geckoboard_ip_whitelist)
    description = "Geckoboard"
  }


  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
