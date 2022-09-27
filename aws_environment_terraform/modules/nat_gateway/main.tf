resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name         = "foo-app-vpc-nat-gw-eip"
    "spire:name" = "foo-app-vpc-nat-gw-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.nat_sn_id
  tags = {
    Name         = "foo-app-vpc-nat-gw"
    "spire:name" = "foo-app-vpc-nat-gw"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name         = "foo-app-vpc-private-rt"
    "spire:name" = "foo-app-vpc-private-rt"
  }
}

resource "aws_route_table_association" "servers_sn_private" {
  subnet_id      = var.pre_processing_servers_private_sn_id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "tasks_sn_private" {
  subnet_id      = var.pre_processing_tasks_private_sn_id
  route_table_id = aws_route_table.private_rt.id
}
