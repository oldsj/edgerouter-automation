output "tunnel1_address" {
  value = "${aws_vpn_connection.vpn.tunnel1_address}"
}

output "tunnel1_bgp_asn" {
 value = "${aws_vpn_connection.vpn.tunnel1_bgp_asn}"
}

output "tunnel1_bgp_holdtime" {
  value = "${aws_vpn_connection.vpn.tunnel1_bgp_holdtime}"
}  

output "tunnel1_cgw_inside_address" {
  value = "${aws_vpn_connection.vpn.tunnel1_cgw_inside_address}"
}

output "tunnel1_preshared_key" {
  value = "${aws_vpn_connection.vpn.tunnel1_preshared_key}"
}  
output "tunnel1_vgw_inside_address" {
  value = "${aws_vpn_connection.vpn.tunnel1_vgw_inside_address}"
}

output "tunnel2_address" {
  value = "${aws_vpn_connection.vpn.tunnel2_address}"
}

output "tunnel2_bgp_asn" {
  value = "${aws_vpn_connection.vpn.tunnel2_bgp_asn}"
}

output "tunnel2_bgp_holdtime" {
  value = "${aws_vpn_connection.vpn.tunnel2_bgp_holdtime}"
}

output "tunnel2_cgw_inside_address" {
  value = "${aws_vpn_connection.vpn.tunnel2_cgw_inside_address}"
}

output "tunnel2_preshared_key" {
  value = "${aws_vpn_connection.vpn.tunnel2_preshared_key}"
}

output "tunnel2_vgw_inside_address" {
  value = "${aws_vpn_connection.vpn.tunnel2_vgw_inside_address}"
}