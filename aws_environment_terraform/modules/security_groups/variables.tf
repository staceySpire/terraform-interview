variable "vpc_id" {}

variable "bastion_ip_whitelist" {}

variable "geckoboard_ip_whitelist" {
  default = "23.23.205.140/32,50.16.244.16/32,54.204.39.96/32,54.243.225.101/32,54.243.235.136/32,54.243.235.173/32"
}
