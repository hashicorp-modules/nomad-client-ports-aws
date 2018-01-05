resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "nomad-client-ports-aws"
  }
}

module "nomad_client_ports_aws" {
  source = "../../../nomad-client-ports-aws"
  # source = "git@github.com:hashicorp-modules/nomad-client-ports-aws?ref=f-refactor"

  vpc_id      = "${aws_vpc.main.id}"
  cidr_blocks = ["${aws_vpc.main.cidr_block}"]
}
