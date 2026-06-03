terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Security Group
resource "aws_security_group" "gs_rest_service" {
  name        = "gs-rest-service-sg"
  description = "Security group for gs-rest-service"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 777
    to_port     = 777
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "gs_rest_service" {
  ami                    = "ami-00e801948462f718a"
  instance_type          = "t2.micro"
  key_name               = "gs-rest-service-key"
  vpc_security_group_ids = [aws_security_group.gs_rest_service.id]

  tags = {
    Name = "gs-rest-service"
  }
}

output "public_ip" {
  value = aws_instance.gs_rest_service.public_ip
}
