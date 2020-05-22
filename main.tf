provider "aws" {}

locals {
  create_iam_role = var.iam_role_arn == null
  iam_role_arn    = local.create_iam_role ? join("", aws_iam_role.this.*.arn) : var.iam_role_arn
}

### RESOURCES ###

# Race condition on resource cycles requires some randomness in the name to avoid "name already exists" errors
resource "random_uuid" "assessment_template" {
  count = var.create_inspector ? 1 : 0

  keepers = {
    rules_package_arns = join(",", data.aws_inspector_rules_packages.this.arns)
    duration           = var.duration
    target_arn         = aws_inspector_assessment_target.this[0].arn

  }
}

# Create Inspector Assessment Target
resource "aws_inspector_assessment_target" "this" {
  count = var.create_inspector ? 1 : 0
  name  = var.name
}

# Create Inspector Assessment Template
resource "aws_inspector_assessment_template" "this" {
  count = var.create_inspector ? 1 : 0

  name       = "${var.name} ${random_uuid.assessment_template[0].result}"
  target_arn = random_uuid.assessment_template[0].keepers.target_arn
  duration   = random_uuid.assessment_template[0].keepers.duration

  rules_package_arns = split(",", random_uuid.assessment_template[0].keepers.rules_package_arns)
}

# Create Cloudwatch Event Rule
resource "aws_cloudwatch_event_rule" "this" {
  count = var.create_inspector ? 1 : 0

  name                = var.name
  description         = "Run inspector scan on a schedule"
  schedule_expression = var.schedule
  event_pattern       = var.event_pattern
  tags                = var.tags
}

# Create IAM Role
resource "aws_iam_role" "this" {
  count = var.create_inspector && local.create_iam_role ? 1 : 0

  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

# Create IAM Policy
resource "aws_iam_policy" "this" {
  count = var.create_inspector && local.create_iam_role ? 1 : 0

  name   = var.name
  policy = data.aws_iam_policy_document.start_inspector.json
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "this" {
  count = var.create_inspector && local.create_iam_role ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

# Create Cloudwatch Event Target
resource "aws_cloudwatch_event_target" "this" {
  count = var.create_inspector ? 1 : 0

  rule     = aws_cloudwatch_event_rule.this[0].name
  arn      = aws_inspector_assessment_template.this[0].arn
  role_arn = local.iam_role_arn
}

### DATA SOURCES ###
data "aws_inspector_rules_packages" "this" {
}

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
