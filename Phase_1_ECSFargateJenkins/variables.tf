# Variables
variable "SampleCidrBlock" {
description = "VPC Cidr Block"
type =  string
default = "10.250.0.0/16"
validation {
	condition = ( can ( regex("^([0-9]+\\.){3}[0-9]+\\/[0-9]+$", var.SampleCidrBlock) ) )
	error_message = "SampleCidrBlock must be a legitimate CIDR value."
	}
}

variable "region" {
  default = "us-east-2"
  type = string
  description = "AWS Region"
  validation {
	condition = ( var.region == "us-east-2" || var.region == "us-west-2" )
	error_message = "Region can be us-east-2 or us-west-2."
    }
}
//User source IP address
variable "user_source_ip" {
	type = string
	default =  "24.23.232.215/32" //"64.129.227.254/32"
    description = "HTTP and SSH Source IP"
}


variable "NetworkTypeA" {
description = "Public Subnet"
type =  string
default = "Public"
validation {
	condition = ( var.NetworkTypeA == "Public" || var.NetworkTypeA == "Private")
	error_message = "NetworkTypeA must be either Public or Private."
    }
}

variable "NetworkTypeB" {
description = "Sample Public or Private"
type =  string
default = "Private"
validation {
	condition = ( var.NetworkTypeB == "Public" || var.NetworkTypeB == "Private"  )
	error_message = "NetworkTypeB must be either Public or Private."
    }
}

variable "FirstAvailabilityZoneIndex" {
description = "Platform 1 AZ letter A,B, or C for Public or Private"
type =  string
default = "A"
validation {
	condition = ( var.FirstAvailabilityZoneIndex == "A" || var.FirstAvailabilityZoneIndex == "B" || var.FirstAvailabilityZoneIndex == "C")
	error_message = "FirstAvailabilityZoneIndex must be a letter of the AZ in the specified Region."
	}
}

variable "SecondAvailabilityZoneIndex" {
description = "Platform 2 AZ letter A,B, or C for Public and Private"
type =  string
default = "B"
validation {
	condition = ( var.SecondAvailabilityZoneIndex == "A" || var.SecondAvailabilityZoneIndex == "B" || var.SecondAvailabilityZoneIndex == "C")
	error_message = "SecondAvailabilityZoneIndex must be a letter of the AZ in the specified Region."
	}
}

variable "KeyName" {
description = "Name of Existing EC2 KeyPair "
type =  string
default = "Instance"
validation {
	condition = ( var.KeyName != "")
	error_message = "KeyName must be the name of an existing Ec2 pair."
	}
}

variable "InstanceType" {
description = "Domain Controller node Instance Type"
type =  string
default = "t2.micro"
validation {
	condition = ( var.InstanceType == "t2.micro")
	error_message = "Wrong  node Instance Type."
	}
}

variable "private_to_efs" {
    description = "tag name of SG private to EFS"
    type =  string
    default = "Private_Instance_to_EFS"
    }


# Mapping comment

variable "RegionInstanceMap" {
	description = "Region AMIs  for Public and Private networks"
  	type = map(map(string))
  	default = {
	    us-west-2 = {
	    	Public = "ami-0277b52859bac6f4b"
	    	Private = "ami-0277b52859bac6f4b"
	    	},
	    us-east-2 = {
	    	Public = "ami-0277b52859bac6f4b"
	    	Private = "ami-0277b52859bac6f4b"
	    	}
  	}
}

variable "SubnetMap" {
	description = "Subnets in Zones A,B,and C for Public and Private Networks"
  	type = map(map(string))
  	default = {
	    A = {
	    	Public = "10.250.12.0/23"
	    	Private = "10.250.18.0/23"
	    	},
	    B = {
	    	Public = "10.250.14.0/23"
	    	Private = "10.250.20.0/23"
	    	},
	    C = {
	    	Public = "10.250.16.0/23"
	    	Private = "10.250.22.0/23"
	    	}
  	}
}

variable "AZMap" {
    # value = lookup( lookup( var.AZMap, var.region ), var.FirstAvailabilityZoneIndex)
	description = "AWS AZ in in Regions for Public and Private Networks"
  	type = map(map(string))
  	default = {
	    us-west-2 = {
	    	A = "us-west-2a"
	    	B = "us-west-2b"
	    	C = "us-west-2c"
	    	},
	    us-east-2 = {
	    	A = "us-east-2a"
	    	B = "us-east-2b"
	    	C = "us-east-2c"
	    	}
  	}
}

variable "EC2InstanceIPAddress" {
	description = "Linux IP for Public and Private in AZ 1,2,3"
  	type = map(map(string))
  	default = {
	    Public = {
	    	A = "10.250.12.15"
	    	B = "10.250.14.15"
	    	C = "10.250.16.15"
	    },
	    Private = {
	    	A = "10.250.18.15"
	    	B = "10.250.20.15"
	    	C = "10.250.22.15"
	    }
 	} 	
}

//Route tables
variable "private_route_table_prefix" {
	type = string
	default =  "Private_Internal_Route_Table_"
    description = "Private Route Table lable prefix"
    }

data "aws_route_tables" "GetObjectPrivateRouteTablesObjs" {
//tags = {Name =  "VPC Public A" }
  filter {
    name = "tag:Name"
    values = [join( "", [var.private_route_table_prefix, "*"])]
  }
}
