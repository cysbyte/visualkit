package worker

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/providers"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
)

type JobProcessor interface {
	Process(ctx context.Context, job *models.Job) error
}

type ProcessorSet struct {
	Analysis   JobProcessor
	Generation JobProcessor
}

func (set ProcessorSet) ForType(jobType string) (JobProcessor, bool) {
	switch jobType {
	case models.JobTypeImageAnalysis:
		return set.Analysis, set.Analysis != nil
	case models.JobTypeImageGeneration:
		return set.Generation, set.Generation != nil
	default:
		return nil, false
	}
}

type ImageAnalysisProcessor struct {
	Assets          repositories.ImageAssetRepository
	Jobs            services.JobService
	Storage         storage.ObjectStorage
	Vision          providers.VisionProvider
	ProviderTimeout time.Duration
}

func (processor ImageAnalysisProcessor) Process(ctx context.Context, job *models.Job) error {
	if job == nil {
		return errors.New("job is required")
	}
	rawAssetID, ok := job.Input["asset_id"].(string)
	if !ok || rawAssetID == "" {
		rawAssetID, ok = job.Input["referenceAssetId"].(string)
	}
	if !ok || rawAssetID == "" {
		return providers.ErrInvalidImage
	}
	assetID, err := uuid.Parse(rawAssetID)
	if err != nil {
		return providers.ErrInvalidImage
	}
	asset, err := processor.Assets.Get(ctx, job.UserID, assetID)
	if err != nil {
		return err
	}
	if asset.Status != models.ImageAssetStatusReady {
		return providers.ErrInvalidImage
	}
	if processor.Storage == nil {
		return errors.New("object storage is required")
	}
	object, err := processor.Storage.GetObject(ctx, asset.ObjectKey)
	if err != nil {
		return err
	}
	if len(object.Data) == 0 {
		return providers.ErrInvalidImage
	}
	if asset.ByteSize > 0 && object.SizeBytes > 0 && object.SizeBytes != asset.ByteSize {
		return providers.ErrInvalidImage
	}
	if object.ContentType != "" && asset.MimeType != "" && object.ContentType != asset.MimeType {
		return providers.ErrInvalidImage
	}
	cancelled, err := processor.jobCancelled(ctx, job.ID)
	if err != nil {
		return err
	}
	if cancelled {
		return context.Canceled
	}
	timeout := processor.ProviderTimeout
	if timeout <= 0 {
		timeout = 2 * time.Minute
	}
	providerCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	visualDNA, err := processor.Vision.AnalyzeImage(providerCtx, providers.VisionInput{
		AssetObjectKey: asset.ObjectKey,
		MimeType:       asset.MimeType,
		ImageData:      object.Data,
		Prompt:         providers.VisionAnalysisPrompt,
	})
	if err != nil {
		return err
	}
	cancelled, err = processor.jobCancelled(ctx, job.ID)
	if err != nil {
		return err
	}
	if cancelled {
		return context.Canceled
	}
	if err := visualDNA.Validate(); err != nil {
		return fmt.Errorf("%w: %v", providers.ErrInvalidProviderRequest, err)
	}
	if _, err := processor.Assets.SaveVisualDNA(ctx, job.UserID, asset.ID, visualDNA); err != nil {
		return err
	}
	output, err := structToMap(struct {
		ReferenceAssetID uuid.UUID        `json:"reference_asset_id"`
		VisualDNA        models.VisualDNA `json:"visual_dna"`
	}{ReferenceAssetID: asset.ID, VisualDNA: visualDNA})
	if err != nil {
		return err
	}
	_, err = processor.Jobs.CompleteJob(ctx, job.ID, output)
	return err
}

type ImageGenerationProcessor struct {
	Assets          repositories.ImageAssetRepository
	Creations       repositories.CreationRepository
	Templates       repositories.TemplateRepository
	Jobs            services.JobService
	Storage         storage.ObjectStorage
	Generator       providers.ImageGenerationProvider
	ProviderTimeout time.Duration
	PromptBuilder   services.PromptBuilder
}

func (processor ImageGenerationProcessor) Process(ctx context.Context, job *models.Job) error {
	if job == nil {
		return errors.New("job is required")
	}
	var request models.GenerationRequest
	inputBytes, err := json.Marshal(job.Input)
	if err != nil {
		return err
	}
	if err := json.Unmarshal(inputBytes, &request); err != nil {
		return providers.ErrInvalidProviderRequest
	}
	if err := request.Validate(); err != nil {
		return fmt.Errorf("%w: %v", providers.ErrInvalidProviderRequest, err)
	}
	if processor.Templates == nil {
		return errors.New("template repository is required")
	}
	template, err := processor.Templates.Get(ctx, request.TemplateID)
	if err != nil {
		return err
	}
	intent, err := processor.PromptBuilder.BuildGenerationIntent(request.Draft(), template)
	if err != nil {
		return fmt.Errorf("%w: %v", providers.ErrInvalidProviderRequest, err)
	}
	resolvedPrompt, err := processor.PromptBuilder.BuildProviderPrompt(intent)
	if err != nil {
		return fmt.Errorf("%w: %v", providers.ErrInvalidProviderRequest, err)
	}
	var referenceImage *providers.ReferenceImage
	if intent.ReferenceAssetID != nil {
		if processor.Storage == nil {
			return errors.New("object storage is required for reference image")
		}
		referenceAsset, err := processor.Assets.Get(ctx, job.UserID, *intent.ReferenceAssetID)
		if err != nil {
			return err
		}
		if referenceAsset.Status != models.ImageAssetStatusReady {
			return providers.ErrInvalidImage
		}
		object, err := processor.Storage.GetObject(ctx, referenceAsset.ObjectKey)
		if err != nil {
			return err
		}
		if len(object.Data) == 0 {
			return providers.ErrInvalidImage
		}
		referenceImage = &providers.ReferenceImage{
			AssetID:     referenceAsset.ID.String(),
			MimeType:    referenceAsset.MimeType,
			Data:        object.Data,
			PixelWidth:  referenceAsset.PixelWidth,
			PixelHeight: referenceAsset.PixelHeight,
		}
	}
	var personImage *providers.ReferenceImage
	if rawPersonID, ok := job.Input["personAssetId"]; ok {
		personID, err := uuid.Parse(fmt.Sprint(rawPersonID))
		if err != nil || intent.ReferenceAssetID == nil || personID == *intent.ReferenceAssetID {
			return providers.ErrInvalidImage
		}
		if processor.Storage == nil {
			return errors.New("object storage is required for person image")
		}
		personAsset, err := processor.Assets.Get(ctx, job.UserID, personID)
		if err != nil {
			return err
		}
		if personAsset.Status != models.ImageAssetStatusReady {
			return providers.ErrInvalidImage
		}
		object, err := processor.Storage.GetObject(ctx, personAsset.ObjectKey)
		if err != nil {
			return err
		}
		if len(object.Data) == 0 {
			return providers.ErrInvalidImage
		}
		personImage = &providers.ReferenceImage{
			AssetID:     personAsset.ID.String(),
			MimeType:    personAsset.MimeType,
			Data:        object.Data,
			PixelWidth:  personAsset.PixelWidth,
			PixelHeight: personAsset.PixelHeight,
		}
	}
	cancelled, err := processor.jobCancelled(ctx, job.ID)
	if err != nil {
		return err
	}
	if cancelled {
		return context.Canceled
	}
	creation := models.Creation{
		ID:                   uuid.New(),
		UserID:               job.UserID,
		ReferenceAssetID:     intent.ReferenceAssetID,
		Prompt:               intent.OriginalPrompt,
		OriginalPrompt:       intent.OriginalPrompt,
		ResolvedPrompt:       resolvedPrompt,
		Template:             template,
		VisualDNA:            intent.VisualDNA,
		PreservationSettings: intent.Preservation,
		GenerationSettings:   intent.GenerationSettings,
		Status:               "processing",
		CreatedAt:            time.Now().UTC(),
	}
	creation, err = processor.Creations.Create(ctx, creation)
	if err != nil {
		return err
	}
	failCreation := func(cause error) error {
		creation.Status = "failed"
		creation.FailureMessage = "generation failed"
		persistContext := ctx
		if persistContext.Err() != nil {
			var cancel context.CancelFunc
			persistContext, cancel = context.WithTimeout(context.Background(), 5*time.Second)
			defer cancel()
		}
		_, _ = processor.Creations.Update(persistContext, creation)
		return cause
	}
	timeout := processor.ProviderTimeout
	if timeout <= 0 {
		timeout = 2 * time.Minute
	}
	providerCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	providerRequest := request
	providerRequest.OriginalPrompt = intent.OriginalPrompt
	providerRequest.UserPrompt = intent.OriginalPrompt
	providerRequest.ResolvedPrompt = resolvedPrompt
	providerRequest.ReferenceAssetID = intent.ReferenceAssetID
	providerRequest.VisualDNA = intent.VisualDNA
	providerRequest.PreservationSettings = intent.Preservation
	providerRequest.GenerationSettings = intent.GenerationSettings
	slog.Info("image provider request prepared",
		slog.String("job_id", job.ID.String()),
		slog.String("template_id", intent.TemplateID.String()),
		slog.String("aspect_ratio", intent.GenerationSettings.AspectRatio),
		slog.Int("prompt_length", len(resolvedPrompt)),
		slog.Bool("has_reference_image", referenceImage != nil),
		slog.Bool("has_person_image", personImage != nil),
	)
	generated, err := processor.Generator.GenerateImage(providerCtx, providers.GenerationInput{
		Request:        providerRequest,
		Intent:         intent,
		ProviderPrompt: resolvedPrompt,
		ReferenceImage: referenceImage,
		PersonImage:    personImage,
	})
	if err != nil {
		return failCreation(err)
	}
	cancelled, err = processor.jobCancelled(ctx, job.ID)
	if err != nil {
		return failCreation(err)
	}
	if cancelled {
		return failCreation(context.Canceled)
	}
	if len(generated.Data) == 0 {
		return failCreation(providers.ErrProviderResponse)
	}
	if generated.MimeType == "" {
		generated.MimeType = "image/jpeg"
	}
	generatedKey := fmt.Sprintf("users/%s/creations/%s/generated", job.UserID, creation.ID)
	thumbnailKey := fmt.Sprintf("users/%s/creations/%s/thumbnail", job.UserID, creation.ID)
	if len(generated.Data) > 0 {
		if err := processor.Storage.PutObject(ctx, storage.PutObjectInput{
			ObjectKey:   generatedKey,
			ContentType: generated.MimeType,
			Data:        generated.Data,
		}); err != nil {
			return failCreation(err)
		}
	}
	if len(generated.ThumbnailData) > 0 {
		if err := processor.Storage.PutObject(ctx, storage.PutObjectInput{
			ObjectKey:   thumbnailKey,
			ContentType: generated.MimeType,
			Data:        generated.ThumbnailData,
		}); err != nil {
			return failCreation(err)
		}
	}
	generatedAsset, err := processor.Assets.Create(ctx, models.ImageAsset{
		UserID:      job.UserID,
		ObjectKey:   generatedKey,
		Filename:    "generated",
		MimeType:    generated.MimeType,
		ByteSize:    int64(len(generated.Data)),
		PixelWidth:  generated.PixelWidth,
		PixelHeight: generated.PixelHeight,
		Status:      models.ImageAssetStatusReady,
	})
	if err != nil {
		return failCreation(err)
	}
	var thumbnailAsset models.ImageAsset
	if len(generated.ThumbnailData) > 0 {
		thumbnailAsset, err = processor.Assets.Create(ctx, models.ImageAsset{
			UserID:    job.UserID,
			ObjectKey: thumbnailKey,
			Filename:  "thumbnail",
			MimeType:  generated.MimeType,
			ByteSize:  int64(len(generated.ThumbnailData)),
			Status:    models.ImageAssetStatusReady,
		})
		if err != nil {
			return failCreation(err)
		}
	}
	creation.GeneratedAssetID = &generatedAsset.ID
	creation.ImageAssetID = &generatedAsset.ID
	if thumbnailAsset.ID != uuid.Nil {
		creation.ThumbnailAssetID = &thumbnailAsset.ID
	}
	creation.Status = "completed"
	if _, err := processor.Creations.Update(ctx, creation); err != nil {
		return err
	}
	output := map[string]any{
		"creationId":         creation.ID.String(),
		"generatedAssetId":   generatedAsset.ID.String(),
		"generatedObjectKey": generatedKey,
	}
	if thumbnailAsset.ID != uuid.Nil {
		output["thumbnailAssetId"] = thumbnailAsset.ID.String()
	}
	_, err = processor.Jobs.CompleteJob(ctx, job.ID, output)
	return err
}

func (processor ImageAnalysisProcessor) jobCancelled(ctx context.Context, jobID uuid.UUID) (bool, error) {
	if processor.Jobs.Jobs == nil {
		return false, nil
	}
	current, err := processor.Jobs.LoadJob(ctx, jobID)
	if err != nil {
		return false, err
	}
	return current.Status == models.JobStatusCancelled, nil
}

func (processor ImageGenerationProcessor) jobCancelled(ctx context.Context, jobID uuid.UUID) (bool, error) {
	if processor.Jobs.Jobs == nil {
		return false, nil
	}
	current, err := processor.Jobs.LoadJob(ctx, jobID)
	if err != nil {
		return false, err
	}
	return current.Status == models.JobStatusCancelled, nil
}

func structToMap(value any) (map[string]any, error) {
	data, err := json.Marshal(value)
	if err != nil {
		return nil, err
	}
	var result map[string]any
	return result, json.Unmarshal(data, &result)
}
