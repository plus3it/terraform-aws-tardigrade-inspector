# terraform-aws-tardigrade-inspector

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | String to prefix resource names with | `string` | n/a | yes |
| create\_inspector | Controls whether to create the Inspector resources | `bool` | `true` | no |
| duration | Maximum time the Inspector assessment will run for (in seconds) | `string` | `"3600"` | no |
| iam\_role\_arn | Controls whether to create the Inspector role | `any` | `null` | no |
| schedule | Rate expression for CloudWatch event | `string` | `"rate(7 days)"` | no |
| tags | Map of tags to apply to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| assessment\_target\_arn | Assessment target ARN |
| assessment\_template\_arn | Assessment template ARN |

<!-- END TFDOCS -->
