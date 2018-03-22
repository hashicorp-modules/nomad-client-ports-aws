output "nomad_client_sg_id" {
  value = "${element(concat(aws_security_group.nomad_client.*.id, list("")), 0)}" # TODO: Workaround for issue #11210
}
