package api

import (
	"net/http/httptest"
	"strings"
	"testing"
)

func TestWriteErrorUsesEnvelope(t *testing.T) {
	recorder := httptest.NewRecorder()
	WriteError(recorder, ErrInvalidRequest)
	if !strings.Contains(recorder.Body.String(), `"error"`) {
		t.Fatal("expected error envelope")
	}
	if recorder.Code != 400 {
		t.Fatalf("status = %d, want 400", recorder.Code)
	}
}
