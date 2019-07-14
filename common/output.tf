/* Security group */
output "sg_webapp_albs_id" {
    value = "${aws_security_group.webapp_albs.id}"
}

output "sg_webapp_instances_id" {
    value = "${aws_security_group.webapp_instances.id}"
}
# ----------------mysql------------------
output "sg_mysql_instances_id" {
    value = "${aws_security_group.mysql_instances.id}"
}
# --------------------------------------
output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

/* Subnet IDs */
output "pub" {
    value = "${join(",", aws_subnet.pub.*.id)}" # ???
}
