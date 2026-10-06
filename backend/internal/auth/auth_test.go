package auth

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/google/uuid"
)

func TestDevelopmentAuthProviderUsesHeaderOnlyAsDevelopmentCredential(t *testing.T) {
	userID := uuid.New()
	request := httptest.NewRequest(http.MethodGet, "/", nil)
	request.Header.Set("X-User-ID", userID.String())

	user, err := (DevelopmentAuthProvider{}).Authenticate(context.Background(), request)
	if err != nil {
		t.Fatal(err)
	}
	if user.ID != userID || user.Provider != "development" {
		t.Fatalf("user = %#v, want development identity", user)
	}
}

func TestDevelopmentAuthProviderUsesConfiguredDefault(t *testing.T) {
	userID := uuid.New()
	request := httptest.NewRequest(http.MethodGet, "/", nil)

	user, err := (DevelopmentAuthProvider{DefaultUserID: userID}).Authenticate(context.Background(), request)
	if err != nil {
		t.Fatal(err)
	}
	if user.ID != userID {
		t.Fatalf("user ID = %s, want %s", user.ID, userID)
	}
}

func TestBearerAuthProviderRejectsMissingAndInvalidCredentials(t *testing.T) {
	provider := BearerAuthProvider{}

	for _, authorization := range []string{"", "Basic token", "Bearer"} {
		request := httptest.NewRequest(http.MethodGet, "/", nil)
		request.Header.Set("Authorization", authorization)
		_, err := provider.Authenticate(context.Background(), request)
		if authorization == "" {
			if err != ErrMissingCredentials {
				t.Fatalf("authorization %q error = %v, want missing credentials", authorization, err)
			}
			continue
		}
		if err != ErrInvalidCredentials {
			t.Fatalf("authorization %q error = %v, want invalid credentials", authorization, err)
		}
	}
}

func TestBearerAuthProviderRequiresVerifier(t *testing.T) {
	request := httptest.NewRequest(http.MethodGet, "/", nil)
	request.Header.Set("Authorization", "Bearer token")
	_, err := (BearerAuthProvider{}).Authenticate(context.Background(), request)
	if err != ErrProviderUnavailable {
		t.Fatalf("error = %v, want provider unavailable", err)
	}
}
