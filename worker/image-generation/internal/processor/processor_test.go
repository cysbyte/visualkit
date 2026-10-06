package processor

import (
	"context"
	"testing"
)

func TestMockGeneration(t *testing.T) {
	result, err := NewMock().Process(context.Background(), Job{ID: "job_1"})
	if err != nil {
		t.Fatal(err)
	}
	if result.OutputImageReference == "" {
		t.Fatal("expected mock image reference")
	}
}
