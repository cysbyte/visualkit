package jobs

import (
	"strconv"
	"sync"
	"time"
)

type Status string

const (
	StatusQueued     Status = "queued"
	StatusProcessing Status = "processing"
	StatusCompleted  Status = "completed"
	StatusFailed     Status = "failed"
	StatusCancelled  Status = "cancelled"
)

type Kind string

const (
	KindImageAnalysis   Kind = "image_analysis"
	KindImageGeneration Kind = "image_generation"
)

type CreateRequest struct {
	Kind    Kind           `json:"kind"`
	Payload map[string]any `json:"payload,omitempty"`
}

type Job struct {
	ID           string         `json:"id"`
	Kind         Kind           `json:"kind"`
	Status       Status         `json:"status"`
	Result       map[string]any `json:"result,omitempty"`
	ErrorMessage string         `json:"errorMessage,omitempty"`
	CreatedAt    time.Time      `json:"createdAt"`
	UpdatedAt    time.Time      `json:"updatedAt"`
}

type MemoryStore struct {
	mu   sync.RWMutex
	next int
	jobs map[string]Job
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{jobs: make(map[string]Job)}
}

func (store *MemoryStore) Create(request CreateRequest) Job {
	store.mu.Lock()
	defer store.mu.Unlock()

	store.next++
	now := time.Now().UTC()
	job := Job{
		ID:        "job_" + strconv.Itoa(store.next),
		Kind:      request.Kind,
		Status:    StatusQueued,
		CreatedAt: now,
		UpdatedAt: now,
	}
	store.jobs[job.ID] = job
	return job
}

func (store *MemoryStore) Get(id string) (Job, bool) {
	store.mu.RLock()
	defer store.mu.RUnlock()
	job, ok := store.jobs[id]
	return job, ok
}
