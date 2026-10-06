package storage

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"net/url"
	"sync"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/smithy-go"
)

var ErrObjectNotFound = errors.New("object not found")

type ObjectStorage interface {
	CreateUploadURL(ctx context.Context, input UploadInput) (UploadReference, error)
	CreateDownloadURL(ctx context.Context, objectKey string, expiresIn time.Duration) (string, error)
	HeadObject(ctx context.Context, objectKey string) (ObjectMetadata, error)
	GetObject(ctx context.Context, objectKey string) (ObjectData, error)
	DeleteObject(ctx context.Context, objectKey string) error
	PutObject(ctx context.Context, input PutObjectInput) error
}

type UploadInput struct {
	ObjectKey string
	MimeType  string
	ByteSize  int64
	ExpiresIn time.Duration
}

type UploadReference struct {
	ObjectKey string
	UploadURL string
	ExpiresIn int
}

type ObjectMetadata struct {
	ObjectKey   string
	ContentType string
	SizeBytes   int64
}

type ObjectData struct {
	ObjectMetadata
	Data []byte
}

type PutObjectInput struct {
	ObjectKey   string
	ContentType string
	Data        []byte
}

type S3Config struct {
	Bucket string
	Region string
}

type S3ObjectStorage struct {
	bucket  string
	client  *s3.Client
	presign *s3.PresignClient
}

func NewS3ObjectStorage(ctx context.Context, configuration S3Config) (*S3ObjectStorage, error) {
	if configuration.Bucket == "" {
		return nil, errors.New("S3 bucket is required")
	}
	if configuration.Region == "" {
		return nil, errors.New("S3 region is required")
	}
	awsConfiguration, err := awsconfig.LoadDefaultConfig(ctx, awsconfig.WithRegion(configuration.Region))
	if err != nil {
		return nil, fmt.Errorf("load AWS configuration: %w", err)
	}
	client := s3.NewFromConfig(awsConfiguration)
	return &S3ObjectStorage{
		bucket:  configuration.Bucket,
		client:  client,
		presign: s3.NewPresignClient(client),
	}, nil
}

func (storage *S3ObjectStorage) CreateUploadURL(
	ctx context.Context,
	input UploadInput,
) (UploadReference, error) {
	if storage == nil || storage.presign == nil {
		return UploadReference{}, errors.New("S3 storage is not initialized")
	}
	if input.ObjectKey == "" || input.MimeType == "" || input.ByteSize <= 0 {
		return UploadReference{}, errors.New("invalid S3 upload input")
	}
	if input.ExpiresIn <= 0 {
		input.ExpiresIn = 15 * time.Minute
	}
	request, err := storage.presign.PresignPutObject(ctx, &s3.PutObjectInput{
		Bucket:        aws.String(storage.bucket),
		Key:           aws.String(input.ObjectKey),
		ContentType:   aws.String(input.MimeType),
		ContentLength: aws.Int64(input.ByteSize),
	}, func(options *s3.PresignOptions) {
		options.Expires = input.ExpiresIn
	})
	if err != nil {
		return UploadReference{}, fmt.Errorf("presign S3 upload: %w", err)
	}
	return UploadReference{
		ObjectKey: input.ObjectKey,
		UploadURL: request.URL,
		ExpiresIn: durationSeconds(input.ExpiresIn),
	}, nil
}

func (storage *S3ObjectStorage) CreateDownloadURL(
	ctx context.Context,
	objectKey string,
	expiresIn time.Duration,
) (string, error) {
	if storage == nil || storage.presign == nil {
		return "", errors.New("S3 storage is not initialized")
	}
	if objectKey == "" {
		return "", errors.New("object key is required")
	}
	if expiresIn <= 0 {
		expiresIn = 15 * time.Minute
	}
	request, err := storage.presign.PresignGetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(storage.bucket),
		Key:    aws.String(objectKey),
	}, func(options *s3.PresignOptions) {
		options.Expires = expiresIn
	})
	if err != nil {
		return "", fmt.Errorf("presign S3 download: %w", err)
	}
	return request.URL, nil
}

func (storage *S3ObjectStorage) HeadObject(
	ctx context.Context,
	objectKey string,
) (ObjectMetadata, error) {
	if storage == nil || storage.client == nil {
		return ObjectMetadata{}, errors.New("S3 storage is not initialized")
	}
	output, err := storage.client.HeadObject(ctx, &s3.HeadObjectInput{
		Bucket: aws.String(storage.bucket),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		var apiError smithy.APIError
		if errors.As(err, &apiError) &&
			(apiError.ErrorCode() == "NotFound" || apiError.ErrorCode() == "NoSuchKey") {
			return ObjectMetadata{}, ErrObjectNotFound
		}
		return ObjectMetadata{}, fmt.Errorf("head S3 object: %w", err)
	}
	metadata := ObjectMetadata{ObjectKey: objectKey}
	if output.ContentLength != nil {
		metadata.SizeBytes = *output.ContentLength
	}
	if output.ContentType != nil {
		metadata.ContentType = *output.ContentType
	}
	return metadata, nil
}

func (storage *S3ObjectStorage) GetObject(
	ctx context.Context,
	objectKey string,
) (ObjectData, error) {
	if storage == nil || storage.client == nil {
		return ObjectData{}, errors.New("S3 storage is not initialized")
	}
	if objectKey == "" {
		return ObjectData{}, errors.New("object key is required")
	}
	output, err := storage.client.GetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(storage.bucket),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		var apiError smithy.APIError
		if errors.As(err, &apiError) &&
			(apiError.ErrorCode() == "NotFound" || apiError.ErrorCode() == "NoSuchKey") {
			return ObjectData{}, ErrObjectNotFound
		}
		return ObjectData{}, fmt.Errorf("get S3 object: %w", err)
	}
	defer output.Body.Close()
	data, err := io.ReadAll(output.Body)
	if err != nil {
		return ObjectData{}, fmt.Errorf("read S3 object: %w", err)
	}
	metadata := ObjectMetadata{
		ObjectKey:   objectKey,
		ContentType: stringValue(output.ContentType),
		SizeBytes:   int64(len(data)),
	}
	if output.ContentLength != nil {
		metadata.SizeBytes = *output.ContentLength
	}
	return ObjectData{ObjectMetadata: metadata, Data: data}, nil
}

func (storage *S3ObjectStorage) DeleteObject(
	ctx context.Context,
	objectKey string,
) error {
	if storage == nil || storage.client == nil {
		return errors.New("S3 storage is not initialized")
	}
	_, err := storage.client.DeleteObject(ctx, &s3.DeleteObjectInput{
		Bucket: aws.String(storage.bucket),
		Key:    aws.String(objectKey),
	})
	if err != nil {
		return fmt.Errorf("delete S3 object: %w", err)
	}
	return nil
}

func (storage *S3ObjectStorage) PutObject(ctx context.Context, input PutObjectInput) error {
	if storage == nil || storage.client == nil {
		return errors.New("S3 storage is not initialized")
	}
	if input.ObjectKey == "" || input.ContentType == "" || len(input.Data) == 0 {
		return errors.New("invalid S3 object input")
	}
	_, err := storage.client.PutObject(ctx, &s3.PutObjectInput{
		Bucket:        aws.String(storage.bucket),
		Key:           aws.String(input.ObjectKey),
		ContentType:   aws.String(input.ContentType),
		ContentLength: aws.Int64(int64(len(input.Data))),
		Body:          bytes.NewReader(input.Data),
	})
	if err != nil {
		return fmt.Errorf("put S3 object: %w", err)
	}
	return nil
}

type MockObjectStorage struct {
	mu               sync.RWMutex
	objects          map[string]ObjectMetadata
	objectData       map[string][]byte
	uploadReferences map[string]UploadReference
	downloadURLs     map[string]string
	UploadURLTTL     time.Duration
	DownloadURLTTL   time.Duration
}

func NewMockObjectStorage() *MockObjectStorage {
	return &MockObjectStorage{
		objects:          make(map[string]ObjectMetadata),
		objectData:       make(map[string][]byte),
		uploadReferences: make(map[string]UploadReference),
		downloadURLs:     make(map[string]string),
		UploadURLTTL:     15 * time.Minute,
		DownloadURLTTL:   15 * time.Minute,
	}
}

func (storage *MockObjectStorage) CreateUploadURL(
	_ context.Context,
	input UploadInput,
) (UploadReference, error) {
	if storage == nil {
		return UploadReference{}, errors.New("mock storage is not initialized")
	}
	if input.ObjectKey == "" || input.MimeType == "" || input.ByteSize <= 0 {
		return UploadReference{}, errors.New("invalid mock upload input")
	}
	expiresIn := input.ExpiresIn
	if expiresIn <= 0 {
		expiresIn = storage.UploadURLTTL
	}
	reference := UploadReference{
		ObjectKey: input.ObjectKey,
		UploadURL: "mock://visualkit/upload/" + url.PathEscape(input.ObjectKey),
		ExpiresIn: durationSeconds(expiresIn),
	}
	storage.mu.Lock()
	defer storage.mu.Unlock()
	if storage.uploadReferences == nil {
		storage.uploadReferences = make(map[string]UploadReference)
	}
	storage.uploadReferences[input.ObjectKey] = reference
	return reference, nil
}

func (storage *MockObjectStorage) CreateDownloadURL(
	_ context.Context,
	objectKey string,
	expiresIn time.Duration,
) (string, error) {
	if storage == nil {
		return "", errors.New("mock storage is not initialized")
	}
	if objectKey == "" {
		return "", errors.New("object key is required")
	}
	if expiresIn <= 0 {
		expiresIn = storage.DownloadURLTTL
	}
	downloadURL := "mock://visualkit/download/" + url.PathEscape(objectKey)
	storage.mu.Lock()
	defer storage.mu.Unlock()
	if storage.downloadURLs == nil {
		storage.downloadURLs = make(map[string]string)
	}
	storage.downloadURLs[objectKey] = downloadURL
	return downloadURL, nil
}

func (storage *MockObjectStorage) HeadObject(
	_ context.Context,
	objectKey string,
) (ObjectMetadata, error) {
	if storage == nil {
		return ObjectMetadata{}, errors.New("mock storage is not initialized")
	}
	storage.mu.RLock()
	defer storage.mu.RUnlock()
	object, ok := storage.objects[objectKey]
	if !ok {
		return ObjectMetadata{}, ErrObjectNotFound
	}
	return object, nil
}

func (storage *MockObjectStorage) GetObject(
	_ context.Context,
	objectKey string,
) (ObjectData, error) {
	if storage == nil {
		return ObjectData{}, errors.New("mock storage is not initialized")
	}
	storage.mu.RLock()
	defer storage.mu.RUnlock()
	object, ok := storage.objects[objectKey]
	if !ok {
		return ObjectData{}, ErrObjectNotFound
	}
	data, ok := storage.objectData[objectKey]
	if !ok {
		return ObjectData{}, ErrObjectNotFound
	}
	return ObjectData{
		ObjectMetadata: object,
		Data:           append([]byte(nil), data...),
	}, nil
}

func (storage *MockObjectStorage) DeleteObject(
	_ context.Context,
	objectKey string,
) error {
	if storage == nil {
		return errors.New("mock storage is not initialized")
	}
	storage.mu.Lock()
	defer storage.mu.Unlock()
	if _, ok := storage.objects[objectKey]; !ok {
		return ErrObjectNotFound
	}
	delete(storage.objects, objectKey)
	delete(storage.objectData, objectKey)
	return nil
}

// PutObject records an object as if a direct-to-S3 upload had completed.
// It is intended for local development and service tests.
func (storage *MockObjectStorage) PutObjectMetadata(object ObjectMetadata) {
	if storage == nil {
		return
	}
	storage.mu.Lock()
	defer storage.mu.Unlock()
	if storage.objects == nil {
		storage.objects = make(map[string]ObjectMetadata)
	}
	storage.objects[object.ObjectKey] = object
}

func (storage *MockObjectStorage) PutObject(_ context.Context, input PutObjectInput) error {
	if storage == nil {
		return errors.New("mock storage is not initialized")
	}
	if input.ObjectKey == "" || input.ContentType == "" || len(input.Data) == 0 {
		return errors.New("invalid mock object input")
	}
	storage.PutObjectMetadata(ObjectMetadata{
		ObjectKey:   input.ObjectKey,
		ContentType: input.ContentType,
		SizeBytes:   int64(len(input.Data)),
	})
	storage.mu.Lock()
	if storage.objectData == nil {
		storage.objectData = make(map[string][]byte)
	}
	storage.objectData[input.ObjectKey] = append([]byte(nil), input.Data...)
	storage.mu.Unlock()
	return nil
}

func stringValue(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

func durationSeconds(value time.Duration) int {
	if value <= 0 {
		return 0
	}
	return int(value / time.Second)
}
