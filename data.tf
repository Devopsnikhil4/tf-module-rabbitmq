# Terraform Renote State Datasource : This is going to read the data from another statefile

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "b54-tf-remote-stat"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "image" {
  most_recent      = true
  name_regex       = "ansible-lab-image"     # Ensure you make your own AMI from my labImage and install ANSIBLE on the top of it and then use your AMI Name
  owners           = ["self"]
}
 