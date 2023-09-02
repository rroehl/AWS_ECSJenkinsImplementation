[
    {
    "name": "${name}",
    "image": "${container_image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "memoryReservation": ${memory},
    "essential": true,
    
    "linuxParameters": {
        "initProcessEnabled": true
    },
    "mountPoints": [
        {
            "containerPath": "${jenkins_home}",
            "sourceVolume": "${source_volume}"
        }
    ],

    "portMappings": [
         {
          "containerPort": ${jnlp_port}
        },
        {
          "containerPort": ${jenkins_container_port}
        }
      ],

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
