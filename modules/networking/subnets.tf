# Create Private Subnets
resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az1

  tags = merge(
    var.tags,
    {
      Name = "Private subnet 1"
    }
  )
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az2

  tags = merge(
    var.tags,
    {
      Name = "Private Subnet 2"
    }
  )
}

# Create Public Subnet (for testing purposes bro)

# Create Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "Main Internet Gateway"
    }
  )
}

# Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "Public Route Table"
    }
  )
}

# Now We Create the Public Subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "Public Subnet 1"
    }
  )
}

# Associating the route table to the public subnet
resource "aws_route_table_association" "public_rtt_assoc_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id
}