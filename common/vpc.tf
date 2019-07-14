/* Create a VPC */

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Name = "${var.name_prefix}-VPC"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.name_prefix}-IGW"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "${var.name_prefix}-pub-RT"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.name_prefix}-priv-RT"
    }
}
/*
resource "aws_route" "r" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = ["aws_route_table.private"]
}
*/

resource "aws_vpc_dhcp_options" "dns_resolver" {
    domain_name_servers = ["AmazonProvidedDNS"]

    tags {
        Name = "${var.name_prefix}-webapp"
    }
}

resource "aws_vpc_dhcp_options_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}

/* For better availability, we will create our VPC in 2 different availability zones */
resource "aws_subnet" "pub" {
    count = 2
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.${count.index +1}.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.aws_region}${element(split(",", var.subnet_azs), count.index)}"

    tags {
        Name = "webapp"
    }
}
# -----------------------mysql-----------------------------
resource "aws_subnet" "priv" {
    count = 2
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.${count.index + 3}.0/24"
    map_public_ip_on_launch = false
    availability_zone = "${var.aws_region}${element(split(",", var.subnet_azs), count.index)}"

    tags {
        Name = "mysql"
    }
}

resource "aws_route_table_association" "pub1" {
    subnet_id      = "${aws_subnet.pub.0.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "priv3" {
    subnet_id      = "${aws_subnet.priv.0.id}"
    route_table_id = "${aws_route_table.private.id}"
}
resource "aws_route_table_association" "pub2" {
    subnet_id      = "${aws_subnet.pub.1.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "priv4" {
    subnet_id      = "${aws_subnet.priv.1.id}"
    route_table_id = "${aws_route_table.private.id}"
}

