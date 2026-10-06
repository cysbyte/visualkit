#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TF_DIR="${ROOT_DIR}/infrastructure/terraform"

ENVIRONMENT="${ENVIRONMENT:?ENVIRONMENT is required: development, staging, or production}"
AWS_REGION="${AWS_REGION:?AWS_REGION is required}"
TFVARS_FILE="${TFVARS_FILE:-${TF_DIR}/${ENVIRONMENT}.tfvars}"
BACKEND_CONFIG="${BACKEND_CONFIG:-${TF_DIR}/backend-${ENVIRONMENT}.hcl}"
API_IMAGE="${API_IMAGE:?API_IMAGE is required}"
WORKER_IMAGE="${WORKER_IMAGE:?WORKER_IMAGE is required}"

if [[ ! -f "${TFVARS_FILE}" ]]; then
  printf 'Terraform variables file not found: %s\n' "${TFVARS_FILE}" >&2
  exit 1
fi

if [[ ! -f "${BACKEND_CONFIG}" ]]; then
  printf 'Terraform backend config not found: %s\n' "${BACKEND_CONFIG}" >&2
  exit 1
fi

terraform -chdir="${TF_DIR}" init \
  -backend-config="${BACKEND_CONFIG}"

terraform -chdir="${TF_DIR}" apply \
  -var-file="${TFVARS_FILE}" \
  -var="aws_region=${AWS_REGION}" \
  -var="container_image_api=${API_IMAGE}" \
  -var="container_image_worker=${WORKER_IMAGE}"

terraform -chdir="${TF_DIR}" output
