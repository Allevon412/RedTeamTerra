resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"

    tags = {
        Name = "prod-vpc"
    }
}

resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.10.0.0/24"
    map_public_ip_on_launch = "true" // This makes the aws_subnet 'prod-subnet-public-1' a public subnet by associating a public IP on startup
    availability_zone = var.AVAILABILITY_ZONE

    tags = {
        Name = "prod-subnet-public-1"
    }
}