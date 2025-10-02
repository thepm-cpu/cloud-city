# Data source for latest Ubuntu 22.04 AMI (owner: Canonical)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC Module (community) - Handles VPC, subnet, IGW, route table
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"  # Matches provider

  name = "cloud-city-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a"]  # Single AZ for simplicity
  public_subnets  = [var.public_subnet_cidr]
  public_subnet_tags = { Name = "cloud-city-public-subnet" }

  enable_nat_gateway = false  # No private subnets, so no NAT
  enable_vpn_gateway = false

  tags = {
    Name = "cloud-city"
  }
}

# Security Group (custom) - Fences
resource "aws_security_group" "app_sg" {
  name        = "cloud-city-sg"
  description = "Security group for app and monitoring"
  vpc_id      = module.vpc.vpc_id

  # Inbound rules
  ingress {
    description = "SSH from anywhere (demo only; use bastion in prod)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP for app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask app port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus dashboard"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter metrics"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-city-sg"
  }
}

# EC2 Instance (custom) - House
resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = true  # Public IP for access

  tags = {
    Name = "cloud-city-app"
  }
}