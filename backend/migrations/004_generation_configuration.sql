ALTER TABLE templates
    ADD COLUMN IF NOT EXISTS prompt_directives JSONB NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS default_settings JSONB NOT NULL DEFAULT '{}'::jsonb,
    ADD COLUMN IF NOT EXISTS preview_asset_id UUID REFERENCES image_assets(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;

UPDATE templates
SET prompt_directives = CASE slug
    WHEN 'cinematic' THEN '["cinematic composition", "controlled contrast", "atmospheric depth", "film-inspired visual language"]'::jsonb
    WHEN 'fashion' THEN '["art-directed fashion composition", "expressive posing", "refined styling", "editorial polish"]'::jsonb
    WHEN 'product-photography' THEN '["clean studio lighting", "considered product placement", "material detail", "commercial clarity"]'::jsonb
    WHEN 'travel' THEN '["sense of place", "natural atmosphere", "environmental storytelling", "memorable detail"]'::jsonb
    WHEN 'portrait' THEN '["intentional portrait framing", "expressive presence", "flattering light", "clear focal subject"]'::jsonb
    WHEN 'editorial' THEN '["art-directed composition", "visual restraint", "editorial hierarchy", "polished details"]'::jsonb
    WHEN 'anime' THEN '["expressive stylization", "graphic shapes", "vivid color relationships", "animated visual energy"]'::jsonb
    WHEN '3d' THEN '["dimensional forms", "believable materials", "soft studio light", "polished 3D presentation"]'::jsonb
    WHEN 'minimal' THEN '["visual restraint", "negative space", "simple forms", "calm intentional composition"]'::jsonb
    WHEN 'social-media' THEN '["clear focal point", "immediate visual impact", "readable contrast", "feed-friendly framing"]'::jsonb
    ELSE prompt_directives
END,
default_settings = generation_settings
WHERE prompt_directives = '[]'::jsonb OR default_settings = '{}'::jsonb;

CREATE INDEX IF NOT EXISTS templates_active_idx ON templates(is_active);
