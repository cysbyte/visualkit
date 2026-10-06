package httpapi

import (
	"context"
	"crypto/subtle"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/visualkit/backend/internal/auth"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/middleware"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/pkg/api"
)

type Dependencies struct {
	Config   config.Config
	Logger   *slog.Logger
	Pool     *pgxpool.Pool
	Services services.Set
	Auth     auth.AuthProvider
}

type Server struct {
	config   config.Config
	logger   *slog.Logger
	pool     *pgxpool.Pool
	services services.Set
	auth     auth.AuthProvider
}

func NewServer(dependencies Dependencies) *Server {
	logger := dependencies.Logger
	if logger == nil {
		logger = slog.Default()
	}

	devUser := uuid.Nil
	if dependencies.Config.DevelopmentUserID != "" {
		devUser, _ = uuid.Parse(dependencies.Config.DevelopmentUserID)
	}
	if devUser == uuid.Nil && dependencies.Config.AuthMode == "development" {
		devUser = uuid.New()
	}
	authProvider := dependencies.Auth
	if authProvider == nil {
		authProvider = auth.ProviderForMode(dependencies.Config.AuthMode, devUser)
	}

	return &Server{
		config:   dependencies.Config,
		logger:   logger,
		pool:     dependencies.Pool,
		services: dependencies.Services,
		auth:     authProvider,
	}
}

func (server *Server) Handler() http.Handler {
	authenticated := middleware.AuthenticationMiddleware{
		Provider: server.auth,
		Users:    server.services.Users,
		Logger:   server.logger,
	}.Handler(server.logging(server.routes()))
	return server.requestID(authenticated)
}

func (server *Server) routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/health", server.health)
	mux.HandleFunc("/healthz", server.health)
	mux.HandleFunc("/ready", server.ready)
	mux.HandleFunc("/v1/templates", server.templates)
	mux.HandleFunc("/v1/image-assets", server.imageAssets)
	mux.HandleFunc("/v1/assets/upload-url", server.assetUploadURL)
	mux.HandleFunc("/v1/assets/", server.asset)
	mux.HandleFunc("/v1/image-analysis/jobs", server.analysisJobs)
	mux.HandleFunc("/v1/image-analysis", server.analysisJobs)
	mux.HandleFunc("/v1/image-generation/jobs", server.generationJobs)
	mux.HandleFunc("/v1/jobs/image-analysis", server.analysisJobs)
	mux.HandleFunc("/v1/jobs/image-generation", server.generationJobs)
	mux.HandleFunc("/v1/jobs/", server.job)
	mux.HandleFunc("/internal/jobs/", server.internalJob)
	mux.HandleFunc("/v1/styles", server.styles)
	mux.HandleFunc("/v1/styles/", server.style)
	mux.HandleFunc("/v1/creations", server.creations)
	mux.HandleFunc("/v1/creations/", server.creation)
	mux.HandleFunc("/v1/credits/balance", server.creditBalance)
	mux.HandleFunc("/v1/generation/estimate", server.generationEstimate)
	return mux
}

func (server *Server) health(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		server.methodNotAllowed(response)
		return
	}
	api.WriteData(response, http.StatusOK, map[string]string{"status": "ok"})
}

func (server *Server) ready(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		server.methodNotAllowed(response)
		return
	}
	if server.pool == nil || server.pool.Ping(request.Context()) != nil {
		api.WriteError(response, api.ErrUnavailable)
		return
	}
	api.WriteData(response, http.StatusOK, map[string]string{"status": "ready"})
}

func (server *Server) templates(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		server.methodNotAllowed(response)
		return
	}
	templates, err := server.services.Templates.List(request.Context())
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusOK, templates)
}

func (server *Server) imageAssets(response http.ResponseWriter, request *http.Request) {
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	switch request.Method {
	case http.MethodPost:
		var input services.CreateAssetInput
		if err := decodeJSON(response, request, &input); err != nil {
			server.handleError(response, err)
			return
		}
		asset, err := (services.AssetService{
			Users:  server.services.Users,
			Assets: server.services.Assets,
		}).Create(request.Context(), userID, input)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusCreated, asset)
	default:
		server.methodNotAllowed(response)
	}
}

func (server *Server) assetUploadURL(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		server.methodNotAllowed(response)
		return
	}
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	var input services.CreateAssetUploadInput
	if err := decodeJSON(response, request, &input); err != nil {
		server.handleError(response, err)
		return
	}
	asset, err := (services.AssetService{
		Users:   server.services.Users,
		Assets:  server.services.Assets,
		Storage: server.services.Storage,
		Config:  server.config,
	}).CreateUploadURL(request.Context(), userID, input)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusCreated, asset)
}

func (server *Server) asset(response http.ResponseWriter, request *http.Request) {
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	basePath := "/v1/assets/"
	rawPath := strings.TrimPrefix(request.URL.Path, basePath)
	parts := strings.Split(strings.TrimSuffix(rawPath, "/"), "/")
	if len(parts) != 2 || parts[0] == "" || parts[1] == "" {
		server.handleError(response, fmtErrorInvalid("asset route is invalid"))
		return
	}
	assetID, err := pathUUID(basePath+parts[0], basePath)
	if err != nil {
		server.handleError(response, err)
		return
	}
	service := services.AssetService{
		Users:   server.services.Users,
		Assets:  server.services.Assets,
		Storage: server.services.Storage,
		Config:  server.config,
	}
	switch {
	case request.Method == http.MethodPost && parts[1] == "complete":
		var input services.CompleteAssetUploadInput
		if err := decodeJSON(response, request, &input); err != nil {
			server.handleError(response, err)
			return
		}
		asset, completeErr := service.CompleteUpload(request.Context(), userID, assetID, input)
		if completeErr != nil {
			server.handleError(response, completeErr)
			return
		}
		api.WriteData(response, http.StatusOK, asset)
	case request.Method == http.MethodGet && parts[1] == "url":
		download, urlErr := service.CreateDownloadURL(request.Context(), userID, assetID)
		if urlErr != nil {
			server.handleError(response, urlErr)
			return
		}
		api.WriteData(response, http.StatusOK, download)
	default:
		server.methodNotAllowed(response)
	}
}

func (server *Server) analysisJobs(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		server.methodNotAllowed(response)
		return
	}
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	var input services.CreateAnalysisInput
	if err := decodeJSON(response, request, &input); err != nil {
		server.handleError(response, err)
		return
	}
	job, err := server.jobService().CreateAnalysisJob(
		request.Context(),
		userID,
		input,
		strings.TrimSpace(request.Header.Get("Idempotency-Key")),
	)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusAccepted, services.JobReference{
		JobID:  job.ID,
		Status: job.Status,
		Type:   job.Type,
	})
}

func (server *Server) generationJobs(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		server.methodNotAllowed(response)
		return
	}
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	var input services.CreateGenerationInput
	if err := decodeJSON(response, request, &input); err != nil {
		server.handleError(response, err)
		return
	}
	job, err := server.jobService().CreateGenerationJob(
		request.Context(),
		userID,
		input,
		strings.TrimSpace(request.Header.Get("Idempotency-Key")),
	)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusAccepted, services.JobReference{
		JobID:  job.ID,
		Status: job.Status,
		Type:   job.Type,
	})
}

func (server *Server) job(response http.ResponseWriter, request *http.Request) {
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	jobPath := strings.TrimPrefix(request.URL.Path, "/v1/jobs/")
	isCancel := strings.HasSuffix(jobPath, "/cancel")
	if isCancel {
		jobPath = strings.TrimSuffix(jobPath, "/cancel")
	}
	id, err := pathUUID("/v1/jobs/"+jobPath, "/v1/jobs/")
	if err != nil {
		server.handleError(response, err)
		return
	}
	switch {
	case request.Method == http.MethodGet && !isCancel:
		job, err := server.jobService().GetJob(request.Context(), userID, id)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusOK, jobResponse(job))
	case request.Method == http.MethodPost && isCancel:
		job, err := server.jobService().CancelJob(request.Context(), userID, id)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusOK, job)
	default:
		server.methodNotAllowed(response)
	}
}

func (server *Server) jobService() services.JobService {
	return services.JobService{
		Users:                server.services.Users,
		Assets:               server.services.Assets,
		Jobs:                 server.services.Jobs,
		Generations:          server.services.Generations,
		Templates:            server.services.Templates,
		Credits:              server.services.Credits,
		GenerationCreditCost: server.config.GenerationCreditCost,
		Queue:                server.services.Queue,
	}
}

func jobResponse(job models.Job) any {
	if job.Type == models.JobTypeImageAnalysis && job.Status == models.JobStatusCompleted {
		result := job.Output
		if result == nil {
			result = job.Result
		}
		if result == nil {
			result = map[string]any{}
		}
		return struct {
			ID           uuid.UUID      `json:"id"`
			Type         string         `json:"type"`
			Status       string         `json:"status"`
			Progress     int            `json:"progress,omitempty"`
			Result       map[string]any `json:"result"`
			ErrorCode    string         `json:"error_code,omitempty"`
			ErrorMessage string         `json:"error_message,omitempty"`
			CreatedAt    time.Time      `json:"created_at"`
			StartedAt    *time.Time     `json:"started_at,omitempty"`
			CompletedAt  *time.Time     `json:"completed_at,omitempty"`
			UpdatedAt    time.Time      `json:"updated_at"`
		}{
			ID:           job.ID,
			Type:         job.Type,
			Status:       job.Status,
			Progress:     job.Progress,
			Result:       result,
			ErrorCode:    job.ErrorCode,
			ErrorMessage: job.ErrorMessage,
			CreatedAt:    job.CreatedAt,
			StartedAt:    job.StartedAt,
			CompletedAt:  job.CompletedAt,
			UpdatedAt:    job.UpdatedAt,
		}
	}
	return job
}

func (server *Server) internalJob(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost || !strings.HasSuffix(request.URL.Path, "/status") {
		server.methodNotAllowed(response)
		return
	}
	expectedToken := strings.TrimSpace(server.config.InternalJobToken)
	providedToken := strings.TrimSpace(request.Header.Get("X-Internal-Token"))
	if server.config.AuthMode != "development" &&
		(expectedToken == "" ||
			providedToken == "" ||
			subtle.ConstantTimeCompare([]byte(providedToken), []byte(expectedToken)) != 1) {
		api.WriteError(response, api.ErrUnauthorized)
		return
	}
	id, err := pathUUID(strings.TrimSuffix(request.URL.Path, "/status"), "/internal/jobs/")
	if err != nil {
		server.handleError(response, err)
		return
	}
	var update services.JobStatusUpdate
	if err := decodeJSON(response, request, &update); err != nil {
		server.handleError(response, err)
		return
	}
	job, err := (services.JobService{
		Jobs: server.services.Jobs,
	}).UpdateStatus(request.Context(), id, update)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusOK, job)
}

func (server *Server) styles(response http.ResponseWriter, request *http.Request) {
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	service := services.StyleService{
		Users:   server.services.Users,
		Styles:  server.services.Styles,
		Assets:  server.services.Assets,
		Storage: server.services.Storage,
		Config:  server.config,
	}
	switch request.Method {
	case http.MethodGet:
		styles, err := service.List(request.Context(), userID)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusOK, styles)
	case http.MethodPost:
		var input services.CreateStyleInput
		if err := decodeJSON(response, request, &input); err != nil {
			server.handleError(response, err)
			return
		}
		created, err := service.Create(request.Context(), userID, input)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusCreated, created)
	default:
		server.methodNotAllowed(response)
	}
}

func (server *Server) style(response http.ResponseWriter, request *http.Request) {
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	id, err := pathUUID(request.URL.Path, "/v1/styles/")
	if err != nil {
		server.handleError(response, err)
		return
	}
	service := services.StyleService{
		Users:   server.services.Users,
		Styles:  server.services.Styles,
		Assets:  server.services.Assets,
		Storage: server.services.Storage,
		Config:  server.config,
	}
	switch request.Method {
	case http.MethodGet:
		style, err := service.Get(request.Context(), userID, id)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusOK, style)
	case http.MethodPatch, http.MethodPut:
		var input services.UpdateStyleInput
		if err := decodeJSON(response, request, &input); err != nil {
			server.handleError(response, err)
			return
		}
		updated, err := service.Update(request.Context(), userID, id, input)
		if err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusOK, updated)
	case http.MethodDelete:
		if err := service.Delete(request.Context(), userID, id); err != nil {
			server.handleError(response, err)
			return
		}
		api.WriteData(response, http.StatusOK, map[string]bool{"deleted": true})
	default:
		server.methodNotAllowed(response)
	}
}

func (server *Server) creations(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		server.methodNotAllowed(response)
		return
	}
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	limit, err := parseCreationLimit(request.URL.Query().Get("limit"))
	if err != nil {
		server.handleError(response, err)
		return
	}
	page, err := (services.CreationService{
		Creations: server.services.Creations,
		Assets:    server.services.Assets,
		Storage:   server.services.Storage,
		Config:    server.config,
	}).ListPage(
		request.Context(),
		userID,
		limit,
		request.URL.Query().Get("cursor"),
	)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusOK, page)
}

func (server *Server) creation(response http.ResponseWriter, request *http.Request) {
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	id, err := pathUUID(request.URL.Path, "/v1/creations/")
	if err != nil {
		server.handleError(response, err)
		return
	}
	service := services.CreationService{
		Creations: server.services.Creations,
		Assets:    server.services.Assets,
		Storage:   server.services.Storage,
		Config:    server.config,
	}
	switch request.Method {
	case http.MethodGet:
		creation, detailErr := service.Detail(request.Context(), userID, id)
		if detailErr != nil {
			server.handleError(response, detailErr)
			return
		}
		api.WriteData(response, http.StatusOK, creation)
	case http.MethodDelete:
		if deleteErr := service.Delete(request.Context(), userID, id); deleteErr != nil {
			server.handleError(response, deleteErr)
			return
		}
		api.WriteData(response, http.StatusOK, map[string]bool{"deleted": true})
	default:
		server.methodNotAllowed(response)
	}
}

func parseCreationLimit(raw string) (int, error) {
	if strings.TrimSpace(raw) == "" {
		return 0, nil
	}
	limit, err := strconv.Atoi(raw)
	if err != nil {
		return 0, errors.New("invalid request: limit must be an integer")
	}
	return limit, nil
}

func (server *Server) creditBalance(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		server.methodNotAllowed(response)
		return
	}
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	balance, err := (services.CreditService{
		Credits:              server.services.Credits,
		GenerationCreditCost: server.config.GenerationCreditCost,
	}).Balance(request.Context(), userID)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusOK, balance)
}

func (server *Server) generationEstimate(response http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		server.methodNotAllowed(response)
		return
	}
	userID, ok := server.userID(response, request)
	if !ok {
		return
	}
	templateID, err := uuid.Parse(strings.TrimSpace(request.URL.Query().Get("template_id")))
	if err != nil {
		server.handleError(response, fmtErrorInvalid("template_id must be a UUID"))
		return
	}
	estimate, err := (services.CreditService{
		Credits:              server.services.Credits,
		Templates:            server.services.Templates,
		GenerationCreditCost: server.config.GenerationCreditCost,
	}).Estimate(
		request.Context(),
		userID,
		templateID,
		request.URL.Query().Get("aspect_ratio"),
	)
	if err != nil {
		server.handleError(response, err)
		return
	}
	api.WriteData(response, http.StatusOK, estimate)
}

func (server *Server) userID(response http.ResponseWriter, request *http.Request) (uuid.UUID, bool) {
	userID, ok := auth.UserIDFromContext(request.Context())
	if !ok {
		server.handleError(response, api.ErrUnauthorized)
		return uuid.Nil, false
	}
	return userID, true
}

func decodeJSON(response http.ResponseWriter, request *http.Request, target any) error {
	request.Body = http.MaxBytesReader(response, request.Body, 2<<20)
	decoder := json.NewDecoder(request.Body)
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(target); err != nil {
		return fmtErrorInvalid("request body is invalid")
	}
	return nil
}

func pathUUID(path, prefix string) (uuid.UUID, error) {
	raw := strings.TrimPrefix(path, prefix)
	if raw == "" || strings.Contains(raw, "/") {
		return uuid.Nil, fmtErrorInvalid("resource id is invalid")
	}
	id, err := uuid.Parse(raw)
	if err != nil {
		return uuid.Nil, fmtErrorInvalid("resource id is invalid")
	}
	return id, nil
}

func fmtErrorInvalid(message string) error {
	return errors.New("invalid request: " + message)
}

func (server *Server) handleError(response http.ResponseWriter, err error) {
	server.logger.Error("request failed", slog.Any("error", err))
	api.WriteError(response, err)
}

func (server *Server) methodNotAllowed(response http.ResponseWriter) {
	api.WriteError(response, errors.New("invalid request: method not allowed"))
}

func (server *Server) logging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(response http.ResponseWriter, request *http.Request) {
		start := time.Now()
		requestID := requestIDFromContext(request.Context())
		next.ServeHTTP(response, request)
		attrs := []any{
			slog.String("method", request.Method),
			slog.String("path", request.URL.Path),
			slog.String("request_id", requestID),
			slog.Duration("duration", time.Since(start)),
		}
		if userID, ok := auth.UserIDFromContext(request.Context()); ok {
			attrs = append(attrs, slog.String("user_id", userID.String()))
		}
		server.logger.Info("http request", attrs...)
	})
}

func (server *Server) requestID(next http.Handler) http.Handler {
	return http.HandlerFunc(func(response http.ResponseWriter, request *http.Request) {
		requestID := strings.TrimSpace(request.Header.Get("X-Request-ID"))
		if requestID == "" {
			requestID = uuid.NewString()
		}
		response.Header().Set("X-Request-ID", requestID)
		next.ServeHTTP(response, request.WithContext(
			withRequestID(request.Context(), requestID),
		))
	})
}

type requestIDContextKey struct{}

func withRequestID(ctx context.Context, requestID string) context.Context {
	return context.WithValue(ctx, requestIDContextKey{}, requestID)
}

func requestIDFromContext(ctx context.Context) string {
	requestID, _ := ctx.Value(requestIDContextKey{}).(string)
	return requestID
}
