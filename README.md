# terraform-aws-tardigrade-inspector
## Overview
Creates an assessment target and assessment using terraform

## Resources Created
*  Inspector
    - Assessment Target
    - Assessment Template
* CloudWatch
    - CloudWatch Event Rule
    - CloudWatch Event Target
* IAM
    - IAM Role
    - IAM Policy
## Required Inputs

The following input variables are required:

### name

Description: String to prefix resource names with

Type: `string`

### region

Description: Region to deploy resources

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### create\_inspector

Description: Controls whether to create the Inspector resources

Type: `string`

Default: `"false"`

### duration

Description: Maximum time the Inspector assessment will run for (in seconds)

Type: `string`

Default: `"3600"`

### schedule

Description: Rate expression for CloudWatch event

Type: `string`

Default: `"rate(7 days)"`

### tags

Description: Map of tags to apply to the resources

Type: `map`

Default: `<map>`

## Outputs

The following outputs are exported:

### assessment\_target\_arn

Description: Assessment target ARN

### assessment\_template\_arn

Description: Assessment template ARN

