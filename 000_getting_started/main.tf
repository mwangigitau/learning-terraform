terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }

  cloud {
    organization = "mwangigitau_terraform"

    workspaces {
      name = "getting-started"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
}

provider "aws" {
  region                   = "eu-west-1"
  alias                    = "eu"
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
