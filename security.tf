### Master access
resource "aws_security_group" "sg_lamp" {
  name        = "allow_lamp_access"
  vpc_id      = aws_vpc.lamp-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["159.224.144.48/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
