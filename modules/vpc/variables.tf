variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc_name" {
  type    = string
  default = "infra-vpc"
}

variable "public_ip_on_launch" {
  type    = boolean
  default = true
}

variable "subnet_name" {
  type    = string
  default = "infra-subnet"
}

variable "internet_gateway_name" {
  type    = string
  default = "infra-gw"
}

variable "route_table_name" {
  type    = string
  default = "infra-route-table"
}