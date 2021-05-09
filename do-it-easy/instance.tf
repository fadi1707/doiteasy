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