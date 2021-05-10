resource "aws_instance" "app1" {
    ami = var.instance["ami_type"]
    instance_type = var.instance["inst_type"]
    subnet_id = aws_subnet.example-subnet-1.id
    associate_public_ip_address = true
    key_name = var.public_key
    vpc_security_group_ids = [
        aws_security_group.instance.id
    ]
    
    tags = {
        Name = "app1"
    }
}

resource "aws_instance" "app2" {
    ami = var.instance["ami_type"]
    instance_type = var.instance["inst_type"]
    subnet_id = aws_subnet.example-subnet-2.id
    associate_public_ip_address = true
    key_name = var.public_key
    vpc_security_group_ids = [
        aws_security_group.instance.id
    ]
    
    tags = {
        Name = "app2"
    }
}