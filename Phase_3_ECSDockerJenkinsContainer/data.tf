//data "aws_ecr_repository" "get_jenkins_controller_repo" {
   // name =var.jenkins_ecr_controller_repository_name
    //}

//data "aws_ecr_repository" "get_jenkins_linux_agent_repo" {
  //  name =var.jenkins_ecr_linux_agent_repository_name
    //}
// Cluster resources
//Get Jenkins cluster resource
data "aws_ecs_cluster" "ecs-jenkins_controller_cluster" {
  cluster_name = "${var.name_prefix}-cluster"
}   

data "aws_subnets" "GetPrivateSubnetObjs" {
  //vpc_id = "${data.aws_vpc.GetVPCObject.id}"
  filter {
    name = "tag:Name"
    values = [var.private_subnet_names] //"${data.aws_vpc.targetVpc.tags.Name}.dmz0"]
  }
}
data "aws_security_group" "get_jenkins_agent_security_group" {
    filter {
    name = "tag:Name"
    values = ["Jenkins Agent SecurityGroup"]
    }
}


//data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

// AWS Jenkins Repository
data "aws_ecr_repository" "get_jenkins_controller_repo" {
    name =var.jenkins_ecr_controller_repository_name
    }

data "aws_ecr_repository" "get_jenkins_linux_agent_repo" {
    name =var.jenkins_ecr_linux_agent_repository_name
    }


//data "aws_ecr_image" "service_controller_image" {

 // repository_name = ${aws_ecr_repository.jenkins_controller.repository_url}"
  //image_tag       = "${var.docker_service_image_tag}"
//}
