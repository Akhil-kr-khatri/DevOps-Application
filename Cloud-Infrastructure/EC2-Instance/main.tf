resource "aws_instance" "devops_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  

  user_data = file("./startup.sh")

  tags = {
    Name = "DevOps-App-Server"
  }
}

output "ec2_public_ip" {
  value = aws_instance.devops_ec2.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.devops_ec2.public_dns
}
