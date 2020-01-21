provider "aws" {
  region = "us-east-2"
  }
variable "key_name" {
  type = string
}
  resource "aws_instance" "app" {
  ami = "ami-0e55e373"
  instance_type = "t1.micro"
  key_name = "${var.key_name}"
  }
  resource "aws_instance" "db" {
  ami = "ami-0e55e373"
  instance_type = "t1.micro"
  key_name = "${var.key_name}"
  }
  resource "aws_instance" "vault" {
  ami = "ami-0e55e373"
  instance_type = "t1.micro"
  key_name = "${var.key_name}"
 }

resource "aws_security_group" "default" {
  name = "sg_staging"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
	
}
