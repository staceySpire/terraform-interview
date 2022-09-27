output "vpc_id" {
  value = aws_vpc.foo_app_vpc.id
}

output "foo_app_efs_private_id" {
  value = aws_subnet.foo_app_efs_private.id
}

output "pre_processing_tasks_private_sn_id" {
  value = aws_subnet.pre_processing_tasks_private.id
}

output "pre_processing_servers_private_sn_id" {
  value = aws_subnet.pre_processing_servers_private.id
}

output "public_sn_id" {
  value = aws_subnet.public.id
}
