package providers

import (
	"context"
	"encoding/json"
	"errors"
	"testing"

	"github.com/visualkit/backend/internal/models"
)

func TestParseVisualDNAResponse(t *testing.T) {
	data, err := json.Marshal(models.MockVisualDNA())
	if err != nil {
		t.Fatal(err)
	}
	decoded, err := ParseVisualDNAResponse(data)
	if err != nil {
		t.Fatal(err)
	}
	if decoded.Style.Attributes[0] != "cinematic" {
		t.Fatalf("style = %#v", decoded.Style.Attributes)
	}
}

func TestParseVisualDNAResponseRecoversOneJSONObject(t *testing.T) {
	data, err := json.Marshal(models.MockVisualDNA())
	if err != nil {
		t.Fatal(err)
	}
	decoded, err := ParseVisualDNAResponse(append([]byte("```json\n"), append(data, []byte("\n```")...)...))
	if err != nil {
		t.Fatal(err)
	}
	if decoded.SchemaVersion != models.VisualDNASchemaVersion {
		t.Fatalf("schema version = %d", decoded.SchemaVersion)
	}
}

func TestParseVisualDNAResponseRejectsMalformedOutput(t *testing.T) {
	if _, err := ParseVisualDNAResponse([]byte(`{"style":{"attributes":["cinematic"]}}`)); !errors.Is(err, ErrInvalidProviderRequest) {
		t.Fatalf("error = %v, want invalid provider request", err)
	}
}

func TestParseVisualDNAResponseRejectsUnknownFields(t *testing.T) {
	data, err := json.Marshal(models.MockVisualDNA())
	if err != nil {
		t.Fatal(err)
	}
	var fields map[string]any
	if err := json.Unmarshal(data, &fields); err != nil {
		t.Fatal(err)
	}
	fields["provider_prompt"] = "do more"
	data, err = json.Marshal(fields)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := ParseVisualDNAResponse(data); !errors.Is(err, ErrInvalidProviderRequest) {
		t.Fatalf("error = %v, want invalid provider request", err)
	}
}

func TestStructuredVisionProviderRequiresImage(t *testing.T) {
	provider := StructuredVisionProvider{
		Analyze: func(context.Context, VisionInput) ([]byte, error) {
			return json.Marshal(models.MockVisualDNA())
		},
	}
	if _, err := provider.AnalyzeImage(context.Background(), VisionInput{}); !errors.Is(err, ErrInvalidImage) {
		t.Fatalf("error = %v, want invalid image", err)
	}
}

func TestNewVisionProviderSelectsConfiguredAdapter(t *testing.T) {
	provider, err := NewVisionProvider("http", "https://vision.test/analyze", "secret")
	if err != nil {
		t.Fatal(err)
	}
	if _, ok := provider.(HTTPVisionProvider); !ok {
		t.Fatalf("provider = %T, want HTTPVisionProvider", provider)
	}
}

func TestNewVisionProviderRejectsUnknownProvider(t *testing.T) {
	if _, err := NewVisionProvider("unknown", "", ""); err == nil {
		t.Fatal("expected unknown provider error")
	}
}
