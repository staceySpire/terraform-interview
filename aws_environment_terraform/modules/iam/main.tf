resource "aws_iam_user" "concourse_ecr_user" {
  name = "concourse-aws-ecr-access"

  tags = {
    Name         = "concourse-aws-ecr-access-iam-role"
    "spire:name" = "concourse-aws-ecr-access-iam-role"
    Notes        = "For use in providing AWS ECR-only access to Concourse CI pipelines "
  }
}

#resource "aws_iam_access_key" "concourse_ecr_user" {
#  user = aws_iam_user.concourse_ecr_user.name
#}

resource "aws_iam_user_policy" "concourse_ecr_user_policy" {
  name = "ECR_FULL"
  user = aws_iam_user.concourse_ecr_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:ListTagsForResource",
                "ecr:UploadLayerPart",
                "ecr:BatchDeleteImage",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:DeleteRepositoryPolicy",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetLifecyclePolicy",
                "ecr:PutLifecyclePolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:CreateRepository",
                "ecr:PutImageScanningConfiguration",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken",
                "ecr:DeleteLifecyclePolicy",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:GetRepositoryPolicy"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user" "concourse_terraform_user" {
  name = "concourse-aws-terraform-access"
  tags = {
    Name         = "concourse-terraform-iam-user"
    "spire:name" = "concourse-terraform-iam-user"
    Notes        = "For use in deploying terraform IaC to AWS via Concourse CI pipelines "
  }
}

resource "aws_iam_access_key" "concourse_terraform_user" {
  user = aws_iam_user.concourse_terraform_user.name
}

resource "aws_iam_user_policy" "concourse_terraform_user_policy" {
  name = "TERRAFORM_REQS"
  user = aws_iam_user.concourse_terraform_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "tf0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:DeleteItem"
            ],
            "Resource": "arn:aws:dynamodb:eu-west-1:1234567890:table/terraform-state-lock-dynamo"
        },
        {
            "Sid": "tf1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-remote-state-storage-s3",
                "arn:aws:s3:::terraform-remote-state-storage-s3/*"
            ]
        },
        {
            "Sid": "tf2",
            "Effect": "Allow",
            "Action": [
                "autoscaling:*",
                "batch:*",
                "cloudformation:*",
                "dynamodb:Describe*",
                "dynamodb:List*",
                "dynamodb:TagResource",
                "events:DescribeRule",
                "events:ListTagsForResource",
                "events:ListTargetsByRule",
                "ec2:CreateTags",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:Describe*",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:RunInstances",
                "ec2:InstanceMarketType",
                "ecr:*",
                "ecs:CreateCluster",
                "ecs:DescribeTaskDefinition",
                "ecs:RegisterTaskDefinition",
                "ecs:*",
                "elasticfilesystem:Create*",
                "elasticfilesystem:Describe*",
                "elasticfilesystem:List*",
                "elasticfilesystem:Tag*",
                "elasticfilesystem:Untag*",
                "elasticfilesystem:Update*",
                "events:*",
                "iam:Get*",
                "iam:List*",
                "lambda:*",
                "logs:CreateLogGroup",
                "logs:DescribeLogGroups",
                "logs:ListTagsLogGroup",
                "logs:PutRetentionPolicy",
                "logs:DeleteLogGroup",
                "rds:Add*",
                "rds:Describe*",
                "rds:List*",
                "rds:ModifyDBInstance",
                "s3:Put*",
                "s3:List*",
                "s3:Get*",
                "secretsmanager:Describe*",
                "secretsmanager:Get*",
                "sns:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "tf3",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::1234567890:role/AmazonECSTaskS3BucketRole",
                "arn:aws:iam::1234567890:role/ecsTaskExecutionRole",
                "arn:aws:iam::1234567890:role/*-eu-west-1-lambdaRole",
                "arn:aws:iam::1234567890:role/ecsEventsRole"
            ]
        },
        {
            "Sid": "tf4",
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {"aws:ResourceTag/Name": "Bastion Server"}
            }
        }
    ]
}
EOF
}


resource "aws_iam_user" "concourse_s3_user" {
  name = "concourse-aws-s3-get"
  tags = {
    Name         = "concourse-s3-iam-role"
    "spire:name" = "concourse-s3-iam-role"
    Notes        = "For use in getting data from S3 to Concourse CI pipelines "
  }
}

resource "aws_iam_user_policy" "concourse_s3_user_policy" {
  name = "S3_GET_LIST"
  user = aws_iam_user.concourse_s3_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::gnss-iono",
                "arn:aws:s3:::gnss-iono/*"
            ]
        }
    ]
}
EOF
}
