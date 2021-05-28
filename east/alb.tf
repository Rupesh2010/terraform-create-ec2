resource "aws_lb" "default" {
  name               = var.app
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default.id]
  subnets            = [tolist(data.aws_subnet_ids.default.ids)[0], tolist(data.aws_subnet_ids.default.ids)[1]]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}


resource "aws_lb_listener_rule" "default" {
  listener_arn = aws_lb_listener.default.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default.arn
  }

  condition {
    host_header {
      values = ["petclinic.wahidit.live"]
    }
  }
}
