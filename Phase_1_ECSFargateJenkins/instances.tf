# Create instances

resource "aws_instance" PublicLinux1 {
	
	depends_on = [ aws_subnet.PublicSubNet1]
	ami =  lookup( lookup( var.RegionInstanceMap, var.region), var.NetworkTypeA) 
	instance_type = var.InstanceType 
	key_name = var.KeyName
	//associate_public_ip_address = true
	subnet_id = aws_subnet.PublicSubNet1.id
	security_groups = [ aws_security_group.PublicSSHSecurityGroup.id, aws_security_group.PingExternalInboundSecurityGroup.id,  aws_security_group.PingInternalOutboundSecurityGroup.id,aws_security_group.HTTPOutBoundSecurityGroup.id]
	private_ip = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeA ), var.FirstAvailabilityZoneIndex)
	
	tags = {
		Name = join( "", [var.NetworkTypeA, "Linux","Instance1",var.FirstAvailabilityZoneIndex])
    Environment = var.NetworkTypeA
    "Environment Index" = var.FirstAvailabilityZoneIndex
	}
}
resource "aws_instance" PublicLinux2 {
	
	depends_on = [ aws_subnet.PublicSubNet2]
	ami =  lookup( lookup( var.RegionInstanceMap, var.region), var.NetworkTypeA) 
	instance_type = var.InstanceType 
	key_name = var.KeyName
	//associate_public_ip_address = true
	subnet_id = aws_subnet.PublicSubNet2.id
	security_groups = [ aws_security_group.PublicSSHSecurityGroup.id, aws_security_group.PingExternalInboundSecurityGroup.id,  aws_security_group.PingInternalOutboundSecurityGroup.id,aws_security_group.HTTPOutBoundSecurityGroup.id]
	private_ip = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeA ), var.SecondAvailabilityZoneIndex)
	
	tags = {
        Name = join( "", [var.NetworkTypeA, "Linux", "Instance2",var.SecondAvailabilityZoneIndex])
        Environment = var.NetworkTypeA
        "Environment Index" = var.SecondAvailabilityZoneIndex
	}
}

resource "aws_instance" PrivateLinux1 {
	
	depends_on = [ aws_subnet.PrivateSubNet1]
	ami =  lookup( lookup( var.RegionInstanceMap, var.region), var.NetworkTypeB) 
	instance_type = var.InstanceType 
	key_name = var.KeyName
	associate_public_ip_address = false
	subnet_id = aws_subnet.PrivateSubNet1.id
	security_groups = [ aws_security_group.PingInternalInboundSecurityGroup.id,aws_security_group.PrivateSSHSecurityGroup.id,aws_security_group.HTTPOutBoundSecurityGroup.id, aws_security_group.private_to_efs.id]
    //security_groups = [ aws_security_group.AllInternalSecurityGroup.id]

	private_ip = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeB ), var.FirstAvailabilityZoneIndex)

	tags = {
    Name = join( "", [var.NetworkTypeB, "Linux","Instance1",var.FirstAvailabilityZoneIndex])
    Environment = var.NetworkTypeB
    "Environment Index" = var.FirstAvailabilityZoneIndex
	}
}

resource "aws_instance" PrivateLinux2 {
	
	depends_on = [ aws_subnet.PrivateSubNet2]
	ami =  lookup( lookup( var.RegionInstanceMap, var.region), var.NetworkTypeB) 
	instance_type = var.InstanceType 
	key_name = var.KeyName
	associate_public_ip_address = false
	subnet_id = aws_subnet.PrivateSubNet2.id
	security_groups = [ aws_security_group.PingInternalInboundSecurityGroup.id, aws_security_group.PrivateSSHSecurityGroup.id,aws_security_group.HTTPOutBoundSecurityGroup.id,aws_security_group.private_to_efs.id]
    //security_groups = [ aws_security_group.AllInternalSecurityGroup.id]

	private_ip = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeB ), var.SecondAvailabilityZoneIndex)

	tags = {
    Name = join( "", [var.NetworkTypeB, "Linux", "Instance2",var.SecondAvailabilityZoneIndex])
    Environment = var.NetworkTypeB
    "Environment Index" = var.SecondAvailabilityZoneIndex
	}
}

resource "null_resource" "stop_ec2_instances" {

    depends_on = [aws_instance.PrivateLinux1,aws_instance.PrivateLinux2,aws_instance.PublicLinux1,aws_instance.PublicLinux2]
    // triggers = {
        // src_hash = file("${path.module}/docker/files/jenkins.yaml.tpl")
    //}
    //depends_on = [null_resource.render_template]
    provisioner "local-exec" { 
        command = <<EOF
aws ec2 stop-instances --instance-ids ${aws_instance.PrivateLinux1.id}
aws ec2 stop-instances --instance-ids ${aws_instance.PrivateLinux2.id}
aws ec2 stop-instances --instance-ids ${aws_instance.PublicLinux1.id}
aws ec2 stop-instances --instance-ids ${aws_instance.PublicLinux2.id}
EOF
        } 
    provisioner "local-exec" {
        command = "echo 'Test exec'"
     
        }

    provisioner "local-exec" {
        when    = destroy
        command = "echo 'Stopping Instances'"
     
        }
    }