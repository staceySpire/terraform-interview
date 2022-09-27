provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      "spire:environment"         = "prod"
      "spire:publicly-accessible" = false
      "spire:access-control-cicd" = "https://ci.spire.sh/teams/foo/"
      "spire:support-channel"     = "https://general.slack.com/archives/"
      "spire:team"                = "foo"
      "spire:owner"               = "stacey.melville@spire.com"
      "spire:managed-by"          = "terraform"
      "spire:source"              = "https://github.com/nsat/terraform-interview"
      "spire:documentation"       = "https://github.com/nsat/terraform-interview"
      "spire:department-code"     = 1234
    }
  }
}

data "aws_security_group" "sg" {
  name = "bastion-security-group"
}

data "aws_subnet" "sn" {
  filter {
    name   = "tag:Name"
    values = ["ec2-server-public-subnet-1a"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = "pre-processing-bastion-key"
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.sn.id
  vpc_security_group_ids      = [data.aws_security_group.sg.id]
  associate_public_ip_address = true

  tags = {
    Name         = "bastion-server"
    "spire:name" = "bastion-server"
  }
}
