# VisualKit Architecture

## Goal

VisualKit lets users create images from prompts, understand the visual characteristics of reference images, preserve selected Visual DNA, and reuse saved styles.

The repository separates the native iOS client, the request-oriented Go API, asynchronous image workers, and cloud infrastructure. Each boundary can evolve independently.

## Repository Boundaries

### `/ios`

Native SwiftUI iOS application.

- Uses PhotosPicker and native image APIs for local reference-image selection.
- Owns prompt text, Visual DNA editing, preservation settings, templates, style library, creations, and presentation.
- Calls only the Go backend client boundary when production networking is enabled.
- Polls backend-owned asynchronous job status through `JobService`.
- Does not contain SQS, ECS, AWS credentials, or provider SDKs.

### `/backend`

Go REST/JSON API and durable orchestration boundary.

- Authenticates users and authorizes creation/job records.
- Accepts structured image-analysis and image-generation requests.
- Stores job state and result references.
- Publishes identifier-only work messages to queues.
- Accepts worker callbacks and exposes job status to iOS.
- Does not perform long-running image analysis or generation in an HTTP request.

### `/backend/cmd/worker`

Asynchronous Go worker boundary.

- Consumes backend-owned jobs.
- Loads source image references from object storage through backend-issued references.
- Runs provider-independent analysis or generation implementations.
- Reports progress, completion, and failure to the Go API.
- Does not expose public iOS endpoints.
- Does not own user authentication or durable product state.

The current worker is one independently deployable ECS service with separate
processors:

- image analysis extracts structured Visual DNA.
- image generation creates an output image from the structured generation request.

### `/infrastructure`

Deployment boundary.

- Docker image definitions.
- ECS/Fargate services for API and worker.
- S3 object-storage layout.
- SQS queue and dead-letter queue.
- IAM policy boundaries.
- PostgreSQL migration and environment templates.

AWS resource definitions live in `infrastructure/terraform` and are parameterized
per environment.

## Core Data Flow

```text
iPhone
  │ structured request
  ▼
Go API
  │ persist job + publish identifier-only message
  ▼
SQS
  │
  ├── image-analysis worker
  └── image-generation worker
          │
          ├── report progress/result ──> Go API
          └── store output reference ──> object storage
                                      │
                                      ▼
                               iOS polls job status
```

Image bytes, Visual DNA payloads, prompts, and provider-specific instructions do not belong in SQS messages. Queue messages contain a job ID, job kind, and small version/configuration values. The API and object storage remain the durable source of truth.

## Job Contract

The client-visible status values are:

- `queued`
- `processing`
- `completed`
- `failed`

The iOS app does not need to know whether the backend uses SQS, ECS, another queue, or a different worker runtime. Replacing the mock implementation with the production API client must not require UI changes.

## Provider Boundary

AI provider APIs are worker/backend concerns. Provider keys and model configuration are runtime secrets for backend or worker deployments. They must never be embedded in the iOS application, queue messages, or client-visible models.
