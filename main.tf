# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Change to your desired VPC CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Create a public subnet within the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Change to your desired subnet CIDR block
  availability_zone       = "us-east-1a"   # Change to your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Create a security group allowing SSH access
resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Redirect all traffic
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance in the public subnet
resource "aws_instance" "TechnoaHI" {
  ami           = "ami-051f7e7f6c2f40dc1"  # Replace with the correct AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id  # Specify the subnet here
  key_name      = "north" 
  tags = {
    Name = "TechnoaHI"
  }
}

