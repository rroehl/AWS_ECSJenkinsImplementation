# Terraform example of AWS Fargate Jenkins platform

# Phase 3: Create the Jenkins Service and Agent Container Images

In Phase 3, the Jenkins service and agent Docker images are created and uploaded into AWS ECR.

Both Jenkins images are created on the users workstation using the Docker tools by running the Terraform scripts. Once the local image is created it will be uploaded to the AWS ECR repository. When the Terraform command is executed, a destroy.sh script is created and it will automatically run when the Terraform command destroy is executed. The destroy script will remove the images from the local Docker repository.

For the Jenkins service, the Docker file is created from a template called Dockerfile.tpl. The Dockerfile template file variables are populated with values when the Terraform is executed. The Service image is created from scratch.

The Dockerfile will:

* Download the Jenkins WAR file from the Internet and its versioned is defined by the Jenkins version variable in Terraform code.
* Define the image directory structure, ports, instance users/groups, access, and environment variables. The Jenkins plugins are preloaded via the Jenkins plugin manager and are defined in the plugin.txt file.
* Copy jenkins-support, jenkins.sh, jenkins-plugin-cli, jenkins-config.sh, plugins.txt, jenkins.yaml, and startup-properties.groovy into the image.
* Define the execution of both jenkins-config.sh and jenkins.sh scripts.

The jenkins.sh script will start the Jenkins service instance Java process, and all jenkins-support script.

The Jenkins-plugin-cli will manages the download and installation of the plugins which are listed in the plugins.txt file. The jenkins-conf.sh will on the first run configure the EFS volumes and not on subsequent runs. The startup-properties.groovy file will execute when Jenkins starts up and will configure the Jenkins system variables.

The Jenkins service state is persisted onto the AWS EFS volume. All files below the Jenkins home folder will be written to the AWS EFS volume.

The Jenkins YAML file is created from the Terraform code and is used by the configuration as code plugin to:

* Create Jenkins users.
* Create and associate authorization groups.
* Configure the AWS ECS plugin (used to create the agents).

![](docs/assets/20230130_153424_diagram_A.drawio.svg)

The Jenkins agent images is configured in the same manner. The docker.tf will subsititute the variables into the Dockerfile template and create the docker file. The remaining process that Terraform performs is the same as the Jenkins Service creation.

The Dockerfile will:

* Create directories create environment variables, file/directory permissions, and add users/groups.
* Download the agent JAR file and configure the running of the jenkins-agent script. The version of the Jenkins agent is define by Jenkins agent variable.
* Copy the jenkins-agent script, which is used to configure the environment and start the agent.

For the agent, there are two AWS EFS mounts created, one for the .jenkins folder and the agent directory under the jenkins home.

The Terraform destroy will perform the same operations as was done with the Jenkins Service image destroy.

Before running Terraform, the Terraform variables will need to be defined:

* service_admin_display_name
* service_admin_user_name
* service_admin_password
* service_admin_email
  and
* service_job_display_name
* service_job_user_name
* service_job_password
* service_job_email

To create the Resources in this phase:
terraform apply  -auto-approve

To destroy the Resources in this phase:
terraform destroy  -auto-approve

[Next... Phase 4: Create the Jenkins Service ECS Tasks on Fargate](https://github.com/rroehl/ECSCreateJenkinsContainer/tree/master/) 

[Return to the parent doc...](https://github.com/rroehl/ECSFargateJenkins/tree/master/)

<!-- BEGIN_TF_DOCS -->

## Requirements


| Name                                                                      | Version  |
| --------------------------------------------------------------------------- | ---------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 4.49  |
| <a name="requirement_local"></a> [local](#requirement\_local)             | ~> 2.3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null)                | ~> 3.2.1 |

## Providers


| Name                                                    | Version |
| --------------------------------------------------------- | --------- |
| <a name="provider_aws"></a> [aws](#provider\_aws)       | 4.52.0  |
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0   |
| <a name="provider_null"></a> [null](#provider\_null)    | 3.2.1   |

## Modules

No modules.

## Resources


| Name                                                                                                                                                 | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------- |
| [local_file.jenkins_yaml_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)                                   | resource    |
| [null_resource.aws_cli_login](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                                 | resource    |
| [null_resource.build_docker_controller_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                 | resource    |
| [null_resource.build_docker_linux_agent_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                | resource    |
| [null_resource.docker_controller_file_render_sed](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)             | resource    |
| [null_resource.docker_linux_agent_file_render_sed](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)            | resource    |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token)          | data source |
| [aws_ecr_repository.get_jenkins_controller_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository)      | data source |
| [aws_ecr_repository.get_jenkins_linux_agent_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository)     | data source |
| [aws_ecs_cluster.ecs-jenkins_controller_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster)         | data source |
| [aws_security_group.get_jenkins_agent_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.GetPrivateSubnetObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)                           | data source |

## Inputs


| Name                                                                                                                                                              | Description                                             | Type     | Default                                | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- | ---------- | ---------------------------------------- | :--------: |
| <a name="input_docker_linux_agent_image_tag"></a> [docker\_linux\_agent\_image\_tag](#input\_docker\_linux\_agent\_image\_tag)                                    | Docker linux agent image tag                            | `string` | `"lts"`                                |    no    |
| <a name="input_docker_service_image_tag"></a> [docker\_service\_image\_tag](#input\_docker\_service\_image\_tag)                                                  | Docker controller image tag                             | `string` | `"lts"`                                |    no    |
| <a name="input_ecs_plugin_name"></a> [ecs\_plugin\_name](#input\_ecs\_plugin\_name)                                                                               | Name associated with plugin                             | `string` | `"ecs-cloud"`                          |    no    |
| <a name="input_jenkins_agent_name"></a> [jenkins\_agent\_name](#input\_jenkins\_agent\_name)                                                                      | agent name                                              | `string` | `"Linux_Agent"`                        |    no    |
| <a name="input_jenkins_controller_port"></a> [jenkins\_controller\_port](#input\_jenkins\_controller\_port)                                                       | n/a                                                     | `number` | `8080`                                 |    no    |
| <a name="input_jenkins_dns_domain_name"></a> [jenkins\_dns\_domain\_name](#input\_jenkins\_dns\_domain\_name)                                                     | n/a                                                     | `string` | `"jenkins.cluster.local"`              |    no    |
| <a name="input_jenkins_ecr_controller_repository_name"></a> [jenkins\_ecr\_controller\_repository\_name](#input\_jenkins\_ecr\_controller\_repository\_name)      | Name for Jenkins controller ECR repository              | `string` | `"serverless-jenkins-controller"`      |    no    |
| <a name="input_jenkins_ecr_linux_agent_repository_name"></a> [jenkins\_ecr\_linux\_agent\_repository\_name](#input\_jenkins\_ecr\_linux\_agent\_repository\_name) | Name for Jenkins Linux Agentr ECR repository            | `string` | `"serverless-jenkins-linux-agent"`     |    no    |
| <a name="input_jenkins_jnlp_port"></a> [jenkins\_jnlp\_port](#input\_jenkins\_jnlp\_port)                                                                         | n/a                                                     | `number` | `50000`                                |    no    |
| <a name="input_jenkins_linux_agent_home_folder"></a> [jenkins\_linux\_agent\_home\_folder](#input\_jenkins\_linux\_agent\_home\_folder)                           | Jenkins linux agent home folder                         | `string` | `"/apps/jenkins/jenkins_home"`         |    no    |
| <a name="input_jenkins_linux_agent_root_folder"></a> [jenkins\_linux\_agent\_root\_folder](#input\_jenkins\_linux\_agent\_root\_folder)                           | Jenkins linux agent Root folder                         | `string` | `"/apps/jenkins"`                      |    no    |
| <a name="input_jenkins_service_home_folder"></a> [jenkins\_service\_home\_folder](#input\_jenkins\_service\_home\_folder)                                         | Jenkins Service home folder                             | `string` | `"/apps/jenkins/jenkins_home"`         |    no    |
| <a name="input_jenkins_service_hostname"></a> [jenkins\_service\_hostname](#input\_jenkins\_service\_hostname)                                                    | Discover service                                        | `string` | `"jenkins_service"`                    |    no    |
| <a name="input_jenkins_service_root_folder"></a> [jenkins\_service\_root\_folder](#input\_jenkins\_service\_root\_folder)                                         | Jenkins Service Root folder                             | `string` | `"/apps/jenkins"`                      |    no    |
| <a name="input_jenkins_url"></a> [jenkins\_url](#input\_jenkins\_url)                                                                                             | URL of the service                                      | `string` | `""`                                   |    no    |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)                                                                                             | n/a                                                     | `string` | `"serverless-jenkins"`                 |    no    |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names)                                                                | The tag name of the private subnets to add resources to | `string` | `"Private Subnet*"`                    |    no    |
| <a name="input_region"></a> [region](#input\_region)                                                                                                              | AWS Region                                              | `string` | `"us-east-2"`                          |    no    |
| <a name="input_service_admin_display_name"></a> [service\_admin\_display\_name](#input\_service\_admin\_display\_name)                                            | Jenkins admin display name                              | `string` | `"...ADMIN USER DISPLAY NAME...."`     |    no    |
| <a name="input_service_admin_email"></a> [service\_admin\_email](#input\_service\_admin\_email)                                                                   | Jenkins admin email address                             | `string` | `"...ADMIN USER NAME....@COMPANY.COM"` |    no    |
| <a name="input_service_admin_password"></a> [service\_admin\_password](#input\_service\_admin\_password)                                                          | Jenkins admin password                                  | `string` | `"...PASSWORD..."`                     |    no    |
| <a name="input_service_admin_user_name"></a> [service\_admin\_user\_name](#input\_service\_admin\_user\_name)                                                     | Jenkins admin user name                                 | `string` | `"...ADMIN USER NAME...."`             |    no    |
| <a name="input_service_job_display_name"></a> [service\_job\_display\_name](#input\_service\_job\_display\_name)                                                  | Jenkins job display name                                | `string` | `"Job Runner"`                         |    no    |
| <a name="input_service_job_email"></a> [service\_job\_email](#input\_service\_job\_email)                                                                         | Jenkins job email address                               | `string` | `"jobrunner@{company}.com"`               |    no    |
| <a name="input_service_job_password"></a> [service\_job\_password](#input\_service\_job\_password)                                                                | Jenkins job  password                                   | `string` | `"...PASSWORD..."`                     |    no    |
| <a name="input_service_job_user_name"></a> [service\_job\_user\_name](#input\_service\_job\_user\_name)                                                           | Jenkins job user password                               | `string` | `"jobrunner"`                          |    no    |

## Outputs


| Name                                                                             | Description |
| ---------------------------------------------------------------------------------- | ------------- |
| <a name="output_repo_name"></a> [repo\_name](#output\_repo\_name)                | n/a         |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | n/a         |
| <a name="output_robbsubnets"></a> [robbsubnets](#output\_robbsubnets)            | n/a         |

<!-- END_TF_DOCS -->
