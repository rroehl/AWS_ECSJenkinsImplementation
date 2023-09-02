resource "aws_efs_file_system" "jenkins_service_efs" {
    creation_token                  = "${var.name_prefix}-${var.jenkins_service_efs_token}" 
    encrypted                       = var.efs_enable_encryption
    kms_key_id                      = var.efs_kms_key_arn //If null the default key is used
    performance_mode                = var.efs_performance_mode
    throughput_mode                 = var.efs_throughput_mode
    provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps // not needed unless throughput is not  burst

    dynamic "lifecycle_policy" { //default value is null
        for_each = var.efs_ia_lifecycle_policy != null ? [var.efs_ia_lifecycle_policy] : []
            content {
                transition_to_ia = lifecycle_policy.value
        }
    }

    tags = {
        Name = var.jenkins_service_efs_name
    }
}

resource "aws_efs_access_point" jenkins_service_efs_access_point {
    depends_on = [aws_efs_file_system.jenkins_service_efs]
    file_system_id = aws_efs_file_system.jenkins_service_efs.id

    posix_user {
        gid = 0
        uid = 0
    }
    root_directory {
        path = "/"
        creation_info {
            owner_gid   = var.efs_access_point_gid
            owner_uid   = var.efs_access_point_uid
            permissions = "770"
        }
    }

    tags = {
        name = "jenkins_service_efs_access_point"
    }
}

resource "aws_efs_mount_target" jenkins_service_efs_mount_targets {
 
  for_each = { for subnet in data.aws_subnets.GetPrivateSubnetObjs.ids : subnet => true }
    file_system_id = aws_efs_file_system.jenkins_service_efs.id
    subnet_id       = each.key
    security_groups = [aws_security_group.jenkins_service_efs_security_group.id]
}


// Linux Agent EFS dot jenkins volume
resource "aws_efs_file_system" "jenkins_agent_dot_jenkins_efs" {
    creation_token                  = "${var.name_prefix}-${var.jenkins_agent_dot_jenkins_efs_token}"
    encrypted                       = var.efs_enable_encryption
    kms_key_id                      = var.efs_kms_key_arn //If null the default key is used
    performance_mode                = var.efs_performance_mode
    throughput_mode                 = var.efs_throughput_mode
    provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps // not needed unless throughput is not  burst

    dynamic "lifecycle_policy" { //default value is null
        for_each = var.efs_ia_lifecycle_policy != null ? [var.efs_ia_lifecycle_policy] : []
            content {
                transition_to_ia = lifecycle_policy.value
        }
    }

    tags = {
        Name = var.jenkins_agent_dot_jenkins_efs_name
    }
}
resource "aws_efs_access_point" jenkins_agent_dot_jenkins_efs_access_point {
    depends_on = [aws_efs_file_system.jenkins_agent_dot_jenkins_efs]
    file_system_id = aws_efs_file_system.jenkins_agent_dot_jenkins_efs.id

    posix_user {
        gid = 0
        uid = 0
    }
    root_directory {
        path = "/"
        creation_info {
            owner_gid   = var.efs_access_point_uid
            owner_uid   = var.efs_access_point_gid
            permissions = "755"
        }
    }

    tags = {
        name = "jenkins_agent_dot_jenkins_efs_access_point"
    }
}
resource "aws_efs_mount_target" jenkins_agent_dot_efs_mount_targets {
 
  for_each = { for subnet in data.aws_subnets.GetPrivateSubnetObjs.ids : subnet => true }
    file_system_id = aws_efs_file_system.jenkins_agent_dot_jenkins_efs.id
    subnet_id       = each.key
    security_groups = [aws_security_group.jenkins_agent_efs_security_group.id]
    }


// Linux Agent EFS work dir volume
resource "aws_efs_file_system" "jenkins_agent_work_dir_efs" {
    creation_token                  = "${var.name_prefix}-${var.jenkins_agent_work_dir_fs_efs_token}"
    encrypted                       = var.efs_enable_encryption
    kms_key_id                      = var.efs_kms_key_arn //If null the default key is used
    performance_mode                = var.efs_performance_mode
    throughput_mode                 = var.efs_throughput_mode
    provisioned_throughput_in_mibps = var.efs_provisioned_throughput_in_mibps // not needed unless throughput is not  burst

    dynamic "lifecycle_policy" { //default value is null
        for_each = var.efs_ia_lifecycle_policy != null ? [var.efs_ia_lifecycle_policy] : []
            content {
                transition_to_ia = lifecycle_policy.value
        }
    }

    tags = {
        Name = var.jenkins_agent_work_dir_efs_name
    }
}
resource "aws_efs_access_point" jenkins_agent_work_dir_efs_access_point {
    depends_on = [aws_efs_file_system.jenkins_agent_work_dir_efs]
    file_system_id = aws_efs_file_system.jenkins_agent_work_dir_efs.id

    posix_user {
        gid = 0
        uid = 0
    }
    root_directory {
        path = "/"
        creation_info {
            owner_gid   = var.efs_access_point_uid
            owner_uid   = var.efs_access_point_gid
            permissions = "755"
        }
    }

    tags = {
        name = "jenkins_agent_work_dir_efs_access_point"
    }
}
resource "aws_efs_mount_target" jenkins_agent_work_dir_efs_mount_targets {
 
  for_each = { for subnet in data.aws_subnets.GetPrivateSubnetObjs.ids : subnet => true }
    file_system_id = aws_efs_file_system.jenkins_agent_work_dir_efs.id
    subnet_id       = each.key
    security_groups = [aws_security_group.jenkins_agent_efs_security_group.id]
}