locals {
  create_iam_role = var.iam_role_arn == null
  iam_role_arn    = local.create_iam_role ? join("", aws_iam_role.this.*.arn) : var.iam_role_arn
}

### RESOURCES ###

# Race condition on resource cycles requires some randomness in the name to avoid "name already exists" errors
resource "random_uuid" "assessment_template" {
  keepers = {
    rules_package_arns = join(",", data.aws_inspector_rules_packages.this.arns)
    duration           = var.duration
    target_arn         = aws_inspector_assessment_target.this.arn

  }
}

# Adding random string to assessment target name
resource "random_string" "random_suffix" {
  length  = 6
  special = false
}

# Create Inspector Assessment Target
resource "aws_inspector_assessment_target" "this" {
  name = "${var.name}-${random_string.random_suffix.result}"
}

# Create Inspector Assessment Template
resource "aws_inspector_assessment_template" "this" {

  name       = "${var.name} ${random_uuid.assessment_template.result}"
  target_arn = random_uuid.assessment_template.keepers.target_arn
  duration   = random_uuid.assessment_template.keepers.duration

  rules_package_arns = split(",", random_uuid.assessment_template.keepers.rules_package_arns)
}

# Create Cloudwatch Event Rule
resource "aws_cloudwatch_event_rule" "this" {

  name                = var.name
  description         = "Run inspector scan on a schedule"
  schedule_expression = var.schedule
  event_pattern       = var.event_pattern
  tags                = var.tags
}

# Create IAM Role
resource "aws_iam_role" "this" {
  count = local.create_iam_role ? 1 : 0

  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

# Create IAM Policy
resource "aws_iam_policy" "this" {
  count = local.create_iam_role ? 1 : 0

  name   = var.name
  policy = data.aws_iam_policy_document.start_inspector.json
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "this" {
  count = local.create_iam_role ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

# Create Cloudwatch Event Target
resource "aws_cloudwatch_event_target" "this" {
  rule     = aws_cloudwatch_event_rule.this.name
  arn      = aws_inspector_assessment_template.this.arn
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
