UPDATE templates
SET thumbnail_url = CASE slug
    WHEN 'editorial' THEN 'template-thumbnails/template-editorial-poster.png'
    WHEN 'product-photography' THEN 'template-thumbnails/template-studio-product.png'
    WHEN '3d' THEN 'template-thumbnails/template-saas-dashboard.png'
    ELSE thumbnail_url
END
WHERE slug IN ('editorial', 'product-photography', '3d');
