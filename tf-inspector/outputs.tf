//
// Module: inspector
//
output "assessment_template_arn" {
  value = "${join("", aws_inspector_assessment_template.this.*.arn)}"
}

output "assessment_target_arn" {
  value = "${join("", aws_inspector_assessment_target.this.*.arn)}"
}
