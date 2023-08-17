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
  key_name               = var.key_name ##enter keyname. eg; "airace_1"
  instance_type          = var.instance_type ##enter instance type eg: "t2.micro"
  ami                    = data.aws_ami.myami.id
  iam_instance_profile   = "roleforcodedeploy"
  vpc_security_group_ids = [aws_security_group.allow_selected_ports.id]
  tags = {
    Name = var.ec2_name
  }
}

resource "aws_security_group" "allow_selected_ports" {
  name        = "" ##enter the security group name here
  description = "Allows inbound traffic on ports 80, 443, and 22"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "" ##enter the name here
  }
}

variable "ec2_name" {
  description = "name for ec2"
}
variable "instance_type"{
   
}
variable "key_name" {
  
}
output "public_ip" {
  value = aws_instance.ec2.public_ip
}
