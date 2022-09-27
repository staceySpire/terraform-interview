resource "aws_vpc_peering_connection" "foo-app-default" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.foo_app_vpc_id
  vpc_id        = var.default_vpc_id
  auto_accept   = true

  tags = {
    Name         = "foo-app-to-default-vpc-peering-connec"
    "spire:name" = "foo-app-to-default-vpc-peering-connec"
  }
}
