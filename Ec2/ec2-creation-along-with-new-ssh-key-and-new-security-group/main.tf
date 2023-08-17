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
  key_name               = "" ## enter the new key name here(copy from the below resource "aws_key_pair")
  instance_type          = "" ##enter the instance type here
  ami                    = data.aws_ami.myami.id
  iam_instance_profile   = "roleforcodedeploy"
  vpc_security_group_ids = [aws_security_group.allow_selected_ports.id]
  tags = {
    Name = var.ec2_name
  }
}

resource "aws_security_group" "allow_selected_ports" {
  name        = "" ##enter the name here
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
    Name = "" ##eneter the name here
  }
}

variable "ec2_name" {
  description = "name for ec2"
}
output "public_ip" {
  value = aws_instance.ec2.public_ip
}
resource "aws_key_pair" "TF_key" {
  key_name   = "" ##eneter the key name here
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "" ##eneter the filename here. it will be the name of the key file that'll be stores as in the pc
}
##key_name in aws_instance and filename in resource should be same to avoid confusion
variable "ec2_name" {
    description = "name for ec2 instance"
  

   
}
variable "key_name" {
  
}
