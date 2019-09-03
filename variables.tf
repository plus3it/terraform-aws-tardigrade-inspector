//
// Module: inspector
//
variable "create_inspector" {
  description = "Controls whether to create the Inspector resources"
  default     = true
}

variable "iam_role_arn" {
  description = "Controls whether to create the Inspector role"
  default     = null
}

variable "name" {
  description = "String to prefix resource names with"
  type        = string
}

variable "duration" {
  description = "Maximum time the Inspector assessment will run for (in seconds)"
  type        = string
  default     = "3600"
}

variable "schedule" {
  description = "Rate expression for CloudWatch event"
  type        = string
  default     = "rate(7 days)"
}

variable "tags" {
  description = "Map of tags to apply to the resources"
  type        = map(string)
  default     = {}
}
