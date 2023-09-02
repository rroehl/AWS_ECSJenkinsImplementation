# Create  the Public Subnet 1
resource "aws_subnet" PublicSubNet1 {
	vpc_id = aws_vpc.SampleVPC.id

	cidr_block = lookup( lookup( var.SubnetMap, var.FirstAvailabilityZoneIndex), var.NetworkTypeA)
	availability_zone = lookup( lookup( var.AZMap, var.region ), var.FirstAvailabilityZoneIndex)
	map_public_ip_on_launch = true 
	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
	    Name = join( " ", [var.NetworkTypeA,"Subnet",  var.FirstAvailabilityZoneIndex])
    	Environment = var.NetworkTypeA
    	"Environment Index" = var.FirstAvailabilityZoneIndex
	}	
}
# Create  the Public Subnet 2
resource "aws_subnet" PublicSubNet2 {
	vpc_id = aws_vpc.SampleVPC.id

	cidr_block = lookup( lookup( var.SubnetMap, var.SecondAvailabilityZoneIndex), var.NetworkTypeA)
	availability_zone = lookup( lookup( var.AZMap, var.region ), var.SecondAvailabilityZoneIndex)
	map_public_ip_on_launch = true

	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
        Name = join( " ", [var.NetworkTypeA,"Subnet",  var.SecondAvailabilityZoneIndex])
    	Environment = var.NetworkTypeA
    	"Environment Index" = var.SecondAvailabilityZoneIndex
	}	
}

//Create private subnet 1
resource "aws_subnet" PrivateSubNet1 {
	vpc_id = aws_vpc.SampleVPC.id

	cidr_block = lookup( lookup( var.SubnetMap, var.FirstAvailabilityZoneIndex), var.NetworkTypeB)
	availability_zone = lookup( lookup( var.AZMap, var.region ), var.FirstAvailabilityZoneIndex)
	map_public_ip_on_launch = false

	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
	    Name = join( " ", [var.NetworkTypeB,"Subnet",  var.FirstAvailabilityZoneIndex])
    	Environment = var.NetworkTypeB
    	"Environment Index" = var.FirstAvailabilityZoneIndex
	}	

}
//Create private subnet 2
resource "aws_subnet" PrivateSubNet2 {
	vpc_id = aws_vpc.SampleVPC.id

	cidr_block = lookup( lookup( var.SubnetMap, var.SecondAvailabilityZoneIndex), var.NetworkTypeB)
	availability_zone = lookup( lookup( var.AZMap, var.region ), var.SecondAvailabilityZoneIndex)
	map_public_ip_on_launch = false

	depends_on = [
		aws_vpc.SampleVPC
	]
	tags = {
	    Name = join( " ", [var.NetworkTypeB,"Subnet",  var.SecondAvailabilityZoneIndex])
    	Environment = var.NetworkTypeB
    	"Environment Index" = var.SecondAvailabilityZoneIndex
	}	

}
