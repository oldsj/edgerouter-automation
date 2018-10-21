output "test_instance_ip" {
  value = "${aws_instance.test_instance.private_ip}"
}
