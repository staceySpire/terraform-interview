provider "aws" {
  region = var.aws_region
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

module "secrets_manager_data" {
  source = "./modules/secrets_manager_data"
}

module "eu_west_1_vpc" {
  source = "./modules/eu-west-1-vpc"
}

module "vpc_peering" {
  source       = "./modules/vpc_networking_configuration"
  foo_app_vpc_id = module.eu_west_1_vpc.vpc_id
}

module "security_groups" {
  source               = "./modules/security_groups"
  vpc_id               = module.eu_west_1_vpc.vpc_id
  bastion_ip_whitelist = module.secrets_manager_data.bastion_ip_whitelist
}

module "efs_volume" {
  source    = "./modules/efs_volume"
  subnet_id = module.eu_west_1_vpc.foo_app_efs_private_id
  sg_id     = module.security_groups.foo_app_efs_sg_id
}

module "nat_gateway" {
  source                               = "./modules/nat_gateway"
  vpc_id                               = module.eu_west_1_vpc.vpc_id
  nat_sn_id                            = module.eu_west_1_vpc.public_sn_id
  pre_processing_servers_private_sn_id = module.eu_west_1_vpc.pre_processing_servers_private_sn_id
  pre_processing_tasks_private_sn_id   = module.eu_west_1_vpc.pre_processing_tasks_private_sn_id
}

module "vpc_endpoint" {
  source        = "./modules/vpc_endpoint"
  vpc_id        = module.eu_west_1_vpc.vpc_id
  private_rt_id = module.nat_gateway.private_rt_id
}

module "iam_users" {
  source = "./modules/iam"
}
