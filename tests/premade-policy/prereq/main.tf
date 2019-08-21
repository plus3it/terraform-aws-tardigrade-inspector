provider "aws" {
  region = "us-east-1"
}

resource "random_id" "name" {
  byte_length = 6
  prefix      = "terraform-aws-inspector-"
}

resource "aws_iam_role" "test" {
  name               = random_id.name.hex
  assume_role_policy = data.aws_iam_policy_document.assume_role_test.json
}

resource "aws_iam_policy" "test" {
  name   = random_id.name.hex
  policy = data.aws_iam_policy_document.start_inspector_test.json
}

data "aws_iam_policy_document" "assume_role_test" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "start_inspector_test" {
  statement {
    actions   = ["inspector:StartAssessmentRun"]
    resources = ["*"]
  }
}

output "random_name" {
  value = random_id.name.hex
}

output "iam_role_arn" {
  value = aws_iam_role.test.arn
}

