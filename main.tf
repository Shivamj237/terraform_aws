resource "aws_vpc" "my_vpc" {
  cidr_block = "72.25.227.0/24" 
}
resource "aws_subnet" "my_subnet" {
  vpc_id  = aws_vpc.my_vpc.id
  cidr_block = "72.25.227.0/26"  
  availability_zone = "ap-south-1a"   
}
resource "aws_internet_gateway" "my_igw"{
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_route" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}
resource "aws_route_table_association" "my_route_assc" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_route.id
}
resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
    from_port = 80
    to_port = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test" {
  ami = "ami-0dee22c13ea7a9a67"  
  instance_type = "t2.micro" 
  key_name  = "MyKeyPair" 
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  associate_public_ip_address = true
  }

