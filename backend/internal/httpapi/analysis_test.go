package httpapi

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
)

type analysisHTTPUsers struct{}

func (analysisHTTPUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	return models.User{ID: id}, nil
}

type analysisHTTPAssets struct {
	asset models.ImageAsset
}

func (assets analysisHTTPAssets) Create(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return assets.asset, nil
}

func (assets analysisHTTPAssets) Get(_ context.Context, userID, assetID uuid.UUID) (models.ImageAsset, error) {
	if assets.asset.ID != assetID || assets.asset.UserID != userID {
		return models.ImageAsset{}, database.ErrNotFound
	}
	return assets.asset, nil
}

func (assets analysisHTTPAssets) Update(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return assets.asset, nil
}

func (assets analysisHTTPAssets) SaveVisualDNA(context.Context, uuid.UUID, uuid.UUID, models.VisualDNA) (models.ImageAsset, error) {
	return assets.asset, nil
}

type analysisHTTPJobs struct {
	job models.Job
}

func (jobs *analysisHTTPJobs) Create(_ context.Context, job models.Job) (models.Job, error) {
	job.ID = uuid.New()
	jobs.job = job
	return job, nil
}

func (jobs *analysisHTTPJobs) Get(_ context.Context, userID, jobID uuid.UUID) (models.Job, error) {
	if jobs.job.ID != jobID || jobs.job.UserID != userID {
		return models.Job{}, database.ErrNotFound
	}
	return jobs.job, nil
}

func (jobs *analysisHTTPJobs) GetByID(_ context.Context, jobID uuid.UUID) (models.Job, error) {
	if jobs.job.ID != jobID {
		return models.Job{}, database.ErrNotFound
	}
	return jobs.job, nil
}

func (jobs *analysisHTTPJobs) GetByIdempotencyKey(context.Context, uuid.UUID, string) (models.Job, error) {
	return models.Job{}, database.ErrNotFound
}

func (jobs *analysisHTTPJobs) ClaimProcessing(context.Context, uuid.UUID, int) (models.Job, bool, error) {
	return jobs.job, false, nil
}

func (jobs *analysisHTTPJobs) Update(_ context.Context, job models.Job) (models.Job, error) {
	jobs.job = job
	return job, nil
}

func TestImageAnalysisEndpointUsesAssetIDContract(t *testing.T) {
	userID := uuid.New()
	assetID := uuid.New()
	jobRepository := &analysisHTTPJobs{}
	server := NewServer(Dependencies{
		Config: config.Config{AuthMode: "development", DevelopmentUserID: userID.String()},
		Services: services.Set{
			Users: analysisHTTPUsers{},
			Assets: analysisHTTPAssets{asset: models.ImageAsset{
				ID:     assetID,
				UserID: userID,
				Status: models.ImageAssetStatusReady,
			}},
			Jobs:  jobRepository,
			Queue: queue.NewMemoryPublisher(),
		},
	})

	body := bytes.NewBufferString(`{"asset_id":"` + assetID.String() + `"}`)
	request := httptest.NewRequest(http.MethodPost, "/v1/image-analysis", body)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)

	if response.Code != http.StatusAccepted {
		t.Fatalf("status = %d, want %d: %s", response.Code, http.StatusAccepted, response.Body.String())
	}
	var envelope struct {
		Data services.JobReference `json:"data"`
	}
	if err := json.Unmarshal(response.Body.Bytes(), &envelope); err != nil {
		t.Fatal(err)
	}
	if envelope.Data.JobID == uuid.Nil || envelope.Data.Status != models.JobStatusQueued {
		t.Fatalf("response = %#v, want queued job reference", envelope.Data)
	}
	if jobRepository.job.Input["asset_id"] != assetID.String() {
		t.Fatalf("job input = %#v, want asset_id", jobRepository.job.Input)
	}
}

func TestCompletedAnalysisJobResponseContainsVisualDNAResult(t *testing.T) {
	visualDNA := models.MockVisualDNA()
	job := models.Job{
		ID:          uuid.New(),
		Type:        models.JobTypeImageAnalysis,
		Status:      models.JobStatusCompleted,
		Output:      map[string]any{"visual_dna": visualDNA},
		CreatedAt:   time.Now().UTC(),
		UpdatedAt:   time.Now().UTC(),
		CompletedAt: timePointerForTest(time.Now().UTC()),
	}
	response, ok := jobResponse(job).(struct {
		ID           uuid.UUID      `json:"id"`
		Type         string         `json:"type"`
		Status       string         `json:"status"`
		Progress     int            `json:"progress,omitempty"`
		Result       map[string]any `json:"result"`
		ErrorCode    string         `json:"error_code,omitempty"`
		ErrorMessage string         `json:"error_message,omitempty"`
		CreatedAt    time.Time      `json:"created_at"`
		StartedAt    *time.Time     `json:"started_at,omitempty"`
		CompletedAt  *time.Time     `json:"completed_at,omitempty"`
		UpdatedAt    time.Time      `json:"updated_at"`
	})
	if !ok {
		t.Fatal("expected analysis response projection")
	}
	if response.Result["visual_dna"] == nil {
		t.Fatalf("result = %#v, want visual_dna", response.Result)
	}
}

func timePointerForTest(value time.Time) *time.Time {
	return &value
}

var _ repositories.ImageAssetRepository = analysisHTTPAssets{}
var _ repositories.JobRepository = (*analysisHTTPJobs)(nil)
