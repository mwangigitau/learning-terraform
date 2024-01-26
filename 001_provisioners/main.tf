terraform {
  required_version = ">=1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.33.0"
    }
  }

  cloud {
    organization = "mwangigitau_terraform"

    workspaces {
      name = "provisioners"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  project_name = "Hahahaha"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("./terraform.pub")
}

data "aws_vpc" "main" {
  id = "vpc-07f0dd4234abb0d23"
}



