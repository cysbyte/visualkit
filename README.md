# VisualKit

VisualKit is an AI image creation product focused on understanding and reusing the visual style of reference images.

## Repository Layout

- `ios/` - Native SwiftUI iPhone application. Owns Photos access, local presentation, structured generation state, and API client abstractions.
- `backend/` - Go HTTP API. Owns authentication, durable job records, request validation, object-storage references, and worker orchestration.
- `backend/cmd/worker` - Go asynchronous worker service for image analysis and image generation jobs.
- `infrastructure/` - Deployment boundaries for Docker, AWS ECS/Fargate, S3, SQS, PostgreSQL, IAM, and observability.
- `docs/` - Product and architecture documentation.

The iOS application communicates only with the Go backend. It never communicates directly with SQS, ECS, AWS credentials, or image-generation providers.

The backend resolves the authenticated user through an `AuthProvider` and
scopes all user-owned resources by that identity. `X-User-ID` is available only
for local development authentication.

## Current Status

- Native iOS client: implemented with local/mock services.
- Go backend: local development API scaffold with asynchronous job contracts.
- Worker: shared asynchronous Go worker with separate analysis and generation processors.
- Infrastructure: Terraform AWS deployment for the API, worker, ALB, VPC, RDS, S3, SQS, IAM, ECR, autoscaling, and CloudWatch.

## Build And Test

```bash
cd ios
xcodebuild -project VisualKit.xcodeproj -scheme VisualKit -sdk iphonesimulator build

cd ../backend
go test ./...
```

The backend and workers are intentionally provider-neutral at this stage. AI provider credentials belong only in backend/worker runtime configuration, never in the iOS target.

## Template Test Image

To generate a reference photo for the “Volumetric Laser on Black Poster” template:

```bash
python3 scripts/generate-template-test-image.py --dry-run
python3 scripts/generate-template-test-image.py --output output/imagegen/laser-test-v2.png
```

The script uses `GATEWAY_IMAGE_UPSTREAM_API_KEY` and `GATEWAY_IMAGE_UPSTREAM_BASE_URL` (or `OPENAI_API_KEY` and `OPENAI_BASE_URL`). By default it also reads the local TokenDuoDuo gateway `.env` if present; use `--env-file` to choose another file. Pass `--prompt` to generate another reference, or `--force` to replace an existing image. The output must be PNG and under the application's 8 MB upload limit.

See [infrastructure/README.md](infrastructure/README.md) for Terraform
bootstrap, environment setup, image deployment, migrations, rollback, and
production authentication requirements.








