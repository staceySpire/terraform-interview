provider "aws" {
  profile             = "aws-profile"
  allowed_account_ids = ["12344567890"]
  region              = var.aws_region
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

resource "aws_s3_bucket" "terraform_state_bucket" {
  # Note: because S3 bucket names are global, we can't use the same one as the
  # general Spire state bucket.
  bucket = "terraform-remote-state-storage-s3"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  # How do these tags work with the default_tags?
  tags = {
    Name         = "terraform-state"
    "spire:name" = "terraform-state"
    Unit         = "space-weather"
    Role         = "terraform"
    Creator      = "terraform"
    Notes        = "S3 bucket to store Terraform state"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Unit         = "foo"
    Role         = "terraform"
    Creator      = "terraform"
    Notes        = "S3 bucket to store Terraform state"
    Name         = "terraform-state-lock"
    "spire:name" = "terraform-state-lock"
  }
}
