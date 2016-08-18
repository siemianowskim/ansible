provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the open internet
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

# Give the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Public"
  }
}

# Our default security group to access
# instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_securitygroup"
  description = "Used for public instances"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 8484
    to_port     = 8484
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ansible" {
  key_name = "ansible"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDI4dD0P2trmU98wwMV/Hgnc23MmvPP+PdglBWqcrf70aPc9oO7hMWktuHOX7Um6oY/XrdjGfE4tg38eJjwPgPQ6kJP7XFJFOfTctNx1gMeOVMg/lQm4FqOkiMDha1oBwTA4YWywId/EF65j+WM/Omb+XmbkVN9lqzJV3sAfd+uVWLg9OnVMehYVzjMzJMVQ8W9vG1Gwb0CoSNuUkFT25aVcClFBwH5bDnPYJSzhqaa/TbK1zsE4EBsnGdp+HHFDnjo0FQdk0ie7K1oPWMd3cWDb2MQVSousbBWdOhHmcllLLoEkCZmVF9kx5M04yPQa/pjo/Z1wxupCSwb4NWZmouP ansible"
}

resource "aws_instance" "Web" {
  instance_type = "t2.micro"
  ami = "ami-ea26ce85"
  key_name = "${var.aws_key_name}"
  tags {
        Name = "Web"
	Type = "ec2"
    }
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"
  private_ip = "10.0.1.100"
}

resource "aws_instance" "App1" {
  instance_type = "t2.micro"
  ami = "ami-ea26ce85"
  key_name = "${var.aws_key_name}"
  tags {
        Name = "App1"
	Type = "ec2"
    }
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"
  private_ip = "10.0.1.110"
}

resource "aws_instance" "App2" {
  instance_type = "t2.micro"
  ami = "ami-ea26ce85"
  key_name = "${var.aws_key_name}"
  tags {
        Name = "App2"
	Type = "ec2"
    }
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"
  private_ip = "10.0.1.120"
}

