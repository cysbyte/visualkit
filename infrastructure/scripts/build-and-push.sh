#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKEND_DIR="${ROOT_DIR}/backend"

AWS_REGION="${AWS_REGION:?AWS_REGION is required}"
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:?AWS_ACCOUNT_ID is required}"
ENVIRONMENT="${ENVIRONMENT:?ENVIRONMENT is required: development, staging, or production}"
PROJECT_NAME="${PROJECT_NAME:-visualkit}"
IMAGE_TAG="${IMAGE_TAG:-$(date -u +%Y%m%d-%H%M%S)}"
ECR_PREFIX="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-${ENVIRONMENT}"

aws ecr get-login-password --region "${AWS_REGION}" |
  docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

docker build \
  --file "${BACKEND_DIR}/Dockerfile" \
  --tag "${ECR_PREFIX}/api:${IMAGE_TAG}" \
  "${BACKEND_DIR}"

docker build \
  --file "${BACKEND_DIR}/Dockerfile.worker" \
  --tag "${ECR_PREFIX}/worker:${IMAGE_TAG}" \
  "${BACKEND_DIR}"

docker push "${ECR_PREFIX}/api:${IMAGE_TAG}"
docker push "${ECR_PREFIX}/worker:${IMAGE_TAG}"

printf 'API_IMAGE=%s\n' "${ECR_PREFIX}/api:${IMAGE_TAG}"
printf 'WORKER_IMAGE=%s\n' "${ECR_PREFIX}/worker:${IMAGE_TAG}"
