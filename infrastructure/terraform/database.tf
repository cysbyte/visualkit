resource "random_password" "database" {
  length           = 32
  special          = true
  override_special = "-_"
}

resource "aws_db_subnet_group" "database" {
  name       = local.name
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_db_instance" "database" {
  identifier                 = local.name
  engine                     = "postgres"
  engine_version             = "16"
  instance_class             = var.database_instance_class
  allocated_storage          = var.database_allocated_storage
  storage_type               = "gp3"
  storage_encrypted          = true
  db_name                    = var.database_name
  username                   = var.database_username
  password                   = random_password.database.result
  port                       = 5432
  db_subnet_group_name       = aws_db_subnet_group.database.name
  vpc_security_group_ids     = [aws_security_group.database.id]
  publicly_accessible        = false
  multi_az                   = var.database_multi_az
  backup_retention_period    = var.database_backup_retention_days
  backup_window              = "03:00-04:00"
  maintenance_window         = "sun:04:00-sun:05:00"
  auto_minor_version_upgrade = true
  deletion_protection        = var.enable_deletion_protection && var.environment == "production"
  skip_final_snapshot        = var.environment != "production"
  final_snapshot_identifier  = var.environment == "production" ? "${local.name}-final" : null
  apply_immediately          = var.environment != "production"
}

resource "aws_secretsmanager_secret" "database" {
  name                    = "${local.name}/database"
  recovery_window_in_days = var.environment == "production" ? 30 : 0
  kms_key_id              = var.db_secret_kms_key_arn != "" ? var.db_secret_kms_key_arn : null
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    database_url = "postgres://${var.database_username}:${random_password.database.result}@${aws_db_instance.database.address}:5432/${var.database_name}?sslmode=require"
  })

  depends_on = [aws_db_instance.database]
}
