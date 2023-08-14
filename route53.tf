resource "aws_route53_record" "rabbitmq_dns_record" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_ID 
  name    = "rabbitmq-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"
  type    = "A"
  ttl     = 10
  records = [aws_spot_instance_request.allows_rabbitmq.private_ip]
}

  