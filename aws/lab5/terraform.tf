terraform {
  backend "s3" {
    bucket = "my-terraform-state-wnb"
    key    = "prod/aws_terraform.tfstate"
    region = "us-east-1"
  }
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "hyyercode"
  #   workspaces {
  #     name = "lab5"
  #   }
  # }
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " >= 5.6.0"
    }
  }
}