variable "region" {
  default = "us-east-2"
  type = string
  description = "AWS Region"
  validation {
	condition = ( var.region == "us-east-2" || var.region == "us-west-2" )
	error_message = "Region can be us-east-2 or us-west-2."
    }
}

variable "private_subnet_names" {
	type = string
	default = "Private Subnet*"
    description = "The tag name of the private subnets to add resources to"
}

//Jenkins

variable jenkins_controller_port {
    type    = number
    default = 8080
}
variable jenkins_jnlp_port {
    type    = number
    default = 50000
}

// alb
variable name_prefix {
    type    = string
    default = "serverless-jenkins"
}

// Discovery service
variable jenkins_service_hostname {
  type    = string
  default = "jenkins_service"
}

variable jenkins_dns_domain_name {
  type    = string
  default = "jenkins.cluster.local"
}

// EFS
variable "jenkins_service_efs_name" {
	type = string
	default =  "jenkins_service_efs" 
    description = "Jenkins EFS file system"
    }

