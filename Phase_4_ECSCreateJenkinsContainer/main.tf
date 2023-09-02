 terraform {
  required_version = ">= 1.3.7" 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = var.region
}