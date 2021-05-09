resource "aws_vpc" "example-vpc"  {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "example-vpc"
    }
}

resource "aws_subnet" "example-subnet-1" {
    vpc_id = aws_vpc.example-vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "example-subnet-1"
    } 
}

resource "aws_subnet" "example-subnet-2" {
    vpc_id = aws_vpc.example-vpc.id
    cidr_block = "10.0.1.0/28"
    availability_zone = "eu-central-1b"

    tags = {
        Name = "example-subnet-2"
    }
}

resource "aws_internet_gateway" "example_igw" {
    vpc_id = aws_vpc.example-vpc.id

    tags = {
        Name = "example-igw"
    }
}

resource "aws_route_table" "example-RT" {
    vpc_id = aws_vpc.example-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.example_igw.id
    }

    tags = {
        Name = "example-RT"
    }
}

resource "aws_main_route_table_association" "RT-igw" {
    vpc_id = aws_vpc.example-vpc.id
    route_table_id = aws_route_table.example-RT.id
}