variable "address_space" {
  type        = string
  description = "Cidr range for the Virtual Network"
  default     = "10.10.0.0/16"
}

variable "vnet_name" {
  type = string
  default = "devops-network"
  description = "We are using this variable for craeting VNET"
}