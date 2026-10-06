package httpapi

import (
	"context"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
)

type httpAssetUsers struct{}

func (httpAssetUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	return models.User{ID: id}, nil
}

type httpAssetRepository struct{}

func (httpAssetRepository) Create(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (httpAssetRepository) Get(context.Context, uuid.UUID, uuid.UUID) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (httpAssetRepository) Update(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (httpAssetRepository) SaveVisualDNA(context.Context, uuid.UUID, uuid.UUID, models.VisualDNA) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func TestAssetRouteRejectsInvalidAssetID(t *testing.T) {
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode: "development",
		},
		Logger: slog.Default(),
		Services: services.Set{
			Users:   httpAssetUsers{},
			Assets:  httpAssetRepository{},
			Storage: storage.NewMockObjectStorage(),
		},
	})

	request := httptest.NewRequest(http.MethodGet, "/v1/assets/not-a-uuid/url", nil)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)

	if response.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want %d", response.Code, http.StatusBadRequest)
	}
	if !strings.Contains(response.Body.String(), `"INVALID_REQUEST"`) {
		t.Fatalf("response = %s, want invalid request error", response.Body.String())
	}
}

var _ repositories.ImageAssetRepository = httpAssetRepository{}
