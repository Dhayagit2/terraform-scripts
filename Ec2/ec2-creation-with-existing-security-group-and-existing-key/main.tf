provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "myami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "ec2" {
  key_name               = var.key_name
  instance_type          = var.instance_type      #eg: 't2.micro"
  ami                    = data.aws_ami.myami.id
  iam_instance_profile   = "roleforcodedeploy"
  vpc_security_group_ids = [data.aws_security_group.mysecuritygroup.id]
  tags = {
    Name = var.ec2_name
  }
}
data "aws_security_group" "mysecuritygroup" {
  id = var.sgid#copy the security group id here from the console
}
variable "ec2_name" {
    description = "name for ec2 instance"
  
}
variable "instance_type"{
   
}
variable "key_name" {
  
}
variable "sgid" {

}
output "public_ip" {
  value = aws_instance.ec2.public_ip
}
