package main

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/httpapi"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/internal/services"
	"github.com/visualkit/backend/internal/storage"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
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
	jobQueue := queue.JobQueue(queue.NewMemoryPublisher())
	if configuration.SQSQueueURL != "" {
		jobQueue, err = queue.NewSQSJobQueue(ctx, queue.SQSConfig{
			QueueURL: configuration.SQSQueueURL,
			Region:   configuration.SQSRegion,
		})
		if err != nil {
			logger.Error("job queue initialization failed", slog.Any("error", err))
			os.Exit(1)
		}
	}

	app := httpapi.NewServer(httpapi.Dependencies{
		Config:   configuration,
		Logger:   logger,
		Pool:     pool,
		Services: services.NewSet(repositories.NewSet(pool), configuration, objectStorage, jobQueue),
	})

	server := &http.Server{
		Addr:              ":" + configuration.Port,
		Handler:           app.Handler(),
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      30 * time.Second,
		IdleTimeout:       60 * time.Second,
		MaxHeaderBytes:    32 << 10,
	}

	go func() {
		logger.Info("visualkit backend listening", slog.String("address", server.Addr))
		if serveErr := server.ListenAndServe(); serveErr != nil &&
			!errors.Is(serveErr, http.ErrServerClosed) {
			logger.Error("http server failed", slog.Any("error", serveErr))
			stop()
		}
	}()

	<-ctx.Done()
	shutdownContext, cancel := context.WithTimeout(context.Background(), configuration.ShutdownTimeout)
	defer cancel()
	if err := server.Shutdown(shutdownContext); err != nil {
		logger.Error("http shutdown failed", slog.Any("error", err))
	}
}
