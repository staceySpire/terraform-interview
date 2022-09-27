resource "aws_vpc" "foo_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name         = "foo-app-vpc"
    "spire:name" = "foo-app-vpc"
  }
}

##### SUBNETS
resource "aws_subnet" "foo_app_efs_private" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.16.0/24"

  tags = {
    Name         = "foo-app-efs-private-subnet"
    "spire:name" = "foo-app-efs-private-subnet"
  }
}

resource "aws_subnet" "pre_processing_tasks_private" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.28.0/23"

  tags = {
    Name         = "ecs-tasks-private-subnet"
    "spire:name" = "ecs-tasks-private-subnet"
  }
}

resource "aws_subnet" "pre_processing_servers_private" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.24.0/23"

  tags = {
    Name         = "ec2-servers-private-subnet-1a"
    "spire:name" = "ec2-servers-private-subnet-1a"
  }
}

resource "aws_subnet" "pre_processing_servers_private_1b" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.26.0/23"

  tags = {
    Name         = "ec2-servers-private-subnet-1b"
    "spire:name" = "ec2-servers-private-subnet-1b"
  }
}

resource "aws_subnet" "rds_servers_1a" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.30.0/24"

  tags = {
    Name         = "rds-servers-private-subnet-1a"
    "spire:name" = "rds-servers-private-subnet-1a"
  }
}

resource "aws_subnet" "rds_servers_1b" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.31.0/24"

  tags = {
    Name         = "rds-servers-private-subnet-1b"
    "spire:name" = "rds-servers-private-subnet-1b"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.foo_app_vpc.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.48.0/26"

  tags = {
    Name         = "ec2-server-public-subnet-1a"
    "spire:name" = "ec2-server-public-subnet-1a"
  }
}

##### ROUTING
resource "aws_internet_gateway" "pre_processing_igw" {
  vpc_id = aws_vpc.foo_app_vpc.id

  tags = {
    Name         = "foo-app-vpc-igw"
    "spire:name" = "foo-app-vpc-igw"
  }
}

resource "aws_route_table" "pre_processing_rt_public" {
  vpc_id = aws_vpc.foo_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pre_processing_igw.id
  }

  tags = {
    Name         = "foo-app-vpc-public-rt"
    "spire:name" = "foo-app-vpc-public-rt"
  }
}

resource "aws_route_table_association" "pre_processing_public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.pre_processing_rt_public.id
}

resource "aws_route_table_association" "rds_servers_1a" {
  subnet_id      = aws_subnet.rds_servers_1a.id
  route_table_id = aws_route_table.pre_processing_rt_public.id
}

resource "aws_route_table_association" "rds_servers_1b" {
  subnet_id      = aws_subnet.rds_servers_1b.id
  route_table_id = aws_route_table.pre_processing_rt_public.id
}
