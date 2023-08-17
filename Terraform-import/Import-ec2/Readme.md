To import the existing resources which were created in the console, create a main.tf file

In the main.tf file provider and resource must be specified.

E.g:
```
provider "aws" {
    region = "<region-name>"
}
resource "aws_instance" "<instance-name>" {
}
```


replace the region-name and instance-name with the respective names which were created in the console
 
Then run this - command terraform `import aws_instance.<name-of-the-instance> <instance-id>`
               E.g: terraform import aws_instance.terraform i-0d3012f0d7a1aabe4

terraform.tfstate file will be created after executing the command in which that file has the terraform code for the resource which we created in the console


To make changes to that resource make changes in the main.tf file and apply. Don't directly make changes in the terraform.tfstate file itself 
