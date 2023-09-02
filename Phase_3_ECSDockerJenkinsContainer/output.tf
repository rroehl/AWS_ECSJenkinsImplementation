output "repo_name" {
  value = data.aws_ecr_repository.get_jenkins_controller_repo.name
}

output "repository_url" {
  value = data.aws_ecr_repository.get_jenkins_controller_repo.repository_url 
}


output "robbsubnets" {
value =  join(",", [for s in data.aws_subnets.GetPrivateSubnetObjs.ids : format("%q", s)]) 
//value =  "data.aws_subnets.GetPrivateSubnetObjs.ids " 
}