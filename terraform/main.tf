provider "aws" {
  region = "us-east-1"
  }
variable "key_name" {
  type = string
}
variable "zone_id" {
  type = string
}
  
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}
resource "tls_private_key" "privkey" {
    algorithm = "RSA" 
    rsa_bits = 4096
}
resource "aws_key_pair" "keypair" {
    key_name = "${var.key_name}"
    public_key = "${tls_private_key.privkey.public_key_openssh}"
}
output "private_key" {
  value = "${tls_private_key.privkey.private_key_pem}"
  sensitive = true
}

