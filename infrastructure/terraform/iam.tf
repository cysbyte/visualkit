data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_api_execution" {
  name               = "${local.name}-ecs-api-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_api_execution_managed" {
  role       = aws_iam_role.ecs_api_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_api_execution_secrets" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = concat(
      [aws_secretsmanager_secret.database.arn],
      compact([var.internal_job_token_secret_arn])
    )
  }

  dynamic "statement" {
    for_each = toset(compact(concat(
      [var.db_secret_kms_key_arn],
      tolist(var.api_secrets_kms_key_arns)
    )))

    content {
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = [statement.value]
    }
  }
}

resource "aws_iam_role_policy" "ecs_api_execution_secrets" {
  name   = "${local.name}-ecs-api-execution-secrets"
  role   = aws_iam_role.ecs_api_execution.id
  policy = data.aws_iam_policy_document.ecs_api_execution_secrets.json
}

resource "aws_iam_role" "ecs_worker_execution" {
  name               = "${local.name}-ecs-worker-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_worker_execution_managed" {
  role       = aws_iam_role.ecs_worker_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_worker_execution_secrets" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = concat(
      [aws_secretsmanager_secret.database.arn],
      compact([
        var.vision_api_key_secret_arn,
        var.image_generation_api_key_secret_arn
      ])
    )
  }

  dynamic "statement" {
    for_each = toset(compact(concat(
      [var.db_secret_kms_key_arn],
      tolist(var.worker_secrets_kms_key_arns)
    )))

    content {
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = [statement.value]
    }
  }
}

resource "aws_iam_role_policy" "ecs_worker_execution_secrets" {
  name   = "${local.name}-ecs-worker-execution-secrets"
  role   = aws_iam_role.ecs_worker_execution.id
  policy = data.aws_iam_policy_document.ecs_worker_execution_secrets.json
}

data "aws_iam_policy_document" "api_task" {
  statement {
    sid       = "S3AssetObjects"
    effect    = "Allow"
    actions   = ["s3:DeleteObject", "s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.assets.arn}/*"]
  }

  statement {
    sid       = "EnqueueJobs"
    effect    = "Allow"
    actions   = ["sqs:SendMessage", "sqs:GetQueueAttributes"]
    resources = [aws_sqs_queue.jobs.arn]
  }
}

resource "aws_iam_role" "api_task" {
  name               = "${local.name}-api-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy" "api_task" {
  name   = "${local.name}-api-task"
  role   = aws_iam_role.api_task.id
  policy = data.aws_iam_policy_document.api_task.json
}

data "aws_iam_policy_document" "worker_task" {
  statement {
    sid       = "ReadWriteAssetObjects"
    effect    = "Allow"
    actions   = ["s3:DeleteObject", "s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.assets.arn}/*"]
  }

  statement {
    sid       = "ConsumeJobs"
    effect    = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage"
    ]
    resources = [aws_sqs_queue.jobs.arn]
  }
}


resource "aws_iam_role" "worker_task" {
  name               = "${local.name}-worker-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy" "worker_task" {
  name   = "${local.name}-worker-task"
  role   = aws_iam_role.worker_task.id
  policy = data.aws_iam_policy_document.worker_task.json
}
