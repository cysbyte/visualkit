# VisualKit Image Analysis Worker

Asynchronous worker boundary for extracting structured Visual DNA from reference images.

The worker receives backend-owned job identifiers and object references. It does not expose public iOS endpoints and does not receive AWS credentials or provider keys from queue messages.

```bash
go test ./...
go run ./cmd/worker
```
