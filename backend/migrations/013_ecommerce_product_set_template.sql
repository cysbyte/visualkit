INSERT INTO templates (
    slug, name, description, category, prompt_instructions,
    recommended_aspect_ratio, generation_settings, default_settings,
    prompt_directives, styles, scenes, featured, is_active
) VALUES (
    'ecommerce-product-set', 'Product listing image set',
    'Consistent product images for Amazon and Shopify listings.',
    'Products & E-commerce', '', '1:1',
    '{"aspectRatio":"1:1"}'::jsonb, '{"aspectRatio":"1:1"}'::jsonb,
    '[]'::jsonb, '["Product", "Photography"]'::jsonb, '["Commerce"]'::jsonb,
    FALSE, TRUE
)
ON CONFLICT (slug) DO UPDATE
SET is_active = TRUE, updated_at = NOW();
