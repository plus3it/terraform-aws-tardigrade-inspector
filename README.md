# terraform-aws-tardigrade-inspector

## Testing

Manual testing:

```
# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

For automated testing, PYTEST_ARGS is optional and no profile is needed:

```
make terraform/pytest PYTEST_ARGS="-v"
```

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.start_inspector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_inspector_rules_packages.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/inspector_rules_packages) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | String to prefix resource names with | `string` | n/a | yes |
| <a name="input_duration"></a> [duration](#input\_duration) | Maximum time the Inspector assessment will run for (in seconds) | `string` | `"3600"` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | JSON object describing an event to capture. Required if not setting a schedule. See AWS documentation for more details - https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEventsandEventPatterns.html | `string` | `null` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Controls whether to create the Inspector role | `any` | `null` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Rate expression for CloudWatch event. Required if not setting an event\_pattern | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assessment_target_arn"></a> [assessment\_target\_arn](#output\_assessment\_target\_arn) | Assessment target ARN |
| <a name="output_assessment_template_arn"></a> [assessment\_template\_arn](#output\_assessment\_template\_arn) | Assessment template ARN |

<!-- END TFDOCS -->
