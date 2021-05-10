resource "aws_security_group" "instance" {
    name = "app-instance-sg"
    description = "AWS sg for instances"
    vpc_id = aws_vpc.example-vpc.id
    
    ingress {
        description = "Allow port 3000 from loadbalancer sg"
        from_port = var.instance["port"]
        to_port = var.instance["port"]
        protocol = "TCP"
        security_groups = [aws_security_group.loadbalancer_sg.id]
    }
    
    ingress {
        description = "Alloe SSH jump_server_sg"
        from_port = var.instance["SSH_PORT"]
        to_port = var.instance["SSH_PORT"]
        protocol = "TCP"
        cidr_blocks = [var.sec_cidr_blocks["IP4"]]
        ipv6_cidr_blocks = [var.sec_cidr_blocks["IP6"]]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" 
        cidr_blocks = [var.sec_cidr_blocks["IP4"]]
        ipv6_cidr_blocks = [var.sec_cidr_blocks["IP6"]]
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
        from_port = var.lb-vars["PORT"]
        to_port = var.lb-vars["PORT"]
        protocol = "tcp"
        cidr_blocks = [var.sec_cidr_blocks["IP4"]]
        ipv6_cidr_blocks = [var.sec_cidr_blocks["IP6"]]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.sec_cidr_blocks["IP4"]]
        ipv6_cidr_blocks = [var.sec_cidr_blocks["IP6"]]
    }

    tags = {
        Name = "app-lb-sg"
    }
}


