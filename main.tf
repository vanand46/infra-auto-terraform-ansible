resource "aws_key_pair" "infra_key" {
  key_name   = "infra-key"
  public_key = file("~/.ssh/infra-key.pub")
}