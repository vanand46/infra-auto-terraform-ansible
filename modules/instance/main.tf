#  Create an EC2 Instance
resource "aws_instance" "infra_vm" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name

  tags = {
    Name = var.instance_name
  }

 # SSH Connection
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.ssh_user
    private_key = var.private_key_pem
    timeout     = "2m"
  }
}

output "public_ip" {
  value = aws_instance.infra_vm.public_ip
}