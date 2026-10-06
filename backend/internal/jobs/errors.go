package jobs

import (
	"context"
	"errors"
	"net"
	"strings"
	"syscall"

	"github.com/visualkit/backend/internal/providers"
)

type ErrorClass string

const (
	ErrorClassRetryable ErrorClass = "retryable"
	ErrorClassPermanent ErrorClass = "permanent"
)

var (
	ErrProviderTimeout   = errors.New("provider timeout")
	ErrTemporaryNetwork  = errors.New("temporary network failure")
	ErrTemporaryAWS      = errors.New("temporary AWS failure")
	ErrInvalidImage      = providers.ErrInvalidImage
	ErrInvalidPrompt     = providers.ErrInvalidPrompt
	ErrUnsupportedConfig = errors.New("unsupported configuration")
	ErrInvalidProvider   = providers.ErrInvalidProviderRequest
)

func ClassifyError(err error) ErrorClass {
	if err == nil {
		return ErrorClassPermanent
	}
	var providerError *providers.ProviderError
	if errors.As(err, &providerError) {
		if providerError.Retryable {
			return ErrorClassRetryable
		}
		return ErrorClassPermanent
	}
	if errors.Is(err, context.DeadlineExceeded) ||
		errors.Is(err, ErrProviderTimeout) ||
		errors.Is(err, ErrTemporaryNetwork) ||
		errors.Is(err, ErrTemporaryAWS) {
		return ErrorClassRetryable
	}
	var netError net.Error
	if errors.As(err, &netError) && (netError.Timeout() || netError.Temporary()) {
		return ErrorClassRetryable
	}
	if errors.Is(err, syscall.ECONNRESET) || errors.Is(err, syscall.ECONNREFUSED) {
		return ErrorClassRetryable
	}
	if strings.Contains(strings.ToLower(err.Error()), "timeout") {
		return ErrorClassRetryable
	}
	return ErrorClassPermanent
}
