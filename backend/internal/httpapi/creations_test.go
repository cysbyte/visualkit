package httpapi

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
)

type creationsHTTPRepository struct {
	creations map[uuid.UUID]models.Creation
}

func (repository *creationsHTTPRepository) List(
	_ context.Context,
	userID uuid.UUID,
) ([]models.Creation, error) {
	result := make([]models.Creation, 0)
	for _, creation := range repository.creations {
		if creation.UserID == userID {
			result = append(result, creation)
		}
	}
	return result, nil
}

func (repository *creationsHTTPRepository) ListPage(
	ctx context.Context,
	userID uuid.UUID,
	limit int,
	before *models.CreationCursor,
) ([]models.Creation, bool, error) {
	all, err := repository.List(ctx, userID)
	if err != nil {
		return nil, false, err
	}
	for i := 0; i < len(all); i++ {
		for j := i + 1; j < len(all); j++ {
			if all[j].CreatedAt.After(all[i].CreatedAt) {
				all[i], all[j] = all[j], all[i]
			}
		}
	}
	start := 0
	if before != nil {
		start = len(all)
		for i, creation := range all {
			if creation.CreatedAt.Before(before.CreatedAt) {
				start = i
				break
			}
		}
	}
	all = all[start:]
	hasMore := len(all) > limit
	if hasMore {
		all = all[:limit]
	}
	return all, hasMore, nil
}

func (repository *creationsHTTPRepository) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.Creation, error) {
	creation, ok := repository.creations[id]
	if !ok || creation.UserID != userID {
		return models.Creation{}, database.ErrNotFound
	}
	return creation, nil
}

func (repository *creationsHTTPRepository) Create(
	_ context.Context,
	creation models.Creation,
) (models.Creation, error) {
	repository.creations[creation.ID] = creation
	return creation, nil
}

func (repository *creationsHTTPRepository) Update(
	_ context.Context,
	creation models.Creation,
) (models.Creation, error) {
	repository.creations[creation.ID] = creation
	return creation, nil
}

func (repository *creationsHTTPRepository) Delete(
	_ context.Context,
	userID, id uuid.UUID,
) error {
	if _, err := repository.Get(context.Background(), userID, id); err != nil {
		return err
	}
	delete(repository.creations, id)
	return nil
}

type creationsHTTPAssets struct {
	assets map[uuid.UUID]models.ImageAsset
}

func (repository *creationsHTTPAssets) Create(
	_ context.Context,
	asset models.ImageAsset,
) (models.ImageAsset, error) {
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *creationsHTTPAssets) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.ImageAsset, error) {
	asset, ok := repository.assets[id]
	if !ok || asset.UserID != userID {
		return models.ImageAsset{}, database.ErrNotFound
	}
	return asset, nil
}

func (repository *creationsHTTPAssets) Update(
	_ context.Context,
	asset models.ImageAsset,
) (models.ImageAsset, error) {
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *creationsHTTPAssets) SaveVisualDNA(
	context.Context,
	uuid.UUID,
	uuid.UUID,
	models.VisualDNA,
) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (repository *creationsHTTPAssets) Delete(
	_ context.Context,
	userID, id uuid.UUID,
) error {
	asset, err := repository.Get(context.Background(), userID, id)
	if err != nil {
		return err
	}
	delete(repository.assets, id)
	_ = asset
	return nil
}

func newCreationsHTTPServer(
	userID uuid.UUID,
	creations repositories.CreationRepository,
	assets repositories.ImageAssetRepository,
	objectStorage storage.ObjectStorage,
) *Server {
	return NewServer(Dependencies{
		Config: config.Config{
			AuthMode:          "development",
			DevelopmentUserID: userID.String(),
		},
		Services: services.Set{
			Users:     analysisHTTPUsers{},
			Creations: creations,
			Assets:    assets,
			Storage:   objectStorage,
		},
	})
}

func TestCreationsHTTPListUsesCursorPaginationAndCompactItems(t *testing.T) {
	userID := uuid.New()
	now := time.Now().UTC()
	creationRepository := &creationsHTTPRepository{
		creations: make(map[uuid.UUID]models.Creation),
	}
	assets := &creationsHTTPAssets{assets: make(map[uuid.UUID]models.ImageAsset)}
	for index, prompt := range []string{"newest", "middle", "oldest"} {
		creation := httpCreation(userID, now.Add(-time.Duration(index)*time.Minute), prompt, assets)
		creationRepository.creations[creation.ID] = creation
	}
	server := newCreationsHTTPServer(
		userID,
		creationRepository,
		assets,
		storage.NewMockObjectStorage(),
	)

	request := httptest.NewRequest(http.MethodGet, "/v1/creations?limit=2", nil)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", response.Code, response.Body.String())
	}
	var envelope struct {
		Data models.CreationPage `json:"data"`
	}
	if err := json.Unmarshal(response.Body.Bytes(), &envelope); err != nil {
		t.Fatal(err)
	}
	if len(envelope.Data.Items) != 2 || !envelope.Data.HasMore ||
		envelope.Data.NextCursor == "" {
		t.Fatalf("page = %#v", envelope.Data)
	}
	if envelope.Data.Items[0].Prompt != "newest" ||
		envelope.Data.Items[1].Prompt != "middle" {
		t.Fatalf("items = %#v", envelope.Data.Items)
	}
	if envelope.Data.Items[0].ImageURL == "" ||
		envelope.Data.Items[0].ThumbnailURL == "" {
		t.Fatalf("signed URLs missing: %#v", envelope.Data.Items[0])
	}
	if envelope.Data.Items[0].Style == nil {
		t.Fatal("expected compact style summary")
	}
	if strings.Contains(response.Body.String(), `"visual_dna"`) {
		t.Fatalf("list response contains full Visual DNA: %s", response.Body.String())
	}

	nextRequest := httptest.NewRequest(
		http.MethodGet,
		"/v1/creations?limit=2&cursor="+envelope.Data.NextCursor,
		nil,
	)
	nextResponse := httptest.NewRecorder()
	server.Handler().ServeHTTP(nextResponse, nextRequest)
	if nextResponse.Code != http.StatusOK {
		t.Fatalf("next status = %d: %s", nextResponse.Code, nextResponse.Body.String())
	}
	var nextEnvelope struct {
		Data models.CreationPage `json:"data"`
	}
	if err := json.Unmarshal(nextResponse.Body.Bytes(), &nextEnvelope); err != nil {
		t.Fatal(err)
	}
	if len(nextEnvelope.Data.Items) != 1 ||
		nextEnvelope.Data.Items[0].Prompt != "oldest" ||
		nextEnvelope.Data.HasMore {
		t.Fatalf("next page = %#v", nextEnvelope.Data)
	}
}

func TestCreationsHTTPDetailDeleteAndOwnership(t *testing.T) {
	ownerID := uuid.New()
	otherUserID := uuid.New()
	creationRepository := &creationsHTTPRepository{
		creations: make(map[uuid.UUID]models.Creation),
	}
	assets := &creationsHTTPAssets{assets: make(map[uuid.UUID]models.ImageAsset)}
	objectStorage := storage.NewMockObjectStorage()
	creation := httpCreation(ownerID, time.Now().UTC(), "private", assets)
	creationRepository.creations[creation.ID] = creation
	server := newCreationsHTTPServer(ownerID, creationRepository, assets, objectStorage)

	detailRequest := httptest.NewRequest(
		http.MethodGet,
		"/v1/creations/"+creation.ID.String(),
		nil,
	)
	detailResponse := httptest.NewRecorder()
	server.Handler().ServeHTTP(detailResponse, detailRequest)
	if detailResponse.Code != http.StatusOK {
		t.Fatalf("detail status = %d: %s", detailResponse.Code, detailResponse.Body.String())
	}
	if !strings.Contains(detailResponse.Body.String(), `"visual_dna"`) {
		t.Fatalf("detail response missing Visual DNA: %s", detailResponse.Body.String())
	}

	otherServer := newCreationsHTTPServer(
		otherUserID,
		creationRepository,
		assets,
		objectStorage,
	)
	otherRequest := httptest.NewRequest(
		http.MethodGet,
		"/v1/creations/"+creation.ID.String(),
		nil,
	)
	otherResponse := httptest.NewRecorder()
	otherServer.Handler().ServeHTTP(otherResponse, otherRequest)
	if otherResponse.Code != http.StatusNotFound {
		t.Fatalf("other-user status = %d, want %d", otherResponse.Code, http.StatusNotFound)
	}

	deleteRequest := httptest.NewRequest(
		http.MethodDelete,
		"/v1/creations/"+creation.ID.String(),
		nil,
	)
	deleteResponse := httptest.NewRecorder()
	server.Handler().ServeHTTP(deleteResponse, deleteRequest)
	if deleteResponse.Code != http.StatusOK {
		t.Fatalf("delete status = %d: %s", deleteResponse.Code, deleteResponse.Body.String())
	}
	if _, ok := creationRepository.creations[creation.ID]; ok {
		t.Fatal("creation was not deleted")
	}
}

func TestCreationsHTTPRejectsInvalidPaginationInput(t *testing.T) {
	userID := uuid.New()
	server := newCreationsHTTPServer(
		userID,
		&creationsHTTPRepository{creations: make(map[uuid.UUID]models.Creation)},
		&creationsHTTPAssets{assets: make(map[uuid.UUID]models.ImageAsset)},
		storage.NewMockObjectStorage(),
	)
	request := httptest.NewRequest(http.MethodGet, "/v1/creations?limit=not-a-number", nil)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want %d: %s", response.Code, http.StatusBadRequest, response.Body.String())
	}
}

func httpCreation(
	userID uuid.UUID,
	createdAt time.Time,
	prompt string,
	assets *creationsHTTPAssets,
) models.Creation {
	creationID := uuid.New()
	imageID := uuid.New()
	thumbnailID := uuid.New()
	assets.assets[imageID] = models.ImageAsset{
		ID:        imageID,
		UserID:    userID,
		ObjectKey: "users/" + userID.String() + "/creations/" + creationID.String() + "/generated",
		Status:    models.ImageAssetStatusReady,
	}
	assets.assets[thumbnailID] = models.ImageAsset{
		ID:        thumbnailID,
		UserID:    userID,
		ObjectKey: "users/" + userID.String() + "/creations/" + creationID.String() + "/thumbnail",
		Status:    models.ImageAssetStatusReady,
	}
	return models.Creation{
		ID:               creationID,
		UserID:           userID,
		ImageAssetID:     &imageID,
		GeneratedAssetID: &imageID,
		ThumbnailAssetID: &thumbnailID,
		Prompt:           prompt,
		OriginalPrompt:   prompt,
		Template:         models.Template{ID: uuid.New(), Name: "Cinematic", Category: "cinematic"},
		VisualDNA:        visualDNAForCreation(),
		Status:           "completed",
		CreatedAt:        createdAt,
		UpdatedAt:        createdAt,
	}
}

func visualDNAForCreation() *models.VisualDNA {
	visualDNA := models.MockVisualDNA()
	return &visualDNA
}

var _ repositories.CreationRepository = (*creationsHTTPRepository)(nil)
var _ repositories.PaginatedCreationRepository = (*creationsHTTPRepository)(nil)
var _ repositories.CreationDeleter = (*creationsHTTPRepository)(nil)
var _ repositories.ImageAssetRepository = (*creationsHTTPAssets)(nil)
var _ repositories.ImageAssetDeleter = (*creationsHTTPAssets)(nil)
