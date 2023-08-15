# Creates EC2 SPOT Instance
resource "aws_spot_instance_request" "allows_rabbitmq" {
  ami                        = data.aws_ami.image.id
  subnet_id                  = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]
  instance_type              = var.RABBITMQ_INSTANCE_TYPE
  vpc_security_group_ids     = [aws_security_group.allows_rabbitmq.id]
  wait_for_fulfillment       = true

  tags = {
    Name = "roboshop-rabbitmq-${var.ENV}"
  }
}

resource "null_resource" "app_install" {
  provisioner "remote-exec" {

    # connection block establishes connection to this
    connection {
      type     = "ssh"
      user     = SSH_USERNAME
      password = SSH_PASSWORD
      host     = aws_spot_instance_request.allows_rabbitmq.private_ip             # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
    }

    inline = [
      "ansible-pull -U https://github.com/Devopsnikhil4/ansible.git  -e ENV=dev -e COMPONENT=rabbitmq  roboshop-pull.yml"
    ]
  }  
}

# resource "aws_instance" "sample" {
#   ami                     = data.aws_ami.image.id
#   instance_type           = "t3.nano"
#   vpc_security_group_ids  = [var.sg]

#   # This will be executed on the top of the machine once it's created
#   provisioner "remote-exec" {

#     # connection block establishes connection to this
#     connection {
#       type     = "ssh"
#       user     = "centos"
#       password = "DevOps321"
#       host     = self.private_ip             # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
#     }

#     inline = [
#       "ansible-pull -U https://github.com/Devopsnikhil4/ansible.git -e ENV=dev -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} roboshop-pull.yml"
#     ]
#   }
# }

# variable "sg" {}   # step 3 : Now to use this info, declare an empty varianble and user it ( in root module, we have declared " sg = var.sgid )

# output "public_ip" {
#   value   = aws_instance.sample.public_ip
# }