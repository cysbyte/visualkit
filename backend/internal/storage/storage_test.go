package storage

import (
	"context"
	"testing"
)

func TestMockObjectStorageRetainsObjectBytes(t *testing.T) {
	objectStorage := NewMockObjectStorage()
	input := PutObjectInput{
		ObjectKey:   "users/user/assets/asset/original",
		ContentType: "image/jpeg",
		Data:        []byte("image-bytes"),
	}
	if err := objectStorage.PutObject(context.Background(), input); err != nil {
		t.Fatal(err)
	}
	object, err := objectStorage.GetObject(context.Background(), input.ObjectKey)
	if err != nil {
		t.Fatal(err)
	}
	if string(object.Data) != string(input.Data) {
		t.Fatalf("data = %q, want %q", object.Data, input.Data)
	}
	if object.ContentType != input.ContentType || object.SizeBytes != int64(len(input.Data)) {
		t.Fatalf("metadata = %#v", object.ObjectMetadata)
	}
}
