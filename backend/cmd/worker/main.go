package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"

	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/providers"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
	"github.com/visualkit/backend/internal/worker"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger)
	configuration, err := config.Load()
	if err != nil {
		logger.Error("invalid configuration", slog.Any("error", err))
		os.Exit(1)
	}
	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	pool, err := database.NewPool(ctx, configuration)
	if err != nil {
		logger.Error("database connection failed", slog.Any("error", err))
		os.Exit(1)
	}
	defer pool.Close()

	repositories := repositories.NewSet(pool)
	objectStorage := storage.ObjectStorage(storage.NewMockObjectStorage())
	if configuration.S3Bucket != "" || configuration.S3Region != "" {
		objectStorage, err = storage.NewS3ObjectStorage(ctx, storage.S3Config{
			Bucket: configuration.S3Bucket,
			Region: configuration.S3Region,
		})
		if err != nil {
			logger.Error("object storage initialization failed", slog.Any("error", err))
			os.Exit(1)
		}
	}
	var consumer queue.JobConsumer
	if configuration.SQSQueueURL != "" {
		consumer, err = queue.NewSQSJobQueue(ctx, queue.SQSConfig{
			QueueURL: configuration.SQSQueueURL,
			Region:   configuration.SQSRegion,
		})
		if err != nil {
			logger.Error("job queue initialization failed", slog.Any("error", err))
			os.Exit(1)
		}
	} else {
		consumer = queue.NewMemoryPublisher()
	}
	jobService := services.JobService{
		Users:                repositories.Users,
		Assets:               repositories.Assets,
		Jobs:                 repositories.Jobs,
		Templates:            repositories.Templates,
		Credits:              repositories.Credits,
		GenerationCreditCost: configuration.GenerationCreditCost,
		Queue:                queue.NewMemoryPublisher(),
	}
	imageGenerator, err := providers.NewImageGenerationProvider(
		configuration.ImageGenerationProvider,
		configuration.ImageGenerationEndpoint,
		configuration.ImageGenerationModel,
		configuration.ImageGenerationAPIKey,
	)
	if err != nil {
		logger.Error("image generation provider configuration failed", slog.Any("error", err))
		os.Exit(1)
	}
	visionProvider, err := providers.NewVisionProvider(
		configuration.VisionProvider,
		configuration.VisionEndpoint,
		configuration.VisionAPIKey,
	)
	if err != nil {
		logger.Error("vision provider configuration failed", slog.Any("error", err))
		os.Exit(1)
	}
	processors := worker.ProcessorSet{
		Analysis: worker.ImageAnalysisProcessor{
			Assets:          repositories.Assets,
			Jobs:            jobService,
			Storage:         objectStorage,
			Vision:          visionProvider,
			ProviderTimeout: configuration.WorkerProviderTimeout,
		},
		Generation: worker.ImageGenerationProcessor{
			Assets:          repositories.Assets,
			Creations:       repositories.Creations,
			Templates:       repositories.Templates,
			Jobs:            jobService,
			Storage:         objectStorage,
			Generator:       imageGenerator,
			ProviderTimeout: configuration.WorkerProviderTimeout,
		},
	}
	runner := worker.Runner{
		Consumer:          consumer,
		Jobs:              jobService,
		Processors:        processors,
		Logger:            logger,
		Concurrency:       configuration.WorkerConcurrency,
		LongPollWait:      configuration.WorkerLongPollWait,
		VisibilityTimeout: configuration.WorkerVisibilityTimeout,
		ShutdownTimeout:   configuration.WorkerShutdownTimeout,
		MaxAttempts:       configuration.WorkerMaxAttempts,
	}
	logger.Info("visualkit worker started",
		slog.Int("concurrency", configuration.WorkerConcurrency),
		slog.Duration("visibility_timeout", configuration.WorkerVisibilityTimeout))
	shutdownCtx, cancel := context.WithCancel(ctx)
	defer cancel()
	if err := runner.Run(shutdownCtx); err != nil {
		logger.Error("worker failed", slog.Any("error", err))
		os.Exit(1)
	}
}
