output "MyCurrentSourceIP" {
	value = var.user_source_ip
	description = "My source IP"
}

//output "DataNodeIamProfileName" {
  //value = aws_iam_instance_profile.DataNodeInstanceProfile.name
  //description = "Data node IAM profile name" 
//}

output "KeyName" {
  value = var.KeyName
  description = "Sample Key Name"
}


output "AWS_Region" {
	value = var.region
	description = "AWS region"
}

output "AvailabilityZone1" {
	value = lookup( lookup( var.AZMap, var.region ), var.FirstAvailabilityZoneIndex)
	description = "Sample Availability Zone"
}
output "AvailabilityZone2" {
	value = lookup( lookup( var.AZMap, var.region ), var.SecondAvailabilityZoneIndex)
	description = "Sample Availability Zone"
}

output "PlatformA" {
	value = var.NetworkTypeA
	description = "RM Public, PrivatePlatform"
}
output "PlatformB" {
	value = var.NetworkTypeB
	description = "RM Public, Private, or Shared Platform"
}

output "PublicSubnetName1" {
	value = lookup( lookup( var.SubnetMap, var.FirstAvailabilityZoneIndex), var.NetworkTypeA)
	description = "Public Subnet 1"
}
output "PrivateSubnetName1" {
	value = lookup( lookup( var.SubnetMap, var.FirstAvailabilityZoneIndex), var.NetworkTypeB)
	description = "Private Subnet 1"
}
output "PublicSubnetName2" {
	value = lookup( lookup( var.SubnetMap, var.SecondAvailabilityZoneIndex), var.NetworkTypeA)
	description = "Public Subnet 2"
}
output "PrivateSubnetName2" {
	value = lookup( lookup( var.SubnetMap, var.SecondAvailabilityZoneIndex), var.NetworkTypeB)
	description = "Public Subnet 2"
}
/* Endpoint used
output "PublicNatGateWayAIP" {
  value = aws_eip.NatGatewayAIP.public_ip
}
*/
output "PublicInstance1-PrivateIP" {
	value = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeA ), var.FirstAvailabilityZoneIndex)
	description = "PublicInstance1 Private IP"
}
output "PrivateInstance1-PrivateIP" {
	value = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeB ), var.FirstAvailabilityZoneIndex)
	description = "Private Instance1 Private IP"
}
output "PublicInstance2-PrivateIP" {
	value = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeA ), var.SecondAvailabilityZoneIndex)
	description = "PublicInstance2 Private IP"
}
output "PrivateInstance2-PrivateIP" {
	value = lookup( lookup( var.EC2InstanceIPAddress, var.NetworkTypeB ), var.SecondAvailabilityZoneIndex)
	description = "Private Instance2 Private IP"
}

output "Private_Route_Table_objs" {
	value = data.aws_route_tables.GetObjectPrivateRouteTablesObjs
	description = "Private route table objs"
    }





