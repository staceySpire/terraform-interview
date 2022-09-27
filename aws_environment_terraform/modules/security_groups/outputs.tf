output "foo_app_ec2_sg_id" {
  value = aws_security_group.foo_app_ec2_sg.id
}

output "foo_app_efs_sg_id" {
  value = aws_security_group.foo_app_efs_sg.id
}

output "pre_processing_sg_id" {
  value = aws_security_group.pre_processing_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "private_server_sg_id" {
  value = aws_security_group.private_server_sg.id
}
