resource "aws_instance" "test_instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id     = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  security_groups = ["${aws_security_group.allow_cgw_lan.id}"]
}

resource "aws_security_group" "allow_cgw_lan" {
  name        = "allow_cgw_lan"
  description = "Allow inbound traffic from the customer gateway"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.customer_gateway_lan}"]
  }
}
