# security group for C2 server machine
resource "aws_security_group" "subnet-c2-server" {
    name        = "subnet-c2-server"
    description = "Control C2 server host traffic"
    vpc_id      = "${aws_vpc.prod-vpc.id}"

    #egress {
        #from_port   = 0
        #to_port     = 0
        #protocol    = -1
        #cidr_blocks = ["0.0.0.0/0"]
        #description = "Internet Access"
    #}
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["10.10.0.0/24"]
        description = "Subnet All Access"

        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

    tags = {
        Name = "subnet-c2-server"
    }
}
# security group for Subnet - Windows Developer machine
resource "aws_security_group" "subnet-sg-dev" {
    name        = "subnet-sg-dev"
    description = "Allow developer host traffic to all hosts and internet"
    vpc_id      = "${aws_vpc.prod-vpc.id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Internet Access"
    }

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["10.10.0.0/24"]
        description = "Subnet All Access"

        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

    tags = {
        Name = "subnet-sg-dev"
    }
}

# security group for Subnet - Ubuntu Redirector
resource "aws_security_group" "subnet-sg-redir" {
    name        = "subnet-sg-redir"
    description = "Allow redir host traffic to all hosts and internet and 80 and 443"
    vpc_id      = "${aws_vpc.prod-vpc.id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "Internet Access"
    }

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["10.10.0.0/24"]
        description = "Subnet All Access"

        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

        ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Redir Server HTTPS Access"
        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

        ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Redir Server HTTP Access"
        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

            ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Redir Server SSH Access"
        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

    tags = {
        Name = "subnet-sg-dev"
    }
}

# security group for Guac Server
resource "aws_security_group" "guacamole-server-sg-allowed" {
    name        = "guacamole-sg"
    description = "Allow traffic to Guacamole Host"
    vpc_id      = "${aws_vpc.prod-vpc.id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Guacamole Server HTTPS Access"
        ipv6_cidr_blocks    = []
        prefix_list_ids     = []
        security_groups     = []
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Guacamole Server Tomcat 8080 Access"
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
    }

        ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Guacamole Server SSH Access"
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
    }

        ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["10.10.0.0/24"]
        description = "Subnet All Access"
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
    }

    

    tags = {
        Name = "guacamole-server-sg-allowed"
    }
}
