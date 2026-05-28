provider "aws" {
  region = "us-east-1"
}

########################################
# KMS Key for S3 Encryption
########################################

resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

########################################
# S3 Bucket
########################################

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "guru-demo-checkov-secure-bucket-12345"

  tags = {
    Environment = "dev"
    Owner       = "guru"
    Project     = "checkov-demo"
  }
}

########################################
# S3 Versioning
########################################

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

########################################
# S3 Encryption (KMS)
########################################

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

########################################
# S3 Public Access Block
########################################

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################################
# Security Group
########################################

resource "aws_security_group" "secure_sg" {
  name        = "secure-sg"
  description = "Restricted security group"

  ingress {
    description = "Allow SSH only from internal network"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow HTTPS outbound"

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
    Owner       = "guru"
    Project     = "checkov-demo"
  }
}
