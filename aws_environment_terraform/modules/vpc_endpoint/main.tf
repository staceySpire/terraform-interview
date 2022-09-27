resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.eu-west-1.s3"
  tags = {
    Name         = "s3-vpc-endpoint"
    "spire:name" = "s3-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = var.private_rt_id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
