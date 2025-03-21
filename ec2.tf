# CS Server
resource "aws_instance" "c2-server" {
    ami                         = ""
    instance_type               = "t2.medium"
    subnet_id                   = "${aws_subnet.prod-subnet-public-1.id}"
    private_ip                  = "10.10.0.204"
    vpc_security_group_ids      = ["${aws_security_group.subnet-c2-server.id}"]
    associate_public_ip_address = true
    key_name                    = "${aws_key_pair.kp.key_name}"
    tags                        = {
                                Name = "Ubuntu C2 Server"
                                }
}

# Ubuntu Redirector
resource "aws_instance" "redirector-server" {
    ami                         = ""
    instance_type               = "t2.medium"
    subnet_id                   = "${aws_subnet.prod-subnet-public-1.id}"
    private_ip                  = "10.10.0.205"
    vpc_security_group_ids      = ["${aws_security_group.subnet-sg-redir.id}"]
    associate_public_ip_address = true
    key_name                    = "${aws_key_pair.kp.key_name}"
    tags                        = {
                                Name = "C2 Redirector Server"
                                }
}
# Create Elastic IP for the C2 redirector server EC2 instance
resource "aws_eip" "redirector-server-eip" {
    #vpc  = true
    domain = "vpc"
    tags = {
      Name = "redirector-server-eip"
    }
}
# Associate Elastic IP to Windows Server
resource "aws_eip_association" "redirector-server-eip-association" {
  instance_id   = aws_instance.redirector-server.id
  allocation_id = aws_eip.redirector-server-eip.id
}
# Windows Dev Box
resource "aws_instance" "windows-dev-box" {
    ami                         = ""
    instance_type               = "t2.large"
    subnet_id                   = "${aws_subnet.prod-subnet-public-1.id}"
    private_ip                  = "10.10.0.10"
    vpc_security_group_ids      = ["${aws_security_group.subnet-sg-dev.id}"]
    associate_public_ip_address = true
    key_name                    = "${aws_key_pair.kp.key_name}"
    tags                        = {
                                Name = "Windows Dev Box"
                              }
}

# Ubuntu Attack Box
resource "aws_instance" "attack-server" {
    ami                         = ""
    instance_type               = "t2.medium"
    subnet_id                   = "${aws_subnet.prod-subnet-public-1.id}"
    private_ip                  = "10.10.0.206"
    vpc_security_group_ids      = ["${aws_security_group.subnet-sg-dev.id}"]
    associate_public_ip_address = true
    key_name                    = "${aws_key_pair.kp.key_name}"
    tags                        = {
                                Name = "Linux Attack Server"
                                }
}

# Guacamole Server
resource "aws_instance" "guacamole-server" {
    ami                         = ""
    instance_type               = "t2.medium"
    subnet_id                   = "${aws_subnet.prod-subnet-public-1.id}"
    private_ip                  = "10.10.0.50"
    vpc_security_group_ids      = ["${aws_security_group.guacamole-server-sg-allowed.id}"]
    key_name                    = "${aws_key_pair.kp.key_name}"

    # set the randomized password
    provisioner "remote-exec" {
    # #!/bin/sh
    # sudo chmod 777 /etc/guacamole
    # sudo chmod 777 /etc/guacamole/user-mapping.xml
    # newpw=$( echo -n "297NrLYqZoZfwEvT" | md5sum | cut -d ' ' -f1 )
    # sed -i /etc/guacamole/user-mapping.xml -e "s/password=\"[^\"]*\"/password=\"$newpw\"/g"
    # sudo chmod 644 /etc/guacamole/user-mapping.xml
    # sudo chmod 755 /etc/guacamole
      inline = [
        "sudo chmod 777 /etc/guacamole",
        "sudo chmod 777 /etc/guacamole/user-mapping.xml",
        "newpw=$( echo -n \"${local.guac_pass}\" | md5sum | cut -d ' ' -f1 )",
        "sed -i /etc/guacamole/user-mapping.xml -e \"s/password=\\\"[^\\\"]*\\\"/password=\\\"$newpw\\\"/g\"",
        "sudo chmod 644 /etc/guacamole/user-mapping.xml",
        "sudo chmod 755 /etc/guacamole"
      ]
    }
    connection {
        user                  = "admin"
        host                  = "${aws_instance.guacamole-server.public_ip}"
        private_key           = "${tls_private_key.ssh-key.private_key_pem}"
    }
    tags = {
      Name = "Guacamole Server"
    }
}

# Create Elastic IP for the Guacamole Server EC2 instance
resource "aws_eip" "guacamole-server-eip" {
    #vpc  = true
    domain = "vpc"
    tags = {
      Name = "guacamole-server-eip"
    }
}
# Associate Elastic IP to Windows Server
resource "aws_eip_association" "guacamole-server-eip-association" {
  instance_id   = aws_instance.guacamole-server.id
  allocation_id = aws_eip.guacamole-server-eip.id
}