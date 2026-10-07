package repositories

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
)

type Set struct {
	Users       UserRepository
	Assets      ImageAssetRepository
	Templates   TemplateRepository
	Styles      SavedStyleRepository
	Jobs        JobRepository
	Creations   CreationRepository
	Generations GenerationRepository
	Credits     CreditRepository
}

func NewSet(pool *pgxpool.Pool) Set {
	return Set{
		Users:       postgresUsers{pool: pool},
		Assets:      postgresAssets{pool: pool},
		Templates:   postgresTemplates{pool: pool},
		Styles:      postgresStyles{pool: pool},
		Jobs:        postgresJobs{pool: pool},
		Creations:   postgresCreations{pool: pool},
		Generations: postgresGenerations{pool: pool},
		Credits:     postgresCredits{pool: pool},
	}
}

type UserRepository interface {
	Ensure(ctx context.Context, id uuid.UUID) (models.User, error)
}

type ImageAssetRepository interface {
	Create(ctx context.Context, asset models.ImageAsset) (models.ImageAsset, error)
	Get(ctx context.Context, userID, id uuid.UUID) (models.ImageAsset, error)
	Update(ctx context.Context, asset models.ImageAsset) (models.ImageAsset, error)
	SaveVisualDNA(ctx context.Context, userID, assetID uuid.UUID, visualDNA models.VisualDNA) (models.ImageAsset, error)
}

type ImageAssetDeleter interface {
	Delete(ctx context.Context, userID, id uuid.UUID) error
}

type TemplateRepository interface {
	List(ctx context.Context) ([]models.Template, error)
	Get(ctx context.Context, id uuid.UUID) (models.Template, error)
}

type SavedStyleRepository interface {
	List(ctx context.Context, userID uuid.UUID) ([]models.SavedStyle, error)
	Get(ctx context.Context, userID, id uuid.UUID) (models.SavedStyle, error)
	Create(ctx context.Context, style models.SavedStyle) (models.SavedStyle, error)
	Update(ctx context.Context, style models.SavedStyle) (models.SavedStyle, error)
	Delete(ctx context.Context, userID, id uuid.UUID) error
}

type JobRepository interface {
	Create(ctx context.Context, job models.Job) (models.Job, error)
	Get(ctx context.Context, userID, id uuid.UUID) (models.Job, error)
	GetByID(ctx context.Context, id uuid.UUID) (models.Job, error)
	GetByIdempotencyKey(ctx context.Context, userID uuid.UUID, idempotencyKey string) (models.Job, error)
	ClaimProcessing(ctx context.Context, id uuid.UUID, attempt int) (models.Job, bool, error)
	Update(ctx context.Context, job models.Job) (models.Job, error)
}

type CreationRepository interface {
	List(ctx context.Context, userID uuid.UUID) ([]models.Creation, error)
	Get(ctx context.Context, userID, id uuid.UUID) (models.Creation, error)
	Create(ctx context.Context, creation models.Creation) (models.Creation, error)
	Update(ctx context.Context, creation models.Creation) (models.Creation, error)
}

type PaginatedCreationRepository interface {
	ListPage(
		ctx context.Context,
		userID uuid.UUID,
		limit int,
		before *models.CreationCursor,
	) ([]models.Creation, bool, error)
}

type CreationDeleter interface {
	Delete(ctx context.Context, userID, id uuid.UUID) error
}

type GenerationRepository interface {
	Create(ctx context.Context, generation models.Generation) (models.Generation, error)
}

type CreditRepository interface {
	Balance(ctx context.Context, userID uuid.UUID) (int, error)
	Append(ctx context.Context, entry models.CreditLedgerEntry) error
	Reserve(ctx context.Context, userID uuid.UUID, referenceType string, referenceID uuid.UUID, amount int) error
	Consume(ctx context.Context, userID uuid.UUID, referenceType string, referenceID uuid.UUID) error
	Refund(ctx context.Context, userID uuid.UUID, referenceType string, referenceID uuid.UUID) error
}

type postgresUsers struct{ pool *pgxpool.Pool }

func (repository postgresUsers) Ensure(ctx context.Context, id uuid.UUID) (models.User, error) {
	now := time.Now().UTC()
	transaction, err := repository.pool.Begin(ctx)
	if err != nil {
		return models.User{}, fmt.Errorf("begin ensure user: %w", err)
	}
	defer transaction.Rollback(ctx)
	_, err = transaction.Exec(ctx, `
		INSERT INTO users (id, created_at, updated_at)
		VALUES ($1, $2, $2)
		ON CONFLICT (id) DO UPDATE SET updated_at = EXCLUDED.updated_at
	`, id, now)
	if err != nil {
		return models.User{}, fmt.Errorf("ensure user: %w", err)
	}
	_, err = transaction.Exec(ctx, `
		INSERT INTO credit_ledger (
			id, user_id, type, reference_type, metadata,
			amount, reason, created_at
		) VALUES ($1,$2,$3,$4,$5,$6,$3,$7)
		ON CONFLICT DO NOTHING
	`, uuid.New(), id, models.CreditLedgerTypeSubscriptionGrant, "initial_grant",
		[]byte(`{"grant":"initial"}`), 100, now)
	if err != nil {
		return models.User{}, fmt.Errorf("grant initial credits: %w", err)
	}
	if err := transaction.Commit(ctx); err != nil {
		return models.User{}, fmt.Errorf("commit ensure user: %w", err)
	}
	return models.User{ID: id, CreatedAt: now, UpdatedAt: now}, nil
}

type postgresAssets struct{ pool *pgxpool.Pool }

func (repository postgresAssets) Create(ctx context.Context, asset models.ImageAsset) (models.ImageAsset, error) {
	if asset.ID == uuid.Nil {
		asset.ID = uuid.New()
	}
	if asset.CreatedAt.IsZero() {
		asset.CreatedAt = time.Now().UTC()
	}
	asset.UpdatedAt = asset.CreatedAt
	_, err := repository.pool.Exec(ctx, `
		INSERT INTO image_assets (
			id, user_id, object_key, filename, mime_type, byte_size,
			pixel_width, pixel_height, status, visual_dna, created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$11)
	`, asset.ID, asset.UserID, asset.ObjectKey, asset.Filename, asset.MimeType,
		asset.ByteSize, asset.PixelWidth, asset.PixelHeight, asset.Status, nil, asset.CreatedAt)
	if err != nil {
		return models.ImageAsset{}, fmt.Errorf("create image asset: %w", err)
	}
	return asset, nil
}

func (repository postgresAssets) Get(ctx context.Context, userID, id uuid.UUID) (models.ImageAsset, error) {
	var asset models.ImageAsset
	var visualDNA []byte
	err := repository.pool.QueryRow(ctx, `
		SELECT id, user_id, object_key, filename, mime_type, byte_size,
		       pixel_width, pixel_height, status, visual_dna, created_at, updated_at
		FROM image_assets WHERE id = $1 AND user_id = $2
	`, id, userID).Scan(
		&asset.ID, &asset.UserID, &asset.ObjectKey, &asset.Filename,
		&asset.MimeType, &asset.ByteSize, &asset.PixelWidth, &asset.PixelHeight,
		&asset.Status, &visualDNA, &asset.CreatedAt, &asset.UpdatedAt,
	)
	if err != nil {
		return models.ImageAsset{}, normalizeNotFound(err, "image asset")
	}
	if len(visualDNA) > 0 && string(visualDNA) != "null" {
		asset.VisualDNA = &models.VisualDNA{}
		if err := json.Unmarshal(visualDNA, asset.VisualDNA); err != nil {
			return models.ImageAsset{}, fmt.Errorf("decode image asset visual DNA: %w", err)
		}
	}
	return asset, nil
}

func (repository postgresAssets) Update(ctx context.Context, asset models.ImageAsset) (models.ImageAsset, error) {
	asset.UpdatedAt = time.Now().UTC()
	visualDNA, err := json.Marshal(asset.VisualDNA)
	if err != nil {
		return models.ImageAsset{}, fmt.Errorf("encode image asset visual DNA: %w", err)
	}
	result, err := repository.pool.Exec(ctx, `
		UPDATE image_assets
		SET object_key = $1, filename = $2, mime_type = $3, byte_size = $4,
		    pixel_width = $5, pixel_height = $6, status = $7, visual_dna = $8, updated_at = $9
		WHERE id = $10 AND user_id = $11
	`, asset.ObjectKey, asset.Filename, asset.MimeType, asset.ByteSize,
		asset.PixelWidth, asset.PixelHeight, asset.Status, visualDNA, asset.UpdatedAt,
		asset.ID, asset.UserID)
	if err != nil {
		return models.ImageAsset{}, fmt.Errorf("update image asset: %w", err)
	}
	if result.RowsAffected() == 0 {
		return models.ImageAsset{}, normalizeNotFound(pgx.ErrNoRows, "image asset")
	}
	return asset, nil
}

func (repository postgresAssets) Delete(ctx context.Context, userID, id uuid.UUID) error {
	result, err := repository.pool.Exec(ctx,
		`DELETE FROM image_assets WHERE id = $1 AND user_id = $2`,
		id, userID,
	)
	if err != nil {
		return fmt.Errorf("delete image asset: %w", err)
	}
	if result.RowsAffected() == 0 {
		return normalizeNotFound(pgx.ErrNoRows, "image asset")
	}
	return nil
}

func (repository postgresAssets) SaveVisualDNA(
	ctx context.Context,
	userID, assetID uuid.UUID,
	visualDNA models.VisualDNA,
) (models.ImageAsset, error) {
	if err := visualDNA.Validate(); err != nil {
		return models.ImageAsset{}, fmt.Errorf("validate visual DNA: %w", err)
	}
	encoded, err := json.Marshal(visualDNA)
	if err != nil {
		return models.ImageAsset{}, fmt.Errorf("encode visual DNA: %w", err)
	}
	result, err := repository.pool.Exec(ctx, `
		UPDATE image_assets SET visual_dna = $1, updated_at = NOW()
		WHERE id = $2 AND user_id = $3
	`, encoded, assetID, userID)
	if err != nil {
		return models.ImageAsset{}, fmt.Errorf("save visual DNA: %w", err)
	}
	if result.RowsAffected() == 0 {
		return models.ImageAsset{}, normalizeNotFound(pgx.ErrNoRows, "image asset")
	}
	return repository.Get(ctx, userID, assetID)
}

type postgresTemplates struct{ pool *pgxpool.Pool }

const templateSelectColumns = `
	id, slug, name, description, category, prompt_directives,
	default_settings, preview_asset_id, is_active,
	source_case_id, source_label, source_url, github_url, source_image_path, image_alt,
	styles, scenes, featured,
	prompt_instructions, recommended_aspect_ratio, generation_settings,
	thumbnail_url, created_at, updated_at
`

const joinedTemplateSelectColumns = `
	t.id, t.slug, t.name, t.description, t.category,
	t.prompt_directives, t.default_settings, t.preview_asset_id, t.is_active,
	t.source_case_id, t.source_label, t.source_url, t.github_url, t.source_image_path, t.image_alt,
	t.styles, t.scenes, t.featured,
	t.prompt_instructions, t.recommended_aspect_ratio,
	t.generation_settings, t.thumbnail_url, t.created_at, t.updated_at
`

func (repository postgresTemplates) List(ctx context.Context) ([]models.Template, error) {
	rows, err := repository.pool.Query(ctx,
		`SELECT `+templateSelectColumns+`
		FROM templates WHERE is_active = TRUE
		ORDER BY
			(thumbnail_url <> '') DESC,
			featured DESC,
			source_case_id DESC NULLS LAST,
			name`,
	)
	if err != nil {
		return nil, fmt.Errorf("list templates: %w", err)
	}
	defer rows.Close()

	var templates []models.Template
	for rows.Next() {
		template, scanErr := scanTemplate(rows)
		if scanErr != nil {
			return nil, scanErr
		}
		templates = append(templates, template)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate templates: %w", err)
	}
	return templates, nil
}

func (repository postgresTemplates) Get(ctx context.Context, id uuid.UUID) (models.Template, error) {
	row := repository.pool.QueryRow(ctx,
		`SELECT `+templateSelectColumns+`
		FROM templates WHERE id = $1 AND is_active = TRUE`,
		id,
	)
	template, err := scanTemplate(row)
	if err != nil {
		return models.Template{}, normalizeNotFound(err, "template")
	}
	return template, nil
}

type rowScanner interface {
	Scan(dest ...any) error
}

func scanTemplate(row rowScanner) (models.Template, error) {
	var template models.Template
	var promptDirectives, defaultSettings, styles, scenes, generationSettings []byte
	err := row.Scan(
		&template.ID, &template.Slug, &template.Name, &template.Description,
		&template.Category, &promptDirectives, &defaultSettings,
		&template.PreviewAssetID, &template.IsActive,
		&template.SourceCaseID, &template.SourceLabel, &template.SourceURL,
		&template.GitHubURL, &template.SourceImagePath, &template.ImageAlt, &styles, &scenes,
		&template.Featured,
		&template.PromptInstructions, &template.RecommendedAspectRatio,
		&generationSettings, &template.ThumbnailURL, &template.CreatedAt,
		&template.UpdatedAt,
	)
	if err != nil {
		return models.Template{}, err
	}
	if len(promptDirectives) > 0 {
		if err := json.Unmarshal(promptDirectives, &template.PromptDirectives); err != nil {
			return models.Template{}, fmt.Errorf("decode template prompt directives: %w", err)
		}
	}
	if len(defaultSettings) > 0 {
		if err := json.Unmarshal(defaultSettings, &template.DefaultSettings); err != nil {
			return models.Template{}, fmt.Errorf("decode template default settings: %w", err)
		}
	}
	if len(styles) > 0 {
		if err := json.Unmarshal(styles, &template.Styles); err != nil {
			return models.Template{}, fmt.Errorf("decode template styles: %w", err)
		}
	}
	if len(scenes) > 0 {
		if err := json.Unmarshal(scenes, &template.Scenes); err != nil {
			return models.Template{}, fmt.Errorf("decode template scenes: %w", err)
		}
	}
	if len(generationSettings) > 0 {
		if err := json.Unmarshal(generationSettings, &template.GenerationSettings); err != nil {
			return models.Template{}, fmt.Errorf("decode template generation settings: %w", err)
		}
	}
	return template, nil
}

type postgresStyles struct{ pool *pgxpool.Pool }

func (repository postgresStyles) List(ctx context.Context, userID uuid.UUID) ([]models.SavedStyle, error) {
	rows, err := repository.pool.Query(ctx, `
		SELECT id, user_id, name, preview_asset_id, visual_dna, created_at, updated_at
		FROM saved_styles WHERE user_id = $1 ORDER BY created_at DESC
	`, userID)
	if err != nil {
		return nil, fmt.Errorf("list saved styles: %w", err)
	}
	defer rows.Close()

	var styles []models.SavedStyle
	for rows.Next() {
		var style models.SavedStyle
		var visualDNA []byte
		if err := rows.Scan(
			&style.ID, &style.UserID, &style.Name, &style.PreviewAssetID,
			&visualDNA, &style.CreatedAt, &style.UpdatedAt,
		); err != nil {
			return nil, fmt.Errorf("scan saved style: %w", err)
		}
		if err := json.Unmarshal(visualDNA, &style.VisualDNA); err != nil {
			return nil, fmt.Errorf("decode saved style visual DNA: %w", err)
		}
		styles = append(styles, style)
	}
	return styles, rows.Err()
}

func (repository postgresStyles) Get(ctx context.Context, userID, id uuid.UUID) (models.SavedStyle, error) {
	var style models.SavedStyle
	var visualDNA []byte
	err := repository.pool.QueryRow(ctx, `
		SELECT id, user_id, name, preview_asset_id, visual_dna, created_at, updated_at
		FROM saved_styles
		WHERE user_id = $1 AND id = $2
	`, userID, id).Scan(
		&style.ID, &style.UserID, &style.Name, &style.PreviewAssetID,
		&visualDNA, &style.CreatedAt, &style.UpdatedAt,
	)
	if err != nil {
		return models.SavedStyle{}, normalizeNotFound(err, "saved style")
	}
	if err := json.Unmarshal(visualDNA, &style.VisualDNA); err != nil {
		return models.SavedStyle{}, fmt.Errorf("decode saved style visual DNA: %w", err)
	}
	return style, nil
}

func (repository postgresStyles) Create(ctx context.Context, style models.SavedStyle) (models.SavedStyle, error) {
	return repository.save(ctx, style, false)
}

func (repository postgresStyles) Update(ctx context.Context, style models.SavedStyle) (models.SavedStyle, error) {
	return repository.save(ctx, style, true)
}

func (repository postgresStyles) save(ctx context.Context, style models.SavedStyle, update bool) (models.SavedStyle, error) {
	if err := style.VisualDNA.Validate(); err != nil {
		return models.SavedStyle{}, fmt.Errorf("validate visual DNA: %w", err)
	}
	if style.ID == uuid.Nil {
		style.ID = uuid.New()
	}
	if style.CreatedAt.IsZero() {
		style.CreatedAt = time.Now().UTC()
	}
	style.UpdatedAt = time.Now().UTC()
	visualDNA, err := json.Marshal(style.VisualDNA)
	if err != nil {
		return models.SavedStyle{}, fmt.Errorf("encode visual DNA: %w", err)
	}

	var query string
	if update {
		query = `
			UPDATE saved_styles SET name = $1, preview_asset_id = $2,
			    visual_dna = $3, updated_at = $4
			WHERE id = $5 AND user_id = $6
		`
		result, execErr := repository.pool.Exec(ctx, query, style.Name, style.PreviewAssetID,
			visualDNA, style.UpdatedAt, style.ID, style.UserID)
		err = execErr
		if err == nil && result.RowsAffected() == 0 {
			return models.SavedStyle{}, normalizeNotFound(pgx.ErrNoRows, "saved style")
		}
	} else {
		query = `
			INSERT INTO saved_styles
			    (id, user_id, name, preview_asset_id, visual_dna, created_at, updated_at)
			VALUES ($1,$2,$3,$4,$5,$6,$6)
		`
		_, err = repository.pool.Exec(ctx, query, style.ID, style.UserID, style.Name,
			style.PreviewAssetID, visualDNA, style.CreatedAt)
	}
	if err != nil {
		return models.SavedStyle{}, fmt.Errorf("save style: %w", err)
	}
	return style, nil
}

func (repository postgresStyles) Delete(ctx context.Context, userID, id uuid.UUID) error {
	result, err := repository.pool.Exec(ctx,
		`DELETE FROM saved_styles WHERE id = $1 AND user_id = $2`, id, userID)
	if err != nil {
		return fmt.Errorf("delete saved style: %w", err)
	}
	if result.RowsAffected() == 0 {
		return normalizeNotFound(pgx.ErrNoRows, "saved style")
	}
	return nil
}

type postgresJobs struct{ pool *pgxpool.Pool }

func (repository postgresJobs) Create(ctx context.Context, job models.Job) (models.Job, error) {
	if job.ID == uuid.Nil {
		job.ID = uuid.New()
	}
	if job.CreatedAt.IsZero() {
		job.CreatedAt = time.Now().UTC()
	}
	job.UpdatedAt = job.CreatedAt
	if job.Type == "" {
		job.Type = job.Kind
	}
	if job.Kind == "" {
		job.Kind = job.Type
	}
	if job.Input == nil {
		job.Input = job.Request
	}
	if job.Request == nil {
		job.Request = job.Input
	}
	if job.Output == nil {
		job.Output = job.Result
	}
	if job.Result == nil {
		job.Result = job.Output
	}
	if job.Status == "" {
		job.Status = models.JobStatusQueued
	}
	if job.Attempts < 1 {
		job.Attempts = 1
	}
	result, err := json.Marshal(job.Output)
	if err != nil {
		return models.Job{}, fmt.Errorf("encode job result: %w", err)
	}
	request, err := json.Marshal(job.Input)
	if err != nil {
		return models.Job{}, fmt.Errorf("encode job request: %w", err)
	}
	_, err = repository.pool.Exec(ctx, `
		INSERT INTO jobs (
		    id, user_id, type, kind, status, progress, input, output, request, result,
		    error_code, error_message, attempts, idempotency_key, started_at,
		    completed_at, created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$7,$8,$9,$10,$11,$12,$13,$14,$15,$15)
	`, job.ID, job.UserID, job.Type, job.Kind, job.Status, job.Progress,
		request, result, job.ErrorCode, job.ErrorMessage, job.Attempts,
		job.IdempotencyKey, job.StartedAt, job.CompletedAt, job.CreatedAt)
	if err != nil {
		return models.Job{}, fmt.Errorf("create job: %w", err)
	}
	return job, nil
}

func (repository postgresJobs) Get(ctx context.Context, userID, id uuid.UUID) (models.Job, error) {
	var job models.Job
	var input, output, request, result []byte
	err := repository.pool.QueryRow(ctx, `
		SELECT id, user_id, type, kind, status, progress, input, output, request, result,
		       error_code, error_message, attempts, idempotency_key, started_at,
		       completed_at, created_at, updated_at
		FROM jobs WHERE id = $1 AND user_id = $2
	`, id, userID).Scan(
		&job.ID, &job.UserID, &job.Type, &job.Kind, &job.Status, &job.Progress,
		&input, &output, &request, &result, &job.ErrorCode, &job.ErrorMessage,
		&job.Attempts, &job.IdempotencyKey, &job.StartedAt, &job.CompletedAt,
		&job.CreatedAt, &job.UpdatedAt,
	)
	if err != nil {
		return models.Job{}, normalizeNotFound(err, "job")
	}
	decodeJobJSON(&job, input, output, request, result)
	return job, nil
}

func (repository postgresJobs) GetByID(ctx context.Context, id uuid.UUID) (models.Job, error) {
	var job models.Job
	var input, output, request, result []byte
	err := repository.pool.QueryRow(ctx, `
		SELECT id, user_id, type, kind, status, progress, input, output, request, result,
		       error_code, error_message, attempts, idempotency_key, started_at,
		       completed_at, created_at, updated_at
		FROM jobs WHERE id = $1
	`, id).Scan(
		&job.ID, &job.UserID, &job.Type, &job.Kind, &job.Status, &job.Progress,
		&input, &output, &request, &result, &job.ErrorCode, &job.ErrorMessage,
		&job.Attempts, &job.IdempotencyKey, &job.StartedAt, &job.CompletedAt,
		&job.CreatedAt, &job.UpdatedAt,
	)
	if err != nil {
		return models.Job{}, normalizeNotFound(err, "job")
	}
	decodeJobJSON(&job, input, output, request, result)
	return job, nil
}

func (repository postgresJobs) GetByIdempotencyKey(
	ctx context.Context,
	userID uuid.UUID,
	idempotencyKey string,
) (models.Job, error) {
	var job models.Job
	var input, output, request, result []byte
	err := repository.pool.QueryRow(ctx, `
		SELECT id, user_id, type, kind, status, progress, input, output, request, result,
		       error_code, error_message, attempts, idempotency_key, started_at,
		       completed_at, created_at, updated_at
		FROM jobs WHERE user_id = $1 AND idempotency_key = $2
	`, userID, idempotencyKey).Scan(
		&job.ID, &job.UserID, &job.Type, &job.Kind, &job.Status, &job.Progress,
		&input, &output, &request, &result, &job.ErrorCode, &job.ErrorMessage,
		&job.Attempts, &job.IdempotencyKey, &job.StartedAt, &job.CompletedAt,
		&job.CreatedAt, &job.UpdatedAt,
	)
	if err != nil {
		return models.Job{}, normalizeNotFound(err, "job")
	}
	decodeJobJSON(&job, input, output, request, result)
	return job, nil
}

func (repository postgresJobs) ClaimProcessing(
	ctx context.Context,
	id uuid.UUID,
	attempt int,
) (models.Job, bool, error) {
	if attempt < 1 {
		attempt = 1
	}
	result, err := repository.pool.Exec(ctx, `
		UPDATE jobs
		SET status = $1,
		    attempts = GREATEST(attempts, $2),
		    started_at = COALESCE(started_at, NOW()),
		    updated_at = NOW()
		WHERE id = $3 AND status = $4
	`, models.JobStatusProcessing, attempt, id, models.JobStatusQueued)
	if err != nil {
		return models.Job{}, false, fmt.Errorf("claim job for processing: %w", err)
	}
	job, getErr := repository.GetByID(ctx, id)
	if getErr != nil {
		return models.Job{}, false, getErr
	}
	return job, result.RowsAffected() > 0, nil
}

func (repository postgresJobs) Update(ctx context.Context, job models.Job) (models.Job, error) {
	if job.Type == "" {
		job.Type = job.Kind
	}
	if job.Kind == "" {
		job.Kind = job.Type
	}
	if job.Input == nil {
		job.Input = job.Request
	}
	if job.Request == nil {
		job.Request = job.Input
	}
	if job.Output == nil {
		job.Output = job.Result
	}
	if job.Result == nil {
		job.Result = job.Output
	}
	result, err := json.Marshal(job.Output)
	if err != nil {
		return models.Job{}, fmt.Errorf("encode job result: %w", err)
	}
	job.UpdatedAt = time.Now().UTC()
	request, err := json.Marshal(job.Input)
	if err != nil {
		return models.Job{}, fmt.Errorf("encode job request: %w", err)
	}
	command, err := repository.pool.Exec(ctx, `
		UPDATE jobs SET type = $1, kind = $2, status = $3, progress = $4,
		                input = $5, output = $6, request = $5, result = $6,
		                error_code = $7, error_message = $8, attempts = $9,
		                idempotency_key = $10, started_at = $11, completed_at = $12,
		                updated_at = $13
		WHERE id = $14 AND user_id = $15
	`, job.Type, job.Kind, job.Status, job.Progress, request, result,
		job.ErrorCode, job.ErrorMessage, job.Attempts, job.IdempotencyKey,
		job.StartedAt, job.CompletedAt, job.UpdatedAt, job.ID, job.UserID)
	if err != nil {
		return models.Job{}, fmt.Errorf("update job: %w", err)
	}
	if command.RowsAffected() == 0 {
		return models.Job{}, normalizeNotFound(pgx.ErrNoRows, "job")
	}
	return job, nil
}

func decodeJobJSON(job *models.Job, input, output, request, result []byte) {
	if len(input) == 0 {
		input = request
	}
	if len(output) == 0 {
		output = result
	}
	if len(input) > 0 {
		_ = json.Unmarshal(input, &job.Input)
		job.Request = job.Input
	}
	if len(output) > 0 {
		_ = json.Unmarshal(output, &job.Output)
		job.Result = job.Output
	}
	if job.Type == "" {
		job.Type = job.Kind
	}
	if job.Kind == "" {
		job.Kind = job.Type
	}
}

type postgresCreations struct{ pool *pgxpool.Pool }

func (repository postgresCreations) List(ctx context.Context, userID uuid.UUID) ([]models.Creation, error) {
	rows, err := repository.pool.Query(ctx, `
		SELECT c.id, c.user_id, c.generated_asset_id, c.thumbnail_asset_id,
		       c.image_asset_id, c.reference_asset_id, c.prompt, c.original_prompt,
		       c.resolved_generation_prompt, c.visual_dna,
		       c.preservation_settings, c.generation_settings, c.status,
		       c.failure_message, c.created_at, c.updated_at,
			`+joinedTemplateSelectColumns+`
		FROM creations c
		LEFT JOIN templates t ON t.id = c.template_id
		WHERE c.user_id = $1
		ORDER BY c.created_at DESC
	`, userID)
	if err != nil {
		return nil, fmt.Errorf("list creations: %w", err)
	}
	defer rows.Close()

	var creations []models.Creation
	for rows.Next() {
		creation, scanErr := scanCreation(rows)
		if scanErr != nil {
			return nil, scanErr
		}
		creations = append(creations, creation)
	}
	return creations, rows.Err()
}

func (repository postgresCreations) ListPage(
	ctx context.Context,
	userID uuid.UUID,
	limit int,
	before *models.CreationCursor,
) ([]models.Creation, bool, error) {
	if limit < 1 {
		limit = 30
	}
	var cursorTime *time.Time
	var cursorID uuid.UUID
	if before != nil {
		cursorTime = &before.CreatedAt
		cursorID = before.ID
	}

	rows, err := repository.pool.Query(ctx, `
		SELECT c.id, c.user_id, c.generated_asset_id, c.thumbnail_asset_id,
		       c.image_asset_id, c.reference_asset_id, c.prompt, c.original_prompt,
		       c.resolved_generation_prompt, c.visual_dna,
		       c.preservation_settings, c.generation_settings, c.status,
		       c.failure_message, c.created_at, c.updated_at,
			`+joinedTemplateSelectColumns+`
		FROM creations c
		LEFT JOIN templates t ON t.id = c.template_id
		WHERE c.user_id = $1
		  AND (
			$2::timestamptz IS NULL
			OR c.created_at < $2::timestamptz
			OR (c.created_at = $2::timestamptz AND c.id < $3::uuid)
		  )
		ORDER BY c.created_at DESC, c.id DESC
		LIMIT $4
	`, userID, cursorTime, cursorID, limit+1)
	if err != nil {
		return nil, false, fmt.Errorf("list creation page: %w", err)
	}
	defer rows.Close()

	creations := make([]models.Creation, 0, limit+1)
	for rows.Next() {
		creation, scanErr := scanCreation(rows)
		if scanErr != nil {
			return nil, false, scanErr
		}
		creations = append(creations, creation)
	}
	if err := rows.Err(); err != nil {
		return nil, false, err
	}
	hasMore := len(creations) > limit
	if hasMore {
		creations = creations[:limit]
	}
	return creations, hasMore, nil
}

func (repository postgresCreations) Get(ctx context.Context, userID, id uuid.UUID) (models.Creation, error) {
	row := repository.pool.QueryRow(ctx, `
		SELECT c.id, c.user_id, c.generated_asset_id, c.thumbnail_asset_id,
		       c.image_asset_id, c.reference_asset_id, c.prompt, c.original_prompt,
		       c.resolved_generation_prompt, c.visual_dna,
		       c.preservation_settings, c.generation_settings, c.status,
		       c.failure_message, c.created_at, c.updated_at,
			`+joinedTemplateSelectColumns+`
		FROM creations c
		LEFT JOIN templates t ON t.id = c.template_id
		WHERE c.user_id = $1 AND c.id = $2
	`, userID, id)
	creation, err := scanCreation(row)
	if err != nil {
		return models.Creation{}, normalizeNotFound(err, "creation")
	}
	return creation, nil
}

func (repository postgresCreations) Create(ctx context.Context, creation models.Creation) (models.Creation, error) {
	if creation.ID == uuid.Nil {
		creation.ID = uuid.New()
	}
	if creation.CreatedAt.IsZero() {
		creation.CreatedAt = time.Now().UTC()
	}
	creation.UpdatedAt = creation.CreatedAt
	visualDNA, err := json.Marshal(creation.VisualDNA)
	if err != nil {
		return models.Creation{}, fmt.Errorf("encode creation visual DNA: %w", err)
	}
	preservation, err := json.Marshal(creation.PreservationSettings)
	if err != nil {
		return models.Creation{}, fmt.Errorf("encode preservation settings: %w", err)
	}
	generationSettings, err := json.Marshal(creation.GenerationSettings)
	if err != nil {
		return models.Creation{}, fmt.Errorf("encode generation settings: %w", err)
	}
	_, err = repository.pool.Exec(ctx, `
		INSERT INTO creations (
			id, user_id, image_asset_id, generated_asset_id, thumbnail_asset_id,
			reference_asset_id, prompt, original_prompt, resolved_generation_prompt, template_id,
			visual_dna, preservation_settings, generation_settings, status,
			failure_message, created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$16)
		`, creation.ID, creation.UserID, creation.ImageAssetID,
		creation.GeneratedAssetID, creation.ThumbnailAssetID,
		creation.ReferenceAssetID, creation.Prompt, creation.OriginalPrompt,
		creation.ResolvedPrompt, creation.Template.ID,
		visualDNA, preservation, generationSettings, creation.Status,
		creation.FailureMessage, creation.CreatedAt)
	if err != nil {
		return models.Creation{}, fmt.Errorf("create creation: %w", err)
	}
	return creation, nil
}

func (repository postgresCreations) Update(ctx context.Context, creation models.Creation) (models.Creation, error) {
	creation.UpdatedAt = time.Now().UTC()
	visualDNA, err := json.Marshal(creation.VisualDNA)
	if err != nil {
		return models.Creation{}, fmt.Errorf("encode creation visual DNA: %w", err)
	}
	preservation, err := json.Marshal(creation.PreservationSettings)
	if err != nil {
		return models.Creation{}, fmt.Errorf("encode preservation settings: %w", err)
	}
	generationSettings, err := json.Marshal(creation.GenerationSettings)
	if err != nil {
		return models.Creation{}, fmt.Errorf("encode generation settings: %w", err)
	}
	result, err := repository.pool.Exec(ctx, `
		UPDATE creations SET image_asset_id = $1, generated_asset_id = $2,
		    thumbnail_asset_id = $3, original_prompt = $4,
		    resolved_generation_prompt = $5, status = $6, failure_message = $7,
		    visual_dna = $8, preservation_settings = $9,
		    generation_settings = $10, updated_at = $11
		WHERE id = $12 AND user_id = $13
		`, creation.ImageAssetID, creation.GeneratedAssetID,
		creation.ThumbnailAssetID, creation.OriginalPrompt,
		creation.ResolvedPrompt, creation.Status, creation.FailureMessage,
		visualDNA, preservation, generationSettings, creation.UpdatedAt,
		creation.ID, creation.UserID)
	if err != nil {
		return models.Creation{}, fmt.Errorf("update creation: %w", err)
	}
	if result.RowsAffected() == 0 {
		return models.Creation{}, normalizeNotFound(pgx.ErrNoRows, "creation")
	}
	return creation, nil
}

func (repository postgresCreations) Delete(ctx context.Context, userID, id uuid.UUID) error {
	result, err := repository.pool.Exec(ctx,
		`DELETE FROM creations WHERE id = $1 AND user_id = $2`,
		id, userID,
	)
	if err != nil {
		return fmt.Errorf("delete creation: %w", err)
	}
	if result.RowsAffected() == 0 {
		return normalizeNotFound(pgx.ErrNoRows, "creation")
	}
	return nil
}

type postgresGenerations struct{ pool *pgxpool.Pool }

func (repository postgresGenerations) Create(ctx context.Context, generation models.Generation) (models.Generation, error) {
	if generation.ID == uuid.Nil {
		generation.ID = uuid.New()
	}
	if generation.CreatedAt.IsZero() {
		generation.CreatedAt = time.Now().UTC()
	}
	generation.UpdatedAt = generation.CreatedAt
	request, err := json.Marshal(generation.Request)
	if err != nil {
		return models.Generation{}, fmt.Errorf("encode generation request: %w", err)
	}
	_, err = repository.pool.Exec(ctx, `
		INSERT INTO generations
		    (id, user_id, creation_id, job_id, request, status, created_at, updated_at)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$7)
	`, generation.ID, generation.UserID, generation.CreationID, generation.JobID,
		request, generation.Status, generation.CreatedAt)
	if err != nil {
		return models.Generation{}, fmt.Errorf("create generation: %w", err)
	}
	return generation, nil
}

func scanCreation(row rowScanner) (models.Creation, error) {
	var creation models.Creation
	var visualDNA, preservation, generationSettings, templateSettings []byte
	var templateID, templatePreviewAssetID *uuid.UUID
	var templateSourceCaseID *int
	var templateSlug, templateName, templateDescription, templateCategory,
		templateSourceLabel, templateSourceURL, templateGitHubURL, templateSourceImagePath, templateImageAlt,
		templateInstructions, templateAspectRatio, templateThumbnail *string
	var templateDirectives, templateDefaults, templateStyles, templateScenes []byte
	var templateActive *bool
	var templateFeatured *bool
	var templateCreatedAt, templateUpdatedAt *time.Time
	err := row.Scan(
		&creation.ID, &creation.UserID, &creation.GeneratedAssetID,
		&creation.ThumbnailAssetID, &creation.ImageAssetID,
		&creation.ReferenceAssetID, &creation.Prompt, &creation.OriginalPrompt,
		&creation.ResolvedPrompt, &visualDNA,
		&preservation, &generationSettings, &creation.Status,
		&creation.FailureMessage, &creation.CreatedAt, &creation.UpdatedAt,
		&templateID, &templateSlug, &templateName, &templateDescription,
		&templateCategory, &templateDirectives, &templateDefaults,
		&templatePreviewAssetID, &templateActive,
		&templateSourceCaseID, &templateSourceLabel, &templateSourceURL,
		&templateGitHubURL, &templateSourceImagePath, &templateImageAlt, &templateStyles, &templateScenes,
		&templateFeatured, &templateInstructions, &templateAspectRatio, &templateSettings, &templateThumbnail,
		&templateCreatedAt, &templateUpdatedAt,
	)
	if err != nil {
		return models.Creation{}, err
	}
	if len(visualDNA) > 0 && string(visualDNA) != "null" {
		creation.VisualDNA = &models.VisualDNA{}
		if err := json.Unmarshal(visualDNA, creation.VisualDNA); err != nil {
			return models.Creation{}, fmt.Errorf("decode creation visual DNA: %w", err)
		}
	}
	if creation.ImageAssetID == nil {
		creation.ImageAssetID = creation.GeneratedAssetID
	}
	if creation.OriginalPrompt == "" {
		creation.OriginalPrompt = creation.Prompt
	}
	if err := json.Unmarshal(preservation, &creation.PreservationSettings); err != nil {
		return models.Creation{}, fmt.Errorf("decode preservation settings: %w", err)
	}
	if err := json.Unmarshal(generationSettings, &creation.GenerationSettings); err != nil {
		return models.Creation{}, fmt.Errorf("decode generation settings: %w", err)
	}
	if templateID != nil {
		creation.Template.ID = *templateID
		creation.Template.Slug = valueOrEmpty(templateSlug)
		creation.Template.Name = valueOrEmpty(templateName)
		creation.Template.Description = valueOrEmpty(templateDescription)
		creation.Template.Category = valueOrEmpty(templateCategory)
		creation.Template.PreviewAssetID = templatePreviewAssetID
		if templateActive != nil {
			creation.Template.IsActive = *templateActive
		}
		creation.Template.SourceCaseID = templateSourceCaseID
		creation.Template.SourceLabel = valueOrEmpty(templateSourceLabel)
		creation.Template.SourceURL = valueOrEmpty(templateSourceURL)
		creation.Template.GitHubURL = valueOrEmpty(templateGitHubURL)
		creation.Template.SourceImagePath = valueOrEmpty(templateSourceImagePath)
		creation.Template.ImageAlt = valueOrEmpty(templateImageAlt)
		if templateFeatured != nil {
			creation.Template.Featured = *templateFeatured
		}
		creation.Template.PromptInstructions = valueOrEmpty(templateInstructions)
		creation.Template.RecommendedAspectRatio = valueOrEmpty(templateAspectRatio)
		creation.Template.ThumbnailURL = valueOrEmpty(templateThumbnail)
		creation.Template.CreatedAt = timeOrZero(templateCreatedAt)
		creation.Template.UpdatedAt = timeOrZero(templateUpdatedAt)
		if len(templateSettings) > 0 {
			if err := json.Unmarshal(templateSettings, &creation.Template.GenerationSettings); err != nil {
				return models.Creation{}, fmt.Errorf("decode creation template settings: %w", err)
			}
		}
		if len(templateDirectives) > 0 {
			if err := json.Unmarshal(templateDirectives, &creation.Template.PromptDirectives); err != nil {
				return models.Creation{}, fmt.Errorf("decode creation template directives: %w", err)
			}
		}
		if len(templateStyles) > 0 {
			if err := json.Unmarshal(templateStyles, &creation.Template.Styles); err != nil {
				return models.Creation{}, fmt.Errorf("decode creation template styles: %w", err)
			}
		}
		if len(templateScenes) > 0 {
			if err := json.Unmarshal(templateScenes, &creation.Template.Scenes); err != nil {
				return models.Creation{}, fmt.Errorf("decode creation template scenes: %w", err)
			}
		}
		if len(templateDefaults) > 0 {
			if err := json.Unmarshal(templateDefaults, &creation.Template.DefaultSettings); err != nil {
				return models.Creation{}, fmt.Errorf("decode creation template defaults: %w", err)
			}
		}
	}
	return creation, nil
}

func valueOrEmpty(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

func timeOrZero(value *time.Time) time.Time {
	if value == nil {
		return time.Time{}
	}
	return *value
}

type postgresCredits struct{ pool *pgxpool.Pool }

func (repository postgresCredits) Balance(ctx context.Context, userID uuid.UUID) (int, error) {
	var balance int
	err := repository.pool.QueryRow(ctx,
		`SELECT COALESCE(SUM(amount), 0) FROM credit_ledger WHERE user_id = $1`,
		userID,
	).Scan(&balance)
	return balance, err
}

func (repository postgresCredits) Append(ctx context.Context, entry models.CreditLedgerEntry) error {
	if entry.ID == uuid.Nil {
		entry.ID = uuid.New()
	}
	if entry.Type == "" {
		entry.Type = entry.Reason
	}
	if entry.Reason == "" {
		entry.Reason = entry.Type
	}
	if entry.CreatedAt.IsZero() {
		entry.CreatedAt = time.Now().UTC()
	}
	metadata, err := json.Marshal(entry.Metadata)
	if err != nil {
		return fmt.Errorf("encode credit metadata: %w", err)
	}
	if entry.Metadata == nil {
		metadata = []byte(`{}`)
	}
	_, err = repository.pool.Exec(ctx, `
		INSERT INTO credit_ledger (
			id, user_id, type, reference_type, reference_id, metadata,
			amount, reason, created_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
	`, entry.ID, entry.UserID, entry.Type, entry.ReferenceType, entry.ReferenceID,
		metadata, entry.Amount, entry.Reason, entry.CreatedAt)
	if err != nil {
		return fmt.Errorf("append credit ledger entry: %w", err)
	}
	return nil
}

func (repository postgresCredits) Reserve(
	ctx context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
	amount int,
) error {
	if userID == uuid.Nil || referenceID == uuid.Nil || amount <= 0 {
		return errors.New("invalid credit reservation")
	}
	transaction, err := repository.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin credit reservation: %w", err)
	}
	defer transaction.Rollback(ctx)

	if _, err := transaction.Exec(ctx, `
		INSERT INTO users (id) VALUES ($1)
		ON CONFLICT (id) DO NOTHING
	`, userID); err != nil {
		return fmt.Errorf("ensure credit account: %w", err)
	}
	var lockedUserID uuid.UUID
	if err := transaction.QueryRow(ctx,
		`SELECT id FROM users WHERE id = $1 FOR UPDATE`, userID,
	).Scan(&lockedUserID); err != nil {
		return fmt.Errorf("lock credit account: %w", err)
	}

	var existingAmount int
	var existingStatus string
	err = transaction.QueryRow(ctx, `
		SELECT amount, status
		FROM credit_reservations
		WHERE user_id = $1 AND reference_type = $2 AND reference_id = $3
		FOR UPDATE
	`, userID, referenceType, referenceID).Scan(&existingAmount, &existingStatus)
	if err == nil {
		if existingAmount != amount {
			return errors.New("credit reservation amount changed")
		}
		return transaction.Commit(ctx)
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return fmt.Errorf("find credit reservation: %w", err)
	}

	var balance int
	if err := transaction.QueryRow(ctx,
		`SELECT COALESCE(SUM(amount), 0) FROM credit_ledger WHERE user_id = $1`,
		userID,
	).Scan(&balance); err != nil {
		return fmt.Errorf("read credit balance: %w", err)
	}
	if balance < amount {
		return database.ErrInsufficientCredits
	}

	now := time.Now().UTC()
	metadata, _ := json.Marshal(map[string]any{
		"reservation_status": models.CreditReservationStatusReserved,
	})
	if _, err := transaction.Exec(ctx, `
		INSERT INTO credit_ledger (
			id, user_id, type, reference_type, reference_id, metadata,
			amount, reason, created_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
	`, uuid.New(), userID, models.CreditLedgerTypeGeneration, referenceType,
		referenceID, metadata, -amount, models.CreditLedgerTypeGeneration, now); err != nil {
		return fmt.Errorf("record credit reservation: %w", err)
	}
	if _, err := transaction.Exec(ctx, `
		INSERT INTO credit_reservations (
			id, user_id, reference_type, reference_id, amount, status,
			created_at, updated_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$7)
	`, uuid.New(), userID, referenceType, referenceID, amount,
		models.CreditReservationStatusReserved, now); err != nil {
		return fmt.Errorf("create credit reservation: %w", err)
	}
	return transaction.Commit(ctx)
}

func (repository postgresCredits) Consume(
	ctx context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
) error {
	return repository.updateReservationStatus(ctx, userID, referenceType, referenceID,
		models.CreditReservationStatusConsumed)
}

func (repository postgresCredits) Refund(
	ctx context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
) error {
	transaction, err := repository.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin credit refund: %w", err)
	}
	defer transaction.Rollback(ctx)

	var amount int
	var status string
	if err := transaction.QueryRow(ctx, `
		SELECT amount, status
		FROM credit_reservations
		WHERE user_id = $1 AND reference_type = $2 AND reference_id = $3
		FOR UPDATE
	`, userID, referenceType, referenceID).Scan(&amount, &status); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		return fmt.Errorf("load credit reservation for refund: %w", err)
	}
	if status == models.CreditReservationStatusRefunded {
		return transaction.Commit(ctx)
	}
	if status != models.CreditReservationStatusReserved &&
		status != models.CreditReservationStatusConsumed {
		return errors.New("credit reservation cannot be refunded")
	}
	now := time.Now().UTC()
	metadata, _ := json.Marshal(map[string]any{
		"reservation_status": models.CreditReservationStatusRefunded,
	})
	if _, err := transaction.Exec(ctx, `
		INSERT INTO credit_ledger (
			id, user_id, type, reference_type, reference_id, metadata,
			amount, reason, created_at
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
	`, uuid.New(), userID, models.CreditLedgerTypeRefund, referenceType,
		referenceID, metadata, amount, models.CreditLedgerTypeRefund, now); err != nil {
		return fmt.Errorf("record credit refund: %w", err)
	}
	if _, err := transaction.Exec(ctx, `
		UPDATE credit_reservations
		SET status = $1, updated_at = $2
		WHERE user_id = $3 AND reference_type = $4 AND reference_id = $5
	`, models.CreditReservationStatusRefunded, now, userID, referenceType, referenceID); err != nil {
		return fmt.Errorf("mark credit reservation refunded: %w", err)
	}
	return transaction.Commit(ctx)
}

func (repository postgresCredits) updateReservationStatus(
	ctx context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
	status string,
) error {
	transaction, err := repository.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin credit status update: %w", err)
	}
	defer transaction.Rollback(ctx)

	var currentStatus string
	if err := transaction.QueryRow(ctx, `
		SELECT status
		FROM credit_reservations
		WHERE user_id = $1 AND reference_type = $2 AND reference_id = $3
		FOR UPDATE
	`, userID, referenceType, referenceID).Scan(&currentStatus); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		return fmt.Errorf("load credit reservation: %w", err)
	}
	if currentStatus == status ||
		currentStatus == models.CreditReservationStatusRefunded {
		return transaction.Commit(ctx)
	}
	if currentStatus != models.CreditReservationStatusReserved {
		return errors.New("credit reservation cannot change state")
	}
	if _, err := transaction.Exec(ctx, `
		UPDATE credit_reservations SET status = $1, updated_at = NOW()
		WHERE user_id = $2 AND reference_type = $3 AND reference_id = $4
	`, status, userID, referenceType, referenceID); err != nil {
		return fmt.Errorf("update credit reservation: %w", err)
	}
	return transaction.Commit(ctx)
}

func normalizeNotFound(err error, entity string) error {
	if errors.Is(err, pgx.ErrNoRows) {
		return fmt.Errorf("%s not found: %w", entity, database.ErrNotFound)
	}
	return err
}
