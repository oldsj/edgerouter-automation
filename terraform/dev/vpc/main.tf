module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.46.0"

  name = "${var.env}"

  cidr = "172.16.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["172.16.1.0/24"]

  enable_vpn_gateway = true

  tags = {
    Name        = "${var.env}"
  }
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = "${var.customer_gateway_asn}"
  ip_address = "${var.customer_gateway_ip}"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = "${module.vpc.vgw_id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
  type                = "ipsec.1"
}

resource "aws_vpn_gateway_route_propagation" "routep" {
  vpn_gateway_id = "${module.vpc.vgw_id}"
  route_table_id = "${data.aws_route_table.private.id}"
}
