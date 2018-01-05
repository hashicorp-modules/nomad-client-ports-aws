output "nomad_client_sg_id" {
  value = "${aws_security_group.nomad_client.*.id}"
}
