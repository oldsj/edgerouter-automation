variable "customer_gateway_ip" {
  type        = "string"
  description = "The customer gateway public IP"
}

variable "customer_gateway_asn" {
  type        = "string"
  description = "BGP ASN of the customer gateway"
  default     = "65000"  
}

variable "customer_gateway_lan" {
  type        = "string"
  description = "The LAN CIDR behind the customer gateway"
}
