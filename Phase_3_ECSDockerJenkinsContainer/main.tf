 terraform {
  required_version = ">= 1.3.7" 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.49"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = var.region
}