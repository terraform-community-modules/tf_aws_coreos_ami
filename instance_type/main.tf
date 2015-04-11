variable "region" {}
variable "channel" {}
variable "instance_type" {}

module "virttype" {
    source = "github.com/terraform-community-modules/tf_aws_virttype"
    instance_type = "${var.instance_type}"
}

module "ami" {
    source = "../"
    region = "${var.region}"
    channel = "${var.channel}"
    virttype = "${module.virttype.prefer_hvm}"
}

output "ami_id" {
    value = "${module.ami.ami_id}"
}

