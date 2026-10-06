package httpapi

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
)

type stylesHTTPUsers struct{}

func (stylesHTTPUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	return models.User{ID: id}, nil
}

type stylesHTTPRepository struct {
	styles map[uuid.UUID]models.SavedStyle
}

func (repository *stylesHTTPRepository) List(
	_ context.Context,
	userID uuid.UUID,
) ([]models.SavedStyle, error) {
	result := make([]models.SavedStyle, 0)
	for _, style := range repository.styles {
		if style.UserID == userID {
			result = append(result, style)
		}
	}
	return result, nil
}

func (repository *stylesHTTPRepository) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.SavedStyle, error) {
	style, ok := repository.styles[id]
	if !ok || style.UserID != userID {
		return models.SavedStyle{}, database.ErrNotFound
	}
	return style, nil
}

func (repository *stylesHTTPRepository) Create(
	_ context.Context,
	style models.SavedStyle,
) (models.SavedStyle, error) {
	if style.ID == uuid.Nil {
		style.ID = uuid.New()
	}
	repository.styles[style.ID] = style
	return style, nil
}

func (repository *stylesHTTPRepository) Update(
	_ context.Context,
	style models.SavedStyle,
) (models.SavedStyle, error) {
	if _, ok := repository.styles[style.ID]; !ok {
		return models.SavedStyle{}, database.ErrNotFound
	}
	repository.styles[style.ID] = style
	return style, nil
}

func (repository *stylesHTTPRepository) Delete(
	_ context.Context,
	userID, id uuid.UUID,
) error {
	style, err := repository.Get(context.Background(), userID, id)
	if err != nil {
		return err
	}
	delete(repository.styles, style.ID)
	return nil
}

type stylesHTTPAssets struct{}

func (stylesHTTPAssets) Create(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (stylesHTTPAssets) Get(
	_ context.Context,
	userID, id uuid.UUID,
) (models.ImageAsset, error) {
	return models.ImageAsset{
		ID:     id,
		UserID: userID,
		Status: models.ImageAssetStatusReady,
		ObjectKey: "users/" + userID.String() +
			"/assets/" + id.String() + "/original",
	}, nil
}

func (stylesHTTPAssets) Update(context.Context, models.ImageAsset) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func (stylesHTTPAssets) SaveVisualDNA(
	context.Context,
	uuid.UUID,
	uuid.UUID,
	models.VisualDNA,
) (models.ImageAsset, error) {
	return models.ImageAsset{}, nil
}

func TestStylesHTTPRouteSupportsCreateListGetPatchAndDelete(t *testing.T) {
	userID := uuid.New()
	repository := &stylesHTTPRepository{styles: make(map[uuid.UUID]models.SavedStyle)}
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode:          "development",
			DevelopmentUserID: userID.String(),
		},
		Services: services.Set{
			Users:   stylesHTTPUsers{},
			Styles:  repository,
			Assets:  stylesHTTPAssets{},
			Storage: storage.NewMockObjectStorage(),
		},
	})

	createBody := bytes.NewBufferString(`{
		"name":"Warm Cinematic",
		"visual_dna":` + visualDNAJSON(t) + `
	}`)
	createResponse := serveStylesRequest(server, http.MethodPost, "/v1/styles", createBody)
	if createResponse.Code != http.StatusCreated {
		t.Fatalf("create status = %d: %s", createResponse.Code, createResponse.Body.String())
	}
	var createdEnvelope struct {
		Data models.SavedStyleResponse `json:"data"`
	}
	decodeResponse(t, createResponse, &createdEnvelope)
	styleID := createdEnvelope.Data.ID
	if styleID == uuid.Nil || createdEnvelope.Data.Name != "Warm Cinematic" {
		t.Fatalf("created style = %#v", createdEnvelope.Data)
	}

	listResponse := serveStylesRequest(server, http.MethodGet, "/v1/styles", nil)
	if listResponse.Code != http.StatusOK {
		t.Fatalf("list status = %d: %s", listResponse.Code, listResponse.Body.String())
	}
	var listEnvelope struct {
		Data []models.SavedStyleResponse `json:"data"`
	}
	decodeResponse(t, listResponse, &listEnvelope)
	if len(listEnvelope.Data) != 1 || listEnvelope.Data[0].ID != styleID {
		t.Fatalf("list = %#v", listEnvelope.Data)
	}

	patchBody := bytes.NewBufferString(`{"name":"Renamed Style"}`)
	patchResponse := serveStylesRequest(
		server,
		http.MethodPatch,
		"/v1/styles/"+styleID.String(),
		patchBody,
	)
	if patchResponse.Code != http.StatusOK {
		t.Fatalf("patch status = %d: %s", patchResponse.Code, patchResponse.Body.String())
	}
	var patchedEnvelope struct {
		Data models.SavedStyleResponse `json:"data"`
	}
	decodeResponse(t, patchResponse, &patchedEnvelope)
	if patchedEnvelope.Data.Name != "Renamed Style" {
		t.Fatalf("patched style = %#v", patchedEnvelope.Data)
	}

	clearPreviewResponse := serveStylesRequest(
		server,
		http.MethodPatch,
		"/v1/styles/"+styleID.String(),
		bytes.NewBufferString(`{"preview_asset_id":null}`),
	)
	if clearPreviewResponse.Code != http.StatusOK {
		t.Fatalf(
			"clear preview status = %d: %s",
			clearPreviewResponse.Code,
			clearPreviewResponse.Body.String(),
		)
	}
	var clearedEnvelope struct {
		Data models.SavedStyleResponse `json:"data"`
	}
	decodeResponse(t, clearPreviewResponse, &clearedEnvelope)
	if clearedEnvelope.Data.PreviewAssetID != nil ||
		clearedEnvelope.Data.PreviewImageURL != "" {
		t.Fatalf("cleared preview style = %#v", clearedEnvelope.Data)
	}

	getResponse := serveStylesRequest(
		server,
		http.MethodGet,
		"/v1/styles/"+styleID.String(),
		nil,
	)
	if getResponse.Code != http.StatusOK {
		t.Fatalf("get status = %d: %s", getResponse.Code, getResponse.Body.String())
	}

	deleteResponse := serveStylesRequest(
		server,
		http.MethodDelete,
		"/v1/styles/"+styleID.String(),
		nil,
	)
	if deleteResponse.Code != http.StatusOK {
		t.Fatalf("delete status = %d: %s", deleteResponse.Code, deleteResponse.Body.String())
	}
	if _, ok := repository.styles[styleID]; ok {
		t.Fatal("expected style to be deleted")
	}
}

func TestStylesHTTPRouteReturnsNotFoundForOtherUser(t *testing.T) {
	ownerID := uuid.New()
	otherUserID := uuid.New()
	styleID := uuid.New()
	repository := &stylesHTTPRepository{
		styles: map[uuid.UUID]models.SavedStyle{
			styleID: {
				ID:        styleID,
				UserID:    ownerID,
				Name:      "Private",
				VisualDNA: models.MockVisualDNA(),
			},
		},
	}
	server := NewServer(Dependencies{
		Config: config.Config{
			AuthMode:          "development",
			DevelopmentUserID: otherUserID.String(),
		},
		Services: services.Set{
			Users:   stylesHTTPUsers{},
			Styles:  repository,
			Assets:  stylesHTTPAssets{},
			Storage: storage.NewMockObjectStorage(),
		},
	})

	response := serveStylesRequest(
		server,
		http.MethodGet,
		"/v1/styles/"+styleID.String(),
		nil,
	)
	if response.Code != http.StatusNotFound {
		t.Fatalf("status = %d, want %d: %s", response.Code, http.StatusNotFound, response.Body.String())
	}
}

func serveStylesRequest(
	server *Server,
	method, path string,
	body *bytes.Buffer,
) *httptest.ResponseRecorder {
	var requestBody *bytes.Buffer
	if body == nil {
		requestBody = bytes.NewBuffer(nil)
	} else {
		requestBody = body
	}
	request := httptest.NewRequest(method, path, requestBody)
	response := httptest.NewRecorder()
	server.Handler().ServeHTTP(response, request)
	return response
}

func visualDNAJSON(t *testing.T) string {
	t.Helper()
	data, err := json.Marshal(models.MockVisualDNA())
	if err != nil {
		t.Fatal(err)
	}
	return string(data)
}

func decodeResponse(t *testing.T, response *httptest.ResponseRecorder, target any) {
	t.Helper()
	if err := json.Unmarshal(response.Body.Bytes(), target); err != nil {
		t.Fatalf("decode response: %v; body=%s", err, response.Body.String())
	}
}

var _ repositories.SavedStyleRepository = (*stylesHTTPRepository)(nil)
var _ repositories.ImageAssetRepository = stylesHTTPAssets{}
