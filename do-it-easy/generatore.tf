terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.14.1"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}
