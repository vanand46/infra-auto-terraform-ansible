#  Create an EC2 Instance
resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.assign_public_ip
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

  # Remote-Exec Provisioner for installing Ansible on EC2 machine
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install ansible -y",
    ]
  }
}