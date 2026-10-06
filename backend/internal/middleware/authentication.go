package middleware

import (
	"errors"
	"log/slog"
	"net/http"
	"strings"

	"github.com/visualkit/backend/internal/auth"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/pkg/api"
)

type AuthenticationMiddleware struct {
	Provider auth.AuthProvider
	Users    repositories.UserRepository
	Logger   *slog.Logger
}

func (middleware AuthenticationMiddleware) Handler(next http.Handler) http.Handler {
	logger := middleware.Logger
	if logger == nil {
		logger = slog.Default()
	}
	return http.HandlerFunc(func(response http.ResponseWriter, request *http.Request) {
		if isUnauthenticatedPath(request.URL.Path) {
			next.ServeHTTP(response, request)
			return
		}
		if middleware.Provider == nil {
			logger.Error("authentication provider is not configured")
			api.WriteError(response, api.ErrUnavailable)
			return
		}
		user, err := middleware.Provider.Authenticate(request.Context(), request)
		if err != nil {
			logger.Warn("authentication failed", slog.Any("error", err))
			api.WriteError(response, authenticationError(err))
			return
		}
		if err := user.Validate(); err != nil {
			api.WriteError(response, api.ErrInvalidCredentials)
			return
		}
		if middleware.Users == nil {
			logger.Error("user repository is not configured")
			api.WriteError(response, api.ErrUnavailable)
			return
		}
		if _, err := middleware.Users.Ensure(request.Context(), user.ID); err != nil {
			logger.Error("authenticated user persistence failed",
				slog.String("user_id", user.ID.String()),
				slog.Any("error", err))
			api.WriteError(response, api.ErrUnavailable)
			return
		}
		next.ServeHTTP(response, request.WithContext(
			auth.WithAuthenticatedUser(request.Context(), user),
		))
	})
}

func authenticationError(err error) error {
	switch {
	case errors.Is(err, auth.ErrProviderUnavailable):
		return api.ErrUnavailable
	case errors.Is(err, auth.ErrMissingCredentials):
		return api.ErrUnauthorized
	case errors.Is(err, auth.ErrInvalidCredentials):
		return api.ErrInvalidCredentials
	default:
		return api.ErrInvalidCredentials
	}
}

func isUnauthenticatedPath(path string) bool {
	return path == "/health" ||
		path == "/healthz" ||
		path == "/ready" ||
		strings.HasPrefix(path, "/internal/jobs/")
}
