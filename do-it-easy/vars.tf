variable "public_key" {
  type = string
  default = "ffadi-new-kay"
}

variable "instance" {
  type = map
  default = {
      inst_type = "t2.micro"
      ami_type = "ami-043097594a7df80ec"
      port = 3000
      target = "HTTP:3000/"
      SSH_PORT = 22
  }
}

variable "region" {
    type = map
    default = {
        region = "eu-central-1"
        availability_zone1 = "eu-central-1a"
        availability_zone2 = "eu-central-1b"
        availability_zone3 = "eu-central-1c"
    }
  
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "protocol type"
}

variable "cidr_blocks" {
  type        = map
  default     = { 
      vpc = "10.0.0.0/16"
      subnet1 = "10.0.0.0/28"
      subnet2 = "10.0.1.0/28"
      route_cidr = "0.0.0.0/0"
  }
}

variable "sec_cidr_blocks" {
    type = map
    default = {
        IP4 = "0.0.0.0/0"
        IP6 = "::/0"
    }
}


variable "lb-vars" {
    type = map
    default = {
        PORT = 80   
    }
}

variable "my_health_check" {
    type = map
    default = {
        threshold = 2
        timeout = 3
        interval = 30
    }
}
