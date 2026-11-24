# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module creates an Amazon Inspector assessment target and assessment template, and a CloudWatch Events rule that starts the assessment from a schedule, an event pattern, or both. The main inputs are `name`, `schedule`, and `event_pattern`; the module creates an IAM role that lets the rule start the assessment unless `iam_role_arn` is set. It outputs `assessment_template_arn` and `assessment_target_arn`.

### Module-specific files

- `tests/premade_policy/prereq/` - Separate Terraform configuration that creates the IAM role and name used by the `premade_policy` test; the test reads its local state
