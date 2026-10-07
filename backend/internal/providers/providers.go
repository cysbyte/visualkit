package providers

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"

	"github.com/visualkit/backend/internal/models"
)

var (
	ErrInvalidImage           = errors.New("invalid image")
	ErrInvalidPrompt          = errors.New("invalid prompt")
	ErrInvalidProviderRequest = errors.New("invalid provider request")
	ErrProviderUnavailable    = errors.New("provider unavailable")
	ErrProviderResponse       = errors.New("invalid provider response")
)

type ProviderError struct {
	Code      string
	Retryable bool
	Err       error
}

func (err *ProviderError) Error() string {
	if err == nil {
		return ""
	}
	if err.Code == "" {
		return err.Err.Error()
	}
	return err.Code + ": " + err.Err.Error()
}

func (err *ProviderError) Unwrap() error {
	if err == nil {
		return nil
	}
	return err.Err
}

func NewProviderError(code string, retryable bool, err error) error {
	if err == nil {
		err = ErrProviderResponse
	}
	return &ProviderError{Code: code, Retryable: retryable, Err: err}
}

type VisionProvider interface {
	AnalyzeImage(ctx context.Context, input VisionInput) (models.VisualDNA, error)
}

type VisionInput struct {
	AssetObjectKey string
	MimeType       string
	ImageData      []byte
	Prompt         string
}

const VisionAnalysisPrompt = `Analyze the provided reference image and return structured Visual DNA as JSON only.

The primary output is reusable visual characteristics, not an image-generation prompt.
Use this exact schema:
{
  "schema_version": 1,
  "subject": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "composition": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "lighting": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "color_palette": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "camera": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "depth_of_field": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "style": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "mood": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "background": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0},
  "texture": {"attributes": [], "observations": [], "inferences": [], "confidence": 0.0}
}

Separate observations from inferences. Observations must describe visible image evidence.
Inferences may summarize reusable style concepts, but avoid unsupported guesses.
Keep attributes concise and reusable. Confidence values must be between 0 and 1.
Do not include markdown, commentary, binary data, or a giant image-generation prompt.`

type ImageGenerationProvider interface {
	GenerateImage(ctx context.Context, input GenerationInput) (GeneratedImage, error)
}

type GenerationInput struct {
	Request        models.GenerationRequest
	Intent         models.GenerationIntent
	ProviderPrompt string
	ReferenceImage *ReferenceImage
}

type ReferenceImage struct {
	AssetID     string
	MimeType    string
	Data        []byte
	PixelWidth  int
	PixelHeight int
}

type GeneratedImage struct {
	ObjectKey          string
	ThumbnailObjectKey string
	MimeType           string
	Data               []byte
	ThumbnailData      []byte
	PixelWidth         int
	PixelHeight        int
}

type GenerationOutput = GeneratedImage

type HTTPImageGenerationProvider struct {
	Endpoint         string
	APIKey           string
	Client           *http.Client
	MaxResponseBytes int64
}

type OpenAIImageGenerationProvider struct {
	Endpoint         string
	Model            string
	APIKey           string
	Client           *http.Client
	MaxResponseBytes int64
}

type httpGenerationRequest struct {
	Prompt         string                      `json:"prompt"`
	OriginalPrompt string                      `json:"original_prompt"`
	Template       httpTemplateInput           `json:"template"`
	VisualDNA      *models.VisualDNA           `json:"visual_dna,omitempty"`
	Preservation   models.PreservationSettings `json:"preservation"`
	AspectRatio    string                      `json:"aspect_ratio"`
	Settings       models.GenerationSettings   `json:"generation_settings"`
	ReferenceImage *httpReferenceImageInput    `json:"reference_image,omitempty"`
}

type httpTemplateInput struct {
	ID         string   `json:"id"`
	Name       string   `json:"name"`
	Category   string   `json:"category"`
	Directives []string `json:"directives,omitempty"`
}

type httpReferenceImageInput struct {
	AssetID     string `json:"asset_id"`
	MimeType    string `json:"mime_type"`
	DataBase64  string `json:"data_base64"`
	PixelWidth  int    `json:"pixel_width,omitempty"`
	PixelHeight int    `json:"pixel_height,omitempty"`
}

type httpGenerationResponse struct {
	ImageBase64     string `json:"image_base64"`
	ThumbnailBase64 string `json:"thumbnail_base64,omitempty"`
	ImageURL        string `json:"image_url,omitempty"`
	ThumbnailURL    string `json:"thumbnail_url,omitempty"`
	MimeType        string `json:"mime_type"`
	PixelWidth      int    `json:"pixel_width"`
	PixelHeight     int    `json:"pixel_height"`
}

type openAIImageGenerationRequest struct {
	Model          string `json:"model"`
	Prompt         string `json:"prompt"`
	Size           string `json:"size,omitempty"`
	ResponseFormat string `json:"response_format,omitempty"`
}

type openAIImageGenerationResponse struct {
	Data []struct {
		B64JSON string `json:"b64_json"`
		URL     string `json:"url"`
	} `json:"data"`
}

func (provider HTTPImageGenerationProvider) GenerateImage(
	ctx context.Context,
	input GenerationInput,
) (GeneratedImage, error) {
	if strings.TrimSpace(provider.Endpoint) == "" {
		return GeneratedImage{}, NewProviderError("PROVIDER_NOT_CONFIGURED", false, ErrProviderUnavailable)
	}
	if strings.TrimSpace(input.ProviderPrompt) == "" {
		return GeneratedImage{}, ErrInvalidPrompt
	}
	endpoint, err := url.Parse(provider.Endpoint)
	if err != nil || endpoint.Scheme == "" || endpoint.Host == "" {
		return GeneratedImage{}, NewProviderError("PROVIDER_ENDPOINT_INVALID", false, errOrDefault(err, ErrProviderUnavailable))
	}

	requestBody := httpGenerationRequest{
		Prompt:         input.ProviderPrompt,
		OriginalPrompt: input.Intent.OriginalPrompt,
		Template: httpTemplateInput{
			ID:         input.Intent.TemplateID.String(),
			Name:       input.Intent.TemplateName,
			Category:   input.Intent.TemplateCategory,
			Directives: input.Intent.PromptDirectives,
		},
		VisualDNA:    input.Intent.VisualDNA,
		Preservation: input.Intent.Preservation,
		AspectRatio:  input.Intent.GenerationSettings.AspectRatio,
		Settings:     input.Intent.GenerationSettings,
	}
	if input.ReferenceImage != nil {
		requestBody.ReferenceImage = &httpReferenceImageInput{
			AssetID:     input.ReferenceImage.AssetID,
			MimeType:    input.ReferenceImage.MimeType,
			DataBase64:  base64.StdEncoding.EncodeToString(input.ReferenceImage.Data),
			PixelWidth:  input.ReferenceImage.PixelWidth,
			PixelHeight: input.ReferenceImage.PixelHeight,
		}
	}
	encoded, err := json.Marshal(requestBody)
	if err != nil {
		return GeneratedImage{}, NewProviderError("REQUEST_ENCODING_FAILED", false, err)
	}
	request, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint.String(), bytes.NewReader(encoded))
	if err != nil {
		return GeneratedImage{}, NewProviderError("REQUEST_BUILD_FAILED", false, err)
	}
	request.Header.Set("Content-Type", "application/json")
	if provider.APIKey != "" {
		request.Header.Set("Authorization", "Bearer "+provider.APIKey)
	}
	client := provider.Client
	if client == nil {
		client = http.DefaultClient
	}
	response, err := client.Do(request)
	if err != nil {
		if ctx.Err() != nil {
			return GeneratedImage{}, ctx.Err()
		}
		return GeneratedImage{}, NewProviderError("PROVIDER_NETWORK_ERROR", true, err)
	}
	defer response.Body.Close()
	limit := provider.MaxResponseBytes
	if limit <= 0 {
		limit = 100 * 1024 * 1024
	}
	body, err := io.ReadAll(io.LimitReader(response.Body, limit+1))
	if err != nil {
		return GeneratedImage{}, NewProviderError("PROVIDER_RESPONSE_READ_FAILED", true, err)
	}
	if int64(len(body)) > limit {
		return GeneratedImage{}, NewProviderError("PROVIDER_RESPONSE_TOO_LARGE", false, ErrProviderResponse)
	}
	if response.StatusCode < http.StatusOK || response.StatusCode >= http.StatusMultipleChoices {
		return GeneratedImage{}, providerHTTPError(response.StatusCode, body)
	}
	var decoded httpGenerationResponse
	if err := json.Unmarshal(body, &decoded); err != nil {
		return GeneratedImage{}, NewProviderError("PROVIDER_RESPONSE_INVALID_JSON", false, err)
	}
	imageData, err := decodeImageData(decoded.ImageBase64, decoded.ImageURL, client, ctx)
	if err != nil {
		return GeneratedImage{}, err
	}
	thumbnailData, err := decodeImageData(decoded.ThumbnailBase64, decoded.ThumbnailURL, client, ctx)
	if err != nil && (decoded.ThumbnailBase64 != "" || decoded.ThumbnailURL != "") {
		return GeneratedImage{}, err
	}
	if len(imageData) == 0 {
		return GeneratedImage{}, NewProviderError("PROVIDER_IMAGE_MISSING", false, ErrProviderResponse)
	}
	mimeType := decoded.MimeType
	if mimeType == "" {
		mimeType = "image/jpeg"
	}
	return GeneratedImage{
		Data:          imageData,
		ThumbnailData: thumbnailData,
		MimeType:      mimeType,
		PixelWidth:    decoded.PixelWidth,
		PixelHeight:   decoded.PixelHeight,
	}, nil
}

func (provider OpenAIImageGenerationProvider) GenerateImage(
	ctx context.Context,
	input GenerationInput,
) (GeneratedImage, error) {
	if strings.TrimSpace(provider.Endpoint) == "" {
		return GeneratedImage{}, NewProviderError("PROVIDER_NOT_CONFIGURED", false, ErrProviderUnavailable)
	}
	if strings.TrimSpace(input.ProviderPrompt) == "" {
		return GeneratedImage{}, ErrInvalidPrompt
	}
	endpoint, err := url.Parse(provider.Endpoint)
	if err != nil || endpoint.Scheme == "" || endpoint.Host == "" {
		return GeneratedImage{}, NewProviderError("PROVIDER_ENDPOINT_INVALID", false, errOrDefault(err, ErrProviderUnavailable))
	}
	model := strings.TrimSpace(provider.Model)
	if model == "" {
		model = "gpt-image-1"
	}
	encoded, err := json.Marshal(openAIImageGenerationRequest{
		Model:          model,
		Prompt:         input.ProviderPrompt,
		Size:           imageSizeForAspectRatio(input.Intent.GenerationSettings.AspectRatio),
		ResponseFormat: "b64_json",
	})
	if err != nil {
		return GeneratedImage{}, NewProviderError("REQUEST_ENCODING_FAILED", false, err)
	}
	request, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint.String(), bytes.NewReader(encoded))
	if err != nil {
		return GeneratedImage{}, NewProviderError("REQUEST_BUILD_FAILED", false, err)
	}
	request.Header.Set("Content-Type", "application/json")
	if provider.APIKey != "" {
		request.Header.Set("Authorization", "Bearer "+provider.APIKey)
	}
	client := provider.Client
	if client == nil {
		client = http.DefaultClient
	}
	response, err := client.Do(request)
	if err != nil {
		if ctx.Err() != nil {
			return GeneratedImage{}, ctx.Err()
		}
		return GeneratedImage{}, NewProviderError("PROVIDER_NETWORK_ERROR", true, err)
	}
	defer response.Body.Close()
	limit := provider.MaxResponseBytes
	if limit <= 0 {
		limit = 100 * 1024 * 1024
	}
	body, err := io.ReadAll(io.LimitReader(response.Body, limit+1))
	if err != nil {
		return GeneratedImage{}, NewProviderError("PROVIDER_RESPONSE_READ_FAILED", true, err)
	}
	if int64(len(body)) > limit {
		return GeneratedImage{}, NewProviderError("PROVIDER_RESPONSE_TOO_LARGE", false, ErrProviderResponse)
	}
	if response.StatusCode < http.StatusOK || response.StatusCode >= http.StatusMultipleChoices {
		return GeneratedImage{}, providerHTTPError(response.StatusCode, body)
	}
	var decoded openAIImageGenerationResponse
	if err := json.Unmarshal(body, &decoded); err != nil {
		return GeneratedImage{}, NewProviderError("PROVIDER_RESPONSE_INVALID_JSON", false, err)
	}
	if len(decoded.Data) == 0 {
		return GeneratedImage{}, NewProviderError("PROVIDER_IMAGE_MISSING", false, ErrProviderResponse)
	}
	imageData, err := decodeImageData(decoded.Data[0].B64JSON, decoded.Data[0].URL, client, ctx)
	if err != nil {
		return GeneratedImage{}, err
	}
	if len(imageData) == 0 {
		return GeneratedImage{}, NewProviderError("PROVIDER_IMAGE_MISSING", false, ErrProviderResponse)
	}
	return GeneratedImage{
		Data:     imageData,
		MimeType: "image/png",
	}, nil
}

func imageSizeForAspectRatio(aspectRatio string) string {
	switch strings.TrimSpace(aspectRatio) {
	case "1:1":
		return "1024x1024"
	case "16:9":
		return "1536x864"
	case "9:16":
		return "864x1536"
	default:
		return "1024x1024"
	}
}

func decodeImageData(encodedValue, imageURL string, client *http.Client, ctx context.Context) ([]byte, error) {
	if encodedValue != "" {
		data, err := base64.StdEncoding.DecodeString(encodedValue)
		if err != nil {
			return nil, NewProviderError("PROVIDER_IMAGE_INVALID_BASE64", false, err)
		}
		return data, nil
	}
	if imageURL == "" {
		return nil, nil
	}
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, imageURL, nil)
	if err != nil {
		return nil, NewProviderError("PROVIDER_IMAGE_URL_INVALID", false, err)
	}
	response, err := client.Do(request)
	if err != nil {
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}
		return nil, NewProviderError("PROVIDER_IMAGE_DOWNLOAD_FAILED", true, err)
	}
	defer response.Body.Close()
	if response.StatusCode < http.StatusOK || response.StatusCode >= http.StatusMultipleChoices {
		return nil, providerHTTPError(response.StatusCode, nil)
	}
	data, err := io.ReadAll(response.Body)
	if err != nil {
		return nil, NewProviderError("PROVIDER_IMAGE_READ_FAILED", true, err)
	}
	return data, nil
}

func providerHTTPError(status int, body []byte) error {
	retryable := status == http.StatusRequestTimeout ||
		status == http.StatusTooManyRequests ||
		status >= http.StatusInternalServerError
	message := fmt.Sprintf("provider returned HTTP %d", status)
	if len(body) > 0 {
		var payload struct {
			Error string `json:"error"`
		}
		if json.Unmarshal(body, &payload) == nil && payload.Error != "" {
			message = payload.Error
		}
	}
	return NewProviderError(fmt.Sprintf("PROVIDER_HTTP_%d", status), retryable, errors.New(message))
}

func errOrDefault(err, fallback error) error {
	if err != nil {
		return err
	}
	return fallback
}

type StructuredVisionProvider struct {
	Analyze func(ctx context.Context, input VisionInput) ([]byte, error)
}

// HTTPVisionProvider is a provider-neutral HTTP adapter. The backend owns the
// analysis prompt and the adapter only translates the request/response
// envelope; provider-specific credentials stay in the worker environment.
type HTTPVisionProvider struct {
	Endpoint         string
	APIKey           string
	Client           *http.Client
	MaxResponseBytes int64
}

type httpVisionRequest struct {
	Prompt         string `json:"prompt"`
	AssetObjectKey string `json:"asset_object_key"`
	MimeType       string `json:"mime_type"`
	ImageBase64    string `json:"image_base64"`
}

func (provider HTTPVisionProvider) AnalyzeImage(
	ctx context.Context,
	input VisionInput,
) (models.VisualDNA, error) {
	if strings.TrimSpace(provider.Endpoint) == "" {
		return models.VisualDNA{}, NewProviderError("PROVIDER_NOT_CONFIGURED", false, ErrProviderUnavailable)
	}
	if input.AssetObjectKey == "" || input.MimeType == "" || len(input.ImageData) == 0 {
		return models.VisualDNA{}, ErrInvalidImage
	}
	endpoint, err := url.Parse(provider.Endpoint)
	if err != nil || endpoint.Scheme == "" || endpoint.Host == "" {
		return models.VisualDNA{}, NewProviderError(
			"PROVIDER_ENDPOINT_INVALID",
			false,
			errOrDefault(err, ErrProviderUnavailable),
		)
	}
	prompt := input.Prompt
	if strings.TrimSpace(prompt) == "" {
		prompt = VisionAnalysisPrompt
	}
	encoded, err := json.Marshal(httpVisionRequest{
		Prompt:         prompt,
		AssetObjectKey: input.AssetObjectKey,
		MimeType:       input.MimeType,
		ImageBase64:    base64.StdEncoding.EncodeToString(input.ImageData),
	})
	if err != nil {
		return models.VisualDNA{}, NewProviderError("REQUEST_ENCODING_FAILED", false, err)
	}
	request, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint.String(), bytes.NewReader(encoded))
	if err != nil {
		return models.VisualDNA{}, NewProviderError("REQUEST_BUILD_FAILED", false, err)
	}
	request.Header.Set("Content-Type", "application/json")
	if provider.APIKey != "" {
		request.Header.Set("Authorization", "Bearer "+provider.APIKey)
	}
	client := provider.Client
	if client == nil {
		client = http.DefaultClient
	}
	response, err := client.Do(request)
	if err != nil {
		if ctx.Err() != nil {
			return models.VisualDNA{}, ctx.Err()
		}
		return models.VisualDNA{}, NewProviderError("PROVIDER_NETWORK_ERROR", true, err)
	}
	defer response.Body.Close()
	limit := provider.MaxResponseBytes
	if limit <= 0 {
		limit = 2 * 1024 * 1024
	}
	body, err := io.ReadAll(io.LimitReader(response.Body, limit+1))
	if err != nil {
		return models.VisualDNA{}, NewProviderError("PROVIDER_RESPONSE_READ_FAILED", true, err)
	}
	if int64(len(body)) > limit {
		return models.VisualDNA{}, NewProviderError("PROVIDER_RESPONSE_TOO_LARGE", false, ErrProviderResponse)
	}
	if response.StatusCode < http.StatusOK || response.StatusCode >= http.StatusMultipleChoices {
		return models.VisualDNA{}, providerHTTPError(response.StatusCode, body)
	}

	// Adapters may return either the Visual DNA object directly or an envelope
	// containing visual_dna. Both paths still pass through strict validation.
	var envelope map[string]json.RawMessage
	if err := json.Unmarshal(body, &envelope); err != nil {
		return models.VisualDNA{}, NewProviderError("PROVIDER_RESPONSE_INVALID_JSON", false, err)
	}
	if visualDNA, ok := envelope["visual_dna"]; ok {
		return ParseVisualDNAResponse(visualDNA)
	}
	return ParseVisualDNAResponse(body)
}

func NewVisionProvider(name, endpoint, apiKey string) (VisionProvider, error) {
	switch strings.ToLower(strings.TrimSpace(name)) {
	case "", "mock":
		return MockVisionProvider{}, nil
	case "http":
		return HTTPVisionProvider{Endpoint: endpoint, APIKey: apiKey}, nil
	default:
		return nil, fmt.Errorf("unsupported vision provider %q", name)
	}
}

func NewImageGenerationProvider(name, endpoint, model, apiKey string) (ImageGenerationProvider, error) {
	switch strings.ToLower(strings.TrimSpace(name)) {
	case "", "mock":
		return MockImageGenerationProvider{}, nil
	case "http":
		return HTTPImageGenerationProvider{Endpoint: endpoint, APIKey: apiKey}, nil
	case "cheaperinference", "openai":
		return OpenAIImageGenerationProvider{Endpoint: endpoint, Model: model, APIKey: apiKey}, nil
	default:
		return nil, fmt.Errorf("unsupported image generation provider %q", name)
	}
}

func (provider StructuredVisionProvider) AnalyzeImage(
	ctx context.Context,
	input VisionInput,
) (models.VisualDNA, error) {
	if input.AssetObjectKey == "" || input.MimeType == "" || len(input.ImageData) == 0 {
		return models.VisualDNA{}, ErrInvalidImage
	}
	if strings.TrimSpace(input.Prompt) == "" {
		input.Prompt = VisionAnalysisPrompt
	}
	if provider.Analyze == nil {
		return models.VisualDNA{}, ErrInvalidProviderRequest
	}
	response, err := provider.Analyze(ctx, input)
	if err != nil {
		return models.VisualDNA{}, err
	}
	return ParseVisualDNAResponse(response)
}

type JSONVisionProvider struct {
	Response []byte
	Err      error
}

func (provider JSONVisionProvider) AnalyzeImage(
	ctx context.Context,
	input VisionInput,
) (models.VisualDNA, error) {
	if provider.Err != nil {
		return models.VisualDNA{}, provider.Err
	}
	select {
	case <-ctx.Done():
		return models.VisualDNA{}, ctx.Err()
	default:
	}
	return ParseVisualDNAResponse(provider.Response)
}

func ParseVisualDNAResponse(response []byte) (models.VisualDNA, error) {
	candidate := bytes.TrimSpace(response)
	if len(candidate) == 0 {
		return models.VisualDNA{}, ErrInvalidProviderRequest
	}
	if !bytes.HasPrefix(candidate, []byte("{")) {
		recovered, ok := extractJSONObject(candidate)
		if !ok {
			return models.VisualDNA{}, ErrInvalidProviderRequest
		}
		candidate = recovered
	}
	var fields map[string]json.RawMessage
	if err := json.Unmarshal(candidate, &fields); err != nil {
		return models.VisualDNA{}, fmt.Errorf("%w: malformed Visual DNA JSON", ErrInvalidProviderRequest)
	}
	if _, ok := fields["schema_version"]; !ok {
		return models.VisualDNA{}, fmt.Errorf("%w: schema_version is required", ErrInvalidProviderRequest)
	}
	for _, category := range []string{
		"subject", "composition", "lighting", "color_palette", "camera",
		"depth_of_field", "style", "mood", "background", "texture",
	} {
		raw, ok := fields[category]
		if !ok || !bytes.HasPrefix(bytes.TrimSpace(raw), []byte("{")) {
			return models.VisualDNA{}, fmt.Errorf("%w: category %q must be an object", ErrInvalidProviderRequest, category)
		}
	}
	var visualDNA models.VisualDNA
	if err := json.Unmarshal(candidate, &visualDNA); err != nil {
		return models.VisualDNA{}, fmt.Errorf("%w: malformed Visual DNA JSON", ErrInvalidProviderRequest)
	}
	if err := visualDNA.Validate(); err != nil {
		return models.VisualDNA{}, fmt.Errorf("%w: invalid Visual DNA: %v", ErrInvalidProviderRequest, err)
	}
	return visualDNA, nil
}

func extractJSONObject(response []byte) ([]byte, bool) {
	start := bytes.IndexByte(response, '{')
	end := bytes.LastIndexByte(response, '}')
	if start < 0 || end <= start {
		return nil, false
	}
	return bytes.TrimSpace(response[start : end+1]), true
}

type MockVisionProvider struct{}

func (MockVisionProvider) AnalyzeImage(_ context.Context, input VisionInput) (models.VisualDNA, error) {
	if len(input.ImageData) == 0 {
		return models.VisualDNA{}, ErrInvalidImage
	}
	data, err := json.Marshal(models.MockVisualDNA())
	if err != nil {
		return models.VisualDNA{}, err
	}
	return ParseVisualDNAResponse(data)
}

type MockImageGenerationProvider struct{}

type FakeImageGenerationProvider = MockImageGenerationProvider

func (MockImageGenerationProvider) GenerateImage(_ context.Context, input GenerationInput) (GeneratedImage, error) {
	if strings.TrimSpace(input.ProviderPrompt) == "" {
		return GeneratedImage{}, ErrInvalidProviderRequest
	}
	return GeneratedImage{
		ObjectKey:          "mock://visualkit/generated-image",
		ThumbnailObjectKey: "mock://visualkit/generated-thumbnail",
		MimeType:           "image/jpeg",
		Data:               []byte("mock-generated-image"),
		ThumbnailData:      []byte("mock-generated-thumbnail"),
		PixelWidth:         1024,
		PixelHeight:        1024,
	}, nil
}
