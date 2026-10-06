package jobs

import (
	"context"
	"errors"
	"testing"

	"github.com/visualkit/backend/internal/providers"
)

func TestClassifyError(t *testing.T) {
	tests := []struct {
		name  string
		err   error
		class ErrorClass
	}{
		{name: "provider timeout", err: ErrProviderTimeout, class: ErrorClassRetryable},
		{name: "context deadline", err: context.DeadlineExceeded, class: ErrorClassRetryable},
		{name: "temporary AWS", err: ErrTemporaryAWS, class: ErrorClassRetryable},
		{name: "invalid image", err: ErrInvalidImage, class: ErrorClassPermanent},
		{name: "invalid prompt", err: ErrInvalidPrompt, class: ErrorClassPermanent},
		{name: "unsupported configuration", err: ErrUnsupportedConfig, class: ErrorClassPermanent},
		{name: "unknown provider error", err: errors.New("provider rejected the request"), class: ErrorClassPermanent},
		{name: "provider retryable", err: providers.NewProviderError("RATE_LIMITED", true, errors.New("rate limited")), class: ErrorClassRetryable},
		{name: "provider permanent", err: providers.NewProviderError("INVALID_REQUEST", false, errors.New("invalid")), class: ErrorClassPermanent},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if class := ClassifyError(test.err); class != test.class {
				t.Fatalf("class = %q, want %q", class, test.class)
			}
		})
	}
}
