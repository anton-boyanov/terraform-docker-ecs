##
# Some of these variables may be removed from this file if the default value exists
# For better understanding, let's specify all variables explicitly here
##
name_prefix = "endava"
aws_region = "eu-west-1"
#ecs_image_id.eu-west-1 = "ami-68ef940e"
count_webapp = 2
count_mysql = 2
desired_capacity_on_demand = 2
ec2_key_name = "key-name"
instance_type = "t2.micro"
minimum_healthy_percent_webapp = 50
minimum_healthy_percent_mysql = 50

##
# This is a (public) Docker image from dockerhub 
# This web server binds to port 80
##
webapp_docker_image_name = "phpmyadmin/phpmyadmin"
webapp_docker_image_tag = "latest"

##
# This is a (public) Docker image from dockerhub 
# This mysql server binds to port 3306
##
mysql_docker_image_name = "mysql"
mysql_docker_image_tag = "latest"


##
# These variables are required, please fill it out with your environment outputs
##
# -----------------webapp--------------------
sg_webapp_albs_id = "sg-00388055928d84b77"
sg_webapp_instances_id = "sg-066b20e28cb4a5177"
# -----------------mysql---------------------------
sg_mysql_instances_id = "sg-090b3e93cc12690e4"
# -------------------------------------------
vpc_id = "vpc-049cd3514170b2f37"
pub_subnet_ids = "subnet-0a549b94956eb76da,subnet-0dd22a85b15913588"
priv_subnet_ids = "subnet-042cc9d8c584e3fd5,subnet-0188c4995ab10415c"


ecs_instance_profile = "arn:aws:iam::685125159224:instance-profile/endava_ecs_instance_profile"
ecs_service_role = "endava_ecs_service_role"
