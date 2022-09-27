resource "aws_efs_file_system" "efs_volume_for_foo_app" {
  creation_token = "foo_app_efs_volume"
  tags = {
    Name         = "foo-app-efs"
    "spire:name" = "foo-app-efs"
  }
}

resource "aws_efs_mount_target" "efs-mt-for-foo_app" {
  file_system_id  = aws_efs_file_system.efs_volume_for_foo_app.id
  subnet_id       = var.subnet_id
  security_groups = [var.sg_id]
}
