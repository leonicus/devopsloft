resource "aws_instance" "app" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t1.micro"
  vpc_security_group_ids = [aws_security_group.default.id]
  key_name = "${aws_key_pair.keypair.key_name}"
   tags = {
    Name = "devopsApp"
  }
  }
  resource "aws_instance" "db" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t1.micro"
  vpc_security_group_ids = [aws_security_group.default.id]
  key_name = "${aws_key_pair.keypair.key_name}"
   tags = {
    Name = "devopsDB"
  }
  }
  