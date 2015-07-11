#
# AWS Launch EC2 instance
#
resource "aws_instance" "web" {
    count = 1
    instance_type = "${var.instance_type}"
    availability_zone = "${var.az}"
    ami = "${var.ami}"
    vpc_security_group_ids = ["${var.vpc_security_group_id}"]
    subnet_id = "${var.subnet}"
    associate_public_ip_address = true
    key_name = "${var.ssh_key_name}"
    monitoring = true
    tags = {
      Name = "${var.name}"
      Env = "${var.env}"
    }
    ebs_block_device = {
      device_name = "/dev/xvda"
      snapshot_id = "snap-18adf425"
    }
    #provisioner "remote-exec" {
    #  inline = [
    #    "sudo yum update"
    #  ]
    #  connection {
    #    user = "ec2-user"
    #    key_file = "${var.key_path}"
    #  }
    # }
}
