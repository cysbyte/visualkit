package httpapi

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/pkg/api"
)

type estimateHTTPTemplates struct {
	template models.Template
}

func (templates estimateHTTPTemplates) List(context.Context) ([]models.Template, error) {
	return []models.Template{templates.template}, nil
}

func (templates estimateHTTPTemplates) Get(_ context.Context, id uuid.UUID) (models.Template, error) {
	template := templates.template
	template.ID = id
	return template, nil
}

type insufficientHTTPCredits struct{}

func (insufficientHTTPCredits) Balance(context.Context, uuid.UUID) (int, error) {
	return 0, nil
}

func (insufficientHTTPCredits) Append(context.Context, models.CreditLedgerEntry) error {
	return nil
}

func (insufficientHTTPCredits) Reserve(context.Context, uuid.UUID, string, uuid.UUID, int) error {
	return database.ErrInsufficientCredits
}

func (insufficientHTTPCredits) Consume(context.Context, uuid.UUID, string, uuid.UUID) error {
	return nil
}

func (insufficientHTTPCredits) Refund(context.Context, uuid.UUID, string, uuid.UUID) error {
	return nil
}

func TestGenerationEstimateReturnsBackendCost(t *testing.T) {
	userID := uuid.New()
	templateID := uuid.New()
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode:             "development",
			DevelopmentUserID:    userID.String(),
			GenerationCreditCost: 125,
		},
		Services: services.Set{
			Users: analysisHTTPUsers{},
			Templates: estimateHTTPTemplates{
				template: models.Template{
					ID: templateID,
					DefaultSettings: models.GenerationSettings{
						AspectRatio: "4:5",
					},
				},
			},
		},
	})

	request := httptest.NewRequest(
		http.MethodGet,
		"/v1/generation/estimate?template_id="+templateID.String()+"&aspect_ratio=4:5",
		nil,
	)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusOK {
		t.Fatalf("status = %d: %s", response.Code, response.Body.String())
	}
	var envelope struct {
		Data services.GenerationEstimate `json:"data"`
	}
	if err := json.Unmarshal(response.Body.Bytes(), &envelope); err != nil {
		t.Fatal(err)
	}
	if envelope.Data.EstimatedCredits != 125 {
		t.Fatalf("estimate = %#v, want 125 credits", envelope.Data)
	}
}

func TestGenerationEstimateRequiresTemplateID(t *testing.T) {
	userID := uuid.New()
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode:             "development",
			DevelopmentUserID:    userID.String(),
			GenerationCreditCost: 80,
		},
		Services: services.Set{
			Users: analysisHTTPUsers{},
		},
	})
	request := httptest.NewRequest(http.MethodGet, "/v1/generation/estimate", nil)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want %d: %s", response.Code, http.StatusBadRequest, response.Body.String())
	}
}

func TestGenerationReturnsPaymentRequiredWhenCreditsAreInsufficient(t *testing.T) {
	userID := uuid.New()
	templateID := uuid.New()
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode:             "development",
			DevelopmentUserID:    userID.String(),
			GenerationCreditCost: 80,
		},
		Services: services.Set{
			Users:     analysisHTTPUsers{},
			Jobs:      &analysisHTTPJobs{},
			Templates: estimateHTTPTemplates{template: models.Template{ID: templateID}},
			Credits:   insufficientHTTPCredits{},
			Queue:     queue.NewMemoryPublisher(),
		},
	})

	request := httptest.NewRequest(http.MethodPost, "/v1/jobs/image-generation", strings.NewReader(`{
		"userPrompt": "A city street",
		"templateId": "`+templateID.String()+`",
		"generationSettings": {"aspectRatio": "1:1"}
	}`))
	request.Header.Set("Content-Type", "application/json")
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	if response.Code != http.StatusPaymentRequired {
		t.Fatalf("status = %d, want %d: %s", response.Code, http.StatusPaymentRequired, response.Body.String())
	}
	var envelope struct {
		Error *api.ErrorBody `json:"error"`
	}
	if err := json.Unmarshal(response.Body.Bytes(), &envelope); err != nil {
		t.Fatal(err)
	}
	if envelope.Error == nil || envelope.Error.Code != "INSUFFICIENT_CREDITS" {
		t.Fatalf("error = %#v, want insufficient credits", envelope.Error)
	}
}

var _ repositories.TemplateRepository = estimateHTTPTemplates{}
var _ repositories.CreditRepository = insufficientHTTPCredits{}
