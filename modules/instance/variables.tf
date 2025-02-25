variable "ami_id" {
  type    = string
  default = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "private_key_pem" {
  type = string
  sensitive = true
}

variable "instance_name" {
  type    = string
  default = "Infra-Developer-VM"
}

variable "assign_public_ip" {
  type    = boolean
  default = true
}

variable "ssh_user" {
    type = string
    default = "ubuntu"
}