package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/storage"
)

type creationTestRepository struct {
	creations map[uuid.UUID]models.Creation
}

func newCreationTestRepository() *creationTestRepository {
	return &creationTestRepository{creations: make(map[uuid.UUID]models.Creation)}
}

func (repository *creationTestRepository) List(
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

func (repository *creationTestRepository) ListPage(
	_ context.Context,
	userID uuid.UUID,
	limit int,
	before *models.CreationCursor,
) ([]models.Creation, bool, error) {
	all, err := repository.List(context.Background(), userID)
	if err != nil {
		return nil, false, err
	}
	for i := 0; i < len(all); i++ {
		for j := i + 1; j < len(all); j++ {
			if all[j].CreatedAt.After(all[i].CreatedAt) ||
				(all[j].CreatedAt.Equal(all[i].CreatedAt) &&
					string(all[j].ID[:]) > string(all[i].ID[:])) {
				all[i], all[j] = all[j], all[i]
			}
		}
	}
	start := 0
	if before != nil {
		start = len(all)
		for i, creation := range all {
			if creation.CreatedAt.Before(before.CreatedAt) ||
				(creation.CreatedAt.Equal(before.CreatedAt) &&
					string(creation.ID[:]) < string(before.ID[:])) {
				start = i
				break
			}
		}
	}
	if start > len(all) {
		start = len(all)
	}
	all = all[start:]
	hasMore := len(all) > limit
	if hasMore {
		all = all[:limit]
	}
	return all, hasMore, nil
}

func (repository *creationTestRepository) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.Creation, error) {
	creation, ok := repository.creations[id]
	if !ok || creation.UserID != userID {
		return models.Creation{}, database.ErrNotFound
	}
	return creation, nil
}

func (repository *creationTestRepository) Create(
	_ context.Context,
	creation models.Creation,
) (models.Creation, error) {
	repository.creations[creation.ID] = creation
	return creation, nil
}

func (repository *creationTestRepository) Update(
	_ context.Context,
	creation models.Creation,
) (models.Creation, error) {
	repository.creations[creation.ID] = creation
	return creation, nil
}

func (repository *creationTestRepository) Delete(
	_ context.Context,
	userID, id uuid.UUID,
) error {
	if _, err := repository.Get(context.Background(), userID, id); err != nil {
		return err
	}
	delete(repository.creations, id)
	return nil
}

type creationTestAssets struct {
	assets  map[uuid.UUID]models.ImageAsset
	deleted []uuid.UUID
}

func newCreationTestAssets() *creationTestAssets {
	return &creationTestAssets{assets: make(map[uuid.UUID]models.ImageAsset)}
}

func (repository *creationTestAssets) Create(
	_ context.Context,
	asset models.ImageAsset,
) (models.ImageAsset, error) {
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *creationTestAssets) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.ImageAsset, error) {
	asset, ok := repository.assets[id]
	if !ok || asset.UserID != userID {
		return models.ImageAsset{}, database.ErrNotFound
	}
	return asset, nil
}

func (repository *creationTestAssets) Update(
	_ context.Context,
	asset models.ImageAsset,
) (models.ImageAsset, error) {
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *creationTestAssets) SaveVisualDNA(
	_ context.Context,
	_, _ uuid.UUID,
	_ models.VisualDNA,
) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (repository *creationTestAssets) Delete(
	_ context.Context,
	userID, id uuid.UUID,
) error {
	asset, err := repository.Get(context.Background(), userID, id)
	if err != nil {
		return err
	}
	delete(repository.assets, id)
	repository.deleted = append(repository.deleted, asset.ID)
	return nil
}

func newCreationService(
	creations *creationTestRepository,
	assets *creationTestAssets,
	objectStorage *storage.MockObjectStorage,
) CreationService {
	return CreationService{
		Creations: creations,
		Assets:    assets,
		Storage:   objectStorage,
	}
}

func addCreation(
	repository *creationTestRepository,
	assets *creationTestAssets,
	userID uuid.UUID,
	createdAt time.Time,
	prompt string,
) models.Creation {
	creationID := uuid.New()
	imageID := uuid.New()
	thumbnailID := uuid.New()
	imageKey := "users/" + userID.String() + "/creations/" +
		creationID.String() + "/generated"
	thumbnailKey := "users/" + userID.String() + "/creations/" +
		creationID.String() + "/thumbnail"
	repository.creations[creationID] = models.Creation{
		ID:               creationID,
		UserID:           userID,
		ImageAssetID:     &imageID,
		GeneratedAssetID: &imageID,
		ThumbnailAssetID: &thumbnailID,
		Prompt:           prompt,
		OriginalPrompt:   prompt,
		Template: models.Template{
			ID:       uuid.New(),
			Name:     "Cinematic",
			Category: "cinematic",
		},
		VisualDNA: &models.VisualDNA{
			SchemaVersion: models.VisualDNASchemaVersion,
			Style: models.VisualDNACategory{
				Attributes: []string{"cinematic"},
			},
		},
		Status:    "completed",
		CreatedAt: createdAt,
		UpdatedAt: createdAt,
	}
	assets.assets[imageID] = models.ImageAsset{
		ID:        imageID,
		UserID:    userID,
		ObjectKey: imageKey,
		Status:    models.ImageAssetStatusReady,
		MimeType:  "image/jpeg",
	}
	assets.assets[thumbnailID] = models.ImageAsset{
		ID:        thumbnailID,
		UserID:    userID,
		ObjectKey: thumbnailKey,
		Status:    models.ImageAssetStatusReady,
		MimeType:  "image/jpeg",
	}
	return repository.creations[creationID]
}

func TestCreationServiceListPagePaginatesInStableDescendingOrder(t *testing.T) {
	creations := newCreationTestRepository()
	assets := newCreationTestAssets()
	service := newCreationService(creations, assets, storage.NewMockObjectStorage())
	userID := uuid.New()
	base := time.Date(2026, 9, 24, 12, 0, 0, 0, time.UTC)
	first := addCreation(creations, assets, userID, base.Add(-time.Minute), "older")
	second := addCreation(creations, assets, userID, base.Add(time.Minute), "newest")
	third := addCreation(creations, assets, userID, base, "middle")

	page, err := service.ListPage(context.Background(), userID, 2, "")
	if err != nil {
		t.Fatal(err)
	}
	if len(page.Items) != 2 || !page.HasMore || page.NextCursor == "" {
		t.Fatalf("page = %#v, want two items and next cursor", page)
	}
	if page.Items[0].ID != second.ID || page.Items[1].ID != third.ID {
		t.Fatalf("items = %#v, want newest then middle", page.Items)
	}
	if page.Items[0].Style == nil || page.Items[0].Style.Attributes["style"][0] != "cinematic" {
		t.Fatalf("style summary = %#v", page.Items[0].Style)
	}

	next, err := service.ListPage(context.Background(), userID, 2, page.NextCursor)
	if err != nil {
		t.Fatal(err)
	}
	if len(next.Items) != 1 || next.HasMore || next.Items[0].ID != first.ID {
		t.Fatalf("next page = %#v, want oldest item only", next)
	}
}

func TestCreationServiceListPageReturnsSignedURLsWithoutVisualDNAPayload(t *testing.T) {
	creations := newCreationTestRepository()
	assets := newCreationTestAssets()
	objectStorage := storage.NewMockObjectStorage()
	service := newCreationService(creations, assets, objectStorage)
	userID := uuid.New()
	creation := addCreation(creations, assets, userID, time.Now().UTC(), "A city street")

	page, err := service.ListPage(context.Background(), userID, 30, "")
	if err != nil {
		t.Fatal(err)
	}
	if len(page.Items) != 1 {
		t.Fatalf("items = %#v", page.Items)
	}
	item := page.Items[0]
	if item.ImageURL == "" || item.ThumbnailURL == "" {
		t.Fatalf("signed URLs missing: %#v", item)
	}
	if item.Prompt != "A city street" || item.Template.Name != "Cinematic" {
		t.Fatalf("list item = %#v", item)
	}
	if item.ID != creation.ID {
		t.Fatalf("id = %s, want %s", item.ID, creation.ID)
	}
}

func TestCreationServiceDetailAndOwnership(t *testing.T) {
	creations := newCreationTestRepository()
	assets := newCreationTestAssets()
	service := newCreationService(creations, assets, storage.NewMockObjectStorage())
	ownerID := uuid.New()
	otherUserID := uuid.New()
	creation := addCreation(creations, assets, ownerID, time.Now().UTC(), "Private prompt")

	detail, err := service.Detail(context.Background(), ownerID, creation.ID)
	if err != nil {
		t.Fatal(err)
	}
	if detail.VisualDNA == nil || detail.ImageURL == "" {
		t.Fatalf("detail = %#v, want metadata and signed URL", detail)
	}
	if _, err := service.Detail(context.Background(), otherUserID, creation.ID); !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("cross-user detail error = %v, want not found", err)
	}
}

func TestCreationServiceDeleteRemovesPrivateObjectsAndMetadata(t *testing.T) {
	creations := newCreationTestRepository()
	assets := newCreationTestAssets()
	objectStorage := storage.NewMockObjectStorage()
	service := newCreationService(creations, assets, objectStorage)
	userID := uuid.New()
	otherUserID := uuid.New()
	creation := addCreation(creations, assets, userID, time.Now().UTC(), "Delete me")
	imageKey := assets.assets[*creation.ImageAssetID].ObjectKey
	thumbnailKey := assets.assets[*creation.ThumbnailAssetID].ObjectKey
	if err := objectStorage.PutObject(context.Background(), storage.PutObjectInput{
		ObjectKey: imageKey, ContentType: "image/jpeg", Data: []byte("image"),
	}); err != nil {
		t.Fatal(err)
	}
	if err := objectStorage.PutObject(context.Background(), storage.PutObjectInput{
		ObjectKey: thumbnailKey, ContentType: "image/jpeg", Data: []byte("thumbnail"),
	}); err != nil {
		t.Fatal(err)
	}

	if err := service.Delete(context.Background(), otherUserID, creation.ID); !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("cross-user delete error = %v, want not found", err)
	}
	if _, err := creations.Get(context.Background(), userID, creation.ID); err != nil {
		t.Fatalf("cross-user delete removed creation: %v", err)
	}

	if err := service.Delete(context.Background(), userID, creation.ID); err != nil {
		t.Fatal(err)
	}
	if _, err := creations.Get(context.Background(), userID, creation.ID); !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("creation still exists: %v", err)
	}
	if _, err := objectStorage.HeadObject(context.Background(), imageKey); !errors.Is(err, storage.ErrObjectNotFound) {
		t.Fatalf("image object still exists: %v", err)
	}
	if _, err := objectStorage.HeadObject(context.Background(), thumbnailKey); !errors.Is(err, storage.ErrObjectNotFound) {
		t.Fatalf("thumbnail object still exists: %v", err)
	}
	if len(assets.deleted) != 2 {
		t.Fatalf("deleted assets = %#v, want two assets", assets.deleted)
	}
}

func TestCreationServiceRejectsInvalidCursorAndLimit(t *testing.T) {
	service := newCreationService(
		newCreationTestRepository(),
		newCreationTestAssets(),
		storage.NewMockObjectStorage(),
	)
	if _, err := service.ListPage(context.Background(), uuid.New(), 101, ""); err == nil {
		t.Fatal("expected invalid limit error")
	}
	if _, err := service.ListPage(context.Background(), uuid.New(), 30, "invalid"); err == nil {
		t.Fatal("expected invalid cursor error")
	}
}

var _ repositories.CreationRepository = (*creationTestRepository)(nil)
var _ repositories.PaginatedCreationRepository = (*creationTestRepository)(nil)
var _ repositories.CreationDeleter = (*creationTestRepository)(nil)
var _ repositories.ImageAssetRepository = (*creationTestAssets)(nil)
var _ repositories.ImageAssetDeleter = (*creationTestAssets)(nil)
