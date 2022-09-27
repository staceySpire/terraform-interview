data "aws_secretsmanager_secret" "bastion_ip_whitelist" {
  arn = "arn:aws:secretsmanager:eu-west-1:1234567890:secret:bastion_ip_whitelist-KBmSR5"
}

data "aws_secretsmanager_secret_version" "bastion_ip_whitelist" {
  secret_id = data.aws_secretsmanager_secret.bastion_ip_whitelist.id
}
