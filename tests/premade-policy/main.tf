provider aws {
  region = "us-east-1"
}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

module "inspector" {
  source = "../../"

  providers = {
    aws = "aws"
  }

  create_inspector = true
  name             = "${data.terraform_remote_state.prereq.random_name}"
  schedule         = "rate(7 days)"
  duration         = "180"
  iam_role_arn     = "${data.terraform_remote_state.prereq.iam_role_arn}"
}
