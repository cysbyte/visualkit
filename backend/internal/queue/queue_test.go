package queue

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/google/uuid"
)

func TestMemoryPublisher(t *testing.T) {
	publisher := NewMemoryPublisher()
	if err := publisher.Publish(Message{JobID: "job_1", Kind: "image_generation"}); err != nil {
		t.Fatal(err)
	}
	if len(publisher.Messages()) != 1 {
		t.Fatal("expected one published message")
	}
}

func TestJobMessageIsSmallIdentifierOnlyPayload(t *testing.T) {
	message := JobMessage{
		JobID:   uuid.New(),
		Type:    "image_generation",
		Attempt: 1,
	}
	payload, err := json.Marshal(message)
	if err != nil {
		t.Fatal(err)
	}
	var decoded map[string]any
	if err := json.Unmarshal(payload, &decoded); err != nil {
		t.Fatal(err)
	}
	if len(decoded) != 3 {
		t.Fatalf("payload fields = %d, want 3", len(decoded))
	}
	if decoded["type"] != "image_generation" || decoded["attempt"] != float64(1) {
		t.Fatalf("payload = %s, want job identifiers", payload)
	}
	if _, ok := decoded["job_id"]; !ok {
		t.Fatalf("payload = %s, want job_id", payload)
	}
}

func TestMemoryPublisherEnqueuesJobMessage(t *testing.T) {
	publisher := NewMemoryPublisher()
	jobID := uuid.New()
	if err := publisher.Enqueue(context.Background(), JobMessage{
		JobID:   jobID,
		Type:    "image_analysis",
		Attempt: 2,
	}); err != nil {
		t.Fatal(err)
	}
	messages := publisher.JobMessages()
	if len(messages) != 1 || messages[0].JobID != jobID || messages[0].Attempt != 2 {
		t.Fatalf("messages = %#v, want one job message", messages)
	}
}
