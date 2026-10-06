package worker

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/providers"
	"github.com/visualkit/backend/internal/storage"
)

type observingVision struct {
	input providers.VisionInput
}

func (provider *observingVision) AnalyzeImage(_ context.Context, input providers.VisionInput) (models.VisualDNA, error) {
	provider.input = input
	return models.MockVisualDNA(), nil
}

func TestImageAnalysisProcessorLoadsBytesAndBackendPrompt(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	jobID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	vision := &observingVision{}
	processor := ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			ID:        assetID,
			UserID:    userID,
			ObjectKey: "reference-key",
			MimeType:  "image/jpeg",
			ByteSize:  int64(len("reference-image")),
			Status:    models.ImageAssetStatusReady,
		}},
		Jobs:    jobService,
		Storage: testReferenceStorage("reference-key"),
		Vision:  vision,
	}
	job := models.Job{
		ID:     jobID,
		UserID: userID,
		Input:  map[string]any{"asset_id": assetID.String()},
	}
	if err := processor.Process(context.Background(), &job); err != nil {
		t.Fatal(err)
	}
	if string(vision.input.ImageData) != "reference-image" {
		t.Fatalf("image data = %q, want retrieved reference bytes", vision.input.ImageData)
	}
	if vision.input.Prompt != providers.VisionAnalysisPrompt {
		t.Fatal("provider did not receive backend-owned analysis prompt")
	}
	completed, err := jobService.LoadJob(context.Background(), jobID)
	if err != nil {
		t.Fatal(err)
	}
	if completed.Output["visual_dna"] == nil {
		t.Fatalf("output = %#v, want visual_dna", completed.Output)
	}
}

func TestImageAnalysisProcessorRejectsObjectMetadataMismatch(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	jobID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	objectStorage := storage.NewMockObjectStorage()
	if err := objectStorage.PutObject(context.Background(), storage.PutObjectInput{
		ObjectKey:   "reference-key",
		ContentType: "image/png",
		Data:        []byte("reference-image"),
	}); err != nil {
		t.Fatal(err)
	}
	processor := ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			ID:        assetID,
			UserID:    userID,
			ObjectKey: "reference-key",
			MimeType:  "image/jpeg",
			ByteSize:  int64(len("reference-image")),
			Status:    models.ImageAssetStatusReady,
		}},
		Jobs:    jobService,
		Storage: objectStorage,
		Vision:  &observingVision{},
	}
	err := processor.Process(context.Background(), &models.Job{
		ID:     jobID,
		UserID: userID,
		Input:  map[string]any{"asset_id": assetID.String()},
	})
	if !errors.Is(err, providers.ErrInvalidImage) {
		t.Fatalf("error = %v, want invalid image", err)
	}
}

func TestImageAnalysisProcessorProviderTimeout(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	jobID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	processor := ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			ID:        assetID,
			UserID:    userID,
			ObjectKey: "reference-key",
			MimeType:  "image/jpeg",
			ByteSize:  int64(len("reference-image")),
			Status:    models.ImageAssetStatusReady,
		}},
		Jobs:            jobService,
		Storage:         testReferenceStorage("reference-key"),
		Vision:          slowVision{},
		ProviderTimeout: time.Millisecond,
	}
	err := processor.Process(context.Background(), &models.Job{
		ID:     jobID,
		UserID: userID,
		Input:  map[string]any{"asset_id": assetID.String()},
	})
	if !errors.Is(err, context.DeadlineExceeded) {
		t.Fatalf("error = %v, want deadline exceeded", err)
	}
}
