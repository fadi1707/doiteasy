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