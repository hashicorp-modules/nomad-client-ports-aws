resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = "${merge(var.tags, map("Name", format("%s", "nomad-client-ports-aws")))}"
}

module "nomad_client_ports_aws" {
  # source = "github.com/hashicorp-modules/nomad-client-ports-aws"
  source = "../../../nomad-client-ports-aws"

  vpc_id      = "${aws_vpc.main.id}"
  cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  tags        = "${var.tags}"
}
