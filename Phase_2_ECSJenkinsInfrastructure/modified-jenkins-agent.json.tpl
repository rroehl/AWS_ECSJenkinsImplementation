[
    {
        "name": "${name}",
        "image": "${container_image}",
        "cpu": ${cpu},
        "memory": ${memory},
        "memoryReservation": ${memory},
        "portMappings": [],
        "essential": true,
        "environment": [],
        "mountPoints": [
            {
            "containerPath": "${dot_jenkins_folder}",
            "sourceVolume": "${dot_jenkins_source_volume}"
            },
            {
            "containerPath": "${workdir_folder}",
            "sourceVolume": "${workdir_source_volume}"
            }
        ],
        "volumesFrom": [],
        "linuxParameters": {
            "initProcessEnabled": true
        },
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "controller"
            }
        }
    }
]
