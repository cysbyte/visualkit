package httpapi

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/auth"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/services"
)

type httpAuthProvider struct {
	users map[string]auth.AuthenticatedUser
}

func (provider httpAuthProvider) Authenticate(_ context.Context, request *http.Request) (auth.AuthenticatedUser, error) {
	token := request.Header.Get("Authorization")
	user, ok := provider.users[token]
	if !ok {
		return auth.AuthenticatedUser{}, auth.ErrInvalidCredentials
	}
	return user, nil
}

type authHTTPUsers struct {
	ids []uuid.UUID
}

func (users *authHTTPUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	users.ids = append(users.ids, id)
	return models.User{ID: id}, nil
}

func TestProductionRequestRequiresAuthentication(t *testing.T) {
	server := NewServer(Dependencies{
		Config: config.Config{
			Environment: "production",
			AuthMode:    "bearer",
		},
		Services: services.Set{
			Users: &authHTTPUsers{},
		},
		Auth: httpAuthProvider{users: map[string]auth.AuthenticatedUser{}},
	})

	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/v1/styles", nil))
	if response.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusUnauthorized)
	}
}

func TestProductionModeDoesNotTrustDevelopmentUserHeader(t *testing.T) {
	userID := uuid.New()
	server := NewServer(Dependencies{
		Config: config.Config{
			Environment: "production",
			AuthMode:    "bearer",
		},
		Services: services.Set{
			Users: &authHTTPUsers{},
		},
		Auth: httpAuthProvider{users: map[string]auth.AuthenticatedUser{}},
	})

	request := httptest.NewRequest(http.MethodGet, "/v1/styles", nil)
	request.Header.Set("X-User-ID", userID.String())
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusUnauthorized)
	}
}

func TestAuthenticatedRequestUsesProviderIdentityNotClientUserID(t *testing.T) {
	authenticatedID := uuid.New()
	clientSuppliedID := uuid.New()
	users := &authHTTPUsers{}
	server := NewServer(Dependencies{
		Config: config.Config{
			Environment: "production",
			AuthMode:    "bearer",
		},
		Services: services.Set{
			Users: users,
			Styles: &authHTTPStyles{
				styles: map[uuid.UUID]models.SavedStyle{},
			},
		},
		Auth: httpAuthProvider{users: map[string]auth.AuthenticatedUser{
			"Bearer valid": {
				ID:       authenticatedID,
				Subject:  "subject",
				Provider: "test",
			},
		}},
	})

	request := httptest.NewRequest(http.MethodGet, "/v1/styles?user_id="+clientSuppliedID.String(), nil)
	request.Header.Set("Authorization", "Bearer valid")
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusOK {
		t.Fatalf("status = %d, want %d: %s", response.Code, http.StatusOK, response.Body.String())
	}
	if len(users.ids) != 1 || users.ids[0] != authenticatedID {
		t.Fatalf("ensured users = %#v, want authenticated ID %s", users.ids, authenticatedID)
	}
}

type authHTTPStyles struct {
	styles map[uuid.UUID]models.SavedStyle
}

func (styles *authHTTPStyles) List(_ context.Context, userID uuid.UUID) ([]models.SavedStyle, error) {
	result := make([]models.SavedStyle, 0)
	for _, style := range styles.styles {
		if style.UserID == userID {
			result = append(result, style)
		}
	}
	return result, nil
}

func (styles *authHTTPStyles) Get(_ context.Context, userID, id uuid.UUID) (models.SavedStyle, error) {
	style, ok := styles.styles[id]
	if !ok || style.UserID != userID {
		return models.SavedStyle{}, database.ErrNotFound
	}
	return style, nil
}

func (styles *authHTTPStyles) Create(context.Context, models.SavedStyle) (models.SavedStyle, error) {
	return models.SavedStyle{}, nil
}

func (styles *authHTTPStyles) Update(context.Context, models.SavedStyle) (models.SavedStyle, error) {
	return models.SavedStyle{}, nil
}

func (styles *authHTTPStyles) Delete(context.Context, uuid.UUID, uuid.UUID) error {
	return nil
}
