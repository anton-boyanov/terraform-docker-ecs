[
  {
    "name": "mysql",
    "image": "${mysql_docker_image}",
    "cpu": 256,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3306,
        "hostPort": 3306
      }
    ],
    "command": [],
    "entryPoint": [],
    "links": [],
    "mountPoints": [],
    "volumesFrom": []
  }
]
