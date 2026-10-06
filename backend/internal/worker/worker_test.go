package worker

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/providers"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
)

type fakeJobs struct {
	job models.Job
}

func newFakeJobs(job models.Job) *fakeJobs {
	return &fakeJobs{job: job}
}

func (jobs *fakeJobs) Create(_ context.Context, job models.Job) (models.Job, error) {
	if job.ID == uuid.Nil {
		job.ID = uuid.New()
	}
	jobs.job = job
	return job, nil
}

func (jobs *fakeJobs) Get(_ context.Context, userID, id uuid.UUID) (models.Job, error) {
	if jobs.job.ID != id || jobs.job.UserID != userID {
		return models.Job{}, errors.New("not found")
	}
	return jobs.job, nil
}

func (jobs *fakeJobs) GetByID(context.Context, uuid.UUID) (models.Job, error) {
	return jobs.job, nil
}

func (jobs *fakeJobs) GetByIdempotencyKey(context.Context, uuid.UUID, string) (models.Job, error) {
	return models.Job{}, errors.New("not found")
}

func (jobs *fakeJobs) ClaimProcessing(_ context.Context, _ uuid.UUID, attempt int) (models.Job, bool, error) {
	if jobs.job.Status != models.JobStatusQueued {
		return jobs.job, false, nil
	}
	jobs.job.Status = models.JobStatusProcessing
	jobs.job.Attempts = attempt
	now := time.Now().UTC()
	jobs.job.StartedAt = &now
	return jobs.job, true, nil
}

func (jobs *fakeJobs) Update(_ context.Context, job models.Job) (models.Job, error) {
	jobs.job = job
	return job, nil
}

type fakeJobService struct {
	services.JobService
	jobs *fakeJobs
}

func newFakeJobService(job models.Job) services.JobService {
	store := newFakeJobs(job)
	return services.JobService{Jobs: store}
}

type fakeAssets struct {
	asset models.ImageAsset
}

func (assets *fakeAssets) Create(_ context.Context, asset models.ImageAsset) (models.ImageAsset, error) {
	if asset.ID == uuid.Nil {
		asset.ID = uuid.New()
	}
	asset.UserID = coalesceUUID(asset.UserID, assets.asset.UserID)
	return asset, nil
}

func (assets *fakeAssets) Get(_ context.Context, userID, id uuid.UUID) (models.ImageAsset, error) {
	asset := assets.asset
	asset.UserID = userID
	asset.ID = id
	return asset, nil
}

func (assets *fakeAssets) Update(_ context.Context, asset models.ImageAsset) (models.ImageAsset, error) {
	assets.asset = asset
	return asset, nil
}

func (assets *fakeAssets) SaveVisualDNA(_ context.Context, userID, id uuid.UUID, visualDNA models.VisualDNA) (models.ImageAsset, error) {
	asset := assets.asset
	asset.UserID = userID
	asset.ID = id
	asset.VisualDNA = &visualDNA
	assets.asset = asset
	return asset, nil
}

type fakeCreations struct {
	creation models.Creation
}

type fakeTemplates struct {
	template models.Template
}

func (templates fakeTemplates) List(context.Context) ([]models.Template, error) {
	return []models.Template{templates.template}, nil
}

func (templates fakeTemplates) Get(_ context.Context, id uuid.UUID) (models.Template, error) {
	template := templates.template
	template.ID = id
	return template, nil
}

func (creations *fakeCreations) List(context.Context, uuid.UUID) ([]models.Creation, error) {
	return nil, nil
}

func (creations *fakeCreations) Get(context.Context, uuid.UUID, uuid.UUID) (models.Creation, error) {
	return creations.creation, nil
}

func (creations *fakeCreations) Create(_ context.Context, creation models.Creation) (models.Creation, error) {
	if creation.ID == uuid.Nil {
		creation.ID = uuid.New()
	}
	creations.creation = creation
	return creation, nil
}

func (creations *fakeCreations) Update(_ context.Context, creation models.Creation) (models.Creation, error) {
	creations.creation = creation
	return creation, nil
}

type fakeVision struct {
	err error
}

func (provider fakeVision) AnalyzeImage(ctx context.Context, _ providers.VisionInput) (models.VisualDNA, error) {
	if provider.err != nil {
		return models.VisualDNA{}, provider.err
	}
	select {
	case <-ctx.Done():
		return models.VisualDNA{}, ctx.Err()
	default:
	}
	visualDNA := models.MockVisualDNA()
	visualDNA.Style.Attributes = []string{"Cinematic"}
	return visualDNA, nil
}

type slowVision struct{}

func (slowVision) AnalyzeImage(ctx context.Context, _ providers.VisionInput) (models.VisualDNA, error) {
	<-ctx.Done()
	return models.VisualDNA{}, ctx.Err()
}

type fakeGenerator struct {
	err error
}

func (provider fakeGenerator) GenerateImage(context.Context, providers.GenerationInput) (providers.GeneratedImage, error) {
	if provider.err != nil {
		return providers.GeneratedImage{}, provider.err
	}
	return providers.GeneratedImage{
		MimeType:      "image/jpeg",
		Data:          []byte("image"),
		ThumbnailData: []byte("thumb"),
		PixelWidth:    512,
		PixelHeight:   512,
	}, nil
}

func TestProcessorSelection(t *testing.T) {
	set := ProcessorSet{
		Analysis:   ImageAnalysisProcessor{},
		Generation: ImageGenerationProcessor{},
	}
	if _, ok := set.ForType(models.JobTypeImageAnalysis); !ok {
		t.Fatal("expected analysis processor")
	}
	if _, ok := set.ForType(models.JobTypeImageGeneration); !ok {
		t.Fatal("expected generation processor")
	}
	if _, ok := set.ForType("unknown"); ok {
		t.Fatal("did not expect processor for unknown job type")
	}
}

func TestImageAnalysisProcessorCompletesJob(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	jobID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	processor := ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			ID:        assetID,
			UserID:    userID,
			ObjectKey: "users/u/assets/a/original",
			MimeType:  "image/jpeg",
			Status:    models.ImageAssetStatusReady,
		}},
		Jobs:            jobService,
		Storage:         testReferenceStorage("users/u/assets/a/original"),
		Vision:          fakeVision{},
		ProviderTimeout: time.Second,
	}
	job := models.Job{
		ID:     jobID,
		UserID: userID,
		Type:   models.JobTypeImageAnalysis,
		Input:  map[string]any{"asset_id": assetID.String()},
	}
	if err := processor.Process(context.Background(), &job); err != nil {
		t.Fatal(err)
	}
	completed, err := jobService.LoadJob(context.Background(), jobID)
	if err != nil {
		t.Fatal(err)
	}
	if completed.Status != models.JobStatusCompleted {
		t.Fatalf("status = %q, want completed", completed.Status)
	}
}

func TestImageGenerationProcessorCompletesJob(t *testing.T) {
	userID := uuid.New()
	jobID := uuid.New()
	templateID := uuid.New()
	jobService := newFakeJobService(models.Job{ID: jobID, UserID: userID})
	processor := ImageGenerationProcessor{
		Assets:    &fakeAssets{asset: models.ImageAsset{UserID: userID}},
		Creations: &fakeCreations{},
		Templates: fakeTemplates{template: models.Template{
			ID:               templateID,
			Name:             "Cinematic",
			PromptDirectives: []string{"cinematic contrast"},
			DefaultSettings: models.GenerationSettings{
				AspectRatio: "16:9",
			},
		}},
		Jobs:      jobService,
		Storage:   storage.NewMockObjectStorage(),
		Generator: fakeGenerator{},
	}
	job := models.Job{
		ID:     jobID,
		UserID: userID,
		Type:   models.JobTypeImageGeneration,
		Input: map[string]any{
			"userPrompt": "A product photo",
			"templateId": templateID.String(),
			"generationSettings": map[string]any{
				"aspectRatio": "1:1",
			},
			"preservationSettings": map[string]any{},
		},
	}
	if err := processor.Process(context.Background(), &job); err != nil {
		t.Fatal(err)
	}
	completed, err := jobService.LoadJob(context.Background(), jobID)
	if err != nil {
		t.Fatal(err)
	}
	if completed.Status != models.JobStatusCompleted {
		t.Fatalf("status = %q, want completed", completed.Status)
	}
}

func TestRunnerDispatchRetryPermanentAndCancellation(t *testing.T) {
	jobID := uuid.New()
	job := models.Job{
		ID:     jobID,
		UserID: uuid.New(),
		Type:   models.JobTypeImageAnalysis,
		Status: models.JobStatusQueued,
		Input:  map[string]any{"asset_id": uuid.New().String()},
	}
	service := newFakeJobService(job)
	runner := Runner{
		Jobs: service,
		Processors: ProcessorSet{Analysis: ImageAnalysisProcessor{
			Assets: &fakeAssets{asset: models.ImageAsset{
				Status:    models.ImageAssetStatusReady,
				ObjectKey: "key",
				MimeType:  "image/jpeg",
			}},
			Jobs:    service,
			Storage: testReferenceStorage("key"),
			Vision:  fakeVision{err: context.DeadlineExceeded},
		}},
		MaxAttempts: 3,
	}
	acked := runner.HandleMessage(context.Background(), queue.ReceivedJobMessage{
		JobMessage: queue.JobMessage{JobID: jobID, Type: models.JobTypeImageAnalysis, Attempt: 1},
	})
	if acked {
		t.Fatal("retryable error before max attempts should not ack")
	}
	retried, _ := service.LoadJob(context.Background(), jobID)
	if retried.Status != models.JobStatusQueued {
		t.Fatalf("status = %q, want requeued", retried.Status)
	}

	service = newFakeJobService(job)
	runner.Jobs = service
	runner.Processors.Analysis = ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			Status:    models.ImageAssetStatusReady,
			ObjectKey: "key",
			MimeType:  "image/jpeg",
		}},
		Jobs:    service,
		Storage: testReferenceStorage("key"),
		Vision:  fakeVision{err: providers.ErrInvalidImage},
	}
	acked = runner.HandleMessage(context.Background(), queue.ReceivedJobMessage{
		JobMessage: queue.JobMessage{JobID: jobID, Type: models.JobTypeImageAnalysis, Attempt: 1},
	})
	if !acked {
		t.Fatal("permanent error should ack after durable failure")
	}
	failed, _ := service.LoadJob(context.Background(), jobID)
	if failed.Status != models.JobStatusFailed {
		t.Fatalf("status = %q, want failed", failed.Status)
	}

	cancelledJob := job
	cancelledJob.Status = models.JobStatusCancelled
	service = newFakeJobService(cancelledJob)
	runner.Jobs = service
	acked = runner.HandleMessage(context.Background(), queue.ReceivedJobMessage{
		JobMessage: queue.JobMessage{JobID: jobID, Type: models.JobTypeImageAnalysis, Attempt: 1},
	})
	if !acked {
		t.Fatal("cancelled job should ack")
	}
}

func TestProviderTimeout(t *testing.T) {
	jobID := uuid.New()
	assetID := uuid.New()
	service := newFakeJobService(models.Job{ID: jobID, UserID: uuid.New()})
	processor := ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			ID:        assetID,
			Status:    models.ImageAssetStatusReady,
			ObjectKey: "key",
			MimeType:  "image/jpeg",
		}},
		Jobs:            service,
		Storage:         testReferenceStorage("key"),
		Vision:          slowVision{},
		ProviderTimeout: time.Millisecond,
	}
	job := models.Job{ID: jobID, UserID: uuid.New(), Input: map[string]any{"asset_id": assetID.String()}}
	err := processor.Process(context.Background(), &job)
	if !errors.Is(err, context.DeadlineExceeded) {
		t.Fatalf("error = %v, want deadline", err)
	}
}

func TestProcessorsCheckCancellationBeforeProvider(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	jobID := uuid.New()
	jobService := newFakeJobService(models.Job{
		ID:     jobID,
		UserID: userID,
		Status: models.JobStatusCancelled,
	})
	processor := ImageAnalysisProcessor{
		Assets: &fakeAssets{asset: models.ImageAsset{
			ID:        assetID,
			UserID:    userID,
			ObjectKey: "key",
			MimeType:  "image/jpeg",
			Status:    models.ImageAssetStatusReady,
		}},
		Jobs:    jobService,
		Storage: testReferenceStorage("key"),
		Vision:  fakeVision{},
	}
	err := processor.Process(context.Background(), &models.Job{
		ID:     jobID,
		UserID: userID,
		Input:  map[string]any{"asset_id": assetID.String()},
	})
	if !errors.Is(err, context.Canceled) {
		t.Fatalf("error = %v, want cancellation", err)
	}
}

func TestGracefulShutdown(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	runner := Runner{
		Consumer:    queue.NewMemoryPublisher(),
		Jobs:        newFakeJobService(models.Job{}),
		Concurrency: 1,
	}
	if err := runner.Run(ctx); err != nil {
		t.Fatal(err)
	}
}

func coalesceUUID(value, fallback uuid.UUID) uuid.UUID {
	if value == uuid.Nil {
		return fallback
	}
	return value
}

func testReferenceStorage(objectKey string) *storage.MockObjectStorage {
	objectStorage := storage.NewMockObjectStorage()
	_ = objectStorage.PutObject(context.Background(), storage.PutObjectInput{
		ObjectKey:   objectKey,
		ContentType: "image/jpeg",
		Data:        []byte("reference-image"),
	})
	return objectStorage
}
