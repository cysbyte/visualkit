resource "aws_ecs_cluster" "main" {
  name = local.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${local.name}-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.api_cpu
  memory                   = var.api_memory
  execution_role_arn       = aws_iam_role.ecs_api_execution.arn
  task_role_arn            = aws_iam_role.api_task.arn

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = var.container_image_api
      essential = true
      portMappings = [{
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      }]
      environment = concat(local.common_environment, [
        {
          name  = "PORT"
          value = "8080"
        },
        {
          name  = "MIGRATIONS_DIR"
          value = "/app/migrations"
        }
      ])
      secrets = concat(
        [{
          name      = "DATABASE_URL"
          valueFrom = "${local.database_secret_arn}:database_url::"
        }],
        var.internal_job_token_secret_arn == "" ? [] : [{
          name      = "INTERNAL_JOB_TOKEN"
          valueFrom = var.internal_job_token_secret_arn
        }]
      )
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.api.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "api"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "worker" {
  family                   = "${local.name}-worker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.worker_cpu
  memory                   = var.worker_memory
  execution_role_arn       = aws_iam_role.ecs_worker_execution.arn
  task_role_arn            = aws_iam_role.worker_task.arn

  container_definitions = jsonencode([
    {
      name      = "worker"
      image     = var.container_image_worker
      essential = true
      environment = concat(local.common_environment, [
        {
          name  = "WORKER_VISIBILITY_TIMEOUT"
          value = "${var.sqs_visibility_timeout_seconds}s"
        },
        {
          name  = "WORKER_SHUTDOWN_TIMEOUT"
          value = "30s"
        }
      ])
      secrets = concat(
        [{
          name      = "DATABASE_URL"
          valueFrom = "${local.database_secret_arn}:database_url::"
        }],
        var.vision_api_key_secret_arn == "" ? [] : [{
          name      = "VISION_API_KEY"
          valueFrom = var.vision_api_key_secret_arn
        }],
        var.image_generation_api_key_secret_arn == "" ? [] : [{
          name      = "IMAGE_GENERATION_API_KEY"
          valueFrom = var.image_generation_api_key_secret_arn
        }]
      )
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.worker.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "worker"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "api" {
  name                               = "${local.name}-api"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.api.arn
  desired_count                      = var.api_desired_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  enable_execute_command             = var.environment != "production"
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.private : subnet.id]
    security_groups  = [aws_security_group.api.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port    = 8080
  }

  depends_on = [aws_lb_listener.https]
}

resource "aws_ecs_service" "worker" {
  name                               = "${local.name}-worker"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.worker.arn
  desired_count                      = var.worker_desired_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  enable_execute_command             = var.environment != "production"
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = [for subnet in aws_subnet.private : subnet.id]
    security_groups  = [aws_security_group.worker.id]
    assign_public_ip = false
  }
}
