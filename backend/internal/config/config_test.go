package config

import "testing"

func TestLoadRequiresDatabaseURL(t *testing.T) {
	t.Setenv("DATABASE_URL", "")
	if _, err := Load(); err == nil {
		t.Fatal("expected DATABASE_URL validation error")
	}
}

func TestLoadDefaults(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("APP_ENV", "")
	t.Setenv("PORT", "")
	t.Setenv("DATABASE_MAX_CONNS", "")
	t.Setenv("DATABASE_MIN_CONNS", "")

	configuration, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	if configuration.Port != "8080" {
		t.Fatalf("port = %q, want 8080", configuration.Port)
	}
	if configuration.Environment != "development" {
		t.Fatalf("environment = %q, want development", configuration.Environment)
	}
	if configuration.GenerationCreditCost != 10 {
		t.Fatalf("generation credit cost = %d, want 10", configuration.GenerationCreditCost)
	}
}

func TestLoadRejectsInvalidInteger(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("DATABASE_MAX_CONNS", "bad")
	if _, err := Load(); err == nil {
		t.Fatal("expected integer validation error")
	}
}

func TestLoadAssetStorageDefaults(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("S3_UPLOAD_URL_TTL", "")
	t.Setenv("S3_DOWNLOAD_URL_TTL", "")
	t.Setenv("S3_MAX_ASSET_BYTES", "")
	t.Setenv("S3_VERIFY_OBJECT_ON_COMPLETE", "")

	configuration, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	if configuration.S3UploadURLTTL.Minutes() != 15 {
		t.Fatalf("upload URL TTL = %s, want 15m", configuration.S3UploadURLTTL)
	}
	if configuration.S3DownloadURLTTL.Minutes() != 15 {
		t.Fatalf("download URL TTL = %s, want 15m", configuration.S3DownloadURLTTL)
	}
	if configuration.S3MaxAssetBytes != 25*1024*1024 {
		t.Fatalf("max asset bytes = %d, want 25 MiB", configuration.S3MaxAssetBytes)
	}
	if !configuration.S3VerifyObjectOnComplete {
		t.Fatal("expected object verification to default to true")
	}
}

func TestLoadRejectsInvalidAssetStorageConfiguration(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("S3_MAX_ASSET_BYTES", "0")
	if _, err := Load(); err == nil {
		t.Fatal("expected max asset size validation error")
	}
}

func TestLoadGenerationCreditCostOverride(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("GENERATION_CREDIT_COST", "125")
	configuration, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	if configuration.GenerationCreditCost != 125 {
		t.Fatalf("generation credit cost = %d, want 125", configuration.GenerationCreditCost)
	}
}

func TestLoadProviderConfiguration(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("VISION_PROVIDER", "http")
	t.Setenv("VISION_ENDPOINT", "https://vision.test/analyze")
	t.Setenv("VISION_API_KEY", "vision-secret")
	configuration, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	if configuration.VisionProvider != "http" ||
		configuration.VisionEndpoint != "https://vision.test/analyze" ||
		configuration.VisionAPIKey != "vision-secret" {
		t.Fatalf("vision configuration = %#v", configuration)
	}
}

func TestLoadRejectsInvalidGenerationCreditCost(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("GENERATION_CREDIT_COST", "0")
	if _, err := Load(); err == nil {
		t.Fatal("expected generation credit cost validation error")
	}
}

func TestLoadRejectsDevelopmentAuthOutsideDevelopment(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("APP_ENV", "production")
	t.Setenv("AUTH_MODE", "development")
	if _, err := Load(); err == nil {
		t.Fatal("expected development authentication validation error")
	}
}

func TestLoadAllowsBearerAuthInProduction(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("APP_ENV", "production")
	t.Setenv("AUTH_MODE", "bearer")
	configuration, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	if configuration.AuthMode != "bearer" {
		t.Fatalf("auth mode = %q, want bearer", configuration.AuthMode)
	}
}

func TestLoadRejectsUnknownAuthMode(t *testing.T) {
	t.Setenv("DATABASE_URL", "postgres://localhost/visualkit")
	t.Setenv("AUTH_MODE", "unknown")
	if _, err := Load(); err == nil {
		t.Fatal("expected unknown auth mode validation error")
	}
}
