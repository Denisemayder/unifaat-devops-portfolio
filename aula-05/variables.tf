variable "aws_region" {
  default = "us-east-1"
}

variable "project" {
  default = "TechNova"
}

variable "ra" {
  default = "6325028"
}

variable "db_name" {
  default = "technova"
}

variable "db_username" {
  default   = "technovaadmin"
  sensitive = true
}

variable "db_password" {
  default   = "TechNova2024!"
  sensitive = true
}

locals {
  tags = {
    Project = var.project
    Aula    = "05"
    RA      = var.ra
    ManagedBy = "Terraform"
  }
}
