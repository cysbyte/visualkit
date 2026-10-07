package services

import (
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
)

type PromptBuilder struct{}

func (PromptBuilder) BuildGenerationIntent(
	draft models.GenerationDraft,
	template models.Template,
) (models.GenerationIntent, error) {
	if err := validateDraft(draft); err != nil {
		return models.GenerationIntent{}, err
	}
	if template.ID != draft.TemplateID {
		return models.GenerationIntent{}, fmt.Errorf("template does not match generation draft")
	}
	if draft.VisualDNA != nil {
		if err := draft.VisualDNA.Validate(); err != nil {
			return models.GenerationIntent{}, fmt.Errorf("visual DNA is invalid: %w", err)
		}
	}
	settings := mergeGenerationSettings(template.EffectiveDefaultSettings(), draft.GenerationSettings)
	if draft.AspectRatio != "" {
		settings.AspectRatio = draft.AspectRatio
	}
	return models.GenerationIntent{
		OriginalPrompt:     draft.Prompt,
		TemplateID:         template.ID,
		TemplateName:       template.Name,
		TemplateCategory:   template.Category,
		PromptDirectives:   template.EffectivePromptDirectives(),
		VisualDNA:          preservedVisualDNA(draft.VisualDNA, draft.Preservation),
		Preservation:       draft.Preservation,
		ReferenceAssetID:   draft.ReferenceAssetID,
		GenerationSettings: settings,
	}, nil
}

// BuildProviderPrompt creates a provider-neutral resolved prompt. Provider
// adapters can format the same intent differently without changing the client
// contract or mutating the original prompt.
func (builder PromptBuilder) BuildProviderPrompt(intent models.GenerationIntent) (string, error) {
	if strings.TrimSpace(intent.OriginalPrompt) == "" {
		return "", fmt.Errorf("prompt is required")
	}
	sections := []string{strings.TrimSpace(intent.OriginalPrompt)}
	if directives := promptDirectivesForProvider(intent.OriginalPrompt, intent.PromptDirectives); len(directives) > 0 {
		sections = append(sections, "Template directives: "+joinValues(directives))
	}
	if intent.VisualDNA != nil {
		visualSection := visualDNASection(*intent.VisualDNA)
		if visualSection != "" {
			sections = append(sections, "Preserved visual characteristics: "+visualSection)
		}
	}
	return strings.Join(sections, "\n\n"), nil
}

func promptDirectivesForProvider(originalPrompt string, directives []string) []string {
	trimmedPrompt := strings.TrimSpace(originalPrompt)
	result := make([]string, 0, len(directives))
	for _, directive := range directives {
		directive = strings.TrimSpace(directive)
		if directive == "" || directive == trimmedPrompt {
			continue
		}
		result = append(result, directive)
	}
	return result
}

func validateDraft(draft models.GenerationDraft) error {
	if strings.TrimSpace(draft.Prompt) == "" {
		return fmt.Errorf("prompt is required")
	}
	if draft.TemplateID == uuid.Nil {
		return fmt.Errorf("template id is required")
	}
	return nil
}

func preservedVisualDNA(visualDNA *models.VisualDNA, settings models.PreservationSettings) *models.VisualDNA {
	if visualDNA == nil {
		return nil
	}
	preserved := visualDNA.Preserved(settings)
	return &preserved
}

func visualDNASection(visualDNA models.VisualDNA) string {
	type namedCategory struct {
		name     string
		category models.VisualDNACategory
	}
	categories := []namedCategory{
		{"subject", visualDNA.Subject},
		{"composition", visualDNA.Composition},
		{"lighting", visualDNA.Lighting},
		{"color", visualDNA.ColorPalette},
		{"camera", visualDNA.Camera},
		{"depth_of_field", visualDNA.DepthOfField},
		{"style", visualDNA.Style},
		{"mood", visualDNA.Mood},
		{"background", visualDNA.Background},
		{"texture", visualDNA.Texture},
	}
	parts := make([]string, 0, len(categories))
	for _, item := range categories {
		values := append([]string{}, item.category.Attributes...)
		values = append(values, item.category.Inferences...)
		values = append(values, item.category.Observations...)
		if value := joinValues(values); value != "" {
			parts = append(parts, item.name+": "+value)
		}
	}
	return strings.Join(parts, "; ")
}

func joinValues(values []string) string {
	trimmed := make([]string, 0, len(values))
	for _, value := range values {
		if value = strings.TrimSpace(value); value != "" {
			trimmed = append(trimmed, value)
		}
	}
	return strings.Join(trimmed, ", ")
}

func mergeGenerationSettings(defaults, explicit models.GenerationSettings) models.GenerationSettings {
	if explicit.AspectRatio == "" {
		explicit.AspectRatio = defaults.AspectRatio
	}
	if explicit.Quality == "" {
		explicit.Quality = defaults.Quality
	}
	if explicit.Count == 0 {
		explicit.Count = defaults.Count
	}
	return explicit
}
