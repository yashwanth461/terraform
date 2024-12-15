resource "aws_vpc" "vpcid" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "igw" {
  tags = {
    name = "internet gateway"
  }

  vpc_id = aws_vpc.vpcid.id
}

resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.vpcid.id
  cidr_block = var.publicsubnet_cicdr
  tags = {
    name = "public"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id     = aws_vpc.vpcid.id
  cidr_block = var.privatesubnet_cicdr
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