resource "aws_instance" "id" {
  ami           = "ami-0614680123427b75e"
  instance_type = "t2.micro"
  key_name      = "kube"
  subnet_id     = aws_subnet.publicsubnet.id
  associate_public_ip_address = true
}

resource "aws_vpc" "vpcid" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "igw" {
  tags = {
    name = "internet gateway"
  }

  vpc_id = aws_vpc.vpcid.id
}

resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.vpcid.id
  cidr_block = "10.0.0.0/25"
  tags = {
    name = "public"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id     = aws_vpc.vpcid.id
  cidr_block = "10.0.0.128/25"
}

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.vpcid.id
  tags = {
    name = "publicroute"
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.vpcid.id
  tags = {
    name = "privateroute"
  }
}

resource "aws_route_table_association" "publicroutes" {
  route_table_id = aws_route_table.publicroute.id  # Correct reference without quotes
  subnet_id      = aws_subnet.publicsubnet.id       # Correct reference without quotes
}

resource "aws_route_table_association" "privateroutes" {
  route_table_id = aws_route_table.privateroute.id  # Correct reference without quotes
  subnet_id      = aws_subnet.privatesubnet.id      # Correct reference without quotes
}

resource "aws_route" "route" {
  route_table_id          = aws_route_table.publicroute.id  # Correct reference without quotes
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id  # Correct reference without quotes
}

resource "aws_ami_from_instance" "example" {
  name               = "terraform-example"
  source_instance_id = aws_instance.id.id  # Correct reference to the instance ID
}

resource "aws_launch_template" "template" {
  name = "launch-template"
   image_id      = aws_ami_from_instance.example.id
   instance_type = "t2.micro" 
}

resource "aws_autoscaling_group" "scailing" {
  min_size = 2
  max_size = 3
  desired_capacity = 2
   
    
    launch_template {
    id      = aws_launch_template.template.id  # Reference to the Launch Template
    version = "$Latest"  # Use the latest version of the Launch Template
  }
   vpc_zone_identifier = [ aws_subnet.publicsubnet.id ]
  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true  # Apply this tag to instances when they are launched
  }
   
}
