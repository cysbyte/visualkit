package models

import (
	"bytes"
	"encoding/json"
	"fmt"
	"math"
	"strings"
)

const VisualDNASchemaVersion = 1

// VisualDNACategory keeps observable characteristics separate from model
// inferences so the result remains useful when reused by later generations.
type VisualDNACategory struct {
	Attributes   []string `json:"attributes"`
	Observations []string `json:"observations"`
	Inferences   []string `json:"inferences"`
	Confidence   float64  `json:"confidence"`
}

type VisualDNA struct {
	SchemaVersion int               `json:"schema_version"`
	Subject       VisualDNACategory `json:"subject"`
	Composition   VisualDNACategory `json:"composition"`
	Lighting      VisualDNACategory `json:"lighting"`
	ColorPalette  VisualDNACategory `json:"color_palette"`
	Camera        VisualDNACategory `json:"camera"`
	DepthOfField  VisualDNACategory `json:"depth_of_field"`
	Style         VisualDNACategory `json:"style"`
	Mood          VisualDNACategory `json:"mood"`
	Background    VisualDNACategory `json:"background"`
	Texture       VisualDNACategory `json:"texture"`
}

var visualDNACategoryNames = []string{
	"subject",
	"composition",
	"lighting",
	"color_palette",
	"camera",
	"depth_of_field",
	"style",
	"mood",
	"background",
	"texture",
}

func (category VisualDNACategory) Validate(path string) error {
	if len(category.Attributes) > 20 || len(category.Observations) > 20 || len(category.Inferences) > 20 {
		return fmt.Errorf("%s contains too many values", path)
	}
	for field, values := range map[string][]string{
		"attributes":   category.Attributes,
		"observations": category.Observations,
		"inferences":   category.Inferences,
	} {
		for index, value := range values {
			value = strings.TrimSpace(value)
			if value == "" {
				return fmt.Errorf("%s.%s[%d] is empty", path, field, index)
			}
			if len(value) > 500 {
				return fmt.Errorf("%s.%s[%d] is too long", path, field, index)
			}
		}
	}
	if math.IsNaN(category.Confidence) || math.IsInf(category.Confidence, 0) ||
		category.Confidence < 0 || category.Confidence > 1 {
		return fmt.Errorf("%s.confidence must be between 0 and 1", path)
	}
	return nil
}

func (visualDNA VisualDNA) Validate() error {
	if visualDNA.SchemaVersion != VisualDNASchemaVersion {
		return fmt.Errorf("unsupported Visual DNA schema version %d", visualDNA.SchemaVersion)
	}
	categories := map[string]VisualDNACategory{
		"subject":        visualDNA.Subject,
		"composition":    visualDNA.Composition,
		"lighting":       visualDNA.Lighting,
		"color_palette":  visualDNA.ColorPalette,
		"camera":         visualDNA.Camera,
		"depth_of_field": visualDNA.DepthOfField,
		"style":          visualDNA.Style,
		"mood":           visualDNA.Mood,
		"background":     visualDNA.Background,
		"texture":        visualDNA.Texture,
	}
	for _, name := range visualDNACategoryNames {
		if err := categories[name].Validate(name); err != nil {
			return err
		}
	}
	return nil
}

func (visualDNA VisualDNA) Preserved(settings PreservationSettings) VisualDNA {
	preserved := VisualDNA{SchemaVersion: visualDNA.SchemaVersion}
	if preserved.SchemaVersion == 0 {
		preserved.SchemaVersion = VisualDNASchemaVersion
	}
	for category, enabled := range map[string]bool{
		"subject":        settings.Subject,
		"composition":    settings.Composition,
		"lighting":       settings.Lighting,
		"color_palette":  settings.Color || settings.Colors,
		"camera":         settings.Camera,
		"depth_of_field": settings.DepthOfField,
		"style":          settings.Style,
		"mood":           settings.Mood,
		"background":     settings.Background,
		"texture":        settings.Texture,
	} {
		if !enabled {
			continue
		}
		switch category {
		case "subject":
			preserved.Subject = visualDNA.Subject
		case "composition":
			preserved.Composition = visualDNA.Composition
		case "lighting":
			preserved.Lighting = visualDNA.Lighting
		case "color_palette":
			preserved.ColorPalette = visualDNA.ColorPalette
		case "camera":
			preserved.Camera = visualDNA.Camera
		case "depth_of_field":
			preserved.DepthOfField = visualDNA.DepthOfField
		case "style":
			preserved.Style = visualDNA.Style
		case "mood":
			preserved.Mood = visualDNA.Mood
		case "background":
			preserved.Background = visualDNA.Background
		case "texture":
			preserved.Texture = visualDNA.Texture
		}
	}
	return preserved
}

func (visualDNA *VisualDNA) UnmarshalJSON(data []byte) error {
	if visualDNA == nil {
		return fmt.Errorf("Visual DNA target is nil")
	}

	var fields map[string]json.RawMessage
	if err := json.Unmarshal(data, &fields); err != nil {
		return fmt.Errorf("decode Visual DNA object: %w", err)
	}
	if fields == nil {
		return fmt.Errorf("Visual DNA must be an object")
	}

	if isStructuredVisualDNA(fields) {
		decoded, err := decodeStructuredVisualDNA(fields)
		if err != nil {
			return err
		}
		*visualDNA = decoded
		return nil
	}

	// Saved styles created before schema versioning used arrays and camelCase
	// keys. Decode them into the stable schema instead of breaking old data.
	legacy := legacyVisualDNA{}
	encoded, err := json.Marshal(fields)
	if err != nil {
		return fmt.Errorf("encode legacy Visual DNA: %w", err)
	}
	if err := json.Unmarshal(encoded, &legacy); err != nil {
		return fmt.Errorf("decode legacy Visual DNA: %w", err)
	}
	*visualDNA = VisualDNA{
		SchemaVersion: VisualDNASchemaVersion,
		Subject:       legacyCategory(legacy.Subject),
		Composition:   legacyCategory(legacy.Composition),
		Lighting:      legacyCategory(legacy.Lighting),
		ColorPalette:  legacyCategory(legacy.ColorPalette),
		Camera:        legacyCategory(legacy.Camera),
		DepthOfField:  legacyCategory(legacy.DepthOfField),
		Style:         legacyCategory(legacy.Style),
		Mood:          legacyCategory(legacy.Mood),
		Background:    legacyCategory(legacy.Background),
		Texture:       legacyCategory(legacy.Texture),
	}
	return visualDNA.Validate()
}

func isStructuredVisualDNA(fields map[string]json.RawMessage) bool {
	if _, ok := fields["schema_version"]; ok {
		return true
	}
	for _, name := range visualDNACategoryNames {
		raw, ok := fields[name]
		if ok && len(bytes.TrimSpace(raw)) > 0 && bytes.HasPrefix(bytes.TrimSpace(raw), []byte("{")) {
			return true
		}
	}
	return false
}

func decodeStructuredVisualDNA(fields map[string]json.RawMessage) (VisualDNA, error) {
	allowed := map[string]bool{"schema_version": true}
	for _, name := range visualDNACategoryNames {
		allowed[name] = true
	}
	for key := range fields {
		if !allowed[key] {
			return VisualDNA{}, fmt.Errorf("unsupported Visual DNA field %q", key)
		}
	}

	version := VisualDNASchemaVersion
	if raw, ok := fields["schema_version"]; ok {
		if err := json.Unmarshal(raw, &version); err != nil {
			return VisualDNA{}, fmt.Errorf("decode schema_version: %w", err)
		}
	}
	if version != VisualDNASchemaVersion {
		return VisualDNA{}, fmt.Errorf("unsupported Visual DNA schema version %d", version)
	}

	decoded := VisualDNA{SchemaVersion: version}
	for _, name := range visualDNACategoryNames {
		raw, ok := fields[name]
		if !ok || bytes.Equal(bytes.TrimSpace(raw), []byte("null")) {
			return VisualDNA{}, fmt.Errorf("Visual DNA category %q is required", name)
		}
		category, err := decodeVisualDNACategory(name, raw)
		if err != nil {
			return VisualDNA{}, err
		}
		switch name {
		case "subject":
			decoded.Subject = category
		case "composition":
			decoded.Composition = category
		case "lighting":
			decoded.Lighting = category
		case "color_palette":
			decoded.ColorPalette = category
		case "camera":
			decoded.Camera = category
		case "depth_of_field":
			decoded.DepthOfField = category
		case "style":
			decoded.Style = category
		case "mood":
			decoded.Mood = category
		case "background":
			decoded.Background = category
		case "texture":
			decoded.Texture = category
		}
	}
	return decoded, decoded.Validate()
}

func decodeVisualDNACategory(name string, raw []byte) (VisualDNACategory, error) {
	var fields map[string]json.RawMessage
	if err := json.Unmarshal(raw, &fields); err != nil {
		return VisualDNACategory{}, fmt.Errorf("decode Visual DNA category %q: %w", name, err)
	}
	allowed := map[string]bool{
		"attributes": true, "observations": true, "inferences": true, "confidence": true,
	}
	for key := range fields {
		if !allowed[key] {
			return VisualDNACategory{}, fmt.Errorf("unsupported Visual DNA field %q.%s", name, key)
		}
	}
	var category VisualDNACategory
	if raw, ok := fields["attributes"]; ok {
		if err := json.Unmarshal(raw, &category.Attributes); err != nil {
			return VisualDNACategory{}, fmt.Errorf("decode %s.attributes: %w", name, err)
		}
	}
	if raw, ok := fields["observations"]; ok {
		if err := json.Unmarshal(raw, &category.Observations); err != nil {
			return VisualDNACategory{}, fmt.Errorf("decode %s.observations: %w", name, err)
		}
	}
	if raw, ok := fields["inferences"]; ok {
		if err := json.Unmarshal(raw, &category.Inferences); err != nil {
			return VisualDNACategory{}, fmt.Errorf("decode %s.inferences: %w", name, err)
		}
	}
	if raw, ok := fields["confidence"]; ok {
		if err := json.Unmarshal(raw, &category.Confidence); err != nil {
			return VisualDNACategory{}, fmt.Errorf("decode %s.confidence: %w", name, err)
		}
	}
	if err := category.Validate(name); err != nil {
		return VisualDNACategory{}, err
	}
	return category, nil
}

type legacyVisualDNA struct {
	Subject      []string `json:"subject"`
	Composition  []string `json:"composition"`
	Lighting     []string `json:"lighting"`
	ColorPalette []string `json:"colorPalette"`
	Camera       []string `json:"camera"`
	DepthOfField []string `json:"depthOfField"`
	Style        []string `json:"style"`
	Mood         []string `json:"mood"`
	Background   []string `json:"background"`
	Texture      []string `json:"texture"`
}

func legacyCategory(values []string) VisualDNACategory {
	return VisualDNACategory{
		Attributes: cleanStrings(values),
		Confidence: 0,
	}
}

func cleanStrings(values []string) []string {
	cleaned := make([]string, 0, len(values))
	for _, value := range values {
		if value = strings.TrimSpace(value); value != "" {
			cleaned = append(cleaned, value)
		}
	}
	return cleaned
}

func MockVisualDNA() VisualDNA {
	return VisualDNA{
		SchemaVersion: VisualDNASchemaVersion,
		Subject: VisualDNACategory{
			Attributes:   []string{"portrait subject"},
			Observations: []string{"A primary human subject is framed prominently."},
			Inferences:   []string{"Portrait-oriented reference"},
			Confidence:   0.82,
		},
		Composition: VisualDNACategory{
			Attributes:   []string{"centered", "portrait"},
			Observations: []string{"The subject occupies the central frame with balanced negative space."},
			Inferences:   []string{"Editorial portrait composition"},
			Confidence:   0.86,
		},
		Lighting: VisualDNACategory{
			Attributes:   []string{"soft", "warm", "directional"},
			Observations: []string{"Warm directional light creates soft highlights and gentle shadow falloff."},
			Inferences:   []string{"Golden-hour cinematic lighting"},
			Confidence:   0.88,
		},
		ColorPalette: VisualDNACategory{
			Attributes:   []string{"warm", "muted"},
			Observations: []string{"The image uses restrained warm tones with low saturation."},
			Inferences:   []string{"Warm film-inspired palette"},
			Confidence:   0.84,
		},
		Camera: VisualDNACategory{
			Attributes:   []string{"35mm look"},
			Observations: []string{"Perspective appears natural with mild environmental context."},
			Inferences:   []string{"35mm editorial camera feel"},
			Confidence:   0.72,
		},
		DepthOfField: VisualDNACategory{
			Attributes:   []string{"shallow"},
			Observations: []string{"Background detail is softened behind the subject."},
			Inferences:   []string{"Subject-isolating shallow depth of field"},
			Confidence:   0.8,
		},
		Style: VisualDNACategory{
			Attributes:   []string{"cinematic", "editorial"},
			Observations: []string{"The frame uses polished contrast and intentional art direction."},
			Inferences:   []string{"Cinematic editorial style"},
			Confidence:   0.92,
		},
		Mood: VisualDNACategory{
			Attributes:   []string{"nostalgic", "premium"},
			Observations: []string{"Warm tones and restrained contrast create a calm, refined feel."},
			Inferences:   []string{"Premium nostalgic mood"},
			Confidence:   0.78,
		},
		Background: VisualDNACategory{
			Attributes:   []string{"soft", "unobtrusive"},
			Observations: []string{"The background supports the subject without competing for attention."},
			Inferences:   []string{"Minimal editorial background treatment"},
			Confidence:   0.76,
		},
		Texture: VisualDNACategory{
			Attributes:   []string{"subtle film grain"},
			Observations: []string{"Fine texture is visible without obscuring detail."},
			Inferences:   []string{"Film-inspired texture"},
			Confidence:   0.7,
		},
	}
}
