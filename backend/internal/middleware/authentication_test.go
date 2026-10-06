package middleware

import (
	"context"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/auth"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/repositories"
)

type middlewareAuthProvider struct {
	user auth.AuthenticatedUser
	err  error
}

func (provider middlewareAuthProvider) Authenticate(context.Context, *http.Request) (auth.AuthenticatedUser, error) {
	if provider.err != nil {
		return auth.AuthenticatedUser{}, provider.err
	}
	return provider.user, nil
}

type middlewareUsers struct {
	ensured []uuid.UUID
	err     error
}

func (users *middlewareUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	if users.err != nil {
		return models.User{}, users.err
	}
	users.ensured = append(users.ensured, id)
	return models.User{ID: id}, nil
}

func TestAuthenticationMiddlewareRejectsMissingCredentials(t *testing.T) {
	nextCalled := false
	handler := AuthenticationMiddleware{
		Provider: auth.DevelopmentAuthProvider{},
	}.Handler(http.HandlerFunc(func(http.ResponseWriter, *http.Request) {
		nextCalled = true
	}))

	response := httptest.NewRecorder()
	handler.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/v1/styles", nil))
	if response.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusUnauthorized)
	}
	if nextCalled {
		t.Fatal("next handler should not be called")
	}
}

func TestAuthenticationMiddlewareAuthenticatesAndEnsuresUser(t *testing.T) {
	userID := uuid.New()
	users := &middlewareUsers{}
	var contextUser auth.AuthenticatedUser
	handler := AuthenticationMiddleware{
		Provider: middlewareAuthProvider{user: auth.AuthenticatedUser{
			ID:       userID,
			Subject:  "subject",
			Provider: "test",
		}},
		Users: users,
	}.Handler(http.HandlerFunc(func(_ http.ResponseWriter, request *http.Request) {
		contextUser, _ = auth.AuthenticatedUserFromContext(request.Context())
	}))

	response := httptest.NewRecorder()
	handler.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/v1/styles", nil))
	if response.Code != http.StatusOK {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusOK)
	}
	if contextUser.ID != userID || contextUser.Provider != "test" {
		t.Fatalf("context user = %#v, want authenticated user", contextUser)
	}
	if len(users.ensured) != 1 || users.ensured[0] != userID {
		t.Fatalf("ensured users = %#v, want %s", users.ensured, userID)
	}
}

func TestAuthenticationMiddlewareRejectsInvalidCredentials(t *testing.T) {
	handler := AuthenticationMiddleware{
		Provider: middlewareAuthProvider{err: auth.ErrInvalidCredentials},
	}.Handler(http.HandlerFunc(func(http.ResponseWriter, *http.Request) {}))

	response := httptest.NewRecorder()
	handler.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/v1/styles", nil))
	if response.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusUnauthorized)
	}
}

func TestAuthenticationMiddlewareDoesNotRequireUserForHealth(t *testing.T) {
	nextCalled := false
	handler := AuthenticationMiddleware{
		Provider: auth.UnavailableAuthProvider{},
	}.Handler(http.HandlerFunc(func(http.ResponseWriter, *http.Request) {
		nextCalled = true
	}))

	response := httptest.NewRecorder()
	handler.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/health", nil))
	if !nextCalled || response.Code != http.StatusOK {
		t.Fatalf("health response status = %d, next called = %v", response.Code, nextCalled)
	}
}

func TestAuthenticationMiddlewareMapsUserProvisioningFailure(t *testing.T) {
	handler := AuthenticationMiddleware{
		Provider: middlewareAuthProvider{user: auth.AuthenticatedUser{ID: uuid.New()}},
		Users:    &middlewareUsers{err: errors.New("database unavailable")},
	}.Handler(http.HandlerFunc(func(http.ResponseWriter, *http.Request) {}))

	response := httptest.NewRecorder()
	handler.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/v1/styles", nil))
	if response.Code != http.StatusServiceUnavailable {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusServiceUnavailable)
	}
}

var _ repositories.UserRepository = (*middlewareUsers)(nil)
