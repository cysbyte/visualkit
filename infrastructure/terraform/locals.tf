locals {
  name = "${var.project_name}-${var.environment}"

  common_environment = [
    {
      name  = "APP_ENV"
      value = var.environment
    },
    {
      name  = "AUTH_MODE"
      value = var.auth_mode
    },
    {
      name  = "S3_REGION"
      value = var.aws_region
    },
    {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.assets.id
    },
    {
      name  = "SQS_REGION"
      value = var.aws_region
    },
    {
      name  = "SQS_QUEUE_URL"
      value = aws_sqs_queue.jobs.url
    },
    {
      name  = "VISION_PROVIDER"
      value = var.vision_provider
    },
    {
      name  = "VISION_ENDPOINT"
      value = var.vision_endpoint
    },
    {
      name  = "IMAGE_GENERATION_PROVIDER"
      value = var.image_generation_provider
    },
    {
      name  = "IMAGE_GENERATION_ENDPOINT"
      value = var.image_generation_endpoint
    },
    {
      name  = "GENERATION_CREDIT_COST"
      value = tostring(var.generation_credit_cost)
    },
    {
      name  = "WORKER_PROVIDER_TIMEOUT"
      value = var.worker_provider_timeout
    },
    {
      name  = "WORKER_CONCURRENCY"
      value = tostring(var.worker_concurrency)
    },
    {
      name  = "WORKER_MAX_ATTEMPTS"
      value = tostring(var.worker_max_attempts)
    },
    {
      name  = "S3_VERIFY_OBJECT_ON_COMPLETE"
      value = "true"
    }
  ]

  database_secret_arn = aws_secretsmanager_secret.database.arn

}
