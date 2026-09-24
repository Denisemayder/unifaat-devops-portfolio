# Policy 1: leitura S3 apenas em buckets technova-*
resource "aws_iam_policy" "s3_read" {
  name        = "${local.prefix}-technova-s3-read"
  description = "Leitura S3 somente em buckets technova-*"
  tags        = local.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::technova-*",
        "arn:aws:s3:::technova-*/*"
      ]
    }]
  })
}

# Policy 2: EC2 + S3 completo para engenheiros
resource "aws_iam_policy" "ec2_s3_full" {
  name        = "${local.prefix}-technova-ec2-s3-full"
  description = "EC2 e S3 para platform engineering"
  tags        = local.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:Describe*",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/Project" = "TechNova"
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = [
          "arn:aws:s3:::technova-*",
          "arn:aws:s3:::technova-*/*"
        ]
      }
    ]
  })
}

# Policy 3: Deny explicito para acoes destrutivas
resource "aws_iam_policy" "deny_destructive" {
  name        = "${local.prefix}-technova-deny-destructive"
  description = "Bloqueia acoes destrutivas para desenvolvedores"
  tags        = local.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Deny"
      Action   = [
        "s3:Delete*",
        "ec2:TerminateInstances",
        "iam:Delete*"
      ]
      Resource = "*"
    }]
  })
}

# Anexar policies aos grupos
resource "aws_iam_group_policy_attachment" "developers_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_group_policy_attachment" "developers_deny" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.deny_destructive.arn
}

resource "aws_iam_group_policy_attachment" "platform_ec2_s3" {
  group      = aws_iam_group.platform_eng.name
  policy_arn = aws_iam_policy.ec2_s3_full.arn
}
