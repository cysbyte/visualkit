CREATE TABLE IF NOT EXISTS web_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    email TEXT NOT NULL DEFAULT '',
    message TEXT NOT NULL CHECK (char_length(message) BETWEEN 10 AND 2000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS web_feedback_created_at_idx ON web_feedback(created_at DESC);
