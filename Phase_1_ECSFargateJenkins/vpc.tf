

#Create the VPC
resource "aws_vpc" SampleVPC {
	cidr_block = var.SampleCidrBlock
	instance_tenancy     = "default"
    enable_dns_support   = true 
    enable_dns_hostnames = true

    tags = {
    	Name = join( " ", ["VPC", var.NetworkTypeA, var.FirstAvailabilityZoneIndex])
    	Environment = var.NetworkTypeA
    	"Environment Index" = var.FirstAvailabilityZoneIndex
    }
}
# Create an Internet gateway 1- no internet gateway attyeshment needed
resource "aws_internet_gateway" PublicInternetGateway {
	vpc_id = aws_vpc.SampleVPC.id

	tags = {
		Name = join( " ", ["Public Internet Gateway"])
	}
}

















