resource "aws_lb" "app_lb" {
    name               = "Jenkins-AppLB"
    internal           = var.alb_type_internal  
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_security_group.id]
    subnets            = [ element(data.aws_subnets.GetPublicSubnetObjs.ids, 0),  element(data.aws_subnets.GetPublicSubnetObjs.ids, 1) ] 
//subnets            = [ "${element(data.aws_subnets.GetPublicSubnetObjs.ids, 0)}",  "${element(data.aws_subnets.GetPublicSubnetObjs.ids, 1)}" ] 
    }

resource "aws_lb_target_group" "app_lb_targetgroup" {
    name     = "Jenkins-AppLB-TargetGroup"
    port     = var.jenkins_controller_port
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.GetVPCObject.id
    target_type = "ip"

    health_check {
        path = "/login"
        healthy_threshold = 3    //3
        unhealthy_threshold = 5 //3
        timeout = 100 //5 2 - 120
        interval = 101 //5 5-300
        }
    
    lifecycle {
        create_before_destroy = true
        }
    }

resource "aws_lb_listener" "http_app_lb_listener" {
    depends_on = [aws_lb_target_group.app_lb_targetgroup]
    load_balancer_arn = aws_lb.app_lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app_lb_targetgroup.arn
        }

    /*When I implement CERTS
    default_action {
        type = "redirect"

        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
            }
        }
    */
    tags = {
        Name = "HTTP LoadBalancer Listener"
        }
    }
/* When I implement SSL
resource "aws_lb_listener_rule" https_app_lb_listener {
    listener_arn = aws_lb.app_lb.arn
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
    certificate_arn   = var.alb_acm_certificate_arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app_lb_targetgroup.arn
        }
    }

resource "aws_lb_listener_rule" redirect_http_to_https {
    listener_arn = aws_lb_listener.http_app_lb_listener.arn
    action {
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
            }
    }

    condition {
        http_header {
               http_header_name = "*"
               values           = ["*"]
               }
           }
    }
    */
