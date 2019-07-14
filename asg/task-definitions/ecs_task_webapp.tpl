[
  {
    "name": "webapp",
    "image": "${webapp_docker_image}",
    "cpu": 256,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "command": [],
    "entryPoint": [],
    "links": [],
    "mountPoints": [],
    "volumesFrom": []
  }
]
