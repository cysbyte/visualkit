# VisualKit Backend

Production-oriented Go API foundation for the VisualKit iOS client.

## Responsibilities

- Authentication and authorization boundary.
- Image asset metadata and upload orchestration boundary.
- Structured Visual DNA analysis jobs.
- Structured image generation jobs.
- Saved styles and creation history.
- Templates and credit balance.
- PostgreSQL persistence and migration execution.
- Provider and queue abstractions without real integrations yet.
- Authentication boundary and per-user resource isolation.

The iOS app communicates with this API only. It does not receive AWS credentials, SQS URLs, ECS identifiers, or provider API keys.

## Run Locally

Requirements:

- Go 1.22+
- PostgreSQL
- `DATABASE_URL` configured

```bash
cp .env.example .env
set -a
source .env
set +a
go run ./cmd/api
```

Run database migrations as a separate deployment task with
`/app/visualkit-migrate`. The API and worker do not race migrations during
service startup.

## Routes

- `GET /health` - process liveness.
- `GET /ready` - PostgreSQL readiness.
- `GET /v1/templates` - template catalog.
- `POST /v1/image-assets` - create image asset metadata.
- `POST /v1/assets/upload-url` - create a short-lived presigned S3 upload URL.
- `POST /v1/assets/{id}/complete` - verify a direct upload and mark the asset ready.
- `GET /v1/assets/{id}/url` - create a short-lived presigned S3 download URL.
- `POST /v1/image-analysis` - enqueue image analysis for `{ "asset_id": "uuid" }`.
- `POST /v1/image-analysis/jobs` - legacy alias for image analysis.
- `POST /v1/image-generation/jobs` - enqueue image generation.
- `POST /v1/jobs/image-analysis` - enqueue image analysis.
- `POST /v1/jobs/image-generation` - enqueue image generation.
- `GET /v1/jobs/{id}` - read an owned job.
- `POST /v1/jobs/{id}/cancel` - request cooperative cancellation.
- `POST /v1/styles` - create a saved style from structured Visual DNA.
- `GET /v1/styles` - list the current user's saved styles.
- `GET /v1/styles/{style_id}` - retrieve one owned saved style.
- `PATCH /v1/styles/{style_id}` - partially update an owned saved style.
- `DELETE /v1/styles/{style_id}` - delete an owned saved style.
- `GET /v1/creations?limit=30&cursor=...` - paginated creation history with signed image URLs.
- `GET /v1/creations/{creation_id}` - detailed creation metadata with signed image URLs.
- `DELETE /v1/creations/{creation_id}` - delete a creation and its generated assets.
- `GET /v1/credits/balance` - current credit balance.
- `GET /v1/generation/estimate?template_id={uuid}&aspect_ratio=4:5` - backend-calculated generation cost.
- `POST /internal/jobs/{id}/status` - worker status callback.

## Authentication and User Isolation

All `/v1` routes require authentication. The HTTP layer resolves an
`AuthenticatedUser` through `AuthProvider`, ensures the local `users` record
exists, and attaches the identity to request context. Handlers never use a
client-supplied `user_id` as the owner.

Local development uses:

```env
AUTH_MODE=development
DEVELOPMENT_USER_ID=uuid
```

`X-User-ID` is accepted only by the development authentication provider. It is
not read by production-mode handlers. Production deployments must use
`AUTH_MODE=bearer` and inject a provider-specific bearer-token verifier through
the `httpapi.Dependencies.Auth` interface. Provider SDKs and token validation
details remain outside handlers and services.

Every user-owned asset, job, saved style, creation, and credit query is scoped
by the authenticated local user ID. Cross-user lookups return `NOT_FOUND`.
Worker status callbacks use the separate internal boundary and require
`INTERNAL_JOB_TOKEN` outside development mode.

Completed image-analysis jobs return `result.visual_dna` with the versioned
structured Visual DNA schema. Each category contains `attributes`,
`observations`, `inferences`, and `confidence`; the backend never stores a
provider-generated image-generation prompt as the primary analysis result.

## Saved Styles

Saved styles persist reusable, structured Visual DNA independently from
templates and user prompts. A style and its optional preview asset belong to
the authenticated user; preview images remain private and are returned through
temporary signed download URLs. Reusing a style copies its Visual DNA into a
generation draft without changing the draft's prompt, template, aspect ratio,
or other generation settings.

## Credits

Credits are authoritative on the backend. Immutable ledger entries record
grants, purchases, generation reservations, refunds, and adjustments. A
generation reserves its calculated cost before the job is accepted; the
reservation is finalized when the job completes and refunded only when the
job permanently fails. Idempotent generation retries reuse the original job
and reservation.

## Generation Configuration

Image-generation requests contain structured intent. The client does not send
provider-specific prompt syntax:

```json
{
  "prompt": "A woman riding a bicycle in Paris",
  "template_id": "uuid",
  "visual_dna": {},
  "preservation": {
    "style": true,
    "lighting": true,
    "color": true,
    "camera": false
  },
  "generation_settings": {
    "aspect_ratio": "4:5"
  }
}
```

The backend loads the active template, applies only the selected Visual DNA
categories, merges template defaults with explicit generation settings, and
constructs the provider request. Template directives never overwrite the
original prompt. Creations persist both `original_prompt` and the internal
`resolved_generation_prompt`; the latter is not part of the client-owned
prompt state.

The worker reads the private reference object from S3 through the storage
abstraction. SQS messages contain only the job ID, type, and attempt number.

## Image Generation Providers

The worker uses `ImageGenerationProvider`. Local development uses the
deterministic fake provider. Set `IMAGE_GENERATION_PROVIDER` to a non-`mock`
value and configure `IMAGE_GENERATION_ENDPOINT` plus
`IMAGE_GENERATION_API_KEY` to use the provider-neutral HTTP adapter.

The adapter sends structured generation intent, including the original prompt,
resolved prompt, template directives, filtered Visual DNA, preservation
settings, aspect ratio, and an optional reference image. Provider failures are
classified as retryable or permanent before the worker applies its SQS retry
policy. Credentials remain server-side and are never exposed to iOS.

Development authentication uses `X-User-ID`, or a stable generated local user when `AUTH_MODE=development`.

## Asynchronous Jobs

Analysis and generation requests only validate input, persist a PostgreSQL job,
and enqueue a small SQS message. The API never calls an AI provider or waits for
provider work.

Job messages contain identifiers only:

```json
{
  "job_id": "uuid",
  "type": "image_analysis",
  "attempt": 1
}
```

Large prompts, Visual DNA, images, and binary data stay in PostgreSQL or private
object storage. Workers load the job by ID, check cancellation before expensive
work, and report status through the internal job status boundary.

Supported job types:

- `image_analysis`
- `image_generation`

Supported statuses:

- `queued`
- `processing`
- `completed`
- `failed`
- `cancelled`

Generation requests should send an `Idempotency-Key` UUID header. Repeating the
same generation request with the same key returns the original job and does not
enqueue a second message. Reusing the key with different input is rejected.

If PostgreSQL creation succeeds but queue enqueueing fails, the API marks the
job `failed` with `QUEUE_ENQUEUE_FAILED`. This leaves a durable record for a
future reconciliation process instead of leaving a silently stuck `queued` job.

Worker failures should classify as retryable or permanent. Retryable failures
such as provider timeouts and temporary AWS/network errors should be allowed to
return to SQS through its visibility-timeout/redelivery policy. Permanent
failures such as invalid images, prompts, or provider configuration should mark
the job `failed`.

## Direct Image Upload Contract

Image bytes never pass through the Go API. The S3 bucket remains private, and the
iOS application never receives AWS credentials.

1. Request an upload URL:

   ```http
   POST /v1/assets/upload-url
   Content-Type: application/json

   {
     "filename": "reference.jpg",
     "content_type": "image/jpeg",
     "size_bytes": 1234567
   }
   ```

   The response is wrapped in the standard API envelope:

   ```json
   {
     "data": {
       "asset_id": "uuid",
       "upload_url": "https://signed-s3-url",
       "object_key": "users/user-id/assets/asset-id/original",
       "expires_in": 900
     },
     "error": null
   }
   ```

2. Upload the bytes directly to the returned `upload_url` using the signed
   request headers, including the `Content-Type` used in the request.

3. Complete the upload:

   ```http
   POST /v1/assets/{asset_id}/complete
   Content-Type: application/json

   {
     "object_key": "users/user-id/assets/asset-id/original",
     "size_bytes": 1234567,
     "content_type": "image/jpeg",
     "pixel_width": 1200,
     "pixel_height": 1500
   }
   ```

   The API checks ownership, the server-generated object key, object existence,
   size, and content type before transitioning the asset from `pending` to
   `ready`.

4. Use `asset_id` in later image-analysis and image-generation requests. Do not
   send filenames or S3 object keys as domain references.

5. Request a temporary private download URL when displaying the asset:

   ```http
   GET /v1/assets/{asset_id}/url
   ```

No multipart proxy upload endpoint is provided. Generated images and thumbnails
use the same asset abstraction; their object keys are server-generated under
`users/{user_id}/creations/{creation_id}/generated` when that workflow is added.

## Validation

```bash
GOCACHE=/tmp/visualkit-go-cache go test ./...
GOCACHE=/tmp/visualkit-go-cache go vet ./...
```
