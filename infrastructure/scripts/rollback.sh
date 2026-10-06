#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="${AWS_REGION:?AWS_REGION is required}"
ECS_CLUSTER="${ECS_CLUSTER:?ECS_CLUSTER is required}"
API_SERVICE="${API_SERVICE:?API_SERVICE is required}"
WORKER_SERVICE="${WORKER_SERVICE:?WORKER_SERVICE is required}"
API_TASK_DEFINITION="${API_TASK_DEFINITION:?API_TASK_DEFINITION is required}"
WORKER_TASK_DEFINITION="${WORKER_TASK_DEFINITION:?WORKER_TASK_DEFINITION is required}"

aws ecs update-service \
  --region "${AWS_REGION}" \
  --cluster "${ECS_CLUSTER}" \
  --service "${API_SERVICE}" \
  --task-definition "${API_TASK_DEFINITION}" \
  --force-new-deployment

aws ecs update-service \
  --region "${AWS_REGION}" \
  --cluster "${ECS_CLUSTER}" \
  --service "${WORKER_SERVICE}" \
  --task-definition "${WORKER_TASK_DEFINITION}" \
  --force-new-deployment

aws ecs wait services-stable \
  --region "${AWS_REGION}" \
  --cluster "${ECS_CLUSTER}" \
  --services "${API_SERVICE}" "${WORKER_SERVICE}"
