data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "technova-key-${var.ra}"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.main.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y postgresql15
  EOF

  tags = merge(local.tags, { Name = "${var.ra}-technova-ec2" })
}
