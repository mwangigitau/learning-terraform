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


resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["102.135.172.109/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

resource "aws_instance" "my_server" {
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = var.instance_type

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name = "MyServer-${local.project_name}"
  }
}
