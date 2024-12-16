
resource "aws_instance" "ec2" {
 ami=var.ami_id
 instance_type = var.instance_type
 subnet_id = var.subnet_id
 associate_public_ip_address = true
 key_name = var.key_name
 availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.security_id.id  ]
  
}

resource "aws_security_group" "security_id" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
   vpc_id = var.vpc_id

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}