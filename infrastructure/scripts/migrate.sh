#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="${AWS_REGION:?AWS_REGION is required}"
ECS_CLUSTER="${ECS_CLUSTER:?ECS_CLUSTER is required}"
SUBNETS="${SUBNETS:?SUBNETS is required as a comma-separated subnet list}"
SECURITY_GROUPS="${SECURITY_GROUPS:?SECURITY_GROUPS is required as a comma-separated security-group list}"
TASK_DEFINITION="${TASK_DEFINITION:?TASK_DEFINITION is required}"
CONTAINER_NAME="${CONTAINER_NAME:-api}"

TASK_ARN="$(
  aws ecs run-task \
    --region "${AWS_REGION}" \
    --cluster "${ECS_CLUSTER}" \
    --launch-type FARGATE \
    --task-definition "${TASK_DEFINITION}" \
    --network-configuration "awsvpcConfiguration={subnets=[${SUBNETS}],securityGroups=[${SECURITY_GROUPS}],assignPublicIp=DISABLED}" \
    --overrides "{\"containerOverrides\":[{\"name\":\"${CONTAINER_NAME}\",\"command\":[\"/app/visualkit-migrate\"]}]}" \
    --query 'tasks[0].taskArn' \
    --output text
)"

aws ecs wait tasks-stopped \
  --region "${AWS_REGION}" \
  --cluster "${ECS_CLUSTER}" \
  --tasks "${TASK_ARN}"

EXIT_CODE="$(
  aws ecs describe-tasks \
    --region "${AWS_REGION}" \
    --cluster "${ECS_CLUSTER}" \
    --tasks "${TASK_ARN}" \
    --query "tasks[0].containers[?name=='${CONTAINER_NAME}'].exitCode | [0]" \
    --output text
)"

if [[ "${EXIT_CODE}" != "0" ]]; then
  aws ecs describe-tasks \
    --region "${AWS_REGION}" \
    --cluster "${ECS_CLUSTER}" \
    --tasks "${TASK_ARN}" \
    --output json
  exit 1
fi
