package services

import (
	"context"
	"errors"
	"fmt"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/storage"
	"github.com/visualkit/backend/pkg/api"
)

type assetTestUsers struct{}

func (assetTestUsers) Ensure(_ context.Context, id uuid.UUID) (models.User, error) {
	return models.User{ID: id}, nil
}

type assetTestRepository struct {
	assets map[uuid.UUID]models.ImageAsset
}

func newAssetTestRepository() *assetTestRepository {
	return &assetTestRepository{assets: make(map[uuid.UUID]models.ImageAsset)}
}

func (repository *assetTestRepository) Create(_ context.Context, asset models.ImageAsset) (models.ImageAsset, error) {
	if asset.ID == uuid.Nil {
		asset.ID = uuid.New()
	}
	if asset.CreatedAt.IsZero() {
		asset.CreatedAt = time.Now().UTC()
	}
	asset.UpdatedAt = asset.CreatedAt
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *assetTestRepository) Get(_ context.Context, userID, id uuid.UUID) (models.ImageAsset, error) {
	asset, ok := repository.assets[id]
	if !ok || asset.UserID != userID {
		return models.ImageAsset{}, fmt.Errorf("asset not found: %w", database.ErrNotFound)
	}
	return asset, nil
}

func (repository *assetTestRepository) Update(_ context.Context, asset models.ImageAsset) (models.ImageAsset, error) {
	if _, ok := repository.assets[asset.ID]; !ok {
		return models.ImageAsset{}, database.ErrNotFound
	}
	asset.UpdatedAt = time.Now().UTC()
	repository.assets[asset.ID] = asset
	return asset, nil
}

func (repository *assetTestRepository) SaveVisualDNA(
	ctx context.Context,
	userID,
	id uuid.UUID,
	visualDNA models.VisualDNA,
) (models.ImageAsset, error) {
	asset, err := repository.Get(ctx, userID, id)
	if err != nil {
		return models.ImageAsset{}, err
	}
	asset.VisualDNA = &visualDNA
	return repository.Update(ctx, asset)
}

func newAssetService(
	repository *assetTestRepository,
	objectStorage *storage.MockObjectStorage,
) AssetService {
	return AssetService{
		Users:   assetTestUsers{},
		Assets:  repository,
		Storage: objectStorage,
		Config: config.Config{
			S3MaxAssetBytes:          10 * 1024 * 1024,
			S3UploadURLTTL:           15 * time.Minute,
			S3DownloadURLTTL:         15 * time.Minute,
			S3VerifyObjectOnComplete: true,
		},
	}
}

func TestAssetServiceCreateUploadURLRejectsUnsupportedContentType(t *testing.T) {
	service := newAssetService(newAssetTestRepository(), storage.NewMockObjectStorage())

	_, err := service.CreateUploadURL(context.Background(), uuid.New(), CreateAssetUploadInput{
		Filename:    "reference.txt",
		ContentType: "text/plain",
		SizeBytes:   100,
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}
}

func TestAssetServiceCreateUploadURLRejectsMismatchedFilenameExtension(t *testing.T) {
	service := newAssetService(newAssetTestRepository(), storage.NewMockObjectStorage())

	_, err := service.CreateUploadURL(context.Background(), uuid.New(), CreateAssetUploadInput{
		Filename:    "reference.png",
		ContentType: "image/jpeg",
		SizeBytes:   100,
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}
}

func TestAssetServiceCompleteUploadRejectsInvalidAssetID(t *testing.T) {
	service := newAssetService(newAssetTestRepository(), storage.NewMockObjectStorage())

	_, err := service.CompleteUpload(context.Background(), uuid.New(), uuid.Nil, CompleteAssetUploadInput{
		ObjectKey: "users/example/assets/example/original",
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}
}

func TestAssetServiceCreateUploadURLRejectsOversizedFile(t *testing.T) {
	service := newAssetService(newAssetTestRepository(), storage.NewMockObjectStorage())

	_, err := service.CreateUploadURL(context.Background(), uuid.New(), CreateAssetUploadInput{
		Filename:    "reference.jpg",
		ContentType: "image/jpeg",
		SizeBytes:   10*1024*1024 + 1,
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}
}

func TestAssetServiceCreateUploadURLGeneratesOwnedObjectKey(t *testing.T) {
	repository := newAssetTestRepository()
	objectStorage := storage.NewMockObjectStorage()
	service := newAssetService(repository, objectStorage)
	userID := uuid.New()

	upload, err := service.CreateUploadURL(context.Background(), userID, CreateAssetUploadInput{
		Filename:    "reference.jpg",
		ContentType: "image/jpeg",
		SizeBytes:   1234,
	})
	if err != nil {
		t.Fatal(err)
	}
	if upload.AssetID == uuid.Nil {
		t.Fatal("expected server-generated asset ID")
	}
	expectedPrefix := "users/" + userID.String() + "/assets/" + upload.AssetID.String() + "/original"
	if upload.ObjectKey != expectedPrefix {
		t.Fatalf("object key = %q, want %q", upload.ObjectKey, expectedPrefix)
	}
	if upload.UploadURL == "" || upload.ExpiresIn != 900 {
		t.Fatalf("unexpected upload reference: %#v", upload)
	}
	asset := repository.assets[upload.AssetID]
	if asset.Status != models.ImageAssetStatusPending {
		t.Fatalf("asset status = %q, want pending", asset.Status)
	}
	if asset.Filename != "reference.jpg" {
		t.Fatalf("filename = %q, want original metadata", asset.Filename)
	}
}

func TestAssetServiceCompleteUploadRequiresMatchingObjectAndObjectMetadata(t *testing.T) {
	repository := newAssetTestRepository()
	objectStorage := storage.NewMockObjectStorage()
	service := newAssetService(repository, objectStorage)
	userID := uuid.New()
	upload, err := service.CreateUploadURL(context.Background(), userID, CreateAssetUploadInput{
		Filename:    "reference.jpg",
		ContentType: "image/jpeg",
		SizeBytes:   1234,
	})
	if err != nil {
		t.Fatal(err)
	}

	_, err = service.CompleteUpload(context.Background(), userID, upload.AssetID, CompleteAssetUploadInput{
		ObjectKey: "users/other/assets/" + upload.AssetID.String() + "/original",
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("key mismatch error = %v, want invalid request", err)
	}

	objectStorage.PutObjectMetadata(storage.ObjectMetadata{
		ObjectKey:   upload.ObjectKey,
		ContentType: "image/jpeg",
		SizeBytes:   99,
	})
	_, err = service.CompleteUpload(context.Background(), userID, upload.AssetID, CompleteAssetUploadInput{
		ObjectKey: upload.ObjectKey,
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("size mismatch error = %v, want invalid request", err)
	}
}

func TestAssetServiceCompleteUploadMarksAssetReady(t *testing.T) {
	repository := newAssetTestRepository()
	objectStorage := storage.NewMockObjectStorage()
	service := newAssetService(repository, objectStorage)
	userID := uuid.New()
	upload, err := service.CreateUploadURL(context.Background(), userID, CreateAssetUploadInput{
		Filename:    "reference.jpg",
		ContentType: "image/jpeg",
		SizeBytes:   1234,
	})
	if err != nil {
		t.Fatal(err)
	}
	objectStorage.PutObjectMetadata(storage.ObjectMetadata{
		ObjectKey:   upload.ObjectKey,
		ContentType: "image/jpeg",
		SizeBytes:   1234,
	})

	asset, err := service.CompleteUpload(context.Background(), userID, upload.AssetID, CompleteAssetUploadInput{
		ObjectKey:   upload.ObjectKey,
		ContentType: "image/jpeg",
		SizeBytes:   pointerToInt64(1234),
		PixelWidth:  1200,
		PixelHeight: 800,
	})
	if err != nil {
		t.Fatal(err)
	}
	if asset.Status != models.ImageAssetStatusReady {
		t.Fatalf("asset status = %q, want ready", asset.Status)
	}
	if asset.PixelWidth != 1200 || asset.PixelHeight != 800 {
		t.Fatalf("dimensions = %dx%d, want 1200x800", asset.PixelWidth, asset.PixelHeight)
	}

	repeated, err := service.CompleteUpload(context.Background(), userID, upload.AssetID, CompleteAssetUploadInput{
		ObjectKey: upload.ObjectKey,
	})
	if err != nil {
		t.Fatal(err)
	}
	if repeated.Status != models.ImageAssetStatusReady {
		t.Fatalf("repeated completion status = %q, want ready", repeated.Status)
	}
}

func TestAssetServiceCompleteUploadRejectsMissingObject(t *testing.T) {
	repository := newAssetTestRepository()
	service := newAssetService(repository, storage.NewMockObjectStorage())
	userID := uuid.New()
	upload, err := service.CreateUploadURL(context.Background(), userID, CreateAssetUploadInput{
		Filename:    "reference.png",
		ContentType: "image/png",
		SizeBytes:   44,
	})
	if err != nil {
		t.Fatal(err)
	}

	_, err = service.CompleteUpload(context.Background(), userID, upload.AssetID, CompleteAssetUploadInput{
		ObjectKey: upload.ObjectKey,
	})
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}
}

func TestAssetServiceRejectsUnauthorizedAssetAccess(t *testing.T) {
	repository := newAssetTestRepository()
	objectStorage := storage.NewMockObjectStorage()
	service := newAssetService(repository, objectStorage)
	ownerID := uuid.New()
	otherUserID := uuid.New()
	upload, err := service.CreateUploadURL(context.Background(), ownerID, CreateAssetUploadInput{
		Filename:    "reference.webp",
		ContentType: "image/webp",
		SizeBytes:   22,
	})
	if err != nil {
		t.Fatal(err)
	}

	_, err = service.CreateDownloadURL(context.Background(), otherUserID, upload.AssetID)
	if !errors.Is(err, database.ErrNotFound) {
		t.Fatalf("error = %v, want not found for unauthorized asset", err)
	}
}

func TestAssetServiceCreateDownloadURLRequiresReadyAsset(t *testing.T) {
	repository := newAssetTestRepository()
	objectStorage := storage.NewMockObjectStorage()
	service := newAssetService(repository, objectStorage)
	userID := uuid.New()
	upload, err := service.CreateUploadURL(context.Background(), userID, CreateAssetUploadInput{
		Filename:    "reference.heic",
		ContentType: "image/heic",
		SizeBytes:   22,
	})
	if err != nil {
		t.Fatal(err)
	}

	_, err = service.CreateDownloadURL(context.Background(), userID, upload.AssetID)
	if !errors.Is(err, api.ErrInvalidRequest) {
		t.Fatalf("error = %v, want invalid request", err)
	}

	objectStorage.PutObjectMetadata(storage.ObjectMetadata{
		ObjectKey:   upload.ObjectKey,
		ContentType: "image/heic",
		SizeBytes:   22,
	})
	if _, err := service.CompleteUpload(context.Background(), userID, upload.AssetID, CompleteAssetUploadInput{
		ObjectKey: upload.ObjectKey,
	}); err != nil {
		t.Fatal(err)
	}
	download, err := service.CreateDownloadURL(context.Background(), userID, upload.AssetID)
	if err != nil {
		t.Fatal(err)
	}
	if download.DownloadURL == "" || download.ExpiresIn != 900 {
		t.Fatalf("unexpected download reference: %#v", download)
	}
}

func pointerToInt64(value int64) *int64 {
	return &value
}
