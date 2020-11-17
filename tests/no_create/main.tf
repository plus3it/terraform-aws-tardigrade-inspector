/*
provider "aws" {
  region = "us-east-1"
}
*/
module "no_create" {
  source = "../../"
/*
  providers = {
    aws = aws
  }
*/
  # create_inspector = false
  name             = "tardigrade-inspector-no-create"
}

