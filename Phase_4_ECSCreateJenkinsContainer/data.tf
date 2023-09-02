data "aws_subnets" "GetPrivateSubnetObjs" {
  //vpc_id = "${data.aws_vpc.GetVPCObject.id}"
  filter {
    name = "tag:Name"
    values = [var.private_subnet_names ] //"${data.aws_vpc.targetVpc.tags.Name}.dmz0"]
  }
}

//EFS Files Systems
data "aws_efs_file_system" "get_jenkins_service_efs" {
    //vpc_id = "${data.aws_vpc.GetVPCObject.id}"
    tags = {
        Name = var.jenkins_service_efs_name
    }
}

data "aws_efs_access_points" "get_service_efs_access_point" {
    file_system_id = data.aws_efs_file_system.get_jenkins_service_efs.id
}


data "aws_lb_target_group" "get_app_lb_targetgroup" {
      name = "Jenkins-AppLB-TargetGroup"
    }

data "aws_security_group" "get_jenkins_controller_security_group" {
      filter {
        name = "tag:Name"
        values = ["Jenkins Controller SecurityGroup"]
        }
    }
  


// ----- Discoverty service
data "aws_service_discovery_dns_namespace" "get_private_namespace" {
    name = var.jenkins_dns_domain_name
    type = "DNS_PRIVATE"
}

data "aws_service_discovery_service" "get_jenkins_discovery_service" {
  name         = var.jenkins_service_hostname
  namespace_id = data.aws_service_discovery_dns_namespace.get_private_namespace.id
}

// Cluster resources
//Get Jenkins cluster resource
data "aws_ecs_cluster" "ecs-jenkins_controller_cluster" {
  cluster_name = "${var.name_prefix}-cluster"
}    

// Get the Jenkins service task definition
data "aws_ecs_task_definition" "jenkins_controller_task_definition" {
  task_definition = "${var.name_prefix}-service-task-def"
}




