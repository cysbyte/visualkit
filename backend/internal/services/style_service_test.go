package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/storage"
	"github.com/visualkit/backend/pkg/api"
)

type styleTestUsers struct{}

func (styleTestUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	return models.User{ID: id}, nil
}

type styleTestRepository struct {
	styles map[uuid.UUID]models.SavedStyle
}

func newStyleTestRepository() *styleTestRepository {
	return &styleTestRepository{styles: make(map[uuid.UUID]models.SavedStyle)}
}

func (repository *styleTestRepository) List(
	_ context.Context,
	userID uuid.UUID,
) ([]models.SavedStyle, error) {
	styles := make([]models.SavedStyle, 0)
	for _, style := range repository.styles {
		if style.UserID == userID {
			styles = append(styles, style)
		}
	}
	return styles, nil
}

func (repository *styleTestRepository) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.SavedStyle, error) {
	style, ok := repository.styles[id]
	if !ok || style.UserID != userID {
		return models.SavedStyle{}, database.ErrNotFound
	}
	return style, nil
}

func (repository *styleTestRepository) Create(
	_ context.Context,
	style models.SavedStyle,
) (models.SavedStyle, error) {
	if style.ID == uuid.Nil {
		style.ID = uuid.New()
	}
	if style.CreatedAt.IsZero() {
		style.CreatedAt = time.Now().UTC()
	}
	style.UpdatedAt = style.CreatedAt
	repository.styles[style.ID] = style
	return style, nil
}

func (repository *styleTestRepository) Update(
	_ context.Context,
	style models.SavedStyle,
) (models.SavedStyle, error) {
	if _, ok := repository.styles[style.ID]; !ok {
		return models.SavedStyle{}, database.ErrNotFound
	}
	style.UpdatedAt = time.Now().UTC()
	repository.styles[style.ID] = style
	return style, nil
}

func (repository *styleTestRepository) Delete(
	_ context.Context,
	userID, id uuid.UUID,
) error {
	style, err := repository.Get(context.Background(), userID, id)
	if err != nil {
		return err
	}
	delete(repository.styles, style.ID)
	return nil
}

type styleTestAssets struct {
	assets map[uuid.UUID]models.ImageAsset
}

func newStyleTestAssets() *styleTestAssets {
	return &styleTestAssets{assets: make(map[uuid.UUID]models.ImageAsset)}
}

func (repository *styleTestAssets) Create(
	_ context.Context,
	asset models.ImageAsset,
) (models.ImageAsset, error) {
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *styleTestAssets) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.ImageAsset, error) {
	asset, ok := repository.assets[id]
	if !ok || asset.UserID != userID {
		return models.ImageAsset{}, database.ErrNotFound
	}
	return asset, nil
}

func (repository *styleTestAssets) Update(
	_ context.Context,
	asset models.ImageAsset,
) (models.ImageAsset, error) {
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *styleTestAssets) SaveVisualDNA(
	_ context.Context,
	_, _ uuid.UUID,
	_ models.VisualDNA,
) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func newStyleService(
	styles *styleTestRepository,
	assets *styleTestAssets,
	objectStorage *storage.MockObjectStorage,
) StyleService {
	return StyleService{
		Users:   styleTestUsers{},
		Styles:  styles,
		Assets:  assets,
		Storage: objectStorage,
	}
}

func addStylePreview(
	assets *styleTestAssets,
	userID uuid.UUID,
	status string,
) uuid.UUID {
	id := uuid.New()
	assets.assets[id] = models.ImageAsset{
		ID:     id,
		UserID: userID,
		Status: status,
		ObjectKey: "users/" + userID.String() +
			"/assets/" + id.String() + "/original",
	}
	return id
}

func TestStyleServiceCreatePersistsValidStyleAndNormalizesName(t *testing.T) {
	styles := newStyleTestRepository()
	assets := newStyleTestAssets()
	service := newStyleService(styles, assets, storage.NewMockObjectStorage())
	userID := uuid.New()

	response, err := service.Create(context.Background(), userID, CreateStyleInput{
		Name:      "  Warm Cinematic  ",
		VisualDNA: visualDNAInput(),
	})
	if err != nil {
		t.Fatal(err)
	}
	if response.Name != "Warm Cinematic" {
		t.Fatalf("name = %q, want normalized name", response.Name)
	}
	persisted, ok := styles.styles[response.ID]
	if !ok {
		t.Fatal("expected style to be persisted")
	}
	if persisted.UserID != userID || persisted.VisualDNA.Style.Attributes[0] != "cinematic" {
		t.Fatalf("persisted style = %#v", persisted)
	}
}

func TestStyleServiceCreateRejectsMissingNameAndInvalidVisualDNA(t *testing.T) {
	service := newStyleService(
		newStyleTestRepository(),
		newStyleTestAssets(),
		storage.NewMockObjectStorage(),
	)

	_, err := service.Create(context.Background(), uuid.New(), CreateStyleInput{
		VisualDNA: visualDNAInput(),
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("missing name error = %v, want invalid request", err)
	}

	invalid := visualDNAInput()
	invalid.Style.Confidence = 2
	_, err = service.Create(context.Background(), uuid.New(), CreateStyleInput{
		Name:      "Invalid",
		VisualDNA: invalid,
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("invalid Visual DNA error = %v, want invalid request", err)
	}
}

func TestStyleServiceCreateRejectsUnauthorizedOrUnreadyPreviewAsset(t *testing.T) {
	styles := newStyleTestRepository()
	assets := newStyleTestAssets()
	service := newStyleService(styles, assets, storage.NewMockObjectStorage())
	ownerID := uuid.New()
	otherUserID := uuid.New()
	assetID := addStylePreview(assets, otherUserID, models.ImageAssetStatusReady)

	_, err := service.Create(context.Background(), ownerID, CreateStyleInput{
		Name:           "Unauthorized",
		PreviewAssetID: &assetID,
		VisualDNA:      visualDNAInput(),
	})
	if !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("unauthorized preview error = %v, want not found", err)
	}

	unreadyID := addStylePreview(assets, ownerID, models.ImageAssetStatusUploaded)
	_, err = service.Create(context.Background(), ownerID, CreateStyleInput{
		Name:           "Unready",
		PreviewAssetID: &unreadyID,
		VisualDNA:      visualDNAInput(),
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("unready preview error = %v, want invalid request", err)
	}
}

func TestStyleServiceGetAndListEnforceOwnershipAndSignPreview(t *testing.T) {
	styles := newStyleTestRepository()
	assets := newStyleTestAssets()
	objectStorage := storage.NewMockObjectStorage()
	service := newStyleService(styles, assets, objectStorage)
	ownerID := uuid.New()
	otherUserID := uuid.New()
	previewID := addStylePreview(assets, ownerID, models.ImageAssetStatusReady)
	style, err := service.Create(context.Background(), ownerID, CreateStyleInput{
		Name:           "Warm Cinematic",
		PreviewAssetID: &previewID,
		VisualDNA:      visualDNAInput(),
	})
	if err != nil {
		t.Fatal(err)
	}

	if style.PreviewImageURL == "" {
		t.Fatal("expected signed preview image URL")
	}
	if _, err := service.Get(context.Background(), otherUserID, style.ID); !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("cross-user get error = %v, want not found", err)
	}
	list, err := service.List(context.Background(), ownerID)
	if err != nil {
		t.Fatal(err)
	}
	if len(list) != 1 || list[0].ID != style.ID {
		t.Fatalf("list = %#v, want one owned style", list)
	}
}

func TestStyleServiceUpdateSupportsPartialUpdateAndClearingPreview(t *testing.T) {
	styles := newStyleTestRepository()
	assets := newStyleTestAssets()
	service := newStyleService(styles, assets, storage.NewMockObjectStorage())
	userID := uuid.New()
	previewID := addStylePreview(assets, userID, models.ImageAssetStatusReady)
	created, err := service.Create(context.Background(), userID, CreateStyleInput{
		Name:           "Original",
		PreviewAssetID: &previewID,
		VisualDNA:      visualDNAInput(),
	})
	if err != nil {
		t.Fatal(err)
	}

	renamed, err := service.Update(context.Background(), userID, created.ID, UpdateStyleInput{
		Name: stringPointer("Renamed"),
	})
	if err != nil {
		t.Fatal(err)
	}
	if renamed.Name != "Renamed" || renamed.PreviewAssetID == nil {
		t.Fatalf("partial update = %#v", renamed)
	}

	updatedDNA := visualDNAInput()
	updatedDNA.Style.Attributes = []string{"editorial"}
	updated, err := service.Update(context.Background(), userID, created.ID, UpdateStyleInput{
		VisualDNA: updatedDNA,
	})
	if err != nil {
		t.Fatal(err)
	}
	if updated.VisualDNA.Style.Attributes[0] != "editorial" {
		t.Fatalf("updated Visual DNA = %#v", updated.VisualDNA.Style)
	}

	cleared, err := service.Update(context.Background(), userID, created.ID, UpdateStyleInput{
		PreviewAssetID: uuidPointerPointer(nil),
	})
	if err != nil {
		t.Fatal(err)
	}
	if cleared.PreviewAssetID != nil || cleared.PreviewImageURL != "" {
		t.Fatalf("cleared preview = %#v", cleared)
	}
}

func TestStyleServiceUpdateAndDeleteRejectOtherUser(t *testing.T) {
	styles := newStyleTestRepository()
	service := newStyleService(styles, newStyleTestAssets(), storage.NewMockObjectStorage())
	ownerID := uuid.New()
	otherUserID := uuid.New()
	created, err := service.Create(context.Background(), ownerID, CreateStyleInput{
		Name:      "Owned",
		VisualDNA: visualDNAInput(),
	})
	if err != nil {
		t.Fatal(err)
	}

	_, err = service.Update(context.Background(), otherUserID, created.ID, UpdateStyleInput{
		Name: stringPointer("Hijacked"),
	})
	if !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("cross-user update error = %v, want not found", err)
	}
	if err := service.Delete(context.Background(), otherUserID, created.ID); !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("cross-user delete error = %v, want not found", err)
	}
	if _, err := service.Get(context.Background(), ownerID, created.ID); err != nil {
		t.Fatalf("owned style was changed or deleted: %v", err)
	}
}

func TestStyleServiceToGenerationDraftCopiesOnlyVisualDNA(t *testing.T) {
	styles := newStyleTestRepository()
	service := newStyleService(styles, newStyleTestAssets(), storage.NewMockObjectStorage())
	userID := uuid.New()
	created, err := service.Create(context.Background(), userID, CreateStyleInput{
		Name:      "Warm Cinematic",
		VisualDNA: visualDNAInput(),
	})
	if err != nil {
		t.Fatal(err)
	}

	templateID := uuid.New()
	referenceID := uuid.New()
	draft := models.GenerationDraft{
		Prompt:           "A woman riding a bicycle in Paris",
		TemplateID:       templateID,
		ReferenceAssetID: &referenceID,
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "4:5",
			Quality:     "high",
		},
	}
	result, err := service.ToGenerationDraft(context.Background(), userID, created.ID, draft)
	if err != nil {
		t.Fatal(err)
	}
	if result.Prompt != draft.Prompt || result.TemplateID != templateID ||
		result.ReferenceAssetID == nil || *result.ReferenceAssetID != referenceID ||
		result.GenerationSettings != draft.GenerationSettings {
		t.Fatalf("style reuse changed independent draft state: %#v", result)
	}
	if result.VisualDNA == nil || result.VisualDNA.Style.Attributes[0] != "cinematic" {
		t.Fatalf("draft Visual DNA = %#v", result.VisualDNA)
	}
}

func visualDNAInput() *models.VisualDNA {
	visualDNA := models.MockVisualDNA()
	return &visualDNA
}

func stringPointer(value string) *string {
	return &value
}

func uuidPointerPointer(value *uuid.UUID) **uuid.UUID {
	return &value
}
