resource "aws_ecr_repository" "jenkins_controller" {
    name                 =  var.jenkins_ecr_controller_repository_name 
    image_tag_mutability = "IMMUTABLE"
    force_delete = true
    }

resource "aws_ecr_repository_policy" "jenkins-controller-repo-policy" {
    repository = aws_ecr_repository.jenkins_controller.name
    policy     = <<EOF
        {
            "Version": "2008-10-17",
            "Statement": [
                {
                "Sid": "adds full ecr access to the demo repository",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:CompleteLayerUpload",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetLifecyclePolicy",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
                ]
                }
            ]
        }
    EOF
    }

resource "aws_ecr_repository" "jenkins_linux_agent" {
    name                 =  var.jenkins_ecr_linux_agent_repository_name 
    image_tag_mutability = "IMMUTABLE"
    force_delete =true
    }

resource "aws_ecr_repository_policy" "jenkins-linux-agent-repo-policy" {
    repository = aws_ecr_repository.jenkins_linux_agent.name
    policy     = <<EOF
        {
            "Version": "2008-10-17",
            "Statement": [
                {
                "Sid": "adds full ecr access to the demo repository",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:CompleteLayerUpload",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetLifecyclePolicy",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
                ]
                }
            ]
        }
    EOF
    }



# data "aws_caller_identity" "current" {}


