terraform {
  backend "s3" {
    region  = "eu-west-1"
    profile = "foo-profile"
    bucket  = "terraform-remote-state-storage-s3"

    encrypt = true

    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "devops/gnss-iono/bastion-server/terraform.tfstate"
  }
}
