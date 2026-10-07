package services

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"path/filepath"
	"reflect"
	"sort"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/storage"
	"github.com/visualkit/backend/pkg/api"
)

type Set struct {
	Users       repositories.UserRepository
	Assets      repositories.ImageAssetRepository
	Templates   repositories.TemplateRepository
	Styles      repositories.SavedStyleRepository
	Jobs        repositories.JobRepository
	Creations   repositories.CreationRepository
	Generations repositories.GenerationRepository
	Credits     repositories.CreditRepository
	Queue       queue.JobQueue
	Storage     storage.ObjectStorage
	Config      config.Config
}

func NewSet(
	repositorySet repositories.Set,
	configuration config.Config,
	objectStorage storage.ObjectStorage,
	jobQueue ...queue.JobQueue,
) Set {
	var configuredStorage storage.ObjectStorage
	configuredStorage = objectStorage
	if configuredStorage == nil {
		configuredStorage = storage.NewMockObjectStorage()
	}
	var configuredQueue queue.JobQueue = queue.NewMemoryPublisher()
	if len(jobQueue) > 0 && jobQueue[0] != nil {
		configuredQueue = jobQueue[0]
	}
	return Set{
		Users:  repositorySet.Users,
		Assets: repositorySet.Assets,
		Templates: TemplateService{
			Templates: repositorySet.Templates,
			Storage:   configuredStorage,
			Config:    configuration,
		},
		Styles:      repositorySet.Styles,
		Jobs:        repositorySet.Jobs,
		Creations:   repositorySet.Creations,
		Generations: repositorySet.Generations,
		Credits:     repositorySet.Credits,
		Queue:       configuredQueue,
		Storage:     configuredStorage,
		Config:      configuration,
	}
}

type AssetService struct {
	Users   repositories.UserRepository
	Assets  repositories.ImageAssetRepository
	Storage storage.ObjectStorage
	Config  config.Config
}

var allowedImageTypes = map[string]struct{}{
	"image/jpeg": {},
	"image/png":  {},
	"image/heic": {},
	"image/heif": {},
	"image/webp": {},
}

type CreateAssetUploadInput struct {
	Filename    string `json:"filename"`
	ContentType string `json:"content_type"`
	SizeBytes   int64  `json:"size_bytes"`
}

type AssetUploadURL struct {
	AssetID   uuid.UUID `json:"asset_id"`
	UploadURL string    `json:"upload_url"`
	ObjectKey string    `json:"object_key"`
	ExpiresIn int       `json:"expires_in"`
}

type CompleteAssetUploadInput struct {
	ObjectKey   string `json:"object_key"`
	SizeBytes   *int64 `json:"size_bytes,omitempty"`
	ContentType string `json:"content_type,omitempty"`
	PixelWidth  int    `json:"pixel_width,omitempty"`
	PixelHeight int    `json:"pixel_height,omitempty"`
}

type AssetDownloadURL struct {
	AssetID     uuid.UUID `json:"asset_id"`
	DownloadURL string    `json:"download_url"`
	ExpiresIn   int       `json:"expires_in"`
}

func (service AssetService) CreateUploadURL(
	ctx context.Context,
	userID uuid.UUID,
	input CreateAssetUploadInput,
) (AssetUploadURL, error) {
	if err := validateUserID(userID); err != nil {
		return AssetUploadURL{}, api.ErrUnauthorized
	}
	filename := strings.TrimSpace(input.Filename)
	contentType, err := normalizeImageContentType(input.ContentType)
	if err != nil {
		return AssetUploadURL{}, err
	}
	if filename == "" {
		return AssetUploadURL{}, fmt.Errorf("invalid request: filename is required: %w", api.ErrInvalidRequest)
	}
	if err := validateImageFilename(filename, contentType); err != nil {
		return AssetUploadURL{}, err
	}
	if input.SizeBytes <= 0 {
		return AssetUploadURL{}, fmt.Errorf("invalid request: size_bytes must be greater than zero: %w", api.ErrInvalidRequest)
	}
	if service.Config.S3MaxAssetBytes > 0 && input.SizeBytes > service.Config.S3MaxAssetBytes {
		return AssetUploadURL{}, fmt.Errorf("invalid request: file exceeds the maximum allowed size: %w", api.ErrInvalidRequest)
	}
	if service.Storage == nil {
		return AssetUploadURL{}, api.ErrUnavailable
	}
	if _, err := service.Users.Ensure(ctx, userID); err != nil {
		return AssetUploadURL{}, err
	}

	assetID := uuid.New()
	objectKey := fmt.Sprintf("users/%s/assets/%s/original", userID, assetID)
	upload, err := service.Storage.CreateUploadURL(ctx, storage.UploadInput{
		ObjectKey: objectKey,
		MimeType:  contentType,
		ByteSize:  input.SizeBytes,
		ExpiresIn: service.Config.S3UploadURLTTL,
	})
	if err != nil {
		return AssetUploadURL{}, fmt.Errorf("create upload URL: %w", err)
	}
	if upload.ObjectKey != "" && upload.ObjectKey != objectKey {
		return AssetUploadURL{}, fmt.Errorf("storage returned an unexpected object key: %w", api.ErrUnavailable)
	}

	_, err = service.Assets.Create(ctx, models.ImageAsset{
		ID:        assetID,
		UserID:    userID,
		ObjectKey: objectKey,
		Filename:  filename,
		MimeType:  contentType,
		ByteSize:  input.SizeBytes,
		Status:    models.ImageAssetStatusPending,
	})
	if err != nil {
		return AssetUploadURL{}, err
	}
	return AssetUploadURL{
		AssetID:   assetID,
		UploadURL: upload.UploadURL,
		ObjectKey: objectKey,
		ExpiresIn: upload.ExpiresIn,
	}, nil
}

func (service AssetService) CompleteUpload(
	ctx context.Context,
	userID, assetID uuid.UUID,
	input CompleteAssetUploadInput,
) (models.ImageAsset, error) {
	if err := validateUserID(userID); err != nil {
		return models.ImageAsset{}, api.ErrUnauthorized
	}
	if assetID == uuid.Nil {
		return models.ImageAsset{}, fmt.Errorf("invalid request: asset id is required: %w", api.ErrInvalidRequest)
	}
	if strings.TrimSpace(input.ObjectKey) == "" {
		return models.ImageAsset{}, fmt.Errorf("invalid request: object_key is required: %w", api.ErrInvalidRequest)
	}
	asset, err := service.Assets.Get(ctx, userID, assetID)
	if err != nil {
		return models.ImageAsset{}, err
	}
	if input.ObjectKey != asset.ObjectKey {
		return models.ImageAsset{}, fmt.Errorf("invalid request: object_key does not match the asset: %w", api.ErrInvalidRequest)
	}
	if asset.Status == models.ImageAssetStatusReady {
		return asset, nil
	}
	if asset.Status != models.ImageAssetStatusPending &&
		asset.Status != models.ImageAssetStatusUploaded {
		return models.ImageAsset{}, fmt.Errorf("invalid request: asset cannot be completed from its current status: %w", api.ErrInvalidRequest)
	}
	if input.SizeBytes != nil && *input.SizeBytes != asset.ByteSize {
		return models.ImageAsset{}, fmt.Errorf("invalid request: uploaded size does not match the expected size: %w", api.ErrInvalidRequest)
	}
	if input.ContentType != "" {
		contentType, normalizeErr := normalizeImageContentType(input.ContentType)
		if normalizeErr != nil {
			return models.ImageAsset{}, normalizeErr
		}
		if contentType != asset.MimeType {
			return models.ImageAsset{}, fmt.Errorf("invalid request: uploaded content type does not match the expected type: %w", api.ErrInvalidRequest)
		}
	}
	if input.PixelWidth < 0 || input.PixelHeight < 0 {
		return models.ImageAsset{}, fmt.Errorf("invalid request: image dimensions cannot be negative: %w", api.ErrInvalidRequest)
	}

	if service.Config.S3VerifyObjectOnComplete {
		if service.Storage == nil {
			return models.ImageAsset{}, api.ErrUnavailable
		}
		object, headErr := service.Storage.HeadObject(ctx, asset.ObjectKey)
		if headErr != nil {
			if errors.Is(headErr, storage.ErrObjectNotFound) {
				return models.ImageAsset{}, fmt.Errorf("invalid request: uploaded object was not found: %w", api.ErrInvalidRequest)
			}
			return models.ImageAsset{}, fmt.Errorf("verify uploaded object: %w", headErr)
		}
		if object.SizeBytes != asset.ByteSize {
			return models.ImageAsset{}, fmt.Errorf("invalid request: uploaded object size does not match the expected size: %w", api.ErrInvalidRequest)
		}
		if object.ContentType != "" && object.ContentType != asset.MimeType {
			return models.ImageAsset{}, fmt.Errorf("invalid request: uploaded object content type does not match the expected type: %w", api.ErrInvalidRequest)
		}
	}

	asset.PixelWidth = input.PixelWidth
	asset.PixelHeight = input.PixelHeight
	asset.Status = models.ImageAssetStatusReady
	return service.Assets.Update(ctx, asset)
}

func (service AssetService) CreateDownloadURL(
	ctx context.Context,
	userID, assetID uuid.UUID,
) (AssetDownloadURL, error) {
	if err := validateUserID(userID); err != nil {
		return AssetDownloadURL{}, api.ErrUnauthorized
	}
	if assetID == uuid.Nil {
		return AssetDownloadURL{}, fmt.Errorf("invalid request: asset id is required: %w", api.ErrInvalidRequest)
	}
	asset, err := service.Assets.Get(ctx, userID, assetID)
	if err != nil {
		return AssetDownloadURL{}, err
	}
	if asset.Status == models.ImageAssetStatusDeleted {
		return AssetDownloadURL{}, fmt.Errorf("invalid request: asset is deleted: %w", api.ErrInvalidRequest)
	}
	if asset.Status != models.ImageAssetStatusReady {
		return AssetDownloadURL{}, fmt.Errorf("invalid request: asset is not ready: %w", api.ErrInvalidRequest)
	}
	if service.Storage == nil {
		return AssetDownloadURL{}, api.ErrUnavailable
	}
	url, err := service.Storage.CreateDownloadURL(ctx, asset.ObjectKey, service.Config.S3DownloadURLTTL)
	if err != nil {
		return AssetDownloadURL{}, fmt.Errorf("create download URL: %w", err)
	}
	return AssetDownloadURL{
		AssetID:     asset.ID,
		DownloadURL: url,
		ExpiresIn:   durationSeconds(service.Config.S3DownloadURLTTL),
	}, nil
}

func normalizeImageContentType(value string) (string, error) {
	contentType := strings.ToLower(strings.TrimSpace(value))
	if index := strings.IndexByte(contentType, ';'); index >= 0 {
		contentType = strings.TrimSpace(contentType[:index])
	}
	if _, ok := allowedImageTypes[contentType]; !ok {
		return "", fmt.Errorf("invalid request: unsupported image content type: %w", api.ErrInvalidRequest)
	}
	return contentType, nil
}

func validateImageFilename(filename, contentType string) error {
	extension := strings.ToLower(filepath.Ext(filename))
	if extension == "" {
		return nil
	}
	allowedExtensions := map[string]map[string]struct{}{
		"image/jpeg": {".jpg": {}, ".jpeg": {}},
		"image/png":  {".png": {}},
		"image/heic": {".heic": {}},
		"image/heif": {".heif": {}},
		"image/webp": {".webp": {}},
	}
	if _, ok := allowedExtensions[contentType][extension]; !ok {
		return fmt.Errorf("invalid request: filename extension does not match the image content type: %w", api.ErrInvalidRequest)
	}
	return nil
}

func durationSeconds(value time.Duration) int {
	if value <= 0 {
		return 0
	}
	return int(value / time.Second)
}

func (service AssetService) Create(ctx context.Context, userID uuid.UUID, input CreateAssetInput) (models.ImageAsset, error) {
	if err := validateUserID(userID); err != nil {
		return models.ImageAsset{}, err
	}
	filename := strings.TrimSpace(input.Filename)
	if filename == "" {
		return models.ImageAsset{}, fmt.Errorf("invalid request: filename is required: %w", api.ErrInvalidRequest)
	}
	mimeType, err := normalizeImageContentType(input.MimeType)
	if err != nil {
		return models.ImageAsset{}, err
	}
	if err := validateImageFilename(filename, mimeType); err != nil {
		return models.ImageAsset{}, err
	}
	if input.ByteSize <= 0 || input.PixelWidth < 0 || input.PixelHeight < 0 {
		return models.ImageAsset{}, fmt.Errorf("invalid request: image dimensions cannot be negative and byteSize must be greater than zero: %w", api.ErrInvalidRequest)
	}
	if service.Config.S3MaxAssetBytes > 0 && input.ByteSize > service.Config.S3MaxAssetBytes {
		return models.ImageAsset{}, fmt.Errorf("invalid request: file exceeds the maximum allowed size: %w", api.ErrInvalidRequest)
	}
	if _, err := service.Users.Ensure(ctx, userID); err != nil {
		return models.ImageAsset{}, err
	}
	assetID := uuid.New()
	asset := models.ImageAsset{
		ID:          assetID,
		UserID:      userID,
		ObjectKey:   fmt.Sprintf("users/%s/assets/%s/original", userID, assetID),
		Filename:    filename,
		MimeType:    mimeType,
		ByteSize:    input.ByteSize,
		PixelWidth:  input.PixelWidth,
		PixelHeight: input.PixelHeight,
		Status:      models.ImageAssetStatusPending,
	}
	return service.Assets.Create(ctx, asset)
}

type CreateAssetInput struct {
	ObjectKey   string `json:"objectKey"`
	Filename    string `json:"filename"`
	MimeType    string `json:"mimeType"`
	ByteSize    int64  `json:"byteSize"`
	PixelWidth  int    `json:"pixelWidth"`
	PixelHeight int    `json:"pixelHeight"`
}

type JobService struct {
	Users                repositories.UserRepository
	Assets               repositories.ImageAssetRepository
	Jobs                 repositories.JobRepository
	Generations          repositories.GenerationRepository
	Templates            repositories.TemplateRepository
	Credits              repositories.CreditRepository
	GenerationCreditCost int
	Queue                queue.JobQueue
}

type JobStatusUpdate struct {
	Status       string         `json:"status"`
	Progress     int            `json:"progress"`
	ErrorCode    string         `json:"errorCode,omitempty"`
	ErrorMessage string         `json:"errorMessage,omitempty"`
	Output       map[string]any `json:"output,omitempty"`
	Result       map[string]any `json:"result,omitempty"`
}

type CreateAnalysisInput struct {
	AssetID          uuid.UUID `json:"asset_id"`
	ReferenceAssetID uuid.UUID `json:"referenceAssetId,omitempty"`
}

type CreateGenerationInput struct {
	Prompt                string                      `json:"prompt,omitempty"`
	UserPrompt            string                      `json:"userPrompt,omitempty"`
	ReferenceAssetID      *uuid.UUID                  `json:"referenceAssetId,omitempty"`
	ReferenceAssetIDSNAKE *uuid.UUID                  `json:"reference_asset_id,omitempty"`
	VisualDNA             *models.VisualDNA           `json:"visualDNA,omitempty"`
	VisualDNASNAKE        *models.VisualDNA           `json:"visual_dna,omitempty"`
	PreservationSettings  models.PreservationSettings `json:"preservationSettings"`
	Preservation          models.PreservationSettings `json:"preservation"`
	TemplateID            uuid.UUID                   `json:"templateId"`
	TemplateIDSNAKE       uuid.UUID                   `json:"template_id"`
	GenerationSettings    models.GenerationSettings   `json:"generationSettings"`
	GenerationSNAKE       models.GenerationSettings   `json:"generation_settings"`
	AspectRatio           string                      `json:"aspect_ratio,omitempty"`
}

type JobReference struct {
	JobID  uuid.UUID `json:"job_id"`
	Status string    `json:"status"`
	Type   string    `json:"type"`
}

const (
	JobErrorCodeQueueUnavailable = "QUEUE_UNAVAILABLE"
	JobErrorCodeQueueEnqueue     = "QUEUE_ENQUEUE_FAILED"
	JobErrorCodeInsufficient     = "INSUFFICIENT_CREDITS"
	JobErrorCodeCancelled        = "CANCELLED"
	JobErrorCodeRetryable        = "RETRYABLE"
	JobErrorCodePermanent        = "PERMANENT"
)

func (service JobService) CreateAnalysisJob(
	ctx context.Context,
	userID uuid.UUID,
	input CreateAnalysisInput,
	idempotencyKey string,
) (models.Job, error) {
	assetID := input.AssetID
	if assetID == uuid.Nil {
		assetID = input.ReferenceAssetID
	}
	if assetID == uuid.Nil {
		return models.Job{}, fmt.Errorf("invalid request: asset_id is required: %w", api.ErrInvalidRequest)
	}
	if service.Assets != nil {
		asset, err := service.Assets.Get(ctx, userID, assetID)
		if err != nil {
			return models.Job{}, err
		}
		if asset.Status != models.ImageAssetStatusReady {
			return models.Job{}, fmt.Errorf("invalid request: reference asset is not ready: %w", api.ErrInvalidRequest)
		}
	}
	job, _, err := service.createOrReuse(ctx, userID, models.JobTypeImageAnalysis,
		map[string]any{"asset_id": assetID.String()},
		idempotencyKey, nil)
	return job, err
}

func (service JobService) CreateGenerationJob(
	ctx context.Context,
	userID uuid.UUID,
	input CreateGenerationInput,
	idempotencyKey string,
) (models.Job, error) {
	prompt := firstNonEmpty(input.Prompt, input.UserPrompt)
	templateID := firstUUIDValue(input.TemplateID, input.TemplateIDSNAKE)
	referenceAssetID := firstUUID(input.ReferenceAssetID, input.ReferenceAssetIDSNAKE)
	visualDNA := firstVisualDNA(input.VisualDNA, input.VisualDNASNAKE)
	preservation := input.PreservationSettings
	if preservation == (models.PreservationSettings{}) {
		preservation = input.Preservation
	}
	generationSettings := firstGenerationSettings(input.GenerationSettings, input.GenerationSNAKE)
	if generationSettings.AspectRatio == "" {
		generationSettings.AspectRatio = input.AspectRatio
	}
	if strings.TrimSpace(prompt) == "" {
		return models.Job{}, fmt.Errorf("invalid request: userPrompt is required: %w", api.ErrInvalidRequest)
	}
	if templateID == uuid.Nil {
		return models.Job{}, fmt.Errorf("invalid request: templateId is required: %w", api.ErrInvalidRequest)
	}
	if visualDNA != nil {
		if err := visualDNA.Validate(); err != nil {
			return models.Job{}, fmt.Errorf("invalid request: visualDNA is invalid: %w", api.ErrInvalidRequest)
		}
	}
	if service.Templates == nil {
		return models.Job{}, api.ErrUnavailable
	}
	template, err := service.Templates.Get(ctx, templateID)
	if err != nil {
		return models.Job{}, err
	}
	generationSettings = mergeGenerationSettings(template.EffectiveDefaultSettings(), generationSettings)
	if strings.TrimSpace(generationSettings.AspectRatio) == "" {
		return models.Job{}, fmt.Errorf("invalid request: generationSettings.aspectRatio is required: %w", api.ErrInvalidRequest)
	}
	if referenceAssetID != nil && *referenceAssetID != uuid.Nil && service.Assets != nil {
		asset, err := service.Assets.Get(ctx, userID, *referenceAssetID)
		if err != nil {
			return models.Job{}, err
		}
		if asset.Status != models.ImageAssetStatusReady {
			return models.Job{}, fmt.Errorf("invalid request: reference asset is not ready: %w", api.ErrInvalidRequest)
		}
	}
	if service.Credits == nil {
		return models.Job{}, api.ErrUnavailable
	}

	request := models.GenerationRequest{
		OriginalPrompt:       prompt,
		UserPrompt:           prompt,
		ReferenceAssetID:     referenceAssetID,
		VisualDNA:            visualDNA,
		PreservationSettings: preservation,
		TemplateID:           templateID,
		GenerationSettings:   generationSettings,
	}
	payload, err := structToMap(request)
	if err != nil {
		return models.Job{}, err
	}
	job, _, err := service.createOrReuse(ctx, userID, models.JobTypeImageGeneration, payload, idempotencyKey,
		func(job models.Job) error {
			if err := service.Credits.Reserve(
				ctx,
				userID,
				models.JobTypeImageGeneration,
				job.ID,
				service.generationCost(),
			); err != nil {
				return err
			}
			if service.Generations != nil {
				if _, err := service.Generations.Create(ctx, models.Generation{
					UserID:  userID,
					JobID:   job.ID,
					Request: request,
					Status:  job.Status,
				}); err != nil {
					return err
				}
			}
			return nil
		})
	if err != nil {
		return models.Job{}, err
	}
	return job, nil
}

func (service JobService) CreateAnalysis(
	ctx context.Context,
	userID uuid.UUID,
	input CreateAnalysisInput,
) (models.Job, error) {
	return service.CreateAnalysisJob(ctx, userID, input, "")
}

func (service JobService) CreateGeneration(
	ctx context.Context,
	userID uuid.UUID,
	input CreateGenerationInput,
) (models.Job, error) {
	return service.CreateGenerationJob(ctx, userID, input, "")
}

func (service JobService) GetJob(ctx context.Context, userID, jobID uuid.UUID) (models.Job, error) {
	if jobID == uuid.Nil {
		return models.Job{}, fmt.Errorf("invalid request: job id is required: %w", api.ErrInvalidRequest)
	}
	return service.Jobs.Get(ctx, userID, jobID)
}

func (service JobService) LoadJob(ctx context.Context, jobID uuid.UUID) (models.Job, error) {
	if jobID == uuid.Nil {
		return models.Job{}, fmt.Errorf("invalid request: job id is required: %w", api.ErrInvalidRequest)
	}
	return service.Jobs.GetByID(ctx, jobID)
}

func (service JobService) ClaimProcessing(ctx context.Context, jobID uuid.UUID, attempt int) (models.Job, bool, error) {
	if jobID == uuid.Nil {
		return models.Job{}, false, fmt.Errorf("invalid request: job id is required: %w", api.ErrInvalidRequest)
	}
	return service.Jobs.ClaimProcessing(ctx, jobID, attempt)
}

func (service JobService) RequeueRetry(ctx context.Context, jobID uuid.UUID, errorCode, errorMessage string) (models.Job, error) {
	job, err := service.Jobs.GetByID(ctx, jobID)
	if err != nil {
		return models.Job{}, err
	}
	if job.Status == models.JobStatusCancelled {
		return job, nil
	}
	job.Status = models.JobStatusQueued
	job.ErrorCode = errorCode
	job.ErrorMessage = errorMessage
	job.CompletedAt = nil
	job.Attempts++
	return service.Jobs.Update(ctx, job)
}

func (service JobService) FailJob(ctx context.Context, jobID uuid.UUID, errorCode, errorMessage string) (models.Job, error) {
	job, err := service.Jobs.GetByID(ctx, jobID)
	if err != nil {
		return models.Job{}, err
	}
	if service.Credits != nil && job.Type == models.JobTypeImageGeneration {
		if err := service.Credits.Refund(ctx, job.UserID, models.JobTypeImageGeneration, job.ID); err != nil {
			return models.Job{}, fmt.Errorf("refund generation credits: %w", err)
		}
	}
	return service.UpdateStatus(ctx, jobID, JobStatusUpdate{
		Status:       models.JobStatusFailed,
		Progress:     100,
		ErrorCode:    errorCode,
		ErrorMessage: errorMessage,
	})
}

func (service JobService) CompleteJob(ctx context.Context, jobID uuid.UUID, output map[string]any) (models.Job, error) {
	job, err := service.Jobs.GetByID(ctx, jobID)
	if err != nil {
		return models.Job{}, err
	}
	if service.Credits != nil && job.Type == models.JobTypeImageGeneration {
		if err := service.Credits.Consume(ctx, job.UserID, models.JobTypeImageGeneration, job.ID); err != nil {
			return models.Job{}, fmt.Errorf("consume generation credits: %w", err)
		}
	}
	return service.UpdateStatus(ctx, jobID, JobStatusUpdate{
		Status:   models.JobStatusCompleted,
		Progress: 100,
		Output:   output,
	})
}

func (service JobService) CancelJob(ctx context.Context, userID, jobID uuid.UUID) (models.Job, error) {
	job, err := service.GetJob(ctx, userID, jobID)
	if err != nil {
		return models.Job{}, err
	}
	switch job.Status {
	case models.JobStatusCompleted, models.JobStatusFailed, models.JobStatusCancelled:
		return job, nil
	case models.JobStatusQueued, models.JobStatusProcessing:
		if service.Credits != nil && job.Type == models.JobTypeImageGeneration {
			if err := service.Credits.Refund(ctx, job.UserID, models.JobTypeImageGeneration, job.ID); err != nil {
				return models.Job{}, fmt.Errorf("refund generation credits: %w", err)
			}
		}
		job.Status = models.JobStatusCancelled
		job.ErrorCode = JobErrorCodeCancelled
		job.ErrorMessage = "job cancelled by user"
		job.CompletedAt = timePointer(time.Now().UTC())
		return service.Jobs.Update(ctx, job)
	default:
		return models.Job{}, fmt.Errorf("invalid request: job status cannot be cancelled: %w", api.ErrInvalidRequest)
	}
}

func (service JobService) UpdateStatus(
	ctx context.Context,
	jobID uuid.UUID,
	update JobStatusUpdate,
) (models.Job, error) {
	if update.Status == "" {
		return models.Job{}, fmt.Errorf("invalid request: status is required: %w", api.ErrInvalidRequest)
	}
	if update.Progress < 0 || update.Progress > 100 {
		return models.Job{}, fmt.Errorf("invalid request: progress must be between 0 and 100: %w", api.ErrInvalidRequest)
	}
	if jobID == uuid.Nil {
		return models.Job{}, fmt.Errorf("invalid request: job id is required: %w", api.ErrInvalidRequest)
	}
	job, err := service.Jobs.GetByID(ctx, jobID)
	if err != nil {
		return models.Job{}, err
	}
	if !validJobStatus(update.Status) {
		return models.Job{}, fmt.Errorf("invalid request: unsupported job status: %w", api.ErrInvalidRequest)
	}
	if job.Status == models.JobStatusCancelled && update.Status != models.JobStatusCancelled {
		return job, nil
	}
	job.Status = update.Status
	job.Progress = update.Progress
	job.ErrorCode = update.ErrorCode
	job.ErrorMessage = update.ErrorMessage
	if update.Output != nil {
		job.Output = update.Output
		job.Result = update.Output
	} else {
		job.Result = update.Result
		job.Output = update.Result
	}
	now := time.Now().UTC()
	if update.Status == models.JobStatusProcessing && job.StartedAt == nil {
		job.StartedAt = &now
	}
	if update.Status == models.JobStatusCompleted ||
		update.Status == models.JobStatusFailed ||
		update.Status == models.JobStatusCancelled {
		job.CompletedAt = &now
	}
	return service.Jobs.Update(ctx, job)
}

func (service JobService) createOrReuse(
	ctx context.Context,
	userID uuid.UUID,
	jobType string,
	request map[string]any,
	idempotencyKey string,
	beforeEnqueue func(models.Job) error,
) (models.Job, bool, error) {
	if userID == uuid.Nil {
		return models.Job{}, false, api.ErrUnauthorized
	}
	idempotencyKey = strings.TrimSpace(idempotencyKey)
	if idempotencyKey != "" {
		if _, err := uuid.Parse(idempotencyKey); err != nil {
			return models.Job{}, false, fmt.Errorf("invalid request: idempotency key must be a UUID: %w", api.ErrInvalidRequest)
		}
		if service.Jobs != nil {
			existing, err := service.Jobs.GetByIdempotencyKey(ctx, userID, idempotencyKey)
			if err == nil {
				if existing.Type != jobType || !reflect.DeepEqual(existing.Input, request) {
					return models.Job{}, false, fmt.Errorf("invalid request: idempotency key was used with a different request: %w", api.ErrInvalidRequest)
				}
				return existing, true, nil
			}
			if !errors.Is(err, database.ErrNotFound) {
				return models.Job{}, false, err
			}
		}
	}
	if _, err := service.Users.Ensure(ctx, userID); err != nil {
		return models.Job{}, false, err
	}
	now := time.Now().UTC()
	job, err := service.Jobs.Create(ctx, models.Job{
		UserID:         userID,
		Type:           jobType,
		Kind:           jobType,
		Status:         models.JobStatusQueued,
		Progress:       0,
		Input:          request,
		Request:        request,
		Output:         map[string]any{},
		Result:         map[string]any{},
		Attempts:       1,
		IdempotencyKey: idempotencyKey,
		CreatedAt:      now,
	})
	if err != nil {
		if idempotencyKey != "" {
			if existing, lookupErr := service.Jobs.GetByIdempotencyKey(ctx, userID, idempotencyKey); lookupErr == nil {
				if existing.Type != jobType || !reflect.DeepEqual(existing.Input, request) {
					return models.Job{}, false, fmt.Errorf("invalid request: idempotency key was used with a different request: %w", api.ErrInvalidRequest)
				}
				return existing, true, nil
			}
		}
		return models.Job{}, false, err
	}
	if beforeEnqueue != nil {
		if err := beforeEnqueue(job); err != nil {
			failed, failureErr := service.markEnqueueFailed(ctx, job, err)
			return failed, false, failureErr
		}
	}
	if service.Queue == nil {
		failed, failureErr := service.markEnqueueFailed(ctx, job, api.ErrQueueFailure)
		return failed, false, failureErr
	}
	if err := service.Queue.Enqueue(ctx, queue.JobMessage{
		JobID:   job.ID,
		Type:    jobType,
		Attempt: job.Attempts,
	}); err != nil {
		failed, failureErr := service.markEnqueueFailed(ctx, job, fmt.Errorf("%s: %w", JobErrorCodeQueueEnqueue, api.ErrQueueFailure))
		return failed, false, failureErr
	}
	return job, false, nil
}

func (service JobService) markEnqueueFailed(ctx context.Context, job models.Job, cause error) (models.Job, error) {
	job.Status = models.JobStatusFailed
	job.ErrorCode = JobErrorCodeQueueEnqueue
	job.ErrorMessage = "job could not be queued"
	if errors.Is(cause, database.ErrInsufficientCredits) {
		job.ErrorCode = JobErrorCodeInsufficient
		job.ErrorMessage = "generation does not have enough credits"
	}
	job.CompletedAt = timePointer(time.Now().UTC())
	if service.Credits != nil && job.Type == models.JobTypeImageGeneration {
		if err := service.Credits.Refund(ctx, job.UserID, models.JobTypeImageGeneration, job.ID); err != nil {
			return models.Job{}, fmt.Errorf("queue job: %w; refund generation credits: %v", cause, err)
		}
	}
	updated, updateErr := service.Jobs.Update(ctx, job)
	if updateErr != nil {
		return models.Job{}, fmt.Errorf("queue job: %w; persist failed state: %v", cause, updateErr)
	}
	if errors.Is(cause, database.ErrInsufficientCredits) {
		return updated, fmt.Errorf("%w: %v", api.ErrInsufficientCredits, cause)
	}
	return updated, fmt.Errorf("queue job: %w", cause)
}

func (service JobService) generationCost() int {
	if service.GenerationCreditCost > 0 {
		return service.GenerationCreditCost
	}
	return 10
}

func structToMap(value any) (map[string]any, error) {
	data, err := json.Marshal(value)
	if err != nil {
		return nil, fmt.Errorf("encode job input: %w", err)
	}
	var result map[string]any
	if err := json.Unmarshal(data, &result); err != nil {
		return nil, fmt.Errorf("decode job input: %w", err)
	}
	return result, nil
}

func firstNonEmpty(values ...string) string {
	for _, value := range values {
		if strings.TrimSpace(value) != "" {
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

func firstVisualDNA(values ...*models.VisualDNA) *models.VisualDNA {
	for _, value := range values {
		if value != nil {
			return value
		}
	}
	return nil
}

func firstGenerationSettings(values ...models.GenerationSettings) models.GenerationSettings {
	for _, value := range values {
		if value != (models.GenerationSettings{}) {
			return value
		}
	}
	return models.GenerationSettings{}
}

func validJobStatus(status string) bool {
	switch status {
	case models.JobStatusQueued, models.JobStatusProcessing, models.JobStatusCompleted,
		models.JobStatusFailed, models.JobStatusCancelled:
		return true
	default:
		return false
	}
}

func timePointer(value time.Time) *time.Time {
	return &value
}

type TemplateService struct {
	Templates repositories.TemplateRepository
	Storage   storage.ObjectStorage
	Config    config.Config
}

func (service TemplateService) List(ctx context.Context) ([]models.Template, error) {
	templates, err := service.Templates.List(ctx)
	if err != nil {
		return nil, err
	}
	for index := range templates {
		templates[index].ThumbnailURL = service.templateThumbnailURL(ctx, templates[index].ThumbnailURL)
	}
	return templates, nil
}

func (service TemplateService) Get(ctx context.Context, id uuid.UUID) (models.Template, error) {
	template, err := service.Templates.Get(ctx, id)
	if err != nil {
		return models.Template{}, err
	}
	template.ThumbnailURL = service.templateThumbnailURL(ctx, template.ThumbnailURL)
	return template, nil
}

func (service TemplateService) templateThumbnailURL(ctx context.Context, value string) string {
	value = strings.TrimSpace(value)
	if value == "" {
		return ""
	}
	if strings.HasPrefix(value, "http://") || strings.HasPrefix(value, "https://") {
		return value
	}
	objectKey := strings.TrimPrefix(value, "s3://")
	if service.Config.S3Bucket != "" {
		objectKey = strings.TrimPrefix(objectKey, service.Config.S3Bucket+"/")
	}
	if objectKey == "" || service.Storage == nil {
		return value
	}
	signedURL, err := service.Storage.CreateDownloadURL(ctx, objectKey, service.Config.S3DownloadURLTTL)
	if err != nil {
		return value
	}
	return signedURL
}

type StyleService struct {
	Users   repositories.UserRepository
	Styles  repositories.SavedStyleRepository
	Assets  repositories.ImageAssetRepository
	Storage storage.ObjectStorage
	Config  config.Config
}

type CreateStyleInput struct {
	Name                 string            `json:"name"`
	PreviewAssetID       *uuid.UUID        `json:"preview_asset_id,omitempty"`
	PreviewAssetIDLegacy *uuid.UUID        `json:"previewAssetId,omitempty"`
	VisualDNA            *models.VisualDNA `json:"visual_dna,omitempty"`
	VisualDNALegacy      *models.VisualDNA `json:"visualDNA,omitempty"`
}

type UpdateStyleInput struct {
	Name           *string           `json:"name,omitempty"`
	PreviewAssetID **uuid.UUID       `json:"preview_asset_id,omitempty"`
	VisualDNA      *models.VisualDNA `json:"visual_dna,omitempty"`
}

func (input *UpdateStyleInput) UnmarshalJSON(data []byte) error {
	type wire struct {
		Name                 *string           `json:"name"`
		PreviewAssetID       json.RawMessage   `json:"preview_asset_id"`
		PreviewAssetIDLegacy json.RawMessage   `json:"previewAssetId"`
		VisualDNA            *models.VisualDNA `json:"visual_dna"`
	}

	var decoded wire
	decoder := json.NewDecoder(strings.NewReader(string(data)))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&decoded); err != nil {
		return err
	}

	*input = UpdateStyleInput{
		Name:      decoded.Name,
		VisualDNA: decoded.VisualDNA,
	}
	rawPreviewAssetID := decoded.PreviewAssetID
	if rawPreviewAssetID == nil {
		rawPreviewAssetID = decoded.PreviewAssetIDLegacy
	}
	if rawPreviewAssetID != nil {
		var previewAssetID *uuid.UUID
		if err := json.Unmarshal(rawPreviewAssetID, &previewAssetID); err != nil {
			return err
		}
		input.PreviewAssetID = &previewAssetID
	}
	return nil
}

func (service StyleService) List(ctx context.Context, userID uuid.UUID) ([]models.SavedStyleResponse, error) {
	styles, err := service.Styles.List(ctx, userID)
	if err != nil {
		return nil, err
	}
	responses := make([]models.SavedStyleResponse, 0, len(styles))
	for _, style := range styles {
		response, err := service.response(ctx, userID, style)
		if err != nil {
			return nil, err
		}
		responses = append(responses, response)
	}
	return responses, nil
}

func (service StyleService) Get(ctx context.Context, userID, id uuid.UUID) (models.SavedStyleResponse, error) {
	if id == uuid.Nil {
		return models.SavedStyleResponse{}, fmt.Errorf("invalid request: style id is required: %w", api.ErrInvalidRequest)
	}
	style, err := service.Styles.Get(ctx, userID, id)
	if err != nil {
		return models.SavedStyleResponse{}, err
	}
	return service.response(ctx, userID, style)
}

func (service StyleService) Create(ctx context.Context, userID uuid.UUID, input CreateStyleInput) (models.SavedStyleResponse, error) {
	previewAssetID := input.PreviewAssetID
	if previewAssetID == nil {
		previewAssetID = input.PreviewAssetIDLegacy
	}
	visualDNA := input.VisualDNA
	if visualDNA == nil {
		visualDNA = input.VisualDNALegacy
	}
	if visualDNA == nil {
		return models.SavedStyleResponse{}, fmt.Errorf("invalid request: visual_dna is required: %w", api.ErrInvalidRequest)
	}
	style := models.SavedStyle{
		Name:           strings.TrimSpace(input.Name),
		PreviewAssetID: previewAssetID,
		VisualDNA:      *visualDNA,
	}
	if strings.TrimSpace(style.Name) == "" {
		return models.SavedStyleResponse{}, fmt.Errorf("invalid request: name is required: %w", api.ErrInvalidRequest)
	}
	if err := style.VisualDNA.Validate(); err != nil {
		return models.SavedStyleResponse{}, fmt.Errorf("invalid request: visual_dna is invalid: %w", api.ErrInvalidRequest)
	}
	if err := service.validatePreviewAsset(ctx, userID, style.PreviewAssetID); err != nil {
		return models.SavedStyleResponse{}, err
	}
	style.UserID = userID
	if _, err := service.Users.Ensure(ctx, userID); err != nil {
		return models.SavedStyleResponse{}, err
	}
	created, err := service.Styles.Create(ctx, style)
	if err != nil {
		return models.SavedStyleResponse{}, err
	}
	return service.response(ctx, userID, created)
}

func (service StyleService) Update(ctx context.Context, userID, id uuid.UUID, input UpdateStyleInput) (models.SavedStyleResponse, error) {
	if id == uuid.Nil {
		return models.SavedStyleResponse{}, fmt.Errorf("invalid request: style id is required: %w", api.ErrInvalidRequest)
	}
	style, err := service.Styles.Get(ctx, userID, id)
	if err != nil {
		return models.SavedStyleResponse{}, err
	}
	if input.Name != nil {
		if strings.TrimSpace(*input.Name) == "" {
			return models.SavedStyleResponse{}, fmt.Errorf("invalid request: name is required: %w", api.ErrInvalidRequest)
		}
		style.Name = strings.TrimSpace(*input.Name)
	}
	if input.PreviewAssetID != nil {
		style.PreviewAssetID = *input.PreviewAssetID
	}
	if input.VisualDNA != nil {
		if err := input.VisualDNA.Validate(); err != nil {
			return models.SavedStyleResponse{}, fmt.Errorf("invalid request: visual_dna is invalid: %w", api.ErrInvalidRequest)
		}
		style.VisualDNA = *input.VisualDNA
	}
	if err := service.validatePreviewAsset(ctx, userID, style.PreviewAssetID); err != nil {
		return models.SavedStyleResponse{}, err
	}
	updated, err := service.Styles.Update(ctx, style)
	if err != nil {
		return models.SavedStyleResponse{}, err
	}
	return service.response(ctx, userID, updated)
}

func (service StyleService) Delete(ctx context.Context, userID, id uuid.UUID) error {
	if id == uuid.Nil {
		return fmt.Errorf("invalid request: style id is required: %w", api.ErrInvalidRequest)
	}
	return service.Styles.Delete(ctx, userID, id)
}

func (service StyleService) ToGenerationDraft(
	ctx context.Context,
	userID, id uuid.UUID,
	draft models.GenerationDraft,
) (models.GenerationDraft, error) {
	style, err := service.Styles.Get(ctx, userID, id)
	if err != nil {
		return models.GenerationDraft{}, err
	}
	draft.VisualDNA = &style.VisualDNA
	return draft, nil
}

func (service StyleService) validatePreviewAsset(
	ctx context.Context,
	userID uuid.UUID,
	assetID *uuid.UUID,
) error {
	if assetID == nil {
		return nil
	}
	if service.Assets == nil {
		return api.ErrUnavailable
	}
	asset, err := service.Assets.Get(ctx, userID, *assetID)
	if err != nil {
		return err
	}
	if asset.Status != models.ImageAssetStatusReady {
		return fmt.Errorf("invalid request: preview asset is not ready: %w", api.ErrInvalidRequest)
	}
	return nil
}

func (service StyleService) response(
	ctx context.Context,
	userID uuid.UUID,
	style models.SavedStyle,
) (models.SavedStyleResponse, error) {
	response := models.SavedStyleResponse{
		ID:             style.ID,
		Name:           style.Name,
		PreviewAssetID: style.PreviewAssetID,
		VisualDNA:      style.VisualDNA,
		CreatedAt:      style.CreatedAt,
		UpdatedAt:      style.UpdatedAt,
	}
	if style.PreviewAssetID != nil && service.Storage != nil {
		download, err := (AssetService{
			Assets:  service.Assets,
			Storage: service.Storage,
			Config:  service.Config,
		}).CreateDownloadURL(ctx, userID, *style.PreviewAssetID)
		if err != nil {
			return models.SavedStyleResponse{}, err
		}
		response.PreviewImageURL = download.DownloadURL
	}
	return response, nil
}

type CreationService struct {
	Creations repositories.CreationRepository
	Assets    repositories.ImageAssetRepository
	Storage   storage.ObjectStorage
	Config    config.Config
}

func (service CreationService) List(ctx context.Context, userID uuid.UUID) ([]models.Creation, error) {
	return service.Creations.List(ctx, userID)
}

func (service CreationService) Get(ctx context.Context, userID, id uuid.UUID) (models.Creation, error) {
	if id == uuid.Nil {
		return models.Creation{}, fmt.Errorf("invalid request: creation id is required: %w", api.ErrInvalidRequest)
	}
	return service.Creations.Get(ctx, userID, id)
}

func (service CreationService) ListPage(
	ctx context.Context,
	userID uuid.UUID,
	limit int,
	cursor string,
) (models.CreationPage, error) {
	if err := validateUserID(userID); err != nil {
		return models.CreationPage{}, api.ErrUnauthorized
	}
	limit, err := normalizeCreationLimit(limit)
	if err != nil {
		return models.CreationPage{}, err
	}
	before, err := decodeCreationCursor(cursor)
	if err != nil {
		return models.CreationPage{}, err
	}

	var creations []models.Creation
	var hasMore bool
	if paginated, ok := service.Creations.(repositories.PaginatedCreationRepository); ok {
		creations, hasMore, err = paginated.ListPage(ctx, userID, limit, before)
	} else {
		creations, err = service.Creations.List(ctx, userID)
		if err == nil {
			sort.Slice(creations, func(i, j int) bool {
				if creations[i].CreatedAt.Equal(creations[j].CreatedAt) {
					return bytes.Compare(creations[i].ID[:], creations[j].ID[:]) > 0
				}
				return creations[i].CreatedAt.After(creations[j].CreatedAt)
			})
			start := 0
			if before != nil {
				found := false
				for index, creation := range creations {
					if creation.CreatedAt.Before(before.CreatedAt) ||
						(creation.CreatedAt.Equal(before.CreatedAt) &&
							bytes.Compare(creation.ID[:], before.ID[:]) < 0) {
						start = index
						found = true
						break
					}
				}
				if !found {
					start = len(creations)
				}
			}
			if start < len(creations) {
				creations = creations[start:]
			} else {
				creations = nil
			}
			hasMore = len(creations) > limit
			if hasMore {
				creations = creations[:limit]
			}
		}
	}
	if err != nil {
		return models.CreationPage{}, err
	}

	items := make([]models.CreationListItem, 0, len(creations))
	for _, creation := range creations {
		item, projectionErr := service.listItem(ctx, userID, creation)
		if projectionErr != nil {
			return models.CreationPage{}, projectionErr
		}
		items = append(items, item)
	}
	page := models.CreationPage{
		Items:   items,
		HasMore: hasMore,
	}
	if hasMore && len(creations) > 0 {
		page.NextCursor = encodeCreationCursor(models.CreationCursor{
			CreatedAt: creations[len(creations)-1].CreatedAt,
			ID:        creations[len(creations)-1].ID,
		})
	}
	return page, nil
}

func (service CreationService) Detail(
	ctx context.Context,
	userID, id uuid.UUID,
) (models.CreationDetailResponse, error) {
	creation, err := service.Get(ctx, userID, id)
	if err != nil {
		return models.CreationDetailResponse{}, err
	}
	return service.detail(ctx, userID, creation)
}

func (service CreationService) Delete(ctx context.Context, userID, id uuid.UUID) error {
	if id == uuid.Nil {
		return fmt.Errorf("invalid request: creation id is required: %w", api.ErrInvalidRequest)
	}
	creation, err := service.Get(ctx, userID, id)
	if err != nil {
		return err
	}
	assetIDs := uniqueAssetIDs(creation)
	if len(assetIDs) > 0 && service.Storage == nil {
		return api.ErrUnavailable
	}
	if len(assetIDs) > 0 {
		if _, ok := service.Assets.(repositories.ImageAssetDeleter); !ok {
			return api.ErrUnavailable
		}
	}
	for _, assetID := range assetIDs {
		if service.Assets == nil {
			return api.ErrUnavailable
		}
		asset, assetErr := service.Assets.Get(ctx, userID, assetID)
		if errors.Is(assetErr, database.ErrNotFound) {
			continue
		}
		if assetErr != nil {
			return assetErr
		}
		if asset.ObjectKey != "" {
			if deleteErr := service.Storage.DeleteObject(ctx, asset.ObjectKey); deleteErr != nil &&
				!errors.Is(deleteErr, storage.ErrObjectNotFound) {
				return fmt.Errorf("delete creation object: %w", deleteErr)
			}
		}
	}
	deleter, ok := service.Creations.(repositories.CreationDeleter)
	if !ok {
		return api.ErrUnavailable
	}
	if err := deleter.Delete(ctx, userID, id); err != nil {
		return err
	}
	for _, assetID := range assetIDs {
		if service.Assets == nil {
			continue
		}
		if err := service.Assets.(repositories.ImageAssetDeleter).Delete(ctx, userID, assetID); err != nil &&
			!errors.Is(err, database.ErrNotFound) {
			return err
		}
	}
	return nil
}

func (service CreationService) listItem(
	ctx context.Context,
	userID uuid.UUID,
	creation models.Creation,
) (models.CreationListItem, error) {
	imageURL, thumbnailURL, err := service.assetURLs(ctx, userID, creation)
	if err != nil {
		return models.CreationListItem{}, err
	}
	return models.CreationListItem{
		ID:               creation.ID,
		ImageAssetID:     firstAssetIDPointer(creation.ImageAssetID, creation.GeneratedAssetID),
		ThumbnailAssetID: creation.ThumbnailAssetID,
		ImageURL:         imageURL,
		ThumbnailURL:     thumbnailURL,
		Prompt:           creation.OriginalPromptOrPrompt(),
		Template:         templateSummary(creation.Template),
		Style:            styleSummary(creation.VisualDNA),
		Status:           creation.Status,
		FailureMessage:   creation.FailureMessage,
		CreatedAt:        creation.CreatedAt,
	}, nil
}

func (service CreationService) detail(
	ctx context.Context,
	userID uuid.UUID,
	creation models.Creation,
) (models.CreationDetailResponse, error) {
	imageURL, thumbnailURL, err := service.assetURLs(ctx, userID, creation)
	if err != nil {
		return models.CreationDetailResponse{}, err
	}
	return models.CreationDetailResponse{
		ID:                   creation.ID,
		ImageAssetID:         firstAssetIDPointer(creation.ImageAssetID, creation.GeneratedAssetID),
		ThumbnailAssetID:     creation.ThumbnailAssetID,
		ImageURL:             imageURL,
		ThumbnailURL:         thumbnailURL,
		Prompt:               creation.OriginalPromptOrPrompt(),
		OriginalPrompt:       creation.OriginalPromptOrPrompt(),
		ResolvedPrompt:       creation.ResolvedPrompt,
		Template:             creation.Template,
		Style:                styleSummary(creation.VisualDNA),
		VisualDNA:            creation.VisualDNA,
		PreservationSettings: creation.PreservationSettings,
		GenerationSettings:   creation.GenerationSettings,
		ReferenceAssetID:     creation.ReferenceAssetID,
		Status:               creation.Status,
		FailureMessage:       creation.FailureMessage,
		CreatedAt:            creation.CreatedAt,
		UpdatedAt:            creation.UpdatedAt,
	}, nil
}

func (service CreationService) assetURLs(
	ctx context.Context,
	userID uuid.UUID,
	creation models.Creation,
) (string, string, error) {
	if service.Storage == nil || service.Assets == nil {
		if creation.ImageAssetID != nil || creation.GeneratedAssetID != nil ||
			creation.ThumbnailAssetID != nil {
			return "", "", api.ErrUnavailable
		}
		return "", "", nil
	}
	imageURL, err := service.assetURL(ctx, userID, firstAssetID(creation.ImageAssetID, creation.GeneratedAssetID))
	if err != nil {
		return "", "", err
	}
	thumbnailURL, err := service.assetURL(ctx, userID, creation.ThumbnailAssetID)
	if err != nil {
		return "", "", err
	}
	return imageURL, thumbnailURL, nil
}

func (service CreationService) assetURL(
	ctx context.Context,
	userID uuid.UUID,
	assetID *uuid.UUID,
) (string, error) {
	if assetID == nil {
		return "", nil
	}
	download, err := (AssetService{
		Assets:  service.Assets,
		Storage: service.Storage,
		Config:  service.Config,
	}).CreateDownloadURL(ctx, userID, *assetID)
	if err != nil {
		if errors.Is(err, database.ErrNotFound) ||
			errors.Is(err, api.ErrInvalidRequest) {
			return "", nil
		}
		return "", err
	}
	return download.DownloadURL, nil
}

func firstAssetIDPointer(values ...*uuid.UUID) *uuid.UUID {
	for _, value := range values {
		if value != nil && *value != uuid.Nil {
			id := *value
			return &id
		}
	}
	return nil
}

func normalizeCreationLimit(limit int) (int, error) {
	if limit == 0 {
		return 30, nil
	}
	if limit < 1 || limit > 100 {
		return 0, fmt.Errorf("invalid request: limit must be between 1 and 100: %w", api.ErrInvalidRequest)
	}
	return limit, nil
}

func encodeCreationCursor(cursor models.CreationCursor) string {
	data, _ := json.Marshal(struct {
		CreatedAt time.Time `json:"created_at"`
		ID        uuid.UUID `json:"id"`
	}{CreatedAt: cursor.CreatedAt, ID: cursor.ID})
	return base64.RawURLEncoding.EncodeToString(data)
}

func decodeCreationCursor(raw string) (*models.CreationCursor, error) {
	if strings.TrimSpace(raw) == "" {
		return nil, nil
	}
	data, err := base64.RawURLEncoding.DecodeString(raw)
	if err != nil {
		return nil, fmt.Errorf("invalid request: cursor is invalid: %w", api.ErrInvalidRequest)
	}
	var decoded struct {
		CreatedAt time.Time `json:"created_at"`
		ID        uuid.UUID `json:"id"`
	}
	if err := json.Unmarshal(data, &decoded); err != nil ||
		decoded.CreatedAt.IsZero() || decoded.ID == uuid.Nil {
		return nil, fmt.Errorf("invalid request: cursor is invalid: %w", api.ErrInvalidRequest)
	}
	return &models.CreationCursor{
		CreatedAt: decoded.CreatedAt,
		ID:        decoded.ID,
	}, nil
}

func uniqueAssetIDs(creation models.Creation) []uuid.UUID {
	ids := make([]uuid.UUID, 0, 3)
	seen := make(map[uuid.UUID]struct{})
	for _, id := range []*uuid.UUID{
		creation.ImageAssetID,
		creation.GeneratedAssetID,
		creation.ThumbnailAssetID,
	} {
		if id != nil && *id != uuid.Nil {
			if _, ok := seen[*id]; !ok {
				seen[*id] = struct{}{}
				ids = append(ids, *id)
			}
		}
	}
	return ids
}

func firstAssetID(ids ...*uuid.UUID) *uuid.UUID {
	for _, id := range ids {
		if id != nil && *id != uuid.Nil {
			return id
		}
	}
	return nil
}

func templateSummary(template models.Template) models.TemplateSummary {
	return models.TemplateSummary{
		ID:       template.ID,
		Name:     template.Name,
		Category: template.Category,
	}
}

func styleSummary(visualDNA *models.VisualDNA) *models.CreationStyleSummary {
	if visualDNA == nil {
		return nil
	}
	attributes := map[string][]string{}
	for name, category := range map[string]models.VisualDNACategory{
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
	} {
		if len(category.Attributes) > 0 {
			attributes[name] = append([]string(nil), category.Attributes...)
		}
	}
	if len(attributes) == 0 {
		return nil
	}
	return &models.CreationStyleSummary{Attributes: attributes}
}

type CreditService struct {
	Credits              repositories.CreditRepository
	Templates            repositories.TemplateRepository
	GenerationCreditCost int
}

func (service CreditService) Balance(ctx context.Context, userID uuid.UUID) (map[string]any, error) {
	if err := validateUserID(userID); err != nil {
		return nil, api.ErrUnauthorized
	}
	if service.Credits == nil {
		return nil, api.ErrUnavailable
	}
	balance, err := service.Credits.Balance(ctx, userID)
	if err != nil {
		return nil, err
	}
	return map[string]any{"balance": balance}, nil
}

func (service CreditService) GetBalance(ctx context.Context, userID uuid.UUID) (int, error) {
	if err := validateUserID(userID); err != nil {
		return 0, api.ErrUnauthorized
	}
	if service.Credits == nil {
		return 0, api.ErrUnavailable
	}
	return service.Credits.Balance(ctx, userID)
}

func (service CreditService) Reserve(
	ctx context.Context,
	userID, referenceID uuid.UUID,
	amount int,
) error {
	if err := validateUserID(userID); err != nil {
		return api.ErrUnauthorized
	}
	if service.Credits == nil {
		return api.ErrUnavailable
	}
	if amount <= 0 {
		return fmt.Errorf("invalid request: credit amount must be greater than zero: %w", api.ErrInvalidRequest)
	}
	if err := service.Credits.Reserve(ctx, userID, models.JobTypeImageGeneration, referenceID, amount); err != nil {
		if errors.Is(err, database.ErrInsufficientCredits) {
			return api.ErrInsufficientCredits
		}
		return err
	}
	return nil
}

func (service CreditService) Consume(ctx context.Context, userID, referenceID uuid.UUID) error {
	if err := validateUserID(userID); err != nil {
		return api.ErrUnauthorized
	}
	if service.Credits == nil {
		return api.ErrUnavailable
	}
	return service.Credits.Consume(ctx, userID, models.JobTypeImageGeneration, referenceID)
}

func (service CreditService) Refund(ctx context.Context, userID, referenceID uuid.UUID) error {
	if err := validateUserID(userID); err != nil {
		return api.ErrUnauthorized
	}
	if service.Credits == nil {
		return api.ErrUnavailable
	}
	return service.Credits.Refund(ctx, userID, models.JobTypeImageGeneration, referenceID)
}

type GenerationEstimate struct {
	EstimatedCredits int `json:"estimated_credits"`
}

func (service CreditService) Estimate(
	ctx context.Context,
	userID, templateID uuid.UUID,
	aspectRatio string,
) (GenerationEstimate, error) {
	if err := validateUserID(userID); err != nil {
		return GenerationEstimate{}, api.ErrUnauthorized
	}
	if templateID == uuid.Nil {
		return GenerationEstimate{}, fmt.Errorf("invalid request: template_id is required: %w", api.ErrInvalidRequest)
	}
	if service.Templates != nil {
		template, err := service.Templates.Get(ctx, templateID)
		if err != nil {
			return GenerationEstimate{}, err
		}
		if strings.TrimSpace(aspectRatio) == "" {
			aspectRatio = template.EffectiveDefaultSettings().AspectRatio
		}
	}
	if strings.TrimSpace(aspectRatio) == "" {
		return GenerationEstimate{}, fmt.Errorf("invalid request: aspect_ratio is required: %w", api.ErrInvalidRequest)
	}
	return GenerationEstimate{EstimatedCredits: service.creditCost()}, nil
}

func (service CreditService) creditCost() int {
	if service.GenerationCreditCost > 0 {
		return service.GenerationCreditCost
	}
	return 10
}

func validateUserID(userID uuid.UUID) error {
	if userID == uuid.Nil {
		return errors.New("invalid user id")
	}
	return nil
}
