resource "aws_vpc_endpoint" "ecr_api_endpoint" {
    depends_on = [aws_security_group.ecr_endpoint_security_group ]
    vpc_id       = data.aws_vpc.GetVPCObject.id

    service_name = join("", ["com.amazonaws.", var.region,".ecr.api"]) 
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids
    security_group_ids = [aws_security_group.ecr_endpoint_security_group.id]

    private_dns_enabled  =  true
    tags = {
        Name = "${var.name_prefix}-ecr-api-endpoint"
        }
    }
    
resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
    depends_on = [aws_security_group.ecr_endpoint_security_group ]
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".ecr.dkr"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids
    security_group_ids = [aws_security_group.ecr_endpoint_security_group.id ]
    private_dns_enabled  = true
    tags = {
        Name = "${var.name_prefix}-ecr-dkr-endpoint"
        }
    }

resource "aws_vpc_endpoint" "ecr_s3_endpoint" {
    //depends_on = [aws_security_group.ecr_endpoint_security_group ]
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".s3"])
    vpc_endpoint_type = "Gateway"
    route_table_ids = data.aws_route_tables.GetObjectPrivateRouteTablesObjs.ids
    policy = <<EOF
            {
                "Version": "2008-10-17",
                "Statement": [
                        {
                        "Sid": "adds full ecr access to the demo repository",
                        "Effect": "Allow",
                        "Principal": "*",
                        "Action": ["s3:*"],
                        "Resource":"*"
                        }
                    ]
            }
        EOF
   
    tags = {
        Name = "${var.name_prefix}-ecr-s3-endpointt"
        }
    }

resource "aws_vpc_endpoint" "cloudwatch_logs_endpoint" {
    depends_on = [aws_security_group.ecr_endpoint_security_group ]
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".logs"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids
    security_group_ids = [aws_security_group.ecr_endpoint_security_group.id ]
    private_dns_enabled  = true
    policy = <<EOF
            {
                "Version": "2008-10-17",
                "Statement": [
                    {
                        "Sid": "PutOnly",
                        "Principal": "*",
                        "Action": [
                            "logs:CreateLogStream",
                            "logs:PutLogEvents"
                        ],
                        "Effect": "Allow",
                        "Resource": "*"
                        }
                    ]
            }
        EOF
    tags = {
        Name = "${var.name_prefix}-cloudwatch-logs-endpoint"
        }
    }


//Endpoint form the SSM interface for SSH into container
resource "aws_vpc_endpoint" "ssm_endpoint" {
   
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".ssm"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids
    security_group_ids = [aws_security_group.ssm_endpoint_security_group.id ]
    private_dns_enabled  = true
    policy = <<EOF
            {
                "Version": "2008-10-17",
	            "Statement": [
		            {
			        "Action": "*",
			        "Effect": "Allow",
			        "Principal": "*",
			        "Resource": "*"
		        }
	            ]
            }
        EOF
    tags = {
        Name = "${var.name_prefix}-ssm-endpoint"
    }
}

//Endpoint form the SSM interface for SSH into container
resource "aws_vpc_endpoint" "ssm_messages_endpoint" {
   
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".ssmmessages"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids
    security_group_ids = [aws_security_group.ssm_messages_endpoint_security_group.id ]
    private_dns_enabled  = true
    policy = <<EOF
            {
                "Version": "2008-10-17",
	            "Statement": [
		            {
			        "Action": "*",
			        "Effect": "Allow",
			        "Principal": "*",
			        "Resource": "*"
		        }
	            ]
            }
        EOF
    tags = {
        Name = "${var.name_prefix}-ssm-messages-endpoint"
    }
}

// ECS Endpoints -----------------------------

resource "aws_vpc_endpoint" "ecs_agent" {
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".ecs-agent"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids

    security_group_ids = [aws_security_group.ecs_agent_endpoint_security_group.id]
    policy = <<EOF
            {
                "Version": "2008-10-17",
	            "Statement": [
		            {
			        "Action": "*",
			        "Effect": "Allow",
			        "Principal": "*",
			        "Resource": "*"
		        }
	            ]
            }
    EOF

    private_dns_enabled = true
    tags = {
        Name = "${var.name_prefix}-ecs-agent"
    }    
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".ecs-telemetry"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids

    security_group_ids = [aws_security_group.ecs_telemetry_endpoint_security_group.id]
    policy = <<EOF
            {
                "Version": "2008-10-17",
	            "Statement": [
		            {
			        "Action": "*",
			        "Effect": "Allow",
			        "Principal": "*",
			        "Resource": "*"
		        }
	            ]
            }
    EOF

    private_dns_enabled = true
    tags = {
        Name = "${var.name_prefix}-ecs-telemetry"
    }    
}

resource "aws_vpc_endpoint" "ecs" {
    vpc_id       = data.aws_vpc.GetVPCObject.id
    service_name = join("", ["com.amazonaws.", var.region,".ecs"])
    vpc_endpoint_type = "Interface"
    subnet_ids = data.aws_subnets.GetPrivateSubnetObjs.ids

    security_group_ids = [aws_security_group.ecs_endpoint_security_group.id]
    policy = <<EOF
            {
                "Version": "2008-10-17",
	            "Statement": [
		            {
			        "Action": "*",
			        "Effect": "Allow",
			        "Principal": "*",
			        "Resource": "*"
		        }
	            ]
            }
    EOF

    private_dns_enabled = true
    tags = {
        Name = "${var.name_prefix}-ecs"
    }
}