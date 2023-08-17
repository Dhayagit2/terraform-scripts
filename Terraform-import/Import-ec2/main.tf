provider "aws" {
    region = "ap-south-1"
}
resource "aws_instance" "<name-of-the-instance" {
}

#After pasting this run this command in the terminal terraform import aws_instance.<name-of-the-instance> <instance-id>

