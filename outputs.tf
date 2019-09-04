//
// Module: inspector
//
output "assessment_template_arn" {
  description = "Assessment template ARN"
  value       = join("", aws_inspector_assessment_template.this.*.arn)
}

output "assessment_target_arn" {
  description = "Assessment target ARN"
  value       = join("", aws_inspector_assessment_target.this.*.arn)
}
