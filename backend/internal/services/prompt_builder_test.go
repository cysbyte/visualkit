package services

import (
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
)

func TestPromptBuilderPreservesOriginalPrompt(t *testing.T) {
	prompt := "A woman riding a bicycle in Paris"
	template := testPromptTemplate("Editorial Fashion", []string{"editorial polish"})
	intent, err := (PromptBuilder{}).BuildGenerationIntent(models.GenerationDraft{
		Prompt:     prompt,
		TemplateID: template.ID,
		Preservation: models.PreservationSettings{
			Style:    true,
			Lighting: true,
		},
		VisualDNA: &testVisualDNA,
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "4:5",
		},
	}, template)
	if err != nil {
		t.Fatal(err)
	}
	if intent.OriginalPrompt != prompt {
		t.Fatalf("original prompt = %q, want %q", intent.OriginalPrompt, prompt)
	}
	resolved, err := (PromptBuilder{}).BuildProviderPrompt(intent)
	if err != nil {
		t.Fatal(err)
	}
	if strings.HasPrefix(resolved, prompt) == false {
		t.Fatalf("resolved prompt = %q, want original prompt first", resolved)
	}
	if strings.Contains(intent.OriginalPrompt, "editorial polish") {
		t.Fatal("template directive modified original prompt")
	}
}

func TestPromptBuilderIncludesOnlyPreservedVisualDNA(t *testing.T) {
	template := testPromptTemplate("Cinematic", []string{"cinematic composition"})
	settings := models.PreservationSettings{
		Style:    true,
		Lighting: true,
		Color:    true,
		Camera:   false,
	}
	intent, err := (PromptBuilder{}).BuildGenerationIntent(models.GenerationDraft{
		Prompt:             "A bicycle in Paris",
		TemplateID:         template.ID,
		VisualDNA:          &testVisualDNA,
		Preservation:       settings,
		GenerationSettings: models.GenerationSettings{AspectRatio: "4:5"},
	}, template)
	if err != nil {
		t.Fatal(err)
	}
	if intent.VisualDNA.Camera.Attributes != nil {
		t.Fatalf("camera attributes = %#v, want excluded", intent.VisualDNA.Camera.Attributes)
	}
	resolved, err := (PromptBuilder{}).BuildProviderPrompt(intent)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(resolved, "35mm look") {
		t.Fatalf("resolved prompt = %q, camera should be excluded", resolved)
	}
	if !strings.Contains(resolved, "cinematic") || !strings.Contains(resolved, "warm") {
		t.Fatalf("resolved prompt = %q, selected style and color should be included", resolved)
	}
}

func TestPromptBuilderDoesNotDuplicateCasePromptAsDirective(t *testing.T) {
	prompt := "Create a product poster for [PRODUCT]."
	template := testPromptTemplate("Case Template", []string{prompt})
	intent, err := (PromptBuilder{}).BuildGenerationIntent(models.GenerationDraft{
		Prompt:             prompt,
		TemplateID:         template.ID,
		GenerationSettings: models.GenerationSettings{AspectRatio: "1:1"},
	}, template)
	if err != nil {
		t.Fatal(err)
	}
	resolved, err := (PromptBuilder{}).BuildProviderPrompt(intent)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(resolved, "Template directives:") {
		t.Fatalf("resolved prompt = %q, should not duplicate case prompt as directive", resolved)
	}
}

func TestPromptBuilderAppliesTemplateDefaultsWithoutOverwritingAspectRatio(t *testing.T) {
	template := testPromptTemplate("Portrait", []string{"portrait framing"})
	template.DefaultSettings = models.GenerationSettings{
		AspectRatio: "4:5",
		Quality:     "high",
		Count:       1,
	}
	intent, err := (PromptBuilder{}).BuildGenerationIntent(models.GenerationDraft{
		Prompt:             "A mountain cabin",
		TemplateID:         template.ID,
		GenerationSettings: models.GenerationSettings{AspectRatio: "16:9"},
	}, template)
	if err != nil {
		t.Fatal(err)
	}
	if intent.GenerationSettings.AspectRatio != "16:9" {
		t.Fatalf("aspect ratio = %q, want explicit draft ratio", intent.GenerationSettings.AspectRatio)
	}
	if intent.GenerationSettings.Quality != "high" {
		t.Fatalf("quality = %q, want template default", intent.GenerationSettings.Quality)
	}
}

func TestDifferentTemplatesProduceDifferentConfigurations(t *testing.T) {
	draft := models.GenerationDraft{
		Prompt:             "A city street",
		TemplateID:         uuid.New(),
		GenerationSettings: models.GenerationSettings{AspectRatio: "1:1"},
	}
	first := testPromptTemplate("Cinematic", []string{"film contrast"})
	first.ID = draft.TemplateID
	second := testPromptTemplate("Minimal", []string{"negative space"})
	second.ID = draft.TemplateID
	firstIntent, err := (PromptBuilder{}).BuildGenerationIntent(draft, first)
	if err != nil {
		t.Fatal(err)
	}
	secondIntent, err := (PromptBuilder{}).BuildGenerationIntent(draft, second)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Join(firstIntent.PromptDirectives, ",") == strings.Join(secondIntent.PromptDirectives, ",") {
		t.Fatal("template directives should differ")
	}
}

var testVisualDNA = models.MockVisualDNA()

func testPromptTemplate(name string, directives []string) models.Template {
	return models.Template{
		ID:               uuid.New(),
		Name:             name,
		Category:         strings.ToLower(name),
		PromptDirectives: directives,
		IsActive:         true,
	}
}
