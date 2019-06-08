# terraform-aws-tardigrade-inspector

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_inspector | Controls whether to create the Inspector resources | string | `"false"` | no |
| duration | Maximum time the Inspector assessment will run for (in seconds) | string | `"3600"` | no |
| iam\_role\_arn | Controls whether to create the Inspector role | string | `""` | no |
| name | String to prefix resource names with | string | n/a | yes |
| schedule | Rate expression for CloudWatch event | string | `"rate(7 days)"` | no |
| tags | Map of tags to apply to the resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| assessment\_target\_arn | Assessment target ARN |
| assessment\_template\_arn | Assessment template ARN |

