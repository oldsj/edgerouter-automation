variable "customer_gateway_ip" {
  type        = "string"
  description = "The customer gateway public IP"
}

variable "customer_gateway_asn" {
  type        = "string"
  description = "BGP ASN of the customer gateway"
  default     = "65000"  
}
