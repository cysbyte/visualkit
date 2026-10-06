package jobs

import "testing"

func TestMemoryStoreCreatesQueuedJob(t *testing.T) {
	store := NewMemoryStore()
	job := store.Create(CreateRequest{Kind: KindImageGeneration})

	if job.Status != StatusQueued {
		t.Fatalf("status = %q, want %q", job.Status, StatusQueued)
	}
	if job.ID == "" {
		t.Fatal("expected a job ID")
	}

	stored, ok := store.Get(job.ID)
	if !ok {
		t.Fatal("expected created job to be readable")
	}
	if stored.ID != job.ID {
		t.Fatalf("stored ID = %q, want %q", stored.ID, job.ID)
	}
}
