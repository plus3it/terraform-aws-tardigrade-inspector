//
// Module: inspector
//
provider "aws" {
  version = ">= 2.13.0"
  region  = "${var.region}"
}

### RESOURCES ###
# Create Inspector Assessment Target
resource "aws_inspector_assessment_target" "this" {
  count = "${var.create_inspector ? 1 : 0}"
  name  = "${var.name}_assessment_target"
}

# Create Inspector Assessment Template
resource "aws_inspector_assessment_template" "this" {
  count = "${var.create_inspector ? 1 : 0}"

  name       = "${var.name}_assessment_template"
  target_arn = "${aws_inspector_assessment_target.this.arn}"
  duration   = "${var.duration}"

  rules_package_arns = [
    "${data.aws_inspector_rules_packages.this.arns}",
  ]
}

# Create Cloudwatch Event Rule
resource "aws_cloudwatch_event_rule" "this" {
  count = "${var.create_inspector ? 1 : 0}"

  name                = "${var.name}_inspector_scan"
  description         = "Run inspector scan on a schedule"
  schedule_expression = "${var.schedule}"
  tags                = "${var.tags}"
}

# Create IAM Role
resource "aws_iam_role" "this" {
  count = "${var.create_inspector ? 1 : 0}"

  name               = "${var.name}_cloudwatch_inspector_assume_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
  tags               = "${var.tags}"
}

# Create IAM Policy
resource "aws_iam_policy" "this" {
  count = "${var.create_inspector ? 1 : 0}"

  name   = "${var.name}_inspector_run_policy"
  policy = "${data.aws_iam_policy_document.start_inspector.json}"
}

# Attach Policy to IAM Role
resource "aws_iam_policy_attachment" "this" {
  count = "${var.create_inspector ? 1 : 0}"

  name       = "${var.name}_cloudwatch_inspector_policy_attachment"
  roles      = ["${aws_iam_role.this.name}"]
  policy_arn = "${aws_iam_policy.this.arn}"
}

# Create Cloudwatch Event Target
resource "aws_cloudwatch_event_target" "this" {
  count = "${var.create_inspector ? 1 : 0}"

  rule     = "${aws_cloudwatch_event_rule.this.name}"
  arn      = "${aws_inspector_assessment_template.this.arn}"
  role_arn = "${aws_iam_role.this.arn}"
}

### DATA SOURCES ###
data "aws_inspector_rules_packages" "this" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "start_inspector" {
  statement {
    actions   = ["inspector:StartAssessmentRun"]
    resources = ["*"]
  }
}
