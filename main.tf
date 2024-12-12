resource "aws_instance" "id" {
   ami = "ami-0614680123427b75e"
   instance_type = "t2.micro"
   key_name = "kube.pem"  
   subnet_id = aws_subnet.publicsubnet.id
     
     
}


resource "aws_vpc" "vpcid" {
  cidr_block = "10.0.0.0/24" 
}

resource "aws_internet_gateway" "igw" {
   tags = {
     name= "internet gateway"
   }

   vpc_id = aws_vpc.vpcid.id
}

resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.vpcid.id
    cidr_block = "10.0.0.0/25"
  tags = {
     name="public"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id = aws_vpc.vpcid.id
  cidr_block = "10.0.0.128/25"
}

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.vpcid.id
  tags ={
    name="publicroute"
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.vpcid.id
  tags ={
    name="privateroutre"
  }
}

resource "aws_route_table_association" "publicroutes" {
  route_table_id = "aws_route_table.publicroute.id"
  subnet_id = "aws_subnet.publicsubnet.id"
}

resource "aws_route_table_association" "privateroutes" {
    route_table_id = "aws_route_table.privateroute.id"
    subnet_id = aws_subnet.privatesubnet.id
}

resource "aws_route" "route" {
  route_table_id = aws_route_table.publicroute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id

}




