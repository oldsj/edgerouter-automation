variable "env" {
  description = "Environment Descriptor"
  default     = "dev"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_route_table" "private" {
  subnet_id = "${element(data.aws_subnet_ids.private.ids, count.index)}"
}