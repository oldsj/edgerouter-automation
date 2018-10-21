resource "aws_instance" "test_instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id     = "${element(data.aws_subnet_ids.private.ids, count.index)}"
}
