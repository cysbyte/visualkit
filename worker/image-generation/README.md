# VisualKit Image Generation Worker

Asynchronous worker boundary for creating images from structured generation requests.

The worker receives a job ID and backend-owned request reference, then reports an output object reference and metadata to the Go API. Provider integrations belong here or behind a backend-owned provider adapter, never in iOS.

```bash
go test ./...
go run ./cmd/worker
```
