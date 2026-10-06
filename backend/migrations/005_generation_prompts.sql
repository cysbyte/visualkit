ALTER TABLE creations
    ADD COLUMN IF NOT EXISTS original_prompt TEXT,
    ADD COLUMN IF NOT EXISTS resolved_generation_prompt TEXT;

UPDATE creations
SET original_prompt = COALESCE(NULLIF(original_prompt, ''), prompt)
WHERE original_prompt IS NULL OR original_prompt = '';

CREATE INDEX IF NOT EXISTS creations_original_prompt_idx
    ON creations(user_id, created_at DESC);
