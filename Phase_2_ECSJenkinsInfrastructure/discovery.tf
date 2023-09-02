resource "aws_service_discovery_private_dns_namespace" "private_namespace" {
    vpc         = data.aws_vpc.GetVPCObject.id
    name        = var.jenkins_dns_domain_name
    description = "Private namespace for Jenkins containers"
    tags = {
        name = "${var.name_prefix}-PrivateNamespace"
    }
}

resource "aws_service_discovery_service" "jenkins_discovery_service" {
    name = var.jenkins_service_hostname

    dns_config {
        namespace_id = aws_service_discovery_private_dns_namespace.private_namespace.id

        dns_records {
            ttl  = 60
            type = "A"
        }
        dns_records {
            ttl  = 60
            type = "SRV"
        }
    //routing_policy = "MULTIVALUE"
    }
}

