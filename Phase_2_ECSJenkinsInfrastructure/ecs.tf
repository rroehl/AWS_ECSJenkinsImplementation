//Create ECS cluster
resource "aws_ecs_cluster" "jenkins_controller_cluster" {
  //  depends_on = [null_resource.build_docker_controller_image]
    name               = "${var.name_prefix}-cluster"
    capacity_providers = ["FARGATE"]
   // aws_ecs_cluster_capacity_providers = 
    tags               = {
        name  = "Jenkins Cluster"
    }
    setting {
        name = "containerInsights"
        value = "enabled"
    }
}
// Create ECS template for Jenkins controller
resource "aws_ecs_task_definition" jenkins_controller {
    //ROBB depends_on = [aws_efs_file_system.jenkins_service_efs,aws_ecr_repository.jenkins_controller, aws_cloudwatch_log_group.jenkins_controller_log_group]
    depends_on = [aws_efs_file_system.jenkins_service_efs, aws_efs_access_point.jenkins_service_efs_access_point, aws_cloudwatch_log_group.jenkins_controller_log_group]  

    family = "${var.name_prefix}-service-task-def"
    task_role_arn            =  aws_iam_role.jenkins_controller_task_role.arn  // B1 var.jenkins_controller_task_role_arn != null ? var.jenkins_controller_task_role_arn : aws_iam_role.jenkins_controller_task_role.arn  
    execution_role_arn       =  aws_iam_role.ecs_execution_role.arn   // NOT the task role  var.ecs_execution_role_arn != null ? var.ecs_execution_role_arn : aws_iam_role.jenkins_controller_task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.jenkins_controller_cpu
    memory                   = var.jenkins_controller_memory
    //container_definitions    = data.template_file.jenkins_controller_container_def.rendered

    container_definitions    = templatefile("${path.module}/modified-jenkins-controller.json.tpl",
                                                        {
                                                        name                    = "${var.name_prefix}-controller",
                                                        jenkins_container_port  = var.jenkins_controller_port,
                                                        jnlp_port               = var.jenkins_jnlp_port,
                                                        source_volume           = "${var.name_prefix}-${var.jenkins_service_efs_token}",
                                                        jenkins_home            = var.jenkins_service_home_folder, 
                                                        container_image         = join("", [aws_ecr_repository.jenkins_controller.repository_url,":", var.jenkins_controller_image_tag]),
                                                        region                  = var.region,
                                                        log_group               = aws_cloudwatch_log_group.jenkins_controller_log_group.name,
                                                        memory                  = var.jenkins_controller_memory,
                                                        cpu                     = var.jenkins_controller_cpu
                                                        } 
                                                    )

    volume {
        name = "${var.name_prefix}-${var.jenkins_service_efs_token}" 

        efs_volume_configuration {
            file_system_id     = aws_efs_file_system.jenkins_service_efs.id
            transit_encryption = "ENABLED"

            authorization_config {
                access_point_id = aws_efs_access_point.jenkins_service_efs_access_point.id //ids[0] Assumes its the 1st ID  "fsap-08b95278a161e8a7a"
                iam             = "ENABLED"
                }
            }
        }
    }

resource "aws_ecs_task_definition" jenkins_agent {
  
    depends_on = [aws_efs_file_system.jenkins_agent_dot_jenkins_efs, aws_cloudwatch_log_group.jenkins_controller_log_group,aws_efs_file_system.jenkins_agent_work_dir_efs]  

    family = "${var.name_prefix}-agent-task-def"
    task_role_arn            =  aws_iam_role.jenkins_controller_task_role.arn  // B1 var.jenkins_controller_task_role_arn != null ? var.jenkins_controller_task_role_arn : aws_iam_role.jenkins_controller_task_role.arn  
    execution_role_arn       =  aws_iam_role.ecs_execution_role.arn   // NOT the task role  var.ecs_execution_role_arn != null ? var.ecs_execution_role_arn : aws_iam_role.jenkins_controller_task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.jenkins_agent_cpu
    memory                   = var.jenkins_agent_memory
   // container_definitions    = data.template_file.jenkins_agent_container_def.rendered
    container_definitions    = templatefile("${path.module}/modified-jenkins-agent.json.tpl",
                                                        {
                                                        name                            = "${var.name_prefix}-agent",
                                                        container_image                 = join("", [aws_ecr_repository.jenkins_linux_agent.repository_url,":", var.docker_linux_agent_image_tag]),
                                                        memory                          = var.jenkins_agent_memory,
                                                        cpu                             = var.jenkins_agent_cpu,
                                                        dot_jenkins_folder              = join("", ["${var.jenkins_linux_agent_home_folder}/",".jenkins"]),
                                                        dot_jenkins_source_volume       = "${var.name_prefix}-${var.jenkins_agent_dot_jenkins_efs_token}",
                                                        workdir_folder                  = "${var.jenkins_linux_agent_home_folder}/agent",
                                                        workdir_source_volume           = "${var.name_prefix}-${var.jenkins_agent_work_dir_fs_efs_token}",
                                                        log_group                       = aws_cloudwatch_log_group.jenkins_controller_log_group.name,
                                                        region                          = var.region 
                                                        } 
                                                    )

    volume {
        name = "${var.name_prefix}-${var.jenkins_agent_dot_jenkins_efs_token}"
        efs_volume_configuration {
            file_system_id     = aws_efs_file_system.jenkins_agent_dot_jenkins_efs.id
            root_directory          = "/"
            transit_encryption = "ENABLED"
            authorization_config {
                access_point_id = aws_efs_access_point.jenkins_agent_dot_jenkins_efs_access_point.id
                iam             = "ENABLED"
            }
        }
    }

    volume {
        name = "${var.name_prefix}-${var.jenkins_agent_work_dir_fs_efs_token}"
        efs_volume_configuration {
            file_system_id     =  aws_efs_file_system.jenkins_agent_work_dir_efs.id
            root_directory          = "/"
            transit_encryption = "ENABLED"
            authorization_config {
                access_point_id = aws_efs_access_point.jenkins_agent_work_dir_efs_access_point.id // Assumes its the 1st ID  "fsap-08b95278a161e8a7a"
                iam             = "ENABLED"
            }
        }
    }    
}

