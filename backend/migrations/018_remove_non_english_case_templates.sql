DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM templates AS template
        JOIN creations AS creation ON creation.template_id = template.id
        WHERE template.source_case_id IS NOT NULL
          AND template.slug = 'case-' || lpad(template.source_case_id::text, 3, '0')
          AND (
              template.prompt_instructions ~ '[一-鿿ぁ-ヿ가-힣ا-يА-я]'
              OR template.prompt_instructions ~* '^@?Crea una imagen'
              OR EXISTS (
                  SELECT 1
                  FROM jsonb_array_elements_text(template.prompt_directives) AS directive(prompt)
                  WHERE directive.prompt ~ '[一-鿿ぁ-ヿ가-힣ا-يА-я]'
              )
          )
    ) THEN
        RAISE EXCEPTION 'Non-English template is linked to a creation; review before deleting';
    END IF;
END $$;

DELETE FROM templates AS template
WHERE template.source_case_id IS NOT NULL
  AND template.slug = 'case-' || lpad(template.source_case_id::text, 3, '0')
  AND (
      template.prompt_instructions ~ '[一-鿿ぁ-ヿ가-힣ا-يА-я]'
      OR template.prompt_instructions ~* '^@?Crea una imagen'
      OR EXISTS (
          SELECT 1
          FROM jsonb_array_elements_text(template.prompt_directives) AS directive(prompt)
          WHERE directive.prompt ~ '[一-鿿ぁ-ヿ가-힣ا-يА-я]'
      )
  );
