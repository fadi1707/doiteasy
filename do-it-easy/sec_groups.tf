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


