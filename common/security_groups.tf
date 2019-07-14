/**
  * We will utilize ELB and allow web access only from ELB
  */
resource "aws_security_group" "webapp_albs" {
    name = "${var.name_prefix}-webapp-albs"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for ALBs"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.name_prefix}-webapp"
    }
}

/**
  * Security group for each instances
  */
# ----------------webapp--------------------------
resource "aws_security_group" "webapp_instances" {
    name = "${var.name_prefix}-webapp-instances"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for web"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.name_prefix}-webapp"
    }
}

# -------------------mysql------------------------
resource "aws_security_group" "mysql_instances" {
    name = "${var.name_prefix}-mysql-instances"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for mysql"

    tags {
        Name = "${var.name_prefix}-mysql"
    }
}

# -----------------------------------------------
resource "aws_security_group_rule" "allow_all_egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.webapp_instances.id}"
    security_group_id = "${aws_security_group.mysql_instances.id}"
}
# Allow incoming requests from ELB and peers only
resource "aws_security_group_rule" "allow_all_from_albs" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"

    security_group_id = "${aws_security_group.webapp_instances.id}"
    source_security_group_id = "${aws_security_group.webapp_albs.id}"
}

resource "aws_security_group_rule" "allow_3306_from_alb" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"

    source_security_group_id = "${aws_security_group.mysql_instances.id}"
    security_group_id = "${aws_security_group.webapp_albs.id}"
}

resource "aws_security_group_rule" "allow_3306_from_webapp" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"

    security_group_id = "${aws_security_group.mysql_instances.id}"
    source_security_group_id = "${aws_security_group.webapp_instances.id}"
}


#   In production, it's recommended to remove SSH access to the instance
#   (Comment the following lines out)

resource "aws_security_group_rule" "allow_ssh_from_internet" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.mysql_instances.id}"
}

