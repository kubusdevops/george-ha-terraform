resource "aws_lb" "george_lb" {
    name               = "george-ha-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.george_ha_sg.id]
    subnets            = var.subnet_ids
    enable_deletion_protection = false   
}

resource "aws_lb_target_group" "george_tg" {
  name        = "george-ha-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

} 

resource "aws_lb_listener" "george_lb_listener" {
  load_balancer_arn = aws_lb.george_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.george_tg.arn
  }
}

