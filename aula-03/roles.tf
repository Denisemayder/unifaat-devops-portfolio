# roles.tf
# Nota: AWS Academy bloqueia iam:CreateRole e iam:CreateUser/Group.
# A estrutura abaixo documenta o que seria criado em ambiente real.
#
# Role planejada para EC2 acessar S3:
#
# resource "aws_iam_role" "ec2_role" {
#   name = "6325028-technova-ec2-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect    = "Allow"
#       Principal = { Service = "ec2.amazonaws.com" }
#       Action    = "sts:AssumeRole"
#     }]
#   })
# }
#
# resource "aws_iam_role_policy" "ec2_s3_policy" {
#   name = "6325028-ec2-s3-access"
#   role = aws_iam_role.ec2_role.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect   = "Allow"
#       Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
#       Resource = ["arn:aws:s3:::technova-app-data-*", "arn:aws:s3:::technova-app-data-*/*"]
#     }]
#   })
# }
#
# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "6325028-technova-ec2-profile"
#   role = aws_iam_role.ec2_role.name
# }
