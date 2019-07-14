resource "aws_alb" "main" {
  lifecycle { create_before_destroy = true }
  name = "${var.name_prefix}-alb"
  subnets = [ "${split(",", var.pub_subnet_ids)}" ]
  security_groups = ["${var.sg_webapp_albs_id}"]
  idle_timeout = 400
  tags {
        Name = "${var.name_prefix}_alb"
  }
}

resource "aws_alb_target_group" "webapp_tg" {
  name                 = "${var.name_prefix}-webapp-tg"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"

  deregistration_delay = 180

  health_check {
    interval            = "60"
    path                = "/"
    port                = "80"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags {
        Name = "${var.name_prefix}_webapp_tg"
  }

  depends_on = ["aws_alb.main"]
}

# ----------------------mysql------------------------------
resource "aws_alb_target_group" "mysql_tg" {
  name                 = "${var.name_prefix}-mysql-tg"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"

  deregistration_delay = 180

  health_check {
    interval            = "60"
    path                = "/"
    port                = "3306"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags {
        Name = "${var.name_prefix}_mysql_tg"
  }

  depends_on = ["aws_alb.main"]
}

# --------------------webap-------------------------------

resource "aws_alb_listener" "frontend_http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.webapp_tg.id}"
    type             = "forward"
  }

  depends_on = ["aws_alb.main"]
}

# ---------------------mysql-------------------------
resource "aws_alb_listener" "mysql" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "3306"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.mysql_tg.id}"
    type             = "forward"
  }

  depends_on = ["aws_alb.main"]
}

