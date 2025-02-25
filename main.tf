provider "aws" {
  region = "us-east-1"
}

# Create a key pair resource from the generated public key.
resource "aws_key_pair" "infra_key" {
  key_name   = "infra-key"
  public_key = file("~/.ssh/infra-key.pub")
}

# Create a VPC
resource "aws_vpc" "infra_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet within the VPC
resource "aws_subnet" "infra_subnet" {
  vpc_id     = aws_vpc.infra_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create a security group allowing SSH access.
resource "aws_security_group" "infra_sg" {
  vpc_id = aws_vpc.infra_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision an EC2 instance
resource "aws_instance" "infra_vm" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.infra_key.key_name
  subnet_id       = aws_subnet.infra_subnet.id
  vpc_security_group_ids = [aws_security_group.infra_sg.id]

  tags = {
    Name = "Infra-Developer-VM"
  }

  # Use remote-exec to install Ansible on the new instance.
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install ansible -y"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/infra-key")
      host        = self.public_ip
    }
  }
}

# Output the instance public IP for inventory generation.
output "public_ip" {
  value = aws_instance.infra_vm.public_ip
}
