terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Stable version; pins to major for compatibility
    }
  }
}

provider "aws" {
  region = var.region
}