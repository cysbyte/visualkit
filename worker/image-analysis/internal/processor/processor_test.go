package processor

import (
	"context"
	"testing"
)

func TestMockAnalysis(t *testing.T) {
	result, err := NewMock().Process(context.Background(), Job{ID: "job_1"})
	if err != nil {
		t.Fatal(err)
	}
	if len(result.VisualDNA["style"]) == 0 {
		t.Fatal("expected mock style attributes")
	}
}
