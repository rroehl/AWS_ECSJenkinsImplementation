data "aws_caller_identity" "current" {}

//data "aws_ecr_authorization_token" "token" {}


data "aws_route_tables" "GetObjectPrivateRouteTablesObjs" {
  filter {
    name = "tag:Name"
    values = [join( "", [var.private_route_table_prefix, "*"])]
    }
}

data "aws_vpc" "GetVPCObject" {

  filter {
    name = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "GetPublicSubnetObjs" {

  filter {
    name = "tag:Name"
    values = [var.public_subnet_names ] //"${data.aws_vpc.targetVpc.tags.Name}.dmz0"]
  }
}

data "aws_subnets" "GetPrivateSubnetObjs" {

  filter {
    name = "tag:Name"
    values = [var.private_subnet_names ] //"${data.aws_vpc.targetVpc.tags.Name}.dmz0"]
  }
}

data "aws_security_group" "get_sg_private_to_efs" {

  filter {
        name = "tag:Name"
        values = [var.private_to_efs ]
        }   
}