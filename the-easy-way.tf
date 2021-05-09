terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.14.1"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

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

resource "aws_instance" "app1" {
    ami = "ami-043097594a7df80ec"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.example-subnet-1.id
    associate_public_ip_address = true
    key_name = "ffadi-new-kay"
    vpc_security_group_ids = [
        aws_security_group.instance.id
    ]
    
    tags = {
        Name = "app1"
    }
}

resource "aws_instance" "app2" {
    ami = "ami-043097594a7df80ec"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.example-subnet-2.id
    associate_public_ip_address = true
    key_name = "ffadi-new-kay"
    vpc_security_group_ids = [
        aws_security_group.instance.id
    ]
    
    tags = {
        Name = "app2"
    }
}

resource "aws_elb" "example-lb" {
    name = "example-lb"
    subnets = [aws_subnet.example-subnet-1.id, aws_subnet.example-subnet-2.id]
    security_groups = [aws_security_group.loadbalancer_sg.id]
    listener {
        instance_port = 3000
        instance_protocol = "tcp"
        lb_port = 80
        lb_protocol = "tcp"
    }
    
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:3000/"
        interval = 30
    }

    instances = [aws_instance.app1.id, aws_instance.app2.id]
    cross_zone_load_balancing = true

    tags = {
        Name = "example-lb"
    }
}

resource "aws_security_group" "instance" {
    name = "app-instance-sg"
    description = "AWS sg for instances"
    vpc_id = aws_vpc.example-vpc.id
    
    ingress {
        description = "Allow port 3000 from loadbalancer sg"
        from_port = 3000
        to_port = 3000
        protocol = "TCP"
        security_groups = [aws_security_group.loadbalancer_sg.id]
    }
    
    ingress {
        description = "Alloe SSH jump_server_sg"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "app-instance-sg"
    }
}
resource "aws_security_group" "loadbalancer_sg" {
    name = "app-lg-sg"
    description = "Allow http inbound to LB"
    vpc_id = aws_vpc.example-vpc.id

    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "app-lb-sg"
    }
}


