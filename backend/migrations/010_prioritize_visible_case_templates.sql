UPDATE templates
SET featured = CASE
        WHEN slug IN ('case-542', 'case-543', 'case-440') THEN TRUE
        ELSE featured
    END,
    updated_at = NOW()
WHERE slug IN ('case-542', 'case-543', 'case-440');
