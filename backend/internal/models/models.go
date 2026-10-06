package models

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID        uuid.UUID `json:"id"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

type ImageAsset struct {
	ID          uuid.UUID  `json:"id"`
	UserID      uuid.UUID  `json:"userId"`
	ObjectKey   string     `json:"objectKey"`
	Filename    string     `json:"filename"`
	MimeType    string     `json:"mimeType"`
	ByteSize    int64      `json:"byteSize"`
	PixelWidth  int        `json:"pixelWidth"`
	PixelHeight int        `json:"pixelHeight"`
	Status      string     `json:"status"`
	VisualDNA   *VisualDNA `json:"visualDNA,omitempty"`
	CreatedAt   time.Time  `json:"createdAt"`
	UpdatedAt   time.Time  `json:"updatedAt"`
}

const (
	ImageAssetStatusPending    = "pending"
	ImageAssetStatusUploaded   = "uploaded"
	ImageAssetStatusProcessing = "processing"
	ImageAssetStatusReady      = "ready"
	ImageAssetStatusFailed     = "failed"
	ImageAssetStatusDeleted    = "deleted"
)

type PreservationSettings struct {
	Style        bool `json:"style"`
	Lighting     bool `json:"lighting"`
	Color        bool `json:"color"`
	Composition  bool `json:"composition"`
	Camera       bool `json:"camera"`
	DepthOfField bool `json:"depth_of_field"`
	Mood         bool `json:"mood"`
	Texture      bool `json:"texture"`
	Subject      bool `json:"subject"`
	Background   bool `json:"background"`
	// Colors is retained for source compatibility with older clients and
	// server code. New JSON uses color.
	Colors bool `json:"-"`
}

type GenerationSettings struct {
	AspectRatio string `json:"aspectRatio"`
	Quality     string `json:"quality,omitempty"`
	Count       int    `json:"count,omitempty"`
}

func (settings *GenerationSettings) UnmarshalJSON(data []byte) error {
	type wire struct {
		AspectRatio      string `json:"aspectRatio"`
		AspectRatioSnake string `json:"aspect_ratio"`
		Quality          string `json:"quality"`
		Count            int    `json:"count"`
	}
	var decoded wire
	if err := json.Unmarshal(data, &decoded); err != nil {
		return err
	}
	settings.AspectRatio = decoded.AspectRatio
	if settings.AspectRatio == "" {
		settings.AspectRatio = decoded.AspectRatioSnake
	}
	settings.Quality = decoded.Quality
	settings.Count = decoded.Count
	return nil
}

type Template struct {
	ID               uuid.UUID          `json:"id"`
	Slug             string             `json:"slug"`
	Name             string             `json:"name"`
	Description      string             `json:"description"`
	Category         string             `json:"category"`
	PromptDirectives []string           `json:"prompt_directives,omitempty"`
	DefaultSettings  GenerationSettings `json:"default_settings"`
	PreviewAssetID   *uuid.UUID         `json:"preview_asset_id,omitempty"`
	IsActive         bool               `json:"is_active"`
	// Legacy fields are kept while older clients and migrations are upgraded.
	PromptInstructions     string             `json:"promptInstructions"`
	RecommendedAspectRatio string             `json:"recommendedAspectRatio"`
	GenerationSettings     GenerationSettings `json:"generationSettings"`
	ThumbnailURL           string             `json:"thumbnailUrl,omitempty"`
	CreatedAt              time.Time          `json:"createdAt"`
	UpdatedAt              time.Time          `json:"updatedAt"`
}

func (template Template) EffectivePromptDirectives() []string {
	if len(template.PromptDirectives) > 0 {
		return append([]string(nil), template.PromptDirectives...)
	}
	if template.PromptInstructions == "" {
		return nil
	}
	return []string{template.PromptInstructions}
}

func (template Template) EffectiveDefaultSettings() GenerationSettings {
	settings := template.DefaultSettings
	if settings == (GenerationSettings{}) {
		settings = template.GenerationSettings
	}
	if settings.AspectRatio == "" {
		settings.AspectRatio = template.RecommendedAspectRatio
	}
	return settings
}

type SavedStyle struct {
	ID             uuid.UUID  `json:"id"`
	UserID         uuid.UUID  `json:"userId"`
	Name           string     `json:"name"`
	PreviewAssetID *uuid.UUID `json:"previewAssetId,omitempty"`
	VisualDNA      VisualDNA  `json:"visualDNA"`
	CreatedAt      time.Time  `json:"createdAt"`
	UpdatedAt      time.Time  `json:"updatedAt"`
}

type SavedStyleResponse struct {
	ID              uuid.UUID  `json:"id"`
	Name            string     `json:"name"`
	PreviewAssetID  *uuid.UUID `json:"preview_asset_id,omitempty"`
	PreviewImageURL string     `json:"preview_image_url,omitempty"`
	VisualDNA       VisualDNA  `json:"visual_dna"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

type Creation struct {
	ID                   uuid.UUID            `json:"id"`
	UserID               uuid.UUID            `json:"userId"`
	ImageAssetID         *uuid.UUID           `json:"image_asset_id,omitempty"`
	GeneratedAssetID     *uuid.UUID           `json:"generatedAssetId,omitempty"`
	ThumbnailAssetID     *uuid.UUID           `json:"thumbnailAssetId,omitempty"`
	ReferenceAssetID     *uuid.UUID           `json:"referenceAssetId,omitempty"`
	Prompt               string               `json:"prompt"`
	OriginalPrompt       string               `json:"original_prompt,omitempty"`
	ResolvedPrompt       string               `json:"resolved_generation_prompt,omitempty"`
	Template             Template             `json:"template"`
	VisualDNA            *VisualDNA           `json:"visualDNA,omitempty"`
	PreservationSettings PreservationSettings `json:"preservationSettings"`
	GenerationSettings   GenerationSettings   `json:"generationSettings"`
	Status               string               `json:"status"`
	FailureMessage       string               `json:"failureMessage,omitempty"`
	CreatedAt            time.Time            `json:"createdAt"`
	UpdatedAt            time.Time            `json:"updatedAt"`
}

type CreationCursor struct {
	CreatedAt time.Time
	ID        uuid.UUID
}

type TemplateSummary struct {
	ID       uuid.UUID `json:"id"`
	Name     string    `json:"name"`
	Category string    `json:"category,omitempty"`
}

type CreationStyleSummary struct {
	Attributes map[string][]string `json:"attributes,omitempty"`
}

type CreationListItem struct {
	ID               uuid.UUID             `json:"id"`
	ImageAssetID     *uuid.UUID            `json:"image_asset_id,omitempty"`
	ThumbnailAssetID *uuid.UUID            `json:"thumbnail_asset_id,omitempty"`
	ImageURL         string                `json:"image_url,omitempty"`
	ThumbnailURL     string                `json:"thumbnail_url,omitempty"`
	Prompt           string                `json:"prompt"`
	Template         TemplateSummary       `json:"template"`
	Style            *CreationStyleSummary `json:"style,omitempty"`
	Status           string                `json:"status"`
	FailureMessage   string                `json:"failure_message,omitempty"`
	CreatedAt        time.Time             `json:"created_at"`
}

type CreationDetailResponse struct {
	ID                   uuid.UUID             `json:"id"`
	ImageAssetID         *uuid.UUID            `json:"image_asset_id,omitempty"`
	ThumbnailAssetID     *uuid.UUID            `json:"thumbnail_asset_id,omitempty"`
	ImageURL             string                `json:"image_url,omitempty"`
	ThumbnailURL         string                `json:"thumbnail_url,omitempty"`
	Prompt               string                `json:"prompt"`
	OriginalPrompt       string                `json:"original_prompt,omitempty"`
	ResolvedPrompt       string                `json:"resolved_generation_prompt,omitempty"`
	Template             Template              `json:"template"`
	Style                *CreationStyleSummary `json:"style,omitempty"`
	VisualDNA            *VisualDNA            `json:"visual_dna,omitempty"`
	PreservationSettings PreservationSettings  `json:"preservation_settings"`
	GenerationSettings   GenerationSettings    `json:"generation_settings"`
	ReferenceAssetID     *uuid.UUID            `json:"reference_asset_id,omitempty"`
	Status               string                `json:"status"`
	FailureMessage       string                `json:"failure_message,omitempty"`
	CreatedAt            time.Time             `json:"created_at"`
	UpdatedAt            time.Time             `json:"updated_at"`
}

func (creation Creation) OriginalPromptOrPrompt() string {
	if creation.OriginalPrompt != "" {
		return creation.OriginalPrompt
	}
	return creation.Prompt
}

type CreationPage struct {
	Items      []CreationListItem `json:"items"`
	NextCursor string             `json:"next_cursor,omitempty"`
	HasMore    bool               `json:"has_more"`
}

type Generation struct {
	ID         uuid.UUID         `json:"id"`
	UserID     uuid.UUID         `json:"userId"`
	CreationID *uuid.UUID        `json:"creationId,omitempty"`
	JobID      uuid.UUID         `json:"jobId"`
	Request    GenerationRequest `json:"request"`
	Status     string            `json:"status"`
	CreatedAt  time.Time         `json:"createdAt"`
	UpdatedAt  time.Time         `json:"updatedAt"`
}

type GenerationRequest struct {
	OriginalPrompt       string               `json:"original_prompt,omitempty"`
	UserPrompt           string               `json:"userPrompt,omitempty"`
	ReferenceAssetID     *uuid.UUID           `json:"referenceAssetId,omitempty"`
	VisualDNA            *VisualDNA           `json:"visualDNA,omitempty"`
	PreservationSettings PreservationSettings `json:"preservationSettings"`
	TemplateID           uuid.UUID            `json:"templateId"`
	GenerationSettings   GenerationSettings   `json:"generationSettings"`
	ResolvedPrompt       string               `json:"resolved_generation_prompt,omitempty"`
}

type Job struct {
	ID             uuid.UUID      `json:"id"`
	UserID         uuid.UUID      `json:"userId"`
	Type           string         `json:"type"`
	Kind           string         `json:"kind,omitempty"`
	Status         string         `json:"status"`
	Progress       int            `json:"progress,omitempty"`
	Input          map[string]any `json:"input,omitempty"`
	Output         map[string]any `json:"output,omitempty"`
	Request        map[string]any `json:"request,omitempty"`
	Result         map[string]any `json:"result,omitempty"`
	ErrorCode      string         `json:"errorCode,omitempty"`
	ErrorMessage   string         `json:"errorMessage,omitempty"`
	Attempts       int            `json:"attempts"`
	IdempotencyKey string         `json:"idempotencyKey,omitempty"`
	StartedAt      *time.Time     `json:"startedAt,omitempty"`
	CompletedAt    *time.Time     `json:"completedAt,omitempty"`
	CreatedAt      time.Time      `json:"createdAt"`
	UpdatedAt      time.Time      `json:"updatedAt"`
}

const (
	JobTypeImageAnalysis   = "image_analysis"
	JobTypeImageGeneration = "image_generation"

	JobStatusQueued     = "queued"
	JobStatusProcessing = "processing"
	JobStatusCompleted  = "completed"
	JobStatusFailed     = "failed"
	JobStatusCancelled  = "cancelled"
)

type CreditLedgerEntry struct {
	ID            uuid.UUID      `json:"id"`
	UserID        uuid.UUID      `json:"user_id"`
	Type          string         `json:"type"`
	Amount        int            `json:"amount"`
	ReferenceType string         `json:"reference_type,omitempty"`
	ReferenceID   *uuid.UUID     `json:"reference_id,omitempty"`
	Metadata      map[string]any `json:"metadata,omitempty"`
	// Reason remains for compatibility with older callers.
	Reason    string    `json:"reason,omitempty"`
	CreatedAt time.Time `json:"created_at"`
}

const (
	CreditLedgerTypeSubscriptionGrant = "subscription_grant"
	CreditLedgerTypePurchase          = "purchase"
	CreditLedgerTypeGeneration        = "generation"
	CreditLedgerTypeRefund            = "refund"
	CreditLedgerTypeAdjustment        = "adjustment"
)

const (
	CreditReservationStatusReserved = "reserved"
	CreditReservationStatusConsumed = "consumed"
	CreditReservationStatusRefunded = "refunded"
)
