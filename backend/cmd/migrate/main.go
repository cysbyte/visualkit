package main

import (
	"context"
	"log/slog"
	"os"

	"github.com/visualkit/backend/internal/config"
	"github.com/visualkit/backend/internal/database"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	configuration, err := config.Load()
	if err != nil {
		logger.Error("invalid configuration", slog.Any("error", err))
		os.Exit(1)
	}

	ctx := context.Background()
	pool, err := database.NewPool(ctx, configuration)
	if err != nil {
		logger.Error("database connection failed", slog.Any("error", err))
		os.Exit(1)
	}
	defer pool.Close()

	if err := database.RunMigrations(ctx, pool, configuration.MigrationsDir); err != nil {
		logger.Error("database migration failed", slog.Any("error", err))
		os.Exit(1)
	}
	logger.Info("database migrations complete", slog.String("environment", configuration.Environment))
}
