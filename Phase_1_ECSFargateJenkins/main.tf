 terraform {
  required_version = ">= 1.3.7"  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.49"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  } 
}
provider "aws" {
  region     = var.region
   profile    = "default"
}