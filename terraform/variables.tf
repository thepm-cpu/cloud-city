variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "devops-key"
}

variable "ssh_allowed_ip" {
  description = "my laptop's public IP for SSH access (CIDR format)"
  type        = string
  default     = "102.88.111.131/32"  # Replace <your-ip> with your actual IP, e.g., "203.0.113.42/32"
}