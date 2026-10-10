package worker

import (
	"context"
	"errors"
	"log/slog"
	"sync"
	"time"

	"github.com/visualkit/backend/internal/jobs"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/providers"
	"github.com/visualkit/backend/internal/queue"
	"github.com/visualkit/backend/internal/services"
)

type Runner struct {
	Consumer          queue.JobConsumer
	Jobs              services.JobService
	Processors        ProcessorSet
	Logger            *slog.Logger
	Concurrency       int
	LongPollWait      time.Duration
	VisibilityTimeout time.Duration
	ShutdownTimeout   time.Duration
	MaxAttempts       int
}

func (runner Runner) Run(ctx context.Context) error {
	if runner.Consumer == nil {
		return errors.New("job consumer is required")
	}
	if runner.Concurrency < 1 {
		runner.Concurrency = 1
	}
	if runner.LongPollWait <= 0 {
		runner.LongPollWait = 20 * time.Second
	}
	if runner.VisibilityTimeout <= 0 {
		runner.VisibilityTimeout = 5 * time.Minute
	}
	if runner.ShutdownTimeout <= 0 {
		runner.ShutdownTimeout = 30 * time.Second
	}
	if runner.MaxAttempts < 1 {
		runner.MaxAttempts = 3
	}
	logger := runner.Logger
	if logger == nil {
		logger = slog.Default()
	}

	sem := make(chan struct{}, runner.Concurrency)
	var wg sync.WaitGroup
	processingContext, cancelProcessing := context.WithCancel(context.Background())
	defer cancelProcessing()
	for {
		select {
		case <-ctx.Done():
			return waitForActiveJobs(&wg, runner.ShutdownTimeout, cancelProcessing)
		default:
		}
		messages, err := runner.Consumer.Receive(ctx, runner.Concurrency, runner.LongPollWait, runner.VisibilityTimeout)
		if err != nil {
			if ctx.Err() != nil {
				return waitForActiveJobs(&wg, runner.ShutdownTimeout, cancelProcessing)
			}
			logger.Error("worker receive failed", slog.Any("error", err))
			continue
		}
		for _, message := range messages {
			select {
			case <-ctx.Done():
				return waitForActiveJobs(&wg, runner.ShutdownTimeout, cancelProcessing)
			case sem <- struct{}{}:
			}
			wg.Add(1)
			go func(message queue.ReceivedJobMessage) {
				defer wg.Done()
				defer func() { <-sem }()
				if runner.HandleMessage(processingContext, message) {
					if err := runner.Consumer.Delete(context.Background(), message.ReceiptHandle); err != nil {
						logger.Error("worker delete failed",
							slog.String("job_id", message.JobID.String()),
							slog.String("job_type", message.Type),
							slog.Any("error", err))
					}
				}
			}(message)
		}
	}
}

func waitForActiveJobs(wg *sync.WaitGroup, timeout time.Duration, cancel context.CancelFunc) error {
	done := make(chan struct{})
	go func() {
		defer close(done)
		wg.Wait()
	}()
	select {
	case <-done:
		return nil
	case <-time.After(timeout):
		cancel()
		return context.DeadlineExceeded
	}
}

func (runner Runner) HandleMessage(ctx context.Context, message queue.ReceivedJobMessage) bool {
	logger := runner.Logger
	if logger == nil {
		logger = slog.Default()
	}
	start := time.Now()
	attrs := []any{
		slog.String("job_id", message.JobID.String()),
		slog.String("job_type", message.Type),
		slog.Int("attempt", message.Attempt),
	}
	job, claimed, err := runner.Jobs.ClaimProcessing(ctx, message.JobID, message.Attempt)
	if err != nil {
		logger.Error("worker claim failed", append(attrs, slog.Any("error", err))...)
		return false
	}
	if !claimed {
		logger.Info("worker skipped job", append(attrs,
			slog.String("status", job.Status),
			slog.Duration("duration", time.Since(start)))...)
		return true
	}
	attrs = append(attrs, slog.String("user_id", job.UserID.String()))
	attrs = append(attrs, slog.Int("durable_attempt", job.Attempts))
	if job.Status == models.JobStatusCancelled {
		return true
	}
	processor, ok := runner.Processors.ForType(job.Type)
	if !ok {
		if _, err := runner.Jobs.FailJob(ctx, job.ID, "UNSUPPORTED_JOB_TYPE", "no processor registered"); err != nil {
			logger.Error("worker terminal failure persistence failed", append(attrs,
				slog.Duration("duration", time.Since(start)),
				slog.Any("error", err))...)
			return false
		}
		logger.Error("worker unsupported job type", append(attrs,
			slog.Duration("duration", time.Since(start)))...)
		return true
	}
	err = processor.Process(ctx, &job)
	if err == nil {
		logger.Info("worker job completed", append(attrs,
			slog.Duration("duration", time.Since(start)),
			slog.Bool("success", true))...)
		return true
	}
	class := jobs.ClassifyError(err)
	var providerError *providers.ProviderError
	if errors.As(err, &providerError) {
		logger.Warn("worker provider failure", append(attrs,
			slog.String("provider_error_code", providerError.Code),
			slog.Int("provider_http_status", providerError.HTTPStatus),
			slog.String("provider_response_code", providerError.ResponseCode),
			slog.String("provider_response_type", providerError.ResponseType),
			slog.String("provider_response_param", providerError.ResponseParam),
			slog.String("provider_response_hint", providerError.ResponseHint),
			slog.String("provider_request_id", providerError.ProviderRequestID),
			slog.String("request_model", providerError.RequestModel),
			slog.String("request_size", providerError.RequestSize),
			slog.String("request_mode", providerError.RequestMode),
			slog.Int("request_image_count", providerError.RequestImageCount),
			slog.Bool("retryable", providerError.Retryable))...)
	}
	if class == jobs.ErrorClassRetryable && job.Attempts < runner.MaxAttempts {
		if _, err := runner.Jobs.RequeueRetry(ctx, job.ID, services.JobErrorCodeRetryable, "retryable worker error"); err != nil {
			logger.Error("worker retry state persistence failed", append(attrs,
				slog.Duration("duration", time.Since(start)),
				slog.Any("error", err))...)
			return false
		}
		logger.Warn("worker job retryable failure", append(attrs,
			slog.Duration("duration", time.Since(start)),
			slog.String("error_class", string(class)),
			slog.Any("error", err))...)
		return false
	}
	if _, err := runner.Jobs.FailJob(ctx, job.ID, services.JobErrorCodePermanent, "worker failed permanently"); err != nil {
		logger.Error("worker terminal failure persistence failed", append(attrs,
			slog.Duration("duration", time.Since(start)),
			slog.Any("error", err))...)
		return false
	}
	logger.Error("worker job failed", append(attrs,
		slog.Duration("duration", time.Since(start)),
		slog.String("error_class", string(class)),
		slog.Any("error", err))...)
	return true
}
