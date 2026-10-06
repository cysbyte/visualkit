package models

import (
	"encoding/json"
	"testing"
)

func TestVisualDNARemainsStructuredWhenSerialized(t *testing.T) {
	input := VisualDNA{
		SchemaVersion: VisualDNASchemaVersion,
		Style: VisualDNACategory{
			Attributes:   []string{"cinematic"},
			Observations: []string{"Controlled contrast is visible."},
			Inferences:   []string{"Cinematic style"},
			Confidence:   0.92,
		},
		Lighting: VisualDNACategory{
			Attributes:   []string{"soft", "directional"},
			Observations: []string{"Soft light enters from one side."},
			Inferences:   []string{"Soft directional lighting"},
			Confidence:   0.88,
		},
		ColorPalette: VisualDNACategory{
			Attributes:   []string{"warm", "muted"},
			Observations: []string{"Warm, low-saturation colors dominate."},
			Inferences:   []string{"Warm muted palette"},
			Confidence:   0.84,
		},
	}
	input.Composition = VisualDNACategory{Attributes: []string{"centered"}}

	data, err := json.Marshal(input)
	if err != nil {
		t.Fatal(err)
	}

	var decoded VisualDNA
	if err := json.Unmarshal(data, &decoded); err != nil {
		t.Fatal(err)
	}
	if decoded.SchemaVersion != VisualDNASchemaVersion {
		t.Fatalf("schema version = %d, want %d", decoded.SchemaVersion, VisualDNASchemaVersion)
	}
	if len(decoded.Style.Attributes) != 1 || decoded.Style.Attributes[0] != "cinematic" {
		t.Fatalf("style = %#v, want structured style values", decoded.Style)
	}
	if len(decoded.ColorPalette.Attributes) != 2 {
		t.Fatalf("color palette = %#v, want two values", decoded.ColorPalette)
	}
}

func TestVisualDNAReadsLegacySavedStyle(t *testing.T) {
	var decoded VisualDNA
	if err := json.Unmarshal([]byte(`{
		"style": ["Cinematic"],
		"lighting": ["Soft Directional"],
		"colorPalette": ["Warm", "Muted"]
	}`), &decoded); err != nil {
		t.Fatal(err)
	}
	if decoded.SchemaVersion != VisualDNASchemaVersion {
		t.Fatalf("schema version = %d, want %d", decoded.SchemaVersion, VisualDNASchemaVersion)
	}
	if len(decoded.Style.Attributes) != 1 || decoded.Style.Attributes[0] != "Cinematic" {
		t.Fatalf("legacy style = %#v", decoded.Style)
	}
	if len(decoded.ColorPalette.Attributes) != 2 {
		t.Fatalf("legacy colors = %#v", decoded.ColorPalette)
	}
}

func TestVisualDNARejectsInvalidConfidence(t *testing.T) {
	visualDNA := MockVisualDNA()
	visualDNA.Style.Confidence = 1.1
	if err := visualDNA.Validate(); err == nil {
		t.Fatal("expected invalid confidence error")
	}
}
