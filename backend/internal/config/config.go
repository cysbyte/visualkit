package config

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

type Config struct {
	Environment              string
	Port                     string
	DatabaseURL              string
	DatabaseMaxConns         int32
	DatabaseMinConns         int32
	MigrationsDir            string
	S3Bucket                 string
	S3Region                 string
	AWSAccessKeyID           string
	AWSSecretAccessKey       string
	S3UploadURLTTL           time.Duration
	S3DownloadURLTTL         time.Duration
	S3MaxAssetBytes          int64
	S3VerifyObjectOnComplete bool
	SQSQueueURL              string
	SQSRegion                string
	WorkerConcurrency        int
	WorkerLongPollWait       time.Duration
	WorkerVisibilityTimeout  time.Duration
	WorkerShutdownTimeout    time.Duration
	WorkerProviderTimeout    time.Duration
	WorkerMaxAttempts        int
	VisionProvider           string
	VisionEndpoint           string
	VisionAPIKey             string
	ImageGenerationProvider  string
	ImageGenerationEndpoint  string
	ImageGenerationModel     string
	ImageGenerationAPIKey    string
	GenerationCreditCost     int
	AuthMode                 string
	DevelopmentUserID        string
	InternalJobToken         string
	ShutdownTimeout          time.Duration
}

func Load() (Config, error) {
	maxConns, err := envInt("DATABASE_MAX_CONNS", 10)
	if err != nil {
		return Config{}, err
	}
	minConns, err := envInt("DATABASE_MIN_CONNS", 1)
	if err != nil {
		return Config{}, err
	}
	shutdownTimeout, err := envDuration("SHUTDOWN_TIMEOUT", 10*time.Second)
	if err != nil {
		return Config{}, err
	}
	uploadURLTTL, err := envDuration("S3_UPLOAD_URL_TTL", 15*time.Minute)
	if err != nil {
		return Config{}, err
	}
	downloadURLTTL, err := envDuration("S3_DOWNLOAD_URL_TTL", 15*time.Minute)
	if err != nil {
		return Config{}, err
	}
	maxAssetBytes, err := envInt64("S3_MAX_ASSET_BYTES", 25*1024*1024)
	if err != nil {
		return Config{}, err
	}
	verifyObjectOnComplete, err := envBool("S3_VERIFY_OBJECT_ON_COMPLETE", true)
	if err != nil {
		return Config{}, err
	}
	workerConcurrency, err := envInt("WORKER_CONCURRENCY", 4)
	if err != nil {
		return Config{}, err
	}
	workerLongPollWait, err := envDuration("WORKER_LONG_POLL_WAIT", 20*time.Second)
	if err != nil {
		return Config{}, err
	}
	workerVisibilityTimeout, err := envDuration("WORKER_VISIBILITY_TIMEOUT", 5*time.Minute)
	if err != nil {
		return Config{}, err
	}
	workerShutdownTimeout, err := envDuration("WORKER_SHUTDOWN_TIMEOUT", 30*time.Second)
	if err != nil {
		return Config{}, err
	}
	workerProviderTimeout, err := envDuration("WORKER_PROVIDER_TIMEOUT", 2*time.Minute)
	if err != nil {
		return Config{}, err
	}
	workerMaxAttempts, err := envInt("WORKER_MAX_ATTEMPTS", 3)
	if err != nil {
		return Config{}, err
	}
	generationCreditCost, err := envInt("GENERATION_CREDIT_COST", 10)
	if err != nil {
		return Config{}, err
	}

	configuration := Config{
		Environment:              env("APP_ENV", "development"),
		Port:                     env("PORT", "8080"),
		DatabaseURL:              os.Getenv("DATABASE_URL"),
		DatabaseMaxConns:         int32(maxConns),
		DatabaseMinConns:         int32(minConns),
		MigrationsDir:            env("MIGRATIONS_DIR", "migrations"),
		S3Bucket:                 os.Getenv("S3_BUCKET"),
		S3Region:                 os.Getenv("S3_REGION"),
		AWSAccessKeyID:           os.Getenv("AWS_ACCESS_KEY_ID"),
		AWSSecretAccessKey:       os.Getenv("AWS_SECRET_ACCESS_KEY"),
		S3UploadURLTTL:           uploadURLTTL,
		S3DownloadURLTTL:         downloadURLTTL,
		S3MaxAssetBytes:          maxAssetBytes,
		S3VerifyObjectOnComplete: verifyObjectOnComplete,
		SQSQueueURL:              os.Getenv("SQS_QUEUE_URL"),
		SQSRegion:                env("SQS_REGION", os.Getenv("S3_REGION")),
		WorkerConcurrency:        workerConcurrency,
		WorkerLongPollWait:       workerLongPollWait,
		WorkerVisibilityTimeout:  workerVisibilityTimeout,
		WorkerShutdownTimeout:    workerShutdownTimeout,
		WorkerProviderTimeout:    workerProviderTimeout,
		WorkerMaxAttempts:        workerMaxAttempts,
		VisionProvider:           env("VISION_PROVIDER", "mock"),
		VisionEndpoint:           strings.TrimSpace(os.Getenv("VISION_ENDPOINT")),
		VisionAPIKey:             os.Getenv("VISION_API_KEY"),
		ImageGenerationProvider:  env("IMAGE_GENERATION_PROVIDER", "mock"),
		ImageGenerationEndpoint:  strings.TrimSpace(os.Getenv("IMAGE_GENERATION_ENDPOINT")),
		ImageGenerationModel:     strings.TrimSpace(os.Getenv("IMAGE_GENERATION_MODEL")),
		ImageGenerationAPIKey:    os.Getenv("IMAGE_GENERATION_API_KEY"),
		GenerationCreditCost:     generationCreditCost,
		AuthMode:                 env("AUTH_MODE", "development"),
		DevelopmentUserID:        strings.TrimSpace(os.Getenv("DEVELOPMENT_USER_ID")),
		InternalJobToken:         strings.TrimSpace(os.Getenv("INTERNAL_JOB_TOKEN")),
		ShutdownTimeout:          shutdownTimeout,
	}

	if strings.TrimSpace(configuration.DatabaseURL) == "" {
		return Config{}, errors.New("DATABASE_URL is required")
	}
	if maxConns < 1 {
		return Config{}, errors.New("DATABASE_MAX_CONNS must be greater than zero")
	}
	if minConns < 0 || minConns > maxConns {
		return Config{}, errors.New("DATABASE_MIN_CONNS must be between zero and DATABASE_MAX_CONNS")
	}
	if uploadURLTTL <= 0 {
		return Config{}, errors.New("S3_UPLOAD_URL_TTL must be greater than zero")
	}
	if downloadURLTTL <= 0 {
		return Config{}, errors.New("S3_DOWNLOAD_URL_TTL must be greater than zero")
	}
	if maxAssetBytes <= 0 {
		return Config{}, errors.New("S3_MAX_ASSET_BYTES must be greater than zero")
	}
	if workerConcurrency < 1 {
		return Config{}, errors.New("WORKER_CONCURRENCY must be greater than zero")
	}
	if workerLongPollWait < 0 || workerLongPollWait > 20*time.Second {
		return Config{}, errors.New("WORKER_LONG_POLL_WAIT must be between zero and 20s")
	}
	if workerVisibilityTimeout <= 0 {
		return Config{}, errors.New("WORKER_VISIBILITY_TIMEOUT must be greater than zero")
	}
	if workerShutdownTimeout <= 0 {
		return Config{}, errors.New("WORKER_SHUTDOWN_TIMEOUT must be greater than zero")
	}
	if workerProviderTimeout <= 0 {
		return Config{}, errors.New("WORKER_PROVIDER_TIMEOUT must be greater than zero")
	}
	if workerMaxAttempts < 1 {
		return Config{}, errors.New("WORKER_MAX_ATTEMPTS must be greater than zero")
	}
	if generationCreditCost < 1 {
		return Config{}, errors.New("GENERATION_CREDIT_COST must be greater than zero")
	}
	switch configuration.AuthMode {
	case "development", "bearer":
	default:
		return Config{}, errors.New("AUTH_MODE must be development or bearer")
	}
	if configuration.Environment != "development" &&
		configuration.Environment != "test" &&
		configuration.AuthMode == "development" {
		return Config{}, errors.New("development authentication cannot be enabled outside development or test environments")
	}
	if configuration.AuthMode == "development" &&
		configuration.DevelopmentUserID != "" &&
		len(configuration.DevelopmentUserID) != 36 {
		return Config{}, errors.New("DEVELOPMENT_USER_ID must be a UUID")
	}

	return configuration, nil
}

func env(key, fallback string) string {
	if value := strings.TrimSpace(os.Getenv(key)); value != "" {
		return value
	}
	return fallback
}

func envInt(key string, fallback int) (int, error) {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback, nil
	}
	parsed, err := strconv.Atoi(value)
	if err != nil {
		return 0, fmt.Errorf("%s must be an integer: %w", key, err)
	}
	return parsed, nil
}

func envDuration(key string, fallback time.Duration) (time.Duration, error) {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback, nil
	}
	parsed, err := time.ParseDuration(value)
	if err != nil {
		return 0, fmt.Errorf("%s must be a duration: %w", key, err)
	}
	return parsed, nil
}

func envInt64(key string, fallback int64) (int64, error) {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback, nil
	}
	parsed, err := strconv.ParseInt(value, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("%s must be an integer: %w", key, err)
	}
	return parsed, nil
}

func envBool(key string, fallback bool) (bool, error) {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback, nil
	}
	parsed, err := strconv.ParseBool(value)
	if err != nil {
		return false, fmt.Errorf("%s must be a boolean: %w", key, err)
	}
	return parsed, nil
}
