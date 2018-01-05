module "nomad_client_ports_aws" {
  source = "../../../nomad-client-ports-aws"
  # source = "git@github.com:hashicorp-modules/nomad-client-ports-aws?ref=f-refactor"

  count       = "0"
  vpc_id      = "1234"
  cidr_blocks = ["10.139.0.0/16"]
}
