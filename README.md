tf_aws_coreos_ami
=================

Starting from Terraform version 0.7 this module is redundant, because Terraform has [aws_ami](https://www.terraform.io/docs/providers/aws/d/ami.html) data-structure which allows to get ID of specific CoreOS AMI.

Here is the code:

```
variable "channel" {
  default = "stable"
}

variable "virtualization_type" {
  default = "hvm"
}

data "aws_ami" "coreos" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["${var.virtualization_type}"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-${var.channel}-*"]
  }
}

output "ami_id" {
  value = "${data.aws_ami.coreos.image_id}"
}
```

---

If you are using Terraform older than version 0.7 keep reading and using this module.

Terraform module to get the current set of publicly available [CoreOS](https://coreos.com/) [AMIs](https://coreos.com/docs/running-coreos/cloud-providers/ec2/).

This module grabs all of the AMIs listed at:

    https://coreos.com/docs/running-coreos/cloud-providers/ec2/

and then looks up the one you want given the input variables.

## Input variables

  * region - E.g. eu-central-1
  * channel - stable/alpha/beta 
  * virttype - hvm/pv

## Outputs

  * ami_id

## Example use

    module "ami" {
      source = "github.com/terraform-community-modules/tf_aws_coreos_ami"
      region = "eu-central-1"
      channel = "stable"
      virttype = "hvm"
    }

    resource "aws_instance" "core" {
      instances = 5
      ami = "${module.ami.ami_id}"
      instance_type = "m3.8xlarge"
    }

## Note

This module has bundled version of _variables.tf.json_, but if you need to update it you can run `make` in this directory to pull
that file down.

You can do this with a few lines like this in your top level Makefile:

    .terraform/modules:
            terraform get
            for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); make -C $$i; done

Consider open a pull-request with updated _variables.tf.json_.

## Getting an AMI by instance_type

Often you don't want to care if you need an hvm or pv instance.

In these cases, you can instead use:

    module "ami" {
      source = "github.com/terraform-community-modules/tf_aws_coreos_ami/instance_type"
      region = "eu-central-1"
      channel = "stable"
      instance_type = "m3.large"
    }

Note this prefers hvm instances where available.

# LICENSE

Apache2 - See the included LICENSE file for more information.

