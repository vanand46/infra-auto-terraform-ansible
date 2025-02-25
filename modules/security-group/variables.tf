variable "security_group_name" {
  type    = string
  default = "infra-sg"
}

variable "vpc_id" {
  type = string
}

variable "ingress_from_port" {
  type    = number
  default = 22
}

variable "ingress_to_port" {
  type    = number
  default = 22
}

variable "ingress_protocol" {
  type    = string
  default = "tcp"
}

variable "ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}