ALTER TABLE jobs
    ADD COLUMN IF NOT EXISTS type TEXT,
    ADD COLUMN IF NOT EXISTS input JSONB NOT NULL DEFAULT '{}'::jsonb,
    ADD COLUMN IF NOT EXISTS output JSONB NOT NULL DEFAULT '{}'::jsonb,
    ADD COLUMN IF NOT EXISTS error_code TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS attempts INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS idempotency_key TEXT,
    ADD COLUMN IF NOT EXISTS started_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ;

UPDATE jobs
SET type = COALESCE(NULLIF(type, ''), kind),
    input = CASE WHEN input = '{}'::jsonb THEN request ELSE input END,
    output = CASE WHEN output = '{}'::jsonb THEN result ELSE output END
WHERE type IS NULL OR type = '' OR input = '{}'::jsonb OR output = '{}'::jsonb;

ALTER TABLE jobs
    ALTER COLUMN type SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'jobs_type_check'
          AND conrelid = 'jobs'::regclass
    ) THEN
        ALTER TABLE jobs
        ADD CONSTRAINT jobs_type_check
        CHECK (type IN ('image_analysis', 'image_generation'));
    END IF;
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'jobs_status_check'
          AND conrelid = 'jobs'::regclass
    ) THEN
        ALTER TABLE jobs
        ADD CONSTRAINT jobs_status_check
        CHECK (status IN ('queued', 'processing', 'completed', 'failed', 'cancelled'));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS jobs_type_idx ON jobs(type);
CREATE INDEX IF NOT EXISTS jobs_idempotency_key_idx
    ON jobs(user_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS jobs_user_id_idempotency_key_unique_idx
    ON jobs(user_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;
