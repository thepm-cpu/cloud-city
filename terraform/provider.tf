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

terraform {
  backend "s3" {}  # Empty block; populated by -backend-config in workflows
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}