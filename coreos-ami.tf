data "aws_ami" "coreos_stable_latest" {
  most_recent = true

  # Name pattern: CoreOS-stable-xxxx.x.x-hvm
  filter {
    name = "name"
    values = ["CoreOS-stable-*"]
  }

  # https://www.opswat.com/blog/aws-2015-why-you-need-switch-pv-hvm
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  # Use coreOS upstream
  owners = ["595879546273"]
}