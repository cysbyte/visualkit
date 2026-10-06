package models

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/google/uuid"
)

// GenerationDraft is the provider-neutral contract submitted by the client.
// It contains user intent only; it does not contain provider prompt syntax.
type GenerationDraft struct {
	Prompt             string               `json:"prompt"`
	TemplateID         uuid.UUID            `json:"template_id"`
	VisualDNA          *VisualDNA           `json:"visual_dna,omitempty"`
	Preservation       PreservationSettings `json:"preservation"`
	ReferenceAssetID   *uuid.UUID           `json:"reference_asset_id,omitempty"`
	GenerationSettings GenerationSettings   `json:"generation_settings"`
	AspectRatio        string               `json:"aspect_ratio,omitempty"`
}

type GenerationIntent struct {
	OriginalPrompt     string               `json:"original_prompt"`
	TemplateID         uuid.UUID            `json:"template_id"`
	TemplateName       string               `json:"template_name"`
	TemplateCategory   string               `json:"template_category"`
	PromptDirectives   []string             `json:"prompt_directives,omitempty"`
	VisualDNA          *VisualDNA           `json:"visual_dna,omitempty"`
	Preservation       PreservationSettings `json:"preservation"`
	ReferenceAssetID   *uuid.UUID           `json:"reference_asset_id,omitempty"`
	GenerationSettings GenerationSettings   `json:"generation_settings"`
}

func (request GenerationRequest) Draft() GenerationDraft {
	prompt := request.OriginalPrompt
	if prompt == "" {
		prompt = request.UserPrompt
	}
	return GenerationDraft{
		Prompt:             prompt,
		TemplateID:         request.TemplateID,
		VisualDNA:          request.VisualDNA,
		Preservation:       request.PreservationSettings,
		ReferenceAssetID:   request.ReferenceAssetID,
		GenerationSettings: request.GenerationSettings,
		AspectRatio:        request.GenerationSettings.AspectRatio,
	}
}

func (request *GenerationRequest) UnmarshalJSON(data []byte) error {
	type wire struct {
		OriginalPrompt        string               `json:"original_prompt"`
		Prompt                string               `json:"prompt"`
		UserPrompt            string               `json:"userPrompt"`
		ReferenceAssetID      *uuid.UUID           `json:"referenceAssetId"`
		ReferenceAssetIDSNAKE *uuid.UUID           `json:"reference_asset_id"`
		VisualDNA             *VisualDNA           `json:"visualDNA"`
		VisualDNASNAKE        *VisualDNA           `json:"visual_dna"`
		PreservationSettings  PreservationSettings `json:"preservationSettings"`
		Preservation          PreservationSettings `json:"preservation"`
		TemplateID            uuid.UUID            `json:"templateId"`
		TemplateIDSNAKE       uuid.UUID            `json:"template_id"`
		GenerationSettings    GenerationSettings   `json:"generationSettings"`
		GenerationSNAKE       GenerationSettings   `json:"generation_settings"`
		ResolvedPrompt        string               `json:"resolved_generation_prompt"`
	}
	var decoded wire
	if err := json.Unmarshal(data, &decoded); err != nil {
		return err
	}
	*request = GenerationRequest{
		OriginalPrompt:   firstNonEmpty(decoded.OriginalPrompt, decoded.Prompt, decoded.UserPrompt),
		UserPrompt:       decoded.UserPrompt,
		ReferenceAssetID: firstUUID(decoded.ReferenceAssetID, decoded.ReferenceAssetIDSNAKE),
		VisualDNA:        firstVisualDNA(decoded.VisualDNA, decoded.VisualDNASNAKE),
		TemplateID:       firstUUIDValue(decoded.TemplateID, decoded.TemplateIDSNAKE),
		GenerationSettings: firstGenerationSettings(
			decoded.GenerationSettings,
			decoded.GenerationSNAKE,
		),
		ResolvedPrompt: decoded.ResolvedPrompt,
	}
	if decoded.Preservation != (PreservationSettings{}) {
		request.PreservationSettings = decoded.Preservation
	} else {
		request.PreservationSettings = decoded.PreservationSettings
	}
	return nil
}

func (request GenerationRequest) Validate() error {
	if strings.TrimSpace(request.Draft().Prompt) == "" {
		return fmt.Errorf("prompt is required")
	}
	if request.TemplateID == uuid.Nil {
		return fmt.Errorf("template id is required")
	}
	if request.VisualDNA != nil {
		if err := request.VisualDNA.Validate(); err != nil {
			return fmt.Errorf("visual DNA is invalid: %w", err)
		}
	}
	return nil
}

func firstNonEmpty(values ...string) string {
	for _, value := range values {
		if value != "" {
			return value
		}
	}
	return ""
}

func firstUUID(values ...*uuid.UUID) *uuid.UUID {
	for _, value := range values {
		if value != nil && *value != uuid.Nil {
			return value
		}
	}
	return nil
}

func firstUUIDValue(values ...uuid.UUID) uuid.UUID {
	for _, value := range values {
		if value != uuid.Nil {
			return value
		}
	}
	return uuid.Nil
}

func firstVisualDNA(values ...*VisualDNA) *VisualDNA {
	for _, value := range values {
		if value != nil {
			return value
		}
	}
	return nil
}

func firstGenerationSettings(values ...GenerationSettings) GenerationSettings {
	for _, value := range values {
		if value != (GenerationSettings{}) {
			return value
		}
	}
	return GenerationSettings{}
}

func (settings PreservationSettings) Any() bool {
	return settings.Style || settings.Lighting || settings.Color || settings.Colors ||
		settings.Composition || settings.Camera || settings.DepthOfField ||
		settings.Mood || settings.Texture || settings.Subject || settings.Background
}

func (settings PreservationSettings) IsEnabled(category string) bool {
	switch category {
	case "subject":
		return settings.Subject
	case "composition":
		return settings.Composition
	case "lighting":
		return settings.Lighting
	case "color_palette":
		return settings.Color || settings.Colors
	case "camera":
		return settings.Camera
	case "depth_of_field":
		return settings.DepthOfField
	case "style":
		return settings.Style
	case "mood":
		return settings.Mood
	case "background":
		return settings.Background
	case "texture":
		return settings.Texture
	default:
		return false
	}
}

func (settings PreservationSettings) MarshalJSON() ([]byte, error) {
	type wire struct {
		Subject      bool `json:"subject"`
		Composition  bool `json:"composition"`
		Lighting     bool `json:"lighting"`
		Color        bool `json:"color"`
		Camera       bool `json:"camera"`
		DepthOfField bool `json:"depth_of_field"`
		Style        bool `json:"style"`
		Mood         bool `json:"mood"`
		Background   bool `json:"background"`
		Texture      bool `json:"texture"`
	}
	return json.Marshal(wire{
		Subject:      settings.Subject,
		Composition:  settings.Composition,
		Lighting:     settings.Lighting,
		Color:        settings.Color || settings.Colors,
		Camera:       settings.Camera,
		DepthOfField: settings.DepthOfField,
		Style:        settings.Style,
		Mood:         settings.Mood,
		Background:   settings.Background,
		Texture:      settings.Texture,
	})
}

func (settings *PreservationSettings) UnmarshalJSON(data []byte) error {
	type wire struct {
		Subject      bool `json:"subject"`
		Composition  bool `json:"composition"`
		Lighting     bool `json:"lighting"`
		Color        bool `json:"color"`
		Colors       bool `json:"colors"`
		Camera       bool `json:"camera"`
		DepthOfField bool `json:"depth_of_field"`
		LegacyDepth  bool `json:"depthOfField"`
		Style        bool `json:"style"`
		Mood         bool `json:"mood"`
		Background   bool `json:"background"`
		Texture      bool `json:"texture"`
	}
	var decoded wire
	if err := json.Unmarshal(data, &decoded); err != nil {
		return err
	}
	*settings = PreservationSettings{
		Subject:      decoded.Subject,
		Composition:  decoded.Composition,
		Lighting:     decoded.Lighting,
		Color:        decoded.Color,
		Colors:       decoded.Colors,
		Camera:       decoded.Camera,
		DepthOfField: decoded.DepthOfField || decoded.LegacyDepth,
		Style:        decoded.Style,
		Mood:         decoded.Mood,
		Background:   decoded.Background,
		Texture:      decoded.Texture,
	}
	return nil
}
