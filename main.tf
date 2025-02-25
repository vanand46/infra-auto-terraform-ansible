locals {
  aws_region = "us-east-1"
}

provider "aws" {
  region = local.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ssh_keypair" {
  source = "./modules/ssh-keypair"
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "instance" {
  source            = "./modules/instance"
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = module.ssh_keypair.key_name
  private_key_pem   = module.ssh_keypair.private_key_pem
}

output "instance_public_ip" {
  value = module.instance.public_ip
}

resource "null_resource" "ansible_provision" {
  # Ensure this runs after instance creation
  depends_on = [module.instance]

  provisioner "local-exec" {
    command = <<EOT
echo "[infra_vm]" > inventory.ini
echo "${module.instance.public_ip}" >> inventory.ini
ansible-playbook -i inventory.ini ansible/playbook.yml
EOT
  }
}
