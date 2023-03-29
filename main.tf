resource "aws_vpc" "TSYS-VPC" {
  cidr_block       = var.aws_vpc-TSYS-VPC
  instance_tenancy = "default"

  tags = {
    Name = "TSYS-VPC"
  }
}
 
resource "aws_subnet" "tsys-public-sub1" {
  vpc_id     = aws_vpc.TSYS-VPC.id
  cidr_block =  var.aws_subnet-tsys-public-sub1

  tags = {
    Name = "tsys-public-sub1"
  }
}

resource "aws_subnet" "tsys-public-sub2" {
  vpc_id     = aws_vpc.TSYS-VPC.id
  cidr_block = var.aws_subnet-tsys-public-sub2

  tags = {
    Name = "tsys-public-sub2"
  }
}

resource "aws_subnet" "tsys-private-sub1" {
  vpc_id     = aws_vpc.TSYS-VPC.id
  cidr_block = var.aws_subnet-tsys-private-sub1

  tags = {
    Name = "tsys-private-sub1"
  }
}

resource "aws_subnet" "tsys-private-sub2" {
  vpc_id     = aws_vpc.TSYS-VPC.id
  cidr_block = var.aws_subnet-tsys-private-sub2

  tags = {
    Name = "tsys-private-sub2"
  }
}


resource "aws_route_table" "tsys-public-route-table" {
  vpc_id = aws_vpc.TSYS-VPC.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "tsys-private-route-table" {
  vpc_id = aws_vpc.TSYS-VPC.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public-route-association" {
  subnet_id      = aws_subnet.tsys-public-sub1.id
  route_table_id = aws_route_table.tsys-public-route-table.id
}

resource "aws_route_table_association" "private-route-association" {
  subnet_id      = aws_subnet.tsys-private-sub1.id
  route_table_id = aws_route_table.tsys-private-route-table.id
}

resource "aws_internet_gateway" "tsys-igw" {
  vpc_id = aws_vpc.TSYS-VPC.id

  tags = {
    Name = "tsys-igw"
  }
}

resource "aws_route" "public-igw-route" {
  route_table_id            = aws_route_table.tsys-public-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.tsys-igw.id
}

resource "aws_eip" "eip_for_tsys_ngw" {
  vpc = true
  associate_with_private_ip = "18.132.136.127"
  depends_on                = [aws_internet_gateway.tsys-igw]
}

# NAT Gateway #
resource "aws_nat_gateway" "Tsys_ngw" {
  allocation_id = aws_eip.eip_for_tsys_ngw.id
  subnet_id     = aws_subnet.tsys-public-sub1.id

  tags = {
    Name = "Tsys_ngw"
  }
}

# attaching NGW to the private route table #

resource "aws_route" "Tsys_ngw" {
  route_table_id         = aws_route_table.tsys-private-route-table.id
  gateway_id             = aws_nat_gateway.Tsys_ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Security groups #
resource "aws_security_group" "Tsys-sec-group" {
  name        = "TSYS-SG"
  vpc_id      = aws_vpc.TSYS-VPC.id

  ingress {
    description      = "allow http access" 
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["41.242.139.202/32"]
  }

  ingress {
    description      = "allow ssh access"
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

  tags = {
    Name = "security group for ec2"
  }
}

# ec2 Instance #
resource "aws_instance" "tsys-sever-1" {
  ami             = "ami-0aaa5410833273cfe"
  instance_type   = "t2.micro"
  key_name               = "mainkeypair"
  subnet_id       = aws_subnet.tsys-public-sub1.id
  tenancy         = "default"

  tags = {
    Name = "tsys-sever-1"
  }
}

resource "aws_instance" "tsys-sever-2" {
  ami             = "ami-0aaa5410833273cfe"
  instance_type   = "t2.micro"
  key_name               = "mainkeypair"
  subnet_id       = aws_subnet.tsys-private-sub1.id
  tenancy         = "default"

  tags = {
    Name = "tsys-sever-2"
  }
}