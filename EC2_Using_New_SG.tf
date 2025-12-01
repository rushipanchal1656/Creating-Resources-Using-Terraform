provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2-instance" {
    ami = "ami-0d176f79571d18a8f"
    instance_type = "t2.micro"
    key_name = "Mumbai_server_key"
    vpc_security_group_ids = [aws_security_group.Security_Group.id] # To add newly created VPC security group IDs
    tags = {
        name = "My-EC2-Instance"
    }
}

resource "aws_security_group" "Security_Group" {
    name = "my=sg"
    description = "Security group for my EC2 instance"
  ingress {
    description = "HTTP allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH allow"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "HTTPS allow"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}