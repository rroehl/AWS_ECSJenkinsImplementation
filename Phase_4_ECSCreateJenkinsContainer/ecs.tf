

resource "aws_ecs_service" jenkins_controller {
    //depends_on = [aws_ecs_task_definition.jenkins_controller, aws_ecs_cluster.jenkins_controller_cluster,aws_lb_listener.http_app_lb_listener]  //ROBB [aws_lb_listener.https]
    name = "${var.name_prefix}-controller"
    task_definition  = data.aws_ecs_task_definition.jenkins_controller_task_definition.arn
    cluster          = data.aws_ecs_cluster.ecs-jenkins_controller_cluster.id
    desired_count    = 1
    launch_type      = "FARGATE"
    platform_version = "1.4.0"

    //Robb Enable for SSH dubugging
    enable_execute_command = true

    // Assuming we cannot have more than one instance at a time. Ever. 
    deployment_maximum_percent         = 100
    deployment_minimum_healthy_percent = 0
    
    service_registries {
        registry_arn = data.aws_service_discovery_service.get_jenkins_discovery_service.arn
        port =  var.jenkins_jnlp_port
    } 

    load_balancer {
        target_group_arn = data.aws_lb_target_group.get_app_lb_targetgroup.arn
        container_name   = "${var.name_prefix}-controller"
        container_port   = var.jenkins_controller_port
    }

    network_configuration {
        subnets          = data.aws_subnets.GetPrivateSubnetObjs.ids //["subnet-0619bffb0f8d47145"] //   "subnet-0c2f9053a997a08d7" "subnet-0619bffb0f8d47145"  data.aws_subnets.GetPrivateSubnetObjs.ids
        security_groups  = [data.aws_security_group.get_jenkins_controller_security_group.id]
        assign_public_ip = false
        }
    }


//TODO   SAVE THIS TO HAVE ECS MANUAL SPIN UP AGENT
/*
resource "aws_ecs_service" jenkins_agent {
    //depends_on = [aws_ecs_task_definition.jenkins_controller, aws_ecs_cluster.jenkins_controller_cluster,aws_lb_listener.http_app_lb_listener]  //ROBB [aws_lb_listener.https]
    name = "${var.name_prefix}-agent"
    task_definition  = "arn:aws:ecs:us-east-2:638139650817:task-definition/serverless-jenkins-agent-task-def:84"
    cluster          = data.aws_ecs_cluster.ecs-jenkins_controller_cluster.id
    desired_count    = 1
    launch_type      = "FARGATE"
    platform_version = "1.4.0"

    //Robb Enable for SSH dubugging
    enable_execute_command = true

    // Assuming we cannot have more than one instance at a time. Ever. 
    deployment_maximum_percent         = 100
    deployment_minimum_healthy_percent = 0

    network_configuration {
        subnets          = data.aws_subnets.GetPrivateSubnetObjs.ids //["subnet-0619bffb0f8d47145"] //   "subnet-0c2f9053a997a08d7" "subnet-0619bffb0f8d47145"  data.aws_subnets.GetPrivateSubnetObjs.ids
        security_groups  = [data.aws_security_group.get_jenkins_agent_security_group.id]
        assign_public_ip = false
        }
    }
*/