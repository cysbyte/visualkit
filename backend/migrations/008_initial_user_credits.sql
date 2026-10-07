CREATE UNIQUE INDEX IF NOT EXISTS credit_ledger_initial_grant_idx
    ON credit_ledger(user_id)
    WHERE type = 'subscription_grant' AND reference_type = 'initial_grant';

INSERT INTO credit_ledger (
    id, user_id, type, reference_type, metadata,
    amount, reason, created_at
)
SELECT
    gen_random_uuid(),
    users.id,
    'subscription_grant',
    'initial_grant',
    '{"grant":"initial"}'::jsonb,
    100,
    'subscription_grant',
    NOW()
FROM users
ON CONFLICT DO NOTHING;
