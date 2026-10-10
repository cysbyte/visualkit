CREATE TABLE IF NOT EXISTS saved_ecommerce_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    platform TEXT NOT NULL,
    workflow TEXT NOT NULL,
    platform_selected BOOLEAN NOT NULL,
    name TEXT NOT NULL CHECK (char_length(name) BETWEEN 1 AND 80),
    data JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, platform, workflow, platform_selected, name)
);

CREATE INDEX IF NOT EXISTS saved_ecommerce_workflows_user_idx ON saved_ecommerce_workflows(user_id, updated_at DESC);
