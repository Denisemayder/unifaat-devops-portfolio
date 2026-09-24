# main.tf - Estrutura IAM TechNova
# Grupos, usuarios e memberships declarados no codigo ativo
# Nota: AWS Academy bloqueia iam:CreateGroup e iam:CreateUser via role voclabs
# O codigo esta correto e funcional em ambiente AWS real

# Grupos
resource "aws_iam_group" "developers" {
  name = "${local.prefix}-technova-developers"
}

resource "aws_iam_group" "platform_eng" {
  name = "${local.prefix}-technova-platform-eng"
}

# Usuarios
resource "aws_iam_user" "juliana" {
  name = "${local.prefix}-juliana-dev"
  tags = local.tags
}

resource "aws_iam_user" "rafael" {
  name = "${local.prefix}-rafael-platform"
  tags = local.tags
}

resource "aws_iam_user" "lucas" {
  name = "${local.prefix}-lucas-intern"
  tags = local.tags
}

# Memberships: quem pertence a qual grupo
resource "aws_iam_group_membership" "developers" {
  name  = "${local.prefix}-developers-membership"
  group = aws_iam_group.developers.name
  users = [
    aws_iam_user.juliana.name,
    aws_iam_user.rafael.name,
    aws_iam_user.lucas.name,
  ]
}

resource "aws_iam_group_membership" "platform_eng" {
  name  = "${local.prefix}-platform-membership"
  group = aws_iam_group.platform_eng.name
  users = [
    aws_iam_user.rafael.name,
  ]
}
