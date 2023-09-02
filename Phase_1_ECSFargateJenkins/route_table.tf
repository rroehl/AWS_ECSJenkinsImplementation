# Create Internal Route table
resource "aws_route_table" PublicInternalRouteTable1 {
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
	    Name = join( "", ["Public Internal Route Table1", var.NetworkTypeA, var.FirstAvailabilityZoneIndex])
    	Environment = var.NetworkTypeA
    	"Environment Index" = var.FirstAvailabilityZoneIndex
	}
	
}
# Create Internal Route tables
resource "aws_route_table" PublicInternalRouteTable2 {
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [aws_vpc.SampleVPC]
	tags = {
	    Name = join( "", ["Public Internal Route Table 2", var.NetworkTypeA, var.SecondAvailabilityZoneIndex])
    	Environment = var.NetworkTypeA
    	"Environment Index" = var.SecondAvailabilityZoneIndex
	}
}
resource "aws_route_table" PrivateInternalRouteTable1 {
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
	    Name = join( "", [var.private_route_table_prefix, var.FirstAvailabilityZoneIndex])
    	Environment = var.NetworkTypeB
    	"Environment Index" = var.FirstAvailabilityZoneIndex
	    }
    }

resource "aws_route_table" PrivateInternalRouteTable2 {
	vpc_id = aws_vpc.SampleVPC.id
	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
	    Name = join( "", [var.private_route_table_prefix, var.SecondAvailabilityZoneIndex])
    	Environment = var.NetworkTypeB
    	"Environment Index" = var.SecondAvailabilityZoneIndex
	}
}

# Create Internal route table association between route table and subnet
resource "aws_route_table_association" PublicSubNet1InternalRouteTableAssociation {

	depends_on = [ aws_subnet.PublicSubNet1, aws_route_table.PublicInternalRouteTable1]
	subnet_id = aws_subnet.PublicSubNet1.id
	route_table_id = aws_route_table.PublicInternalRouteTable1.id
}

# Create Internal route table association between route table and subnet
resource "aws_route_table_association" PublicSubNet2InternalRouteTableAssociation {

	depends_on = [ aws_subnet.PublicSubNet2, aws_route_table.PublicInternalRouteTable2]
	subnet_id = aws_subnet.PublicSubNet2.id
	route_table_id = aws_route_table.PublicInternalRouteTable2.id
}

# Create Internal route table association between route table and subnet
resource "aws_route_table_association" PrivateSubNet1InternalRouteTableAssociation {

	depends_on = [ aws_subnet.PrivateSubNet1, aws_route_table.PrivateInternalRouteTable1]
	subnet_id = aws_subnet.PrivateSubNet1.id
	route_table_id = aws_route_table.PrivateInternalRouteTable1.id
}

# Create Internal route table association between route table and subnet
resource "aws_route_table_association" PrivateSubNet2InternalRouteTableAssociation {

	depends_on = [ aws_subnet.PrivateSubNet2, aws_route_table.PrivateInternalRouteTable2]
	subnet_id = aws_subnet.PrivateSubNet2.id
	route_table_id = aws_route_table.PrivateInternalRouteTable2.id
}

# Create a routing table entry 1
resource "aws_route" PublicAddIGWToRoute1 {
	depends_on = [ aws_internet_gateway.PublicInternetGateway, aws_route_table.PublicInternalRouteTable1]
	destination_cidr_block = "0.0.0.0/0"
	route_table_id =  aws_route_table.PublicInternalRouteTable1.id
	gateway_id  = aws_internet_gateway.PublicInternetGateway.id
}
# Create a routing table entry 2
resource "aws_route" PublicAddIGWToRoute2 {
	depends_on = [aws_internet_gateway.PublicInternetGateway, aws_route_table.PublicInternalRouteTable2]
	destination_cidr_block = "0.0.0.0/0"
	route_table_id =  aws_route_table.PublicInternalRouteTable2.id
	gateway_id  = aws_internet_gateway.PublicInternetGateway.id
}

# Create a routing table entry for private subnet to the NAT gateway
resource "aws_route" PublicAddNatGWToRoute1 {
	depends_on = [ aws_route_table.PrivateInternalRouteTable1, aws_nat_gateway.NatGateWay1A]
	destination_cidr_block = "0.0.0.0/0"
	route_table_id =  aws_route_table.PrivateInternalRouteTable1.id
	nat_gateway_id  = aws_nat_gateway.NatGateWay1A.id
} 

# Create a routing table entry for private subnet to the NAT gateway
resource "aws_route" PublicAddNatGWToRoute2 {
	//depends_on = [ aws_internet_gateway.PublicInternetGateway, aws_route_table.PublicInternalRouteTable2]
	destination_cidr_block = "0.0.0.0/0"
	route_table_id =  aws_route_table.PrivateInternalRouteTable2.id
	nat_gateway_id  = aws_nat_gateway.NatGateWay1A.id
}
