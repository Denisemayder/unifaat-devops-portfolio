terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Tabela DynamoDB para lock do state
# (Bucket S3 criado via CLI - Academy bloqueia s3:GetBucketObjectLockConfiguration)
resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "6325028-technova-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project = "TechNova"
    Aula    = "05"
    RA      = "6325028"
  }
}

output "dynamodb_table" {
  value = aws_dynamodb_table.tfstate_lock.name
}
