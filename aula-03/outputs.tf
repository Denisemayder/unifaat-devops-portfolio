output "policy_s3_read_arn" {
  description = "ARN da policy de leitura S3"
  value       = aws_iam_policy.s3_read.arn
}

output "policy_ec2_s3_full_arn" {
  description = "ARN da policy EC2+S3 para platform engineering"
  value       = aws_iam_policy.ec2_s3_full.arn
}

output "policy_deny_destructive_arn" {
  description = "ARN da policy de deny para acoes destrutivas"
  value       = aws_iam_policy.deny_destructive.arn
}
