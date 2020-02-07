resource "ansible_host" "AppHost" {
  inventory_hostname = "${aws_instance.app.public_ip}"
  groups = ["app"]
  vars  =  {
      ansible_user = "ubuntu"
      ansible_ssh_private_key_file="/terraform/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
  }
}

resource "ansible_host" "DBHost" {
  inventory_hostname = "${aws_instance.db.public_ip}"
  groups = ["db"]
  vars  =  {
      ansible_user = "ubuntu"
      ansible_ssh_private_key_file="/terraform/privkey.pem"
      ansible_python_interpreter="/usr/bin/python3"
  }
}