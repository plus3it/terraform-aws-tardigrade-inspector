//
// Module: inspector
//
variable "create_inspector" {
  description = "Controls whether to create the Inspector resources"
  default     = false
}

variable "name" {
  description = "String to prefix resource names with"
  type        = "string"
}

variable "duration" {
  description = "Maximum time the Inspector assessment will run for (in seconds)"
  type        = "string"
  default     = "3600"
}

variable "schedule" {
  description = "Rate expression for CloudWatch event"
  type        = "string"
  default     = "rate(7 days)"
}

variable "tags" {
  description = "Map of tags to apply to the resources"
  type        = "map"
  default     = {}
}

variable "region" {
  description = "Region to deploy resources"
  type        = "string"
}
