
# Creating VPC here
resource "aws_vpc" "Dev_VPC" {
  cidr_block       = "192.168.0.0/16"   # Defining the CIDR block use 192.168.0.0/16 basic thing
  instance_tenancy = "default"      # Dedicated has very cost effective so used default
   enable_dns_support  = true
   enable_dns_hostnames = true
  tags = {
    Name = "Dev_VPC"
  }
}

# Creating Subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.Dev_VPC.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Dev_VPC_public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Dev_VPC.id

  tags = {
    Name = "Dev_VPC_IGW"
  }
}

resource "aws_eip" "eip" {
  vpc      = true
 }

#NAT gateway is used to enable instances within a private network to connect to the internet

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "Dev_VPC_NGT"
  }
   
}

# Route the network traffic from your subnet

  resource "aws_route_table" "Route_table1" {
  vpc_id = aws_vpc.Dev_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

   tags = {
    Name = "Dev_VPC_Route_table"
  }
}

# Associate the Public Route Table to the Public Subnet
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Route_table1.id
}
# Create Security Groups
resource "aws_security_group" "security_group" {
  name        = "security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Dev_VPC.id

  ingress {                                            # inbound rules
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.Dev_VPC.cidr_block]
  }

  egress {                                              #Outbound rules
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev_VPC_security_group"
  }
}