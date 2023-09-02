# Terraform example of AWS Fargate Jenkins platform

# Phase 1 Configure the Base Infrastructure

The default VPC is created in the US-east2 region and can easily be created in other regions. All of the AWS resources and Jenkins configurations is set by Terraform declarations or variables.

A single VPC is created with four subnets. A public and private subnets in one AZ and another public and private subnets in the other AZ.  Route tables are associated with each subnet and the two public subnets have a internet gateways attached and route configured to the internet so it can be accessed from an external IP. Only the public subnets have direct access to the Internet. The private subnets have access to the to the public subnets but not directly to the Internet. The public subnets can route to the private subnets. However, the Security Groups control the access to resources.

![](docs/assets/20230130_153424_diagram_A.drawio.svg)

In each subnet, a Free Tier Linux EC2 instance is created for testing purposes such as routing and Security Group access verification. To save on costs, the instances are shut down after creating them.

The Jenkins service and agent images are created by the user via Docker and uploaded to AWS ECR and occurs in a later phase.

The ECS Fargate tasks and EFS storage reside in the private subnets. During the task instantiation the startup processes need access to  Internet resources which is done via the NAT Gateway.

Security groups are configured for to ensure SSH/HTTP from an external IP to the public Linux 1 and 2 instances, and AWS load balancer. From the public linux instances a user can SSH to the private linux. Routing and Security Groups are configured so that the public linux instances can network with the private instances. The VPC has an internet gateway assigned so that the public subnets can be contacted from the Internet. NAT services are attached to the public subnets to allow the private subnets to access the Internet.

NAT services are expensive to run and if they are not longer needed the services should be terminated.

Before running Terraform for phase one, the Terraform variables will need to be defined:

* user_source_ip   - The user source IP address which is allowed to either HTTP to Jenkins or SSH into the Linux instances.

To Create the Resources in this phase:
terraform apply  -auto-approve

To destroy the Resources in this phase:
terraform destroy  -auto-approve

[Next... Phase 2: Configure the Application Infrastructure](https://github.com/rroehl/ECSJenkinsInfrastructure/tree/master/)
<!-- BEGIN_TF_DOCS -->

## Requirements


| Name                                                                      | Version  |
| --------------------------------------------------------------------------- | ---------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0   |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 4.49  |
| <a name="requirement_null"></a> [null](#requirement\_null)                | ~> 3.2.1 |

## Providers


| Name                                                 | Version |
| ------------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider\_aws)    | 4.52.0  |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1   |

## Modules

No modules.

## Resources


| Name                                                                                                                                                                           | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| [aws_eip.NatGatewayAIP](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                                       | resource    |
| [aws_iam_role.RootRole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                                  | resource    |
| [aws_instance.PrivateLinux1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                             | resource    |
| [aws_instance.PrivateLinux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                             | resource    |
| [aws_instance.PublicLinux1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                              | resource    |
| [aws_instance.PublicLinux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                              | resource    |
| [aws_internet_gateway.PublicInternetGateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                     | resource    |
| [aws_nat_gateway.NatGateWay1A](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)                                                        | resource    |
| [aws_route.PublicAddIGWToRoute1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                            | resource    |
| [aws_route.PublicAddIGWToRoute2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                            | resource    |
| [aws_route.PublicAddNatGWToRoute1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                          | resource    |
| [aws_route.PublicAddNatGWToRoute2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                          | resource    |
| [aws_route_table.PrivateInternalRouteTable1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                          | resource    |
| [aws_route_table.PrivateInternalRouteTable2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                          | resource    |
| [aws_route_table.PublicInternalRouteTable1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                           | resource    |
| [aws_route_table.PublicInternalRouteTable2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                           | resource    |
| [aws_route_table_association.PrivateSubNet1InternalRouteTableAssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_route_table_association.PrivateSubNet2InternalRouteTableAssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_route_table_association.PublicSubNet1InternalRouteTableAssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)  | resource    |
| [aws_route_table_association.PublicSubNet2InternalRouteTableAssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)  | resource    |
| [aws_security_group.AllInternalSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                      | resource    |
| [aws_security_group.HTTPExternalSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                     | resource    |
| [aws_security_group.HTTPOutBoundSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                     | resource    |
| [aws_security_group.PingExternalInboundSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                              | resource    |
| [aws_security_group.PingInternalInboundSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                              | resource    |
| [aws_security_group.PingInternalOutboundSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                             | resource    |
| [aws_security_group.PrivateSSHSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                       | resource    |
| [aws_security_group.PublicSSHSecurityGroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                        | resource    |
| [aws_security_group.private_to_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                | resource    |
| [aws_subnet.PrivateSubNet1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                | resource    |
| [aws_subnet.PrivateSubNet2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                | resource    |
| [aws_subnet.PublicSubNet1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource    |
| [aws_subnet.PublicSubNet2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource    |
| [aws_vpc.SampleVPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                           | resource    |
| [null_resource.stop_ec2_instances](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                                                      | resource    |
| [aws_iam_policy_document.RootRole-policy-doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                              | data source |
| [aws_route_tables.GetObjectPrivateRouteTablesObjs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables)                                | data source |

## Inputs


| Name                                                                                                                   | Description                                                | Type               | Default                                                                                                                                                                                                                                                                                        | Required |
| ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :--------: |
| <a name="input_AZMap"></a> [AZMap](#input\_AZMap)                                                                      | AWS AZ in in Regions for Public and Private Networks       | `map(map(string))` | <pre>{<br>  "us-east-2": {<br>    "A": "us-east-2a",<br>    "B": "us-east-2b",<br>    "C": "us-east-2c"<br>  },<br>  "us-west-2": {<br>    "A": "us-west-2a",<br>    "B": "us-west-2b",<br>    "C": "us-west-2c"<br>  }<br>}</pre>                                                             |    no    |
| <a name="input_EC2InstanceIPAddress"></a> [EC2InstanceIPAddress](#input\_EC2InstanceIPAddress)                         | Linux IP for Public and Private in AZ 1,2,3                | `map(map(string))` | <pre>{<br>  "Private": {<br>    "A": "10.250.18.15",<br>    "B": "10.250.20.15",<br>    "C": "10.250.22.15"<br>  },<br>  "Public": {<br>    "A": "10.250.12.15",<br>    "B": "10.250.14.15",<br>    "C": "10.250.16.15"<br>  }<br>}</pre>                                                      |    no    |
| <a name="input_FirstAvailabilityZoneIndex"></a> [FirstAvailabilityZoneIndex](#input\_FirstAvailabilityZoneIndex)       | Platform 1 AZ letter A,B, or C for Public or Private       | `string`           | `"A"`                                                                                                                                                                                                                                                                                          |    no    |
| <a name="input_InstanceType"></a> [InstanceType](#input\_InstanceType)                                                 | Domain Controller node Instance Type                       | `string`           | `"t2.micro"`                                                                                                                                                                                                                                                                                   |    no    |
| <a name="input_KeyName"></a> [KeyName](#input\_KeyName)                                                                | Name of Existing EC2 KeyPair                               | `string`           | `"Instance"`                                                                                                                                                                                                                                                                                   |    no    |
| <a name="input_NetworkTypeA"></a> [NetworkTypeA](#input\_NetworkTypeA)                                                 | Public Subnet                                              | `string`           | `"Public"`                                                                                                                                                                                                                                                                                     |    no    |
| <a name="input_NetworkTypeB"></a> [NetworkTypeB](#input\_NetworkTypeB)                                                 | Sample Public or Private                                   | `string`           | `"Private"`                                                                                                                                                                                                                                                                                    |    no    |
| <a name="input_RegionInstanceMap"></a> [RegionInstanceMap](#input\_RegionInstanceMap)                                  | Region AMIs  for Public and Private networks               | `map(map(string))` | <pre>{<br>  "us-east-2": {<br>    "Private": "ami-0277b52859bac6f4b",<br>    "Public": "ami-0277b52859bac6f4b"<br>  },<br>  "us-west-2": {<br>    "Private": "ami-0277b52859bac6f4b",<br>    "Public": "ami-0277b52859bac6f4b"<br>  }<br>}</pre>                                               |    no    |
| <a name="input_SampleCidrBlock"></a> [SampleCidrBlock](#input\_SampleCidrBlock)                                        | VPC Cidr Block                                             | `string`           | `"10.250.0.0/16"`                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_SecondAvailabilityZoneIndex"></a> [SecondAvailabilityZoneIndex](#input\_SecondAvailabilityZoneIndex)    | Platform 2 AZ letter A,B, or C for Public and Private      | `string`           | `"B"`                                                                                                                                                                                                                                                                                          |    no    |
| <a name="input_SubnetMap"></a> [SubnetMap](#input\_SubnetMap)                                                          | Subnets in Zones A,B,and C for Public and Private Networks | `map(map(string))` | <pre>{<br>  "A": {<br>    "Private": "10.250.18.0/23",<br>    "Public": "10.250.12.0/23"<br>  },<br>  "B": {<br>    "Private": "10.250.20.0/23",<br>    "Public": "10.250.14.0/23"<br>  },<br>  "C": {<br>    "Private": "10.250.22.0/23",<br>    "Public": "10.250.16.0/23"<br>  }<br>}</pre> |    no    |
| <a name="input_private_route_table_prefix"></a> [private\_route\_table\_prefix](#input\_private\_route\_table\_prefix) | Private Route Table lable prefix                           | `string`           | `"Private_Internal_Route_Table_"`                                                                                                                                                                                                                                                              |    no    |
| <a name="input_private_to_efs"></a> [private\_to\_efs](#input\_private\_to\_efs)                                       | tag name of SG private to EFS                              | `string`           | `"Private_Instance_to_EFS"`                                                                                                                                                                                                                                                                    |    no    |
| <a name="input_region"></a> [region](#input\_region)                                                                   | AWS Region                                                 | `string`           | `"us-east-2"`                                                                                                                                                                                                                                                                                  |    no    |
| <a name="input_user_source_ip"></a> [user\_source\_ip](#input\_user\_source\_ip)                                       | RDP Source IP                                              | `string`           | `"...USER'S SOURCE IP ADDRESS.../32"`                                                                                                                                                                                                                                                          |    no    |

## Outputs


| Name                                                                                                               | Description                            |
| -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| <a name="output_AWS_Region"></a> [AWS\_Region](#output\_AWS\_Region)                                               | AWS region                             |
| <a name="output_AvailabilityZone1"></a> [AvailabilityZone1](#output\_AvailabilityZone1)                            | Sample Availability Zone               |
| <a name="output_AvailabilityZone2"></a> [AvailabilityZone2](#output\_AvailabilityZone2)                            | Sample Availability Zone               |
| <a name="output_KeyName"></a> [KeyName](#output\_KeyName)                                                          | Sample Key Name                        |
| <a name="output_MyCurrentSourceIP"></a> [MyCurrentSourceIP](#output\_MyCurrentSourceIP)                            | My source IP                           |
| <a name="output_PlatformA"></a> [PlatformA](#output\_PlatformA)                                                    | RM Public, PrivatePlatform             |
| <a name="output_PlatformB"></a> [PlatformB](#output\_PlatformB)                                                    | RM Public, Private, or Shared Platform |
| <a name="output_PrivateInstance1-PrivateIP"></a> [PrivateInstance1-PrivateIP](#output\_PrivateInstance1-PrivateIP) | Private Instance1 Private IP           |
| <a name="output_PrivateInstance2-PrivateIP"></a> [PrivateInstance2-PrivateIP](#output\_PrivateInstance2-PrivateIP) | Private Instance2 Private IP           |
| <a name="output_PrivateSubnetName1"></a> [PrivateSubnetName1](#output\_PrivateSubnetName1)                         | Private Subnet 1                       |
| <a name="output_PrivateSubnetName2"></a> [PrivateSubnetName2](#output\_PrivateSubnetName2)                         | Public Subnet 2                        |
| <a name="output_Private_Route_Table_objs"></a> [Private\_Route\_Table\_objs](#output\_Private\_Route\_Table\_objs) | Private route table objs               |
| <a name="output_PublicInstance1-PrivateIP"></a> [PublicInstance1-PrivateIP](#output\_PublicInstance1-PrivateIP)    | PublicInstance1 Private IP             |
| <a name="output_PublicInstance2-PrivateIP"></a> [PublicInstance2-PrivateIP](#output\_PublicInstance2-PrivateIP)    | PublicInstance2 Private IP             |
| <a name="output_PublicSubnetName1"></a> [PublicSubnetName1](#output\_PublicSubnetName1)                            | Public Subnet 1                        |
| <a name="output_PublicSubnetName2"></a> [PublicSubnetName2](#output\_PublicSubnetName2)                            | Public Subnet 2                        |

<!-- END_TF_DOCS -->
