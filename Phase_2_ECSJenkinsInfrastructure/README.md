# Terraform example of AWS Fargate Jenkins platform

# Phase 2: Configure the Application Infrastructure

In Phase 2, the application specific infrastructure is configured.

The AWS Load Balancer is configured to support HTTP to the Jenkins service container. Currently, only HTTP is supported and can be upgraded to support HTTPS. Since the Jenkins service container is only active in one availability zone at a time, the AWS LB will ensure redirection to the other availability zone if a availability zone failure occurs. The failover is configured within the AWS Load Balancer service. If HTTPS is configured, it will manage the certificates.

The AWS Cloudwatch service is created to gather container logs from both the Jenkins agent and service. The AWS Service Discovery Private DNS Namespace resource is created to allow the Jenkins agents to resolve the DNS name a of the Jenkins service container. When the Jenkins service container is created, it will register its dynamic IP with the namespace.

The AWS Elastic Container Registry service is configured to managed the Jenkins service and agent task/container images.![](docs/assets/20230131_143826_diagramB.drawio.svg)

The AWS Elastic Container Service is created with two ECS Task Definitions, one for the Jenkins service and the other for the agent, and will use AWS Fargate. The task definition files start as templates whose parameters are populated with Terraform variable values.

Since the AWS ECS tasks are ephemeral both the Jenkins's service and agent application state is persisted to AWS Elastic File System, which is a Unix NFS storage system. The Jenkins service has a single mount and the agents has two file mounts.

The AWS IAM policies created with Terraform are for the ECS components and are confusing. The policy structure should be refactored.

In order to internally access AWS service such as Cloudwatch, ECR, and S3, and not external via the Internet, AWS endpoints are configure for all the AWS services.

For AWS LoadBalancer,the Jenkins server/agent tasks, EFS, and Endpoints, Security Groups are associated to enforce ingress and egress points.

To create the Resources in this phase:
terraform apply  -auto-approve

To destroy the Resources in this phase:
terraform destroy  -auto-approve

[Next... Phase 3: Create the Jenkins Service and Agent Container Images](https://github.com/rroehl/ECSDockerJenkinsContainer/tree/master/) 

[Return to the parent doc...](https://github.com/rroehl/ECSFargateJenkins/tree/master/)

<!-- BEGIN_TF_DOCS -->

## Requirements


| Name                                                                      | Version |
| --------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 4.49 |

## Providers


| Name                                              | Version |
| --------------------------------------------------- | --------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.49.0  |

## Modules

No modules.

## Resources


| Name                                                                                                                                                                                 | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| [aws_cloudwatch_log_group.jenkins_controller_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                            | resource    |
| [aws_ecr_repository.jenkins_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)                                                  | resource    |
| [aws_ecr_repository.jenkins_linux_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)                                                 | resource    |
| [aws_ecr_repository_policy.jenkins-controller-repo-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy)                        | resource    |
| [aws_ecr_repository_policy.jenkins-linux-agent-repo-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy)                       | resource    |
| [aws_ecs_cluster.jenkins_controller_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)                                                | resource    |
| [aws_ecs_task_definition.jenkins_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                                             | resource    |
| [aws_ecs_task_definition.jenkins_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                                        | resource    |
| [aws_efs_access_point.jenkins_agent_dot_jenkins_efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point)                      | resource    |
| [aws_efs_access_point.jenkins_agent_work_dir_efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point)                         | resource    |
| [aws_efs_access_point.jenkins_service_efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point)                                | resource    |
| [aws_efs_file_system.jenkins_agent_dot_jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)                                     | resource    |
| [aws_efs_file_system.jenkins_agent_work_dir_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)                                        | resource    |
| [aws_efs_file_system.jenkins_service_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)                                               | resource    |
| [aws_efs_mount_target.jenkins_agent_dot_efs_mount_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target)                             | resource    |
| [aws_efs_mount_target.jenkins_agent_work_dir_efs_mount_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target)                        | resource    |
| [aws_efs_mount_target.jenkins_service_efs_mount_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target)                               | resource    |
| [aws_iam_policy.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                                        | resource    |
| [aws_iam_policy.jenkins_controller_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                              | resource    |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                              | resource    |
| [aws_iam_role.jenkins_controller_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                    | resource    |
| [aws_iam_role_policy_attachment.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)                               | resource    |
| [aws_iam_role_policy_attachment.jenkins_controller_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)                     | resource    |
| [aws_lb.app_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)                                                                                      | resource    |
| [aws_lb_listener.http_app_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)                                                      | resource    |
| [aws_lb_target_group.app_lb_targetgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)                                                | resource    |
| [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                  | resource    |
| [aws_security_group.ecr_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                         | resource    |
| [aws_security_group.ecs_agent_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                   | resource    |
| [aws_security_group.ecs_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                         | resource    |
| [aws_security_group.ecs_telemetry_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                               | resource    |
| [aws_security_group.jenkins_agent_efs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                    | resource    |
| [aws_security_group.jenkins_agent_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                        | resource    |
| [aws_security_group.jenkins_controller_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                   | resource    |
| [aws_security_group.jenkins_service_efs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                  | resource    |
| [aws_security_group.ssm_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                         | resource    |
| [aws_security_group.ssm_messages_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                | resource    |
| [aws_service_discovery_private_dns_namespace.private_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource    |
| [aws_service_discovery_service.jenkins_discovery_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service)                     | resource    |
| [aws_vpc_endpoint.cloudwatch_logs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                | resource    |
| [aws_vpc_endpoint.ecr_api_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                        | resource    |
| [aws_vpc_endpoint.ecr_dkr_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                        | resource    |
| [aws_vpc_endpoint.ecr_s3_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                         | resource    |
| [aws_vpc_endpoint.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                                     | resource    |
| [aws_vpc_endpoint.ecs_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                               | resource    |
| [aws_vpc_endpoint.ecs_telemetry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                           | resource    |
| [aws_vpc_endpoint.ssm_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                            | resource    |
| [aws_vpc_endpoint.ssm_messages_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)                                                   | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                                        | data source |
| [aws_iam_policy_document.ecs_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                                      | data source |
| [aws_iam_policy_document.ecs_execution_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                            | data source |
| [aws_iam_policy_document.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                                   | data source |
| [aws_iam_policy_document.jenkins_controller_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                         | data source |
| [aws_route_tables.GetObjectPrivateRouteTablesObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables)                                      | data source |
| [aws_security_group.get_sg_private_to_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)                                            | data source |
| [aws_subnets.GetPrivateSubnetObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)                                                           | data source |
| [aws_subnets.GetPublicSubnetObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)                                                            | data source |
| [aws_vpc.GetVPCObject](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                                                                           | data source |

## Inputs


| Name                                                                                                                                                                       | Description                                                         | Type     | Default                            | Required |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ---------- | ------------------------------------ | :--------: |
| <a name="input_SampleCidrBlock"></a> [SampleCidrBlock](#input\_SampleCidrBlock)                                                                                            | VPC Cidr Block                                                      | `string` | `"10.250.0.0/16"`                  |    no    |
| <a name="input_alb_type_internal"></a> [alb\_type\_internal](#input\_alb\_type\_internal)                                                                                  | alb                                                                 | `bool`   | `false`                            |    no    |
| <a name="input_docker_linux_agent_image_tag"></a> [docker\_linux\_agent\_image\_tag](#input\_docker\_linux\_agent\_image\_tag)                                             | Docker linux agent image tag                                        | `string` | `"lts"`                            |    no    |
| <a name="input_efs_access_point_gid"></a> [efs\_access\_point\_gid](#input\_efs\_access\_point\_gid)                                                                       | The gid number to associate with the EFS access point               | `number` | `1000`                             |    no    |
| <a name="input_efs_access_point_uid"></a> [efs\_access\_point\_uid](#input\_efs\_access\_point\_uid)                                                                       | The uid number to associate with the EFS access point               | `number` | `1000`                             |    no    |
| <a name="input_efs_enable_encryption"></a> [efs\_enable\_encryption](#input\_efs\_enable\_encryption)                                                                      | EFS                                                                 | `bool`   | `true`                             |    no    |
| <a name="input_efs_ia_lifecycle_policy"></a> [efs\_ia\_lifecycle\_policy](#input\_efs\_ia\_lifecycle\_policy)                                                              | n/a                                                                 | `string` | `null`                             |    no    |
| <a name="input_efs_kms_key_arn"></a> [efs\_kms\_key\_arn](#input\_efs\_kms\_key\_arn)                                                                                      | n/a                                                                 | `string` | `null`                             |    no    |
| <a name="input_efs_performance_mode"></a> [efs\_performance\_mode](#input\_efs\_performance\_mode)                                                                         | n/a                                                                 | `string` | `"generalPurpose"`                 |    no    |
| <a name="input_efs_provisioned_throughput_in_mibps"></a> [efs\_provisioned\_throughput\_in\_mibps](#input\_efs\_provisioned\_throughput\_in\_mibps)                        | n/a                                                                 | `number` | `null`                             |    no    |
| <a name="input_efs_throughput_mode"></a> [efs\_throughput\_mode](#input\_efs\_throughput\_mode)                                                                            | n/a                                                                 | `string` | `"bursting"`                       |    no    |
| <a name="input_jenkins_agent_cpu"></a> [jenkins\_agent\_cpu](#input\_jenkins\_agent\_cpu)                                                                                  | n/a                                                                 | `number` | `2048`                             |    no    |
| <a name="input_jenkins_agent_dot_jenkins_efs_name"></a> [jenkins\_agent\_dot\_jenkins\_efs\_name](#input\_jenkins\_agent\_dot\_jenkins\_efs\_name)                         | Jenkins agent .jenkins EFS file system                              | `string` | `"jenkins_agent_dot_jenkins_efs"`  |    no    |
| <a name="input_jenkins_agent_dot_jenkins_efs_token"></a> [jenkins\_agent\_dot\_jenkins\_efs\_token](#input\_jenkins\_agent\_dot\_jenkins\_efs\_token)                      | Jenkins agent dot jenkins EFS token for creation and volume name    | `string` | `"agent-dot-jenkins-fs"`           |    no    |
| <a name="input_jenkins_agent_memory"></a> [jenkins\_agent\_memory](#input\_jenkins\_agent\_memory)                                                                         | n/a                                                                 | `number` | `4096`                             |    no    |
| <a name="input_jenkins_agent_work_dir_efs_name"></a> [jenkins\_agent\_work\_dir\_efs\_name](#input\_jenkins\_agent\_work\_dir\_efs\_name)                                  | Jenkins agent workdir EFS file system                               | `string` | `"jenkins_agent_work_dir_efs"`     |    no    |
| <a name="input_jenkins_agent_work_dir_fs_efs_token"></a> [jenkins\_agent\_work\_dir\_fs\_efs\_token](#input\_jenkins\_agent\_work\_dir\_fs\_efs\_token)                    | Jenkins agent work directory EFS token for creation and volume name | `string` | `"agent-work-dir-fs"`              |    no    |
| <a name="input_jenkins_controller_cpu"></a> [jenkins\_controller\_cpu](#input\_jenkins\_controller\_cpu)                                                                   | n/a                                                                 | `number` | `2048`                             |    no    |
| <a name="input_jenkins_controller_image_tag"></a> [jenkins\_controller\_image\_tag](#input\_jenkins\_controller\_image\_tag)                                               | n/a                                                                 | `string` | `"lts"`                            |    no    |
| <a name="input_jenkins_controller_memory"></a> [jenkins\_controller\_memory](#input\_jenkins\_controller\_memory)                                                          | n/a                                                                 | `number` | `4096`                             |    no    |
| <a name="input_jenkins_controller_port"></a> [jenkins\_controller\_port](#input\_jenkins\_controller\_port)                                                                | n/a                                                                 | `number` | `8080`                             |    no    |
| <a name="input_jenkins_controller_task_log_retention_days"></a> [jenkins\_controller\_task\_log\_retention\_days](#input\_jenkins\_controller\_task\_log\_retention\_days) | Cloudwatch                                                          | `number` | `30`                               |    no    |
| <a name="input_jenkins_dns_domain_name"></a> [jenkins\_dns\_domain\_name](#input\_jenkins\_dns\_domain\_name)                                                              | n/a                                                                 | `string` | `"jenkins.cluster.local"`          |    no    |
| <a name="input_jenkins_ecr_controller_repository_name"></a> [jenkins\_ecr\_controller\_repository\_name](#input\_jenkins\_ecr\_controller\_repository\_name)               | Name for Jenkins controller ECR repository                          | `string` | `"serverless-jenkins-controller"`  |    no    |
| <a name="input_jenkins_ecr_linux_agent_repository_name"></a> [jenkins\_ecr\_linux\_agent\_repository\_name](#input\_jenkins\_ecr\_linux\_agent\_repository\_name)          | Name for Jenkins Linux Agentr ECR repository                        | `string` | `"serverless-jenkins-linux-agent"` |    no    |
| <a name="input_jenkins_jnlp_port"></a> [jenkins\_jnlp\_port](#input\_jenkins\_jnlp\_port)                                                                                  | n/a                                                                 | `number` | `50000`                            |    no    |
| <a name="input_jenkins_linux_agent_home_folder"></a> [jenkins\_linux\_agent\_home\_folder](#input\_jenkins\_linux\_agent\_home\_folder)                                    | Jenkins linux agent home folder                                     | `string` | `"/apps/jenkins/jenkins_home"`     |    no    |
| <a name="input_jenkins_service_efs_name"></a> [jenkins\_service\_efs\_name](#input\_jenkins\_service\_efs\_name)                                                           | Jenkins service EFS file system                                     | `string` | `"jenkins_service_efs"`            |    no    |
| <a name="input_jenkins_service_efs_token"></a> [jenkins\_service\_efs\_token](#input\_jenkins\_service\_efs\_token)                                                        | Jenkins service EFS token for creation and volume name              | `string` | `"service-efs"`                    |    no    |
| <a name="input_jenkins_service_home_folder"></a> [jenkins\_service\_home\_folder](#input\_jenkins\_service\_home\_folder)                                                  | Jenkins Service home folder                                         | `string` | `"/apps/jenkins/jenkins_home"`     |    no    |
| <a name="input_jenkins_service_hostname"></a> [jenkins\_service\_hostname](#input\_jenkins\_service\_hostname)                                                             | Discover service                                                    | `string` | `"jenkins_service"`                |    no    |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)                                                                                                      | n/a                                                                 | `string` | `"serverless-jenkins"`             |    no    |
| <a name="input_private_route_table_prefix"></a> [private\_route\_table\_prefix](#input\_private\_route\_table\_prefix)                                                     | Private Route Table lable prefix                                    | `string` | `"Private_Internal_Route_Table_"`  |    no    |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names)                                                                         | The tag name of the private subnets to add resources to             | `string` | `"Private Subnet*"`                |    no    |
| <a name="input_private_to_efs"></a> [private\_to\_efs](#input\_private\_to\_efs)                                                                                           | tag name of SG private to EFS                                       | `string` | `"Private_Instance_to_EFS"`        |    no    |
| <a name="input_public_subnet_names"></a> [public\_subnet\_names](#input\_public\_subnet\_names)                                                                            | The tag name of the public subnets to add resources to              | `string` | `"Public Subnet*"`                 |    no    |
| <a name="input_region"></a> [region](#input\_region)                                                                                                                       | AWS Region                                                          | `string` | `"us-east-2"`                      |    no    |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)                                                                                                               | The tag name of the VPC to add resources to                         | `string` | `"VPC Public A"`                   |    no    |
| <a name="input_white_list_ip"></a> [white\_list\_ip](#input\_white\_list\_ip)                                                                                              | home traffic                                                        | `string` | `"24.23.232.215/32"`               |    no    |

## Outputs


| Name                                                                                         | Description |
| ---------------------------------------------------------------------------------------------- | ------------- |
| <a name="output_MyPublicSubnetA_ID"></a> [MyPublicSubnetA\_ID](#output\_MyPublicSubnetA\_ID) | Subnet ID   |
| <a name="output_MyPublicSubnetB_ID"></a> [MyPublicSubnetB\_ID](#output\_MyPublicSubnetB\_ID) | Subnet ID   |
| <a name="output_MyVPCID"></a> [MyVPCID](#output\_MyVPCID)                                    | VPC ID      |

<!-- END_TF_DOCS -->
