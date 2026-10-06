variable "project_name" {
  type        = string
  description = "Short application name used in resource names."
  default     = "visualkit"
}

variable "environment" {
  type        = string
  description = "Deployment environment."

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "environment must be development, staging, or production."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for the deployment."
}

variable "availability_zones" {
  type        = list(string)
  description = "At least two AZs are required for production-grade networking."

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "availability_zones must contain at least two zones."
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "container_image_api" {
  type        = string
  description = "ECR image URI and tag for the API container."
}

variable "container_image_worker" {
  type        = string
  description = "ECR image URI and tag for the worker container."
}

variable "api_cpu" {
  type    = number
  default = 512
}

variable "api_memory" {
  type    = number
  default = 1024
}

variable "worker_cpu" {
  type    = number
  default = 1024
}

variable "worker_memory" {
  type    = number
  default = 2048
}

variable "api_desired_count" {
  type    = number
  default = 2
}

variable "worker_desired_count" {
  type    = number
  default = 1
}

variable "worker_min_capacity" {
  type    = number
  default = 1
}

variable "worker_max_capacity" {
  type    = number
  default = 10
}

variable "api_min_capacity" {
  type    = number
  default = 2
}

variable "api_max_capacity" {
  type    = number
  default = 10
}

variable "database_name" {
  type    = string
  default = "visualkit"
}

variable "database_username" {
  type      = string
  sensitive = true
  default   = "visualkit"
}

variable "database_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "database_allocated_storage" {
  type    = number
  default = 20
}

variable "database_backup_retention_days" {
  type    = number
  default = 7
}

variable "database_multi_az" {
  type    = bool
  default = true
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for the HTTPS listener."
}

variable "api_domain_name" {
  type        = string
  description = "DNS name used by the API certificate and Route 53 records outside this stack."
}

variable "auth_mode" {
  type    = string
  default = "bearer"
}

variable "vision_provider" {
  type    = string
  default = "mock"
}

variable "vision_endpoint" {
  type    = string
  default = ""
}

variable "vision_api_key_secret_arn" {
  type        = string
  default     = ""
  description = "Optional Secrets Manager ARN containing the vision provider API key."
}

variable "image_generation_provider" {
  type    = string
  default = "mock"
}

variable "image_generation_endpoint" {
  type    = string
  default = ""
}

variable "worker_provider_timeout" {
  type    = string
  default = "2m"
}

variable "worker_concurrency" {
  type    = number
  default = 4
}

variable "worker_max_attempts" {
  type    = number
  default = 3
}

variable "generation_credit_cost" {
  type    = number
  default = 80
}

variable "image_generation_api_key_secret_arn" {
  type        = string
  default     = ""
  description = "Optional Secrets Manager ARN containing the image generation provider API key."
}

variable "internal_job_token_secret_arn" {
  type        = string
  default     = ""
  description = "Optional Secrets Manager ARN containing the worker callback token."
}

variable "db_secret_kms_key_arn" {
  type        = string
  default     = ""
  description = "Optional KMS key ARN used to decrypt the database secret."
}

variable "api_secrets_kms_key_arns" {
  type        = set(string)
  default     = []
  description = "Optional KMS key ARNs used by Secrets Manager secrets injected into the API task."
}

variable "worker_secrets_kms_key_arns" {
  type        = set(string)
  default     = []
  description = "Optional KMS key ARNs used by Secrets Manager secrets injected into the worker task."
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "s3_force_destroy" {
  type    = bool
  default = false
}

variable "sqs_visibility_timeout_seconds" {
  type    = number
  default = 900

  validation {
    condition     = var.sqs_visibility_timeout_seconds >= 60 && var.sqs_visibility_timeout_seconds <= 43200
    error_message = "sqs_visibility_timeout_seconds must be between 60 and 43200."
  }
}

variable "sqs_max_receive_count" {
  type    = number
  default = 3

  validation {
    condition     = var.sqs_max_receive_count >= 1
    error_message = "sqs_max_receive_count must be at least 1."
  }
}

variable "enable_deletion_protection" {
  type    = bool
  default = true
}
