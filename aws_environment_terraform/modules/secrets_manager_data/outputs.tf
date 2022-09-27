output "bastion_ip_whitelist" {
  value = data.aws_secretsmanager_secret_version.bastion_ip_whitelist.secret_string
}
