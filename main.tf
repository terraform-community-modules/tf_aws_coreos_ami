variable "region" {}
variable "channel" {}
variable "virttype" {}
variable "all_amis" {}

output "ami_id" {
    value = "${lookup(var.all_amis, format(\"%s-%s-%s\", var.channel, var.region, var.virttype))}"
}

