provider "aws" {
  region = "us-east-1"
}

resource "random_id" "name" {
  byte_length = 6
  prefix      = "terraform-aws-inspector-"
}

module "event_based" {
  source = "../../"

  name          = random_id.name.hex
  event_pattern = <<-EOF
    {
      "source" : ["aws.ec2"],
      "detail-type" : ["EC2 Instance State-change Notification"],
      "detail" : {
        "state" : ["running"]
      }
    }
  EOF
  duration      = "180"
}

