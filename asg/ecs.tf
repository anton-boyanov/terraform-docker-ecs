/* Cluster definition, which is used in autoscaling.tf */
resource "aws_ecs_cluster" "cluster" {
    name = "${var.name_prefix}_cluster"
}

/* ECS service definitions */
# --------------------webapp--------------------------

resource "aws_ecs_service" "webapp_service" {
    name = "${var.name_prefix}_webapp_service"
    cluster = "${aws_ecs_cluster.cluster.id}"
    task_definition = "${aws_ecs_task_definition.webapp_definition.arn}"
    desired_count = "${var.count_webapp}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_webapp}"
    iam_role = "${var.ecs_service_role}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.webapp_tg.arn}"
        container_name = "webapp"
        container_port = 80
    }

    lifecycle {
        create_before_destroy = true
    }
}

# --------------------mysql------------------------------

resource "aws_ecs_service" "mysql_service" {
    name = "${var.name_prefix}_mysql_service"
    cluster = "${aws_ecs_cluster.cluster.id}"
    task_definition = "${aws_ecs_task_definition.mysql_definition.arn}"
    desired_count = "${var.count_mysql}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_mysql}"
    iam_role = "${var.ecs_service_role}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.mysql_tg.arn}"
        container_name = "mysql"
        container_port = 3306
    }

    lifecycle {
        create_before_destroy = true
    }
}

# -------------------------webapp-------------------------

resource "aws_ecs_task_definition" "webapp_definition" {
    family = "${var.name_prefix}_webapp"
    container_definitions = "${data.template_file.task_webapp.rendered}"

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "task_webapp" {
    template= "${file("task-definitions/ecs_task_webapp.tpl")}"

    vars {
        webapp_docker_image = "${var.webapp_docker_image_name}:${var.webapp_docker_image_tag}"
    }
}

# -------------------------mysql-------------------------

resource "aws_ecs_task_definition" "mysql_definition" {
    family = "${var.name_prefix}_mysql"
    container_definitions = "${data.template_file.task_mysql.rendered}"

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "task_mysql" {
    template= "${file("task-definitions/ecs_task_mysql.tpl")}"

    vars {
        mysql_docker_image = "${var.mysql_docker_image_name}:${var.mysql_docker_image_tag}"
    }
}

# -------------------------------------------------
