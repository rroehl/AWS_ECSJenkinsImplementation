resource "aws_security_group" PrivateSSHSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Port 22 Inbound from any VPC subnet and out bound to any VPC subnet"

	tags = {
	    Name = "Private Security SSH Group"    	
	}

    ingress {
        protocol = "tcp"
		from_port = "22"
		to_port = "22"
		cidr_blocks = [ var.SampleCidrBlock ]

    }

    egress {
        protocol = "tcp"
		from_port = "22"
		to_port = "22"
		cidr_blocks = [ var.SampleCidrBlock ]

    }
}


resource "aws_security_group" PublicSSHSecurityGroup {	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Port 22 Inbound from my home IP and out bound to any VPC subnet"

	tags = {
	    Name = "Public Security SSH Group"
    	
	}
    ingress {
		protocol = "tcp"
		from_port = "22"
		to_port = "22"
		cidr_blocks = [ var.user_source_ip ]
	}
    egress {
		protocol = "tcp"
		from_port = "22"
		to_port = "22"
		cidr_blocks = [ var.SampleCidrBlock ]

	}
}

resource "aws_security_group" HTTPExternalSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Management Security Group for container"

	tags = {
	    Name = "ExternalHTTPSecurityGroup"
	}

    ingress {
		protocol = "tcp"
		from_port = "80"
		to_port = "80"
		cidr_blocks = [ var.user_source_ip ]
	}
}

resource "aws_security_group" HTTPOutBoundSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Management Security Group for container"

	tags = {
	    Name = "OutboundHTTPSecurityGroup"
	}

    egress {
		protocol = "tcp"
		from_port = "80"
		to_port = "80"
		cidr_blocks = ["0.0.0.0/0"]
	}
      egress {
		protocol = "tcp"
		from_port = "443"
		to_port = "443"
		cidr_blocks = ["0.0.0.0/0"]
	}
}


resource "aws_security_group" PingExternalInboundSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Management Security Group for Sample"

	tags = {
	    Name = "External Inbound Ping Security Group"
    	
	}

    ingress {
		protocol = "icmp"
		from_port = "8"
		to_port = "-1"
		cidr_blocks = [ var.user_source_ip ]
	}
}

resource "aws_security_group" PingInternalOutboundSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Management Security Group for Sample"

	tags = {
	    Name = "Internal Outbound Ping Security Group"    	
	}

    egress {
        protocol = "icmp"
		from_port = "8"
		to_port = "-1"
		cidr_blocks = [ var.SampleCidrBlock ]

    }

}

resource "aws_security_group" PingInternalInboundSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Management Security Group for Sample"

	tags = {
	    Name = "Ping Inbound Internal Security Group"

	}

   ingress {
		protocol = "icmp"
		from_port = "8"
		to_port = "-1"
		cidr_blocks = [ var.SampleCidrBlock ]

	}

}

resource "aws_security_group" AllInternalSecurityGroup {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Management Security Group for Sample"

	tags = {
	    Name = "All Internal Security Group"

	}


    ingress {
		protocol = "-1"
		from_port = "0"
		to_port = "0"
		cidr_blocks = [ var.SampleCidrBlock ]

	}

    egress {
        protocol = "-1"
		from_port = "0"
		to_port = "0"
		cidr_blocks = [ var.SampleCidrBlock ]

    }
}

resource "aws_security_group" private_to_efs {
	
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	description = "Private Instance to EFS"

	tags = {
	    Name = var.private_to_efs
	    }
    egress {
        protocol        = "tcp"
        cidr_blocks = [ var.SampleCidrBlock ]
        from_port       = 2049
        to_port         = 2049
        }
    }

