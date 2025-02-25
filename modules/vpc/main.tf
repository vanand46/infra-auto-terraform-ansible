
# Create AWS VPC (Virtual Private Cloud)
resource "aws_vpc" "infra_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Create AWS Subnet
resource "aws_subnet" "infra_subnet" {
  vpc_id                  = aws_vpc.infra_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = var.public_ip_on_launch
  depends_on              = [aws_vpc.infra_vpc]
  tags = {
    Name = var.subnet_name
  }
}

# Create AWS Internet Gateway
resource "aws_internet_gateway" "infra_gw" {
  vpc_id = aws_vpc.infra_vpc.id
  depends_on = [aws_vpc.infra_vpc]
  tags = {
    Name = var.internet_gateway_name
  }
}


# Create AWS Route Table
resource "aws_route_table" "infra_route_table" {
  vpc_id = aws_vpc.infra_vpc.id
  depends_on = [aws_vpc.infra_vpc]
  tags = {
    Name = var.route_table_name
  }
}

# Adds a route in the route table
resource "aws_route" "infra_route" {
  route_table_id         = aws_route_table.infra_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.infra_gw.id
  depends_on             = [aws_route_table.infra_route_table, aws_internet_gateway.infra_gw]
}

# Links the subnet to the route table.
resource "aws_route_table_association" "infra_route_association" {
  subnet_id      = aws_subnet.infra_subnet.id
  route_table_id = aws_route_table.infra_route_table.id
  depends_on     = [aws_subnet.infra_subnet, aws_route_table.infra_route_table]
}