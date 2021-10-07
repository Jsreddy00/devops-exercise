terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "management" {

 ami           = "ami-03d5c68bab01f3496"

 instance_type = "t2.micro"

 tags = {
   "Name" = "Management Server"
 }

}


resource "aws_ecs_cluster" "default" {
  name = "default"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}


resource "aws_ecs_task_definition" "first-run-task-definition" {
  family = "first-run-task-definition"
  container_definitions = jsonencode ([
    {
      command = []
      entrypoint = []
      environment = []
      links = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/first-run-task-definition"
          awslogs-region        = "us-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
      name = "devops-exercise"
      image = "363206127743.dkr.ecr.us-west-2.amazonaws.com/devops-repo"
      cpu = 0
      mountPoints = []
      essential = true
      portMappings = [
        {
          protocol = "tcp"
          containerPort = 80
          hostPort = 80
        }
      ]
      volumesFrom = []
    }
  ])
  cpu = "256"
  execution_role_arn       = "arn:aws:iam::363206127743:role/ecsTaskExecutionRole"
  memory                   = "512"
  requires_compatibilities = ["FARGATE",]
  tags = {}
}

resource "aws_ecs_service" "devops-exercise-service" {
  name = "devops-exercise-service"
  cluster = "arn:aws:ecs:us-west-2:363206127743:cluster/default"
  task_definition = "first-run-task-definition:1"
  desired_count = 1
  iam_role = "aws-service-role"
  wait_for_steady_state = null
  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:363206127743:targetgroup/EC2Co-Defau-1SR2ZDUQ8XY7K/75c1ae5f13b0e556"
    container_name = "devops-exercise"
    container_port = "80"
  }
  network_configuration {
    assign_public_ip = true
    security_groups = ["sg-03c4a8b5d47973ca9"]
    subnets = ["subnet-06d725927a275e9e1","subnet-0f4db417b54d2c767"]
  }

}