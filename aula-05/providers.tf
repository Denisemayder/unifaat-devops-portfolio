terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote State configurado para S3 + DynamoDB
  # Nota: AWS Academy bloqueia s3:GetBucketObjectLockConfiguration e s3:PutBucketVersioning
  # via SCP da organizacao. O backend esta documentado abaixo como referencia.
  # Em ambiente real (AWS pessoal ou producao), descomentar o bloco abaixo:
  #
  # backend "s3" {
  #   bucket       = "6325028-technova-tfstate"
  #   key          = "aula-05/terraform.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.aws_region
}
