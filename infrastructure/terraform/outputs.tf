output "api_url" {
  value = "https://${var.api_domain_name}"
}

output "load_balancer_dns_name" {
  value = aws_lb.api.dns_name
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.id
}

output "jobs_queue_url" {
  value = aws_sqs_queue.jobs.url
}

output "jobs_dlq_url" {
  value = aws_sqs_queue.jobs_dlq.url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "api_ecr_repository_url" {
  value = aws_ecr_repository.api.repository_url
}

output "worker_ecr_repository_url" {
  value = aws_ecr_repository.worker.repository_url
}

output "database_secret_arn" {
  value     = aws_secretsmanager_secret.database.arn
  sensitive = true
}

output "database_endpoint" {
  value     = aws_db_instance.database.address
  sensitive = true
}
