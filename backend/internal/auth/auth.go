package auth

import (
	"context"
	"errors"
	"net/http"
	"strings"

	"github.com/google/uuid"
)

var (
	ErrMissingCredentials  = errors.New("authentication credentials are missing")
	ErrInvalidCredentials  = errors.New("authentication credentials are invalid")
	ErrProviderUnavailable = errors.New("authentication provider is unavailable")
)

type AuthenticatedUser struct {
	ID       uuid.UUID         `json:"id"`
	Subject  string            `json:"subject,omitempty"`
	Provider string            `json:"provider,omitempty"`
	Claims   map[string]string `json:"claims,omitempty"`
}

func (user AuthenticatedUser) Validate() error {
	if user.ID == uuid.Nil {
		return ErrInvalidCredentials
	}
	return nil
}

type AuthProvider interface {
	Authenticate(ctx context.Context, request *http.Request) (AuthenticatedUser, error)
}

type DevelopmentAuthProvider struct {
	DefaultUserID uuid.UUID
}

func (provider DevelopmentAuthProvider) Authenticate(
	_ context.Context,
	request *http.Request,
) (AuthenticatedUser, error) {
	rawUserID := strings.TrimSpace(request.Header.Get("X-User-ID"))
	if rawUserID != "" {
		userID, err := uuid.Parse(rawUserID)
		if err != nil {
			return AuthenticatedUser{}, ErrInvalidCredentials
		}
		return AuthenticatedUser{
			ID:       userID,
			Subject:  userID.String(),
			Provider: "development",
		}, nil
	}
	if provider.DefaultUserID == uuid.Nil {
		return AuthenticatedUser{}, ErrMissingCredentials
	}
	return AuthenticatedUser{
		ID:       provider.DefaultUserID,
		Subject:  provider.DefaultUserID.String(),
		Provider: "development",
	}, nil
}

type BearerTokenVerifier interface {
	VerifyToken(ctx context.Context, token string) (AuthenticatedUser, error)
}

type BearerAuthProvider struct {
	Verifier BearerTokenVerifier
}

func (provider BearerAuthProvider) Authenticate(
	ctx context.Context,
	request *http.Request,
) (AuthenticatedUser, error) {
	header := strings.TrimSpace(request.Header.Get("Authorization"))
	if header == "" {
		return AuthenticatedUser{}, ErrMissingCredentials
	}
	scheme, token, ok := strings.Cut(header, " ")
	if !ok || !strings.EqualFold(strings.TrimSpace(scheme), "bearer") ||
		strings.TrimSpace(token) == "" {
		return AuthenticatedUser{}, ErrInvalidCredentials
	}
	if provider.Verifier == nil {
		return AuthenticatedUser{}, ErrProviderUnavailable
	}
	user, err := provider.Verifier.VerifyToken(ctx, strings.TrimSpace(token))
	if err != nil {
		return AuthenticatedUser{}, err
	}
	if err := user.Validate(); err != nil {
		return AuthenticatedUser{}, err
	}
	return user, nil
}

type UnavailableAuthProvider struct{}

func (UnavailableAuthProvider) Authenticate(context.Context, *http.Request) (AuthenticatedUser, error) {
	return AuthenticatedUser{}, ErrProviderUnavailable
}

type contextKey struct{}

func WithAuthenticatedUser(ctx context.Context, user AuthenticatedUser) context.Context {
	return context.WithValue(ctx, contextKey{}, user)
}

func AuthenticatedUserFromContext(ctx context.Context) (AuthenticatedUser, bool) {
	user, ok := ctx.Value(contextKey{}).(AuthenticatedUser)
	if !ok || user.ID == uuid.Nil {
		return AuthenticatedUser{}, false
	}
	return user, true
}

func UserIDFromContext(ctx context.Context) (uuid.UUID, bool) {
	user, ok := AuthenticatedUserFromContext(ctx)
	if !ok {
		return uuid.Nil, false
	}
	return user.ID, true
}

func ProviderForMode(mode string, defaultUserID uuid.UUID) AuthProvider {
	switch strings.ToLower(strings.TrimSpace(mode)) {
	case "", "development":
		return DevelopmentAuthProvider{DefaultUserID: defaultUserID}
	case "bearer":
		return BearerAuthProvider{}
	default:
		return UnavailableAuthProvider{}
	}
}
