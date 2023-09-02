
output "MyVPCID" {
    value = data.aws_vpc.GetVPCObject.id
    description = "VPC ID"
}

output "MyPublicSubnetA_ID" {
    value =  element(data.aws_subnets.GetPublicSubnetObjs.ids, 0)
    description = "Subnet ID"
}
output "MyPublicSubnetB_ID" {
    value = element(data.aws_subnets.GetPublicSubnetObjs.ids, 1)
    description = "Subnet ID"
}


