# Terraform example of AWS Fargate Jenkins platform

# Phase 4: Create the Jenkins Service ECS Tasks on Fargate

In Phase 4, the Terraform scripts will start the Jenkins Service as an ECS Task.

The AWS ECS Service uses the pre-defined task definition to create the service/task from the images stored in the ECR.

The ECS service will register its IP address with the AWS service discovery service so that the Jenkins Agent tasks can locate it.

The AWS Elastic Load Balancer is configured to send HTTP traffic to the Jenkins Service container in any Availability Zone that the container resides. The Load Balancer ensures Jenkins fail over to another AWS availability zone.

The last part of the ECS configuration defines which subnets or Availability Zones the Jenkins Service container can run in.

To Create the Resources in this phase:
terraform apply  -auto-approve

To destroy the Resources in this phase:
terraform destroy  -auto-approve

[Return to the parent doc...](https://github.com/rroehl/AWS_ECSJenkinsImplementation/)

![](docs/assets/20230131_143826_diagramB.drawio.svg)

<!-- BEGIN_TF_DOCS -->

## Requirements


| Name                                                                      | Version  |
| --------------------------------------------------------------------------- | ---------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 4.49  |

## Providers


| Name                                              | Version |
| --------------------------------------------------- | --------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.53.0  |

## Modules

No modules.

## Resources


| Name                                                                                                                                                                        | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| [aws_ecs_service.jenkins_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)                                               | resource    |
| [aws_ecs_cluster.ecs-jenkins_controller_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster)                                | data source |
| [aws_ecs_task_definition.jenkins_controller_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition)            | data source |
| [aws_efs_access_points.get_service_efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_points)                      | data source |
| [aws_efs_file_system.get_jenkins_service_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_file_system)                               | data source |
| [aws_lb_target_group.get_app_lb_targetgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group)                                | data source |
| [aws_security_group.get_jenkins_controller_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)                   | data source |
| [aws_service_discovery_dns_namespace.get_private_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/service_discovery_dns_namespace) | data source |
| [aws_service_discovery_service.get_jenkins_discovery_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/service_discovery_service)     | data source |
| [aws_subnets.GetPrivateSubnetObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)                                                  | data source |

## Inputs


| Name                                                                                                             | Description                                             | Type     | Default                   | Required |
| ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- | ---------- | --------------------------- | :--------: |
| <a name="input_jenkins_controller_port"></a> [jenkins\_controller\_port](#input\_jenkins\_controller\_port)      | n/a                                                     | `number` | `8080`                    |    no    |
| <a name="input_jenkins_dns_domain_name"></a> [jenkins\_dns\_domain\_name](#input\_jenkins\_dns\_domain\_name)    | n/a                                                     | `string` | `"jenkins.cluster.local"` |    no    |
| <a name="input_jenkins_jnlp_port"></a> [jenkins\_jnlp\_port](#input\_jenkins\_jnlp\_port)                        | n/a                                                     | `number` | `50000`                   |    no    |
| <a name="input_jenkins_service_efs_name"></a> [jenkins\_service\_efs\_name](#input\_jenkins\_service\_efs\_name) | Jenkins EFS file system                                 | `string` | `"jenkins_service_efs"`   |    no    |
| <a name="input_jenkins_service_hostname"></a> [jenkins\_service\_hostname](#input\_jenkins\_service\_hostname)   | Discovery service                                       | `string` | `"jenkins_service"`       |    no    |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)                                            | alb                                                     | `string` | `"serverless-jenkins"`    |    no    |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names)               | The tag name of the private subnets to add resources to | `string` | `"Private Subnet*"`       |    no    |
| <a name="input_region"></a> [region](#input\_region)                                                             | AWS Region                                              | `string` | `"us-east-2"`             |    no    |

## Outputs


| Name                                                                                                                                | Description               |
| ------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| <a name="output_container_subnets_objs"></a> [container\_subnets\_objs](#output\_container\_subnets\_objs)                          | n/a                       |
| <a name="output_service_efs_access_points_ids"></a> [service\_efs\_access\_points\_ids](#output\_service\_efs\_access\_points\_ids) | EFS Files systemr         |
| <a name="output_service_efs_file_system"></a> [service\_efs\_file\_system](#output\_service\_efs\_file\_system)                     | Service EFS Files systemr |

<!-- END_TF_DOCS -->
