package services

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/pkg/api"
)

type jobTestUsers struct{}

func (jobTestUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	return models.User{ID: id}, nil
}

type jobTestRepository struct {
	mu          sync.Mutex
	jobs        map[uuid.UUID]models.Job
	byIdem      map[string]uuid.UUID
	createError error
}

func newJobTestRepository() *jobTestRepository {
	return &jobTestRepository{
		jobs:   make(map[uuid.UUID]models.Job),
		byIdem: make(map[string]uuid.UUID),
	}
}

func (repository *jobTestRepository) Create(_ context.Context, job models.Job) (models.Job, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	if repository.createError != nil {
		return models.Job{}, repository.createError
	}
	if job.ID == uuid.Nil {
		job.ID = uuid.New()
	}
	if job.CreatedAt.IsZero() {
		job.CreatedAt = time.Now().UTC()
	}
	job.UpdatedAt = job.CreatedAt
	repository.jobs[job.ID] = job
	if job.IdempotencyKey != "" {
		repository.byIdem[job.UserID.String()+":"+job.IdempotencyKey] = job.ID
	}
	return job, nil
}

func (repository *jobTestRepository) Get(_ context.Context, userID, id uuid.UUID) (models.Job, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	job, ok := repository.jobs[id]
	if !ok || job.UserID != userID {
		return models.Job{}, database.ErrNotFound
	}
	return job, nil
}

func (repository *jobTestRepository) GetByID(_ context.Context, id uuid.UUID) (models.Job, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	job, ok := repository.jobs[id]
	if !ok {
		return models.Job{}, database.ErrNotFound
	}
	return job, nil
}

func (repository *jobTestRepository) GetByIdempotencyKey(
	_ context.Context,
	userID uuid.UUID,
	key string,
) (models.Job, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	id, ok := repository.byIdem[userID.String()+":"+key]
	if !ok {
		return models.Job{}, database.ErrNotFound
	}
	return repository.jobs[id], nil
}

func (repository *jobTestRepository) ClaimProcessing(
	_ context.Context,
	id uuid.UUID,
	attempt int,
) (models.Job, bool, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	job, ok := repository.jobs[id]
	if !ok {
		return models.Job{}, false, database.ErrNotFound
	}
	if job.Status != models.JobStatusQueued {
		return job, false, nil
	}
	job.Status = models.JobStatusProcessing
	job.Attempts = attempt
	now := time.Now().UTC()
	job.StartedAt = &now
	repository.jobs[id] = job
	return job, true, nil
}

func (repository *jobTestRepository) Update(_ context.Context, job models.Job) (models.Job, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	if _, ok := repository.jobs[job.ID]; !ok {
		return models.Job{}, database.ErrNotFound
	}
	job.UpdatedAt = time.Now().UTC()
	repository.jobs[job.ID] = job
	return job, nil
}

type jobTestQueue struct {
	mu       sync.Mutex
	messages []queue.JobMessage
	err      error
}

func (publisher *jobTestQueue) Enqueue(_ context.Context, message queue.JobMessage) error {
	publisher.mu.Lock()
	defer publisher.mu.Unlock()
	if publisher.err != nil {
		return publisher.err
	}
	publisher.messages = append(publisher.messages, message)
	return nil
}

type jobTestTemplates struct{}

func (jobTestTemplates) Get(_ context.Context, id uuid.UUID) (models.Template, error) {
	return models.Template{ID: id}, nil
}

func (jobTestTemplates) List(context.Context) ([]models.Template, error) {
	return nil, nil
}

func newJobService(repository *jobTestRepository, publisher queue.JobQueue) JobService {
	return JobService{
		Users:     jobTestUsers{},
		Jobs:      repository,
		Templates: jobTestTemplates{},
		Queue:     publisher,
	}
}

func TestCreateAnalysisJobPersistsAndEnqueues(t *testing.T) {
	repository := newJobTestRepository()
	publisher := &jobTestQueue{}
	service := newJobService(repository, publisher)
	userID := uuid.New()
	assetID := uuid.New()

	job, err := service.CreateAnalysisJob(context.Background(), userID, CreateAnalysisInput{
		ReferenceAssetID: assetID,
	}, "")
	if err != nil {
		t.Fatal(err)
	}
	if job.Status != models.JobStatusQueued || job.Type != models.JobTypeImageAnalysis {
		t.Fatalf("job = %#v, want queued analysis job", job)
	}
	if len(publisher.messages) != 1 || publisher.messages[0].JobID != job.ID {
		t.Fatalf("messages = %#v, want one message for job", publisher.messages)
	}
}

func TestCreateGenerationJobReusesIdempotencyKey(t *testing.T) {
	repository := newJobTestRepository()
	publisher := &jobTestQueue{}
	service := newJobService(repository, publisher)
	userID := uuid.New()
	credits := newCreditTestRepository()
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 10,
	}); err != nil {
		t.Fatal(err)
	}
	service.Credits = credits
	service.GenerationCreditCost = 10
	key := uuid.New().String()
	input := CreateGenerationInput{
		UserPrompt: "A woman walking in Paris",
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "4:5",
		},
	}

	first, err := service.CreateGenerationJob(context.Background(), userID, input, key)
	if err != nil {
		t.Fatal(err)
	}
	second, err := service.CreateGenerationJob(context.Background(), userID, input, key)
	if err != nil {
		t.Fatal(err)
	}
	if first.ID != second.ID {
		t.Fatalf("first ID = %s, second ID = %s, want same job", first.ID, second.ID)
	}
	if len(publisher.messages) != 1 {
		t.Fatalf("messages = %d, want one enqueue", len(publisher.messages))
	}
}

func TestCreateGenerationJobRejectsIdempotencyKeyForDifferentRequest(t *testing.T) {
	repository := newJobTestRepository()
	service := newJobService(repository, &jobTestQueue{})
	userID := uuid.New()
	credits := newCreditTestRepository()
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 20,
	}); err != nil {
		t.Fatal(err)
	}
	service.Credits = credits
	service.GenerationCreditCost = 10
	key := uuid.New().String()
	input := CreateGenerationInput{
		UserPrompt: "A woman walking in Paris",
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "4:5",
		},
	}
	if _, err := service.CreateGenerationJob(context.Background(), userID, input, key); err != nil {
		t.Fatal(err)
	}
	input.UserPrompt = "A mountain cabin"
	_, err := service.CreateGenerationJob(context.Background(), userID, input, key)
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}
}

func TestCreateJobMarksQueueFailure(t *testing.T) {
	repository := newJobTestRepository()
	publisher := &jobTestQueue{err: errors.New("SQS unavailable")}
	service := newJobService(repository, publisher)

	job, err := service.CreateAnalysisJob(context.Background(), uuid.New(), CreateAnalysisInput{
		ReferenceAssetID: uuid.New(),
	}, "")
	if !errors.Is(err, api.ErrQueueFailure) {
		t.Fatalf("error = %v, want queue failure", err)
	}
	if job.Status != models.JobStatusFailed || job.ErrorCode != JobErrorCodeQueueEnqueue {
		t.Fatalf("job = %#v, want persisted failed job", job)
	}
}

func TestGenerationQueueFailureRefundsReservedCredits(t *testing.T) {
	repository := newJobTestRepository()
	publisher := &jobTestQueue{err: errors.New("SQS unavailable")}
	credits := newCreditTestRepository()
	userID := uuid.New()
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 10,
	}); err != nil {
		t.Fatal(err)
	}
	service := newJobService(repository, publisher)
	service.Credits = credits
	service.GenerationCreditCost = 10

	job, err := service.CreateGenerationJob(context.Background(), userID, CreateGenerationInput{
		UserPrompt: "A city street",
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "1:1",
		},
	}, "")
	if !errors.Is(err, api.ErrQueueFailure) {
		t.Fatalf("error = %v, want queue failure", err)
	}
	if job.Status != "" {
		t.Fatalf("returned job = %#v, want zero value on failed request", job)
	}
	persisted, getErr := repository.GetByID(context.Background(), jobIDFromQueueFailure(repository))
	if getErr != nil {
		t.Fatal(getErr)
	}
	if persisted.Status != models.JobStatusFailed {
		t.Fatalf("persisted status = %q, want failed", persisted.Status)
	}
	balance, err := credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 10 {
		t.Fatalf("balance after queue failure = %d, want 10", balance)
	}
}

func jobIDFromQueueFailure(repository *jobTestRepository) uuid.UUID {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	for id := range repository.jobs {
		return id
	}
	return uuid.Nil
}

func TestGetAndCancelJob(t *testing.T) {
	repository := newJobTestRepository()
	publisher := &jobTestQueue{}
	service := newJobService(repository, publisher)
	userID := uuid.New()
	job, err := service.CreateAnalysisJob(context.Background(), userID, CreateAnalysisInput{
		ReferenceAssetID: uuid.New(),
	}, "")
	if err != nil {
		t.Fatal(err)
	}

	loaded, err := service.GetJob(context.Background(), userID, job.ID)
	if err != nil || loaded.ID != job.ID {
		t.Fatalf("loaded = %#v, err = %v", loaded, err)
	}
	cancelled, err := service.CancelJob(context.Background(), userID, job.ID)
	if err != nil {
		t.Fatal(err)
	}
	if cancelled.Status != models.JobStatusCancelled {
		t.Fatalf("status = %q, want cancelled", cancelled.Status)
	}
	ignored, err := service.UpdateStatus(context.Background(), job.ID, JobStatusUpdate{
		Status:   models.JobStatusProcessing,
		Progress: 10,
	})
	if err != nil {
		t.Fatal(err)
	}
	if ignored.Status != models.JobStatusCancelled {
		t.Fatalf("status after worker update = %q, want cancelled", ignored.Status)
	}
}

func TestCancelGenerationRefundsReservedCredits(t *testing.T) {
	repository := newJobTestRepository()
	publisher := &jobTestQueue{}
	credits := newCreditTestRepository()
	userID := uuid.New()
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 10,
	}); err != nil {
		t.Fatal(err)
	}
	service := newJobService(repository, publisher)
	service.Credits = credits
	service.GenerationCreditCost = 10

	job, err := service.CreateGenerationJob(context.Background(), userID, CreateGenerationInput{
		UserPrompt: "A mountain cabin",
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "4:5",
		},
	}, "")
	if err != nil {
		t.Fatal(err)
	}
	if _, err := service.CancelJob(context.Background(), userID, job.ID); err != nil {
		t.Fatal(err)
	}
	balance, err := credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 10 {
		t.Fatalf("balance after cancellation = %d, want 10", balance)
	}
	if _, err := service.CancelJob(context.Background(), userID, job.ID); err != nil {
		t.Fatal(err)
	}
	balance, err = credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 10 {
		t.Fatalf("balance after repeated cancellation = %d, want 10", balance)
	}
}
