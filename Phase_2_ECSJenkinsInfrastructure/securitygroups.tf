resource "aws_security_group" alb_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for ALB"
	tags = {
	    Name = "ALB SecurityGroup"
	    }

    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = [var.white_list_ip]
        description = "HTTP Public access"
        }

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [var.white_list_ip]
        description = "HTTPS Public access"
        }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
        }
    /* Test this later egress {
		protocol = "tcp"
		from_port = "8080"
		to_port = "8080"
		security_groups = [aws_security_group.JenkinsSecurityGroup.id]
	    } */ 
    }

resource "aws_security_group" jenkins_controller_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for Jenkins Controller"
    tags = {
	    Name = "Jenkins Controller SecurityGroup"
	}

    ingress {
        protocol        = "tcp"
        self            = true
        security_groups = [aws_security_group.alb_security_group.id,aws_security_group.jenkins_agent_security_group.id ]
        from_port       = var.jenkins_controller_port  //8080
        to_port         = var.jenkins_controller_port
        description     = "Communication channel between the load balancer and the service node and between the agent and the service node"
    }

    ingress {
        protocol        = "tcp"
        self            = true
        security_groups = [aws_security_group.jenkins_agent_security_group.id]  
        from_port       = var.jenkins_jnlp_port   //50000
        to_port         = var.jenkins_jnlp_port
        description     = "Communication channel between the agent and the service nodes"
    }

    ingress {
        protocol = "tcp"
		from_port = "22"
		to_port = "22"
		cidr_blocks = [ var.SampleCidrBlock ]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" jenkins_service_efs_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for Jenkins Service EFS"

	tags = {
	    Name = "EFSSecurityGroup"
	    }
    ingress {
        protocol        = "tcp"
        security_groups = [data.aws_security_group.get_sg_private_to_efs.id]
        from_port       = 2049
        to_port         = 2049
        }

    ingress {
        protocol        = "tcp"
        security_groups = [aws_security_group.jenkins_controller_security_group.id]
        from_port       = 2049
        to_port         = 2049
        }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
        }
	}  

resource "aws_security_group" jenkins_agent_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for Jenkins Agent"
    tags = {
	    Name = "Jenkins Agent SecurityGroup"
	    }

    ingress {
        protocol = "tcp"
		from_port = "22"
		to_port = "22"
		cidr_blocks = [ var.SampleCidrBlock ]

    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
        }

    }

resource "aws_security_group" jenkins_agent_efs_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for Jenkins agent EFS"

	tags = {
	    Name = "EFSSecurityGroup"
	    }
    ingress {
        protocol        = "tcp"
        security_groups = [data.aws_security_group.get_sg_private_to_efs.id]
        from_port       = 2049
        to_port         = 2049
        }

    ingress {
        protocol        = "tcp"
        security_groups = [aws_security_group.jenkins_agent_security_group.id]
        from_port       = 2049
        to_port         = 2049
        }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
        }
	}    

	// VPC Endpoint security group
resource "aws_security_group" ecr_endpoint_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for ECR"
	tags = {
	    Name = "ECR_Endpoint_SecurityGroup"
	}

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ var.SampleCidrBlock ]
        description = "443 inbound endpoint"
    }
    
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

	// SSM Endpoint security group for SSH into container
resource "aws_security_group" ssm_endpoint_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for SSM"
	tags = {
	    Name = "SSM_Endpoint_SecurityGroup"
	}

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ var.SampleCidrBlock ]
        description = "443 inbound endpoint"
    }
    
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

	// SSM Messages Endpoint security group for SSH into container
resource "aws_security_group" ssm_messages_endpoint_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for SSM Messages"
	tags = {
	    Name = "SSM_Messages_Endpoint_SecurityGroup"
	}

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ var.SampleCidrBlock ]
        description = "443 inbound endpoint"
    }
    
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
// ----ECS Endpoint security groups

resource "aws_security_group" ecs_agent_endpoint_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for ecs_agent"
	tags = {
	    Name = "ecs_agent_Messages_Endpoint_SecurityGroup"
	}

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ var.SampleCidrBlock ]
        description = "443 inbound endpoint"
    }
    
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" ecs_telemetry_endpoint_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for ecs_telemetry"
	tags = {
	    Name = "ecs_telemetry_Messages_Endpoint_SecurityGroup"
	}

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ var.SampleCidrBlock ]
        description = "443 inbound endpoint"
    }
    
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" ecs_endpoint_security_group {
	
	vpc_id = data.aws_vpc.GetVPCObject.id
	description = "Management Security Group for ecs"
	tags = {
	    Name = "ecs_Messages_Endpoint_SecurityGroup"
	}

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ var.SampleCidrBlock ]
        description = "443 inbound endpoint"
    }
    
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}