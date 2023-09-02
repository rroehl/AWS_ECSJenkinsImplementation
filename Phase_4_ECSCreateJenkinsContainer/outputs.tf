output "container_subnets_objs" {
  value = data.aws_subnets.GetPrivateSubnetObjs
}

output "service_efs_access_points_ids" {
    value = data.aws_efs_access_points.get_service_efs_access_point.ids[0]
    description = "EFS Files systemr"
    }
    
output "service_efs_file_system" {
    value = data.aws_efs_file_system.get_jenkins_service_efs
    description = "Service EFS Files systemr"
    }

//output "ecr_linux_agent_endpoint" {
 // value = local.ecr_linux_agent_endpoint 
//}





