# Generate an RSA Private Key
resource "tls_private_key" "infra_rsa" {
  algorithm = "RSA"
}

# Create an AWS Key Pair
resource "aws_key_pair" "infra_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.infra_rsa.public_key_openssh
}

# Store the Private Key Locally
resource "local_file" "infra_private_key" {
  content      = tls_private_key.infra_rsa.private_key_pem
  filename     = var.key_file_name
  file_permission = "0400"
}

output "key_name" {
  value = aws_key_pair.infra_rsa.key_name
}

output "private_key_pem" {
  value = tls_private_key.infra_rsa.private_key_pem
  sensitive = true
}