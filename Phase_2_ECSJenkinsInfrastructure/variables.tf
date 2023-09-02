variable "region" {
  default = "us-east-2"
  type = string
  description = "AWS Region"
  validation {
	condition = ( var.region == "us-east-2" || var.region == "us-west-2" )
	error_message = "Region can be us-east-2 or us-west-2."
    }
}

variable "SampleCidrBlock" {
description = "VPC Cidr Block"
type =  string
default = "10.250.0.0/16"
validation {
	condition = ( can ( regex("^([0-9]+\\.){3}[0-9]+\\/[0-9]+$", var.SampleCidrBlock) ) )
	error_message = "SampleCidrBlock must be a legitimate CIDR value."
	}
}

variable "vpc_name" {
	type = string
	default = "VPC Public A"
    description = "The tag name of the VPC to add resources to"
}

variable "public_subnet_names" {
	type = string
	default = "Public Subnet*"
    description = "The tag name of the public subnets to add resources to"
}

variable "private_subnet_names" {
	type = string
	default = "Private Subnet*"
    description = "The tag name of the private subnets to add resources to"
}

variable "white_list_ip" {
	type = string
	default =  "24.23.232.215/32"  // "24.23.232.215/32" // "64.129.227.254/32" 
    description = "home traffic"
}

// Routers
variable "private_route_table_prefix" {
	type = string
	default =  "Private_Internal_Route_Table_"
    description = "Private Route Table lable prefix"
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
variable jenkins_controller_cpu {
    type    = number
    default = 2048
    }

variable jenkins_controller_memory {
    type    = number
    default = 4096
    }

variable jenkins_agent_cpu {
    type    = number
    default = 2048
}

variable jenkins_agent_memory {
    type    = number
    default = 4096
}

variable jenkins_controller_image_tag {
    type    = string
    default = "lts"
    }

// alb
variable alb_type_internal {
    type    = bool
    default = false
    // default = true
    }

variable name_prefix {
  type    = string
  default = "serverless-jenkins"
}


// Discover service
variable jenkins_service_hostname {
  type    = string
  default = "jenkins_service"
}

variable jenkins_dns_domain_name {
  type    = string
  default = "jenkins.cluster.local" //Jenkins DNS domain name
}

// EFS
variable efs_enable_encryption {
        type    = bool
        default = true
}

variable efs_kms_key_arn {
    type    = string
    default = null // Defaults to aws/elasticfilesystem
    }

variable efs_performance_mode {
    type    = string
    default = "generalPurpose" // alternative is maxIO
    }

variable efs_throughput_mode {
    type    = string
    default = "bursting" // alternative is provisioned
    }

variable efs_provisioned_throughput_in_mibps {
    type    = number
    default = null // might need to be 0
    }

variable efs_ia_lifecycle_policy {
    type    = string
    default = null // Valid values are AFTER_7_DAYS AFTER_14_DAYS AFTER_30_DAYS AFTER_60_DAYS AFTER_90_DAYS
    }

variable efs_access_point_uid {
    type        = number
    description = "The uid number to associate with the EFS access point" // Jenkins 1000
    default     = 1000
    }

variable efs_access_point_gid {
    type        = number
    description = "The gid number to associate with the EFS access point" // Jenkins 1000
    default     = 1000
    }

variable "private_to_efs" {
    description = "tag name of SG private to EFS"
    type =  string
    default = "Private_Instance_to_EFS"
    }

variable jenkins_service_efs_token {
    	type = string
	    default =  "service-efs" 
        description = "Jenkins service EFS token for creation and volume name"
}

variable jenkins_agent_dot_jenkins_efs_token {
    	type = string
	    default =  "agent-dot-jenkins-fs" 
        description = "Jenkins agent dot jenkins EFS token for creation and volume name"
} 

variable jenkins_agent_work_dir_fs_efs_token {
    	type = string
	    default =  "agent-work-dir-fs" 
        description = "Jenkins agent work directory EFS token for creation and volume name"
} 

variable "jenkins_service_efs_name" {
	type = string
	default =  "jenkins_service_efs" 
    description = "Jenkins service EFS file system"
}

variable "jenkins_agent_dot_jenkins_efs_name" {
	type = string
	default =  "jenkins_agent_dot_jenkins_efs" 
    description = "Jenkins agent .jenkins EFS file system"
}

variable "jenkins_agent_work_dir_efs_name" {
	type = string
	default =  "jenkins_agent_work_dir_efs" 
    description = "Jenkins agent workdir EFS file system"
}

variable jenkins_service_home_folder {
    type    = string
    default = "/apps/jenkins/jenkins_home"
    description = "Jenkins Service home folder"
    }

variable jenkins_linux_agent_home_folder {
    type    = string
    default = "/apps/jenkins/jenkins_home"
    description = "Jenkins linux agent home folder"
}
    
//Cloudwatch
variable jenkins_controller_task_log_retention_days {
  type    = number
  default = 30
}

    //AWS ECR Registry
variable jenkins_ecr_controller_repository_name {
    type        = string
    default     = "serverless-jenkins-controller"
    description = "Name for Jenkins controller ECR repository"
}

variable jenkins_ecr_linux_agent_repository_name {
    type        = string
    default     = "serverless-jenkins-linux-agent"
    description = "Name for Jenkins Linux Agentr ECR repository"
}
    
//Docker image info
variable docker_linux_agent_image_tag {
    type        = string
    default     = "lts"
    description = "Docker linux agent image tag"
}


