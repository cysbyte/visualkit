package services

import (
	"context"
	"errors"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/pkg/api"
)

func TestCreateGenerationValidatesPromptBeforeDependencies(t *testing.T) {
	service := JobService{}
	_, err := service.CreateGeneration(context.Background(), uuid.New(), CreateGenerationInput{
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "1:1",
		},
	})
	if err == nil {
		t.Fatal("expected prompt validation error")
	}
}

func TestCreateGenerationFailsClosedWithoutCreditRepository(t *testing.T) {
	service := JobService{
		Users:     jobTestUsers{},
		Jobs:      newJobTestRepository(),
		Templates: jobTestTemplates{},
		Queue:     &jobTestQueue{},
	}
	_, err := service.CreateGeneration(context.Background(), uuid.New(), CreateGenerationInput{
		UserPrompt: "A city street",
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "1:1",
		},
	})
	if !errors.Is(err, api.ErrUnavailable) {
		t.Fatalf("error = %v, want service unavailable", err)
	}
}

func TestCreateAnalysisValidatesReferenceAsset(t *testing.T) {
	service := JobService{}
	_, err := service.CreateAnalysis(context.Background(), uuid.New(), CreateAnalysisInput{})
	if err == nil {
		t.Fatal("expected reference asset validation error")
	}
}

func TestUpdateStatusValidatesProgress(t *testing.T) {
	service := JobService{}
	_, err := service.UpdateStatus(context.Background(), uuid.New(), JobStatusUpdate{
		Status:   "processing",
		Progress: 101,
	})
	if err == nil {
		t.Fatal("expected progress validation error")
	}
}
