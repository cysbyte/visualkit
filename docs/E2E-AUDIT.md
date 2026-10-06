# VisualKit End-to-End Audit

Date: 2026-09-25

## Scope

The audited flow is:

```text
iOS
  -> Go API
  -> presigned S3 upload
  -> PostgreSQL asset metadata
  -> PostgreSQL job
  -> SQS
  -> backend worker
  -> vision/image provider
  -> private S3 output
  -> PostgreSQL Visual DNA/creation/job result
  -> iOS polling and signed-URL display
```

The repository has no live AWS account, PostgreSQL instance, SQS queue, or
configured external AI provider available to this audit environment. Automated
tests cover the service and worker boundaries with fakes. The procedure below
is the required staging smoke test before production traffic.

## Automated Verification

Passed:

- `cd backend && GOCACHE=/tmp/visualkit-go-cache go test ./...`
- `cd backend && GOCACHE=/tmp/visualkit-go-cache go vet ./...`
- `cd backend && GOCACHE=/tmp/visualkit-go-cache go build ./cmd/api ./cmd/worker ./cmd/migrate`
- `cd worker/image-analysis && GOCACHE=/tmp/visualkit-analysis-cache go test ./...`
- `cd worker/image-generation && GOCACHE=/tmp/visualkit-generation-cache go test ./...`
- `cd ios && xcodebuild -project VisualKit.xcodeproj -scheme VisualKit -sdk iphonesimulator -configuration Debug -derivedDataPath /tmp/visualkit-audit-ios build CODE_SIGNING_ALLOWED=NO`

Not run:

- `terraform validate`: Terraform is not installed in the audit environment.
- Interactive simulator execution: CoreSimulator runtimes/services are
  unavailable in the audit environment.
- Live S3/SQS/PostgreSQL/provider integration: no staging credentials or
  endpoints were provided.

## Staging Smoke Test

Set:

```bash
export API_BASE_URL="https://api-staging.example.com"
export USER_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
export DATABASE_URL="..."
export S3_BUCKET="..."
export AWS_REGION="us-east-1"
```

Use a real bearer token in `Authorization` for staging. The `X-User-ID`
header is only valid when the backend is explicitly running in development
authentication mode.

### 1. Verify deployment and migrations

```bash
curl -fsS "$API_BASE_URL/health"
curl -fsS "$API_BASE_URL/ready"
```

Expected:

- `/health` returns HTTP 200.
- `/ready` returns HTTP 200 only after PostgreSQL is reachable.
- `schema_migrations` contains migrations `001_core.sql` through
  `007_credit_accounting.sql`.

### 2. Request and complete a reference upload

```bash
UPLOAD_JSON="$(
  curl -fsS -X POST "$API_BASE_URL/v1/assets/upload-url" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"filename":"reference.jpg","content_type":"image/jpeg","size_bytes":REPLACE_BYTES}'
)"

ASSET_ID="$(jq -r '.data.asset_id' <<<"$UPLOAD_JSON")"
UPLOAD_URL="$(jq -r '.data.upload_url' <<<"$UPLOAD_JSON")"
OBJECT_KEY="$(jq -r '.data.object_key' <<<"$UPLOAD_JSON")"

curl -fsS -X PUT "$UPLOAD_URL" \
  -H "Content-Type: image/jpeg" \
  --upload-file reference.jpg

curl -fsS -X POST "$API_BASE_URL/v1/assets/$ASSET_ID/complete" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"object_key\":\"$OBJECT_KEY\",
    \"size_bytes\":REPLACE_BYTES,
    \"content_type\":\"image/jpeg\",
    \"pixel_width\":1200,
    \"pixel_height\":1500
  }"
```

Expected:

- The object key is server-generated and matches
  `users/{user_id}/assets/{asset_id}/original`.
- The API never receives image bytes.
- The asset transitions to `ready`.
- A different authenticated user cannot complete, download, or analyze the
  asset.

### 3. Analyze the reference image

```bash
ANALYSIS_JSON="$(
  curl -fsS -X POST "$API_BASE_URL/v1/image-analysis" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"asset_id\":\"$ASSET_ID\"}"
)"
ANALYSIS_JOB_ID="$(jq -r '.data.job_id' <<<"$ANALYSIS_JSON")"

until STATUS_JSON="$(
  curl -fsS "$API_BASE_URL/v1/jobs/$ANALYSIS_JOB_ID" \
    -H "Authorization: Bearer $TOKEN"
)"; do sleep 2; done

while [[ "$(jq -r '.data.status' <<<"$STATUS_JSON")" =~ ^(queued|processing)$ ]]; do
  sleep 2
  STATUS_JSON="$(
    curl -fsS "$API_BASE_URL/v1/jobs/$ANALYSIS_JOB_ID" \
      -H "Authorization: Bearer $TOKEN"
  )"
done

printf '%s\n' "$STATUS_JSON" > /tmp/visualkit-analysis.json
jq '.data' <<<"$STATUS_JSON"
```

Expected completed result:

```json
{
  "status": "completed",
  "result": {
    "visual_dna": {
      "schema_version": 1,
      "style": {
        "attributes": [],
        "observations": [],
        "inferences": [],
        "confidence": 0
      }
    }
  }
}
```

The result must contain all ten structured categories. It must not be a single
provider-generated paragraph. Malformed provider JSON must produce a durable
failed job and must not be stored as Visual DNA.

### 4. Build a generation request

Fetch the template catalog and choose a returned active template ID:

```bash
curl -fsS "$API_BASE_URL/v1/templates" \
  -H "Authorization: Bearer $TOKEN" | jq '.data[] | {id,name}'
```

Estimate credits:

```bash
curl -fsS "$API_BASE_URL/v1/generation/estimate?template_id=$TEMPLATE_ID&aspect_ratio=4:5" \
  -H "Authorization: Bearer $TOKEN"
```

The iOS prompt remains independent from template and Visual DNA. The request
contains structured intent:

```json
{
  "prompt": "A woman riding a bicycle in Paris",
  "template_id": "TEMPLATE_UUID",
  "visual_dna": "VISUAL_DNA_OBJECT",
  "preservation": {
    "style": true,
    "lighting": true,
    "color": true,
    "composition": true,
    "camera": false,
    "depth_of_field": false,
    "mood": false,
    "texture": false,
    "subject": false,
    "background": false
  },
  "reference_asset_id": "ASSET_UUID",
  "generation_settings": {
    "aspect_ratio": "4:5"
  }
}
```

### 5. Generate and verify credits/idempotency

```bash
IDEMPOTENCY_KEY="$(uuidgen | tr '[:upper:]' '[:lower:]')"

GENERATION_RESPONSE="$(
  curl -fsS -X POST "$API_BASE_URL/v1/jobs/image-generation" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Idempotency-Key: $IDEMPOTENCY_KEY" \
    -H "Content-Type: application/json" \
    -d @generation-request.json
)"

GENERATION_JOB_ID="$(jq -r '.data.job_id' <<<"$GENERATION_RESPONSE")"
```

Repeat the same request with the same idempotency key. It must return the same
job ID and must not reserve credits a second time. Repeat with the same key and
different input; it must be rejected.

Poll:

```bash
while true; do
  curl -fsS "$API_BASE_URL/v1/jobs/$GENERATION_JOB_ID" \
    -H "Authorization: Bearer $TOKEN" | tee /tmp/visualkit-job.json
  STATUS="$(jq -r '.data.status' /tmp/visualkit-job.json)"
  [[ "$STATUS" == "completed" || "$STATUS" == "failed" || "$STATUS" == "cancelled" ]] && break
  sleep 3
done
```

Expected completed output includes a creation identifier. Then:

```bash
CREATION_ID="$(jq -r '.data.output.creationId // .data.output.creation_id' /tmp/visualkit-job.json)"
curl -fsS "$API_BASE_URL/v1/creations/$CREATION_ID" \
  -H "Authorization: Bearer $TOKEN"
```

Verify:

- the original prompt is unchanged;
- the selected template is retained;
- only selected Visual DNA categories were applied;
- the generated image and optional thumbnail are private S3 objects;
- the creation stores prompt, template, Visual DNA, preservation settings,
  reference asset, and generation settings;
- a permanent failure refunds the reservation exactly once;
- a retryable failure keeps the reservation until completion or permanent
  failure.

### 6. Save and reuse a style

```bash
STYLE_RESPONSE="$(
  curl -fsS -X POST "$API_BASE_URL/v1/styles" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"name\":\"Warm Cinematic\",
      \"visual_dna\":$(jq -c '.data.result.visual_dna' /tmp/visualkit-analysis.json)
    }"
)"

STYLE_ID="$(jq -r '.data.id' <<<"$STYLE_RESPONSE")"
curl -fsS "$API_BASE_URL/v1/styles/$STYLE_ID" \
  -H "Authorization: Bearer $TOKEN"
```

Use the returned Visual DNA in a second generation request. The prompt and
template must remain independently configurable. Verify the second creation
appears in:

```bash
curl -fsS "$API_BASE_URL/v1/creations?limit=30" \
  -H "Authorization: Bearer $TOKEN"
```

The list response should contain signed thumbnail URLs and concise metadata.
The detail endpoint should contain complete Visual DNA and generation metadata.

## Audit Findings And Fixes

Fixed during this audit:

- Worker startup now honors `VISION_PROVIDER` instead of always using the mock
  vision provider.
- Added a provider-neutral HTTP vision adapter with strict structured Visual
  DNA parsing and response-size limits.
- Vision and image-generation provider credentials are worker-only Terraform
  secrets; the API task no longer receives AI provider keys.
- Worker retry exhaustion uses the durable PostgreSQL attempt count instead of
  trusting the SQS message attempt field.
- Worker shutdown stops receiving new messages and allows active jobs to finish
  inside the configured shutdown window before cancelling their context.
- Generation no longer creates a ready thumbnail asset when the provider did
  not return thumbnail bytes.
- Worker checks durable cancellation immediately before provider work and after
  provider work.
- iOS direct-to-S3 uploads now expose progress through the upload service
  abstraction; URLSession delegate code remains outside SwiftUI views.

Verified by inspection/tests:

- iOS contains no AWS SDK, SQS/ECS/PostgreSQL access, or AI provider keys.
- API and worker use parameterized pgx queries.
- Ownership is derived from authentication context and applied to assets,
  jobs, styles, creations, and credit operations.
- S3 public access is blocked and access uses presigned URLs.
- Upload content types, extensions, byte limits, object key, object size, and
  object content type are validated.
- SQS messages contain only job identifiers, type, and attempt.
- SQS long polling, visibility timeout, redrive policy, and DLQ are configured.
- Credit reservations are protected by database transactions and row locks.
- Generation idempotency is scoped by authenticated user and request payload.
- iOS networking and job polling are outside SwiftUI views.
- Template selection and saved styles do not overwrite the visible prompt.
- Creation list uses cursor pagination and signed thumbnail URLs.

Blocked or limited:

- Terraform syntax/plan validation requires Terraform to be installed.
- A production bearer-token verifier is an injected adapter boundary; the
  default API entrypoint intentionally fails closed when no verifier is wired.
- The live provider contract is deliberately provider-neutral and needs a
  concrete adapter contract test when the chosen vendor is selected.
- The complete AWS-backed flow still requires a real staging environment and
  credentials.
- The repository still contains two standalone worker example modules under
  `worker/`; Terraform deploys `backend/cmd/worker`, which is the actual
  production worker. They should be treated as examples, not deploy targets.
