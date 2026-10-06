package services

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/visualkit/backend/internal/database"
	"github.com/visualkit/backend/internal/models"
	"github.com/visualkit/backend/internal/repositories"
	"github.com/visualkit/backend/pkg/api"
)

type creditTestReservation struct {
	amount int
	status string
}

type creditTestRepository struct {
	mu           sync.Mutex
	ledger       []models.CreditLedgerEntry
	reservations map[string]creditTestReservation
}

func newCreditTestRepository() *creditTestRepository {
	return &creditTestRepository{
		reservations: make(map[string]creditTestReservation),
	}
}

func (repository *creditTestRepository) Balance(
	_ context.Context,
	userID uuid.UUID,
) (int, error) {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	total := 0
	for _, entry := range repository.ledger {
		if entry.UserID == userID {
			total += entry.Amount
		}
	}
	return total, nil
}

func (repository *creditTestRepository) Append(
	_ context.Context,
	entry models.CreditLedgerEntry,
) error {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	if entry.ID == uuid.Nil {
		entry.ID = uuid.New()
	}
	if entry.CreatedAt.IsZero() {
		entry.CreatedAt = time.Now().UTC()
	}
	repository.ledger = append(repository.ledger, entry)
	return nil
}

func (repository *creditTestRepository) Reserve(
	_ context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
	amount int,
) error {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	key := creditReservationKey(userID, referenceType, referenceID)
	if existing, ok := repository.reservations[key]; ok {
		if existing.amount != amount {
			return errors.New("credit reservation amount changed")
		}
		return nil
	}
	total := 0
	for _, entry := range repository.ledger {
		if entry.UserID == userID {
			total += entry.Amount
		}
	}
	if total < amount {
		return database.ErrInsufficientCredits
	}
	repository.ledger = append(repository.ledger, models.CreditLedgerEntry{
		ID:            uuid.New(),
		UserID:        userID,
		Type:          models.CreditLedgerTypeGeneration,
		Amount:        -amount,
		ReferenceType: referenceType,
		ReferenceID:   &referenceID,
		CreatedAt:     time.Now().UTC(),
	})
	repository.reservations[key] = creditTestReservation{
		amount: amount,
		status: models.CreditReservationStatusReserved,
	}
	return nil
}

func (repository *creditTestRepository) Consume(
	_ context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
) error {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	reservation, ok := repository.reservations[creditReservationKey(userID, referenceType, referenceID)]
	if !ok || reservation.status == models.CreditReservationStatusConsumed ||
		reservation.status == models.CreditReservationStatusRefunded {
		return nil
	}
	reservation.status = models.CreditReservationStatusConsumed
	repository.reservations[creditReservationKey(userID, referenceType, referenceID)] = reservation
	return nil
}

func (repository *creditTestRepository) Refund(
	_ context.Context,
	userID uuid.UUID,
	referenceType string,
	referenceID uuid.UUID,
) error {
	repository.mu.Lock()
	defer repository.mu.Unlock()
	key := creditReservationKey(userID, referenceType, referenceID)
	reservation, ok := repository.reservations[key]
	if !ok || reservation.status == models.CreditReservationStatusRefunded {
		return nil
	}
	if reservation.status != models.CreditReservationStatusReserved &&
		reservation.status != models.CreditReservationStatusConsumed {
		return errors.New("invalid reservation state")
	}
	amount := reservation.amount
	repository.ledger = append(repository.ledger, models.CreditLedgerEntry{
		ID:            uuid.New(),
		UserID:        userID,
		Type:          models.CreditLedgerTypeRefund,
		Amount:        amount,
		ReferenceType: referenceType,
		ReferenceID:   &referenceID,
		CreatedAt:     time.Now().UTC(),
	})
	reservation.status = models.CreditReservationStatusRefunded
	repository.reservations[key] = reservation
	return nil
}

func creditReservationKey(userID uuid.UUID, referenceType string, referenceID uuid.UUID) string {
	return userID.String() + ":" + referenceType + ":" + referenceID.String()
}

func TestCreditServiceBalanceAndLedgerGrant(t *testing.T) {
	repository := newCreditTestRepository()
	service := CreditService{Credits: repository, GenerationCreditCost: 80}
	userID := uuid.New()
	if err := repository.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypeSubscriptionGrant,
		Amount: 160,
	}); err != nil {
		t.Fatal(err)
	}
	balance, err := service.GetBalance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 160 {
		t.Fatalf("balance = %d, want 160", balance)
	}
}

func TestCreditServiceRejectsInsufficientBalance(t *testing.T) {
	repository := newCreditTestRepository()
	service := CreditService{Credits: repository}
	userID := uuid.New()
	err := service.Reserve(context.Background(), userID, uuid.New(), 80)
	if !errors.Is(err, api.ErrInsufficientCredits) {
		t.Fatalf("error = %v, want insufficient credits", err)
	}
}

func TestCreditRepositoryConcurrentReservationsCannotDoubleSpend(t *testing.T) {
	repository := newCreditTestRepository()
	userID := uuid.New()
	if err := repository.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 80,
	}); err != nil {
		t.Fatal(err)
	}
	var wait sync.WaitGroup
	successes := make(chan error, 2)
	for range 2 {
		wait.Add(1)
		go func() {
			defer wait.Done()
			successes <- repository.Reserve(
				context.Background(),
				userID,
				models.JobTypeImageGeneration,
				uuid.New(),
				80,
			)
		}()
	}
	wait.Wait()
	close(successes)
	successCount := 0
	for err := range successes {
		if err == nil {
			successCount++
		} else if !errors.Is(err, database.ErrInsufficientCredits) {
			t.Fatalf("reservation error = %v", err)
		}
	}
	if successCount != 1 {
		t.Fatalf("successful reservations = %d, want 1", successCount)
	}
}

func TestGenerationJobConsumesCreditsAndReusesReservation(t *testing.T) {
	repository := newJobTestRepository()
	credits := newCreditTestRepository()
	userID := uuid.New()
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 80,
	}); err != nil {
		t.Fatal(err)
	}
	service := newJobService(repository, &jobTestQueue{})
	service.Credits = credits
	service.GenerationCreditCost = 80
	key := uuid.New().String()
	input := CreateGenerationInput{
		UserPrompt: "A city street",
		TemplateID: uuid.New(),
		GenerationSettings: models.GenerationSettings{
			AspectRatio: "1:1",
		},
	}
	first, err := service.CreateGenerationJob(context.Background(), userID, input, key)
	if err != nil {
		t.Fatal(err)
	}
	second, err := service.CreateGenerationJob(context.Background(), userID, input, key)
	if err != nil {
		t.Fatal(err)
	}
	if first.ID != second.ID {
		t.Fatalf("job IDs differ: %s and %s", first.ID, second.ID)
	}
	balance, err := credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 0 {
		t.Fatalf("reserved balance = %d, want 0", balance)
	}
	if _, err := service.CompleteJob(context.Background(), first.ID, map[string]any{"creation_id": uuid.New().String()}); err != nil {
		t.Fatal(err)
	}
	balance, err = credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 0 {
		t.Fatalf("consumed balance = %d, want 0", balance)
	}
}

func TestFailedGenerationRefundsCredits(t *testing.T) {
	repository := newJobTestRepository()
	credits := newCreditTestRepository()
	service := newJobService(repository, &jobTestQueue{})
	service.Credits = credits
	userID := uuid.New()
	jobID := uuid.New()
	repository.jobs[jobID] = models.Job{
		ID:     jobID,
		UserID: userID,
		Type:   models.JobTypeImageGeneration,
		Status: models.JobStatusProcessing,
	}
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 80,
	}); err != nil {
		t.Fatal(err)
	}
	if err := credits.Reserve(context.Background(), userID, models.JobTypeImageGeneration, jobID, 80); err != nil {
		t.Fatal(err)
	}
	if _, err := service.FailJob(context.Background(), jobID, JobErrorCodePermanent, "provider failed"); err != nil {
		t.Fatal(err)
	}
	balance, err := credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 80 {
		t.Fatalf("refunded balance = %d, want 80", balance)
	}
}

func TestRetryableGenerationFailureKeepsCreditsReserved(t *testing.T) {
	repository := newJobTestRepository()
	credits := newCreditTestRepository()
	service := newJobService(repository, &jobTestQueue{})
	service.Credits = credits
	userID := uuid.New()
	jobID := uuid.New()
	repository.jobs[jobID] = models.Job{
		ID:     jobID,
		UserID: userID,
		Type:   models.JobTypeImageGeneration,
		Status: models.JobStatusProcessing,
	}
	if err := credits.Append(context.Background(), models.CreditLedgerEntry{
		UserID: userID,
		Type:   models.CreditLedgerTypePurchase,
		Amount: 80,
	}); err != nil {
		t.Fatal(err)
	}
	if err := credits.Reserve(context.Background(), userID, models.JobTypeImageGeneration, jobID, 80); err != nil {
		t.Fatal(err)
	}
	if _, err := service.RequeueRetry(context.Background(), jobID, JobErrorCodeRetryable, "provider timeout"); err != nil {
		t.Fatal(err)
	}
	balance, err := credits.Balance(context.Background(), userID)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 0 {
		t.Fatalf("balance after retryable failure = %d, want 0", balance)
	}
}

var _ repositories.CreditRepository = (*creditTestRepository)(nil)
