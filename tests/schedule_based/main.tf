resource "random_id" "name" {
  byte_length = 6
  prefix      = "terraform-aws-inspector-"
}

module "scheduled_run" {
  source = "../../"

  name     = random_id.name.hex
  schedule = "rate(7 days)"
  duration = "180"
}

