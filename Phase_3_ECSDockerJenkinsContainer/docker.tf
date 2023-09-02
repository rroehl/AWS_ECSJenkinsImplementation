//Create the Controller Docker file with the new variables using SED and not terraform file rendering
resource "null_resource" "docker_controller_file_render_sed" {
    provisioner "local-exec" {
        command = <<EOF
cp ${path.module}/docker_service_image/Dockerfile.tpl ${path.module}/docker_service_image/Dockerfile
sed -ir "s/ARG http_port=\[http_port\]/ARG http_port=\"${var.jenkins_controller_port}\"/" ${path.module}/docker_service_image/Dockerfile
sed -ir "s/ARG agent_port=\[agent_port\]/ARG agent_port=\"${var.jenkins_jnlp_port}\"/" ${path.module}/docker_service_image/Dockerfile
sed -ir "s|ARG jenkins_service_root=\[jenkins_service_root\]|ARG jenkins_service_root=\"${var.jenkins_service_root_folder}\"|" ${path.module}/docker_service_image/Dockerfile
sed -ir "s|ARG jenkins_service_home=\[jenkins_service_home\]|ARG jenkins_service_home=\"${var.jenkins_service_home_folder}\"|" ${path.module}/docker_service_image/Dockerfile
rm ${path.module}/docker_service_image/Dockerfiler
EOF
    }
    provisioner "local-exec" {
        command = "echo 'Service Dockerfile created ..........'" 
    }

    provisioner "local-exec" {
        when    = destroy
        command = "echo 'Service Dockerfile deleted ..........' && rm ${path.module}/docker_service_image/Dockerfile"
    }
}

//Create Jenkins YAML file config as code.....
resource "local_file" "jenkins_yaml_file" {
  filename = "${path.module}/docker_service_image/jenkins.yaml"
  content = local.jenkins_yaml_config
}

//Define the Jenkins YAML file
locals {
    jenkins_yaml_config = <<-EOT
jenkins:

  agentProtocols:
  - "JNLP4-connect"
  - "Ping"

  securityRealm:
    local:
      allowsSignup: false
      users:
        # create a user for admin
        - id: ${var.service_admin_user_name}
          name: ${var.service_admin_display_name}
          password: ${var.service_admin_password}
          properties:
          - mailer:
              emailAddress: ${var.service_admin_email}
        - id: ${var.service_job_user_name}
          name: ${var.service_job_display_name}
          password: ${var.service_job_password}
          properties:
          - mailer:
              emailAddress: ${var.service_job_email}      

  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Job/Build:${var.service_job_user_name}"
        - "Job/Cancel:${var.service_job_user_name}"
        - "Job/Read:jobrun${var.service_job_user_name}ner"
        - "Job/Workspace:${var.service_job_user_name}"
        - "Overall/Administer:${var.service_admin_user_name}"
        - "Overall/Read:authenticated"
        - "Run/Replay:${var.service_job_user_name}"
        - "Run/Update:${var.service_job_user_name}"
  clouds:

  - ecs:
      credentialsId: ''
      cluster: "${data.aws_ecs_cluster.ecs-jenkins_controller_cluster.arn}"
      jenkinsUrl: "http://${var.jenkins_service_hostname}.${var.jenkins_dns_domain_name}:${var.jenkins_controller_port}"
      name: "${var.ecs_plugin_name}"
      numExecutors: 1
      regionName: "${var.region}"
      templates:
      - assignPublicIp: false
        cpu: 1
        cpuArchitecture: "X86_64"
        defaultCapacityProvider: false
        enableExecuteCommand: false
        image: "${data.aws_ecr_repository.get_jenkins_linux_agent_repo.repository_url}:${var.docker_linux_agent_image_tag}"
        label: "${var.jenkins_agent_name}"
        launchType: "FARGATE"
        memory: 0
        remoteFSRoot: ""
        memoryReservation: 0
        networkMode: "default"
        operatingSystemFamily: "LINUX"
        platformVersion: "LATEST"
        privileged: false
        securityGroups: "${data.aws_security_group.get_jenkins_agent_security_group.id}"
        sharedMemorySize: 0
        subnets: "${join(",", [for s in data.aws_subnets.GetPrivateSubnetObjs.ids : format("%s", s)])}"
        taskDefinitionOverride: "${var.name_prefix}-agent-task-def"
        uniqueRemoteFSRoot: false
      tunnel: "${var.jenkins_service_hostname}.${var.jenkins_dns_domain_name}:${var.jenkins_jnlp_port}"

  labelAtoms:
  - name: "${var.jenkins_agent_name}"
  - name: "built-in"

  slaveAgentPort: ${var.jenkins_jnlp_port}

unclassified:
  location:
    adminAddress: "address not configured yet nobody@nowhere"
    url: "${var.jenkins_url}"

    EOT
}


locals {  
    ecr_controller_endpoint = split("/",data.aws_ecr_repository.get_jenkins_controller_repo.repository_url)[0]
    # ecr_endpoint = split("/", aws_ecr_repository.jenkins_controller.repository_url)[0]
}

//TODO DO I NEED THIS
// Build the Service docker image and push it to the AWS ECR
resource "null_resource" "aws_cli_login" {
    // triggers = {
        // src_hash = file("${path.module}/docker_service_image/Dockerfile.tpl")
    //}
 
    provisioner "local-exec" { 
        command = <<EOF
docker login -u AWS -p ${data.aws_ecr_authorization_token.token.password} ${local.ecr_controller_endpoint}
EOF
    } 
    provisioner "local-exec" {
        command = "echo 'Created login to aws ........'"
    }

    provisioner "local-exec" {
        when    = destroy
        command = "echo 'Destroy login to aws ........'"
     
    }
}




// Build the Service docker image and push it to the AWS ECR
resource "null_resource" "build_docker_controller_image" {
     //triggers = {
       //  src_hash = file("${path.module}/docker_service_image/Dockerfile.tpl")
    //}
    depends_on = [null_resource.docker_controller_file_render_sed, null_resource.aws_cli_login, local_file.jenkins_yaml_file]
    provisioner "local-exec" { 
        command = <<EOF
docker build --rm -t ${data.aws_ecr_repository.get_jenkins_controller_repo.repository_url}:${var.docker_service_image_tag} ${path.module}/docker_service_image && \
echo "docker rmi ${data.aws_ecr_repository.get_jenkins_controller_repo.repository_url}:${var.docker_service_image_tag}" > ${path.module}/docker_service_image/destroy.sh && \
docker push ${data.aws_ecr_repository.get_jenkins_controller_repo.repository_url}:${var.docker_service_image_tag} && \
chmod u+x ${path.module}/docker_service_image/destroy.sh
EOF
// echo docker push ${data.aws_ecr_repository.get_jenkins_controller_repo.repository_url}:${var.docker_service_image_tag} && \
//docker push ${data.aws_ecr_repository.get_jenkins_controller_repo.repository_url}:${var.docker_service_image_tag} && \
//docker login -u AWS -p ${data.aws_ecr_authorization_token.token.password} ${local.ecr_controller_endpoint} && \
    } 
    provisioner "local-exec" {
        command = "echo 'Created service Docker image ........'"
    }

    provisioner "local-exec" {
        when    = destroy
        command = "echo 'Execute and Delete destroy.sh........' && ${path.module}/docker_service_image/destroy.sh && rm ${path.module}/docker_service_image/destroy.sh"
    }
}

//Create the Unix Agent Docker file with the new variables using SED and not terraform file rendering
resource "null_resource" "docker_linux_agent_file_render_sed" {
    provisioner "local-exec" {
        command = <<EOF
cp ${path.module}/docker_linux_agent_image/Dockerfile.tpl ${path.module}/docker_linux_agent_image/Dockerfile
sed -ir "s|ARG jenkins_agent_root=\[jenkins_agent_root\]|ARG jenkins_agent_root=\"${var.jenkins_linux_agent_root_folder}\"|" ${path.module}/docker_linux_agent_image/Dockerfile
sed -ir "s|ARG jenkins_agent_home=\[jenkins_agent_home\]|ARG jenkins_agent_home=\"${var.jenkins_linux_agent_home_folder}\"|" ${path.module}/docker_linux_agent_image/Dockerfile
rm ${path.module}/docker_linux_agent_image/Dockerfiler
EOF
    }
    provisioner "local-exec" {
        command = "echo 'Linux Agent Dockerfile created ..........'" 
    }

    provisioner "local-exec" {
        when    = destroy
        command = "echo 'Linux Agent Dockerfile deleted ..........' && rm ${path.module}/docker_linux_agent_image/Dockerfile"
    }
}
/* TODO Delete 
locals {
    ecr_linux_agent_endpoint = split("/", aws_ecr_repository.jenkins_linux_agent.repository_url)[0]
    # ecr_endpoint = split("/", aws_ecr_repository.jenkins_controller.repository_url)[0]
}
*/

// Build the Linux agent docker image and push it to the AWS ECR
resource "null_resource" "build_docker_linux_agent_image" {
     triggers = {
         src_hash1 = sha1(file("${path.module}/docker_linux_agent_image/Dockerfile.tpl"))
         src_hash2 = sha1(file("${path.module}/docker_linux_agent_image/jenkins-agent"))
    }
    depends_on = [null_resource.docker_linux_agent_file_render_sed, null_resource.aws_cli_login]
    provisioner "local-exec" { 
        command = <<EOF
docker build --rm -t ${data.aws_ecr_repository.get_jenkins_linux_agent_repo.repository_url}:${var.docker_linux_agent_image_tag} ${path.module}/docker_linux_agent_image && \
echo "docker rmi ${data.aws_ecr_repository.get_jenkins_linux_agent_repo.repository_url}:${var.docker_linux_agent_image_tag}" > ${path.module}/docker_linux_agent_image/destroy.sh && \
docker push ${data.aws_ecr_repository.get_jenkins_linux_agent_repo.repository_url}:${var.docker_linux_agent_image_tag} && \
chmod u+x ${path.module}/docker_linux_agent_image/destroy.sh
EOF
// After echo  docker push ${aws_ecr_repository.jenkins_linux_agent.repository_url}:${var.docker_linux_agent_image_tag} && \
    } 
    provisioner "local-exec" {
        command = "echo 'Created Linux agent Docker image ........'"
    }

    provisioner "local-exec" {
        when    = destroy
        command = "echo 'Execute and Delete destroy.sh........' && ${path.module}/docker_linux_agent_image/destroy.sh && rm ${path.module}/docker_linux_agent_image/destroy.sh"
     
    }
}
