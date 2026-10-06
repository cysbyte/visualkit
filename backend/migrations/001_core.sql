CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS image_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    object_key TEXT NOT NULL,
    filename TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    byte_size BIGINT NOT NULL DEFAULT 0,
    pixel_width INTEGER NOT NULL DEFAULT 0,
    pixel_height INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    category TEXT NOT NULL DEFAULT '',
    prompt_instructions TEXT NOT NULL DEFAULT '',
    recommended_aspect_ratio TEXT NOT NULL DEFAULT '1:1',
    generation_settings JSONB NOT NULL DEFAULT '{}'::jsonb,
    thumbnail_url TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS saved_styles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    preview_asset_id UUID REFERENCES image_assets(id) ON DELETE SET NULL,
    visual_dna JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    kind TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'queued',
    progress INTEGER NOT NULL DEFAULT 0,
    error_message TEXT NOT NULL DEFAULT '',
    request JSONB NOT NULL DEFAULT '{}'::jsonb,
    result JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS creations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    generated_asset_id UUID REFERENCES image_assets(id) ON DELETE SET NULL,
    thumbnail_asset_id UUID REFERENCES image_assets(id) ON DELETE SET NULL,
    reference_asset_id UUID REFERENCES image_assets(id) ON DELETE SET NULL,
    prompt TEXT NOT NULL,
    template_id UUID REFERENCES templates(id) ON DELETE SET NULL,
    visual_dna JSONB,
    preservation_settings JSONB NOT NULL DEFAULT '{}'::jsonb,
    generation_settings JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'processing',
    failure_message TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS generations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    creation_id UUID REFERENCES creations(id) ON DELETE SET NULL,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE RESTRICT,
    request JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'queued',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS credit_ledger (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    reason TEXT NOT NULL,
    reference_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS image_assets_user_id_idx ON image_assets(user_id);
CREATE INDEX IF NOT EXISTS image_assets_status_idx ON image_assets(status);
CREATE INDEX IF NOT EXISTS image_assets_created_at_idx ON image_assets(created_at DESC);
CREATE INDEX IF NOT EXISTS saved_styles_user_id_idx ON saved_styles(user_id);
CREATE INDEX IF NOT EXISTS saved_styles_created_at_idx ON saved_styles(created_at DESC);
CREATE INDEX IF NOT EXISTS jobs_user_id_idx ON jobs(user_id);
CREATE INDEX IF NOT EXISTS jobs_status_idx ON jobs(status);
CREATE INDEX IF NOT EXISTS jobs_kind_idx ON jobs(kind);
CREATE INDEX IF NOT EXISTS jobs_created_at_idx ON jobs(created_at DESC);
CREATE INDEX IF NOT EXISTS creations_user_id_idx ON creations(user_id);
CREATE INDEX IF NOT EXISTS creations_status_idx ON creations(status);
CREATE INDEX IF NOT EXISTS creations_created_at_idx ON creations(created_at DESC);
CREATE INDEX IF NOT EXISTS generations_user_id_idx ON generations(user_id);
CREATE INDEX IF NOT EXISTS generations_status_idx ON generations(status);
CREATE INDEX IF NOT EXISTS credit_ledger_user_id_idx ON credit_ledger(user_id);
CREATE INDEX IF NOT EXISTS credit_ledger_created_at_idx ON credit_ledger(created_at DESC);

INSERT INTO templates (
    slug, name, description, category, prompt_instructions,
    recommended_aspect_ratio, generation_settings
) VALUES
    ('cinematic', 'Cinematic', 'Atmosphere, depth, and a filmic point of view.', 'cinematic',
     'Use cinematic composition, controlled contrast, atmospheric depth, and film-inspired visual language.',
     '16:9', '{"aspectRatio":"16:9"}'),
    ('fashion', 'Fashion', 'Confident editorial framing with expressive styling.', 'fashion',
     'Use art-directed fashion composition, expressive posing, refined styling, and editorial polish.',
     '4:5', '{"aspectRatio":"4:5"}'),
    ('product-photography', 'Product Photography', 'Clean studio light and precise product focus.', 'product',
     'Use clean studio lighting, considered product placement, material detail, and commercial clarity.',
     '1:1', '{"aspectRatio":"1:1"}'),
    ('travel', 'Travel', 'Sense of place, natural light, and lived-in detail.', 'travel',
     'Emphasize sense of place, natural atmosphere, environmental storytelling, and memorable detail.',
     '16:9', '{"aspectRatio":"16:9"}'),
    ('portrait', 'Portrait', 'Human presence with intentional focus and mood.', 'portrait',
     'Use intentional portrait framing, expressive presence, flattering light, and a clear focal subject.',
     '4:5', '{"aspectRatio":"4:5"}'),
    ('editorial', 'Editorial', 'Art-directed polish with a point of view.', 'editorial',
     'Use art-directed composition, visual restraint, editorial hierarchy, and polished details.',
     '4:5', '{"aspectRatio":"4:5"}'),
    ('anime', 'Anime', 'Stylized character language with vivid expression.', 'anime',
     'Use expressive stylization, graphic shapes, vivid color relationships, and animated visual energy.',
     '4:5', '{"aspectRatio":"4:5"}'),
    ('3d', '3D', 'Dimensional forms, polished materials, and soft light.', '3d',
     'Use dimensional forms, believable materials, soft studio light, and a polished 3D presentation.',
     '1:1', '{"aspectRatio":"1:1"}'),
    ('minimal', 'Minimal', 'Quiet composition, negative space, and clarity.', 'minimal',
     'Use visual restraint, negative space, simple forms, and a calm, intentional composition.',
     '1:1', '{"aspectRatio":"1:1"}'),
    ('social-media', 'Social Media', 'Immediate visual impact built for vertical feeds.', 'social',
     'Use a clear focal point, immediate visual impact, readable contrast, and feed-friendly vertical framing.',
     '9:16', '{"aspectRatio":"9:16"}')
ON CONFLICT (slug) DO NOTHING;
