resource "aws_vpc" "vpc_id" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "my-igw" {
   tags = {
     name="internetgateway"
   }
   vpc_id = aws_vpc.vpc_id.id
}


resource "aws_subnet" "publicsubnet_cidr" {
     vpc_id = aws_vpc.vpc_id.id
      cidr_block = var.publicsubnet_cidr
  tags = {
    name="publicsubnet"
  }
 availability_zone = "ap-south-1a"
 
}


resource "aws_subnet" "privatesubnet_cidr" {

    vpc_id = aws_vpc.vpc_id.id
     cidr_block = var.privatesubnet_cidr
  tags = {
    name="privatesubnet"
  }
 availability_zone = "ap-south-1a"
  
}



resource "aws_route_table" "publicroute" {
     vpc_id = aws_vpc.vpc_id.id
     tags = {
        name="publicroute"
     }
  
}


resource "aws_route_table" "privateroute" {
    vpc_id = aws_vpc.vpc_id.id
    tags ={
        name="privateroute"
    }
  
}


resource "aws_route_table_association" "publicrouteassosciation" {
  route_table_id = aws_route_table.publicroute.id
  subnet_id = aws_subnet.publicsubnet_cidr.id
}


resource "aws_route_table_association" "privaterouteassosciation" {
  route_table_id = aws_route_table.privateroute.id
  subnet_id = aws_subnet.privatesubnet_cidr.id
}

resource "aws_route" "route" {
  route_table_id = aws_route_table.publicroute.id
  
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}

output "vpc_id" {
  value = aws_vpc.vpc_id.id
}