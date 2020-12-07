data "aws_ami" "linux_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "description"
    values = ["Amazon Linux 2*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_key_pair" "lamp_key" {
  key_name = "lamp-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "my_lamp" {
  ami = data.aws_ami.linux_ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.lamp_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_lamp.id]
  subnet_id = aws_subnet.subnet-1.id
  tags = {
    Name = "my_lamp_server"
  }

  provisioner "remote-exec" { #install apache, mysql client, php
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start",
      "sudo systemctl enable httpd",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo yum install -y mysql php php-mysql mariadb-server",
      "sudo systemctl start mariadb",
      "sudo systemctl enable mariadb"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      password = ""
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }
  }
}

output "lamp_ip_address" {
  value = aws_instance.my_lamp.public_ip
}
