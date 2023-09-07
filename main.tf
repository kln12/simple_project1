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

  # Allow SSH access from your IP address (change the CIDR block to your IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.228.221.157/32"]  # Replace with your IP address
  }
}

# Launch an EC2 instance in the public subnet
resource "aws_instance" "TechnoaHI" {
  ami           = "ami-053b0d53c279acc90"  # Replace with the Ubuntu AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id  # Specify the subnet here
  key_name      = "north"
  security_groups = [aws_security_group.ssh_sg.name]  # Attach the SSH security group
  tags = {
    Name = "TechnoaHI"
  }
}

# Output the public IP address of the EC2 instance for reference
output "public_ip" {
  value = aws_instance.TechnoaHI.public_ip
}
