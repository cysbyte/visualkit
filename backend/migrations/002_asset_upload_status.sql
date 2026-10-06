DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'image_assets_status_check'
          AND conrelid = 'image_assets'::regclass
    ) THEN
        ALTER TABLE image_assets
        ADD CONSTRAINT image_assets_status_check
        CHECK (status IN ('pending', 'uploaded', 'processing', 'ready', 'failed', 'deleted'));
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS image_assets_object_key_idx
    ON image_assets(object_key);

ALTER TABLE image_assets
    ADD COLUMN IF NOT EXISTS visual_dna JSONB;
