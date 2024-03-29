/* Terraform constraints */
terraform {
    required_version = ">= 0.11, < 0.12"
}

variable "name_prefix" {
    default = "tutorial"
    description = "Name prefix for this environment."
}

variable "aws_region" {
    default = "eu-west-1"
    description = "Determine AWS region endpoint to access."
}

/* ECS optimized AMIs per region */
variable "ecs_image_id" {
  default = {
    ap-northeast-1 = "ami-68ef940e"
    ap-southeast-1 = "ami-0a622c76"
    eu-west-1      = "ami-0693ed7f"
    us-east-1      = "ami-a7a242da"
    us-west-1      = "ami-9ad4dcfa"
    us-west-2      = "ami-92e06fea"
  }
}
# ---------------------webapp------------------
variable "webapp_docker_image_name" {
    default = "phpmyadmin/phpmyadmin"
    description = "Docker image from Docker Hub"
}

variable "webapp_docker_image_tag" {
    default = "latest"
    description = "Docker image version to pull (from tag)"
}

variable "count_webapp" {
    default = 2
    description = "Number of webapp tasks to run"
}

variable "desired_capacity_on_demand" {
    default = 2
    description = "Number of instance to run"
}

variable "ec2_key_name" {
    default = ""
    description = "EC2 key name to SSH to the instance, make sure that you have this key if you want to access your instance via SSH"
}

variable "instance_type" {
    default = "t2.micro"
    description = "EC2 instance type to use"
}

variable "minimum_healthy_percent_webapp" {
    default = 50
    description = "ECS minimum_healthy_percent configuration, set it lower than 100 to allow rolling update without adding new instances"
}

/* Consume common outputs */
variable "sg_webapp_albs_id" {}
variable "sg_webapp_instances_id" {}
variable "vpc_id" {}
variable "pub_subnet_ids" {}
variable "priv_subnet_ids" {}

# ------------------------mysql-----------------------
variable "mysql_docker_image_name" {
    default = "mysql"
    description = "Docker image from Docker Hub"
}

variable "mysql_docker_image_tag" {
    default = "latest"
    description = "Docker image version to pull (from tag)"
}

variable "count_mysql" {
    default = 2
    description = "Number of mysql tasks to run"
}

/* Consume common outputs */
variable "sg_mysql_instances_id" {}

variable "minimum_healthy_percent_mysql" {
    default = 50
    description = "ECS minimum_healthy_percent configuration, set it lower than 100 to allow rolling update without adding new instances"
}

# ------------------------------------


/* Consume static outputs */
variable "ecs_instance_profile" {}
variable "ecs_service_role" {}

/* Region settings for AWS provider */
provider "aws" {
    region = "${var.aws_region}"
}
