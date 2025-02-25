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

#
# local-exec provisioner to:
# 1. Generate Ansible inventory (inventory.ini)
# 2. Run Ansible Playbook
#

resource "null_resource" "ansible_provision" {
  depends_on = [aws_instance.infra_vm]

  provisioner "local-exec" {
    command = <<EOT
      echo "[infra_vm]" > inventory.ini
      echo "$(terraform output -raw public_ip) ansible_user=ubuntu ansible_ssh_private_key_file=infra-key.pem" >> inventory.ini

      # Now run the ansible playbook
      ansible-playbook -i inventory.ini ansible/playbook.yml
    EOT
  }
}