// Task Role

resource "aws_iam_role" jenkins_controller_task_role {  //B1
    name               = "${var.name_prefix}-controller-task-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json //C1
    tags = {
        name  = "jenkins_controller_task_role"
    }
}

data "aws_iam_policy_document" ecs_assume_policy { //C1
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" jenkins_controller_task { //A1
    role       = aws_iam_role.jenkins_controller_task_role.name //B1
    policy_arn = aws_iam_policy.jenkins_controller_task_policy.arn   //B2
} 

resource "aws_iam_policy" jenkins_controller_task_policy { //B2
    name   = "${var.name_prefix}-controller-task-policy"
    policy = data.aws_iam_policy_document.jenkins_controller_task_policy.json //C2
}

data "aws_iam_policy_document" jenkins_controller_task_policy {       //C2

    statement {
        effect = "Allow"
        actions = [
            "ecs:ListContainerInstances"
            ]
        // Robb resources = [aws_ecs_cluster.jenkins_controller.arn, aws_ecs_cluster.jenkins_agents.arn]
        resources = [aws_ecs_cluster.jenkins_controller_cluster.arn]
    }
    statement {
        effect = "Allow"
        actions = [
        "ecs:RunTask"
        ]
        condition {
        test     = "ArnEquals"
        variable = "ecs:cluster"
        values = [
            aws_ecs_cluster.jenkins_controller_cluster.arn //Robb,
            //ROBB aws_ecs_cluster.jenkins_agents.arn
        ]
        }
        resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/*"]
    }
    statement {
        effect = "Allow"
        actions = [
        "ecs:StopTask",
        "ecs:DescribeTasks"
        ]
        condition {
        test     = "ArnEquals"
        variable = "ecs:cluster"
        values = [
            aws_ecs_cluster.jenkins_controller_cluster.arn//ROBB ,
            //ROBB aws_ecs_cluster.jenkins_agents.arn
        ]
        }
        resources = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task/*"]
    }
    statement {
        effect = "Allow"
        actions = [
        "ssm:PutParameter",
        "ssm:GetParameter",
        "ssm:GetParameters"
        ]
        resources = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/jenkins*"]
    }
    statement {
        effect = "Allow"
        actions = [
        "kms:Decrypt"
        ]
        resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:alias/aws/ssm"]
    }
    statement {
        effect = "Allow"
        actions = [
        "iam:PassRole"
        ]
        resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
    }
    statement {
        effect = "Allow"
        actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
        ]
        resources = ["${aws_cloudwatch_log_group.jenkins_controller_log_group.arn}:*"]
    }
    statement {
        effect = "Allow"
        actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "elasticfilesystem:ClientMount",
        "ecr:GetAuthorizationToken",
        "ecs:RegisterTaskDefinition",
        "ecs:ListClusters",
        "ecs:DescribeContainerInstances",
        "ecs:ListTaskDefinitions",
        "ecs:DescribeTaskDefinition",
        "ecs:DeregisterTaskDefinition"

        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        actions = [
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess",
        ]
        resources = [
            aws_efs_file_system.jenkins_service_efs.arn,

           // TODO "${data.aws_efs_file_system.get_jenkins_agent_dot_jenkins_efs.arn}",
           // TODO "${data.aws_efs_file_system.get_jenkins_agent_dot_jenkins_efs.arn}",

            ]
    }
    // Allow  SSH into containers
    statement {
        effect = "Allow"
        actions = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
        ]
        resources = ["*"]
    }
}


//  Execution Role

resource "aws_iam_role" ecs_execution_role { //B1

    name               = "${var.name_prefix}-ecs-execution-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_policy.json //C1
    tags = {
        name = "ecs_execution_role"
    }
}

data "aws_iam_policy_document" ecs_execution_assume_policy { //C1
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }   
}

resource "aws_iam_role_policy_attachment" ecs_execution {  //A1
    role       = aws_iam_role.ecs_execution_role.name //B1
    policy_arn = aws_iam_policy.ecs_execution_policy.arn //B2
}

resource "aws_iam_policy" ecs_execution_policy {  //B2
    name   = "${var.name_prefix}-ecs-execution-policy"
    policy = data.aws_iam_policy_document.ecs_execution_policy.json //C2
}

data "aws_iam_policy_document" ecs_execution_policy { //C2
    statement {
        effect = "Allow"
        actions = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents",
        ]
        resources = ["*"]
    }
        // Allow SSM SSH into containers
    statement {
        effect = "Allow"
        actions = [
             "ssm:StartSession"
        ]
        resources = ["*"]
    }
}

