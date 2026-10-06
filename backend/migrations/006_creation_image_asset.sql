ALTER TABLE creations
    ADD COLUMN IF NOT EXISTS image_asset_id UUID REFERENCES image_assets(id) ON DELETE SET NULL;

UPDATE creations
SET image_asset_id = generated_asset_id
WHERE image_asset_id IS NULL;

CREATE INDEX IF NOT EXISTS creations_image_asset_id_idx
    ON creations(image_asset_id);
