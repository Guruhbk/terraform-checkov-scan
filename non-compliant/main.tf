provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bad_bucket" {
  bucket = "guru-demo-checkov-bucket"
  tags = {
    Environment = "dev"
  }
}

resource "aws_security_group" "bad_sg" {
  name        = "allow-all"
  description = "Allow everything"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


