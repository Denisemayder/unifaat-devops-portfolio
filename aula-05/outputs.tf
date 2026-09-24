output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_connection_string" {
  value     = "psql -h ${aws_db_instance.postgres.address} -U ${var.db_username} -d ${var.db_name}"
  sensitive = true
}
