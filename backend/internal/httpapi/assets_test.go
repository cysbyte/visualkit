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
	"github.com/visualkit/backend/internal/database"
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

type httpAssetContentRepository struct {
	asset models.ImageAsset
}

func (repository httpAssetContentRepository) Create(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (repository httpAssetContentRepository) Get(_ context.Context, userID, id uuid.UUID) (models.ImageAsset, error) {
	if repository.asset.ID == id && repository.asset.UserID == userID {
		return repository.asset, nil
	}
	return models.ImageAsset{}, database.ErrNotFound
}

func (repository httpAssetContentRepository) Update(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (repository httpAssetContentRepository) SaveVisualDNA(context.Context, uuid.UUID, uuid.UUID, models.VisualDNA) (models.ImageAsset, error) {
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

func TestAssetRouteStreamsStableContentURL(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	objectKey := "users/" + userID.String() + "/creations/test/generated"
	objectStorage := storage.NewMockObjectStorage()
	if err := objectStorage.PutObject(context.Background(), storage.PutObjectInput{
		ObjectKey:   objectKey,
		ContentType: "image/png",
		Data:        []byte("png-bytes"),
	}); err != nil {
		t.Fatal(err)
	}
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode:          "development",
			DevelopmentUserID: userID.String(),
		},
		Logger: slog.Default(),
		Services: services.Set{
			Users: httpAssetUsers{},
			Assets: httpAssetContentRepository{asset: models.ImageAsset{
				ID:        assetID,
				UserID:    userID,
				ObjectKey: objectKey,
				MimeType:  "image/png",
				Status:    models.ImageAssetStatusReady,
			}},
			Storage: objectStorage,
		},
	})

	request := httptest.NewRequest(http.MethodGet, "/v1/assets/"+assetID.String()+"/content", nil)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)

	if response.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", response.Code, response.Body.String())
	}
	if response.Header().Get("Content-Type") != "image/png" {
		t.Fatalf("content type = %q, want image/png", response.Header().Get("Content-Type"))
	}
	if response.Body.String() != "png-bytes" {
		t.Fatalf("body = %q, want image bytes", response.Body.String())
	}
}

var _ repositories.ImageAssetRepository = httpAssetRepository{}
var _ repositories.ImageAssetRepository = httpAssetContentRepository{}
