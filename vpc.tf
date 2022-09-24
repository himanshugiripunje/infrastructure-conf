
//////////////////////////////////////////
#VPC
/////////////////////////////
resource "aws_vpc" "this" {
  cidr_block       = var.cidr_block.vpc
  instance_tenancy = "default"
}
///////////////////////////////////////////////////
#private
//////////////////////////////////////////////////////

resource "aws_subnet" "private1" {
  cidr_block = var.cidr_block.private1
  vpc_id     = aws_vpc.this.id
}
resource "aws_subnet" "private2" {
  cidr_block = var.cidr_block.private2
  vpc_id     = aws_vpc.this.id
}
/////////////////////////////////////////////////////////
#public-subnet
////////////////////////////////////////////
resource "aws_subnet" "public1" {
  cidr_block              = var.cidr_block.public1
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.this.id
}
resource "aws_subnet" "public2" {
  cidr_block              = var.cidr_block.public2
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.this.id
}
/////////////////////////////////////////////////////
#IGW
////////////////////////////////////////////////////
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}
//////////////////////////////////////////////////////
#igw
/////////////////////////////////////////////////////



resource "aws_route_table" "grt" {

  vpc_id = "${aws_vpc.this.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

///////////////////////////////////////////////
##igw - route association to public1 subnet
///////////////////////////////////////////

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.grt.id
}
//////////////////////////////////////////////////////////
#EIP
/////////////////////////////////////////////////////
resource "aws_eip" "eip" {
  vpc = true
}

# /////////////////////////////////////////////////////
# #                         nat
# //////////////////////////////////////


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id
}
/////////////////////////////////////////////////
output "nat_gateway_ip" {
  value = aws_eip.eip.address
}



//////////////////////////////////////////////////

/////////////////////////////////////////
                        #nat
//////////////////////////////////////
resource "aws_route_table" "nrt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  } 
}
/////////////////////////////////////////////////////////////
//nat association//
//////////////////////////////////////////////////////
resource "aws_route_table_association" "ab" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.nrt.id
}

///////////////////////////////////
            #security-group
///////////////////////////////////////
resource "aws_security_group" "sg1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.this.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

/////////////////////////////////

        #instance
///////////////////////////////////////
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "public" {
  instance_type = "t2.micro"  
  ami = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.public1.id
  security_groups = [aws_security_group.sg1.id]
  key_name = "public"
}
resource "aws_instance" "private" {
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.private1.id
  security_groups = [aws_security_group.sg1.id]
  key_name = "public"
}

