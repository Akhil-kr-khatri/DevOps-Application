module "vpc" {
  source             = "./VPC"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "ec2" {
  source            = "./EC2-Instance"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.vpc.security_group_id
  ami_id            = "ami-0b6c6ebed2801a5cb"   # Ubuntu AMI for us-east-1
  instance_type     = "t2.micro"
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.ec2.ec2_public_dns
}