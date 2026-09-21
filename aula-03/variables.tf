variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "TechNova"
}

variable "aluno" {
  description = "Nome do aluno"
  type        = string
  default     = "Denise Macedo"
}

variable "ra" {
  description = "RA do aluno"
  type        = string
  default     = "6325028"
}

locals {
  tags = {
    Project    = var.project_name
    ManagedBy  = "Terraform"
    Aluno      = var.aluno
    RA         = var.ra
    Disciplina = "DevOps - UniFAAT 2026-2"
    Aula       = "03"
  }
  prefix = var.ra
}
