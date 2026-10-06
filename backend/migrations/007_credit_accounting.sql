ALTER TABLE credit_ledger
    ADD COLUMN IF NOT EXISTS type TEXT,
    ADD COLUMN IF NOT EXISTS reference_type TEXT,
    ADD COLUMN IF NOT EXISTS metadata JSONB NOT NULL DEFAULT '{}'::jsonb;

UPDATE credit_ledger
SET type = COALESCE(NULLIF(type, ''), reason)
WHERE type IS NULL OR type = '';

ALTER TABLE credit_ledger
    ALTER COLUMN type SET NOT NULL;

CREATE INDEX IF NOT EXISTS credit_ledger_reference_idx
    ON credit_ledger(user_id, reference_type, reference_id);

CREATE TABLE IF NOT EXISTS credit_reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reference_type TEXT NOT NULL,
    reference_id UUID NOT NULL,
    amount INTEGER NOT NULL CHECK (amount > 0),
    status TEXT NOT NULL DEFAULT 'reserved',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, reference_type, reference_id),
    CHECK (status IN ('reserved', 'consumed', 'refunded'))
);

CREATE INDEX IF NOT EXISTS credit_reservations_user_status_idx
    ON credit_reservations(user_id, status);
