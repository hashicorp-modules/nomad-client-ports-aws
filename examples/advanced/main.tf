resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = "${var.tags}"
}

module "nomad_client_ports_aws" {
  source = "../../../nomad-client-ports-aws"
  # source = "git@github.com:hashicorp-modules/nomad-client-ports-aws?ref=f-refactor"

  count       = "${var.count}"
  name        = "${var.name}"
  vpc_id      = "${aws_vpc.main.id}"
  cidr_blocks = ["${var.cidr_blocks}"]
  tags        = "${var.tags}"
}
