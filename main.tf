terraform {
  required_version = ">= 0.9.3"
}

resource "random_id" "name" {
  count = "${var.count}"

  byte_length = 4
  prefix      = "${var.name}-${count.index + 1}-"
}

# https://www.nomadproject.io/guides/cluster/requirements.html#ports-used
resource "aws_security_group" "nomad_client" {
  count = "${var.count}"

  name        = "${element(random_id.name.*.hex, count.index)}"
  description = "Security Group for ${var.name} Nomad"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

# The port used to run the HTTP server
# https://www.nomadproject.io/docs/agent/configuration/index.html#http-2
resource "aws_security_group_rule" "http_tcp" {
  count = "${var.count}"

  security_group_id = "${element(aws_security_group.nomad_client.*.id, count.index)}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 4646
  to_port           = 4646
  cidr_blocks       = ["${var.cidr_blocks}"]
}

# Default listen port for server to server requests within a cluster. Also
# required for cluster to cluster replication traffic. The port used for
# internal RPC communication between agents and servers, and for inter-server
# traffic for the consensus algorithm (raft)
# https://www.nomadproject.io/docs/agent/configuration/index.html#rpc-2
resource "aws_security_group_rule" "rpc_tcp" {
  count = "${var.count}"

  security_group_id = "${element(aws_security_group.nomad_client.*.id, count.index)}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 4647
  to_port           = 4647
  cidr_blocks       = ["${var.cidr_blocks}"]
}

# All outbound traffic - TCP.
resource "aws_security_group_rule" "outbound_tcp" {
  count = "${var.count}"

  security_group_id = "${element(aws_security_group.nomad_client.*.id, count.index)}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
}

# All outbound traffic - UDP.
resource "aws_security_group_rule" "outbound_udp" {
  count = "${var.count}"

  security_group_id = "${element(aws_security_group.nomad_client.*.id, count.index)}"
  type              = "egress"
  protocol          = "udp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
}
