package providers

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/models"
)

func TestHTTPImageGenerationProviderSuccessAndReferenceForwarding(t *testing.T) {
	var received httpGenerationRequest
	client := &http.Client{Transport: roundTripFunc(func(request *http.Request) (*http.Response, error) {
		if request.Header.Get("Authorization") != "Bearer secret" {
			t.Fatalf("authorization header was not forwarded")
		}
		if err := json.NewDecoder(request.Body).Decode(&received); err != nil {
			t.Fatalf("decode request: %v", err)
		}
		body, err := json.Marshal(httpGenerationResponse{
			ImageBase64:     base64.StdEncoding.EncodeToString([]byte("generated-image")),
			ThumbnailBase64: base64.StdEncoding.EncodeToString([]byte("generated-thumbnail")),
			MimeType:        "image/png",
			PixelWidth:      800,
			PixelHeight:     1000,
		})
		if err != nil {
			return nil, err
		}
		return &http.Response{
			StatusCode: http.StatusOK,
			Body:       io.NopCloser(strings.NewReader(string(body))),
			Header:     make(http.Header),
		}, nil
	})}

	templateID := uuid.New()
	provider := HTTPImageGenerationProvider{
		Endpoint: "https://provider.test/generate",
		APIKey:   "secret",
		Client:   client,
	}
	visualDNA := models.MockVisualDNA()
	result, err := provider.GenerateImage(context.Background(), GenerationInput{
		Intent: models.GenerationIntent{
			OriginalPrompt:   "A woman in Paris",
			TemplateID:       templateID,
			TemplateName:     "Editorial",
			TemplateCategory: "editorial",
			PromptDirectives: []string{"art-directed composition"},
			VisualDNA:        &visualDNA,
			Preservation:     models.PreservationSettings{Style: true},
			GenerationSettings: models.GenerationSettings{
				AspectRatio: "4:5",
			},
		},
		ProviderPrompt: "A woman in Paris\n\nTemplate directives: art-directed composition",
		ReferenceImage: &ReferenceImage{
			AssetID:  "asset-1",
			MimeType: "image/jpeg",
			Data:     []byte("reference-image"),
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	if string(result.Data) != "generated-image" || string(result.ThumbnailData) != "generated-thumbnail" {
		t.Fatalf("generated result = %#v", result)
	}
	if received.Prompt == "" || received.AspectRatio != "4:5" {
		t.Fatalf("provider request = %#v", received)
	}
	if received.ReferenceImage == nil || received.ReferenceImage.DataBase64 != base64.StdEncoding.EncodeToString([]byte("reference-image")) {
		t.Fatalf("reference image was not forwarded: %#v", received.ReferenceImage)
	}
}

func TestHTTPImageGenerationProviderTimeout(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()
	_, err := (HTTPImageGenerationProvider{
		Endpoint: "https://provider.test/generate",
		Client: &http.Client{Transport: roundTripFunc(func(request *http.Request) (*http.Response, error) {
			<-request.Context().Done()
			return nil, request.Context().Err()
		})},
	}).GenerateImage(ctx, GenerationInput{ProviderPrompt: "prompt"})
	if !errors.Is(err, context.DeadlineExceeded) {
		t.Fatalf("error = %v, want deadline exceeded", err)
	}
}

func TestHTTPImageGenerationProviderClassifiesHTTPFailures(t *testing.T) {
	tests := []struct {
		status    int
		retryable bool
	}{
		{status: http.StatusBadRequest, retryable: false},
		{status: http.StatusTooManyRequests, retryable: true},
		{status: http.StatusBadGateway, retryable: true},
	}
	for _, test := range tests {
		t.Run(strings.ReplaceAll(http.StatusText(test.status), " ", "_"), func(t *testing.T) {
			_, err := (HTTPImageGenerationProvider{
				Endpoint: "https://provider.test/generate",
				Client: &http.Client{Transport: roundTripFunc(func(_ *http.Request) (*http.Response, error) {
					return &http.Response{
						StatusCode: test.status,
						Body:       io.NopCloser(strings.NewReader(`{"error":"provider failure"}`)),
						Header:     make(http.Header),
					}, nil
				})},
			}).GenerateImage(context.Background(), GenerationInput{ProviderPrompt: "prompt"})
			var providerError *ProviderError
			if !errors.As(err, &providerError) || providerError.Retryable != test.retryable {
				t.Fatalf("error = %#v, want retryable=%t", err, test.retryable)
			}
		})
	}
}

func TestOpenAIImageGenerationProviderParsesBase64Response(t *testing.T) {
	var received openAIImageGenerationRequest
	client := &http.Client{Transport: roundTripFunc(func(request *http.Request) (*http.Response, error) {
		if request.Header.Get("Authorization") != "Bearer secret" {
			t.Fatalf("authorization header was not forwarded")
		}
		if err := json.NewDecoder(request.Body).Decode(&received); err != nil {
			t.Fatalf("decode request: %v", err)
		}
		body := `{"data":[{"b64_json":"` + base64.StdEncoding.EncodeToString([]byte("generated-image")) + `"}]}`
		return &http.Response{
			StatusCode: http.StatusOK,
			Body:       io.NopCloser(strings.NewReader(body)),
			Header:     make(http.Header),
		}, nil
	})}
	result, err := (OpenAIImageGenerationProvider{
		Endpoint: "https://api.test/v1/images/generations",
		Model:    "test-image-model",
		APIKey:   "secret",
		Client:   client,
	}).GenerateImage(context.Background(), GenerationInput{
		Intent: models.GenerationIntent{
			GenerationSettings: models.GenerationSettings{AspectRatio: "1:1"},
		},
		ProviderPrompt: "A product photo",
	})
	if err != nil {
		t.Fatal(err)
	}
	if string(result.Data) != "generated-image" {
		t.Fatalf("generated image = %q", result.Data)
	}
	if received.Model != "test-image-model" || received.Prompt != "A product photo" || received.ResponseFormat != "b64_json" {
		t.Fatalf("provider request = %#v", received)
	}
}

func TestHTTPVisionProviderParsesStructuredResponse(t *testing.T) {
	visualDNA := models.MockVisualDNA()
	payload, err := json.Marshal(map[string]any{"visual_dna": visualDNA})
	if err != nil {
		t.Fatal(err)
	}
	provider := HTTPVisionProvider{
		Endpoint: "https://vision.test/analyze",
		APIKey:   "secret",
		Client: &http.Client{Transport: roundTripFunc(func(request *http.Request) (*http.Response, error) {
			if request.Header.Get("Authorization") != "Bearer secret" {
				t.Fatal("authorization header was not forwarded")
			}
			return &http.Response{
				StatusCode: http.StatusOK,
				Body:       io.NopCloser(strings.NewReader(string(payload))),
				Header:     make(http.Header),
			}, nil
		})},
	}
	result, err := provider.AnalyzeImage(context.Background(), VisionInput{
		AssetObjectKey: "reference-key",
		MimeType:       "image/jpeg",
		ImageData:      []byte("image"),
		Prompt:         VisionAnalysisPrompt,
	})
	if err != nil {
		t.Fatal(err)
	}
	if result.Style.Attributes[0] != visualDNA.Style.Attributes[0] {
		t.Fatalf("style = %#v, want %#v", result.Style.Attributes, visualDNA.Style.Attributes)
	}
}

type roundTripFunc func(*http.Request) (*http.Response, error)

func (function roundTripFunc) RoundTrip(request *http.Request) (*http.Response, error) {
	return function(request)
}
