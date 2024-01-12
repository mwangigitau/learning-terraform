terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"
  alias   = "eu"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.eu
  }

  name = "my-vpc"
  cidr = "10.0.0.0/16"


  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



locals {
  project_name = "Hahahaha"
}
resource "aws_instance" "my_server" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = var.instance_type

  tags = {
    Name = "MyServer-${local.project_name}"
  }

}
