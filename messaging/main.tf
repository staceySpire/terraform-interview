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

resource "aws_sns_topic" "disk_usage_over_75_alarm" {
  name = "Disk_Usage_Over_75_CloudWatch_Alarms_Topic"
  tags = {
    Name         = "Disk_Usage_Over_75_CloudWatch_Alarms_Topic-sns-topic"
    "spire:name" = "Disk_Usage_Over_75_CloudWatch_Alarms_Topic-sns-topic"
  }
}

resource "aws_sns_topic" "unhandled_error" {
  name = "Unhandled_Error_Topic"
  tags = {
    Name         = "Unhandled_Error_Topic-sns-topic"
    "spire:name" = "Unhandled_Error_Topic-sns-topic"
  }
}
