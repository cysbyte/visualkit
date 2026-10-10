package worker

import (
	"context"
	"errors"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/providers"
	"github.com/visualkit/backend/internal/storage"
)

type capturingGenerator struct {
	input providers.GenerationInput
}

func (generator *capturingGenerator) GenerateImage(_ context.Context, input providers.GenerationInput) (providers.GeneratedImage, error) {
	generator.input = input
	return providers.GeneratedImage{
		MimeType:      "image/jpeg",
		Data:          []byte("image"),
		ThumbnailData: []byte("thumbnail"),
		PixelWidth:    512,
		PixelHeight:   512,
	}, nil
}

func TestImageGenerationProcessorSendsResolvedStructuredIntent(t *testing.T) {
	userID := uuid.New()
	jobID := uuid.New()
	templateID := uuid.New()
	referenceAssetID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	generator := &capturingGenerator{}
	visualDNA := models.MockVisualDNA()
	processor := ImageGenerationProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			UserID:    userID,
			ObjectKey: "reference-key",
			MimeType:  "image/jpeg",
			Status:    models.ImageAssetStatusReady,
		}},
		Creations: &fakeCreations{},
		Templates: fakeTemplates{template: models.Template{
			ID:               templateID,
			Name:             "Editorial",
			Category:         "editorial",
			PromptDirectives: []string{"art-directed composition"},
			DefaultSettings: models.GenerationSettings{
				AspectRatio: "4:5",
				Quality:     "high",
			},
		}},
		Jobs:      jobService,
		Storage:   testReferenceStorage("reference-key"),
		Generator: generator,
	}
	job := models.Job{
		ID:     jobID,
		UserID: userID,
		Type:   models.JobTypeImageGeneration,
		Input: map[string]any{
			"prompt":             "A woman riding a bicycle in Paris",
			"template_id":        templateID.String(),
			"reference_asset_id": referenceAssetID.String(),
			"visual_dna":         visualDNA,
			"preservation": map[string]any{
				"style":  true,
				"color":  true,
				"camera": false,
			},
			"generation_settings": map[string]any{},
		},
	}
	if err := processor.Process(context.Background(), &job); err != nil {
		t.Fatal(err)
	}
	if generator.input.Request.OriginalPrompt != "A woman riding a bicycle in Paris" {
		t.Fatalf("original prompt = %q", generator.input.Request.OriginalPrompt)
	}
	if generator.input.Request.GenerationSettings.AspectRatio != "4:5" {
		t.Fatalf("aspect ratio = %q, want template default", generator.input.Request.GenerationSettings.AspectRatio)
	}
	if generator.input.Request.VisualDNA == nil {
		t.Fatal("expected filtered visual DNA")
	}
	if generator.input.Request.VisualDNA.Camera.Attributes != nil {
		t.Fatalf("camera = %#v, want excluded", generator.input.Request.VisualDNA.Camera.Attributes)
	}
	if generator.input.Request.VisualDNA.Style.Attributes == nil {
		t.Fatal("expected preserved style")
	}
	if generator.input.ProviderPrompt == "" {
		t.Fatal("expected resolved provider prompt")
	}
	if generator.input.ReferenceImage == nil ||
		string(generator.input.ReferenceImage.Data) != "reference-image" {
		t.Fatalf("reference image = %#v, want loaded bytes", generator.input.ReferenceImage)
	}
	if generator.input.Intent.OriginalPrompt != generator.input.Request.OriginalPrompt {
		t.Fatal("intent and request prompts differ")
	}
	creationStore := processor.Creations.(*fakeCreations)
	if creationStore.creation.OriginalPrompt != "A woman riding a bicycle in Paris" {
		t.Fatalf("creation original prompt = %q", creationStore.creation.OriginalPrompt)
	}
	if creationStore.creation.ResolvedPrompt == "" {
		t.Fatal("creation resolved prompt is empty")
	}
	if creationStore.creation.GeneratedAssetID == nil {
		t.Fatal("creation generated asset is missing")
	}
	objectKey := "users/" + userID.String() + "/creations/" + creationStore.creation.ID.String() + "/generated"
	object, err := processor.Storage.GetObject(context.Background(), objectKey)
	if err != nil {
		t.Fatal(err)
	}
	if string(object.Data) != "image" {
		t.Fatalf("stored image = %q", object.Data)
	}
}

func TestImageGenerationProcessorLoadsPersonImage(t *testing.T) {
	userID, templateID, productID, personID := uuid.New(), uuid.New(), uuid.New(), uuid.New()
	jobID := uuid.New()
	generator := &capturingGenerator{}
	store := storage.NewMockObjectStorage()
	for _, item := range []struct{ key, data string }{{"product-key", "t-shirt"}, {"person-key", "person"}} {
		if err := store.PutObject(context.Background(), storage.PutObjectInput{ObjectKey: item.key, ContentType: "image/png", Data: []byte(item.data)}); err != nil {
			t.Fatal(err)
		}
	}
	processor := ImageGenerationProcessor{
		Assets:    &twoReferenceAssets{productID: productID, productKey: "product-key", personID: personID, personKey: "person-key"},
		Creations: &fakeCreations{},
		Templates: fakeTemplates{template: models.Template{ID: templateID, Name: "Product set", DefaultSettings: models.GenerationSettings{AspectRatio: "1:1"}}},
		Jobs:      newFakeJobService(models.Job{ID: jobID, UserID: userID}), Storage: store, Generator: generator,
	}
	job := &models.Job{ID: jobID, UserID: userID, Type: models.JobTypeImageGeneration, Input: map[string]any{
		"prompt": "A woman wearing the t-shirt", "template_id": templateID.String(), "reference_asset_id": productID.String(), "personAssetId": personID.String(),
	}}
	if err := processor.Process(context.Background(), job); err != nil {
		t.Fatal(err)
	}
	if generator.input.ReferenceImage == nil || string(generator.input.ReferenceImage.Data) != "t-shirt" ||
		generator.input.PersonImage == nil || string(generator.input.PersonImage.Data) != "person" {
		t.Fatalf("references: product=%#v person=%#v", generator.input.ReferenceImage, generator.input.PersonImage)
	}
}

type twoReferenceAssets struct {
	fakeAssets
	productID  uuid.UUID
	productKey string
	personID   uuid.UUID
	personKey  string
}

func (assets *twoReferenceAssets) Get(_ context.Context, userID, id uuid.UUID) (models.ImageAsset, error) {
	key := ""
	switch id {
	case assets.productID:
		key = assets.productKey
	case assets.personID:
		key = assets.personKey
	default:
		return models.ImageAsset{}, errors.New("unknown image asset")
	}
	return models.ImageAsset{ID: id, UserID: userID, ObjectKey: key, MimeType: "image/png", Status: models.ImageAssetStatusReady}, nil
}

type failingGenerator struct {
	err error
}

func (generator failingGenerator) GenerateImage(context.Context, providers.GenerationInput) (providers.GeneratedImage, error) {
	return providers.GeneratedImage{}, generator.err
}

func TestImageGenerationProcessorMarksCreationFailedOnProviderError(t *testing.T) {
	userID := uuid.New()
	jobID := uuid.New()
	templateID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	creations := &fakeCreations{}
	processor := ImageGenerationProcessor{
		Assets:    &fakeAssets{asset: models.ImageAsset{UserID: userID}},
		Creations: creations,
		Templates: fakeTemplates{template: models.Template{
			ID:               templateID,
			Name:             "Cinematic",
			PromptDirectives: []string{"film contrast"},
			DefaultSettings:  models.GenerationSettings{AspectRatio: "16:9"},
		}},
		Jobs:      jobService,
		Storage:   storage.NewMockObjectStorage(),
		Generator: failingGenerator{err: providers.NewProviderError("TIMEOUT", true, errors.New("timeout"))},
	}
	err := processor.Process(context.Background(), &models.Job{
		ID:     jobID,
		UserID: userID,
		Input: map[string]any{
			"prompt":      "A city street",
			"template_id": templateID.String(),
		},
	})
	if err == nil {
		t.Fatal("expected provider error")
	}
	if creations.creation.Status != "failed" {
		t.Fatalf("creation status = %q, want failed", creations.creation.Status)
	}
}
