variable "region" {
  default = "us-east-2"
  type = string
  description = "AWS Region"
  validation {
	condition = ( var.region == "us-east-2" || var.region == "us-west-2" )
	error_message = "Region can be us-east-2 or us-west-2."
    }
}

variable name_prefix {
  type    = string
  default = "serverless-jenkins"
}

// Subnet
variable "private_subnet_names" {
	type = string
	default = "Private Subnet*"
    description = "The tag name of the private subnets to add resources to"
}

//Jenkins account passwords

variable service_admin_display_name {
    type = string
    default = "{admin display name}"
    description = "Jenkins admin display name"
}

variable service_admin_user_name {
    type = string
    default = "{Admin user name}"
    description = "Jenkins admin user name"
}

variable service_admin_password {
    type = string
    default = "{password}"
    description = "Jenkins admin password"
}

variable service_admin_email{
    type = string
    default = "{admin email address}"
    description = "Jenkins admin email address"
}

variable service_job_display_name {
    type = string
    default = "Job Runner"
    description = "Jenkins job display name"
}

variable service_job_user_name {
    type = string
    default = "jobrunner"
    description = "Jenkins job user password"
}

variable service_job_password {
    type = string
    default = "{password}"
    description = "Jenkins job  password"
}

variable service_job_email {
    type = string
    default = "jobrunner@{company}.com"
    description = "Jenkins job email address"
}

//Jenkins
variable jenkins_service_root_folder {
    type        = string
    default     = "/apps/jenkins"
    description = "Jenkins Service Root folder"
    }

variable jenkins_service_home_folder {
    type    = string
    default = "/apps/jenkins/jenkins_home"
    description = "Jenkins Service home folder"
    }

variable jenkins_linux_agent_root_folder {
    type        = string
    default     = "/apps/jenkins"
    description = "Jenkins linux agent Root folder"
    }

variable jenkins_linux_agent_home_folder {
    type    = string
    default = "/apps/jenkins/jenkins_home"
    description = "Jenkins linux agent home folder"
    }

variable jenkins_controller_port {
    type    = number
    default = 8080
    }
variable jenkins_jnlp_port {
    type    = number
    default = 50000
    }

// TODO Add the Jenkins URL
variable  jenkins_url{
    type        = string
    default     = ""
    description = "URL of the service"
    }

variable  jenkins_agent_name {
    type        = string
    default     = "Linux_Agent"
    description = "agent name"
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
variable docker_service_image_tag {
    type        = string
    default     = "lts"
    description = "Docker controller image tag"
    }

variable docker_linux_agent_image_tag {
    type        = string
    default     = "lts"
    description = "Docker linux agent image tag"
    }

//ECS Plugin vars
variable ecs_plugin_name {
    type        = string
    default     = "ecs-cloud"
    description = "Name associated with plugin"
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
