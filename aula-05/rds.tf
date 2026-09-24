resource "aws_db_subnet_group" "main" {
  name       = "technova-db-subnet-${var.ra}"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  tags       = merge(local.tags, { Name = "${var.ra}-db-subnet-group" })
}

resource "aws_db_instance" "postgres" {
  identifier        = "technova-db-${var.ra}"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true

  tags = merge(local.tags, { Name = "${var.ra}-technova-db" })
}
