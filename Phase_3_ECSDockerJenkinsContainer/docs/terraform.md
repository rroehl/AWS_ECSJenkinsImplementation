<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.49 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.52.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.jenkins_yaml_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.aws_cli_login](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.build_docker_controller_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.build_docker_linux_agent_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.docker_controller_file_render_sed](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.docker_linux_agent_file_render_sed](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_ecr_repository.get_jenkins_controller_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_ecr_repository.get_jenkins_linux_agent_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_ecs_cluster.ecs-jenkins_controller_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_security_group.get_jenkins_agent_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.GetPrivateSubnetObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_linux_agent_image_tag"></a> [docker\_linux\_agent\_image\_tag](#input\_docker\_linux\_agent\_image\_tag) | Docker linux agent image tag | `string` | `"lts"` | no |
| <a name="input_docker_service_image_tag"></a> [docker\_service\_image\_tag](#input\_docker\_service\_image\_tag) | Docker controller image tag | `string` | `"lts"` | no |
| <a name="input_ecs_plugin_name"></a> [ecs\_plugin\_name](#input\_ecs\_plugin\_name) | Name associated with plugin | `string` | `"ecs-cloud"` | no |
| <a name="input_jenkins_agent_name"></a> [jenkins\_agent\_name](#input\_jenkins\_agent\_name) | agent name | `string` | `"Linux_Agent"` | no |
| <a name="input_jenkins_controller_port"></a> [jenkins\_controller\_port](#input\_jenkins\_controller\_port) | n/a | `number` | `8080` | no |
| <a name="input_jenkins_dns_domain_name"></a> [jenkins\_dns\_domain\_name](#input\_jenkins\_dns\_domain\_name) | n/a | `string` | `"jenkins.cluster.local"` | no |
| <a name="input_jenkins_ecr_controller_repository_name"></a> [jenkins\_ecr\_controller\_repository\_name](#input\_jenkins\_ecr\_controller\_repository\_name) | Name for Jenkins controller ECR repository | `string` | `"serverless-jenkins-controller"` | no |
| <a name="input_jenkins_ecr_linux_agent_repository_name"></a> [jenkins\_ecr\_linux\_agent\_repository\_name](#input\_jenkins\_ecr\_linux\_agent\_repository\_name) | Name for Jenkins Linux Agentr ECR repository | `string` | `"serverless-jenkins-linux-agent"` | no |
| <a name="input_jenkins_jnlp_port"></a> [jenkins\_jnlp\_port](#input\_jenkins\_jnlp\_port) | n/a | `number` | `50000` | no |
| <a name="input_jenkins_linux_agent_home_folder"></a> [jenkins\_linux\_agent\_home\_folder](#input\_jenkins\_linux\_agent\_home\_folder) | Jenkins linux agent home folder | `string` | `"/apps/jenkins/jenkins_home"` | no |
| <a name="input_jenkins_linux_agent_root_folder"></a> [jenkins\_linux\_agent\_root\_folder](#input\_jenkins\_linux\_agent\_root\_folder) | Jenkins linux agent Root folder | `string` | `"/apps/jenkins"` | no |
| <a name="input_jenkins_service_home_folder"></a> [jenkins\_service\_home\_folder](#input\_jenkins\_service\_home\_folder) | Jenkins Service home folder | `string` | `"/apps/jenkins/jenkins_home"` | no |
| <a name="input_jenkins_service_hostname"></a> [jenkins\_service\_hostname](#input\_jenkins\_service\_hostname) | Discover service | `string` | `"jenkins_service"` | no |
| <a name="input_jenkins_service_root_folder"></a> [jenkins\_service\_root\_folder](#input\_jenkins\_service\_root\_folder) | Jenkins Service Root folder | `string` | `"/apps/jenkins"` | no |
| <a name="input_jenkins_url"></a> [jenkins\_url](#input\_jenkins\_url) | URL of the service | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | `"serverless-jenkins"` | no |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names) | The tag name of the private subnets to add resources to | `string` | `"Private Subnet*"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-2"` | no |
| <a name="input_service_admin_display_name"></a> [service\_admin\_display\_name](#input\_service\_admin\_display\_name) | Jenkins admin display name | `string` | `"...ADMIN USER DISPLAY NAME...."` | no |
| <a name="input_service_admin_email"></a> [service\_admin\_email](#input\_service\_admin\_email) | Jenkins admin email address | `string` | `"...ADMIN USER NAME....@COMPANY.COM"` | no |
| <a name="input_service_admin_password"></a> [service\_admin\_password](#input\_service\_admin\_password) | Jenkins admin password | `string` | `"...PASSWORD..."` | no |
| <a name="input_service_admin_user_name"></a> [service\_admin\_user\_name](#input\_service\_admin\_user\_name) | Jenkins admin user name | `string` | `"...ADMIN USER NAME...."` | no |
| <a name="input_service_job_display_name"></a> [service\_job\_display\_name](#input\_service\_job\_display\_name) | Jenkins job display name | `string` | `"Job Runner"` | no |
| <a name="input_service_job_email"></a> [service\_job\_email](#input\_service\_job\_email) | Jenkins job email address | `string` | `"jobrunner@{company}.com"` | no |
| <a name="input_service_job_password"></a> [service\_job\_password](#input\_service\_job\_password) | Jenkins job  password | `string` | `"...PASSWORD..."` | no |
| <a name="input_service_job_user_name"></a> [service\_job\_user\_name](#input\_service\_job\_user\_name) | Jenkins job user password | `string` | `"jobrunner"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repo_name"></a> [repo\_name](#output\_repo\_name) | n/a |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | n/a |
| <a name="output_robbsubnets"></a> [robbsubnets](#output\_robbsubnets) | n/a |
<!-- END_TF_DOCS -->