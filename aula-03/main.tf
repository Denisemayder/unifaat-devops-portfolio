# main.tf - Estrutura IAM TechNova
# Nota: AWS Academy nao permite criar IAM Groups/Users via Terraform
# (iam:CreateGroup e iam:CreateUser bloqueados pela role voclabs)
# Os recursos abaixo sao os suportados pelo ambiente do laboratorio

# As policies e a role/instance-profile estao definidas em policies.tf e roles.tf
# Este arquivo documenta a estrutura IAM que seria criada em ambiente real:
#
# Grupos:
#   - 6325028-technova-developers   -> policies: s3-read, deny-destructive
#   - 6325028-technova-platform-eng -> policies: ec2-s3-full
#
# Usuarios:
#   - 6325028-juliana-dev      -> grupo: developers
#   - 6325028-rafael-platform  -> grupos: developers + platform-eng
#   - 6325028-lucas-intern     -> grupo: developers
#
# Role EC2:
#   - 6325028-technova-ec2-role    -> permite EC2 acessar S3
#   - 6325028-technova-ec2-profile -> instance profile para EC2
