ALTER TABLE templates
    ADD COLUMN IF NOT EXISTS source_case_id INTEGER,
    ADD COLUMN IF NOT EXISTS source_label TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS source_url TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS github_url TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS source_image_path TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS image_alt TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS styles JSONB NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS scenes JSONB NOT NULL DEFAULT '[]'::jsonb,
    ADD COLUMN IF NOT EXISTS featured BOOLEAN NOT NULL DEFAULT FALSE;

CREATE UNIQUE INDEX IF NOT EXISTS templates_source_case_id_idx
    ON templates(source_case_id)
    WHERE source_case_id IS NOT NULL;

UPDATE templates
SET is_active = FALSE, updated_at = NOW()
WHERE source_case_id IS NULL AND slug NOT LIKE 'case-%';

INSERT INTO templates (
    slug, name, description, category, prompt_instructions,
    recommended_aspect_ratio, generation_settings, prompt_directives,
    default_settings, thumbnail_url, source_case_id, source_label,
    source_url, github_url, source_image_path, image_alt, styles, scenes,
    featured, is_active
) VALUES
    ('case-544', 'Preschool Vocabulary Learning Card', 'Template imported from awesome-gpt-image-2 case 544. Source: @Naiknelofar788.', 'Charts & Infographics', 'Create a clean, child-friendly educational vocabulary poster for preschool/kindergarten children, inspired by a simple visual learning card.

Feature [FRUIT] as the main large realistic object on the left, and show a [PART / SLICE / SEGMENT] of the same fruit on the right. Connect the two with a playful dotted curved arrow and a tiny simple stick-figure child pointing toward the smaller part.

Add the word "[FRUIT NAME]" in large bold uppercase letters at the top and "[PART NAME]" in large bold uppercase letters underneath the smaller image. Use a soft white and very light pastel-blue background, rounded image panels, clean spacing, realistic fruit photography, simple blue typography, and minimal playful illustrations.

The overall design should feel bright, educational, modern, uncluttered, and easy for young children to understand, like a premium preschool vocabulary learning card. Vertical 4:5 composition, high resolution, soft lighting, clear labels, no unnecessary decorations.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 544, '@Naiknelofar788', 'https://x.com/Naiknelofar788/status/2092993830220120231', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-544', '/images/case544.jpg', 'Preschool Vocabulary Learning Card', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-543', 'Travel Souvenir Enamel Pin Badge', 'Template imported from awesome-gpt-image-2 case 543. Source: @Emmma__0.', 'Products & E-commerce', 'Turn the reference photo into a travel souvenir enamel pin badge. Compose it as a SCENE, not a single isolated object.

Subject hierarchy: the defining landscape, terrain or landmark of the photo forms the main body of the badge and occupies most of its area. If a person appears prominently in the photo, keep them in the badge as a small, simplified figure at true relative scale within that landscape - the person is an accent, the landscape is the subject. Preserve the original spatial relationship and scale between the figure and the surroundings.

How to render the person: flat enamel color blocks matching their real clothing and hair color from the photo. The face is a smooth plain area of light skin-tone enamel with no drawn facial features - do NOT render the person as a dark or black silhouette, and do NOT black out the face or head. Skin reads as a warm light enamel color, clearly lighter than the clothing.

Styling: thin polished gold outline around the silhouette and along every internal divider, glossy enamel color fill, gentle even lighting with only a soft sheen on the gold lines, very subtle drop shadow. Outer contour follows the scene''s own shape, not a plain rectangle.

Background: flat dark navy coarse linen texture. Badge centered, filling about 60% of the frame.

Avoid: black silhouette figure, blacked-out face, dark featureless head, portrait close-up, detailed facial features, person dominating the badge, cropping out the landscape, three-quarter angle, macro product photography, heavy specular glare, cartoon, realistic scene, text, watermark.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, 'template-thumbnails/template-studio-product.png', 543, '@Emmma__0', 'https://x.com/Emmma__0/status/2093194689222705645', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-543', '/images/case543.jpg', 'Travel Souvenir Enamel Pin Badge', '["Realistic","Product","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-542', 'Black-and-White Typographic Portrait Poster', 'Template imported from awesome-gpt-image-2 case 542. Source: @HustleXR.', 'Posters & Typography', 'High-contrast black and white typographic portrait poster of [HUMAN], shown in side profile with [FEATURE]. Build the portrait with bold black silhouette blocks, sharp negative space, rough ink edges, fragmented stencil shapes, tiny editorial microtext, vertical typographic accents and expressive hand-drawn calligraphic marks. Integrate one large readable text block saying "[TEXT]" in 2 to 4 stacked lines, placed only inside the neck and body area, using oversized scribbled lettering that feels fused into the silhouette. Include a graphic design logo reading "[LOGO]" near the footer. Minimal off-white paper background, asymmetrical layout, cropped vertical composition, experimental editorial poster design, raw ink print texture, aspect ratio 4:5.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, 'template-thumbnails/template-editorial-poster.png', 542, '@HustleXR', 'https://x.com/HustleXR/status/2093206386012230000', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-542', '/images/case542.jpg', 'Black-and-White Typographic Portrait Poster', '["UI","Poster","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-541', '50/50 Mixed-Media Memory Card', 'Template imported from awesome-gpt-image-2 case 541. Source: @Sairah_0.', 'Documents & Publishing', 'Transform the uploaded photo into a vertical mixed-media memory card with a strict 50/50 split.

Keep the original photo unchanged in the top half. In the bottom half, use textured off-white handmade paper and add a muted, irregular color patch matching the photo''s tones.

Redraw the main subjects as a simple dark wax-crayon sketch with loose, imperfect lines and minimal details. Add a short handwritten English phrase and subtle Risograph grain.

Create a quiet, nostalgic Morandi-style aesthetic with generous negative space. Do not add extra elements or copy the reference composition exactly.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 541, '@Sairah_0', 'https://x.com/Sairah_0/status/2093212900160868430', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-541', '/images/case541.jpg', '50/50 Mixed-Media Memory Card', '["UI","Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-540', 'Dreamlike Futuristic World Poster', 'Template imported from awesome-gpt-image-2 case 540. Source: @Naiknelofar788.', 'Illustration & Art', 'Create a visually unforgettable editorial art poster of a dreamlike futuristic world where familiar everyday life meets surreal architecture. Grand sculptural buildings, winding roads, oversized plants, tiny people, unexpected floating elements, dramatic perspective, cinematic atmosphere, and one iconic focal point. Blend vintage travel-poster design with modern luxury editorial aesthetics, sophisticated muted colors, soft natural light, subtle film grain, tactile paper texture, clean geometric shapes, minimal composition, nostalgic yet futuristic, whimsical but premium, highly detailed, instantly recognizable silhouette, Pinterest-worthy, Instagram-viral aesthetic, collectible art print, no clutter, no photorealism, vertical 4:5.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 540, '@Naiknelofar788', 'https://x.com/Naiknelofar788/status/2093230701986672924', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-540', '/images/case540.jpg', 'Dreamlike Futuristic World Poster', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-539', 'Raw Sketchy Portrait Poster', 'Template imported from awesome-gpt-image-2 case 539. Source: @kingofdairyque.', 'Posters & Typography', 'Raw sketchy graphic portrait poster of [HUMAN] wearing [CLOTHING], half-body and large in frame, accompanied closely by [ANIMAL], with a minimal [SCENERY] background. Render in a rough expressive illustrated style with broken black ink contours, loose sketch lines, scratchy hatching, irregular stroke weight, imperfect line edges, fast gestural mark-making, simplified anatomy, flat cel-like shadow blocks, and reduced detail. Use a restrained [COLORS] palette with one dominant warm field, one cool counter-field, dark inked shadows, and a few pale highlight accents. Keep the face oversized and central, crop around mid-torso, and place the animal in the lower foreground or tucked beside the subject, drawn with the same simplified raw linework. Reduce the scenery into only 2 or 3 bold silhouette shapes behind the subject, with no detailed environment rendering. Add a narrow warm off-white poster border and very light print texture. Strong attitude, graphic poster energy, intentionally imperfect strokes, raw and sketchy finish, ar 4:5', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 539, '@kingofdairyque', 'https://x.com/kingofdairyque/status/2093279729717780736', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-539', '/images/case539.jpg', 'Raw Sketchy Portrait Poster', '["Poster","3D"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-538', 'Rubber Stamp Travel Field Notes Poster - Natural', 'Template imported from awesome-gpt-image-2 case 538. Source: @MahnoorAi12.', 'Posters & Typography', 'Rubber Stamp Travel Field Notes Poster - Natural Realism Version

Create a separate "Rubber Stamp Travel Field Notes Poster" for each photo I upload. Output each photo individually. Never create a collage or combine multiple photos.

Use a 4:3 landscape composition with a natural visual transition between the original photograph on the left and the aged-paper field-note area on the right. Do not add an obvious dividing line.

LEFT - ORIGINAL PHOTOGRAPH

The left side should occupy roughly 58% of the frame.

Keep the uploaded photograph visually authentic and recognizable. Preserve the original subject, perspective, terrain, architecture, plants, people, spatial relationships, natural light, shadows, textures, and overall atmosphere.

Do not redesign or reinterpret the photograph.

Only apply a very subtle editorial photo treatment: gentle tonal balancing, restrained color grading, slightly softened highlights, and extremely fine natural film grain. It should still look like a real photograph taken on location rather than an AI-generated image.

Natural cropping is allowed if needed to fit the 4:3 layout, but do not stretch, distort, move, replace, or redraw the main subject.

Avoid excessive sharpness, HDR effects, artificial clarity, cinematic color grading, or overly perfect details.

RIGHT - AGED PAPER FIELD NOTES

The right side should occupy roughly 42% of the frame.

Use warm off-white, slightly aged paper with a believable physical texture. Include very subtle paper fibers, fine grain, faint handling marks, and a matte surface.

Keep large areas completely unprinted.

The paper should feel like a real sheet from an architect''s travel notebook or field journal, not a designed poster background.

Avoid overly strong stains, decorative textures, vintage filters, or artificial grunge.

SMALL RUBBER STAMP

Study the uploaded photograph and identify only the few visual features that make the location immediately recognizable.

Reduce them into a compact, imperfect multi-color rubber stamp impression.

Do not reproduce the photograph element by element.

Simplify aggressively and retain only the most meaningful visual relationships:

- distinctive architecture and silhouette
- important roof, tower, dome, arch, or structural shape
- mountain or terrain contours
- shoreline or road direction
- a few recognizable trees or vegetation forms
- simplified settlement layers
- one or two important foreground shapes when visually relevant

Remove crowds, cars, dense windows, repetitive buildings, tiny vegetation, decorative objects, and insignificant background details.

The result should look like something a traveler could have actually carved into a small rubber stamp, not a miniature illustration of the entire photograph.

Place the stamp in the lower-middle portion of the right paper area, occupying approximately 30-38% of the right section''s height.

Keep generous blank paper around it.

Do not enlarge it into a large illustration.

STAMP COLOR & PRINT CHARACTER

Extract approximately 2-4 muted spot colors naturally from the original photograph.

Possible colors include:

- carbon black
- deep green
- brick or muted red
- ochre
- slate blue
- taupe or earthy brown

Do not force these colors if the photograph suggests a different restrained palette.

Each color should appear as a separate physical ink layer.

Make the print feel genuinely handmade:

- slightly uneven pressure
- tiny gaps in the ink
- dry areas
- paper showing through
- rough carved edges
- irregular line thickness
- small contour breaks
- granular ink texture
- faint ghosting
- slight natural color-layer misregistration
- subtle edge variation

The imperfections should be small and believable, as if the stamp was pressed onto paper by hand.

Avoid perfectly aligned digital layers, smooth vector edges, clean gradients, or artificially exaggerated distress.

The stamp should look physically printed, not digitally illustrated.

FIELD-NOTE TYPOGRAPHY

Generate a small amount of text based only on the actual location and imagery in the photograph:

Location - English name
No. - Number
Three short English keywords
Gregorian calendar year

Place the text below or beside the stamp within the available whitespace.

Use a small, understated typewriter or archival field-note style.

The typography should have very slight mechanical irregularity, as though typed or printed on an old field notebook.

Keep it quiet and secondary to the photograph.

Spell the location and all words correctly.

Do not add slogans, brands, tourist phrases, decorative quotes, or unnecessary text.

OVERALL REALISM

The finished image should feel like a real travel photograph mounted beside a small handmade field stamp on an architect''s personal notebook page.

Prioritize subtle physical realism over visual perfection.

The photograph should remain the strongest visual element.

The stamp should feel like a small fragment of memory extracted from the photograph rather than a second illustration.

Use restrained contrast, natural imperfections, believable paper texture, and slightly imperfect printing.

The final result should feel quiet, tactile, documentary, collectible, and genuinely handmade.

Avoid

Obvious dividing lines, circular seals, postage-stamp borders, perforations, wax seals, sticker layouts, souvenir-card designs, generic travel templates, smooth vector logos, polished digital illustrations, cartoon styling, 3D rendering, plastic textures, glossy gradients, excessive saturation, HDR effects, excessive text, decorative clutter, overly clean geometry, perfectly aligned ink layers, dense miniature architecture, or any alteration/redrawing of the original photograph.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 538, '@MahnoorAi12', 'https://x.com/MahnoorAi12/status/2092221482139349307', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-538', '/images/case538.jpg', 'Rubber Stamp Travel Field Notes Poster - Natural', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-537', 'Use Case: Stylized-concept Asset Type: Vertical Social-media Artwork', 'Template imported from awesome-gpt-image-2 case 537. Source: @PromptSin.', 'Scenes & Storytelling', 'Use case: stylized-concept
Asset type: vertical social-media artwork for the "Your Dark Side" theme

Create an original psychological dark-surrealist scene in a colossal underground archive. Endless shelves of sealed black books rise like skyscrapers and vanish into fog. In the central aisle, a solitary human figure in bone-white clothing kneels before one open book on the floor. No words are visible. From the blank pages rises a delicate life-size figure made entirely of dense black smoke, standing face-to-face with the kneeling person. The smoke figure has no eyes or mouth; instead, its chest contains a small locked crimson door. Thin threads connect that door to the kneeling person''s hands, suggesting a secret self finally acknowledged.

Vertical 9:16 framing, towering shelves create a narrow symmetrical canyon, high-angle shaft of cold silver light, the two figures positioned small in the lower center, immense oppressive scale above them. Black paper, aged stone, floating ash, volumetric fog, subtle polished-floor reflections, premium photorealistic dark concept art, refined editorial composition, quiet dread and introspection rather than horror spectacle.

Color palette: obsidian black, graphite, bone white, cold silver, a single muted crimson accent at the tiny door.

Constraints: entirely original metaphor; blank book pages with absolutely no writing; no recognizable person; no text, symbols, logos, signatures, borders, or watermark.

Avoid: visible letters or runes, portrait close-up, split face, black substance on skin, glowing eyes, gore, skulls, conventional ghosts, fantasy wizard styling, imitation of any named artist.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 537, '@PromptSin', 'https://x.com/PromptSin/status/2092390329890849163', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-537', '/images/case537.jpg', 'Use Case: Stylized-concept Asset Type: Vertical Social-media Artwork', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-536', 'Case 536 Photography and Realism Template', 'Template imported from awesome-gpt-image-2 case 536. Source: @SheBuildsAI_.', 'Photography & Realism', '{
  "title": "WHISPERS OF SPRING",

  "scene": "A peaceful pathway beneath blooming cherry blossom trees during a warm spring afternoon. Pink blossoms fill the canopy overhead while delicate petals drift gracefully through the air. Soft sunlight filters through the branches, creating a dreamy and enchanting atmosphere.",

  "subject": "A young woman walks away from the camera before gently turning her head over her shoulder with a soft, mysterious smile. She wears a flowing natural linen dress that moves gracefully with the breeze, highlighting her delicate facial features and effortless elegance.",

  "detail": "Wind carries countless pink cherry blossom petals across the frame while warm sunlight creates glowing highlights throughout the scene. Every strand of hair moves naturally in the breeze, with ultra realistic skin texture, lifelike fabric folds, soft floral surroundings, and subtle atmospheric haze enhancing the cinematic realism.",

  "atmosphere": "Elegant, peaceful, romantic, dreamy, timeless, cinematic, graceful, and enchanting.",

  "lighting": "Warm spring sunlight filtering through cherry blossom branches, soft natural illumination, glowing highlights, volumetric light rays, gentle ambient shadows, and subtle atmospheric haze.",

  "composition": "Cinematic editorial portrait captured with an 85mm lens, featuring the subject in a three-quarter over-the-shoulder pose. Shallow depth of field, creamy bokeh, balanced framing with flowering trees, soft leading lines, and immersive visual storytelling.",

  "style": "Photorealistic, masterpiece, editorial fashion photography, analog film aesthetic, dreamy pastel color palette, ultra realistic skin texture, highly detailed, shallow depth of field, creamy bokeh, atmospheric haze, HDR, cinematic realism, 8K."
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 536, '@SheBuildsAI_', 'https://x.com/SheBuildsAI_/status/2092431090095149533', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-536', '/images/case536.jpg', 'Case 536 Photography and Realism Template', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-535', 'Create a 12-panel Grid 3 Columns 4 Rows,', 'Template imported from awesome-gpt-image-2 case 535. Source: @Ciri_ai.', 'Characters & People', 'Create a 12-panel grid (3 columns × 4 rows, numbered 1 to 12) showing the SAME person from the reference photo with 12 different hairstyles. This is a hairstyle lookbook. Final image aspect ratio: 4:5 (vertical/portrait).
THE ONLY THING THAT CHANGES BETWEEN PANELS IS THE HAIR ON THE HEAD (shape, style and length only). Everything else stays exactly as in the reference photo.
Identity Anchor (Critical)
The face must be IDENTICAL to the reference photo in every single panel. Preserve exactly: facial bone structure, jawline, cheekbones, nose shape, lips, eye shape and spacing, eyebrows, skin tone, skin texture (pores, natural imperfections), and overall facial proportions. This is the same real person in all 12 frames. Do NOT beautify, slim, or alter the face. Same age, same expression as in the reference.
Mandatory Rules (Do Not Violate)
- NO SUNGLASSES. Eyes must be fully visible in all 12 panels.
- NO ENVIRONMENTAL BACKGROUNDS. Every panel must have a plain, uniform, solid light grey studio backdrop with zero objects, zero textures, zero gradients. Just flat neutral grey.
- Hair COLOR stays exactly as it appears in the reference photo in all 12 panels. Only the shape, length and style changes, never the color.
Keep Identical in Every Panel (Do Not Change)
- MAKEUP AND SKIN: If the person in the reference photo wears makeup, replicate it identically in every panel. Same lip color, same eye makeup, same brow grooming. If they wear no makeup, keep all panels makeup-free. Do NOT add, remove, or alter makeup between panels.
- Clothing: the same clothing visible in the reference photo, replicated exactly.
- Accessories: preserve ALL visible accessories from the reference photo (earrings, necklaces, rings, bracelets, piercings, watch, glasses, etc.). Do not omit, resize, recolor, or restyle any accessory. If the person wears prescription glasses (not sunglasses), keep them in every panel.
- Background: plain solid light grey studio backdrop in every panel. No room, no furniture, no environment.
The 12 Hairstyles
1. Pixie cut: very short, textured, slightly tousled on top with tapered sides and nape
2. Classic bob: chin-length, straight, blunt ends, clean middle part
3. Long layered waves: past the shoulders, soft voluminous waves with face-framing layers
4. Sleek low bun: hair pulled back smoothly into a tight low bun at the nape, no flyaways
5. Curtain bangs with medium-length hair: soft parted fringe framing the face, hair falling just past the shoulders
6. High ponytail: hair pulled up into a sleek high ponytail, smooth crown, length falling behind
7. French bob: short bob ending at the jawline with a soft blunt micro-fringe across the forehead
8. Long straight hair with middle part: very long, sleek, pin-straight, falling well past the shoulders
9. Shaggy wolf cut: medium length, heavy layers, choppy fringe, textured and voluminous with a slightly wild look
10. Elegant updo: hair swept up into a polished chignon with soft face-framing tendrils
11. Short curly crop: short voluminous curls all over, natural texture, tapered at the sides
12. Side-swept Hollywood waves: long glamorous deep side part, sculpted vintage waves cascading over one shoulder
Photographic Specs
Shot on a Canon EOS R5 with an 85mm f/1.4 lens, studio portrait lighting (soft key light, subtle fill), shallow depth of field with sharp focus on the face. PLAIN SOLID LIGHT GREY STUDIO BACKGROUND in every panel. Natural skin rendering with visible pores and realistic hair strands (no plastic or CGI look). Consistent lighting, color grading and exposure across all 12 panels. Photorealistic, high detail, hyperrealistic, 8K. No illustration, no painterly effect, no over-smoothing. NO SUNGLASSES.
Each panel clearly numbered 1 to 12 in the top-left corner. Overall output aspect ratio 4:5.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 535, '@Ciri_ai', 'https://x.com/Ciri_ai/status/2092452220768002400', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-535', '/images/case535.jpg', 'Create a 12-panel Grid 3 Columns 4 Rows,', '["Realistic","Illustration","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-534', 'Create a Medium-sized 9:16 Experimental Editorial Portrait Poster', 'Template imported from awesome-gpt-image-2 case 534. Source: @Goodmanprotocol.', 'Posters & Typography', 'Create a medium-sized 9:16 experimental editorial portrait poster using the following customizable inputs:

Subject: [Adult Male or Female Portrait]
Interference: [Color Split / Narrow Light Beam / Horizontal Cut / Motion Veil]
Title: [Title]
Palette: [Main Neutral Tones + One Accent Color]
Mood: [Sharp / Cinematic / Restrained / Experimental]

Create a striking close-up or waist-up portrait with the subject occupying a strong portion of the frame. Preserve realistic facial features, natural skin texture, authentic hair, realistic proportions, clear emotion, and a strong silhouette. The portrait must work visually as a fashion photograph before the graphic intervention is applied.

Use only one primary interference method:

Color Split: Uneven translucent bands selectively shift, reveal, separate, or distort portions of the portrait.

Narrow Light Beam: A single controlled beam cuts across the face or body and continues naturally into the surrounding space.

Horizontal Cut: Bold horizontal bands interrupt selected areas of the portrait and interact with oversized typography.

Motion Veil: Keep the main portrait sharp while selected areas create subtle horizontal photographic motion trails.

Make typography an integral part of the composition. Use one dominant headline, allowing letters to crop beyond the frame, overlap the subject, disappear behind the body, or interact with the interference.

Keep supporting text minimal: one small series label and one short phrase.

Use mostly black, white, grey, charcoal, or deep neutral tones, plus one accent color. Keep skin tones natural and avoid excessive warmth or yellow grading.

Add only a few subtle graphic details such as fine lines, circles, or open corner marks when necessary.

The final composition should feel like a premium fashion editorial, contemporary photography poster, or experimental art-direction piece-clean, intentional, sophisticated, and visually balanced.

Avoid multiple competing effects, dense text, UI elements, heavy glitches, random collage, excessive decoration, numbering, "Vol." or "Issue" labels, sparkle symbols, logos, watermarks, distorted anatomy, plastic skin, oversaturation, and generic template aesthetics.

Keep the overall treatment medium in scale, refined, adaptable, and universally applicable to different people, titles, themes, palettes, and editorial concepts.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 534, '@Goodmanprotocol', 'https://x.com/Goodmanprotocol/status/2092471662126211143', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-534', '/images/case534.jpg', 'Create a Medium-sized 9:16 Experimental Editorial Portrait Poster', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-533', 'Transform the Subject from the Reference Image into', 'Template imported from awesome-gpt-image-2 case 533. Source: @Sairah_0.', 'Characters & People', 'Transform the subject from the reference image into a cute, quirky hand-drawn doodle illustration.

Use a minimalist children''s storybook / fashion sketch aesthetic with loose, imperfect black ink lines, visible scribbly pencil strokes, subtle cross-hatching, and a charming handmade feel. Keep the character''s recognizable facial features, hairstyle, face shape, clothing, accessories, and overall identity from the reference while simplifying them into a cute illustrated character.

Character design:
- Oversized head and small simplified body
- Simple dot-like eyes and tiny minimal mouth
- Soft rounded facial features
- Slight rosy pink blush on the cheeks
- Messy, expressive hand-drawn hair with many loose sketch lines
- Slightly exaggerated, playful proportions
- Natural, relaxed pose with a whimsical fashion-illustration feel

Art style:
- Black-and-white pencil/ink doodle drawing
- Rough, imperfect sketch lines rather than clean digital outlines
- Dense scribbled hair and clothing details
- Light hand-colored accents
- Subtle watercolor/crayon-like coloring
- Minimal shading
- White or off-white clean background
- Lots of negative space
- Cute, innocent, playful, cozy aesthetic
- Looks like an original handmade notebook/fashion doodle illustration

Preserve the important details of the reference image while converting everything into this consistent doodle-art style. The final image should feel hand-sketched, slightly imperfect, adorable, expressive, and effortlessly stylish, not like polished vector art or 3D cartoon art.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 533, '@Sairah_0', 'https://x.com/Sairah_0/status/2092473965927334071', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-533', '/images/case533.jpg', 'Transform the Subject from the Reference Image into', '["UI","Illustration","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-532', 'Create a Cannes-level Premium Summer Beverage Campaign Poster', 'Template imported from awesome-gpt-image-2 case 532. Source: @ou_zhen599.', 'Products & E-commerce', 'Create a Cannes-level premium summer beverage campaign poster for a fictional lemon drink brand called "LIMORA", using a strict 2-column by 3-row grid layout with six perfectly aligned panels. Preserve the exact structural logic of the composition: each panel shows the same tiny ultra-realistic young woman on a bright sandy beach interacting with oversized lemons, lemon slices, lemon juice, or the final branded drink, while selected panels include a giant realistic human hand entering from above. The full poster must feel like one unified high-end advertising storyboard in motion, where the eye flows continuously from fresh citrus fruit to crafted beverage desire. The lemon product world must remain the absolute visual hero across all six panels.

Overall composition:
Use a clean six-panel grid with thin white dividers, equal panel proportions, consistent horizon line, consistent beach-ocean background, and unified lighting. Every panel should feel self-contained yet rhythmically connected, as if six consecutive scenes from the same luxury summer commercial were frozen at their most iconic moments. Keep the miniature woman and the oversized lemon-related object centered in each frame, with the sea softly blurred in the background and the sand sharply rendered in the foreground. The full page must read instantly from a distance, with strong commercial clarity and polished editorial control.

Orbit visual flow:
Design the entire set around one strong circulation of motion from panel 1 to panel 6. The action should escalate visually: touch, recline, squeeze, travel, embrace, taste. Use repeating directional rhythms in hair movement, arm gestures, leg angles, juice droplets, spoon angle, lemon slice placement, straw tilt, and the position of the entering hand so the eye naturally sweeps across the poster in a flowing wave. Build subtle diagonal energy inside every panel, making the citrus world feel alive, breezy, sparkling, and in motion. The whole set should feel like summer energy orbiting around the brand''s lemon drink.

Narrative panel sequence:
Panel 1: the tiny woman hugs a giant whole lemon on the sand while a giant adult hand descends from above, delicately positioning the lemon. Her pose is lively and slightly off-balance, as if the scene has just begun.
Panel 2: she reclines elegantly inside a halved lemon as though it were a luxury beach chaise, wearing dark sunglasses and holding a tiny parasol drink pick, while a floating lemon slice is lowered from above like a radiant citrus sun.
Panel 3: a giant hand squeezes a vertically cut lemon from above, sending translucent juice streams and droplets downward in a sparkling arc. The woman reacts dynamically beneath it, arms raised, body tilted, caught in the middle of the citrus action.
Panel 4: she rides in a small refined wooden cart piled with lemons, being pulled by a whimsical premium lemon-shaped creature or rolling lemon harness. The cart must feel physically grounded, artisanal, and stylish rather than cartoonish.
Panel 5: the hero climax panel. A tall branded LIMORA lemonade glass dominates the frame, packed with ice cubes, lemon slices, pale sparkling liquid, condensation, a fresh green straw, and a refined cocktail umbrella. The tiny woman hugs the cold glass joyfully, and this panel must be the strongest product-selling moment in the entire composition.
Panel 6: she sits inside a halved lemon while a large polished spoon descends from above carrying glossy lemon sorbet or crushed lemon ice, creating a final delicious serving beat with playful anticipation.

Hero product focus:
The real hero is the lemon beverage system: whole citrus fruit, sliced fruit, squeezed juice, ice, sparkling drink, sorbet, and premium serving details. Every lemon must feel hyper-real, fragrant, sunlit, juicy, and tactile, with detailed skin pores, subtle waxy oil sheen, translucent membranes, wet cut surfaces, and bright natural citrus pulp. The branded glass in panel 5 must be the most visually dominant product object in the set, with crystal-clear glass, refined original English branding reading "LIMORA", elegant condensation, premium ice refraction, and luminous pale-yellow drink clarity.

Character design:
Depict one recurring ultra-realistic miniature young woman across all six panels, wearing the same fitted green floral mini dress and white sandals, with long dark wavy hair and naturally expressive features. She must look like a real scaled-down human placed into a surreal oversized citrus world. Keep anatomy coherent and believable in every frame: correct head-to-body proportion, realistic shoulders, collarbones, arms, waist, hips, thighs, knees, calves, ankles, and feet, with perfectly formed hands and five fingers clearly visible. Her expressions should shift panel by panel: surprised delight, relaxed confidence, playful alarm, exhilaration, joyful refreshment, amused anticipation. Skin must remain photorealistic with pores, natural tonal shifts, faint knee and elbow texture, realistic skin elasticity, and no plastic AI beauty finish.

Lighting:
Use bright premium seaside daylight with a soft upper-left sun direction and gentle atmospheric diffusion. Maintain luminous fresh summer lighting across all six scenes, with short, soft-edged shadows and crisp dimensional highlights. Juice droplets, lemon pulp, ice cubes, spoon edges, sunglasses, glass rim, and condensation should all catch clean sparkling highlights. Lighting must feel luxurious, refreshing, and physically consistent from panel to panel.

Materials:
Lemons: ultra-detailed peel pores, subtle dimpling, natural rind thickness, glistening wet pulp, believable cut translucency, realistic juice behavior.
Drink glass: high-clarity premium glass, accurate refraction, heavy base, condensation beads, crisp logo print, ice transparency, sparkling carbonated liquid feel.
Sorbet and juice: glossy, semi-translucent, cold, wet, appetizing, physically accurate.
Dress: lightweight summer cotton with tiny green floral print, natural wrinkles, fabric tension, and wind-responsive edges.
Hair and skin: realistic strands, fine flyaways, natural shine, believable skin texture.
Large hand: realistic adult fingers, soft skin compression, natural nails, coherent scale perspective.
Cart and props: refined warm wood grain, polished wheels, believable joints and harness elements.
Beach environment: fine sunlit sand with miniature footprints and pressure marks, soft shoreline blur, clean turquoise sea with pale foam.

Color system:
Build the palette around lemon yellow, fresh citrus green, turquoise sea, pale sky blue, warm beach beige, crisp white highlights, and restrained natural skin tones. Yellow must remain the dominant hero color, supported by green and turquoise. Keep the image bright, appetizing, summery, clean, and internationally commercial. Avoid random accent colors.

Typography and branding:
Do not copy any text from the sample. Keep typography minimal and original. Place refined English branding only on the hero glass and optionally a tiny campaign line below the full grid, such as: "LIMORA - Bright in Motion". Typography must feel premium, modern, minimal, and secondary to the visual storytelling.

Art direction:
Hyper-real premium surreal advertising photography, luxury FMCG campaign, storyboard energy, elegant humor, cinematic micro-world illusion, high-end beverage styling, global summer launch poster, polished magazine-grade finish, sharp product realism, strong narrative rhythm, premium brand coherence.

Negative prompt:
copied text, Chinese text, existing brand names, cartoon style, toy-like figure, grotesque oversized head, deformed anatomy, extra fingers, missing fingers, fused fingers, twisted wrists, broken limbs, distorted feet, AI plastic skin, over-smoothed skin, fake citrus texture, unrealistic juice physics, muddy lemon pulp, cloudy glass, weak product focus, inconsistent lighting, inconsistent horizon, messy grid, cluttered props, meme aesthetic, cheap humor, childish illustration, low-resolution detail, oversaturated colors, dead black patches, distorted giant hand perspective', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 532, '@ou_zhen599', 'https://x.com/ou_zhen599/status/2091160215928574397', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-532', '/images/case532.jpg', 'Create a Cannes-level Premium Summer Beverage Campaign Poster', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-531', 'Create a Luxurious, Dreamy Country Travel-art Collection in', 'Template imported from awesome-gpt-image-2 case 531. Source: @Taaruk_.', 'Posters & Typography', 'Create a luxurious, dreamy country travel-art collection in the exact visual language of an elegant premium tourism campaign: a large transparent crystal/glass architectural frame or arched glass display standing on a glossy reflective surface, containing a highly detailed cinematic illustration of the destination. For [COUNTRY], feature its most iconic landmarks, historic architecture, distinctive landscapes, local transportation, cultural elements, national flag, flowers and recognizable scenery arranged as one seamless poetic panorama. Use warm golden-hour sunlight, soft atmospheric haze, pastel cream, champagne, muted blue and sage tones, delicate clouds, subtle birds, realistic glass refraction and rainbow prism highlights along the edges. Create a perfect mirror reflection beneath the glass structure, extending the entire composition downward with beautifully softened reflections. Add elegant editorial typography at the top reading "[COUNTRY]", with smaller refined text "THE SOUL OF [COUNTRY]" and "A JOURNEY THROUGH TIME • 2026" beneath it. Sophisticated luxury travel magazine aesthetic, photorealistic yet painterly, cinematic depth, fine-art composition, extremely detailed architecture, serene atmosphere, premium advertising photography, symmetrical balanced framing, soft film grain, 8K, vertical 4:5, no clutter, no modern UI elements, no extra text.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 531, '@Taaruk_', 'https://x.com/Taaruk_/status/2091391283063361558', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-531', '/images/case531.jpg', 'Create a Luxurious, Dreamy Country Travel-art Collection in', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-530', 'Transform Only the People in the Uploaded Photo', 'Template imported from awesome-gpt-image-2 case 530. Source: @Emmma__0.', 'Characters & People', 'Transform ONLY the people in the uploaded photo into adorable hand-drawn doodle characters while keeping the original photographic background unchanged.

CORE RULE:
Background = original realistic photo.
People = cute hand-drawn doodle characters.

PRESERVE THE BACKGROUND:
Keep the original sky, landscape, buildings, water, furniture, ground, plants, railings, objects, lighting, colors, perspective, camera angle, framing, and textures as close to the original photo as possible.

Do NOT redraw, simplify, illustrate, or apply doodle/crayon/pencil effects to the background or environmental objects.

TRANSFORM ONLY PEOPLE:
Replace each person with a charming, naive doodle version while preserving:
- exact number of people
- original position and relative scale
- front/back/side/three-quarter orientation
- head and body direction
- pose and gesture
- arm and leg positions
- interactions with people or objects
- hairstyle, clothing colors, and major accessories

IMPORTANT:
If someone faces away, keep them back-facing.
If sideways, keep them sideways.
If facing forward, keep them forward.
Never rotate a person toward the viewer or invent a face that is not visible.

CUTE DOODLE STYLE:
Freely reinterpret realistic anatomy into an adorable, imperfect character:
- oversized round head
- tiny compact body
- short simplified arms and legs
- tiny hands and feet
- cute awkward proportions
- loose scribbled hair
- tiny dot eyes and simple facial features when visible
- rosy scribbled cheeks when appropriate

Keep the original pose recognizable, but simplify and slightly exaggerate it for cuteness.

DRAWING STYLE:
Loose naive hand-drawn doodle, like a quick children''s sketch.
Use thin shaky black outlines, imperfect shapes, overlapping sketch lines, scribbled colored-pencil or crayon fills, uneven coloring, white gaps, and slightly messy edges.

The character should look intentionally roughly drawn but extremely cute.

OBJECTS:
Objects, furniture, scenery, and items around the people should remain photographic whenever possible. A doodle character may naturally touch or hold a real photographic object.

INTEGRATION:
Keep correct scale, ground contact, depth, and occlusion so the doodle characters naturally occupy the same locations as the original people.

FINAL LOOK:
It should feel like the real people were removed from the original photograph and replaced with adorable little hand-drawn doodle versions of themselves, while the real-world background remained untouched.

Prioritize:
1. Original photographic background
2. Person position and scale
3. Exact body orientation
4. Pose and gesture
5. Cute exaggerated doodle character design

Avoid full-image illustration, background doodling, realistic anatomy, anime, manga, 3D cartoon, polished digital art, vector lines, changed poses, changed orientation, added people, or invented faces.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 530, '@Emmma__0', 'https://x.com/Emmma__0/status/2091391958128251286', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-530', '/images/case530.jpg', 'Transform Only the People in the Uploaded Photo', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-529', 'Create a Dreamy Ultra-photorealistic Outdoor Fashion Photograph Based', 'Template imported from awesome-gpt-image-2 case 529. Source: @AiwithLariab.', 'Photography & Realism', 'Create a dreamy ultra-photorealistic outdoor fashion photograph based on the person in @image1.

IDENTITY & FACE:
Preserve the exact facial identity of the person in @image1. Keep the same face shape, facial proportions, eyes, eyebrows, nose, lips, skin tone, hairstyle, hairline, and all recognizable facial features. The person must remain clearly recognizable and consistent with the reference image. Do not redesign or replace the face.

POSE & COMPOSITION:
Create a full-body vertical portrait of the person standing naturally on a grassy mountain ridge. The body is slightly turned toward the camera while the face looks naturally toward the viewer. One hand gently holds several long white strings attached to an enormous fluffy white cloud floating directly above the person like a whimsical balloon bouquet. The other hand rests naturally beside the body.

SCENE:
A breathtaking high-altitude mountain landscape with layers of distant blue-green mountains stretching across the horizon. The subject stands on a natural grassy ridge with delicate wild grass around her feet. Vast open sky dominates the upper portion of the composition.

CLOUD BALLOON:
Create one enormous soft white cumulus cloud directly above the subject, visually resembling a giant floating cloud balloon. Multiple thin white strings descend from the cloud and gather elegantly into the person''s hand. The strings should look physically believable and naturally connected to the cloud. The cloud is fluffy, voluminous, bright white, and beautifully illuminated by sunlight.

CLOTHING:
Dress the person in a completely modest, elegant, fully covered outfit:

long flowing light-blue maxi dress reaching the ankles

loose long sleeves covering the arms completely

high and modest neckline

opaque non-transparent fabric

full-length flowing skirt

simple white closed-toe sneakers

small woven crossbody bag
No exposed midriff, no deep neckline, no sheer fabric, no short skirt, no revealing clothing. The outfit should look graceful, comfortable, elegant, and wholesome.

ACCESSORIES:
Add tasteful round dark sunglasses and a simple woven shoulder/crossbody bag. Keep accessories minimal and natural.

HAIR:
Keep the person''s original hairstyle and hair color from @image1 as much as possible. Allow a few natural strands of hair to move gently in the mountain breeze.

LIGHTING:
Bright natural midday sunlight, soft atmospheric illumination, realistic highlights on the white cloud and dress, subtle natural shadows, crisp but gentle exposure, beautiful blue-sky contrast.

PHOTOGRAPHY STYLE:
Ultra-photorealistic professional travel-fashion photography, realistic skin texture, natural fabric details, physically accurate lighting, realistic depth of field, cinematic atmospheric perspective, high dynamic range, sharp subject with a softly detailed background.

COLOR PALETTE:
Sky blue, soft white, pale powder blue, natural green grass, and distant blue mountains. Clean, airy, dreamy color grading with a peaceful summer atmosphere.

COMPOSITION:
9:16 vertical portrait, full body visible from head to shoes, subject positioned slightly below center, enormous blue sky and cloud occupying the upper half, distant mountains forming a soft horizontal horizon, balanced negative space, visually striking editorial travel photograph.

IMPORTANT:
Preserve the exact identity from @image1. Do not change the person''s recognizable face or facial structure. Keep the outfit completely modest, opaque, and fully covering. Maintain realistic anatomy, natural hands, realistic proportions, and believable interaction between the person, strings, cloud, grass, and mountain environment.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 529, '@AiwithLariab', 'https://x.com/AiwithLariab/status/2091394735416160715', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-529', '/images/case529.jpg', 'Create a Dreamy Ultra-photorealistic Outdoor Fashion Photograph Based', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-528', 'Use the Uploaded Image as the Primary Reference', 'Template imported from awesome-gpt-image-2 case 528. Source: @Sairah_0.', 'Characters & People', 'Use the uploaded image as the primary reference. Transform the person into a cute, hand-drawn anime/chibi character while preserving the original person''s recognizable facial features, hairstyle, outfit, pose, and accessories.

A cute young woman standing on a modern city street at blue hour, surrounded by tall illuminated skyscrapers and festive Christmas decorations. A huge glowing Christmas tree covered in warm golden lights stands directly behind her, creating a magical holiday atmosphere. The street is filled with elegant decorative lights, pedestrians, modern architecture, and soft evening city illumination.

Render the character in a charming Japanese hand-drawn anime/chibi illustration style with expressive large eyes, soft blush on the cheeks, delicate facial details, textured pencil-and-ink outlines, subtle watercolor-like coloring, and slightly imperfect handmade sketch details. Keep the background photorealistic and highly detailed, creating a beautiful contrast between the illustrated character and the real-world environment.

Cinematic composition, natural perspective, soft evening lighting, warm Christmas glow, realistic background depth, detailed clothing texture, cozy winter atmosphere, high detail, aesthetically pleasing, vertical portrait composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 528, '@Sairah_0', 'https://x.com/Sairah_0/status/2091401764360896762', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-528', '/images/case528.jpg', 'Use the Uploaded Image as the Primary Reference', '["Poster","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-527', 'Create a Highly Detailed, Photorealistic Miniature Travel-poster Diorama', 'Template imported from awesome-gpt-image-2 case 527. Source: @john_my07.', 'Posters & Typography', 'Create a highly detailed, photorealistic miniature travel-poster diorama inspired by Rio de Janeiro, arranged as a handcrafted 3D paper scene on a warm ivory, slightly textured background.

In the foreground, a realistic human hand holds a vintage Brazilian travel ticket or Rio-themed transit card vertically on the left side. Give the card aged paper texture, subtle printing imperfections, elegant typography, and authentic-looking travel details. From behind the card, a miniature Rio de Janeiro landscape physically rises outward like an intricate pop-up diorama.

Make Christ the Redeemer the dominant central landmark, positioned high above a miniature cityscape with lush green mountains surrounding it. Below, build a tiny realistic Rio street featuring a classic yellow taxi, colorful buildings, palm trees, pedestrians, cyclists, street lamps, tiled sidewalks, and small Brazilian urban details. Add Copacabana beach elements in the distance with tiny umbrellas, beachgoers, and a glimpse of the Atlantic Ocean. Layer the architecture and terrain so everything appears physically constructed from paper, wood, plaster, and miniature materials, with convincing depth, cast shadows, overlapping surfaces, and a slight three-quarter perspective.

Around the main 3D scene, incorporate delicate black, charcoal, and muted sepia hand-drawn travel illustrations on the cream paper. Include a small Sugarloaf Mountain sketch in the upper left, an artistic Copacabana promenade illustration in the upper right, a detailed Selarón Steps sketch along the right side, and a small Ipanema beachfront skyline drawing near the bottom. Add subtle handwritten travel notes, tiny map markings, architectural outlines, compass symbols, postage-stamp details, and understated Brazilian travel annotations.

Keep the composition refined rather than crowded. Blend realistic miniature photography with vintage travel-journal design, tactile paper fibers, faint ink bleed, imperfect hand-drawn lines, warm natural studio lighting, gentle shadows, subtle film grain, and a sophisticated cream, charcoal, muted green, ocean blue, and Brazilian yellow palette.

The final image should feel like a premium collectible Rio de Janeiro travel postcard transformed into a physical miniature world, with the central diorama sharply detailed and the surrounding illustrations slightly softer. Highly realistic human hand and fingers, believable miniature materials, cinematic product photography, editorial travel-magazine aesthetic, shallow depth of field, ultra-fine textures, photorealistic 3D details, vertical 4:5 composition, 8K quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 527, '@john_my07', 'https://x.com/john_my07/status/2091408386466214031', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-527', '/images/case527.jpg', 'Create a Highly Detailed, Photorealistic Miniature Travel-poster Diorama', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-526', 'Case 526 Posters and Typography Template', 'Template imported from awesome-gpt-image-2 case 526. Source: @zhidawang219555.', 'Posters & Typography', '从全黑剧场开始，像切标本一样用六片真实体积激光把空间分层。光面必须有明确起点、透视和薄雾中的厚度，人物站在交汇点，透明道具折射出一小束异色光扇。构图沿左下至右上的对角线推进，脸只用一道克制边光揭示；标题与其中一片光面共享透视，小字留在纯黑负空间。每次替换主题与角色时，不得退化成夜店模板、HUD、霓虹城市或无物理来源的光线。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 526, '@zhidawang219555', 'https://x.com/zhidawang219555/status/2090246237094310178', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-526', '/images/case526.jpg', 'Case 526 Posters and Typography Template', '["Poster","Character"]'::jsonb, '["Travel"]'::jsonb, FALSE, TRUE),
    ('case-525', 'A Cinematic, Ultra-realistic Close-up Portrait of a Stylish', 'Template imported from awesome-gpt-image-2 case 525. Source: @iamsofiaijaz.', 'Photography & Realism', 'A cinematic, ultra-realistic close-up portrait of a stylish man, using the provided image as an accurate face reference. Preserve his natural facial identity, thick naturally curly dark brown hair, neatly trimmed salt-and-pepper beard, strong masculine facial structure, and realistic facial proportions. He wears sophisticated round vintage amber-brown sunglasses and a premium deep burgundy suede jacket over a fitted black silk-knit shirt, creating a refined luxury fashion aesthetic.

Warm cinematic studio lighting with a soft amber-golden key light illuminating the face from the front-left, complemented by a subtle crimson-red rim light outlining the hair and shoulders. The background is a rich burgundy, wine-red, and dark plum gradient, with soft atmospheric haze and subtle diffused light creating depth without distracting from the subject. Elegant warm highlights contrast beautifully against the dark clothing.

Extremely detailed natural skin texture, individual beard hairs, realistic pores, subtle facial imperfections, sharp eyes visible behind slightly tinted lenses, natural reflections on the sunglasses, rich dimensional shadows, realistic fabric and suede texture, shallow depth of field. Sophisticated luxury fashion campaign, mysterious and confident mood, premium men''s editorial photography, cinematic color grading, photorealistic, HDR, professional studio photography, 85mm portrait lens, f/1.8, crisp facial details, soft background bokeh, centered composition, head-and-shoulders framing, powerful masculine presence, understated elegance, 3:4 aspect ratio.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 525, '@iamsofiaijaz', 'https://x.com/iamsofiaijaz/status/2090294894187413883', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-525', '/images/case525.jpg', 'A Cinematic, Ultra-realistic Close-up Portrait of a Stylish', '["Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-524', 'Create a Premium Whimsical Handcrafted Paper-collage Diorama Inspired', 'Template imported from awesome-gpt-image-2 case 524. Source: @AiwithLariab.', 'Illustration & Art', 'Create a premium whimsical handcrafted paper-collage diorama inspired exactly by the uploaded reference image.

Use the uploaded girl reference as the ONLY human subject. Preserve her facial identity with maximum accuracy: exact face shape, eyes, eyebrows, nose, lips, skin tone, hairstyle, hairline, and recognizable facial features. Strict face identity lock - do not redesign, beautify, stylize, age, de-age, or replace her face.

The girl stands alone in the center of the composition in a graceful, natural editorial pose. She is facing the camera with a relaxed confident expression and a subtle natural smile. Her body is slightly angled, creating a candid fashion-editorial feeling. She holds a beautiful small mixed bouquet of flowers naturally with both hands in front of her. One leg is slightly crossed in front of the other for an elegant relaxed pose.

Outfit

Change the outfit completely from the original reference while keeping it fully modest and elegant:

- elegant ivory/cream long-sleeve button-up blouse
- high-waisted wide-leg beige trousers
- full-length trousers with complete coverage
- simple cream closed-toe shoes
- small brown leather shoulder bag
- no revealing clothing
- no exposed midriff
- sophisticated countryside editorial fashion
- natural realistic fabric folds and texture

Environment

Create a beautiful handcrafted 3D paper-diorama countryside scene:

- layered blue mountains in the distance
- green forest and rolling hills
- peaceful blue lake
- grassy lakeside landscape
- textured beige paper pathway in the foreground
- rustic white wooden fence behind the girl
- dreamy pastel sky

Surround the composition with oversized handmade paper flowers in pink, peach, cream, white, and light blue, with layered green paper leaves.

Add decorative paper elements floating in the sky:

- pink paper hearts
- yellow paper stars
- blue stars
- soft white and pale-blue clouds
- tiny colorful paper dots

Place two tiny vintage vehicles near the lake in the background: a cream vintage camper van on one side and a small vintage blue-green car on the other.

Art Direction

The entire environment should look handcrafted from premium textured paper while the girl remains photorealistic and seamlessly integrated into the paper world.

Use:
hand-torn paper edges, visible paper fibers, layered cardstock, subtle imperfections, realistic paper shadows, dimensional cut-paper elements, tactile textures, soft natural daylight, cinematic depth, gentle atmospheric perspective, premium editorial photography.

The final image should feel like a luxury handmade paper storybook brought to life with a real photographic subject.

Composition

Centered full-body girl
Face clearly visible and sharply detailed
Natural elegant pose
Bouquet held naturally
Rustic fence framing the subject
Lake and mountains creating depth
Large flowers framing both lower corners
Clouds and decorative elements filling the upper background
Balanced symmetrical composition with organic handmade imperfections
Girl remains the strongest focal point

Final Look

Photorealistic girl + handcrafted paper-art environment
Dreamy pastel colors
Luxury editorial aesthetic
Whimsical miniature diorama
Soft cinematic daylight
Highly detailed paper textures
Natural realistic skin
Sharp facial identity
Professional fashion photography
Pinterest/Instagram viral visual aesthetic
Magazine-quality composition

Vertical 4:5 portrait composition, full-body framing, ultra-detailed, high resolution, clean polished finish, visually striking, aesthetically balanced, premium handcrafted paper-collage photography.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 524, '@AiwithLariab', 'https://x.com/AiwithLariab/status/2090297565732585554', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-524', '/images/case524.jpg', 'Create a Premium Whimsical Handcrafted Paper-collage Diorama Inspired', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-523', 'Create a Vertical Editorial Travel Illustration Inspired by', 'Template imported from awesome-gpt-image-2 case 523. Source: @Taaruk_.', 'Illustration & Art', 'Create a vertical editorial travel illustration inspired by vintage European travel posters, featuring a peaceful summer afternoon in a grand city park with a recognizable Manhattan-style skyline in the background. Use delicate hand-drawn ink outlines combined with soft, slightly imperfect watercolor washes on warm textured cream paper. Show a wide green lawn filled with people relaxing, reading, walking, jogging, cycling, and having picnics. In the foreground, a casually dressed young couple sits together on a picnic blanket beside a woven basket. Include elegant black vintage park lamps, winding pathways, dense leafy trees framing the composition, and detailed historic and modern skyscrapers rising behind the park. Add a small picturesque stone arch bridge over a calm pond near the bottom of the artwork. Use muted sage green, olive, warm beige, soft blue, pale gray, and subtle golden sunlight, with natural watercolor bleeding, paper grain, fine pen hatching, and an airy sophisticated travel-journal aesthetic. No text, no letters, no logos, no typography, no captions, no signs. Vertical 4:5 composition, highly detailed, elegant, nostalgic, handcrafted watercolor-and-ink illustration.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 523, '@Taaruk_', 'https://x.com/Taaruk_/status/2090307485374578755', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-523', '/images/case523.jpg', 'Create a Vertical Editorial Travel Illustration Inspired by', '["Poster","Illustration","Brand"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-522', 'Use the Single Uploaded Photo as the Only', 'Template imported from awesome-gpt-image-2 case 522. Source: @Sairah_0.', 'Characters & People', 'Use the single uploaded photo as the only visual reference. Transform the person into an adorable hand-drawn 2D children''s storybook character, while keeping their identity immediately recognizable.

Preserve exactly from the photo:
- Facial features and skin tone
- Real hairstyle, length, texture, and color
- Exact clothing, colors, patterns, and layering
- Glasses, jewelry, headwear, bags, and all visible accessories

Do not invent or copy hairstyles, outfits, accessories, braids, pigtails, bows, bonnets, or headscarves from any reference artwork.

### Character
Use an oversized rounded head, tiny compact body, short arms, narrow shoulders, soft rounded silhouette, and cute childlike proportions. Keep the head visually dominant. Avoid realistic anatomy.

### Face
Simplify into tiny dot/oval eyes, minimal nose, tiny smiling mouth, rounded cheeks, and soft peach/pink blush. Keep recognizable facial characteristics. No realistic eyes, detailed lips, anime features, glossy 3D rendering, or heavy shading.

### Hair & Clothing
Recreate the exact hairstyle and outfit from the uploaded photo, simplified into chunky hand-drawn shapes. Preserve important colors, patterns, jewelry, glasses, and other recognizable details.

### Style
Handmade 2D picture-book aesthetic using soft gouache, wax crayon, colored pencil, and dry pastel. Use slightly irregular dark-brown linework, subtle paper grain, uneven pigment, soft brush marks, and imperfect painted edges. Avoid clean vector art, CGI, anime, or photorealism.

### Composition
Square 1:1 portrait, chest/waist-up, centered and facing mostly forward, with balanced negative space. Use a relaxed, charming pose.

### Background
Simple warm mustard, butter yellow, ochre, or cream background with subtle paper texture. No scenery, objects, text, borders, or distractions.

Final feeling: the same person lovingly redrawn as an extremely cute, warm, wholesome, nostalgic, handcrafted children''s-book character-same identity, same hair, same clothes, same accessories, completely simplified and adorable.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 522, '@Sairah_0', 'https://x.com/Sairah_0/status/2090321208441262454', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-522', '/images/case522.jpg', 'Use the Single Uploaded Photo as the Only', '["Realistic","Brand","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-521', ', 3:4 ,25 1:1:1:1, ,,,:1233:1,,,, :,1,,60 ,,,,, :,,,', 'Template imported from awesome-gpt-image-2 case 521. Source: @zhidawang219555.', 'Posters & Typography', '请将我上传的照片制作成一张竖版拼图海报，整体采用 3:4 竖版构图。画面从上到下严格四等分为四个横向区域，每个区域的高度必须精确控制为整体画面高度的25%（四层比例严格为1:1:1:1，不允许出现比例偏差），区域之间无缝衔接，不设分隔线、不留间隙，顺序为：原图→风格1→风格2→风格3。由于每层为约3:1的极扁宽幅比例，各层主体建议横向居中排布，强调左右开阔留白与呼吸感，避免元素纵向拉伸变形或贴边拥挤。四层在人物站位、场景结构、视线方向上保持连贯呼应，呈现同一画面、四种转译的整体感。风格层（第二至四层）须遵循极简原则：每层视觉元素数量压缩至最低限度，只保留1个最核心的主体符号，其余次要装饰、背景细节与陪衬元素一律省略，画面留白占比不低于60%。

第一层保留原始照片的主体结构、人物真实互动关系与姿态、真实质感、自然光影与原有色彩氛围，仅进行轻微高级摄影调色，呈现杂志摄影质感，不改变人物关系与构图逻辑，并可在不改变人物关系与构图逻辑的前提下自然扩展天空、地面或环境背景，使整体更具空间感与叙事感。

第二层为青花瓷绘风格：借鉴青花瓷绘画技法，以钴蓝色线条与晕染在米白底上表现人物与场景，呈现瓷器纹样的疏朗雅致感。色彩以钴蓝与米白为主的单色系。避免蓝色浓淡层次过多显杂，避免图案化装饰堆砌。

第三层为敦煌壁画风格：借鉴敦煌壁画矿物重彩质感，表现古朴斑驳的美感，需简化线条与色块。背景为土黄或赭石底色，带斑驳壁画肌理感。色彩以赭石、石青、朱砂、土黄为主。避免裂纹肌理过多堆砌，避免复杂纹样装饰。

第四层为刺绣锦缎风格：以刺绣针脚肌理表现人物与场景轮廓，呈现丝缎光泽与针线纹理感，图案需极简概括。背景为米白或浅灰缎面底色。色彩以2至3种柔和色搭配金线点缀。避免针脚过密显繁琐，避免金线过多显浮夸。

每一层需将主体与场景统一转换为对应风格，整体表达极度克制与简化，只保留最核心的一个主体符号及其基本轮廓关系，删除一切非必要的背景元素、装饰细节与陪衬物；人物之间的关键位置关系、互动方向与姿态特征需保留，但应抽象为可识别的轮廓关系，做到"元素越少、关系越清晰"。色彩均从原图中提取归纳，每层严格控制在2-4种主色以内。四个区域的高度比例须严格保持1:1:1:1（各占25%），不可出现拼接错位或比例偏差。整体避免朋克/赛博朋克风格、写实照片质感强行叠加、卡通风格、3D渲染感、商业海报感、复杂背景堆砌、元素过多或画面拥挤、相邻两层风格雷同，以及任何文字、Logo、水印或标题。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 521, '@zhidawang219555', 'https://x.com/zhidawang219555/status/2090310144190218272', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-521', '/images/case521.jpg', ', 3:4 ,25 1:1:1:1, ,,,:1233:1,,,, :,1,,60 ,,,,, :,,,', '["Poster","Realistic","Illustration"]'::jsonb, '["Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-520', 'A Graphic Illustration Centered on a Dark Navy', 'Template imported from awesome-gpt-image-2 case 520. Source: @lovimg_com.', 'Illustration & Art', 'A graphic illustration centered on a dark navy blue t-shirt, depicting an astronaut sitting on the surface of the moon, viewed from a side profile. The astronaut is wearing a detailed, bulky space suit and helmet, leaning back against a small lunar rock formation, and is holding a small steaming mug, suggesting they are enjoying a peaceful drink. Positioned directly in front of the astronaut in the background is a large, majestic view of the Earth, rendered in shades of white, light blue, and navy, featuring prominent swirling cloud formations. The entire artwork is monochromatic, utilizing a cool blue-and-white color palette that creates a serene, solitary, and contemplative atmosphere. The lunar ground is textured with craters and dust, providing a grounded contrast to the vast, dark sky and the bright, swirling planet above. The style is clean, artistic, and iconic, reminiscent of screen-printed apparel designs.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 520, '@lovimg_com', 'https://x.com/lovimg_com/status/2077035644254363972', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-520', '/images/case520.jpg', 'A Graphic Illustration Centered on a Dark Navy', '["UI","Illustration","3D"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-519', '100 ,;,,,,,,c4d,ins,,2k', 'Template imported from awesome-gpt-image-2 case 519. Source: @lovimg_com.', 'Products & E-commerce', '100%完整保留上传的原图香水瓶的全部原始外观细节，瓶身造型、薄荷绿玻璃质感、木纹球形瓶盖、原有标签文字完全不做任何修改；瓶身环绕米色织带，周围簇拥薄荷绿玫瑰和浅绿色植物，冷调渐变浅留白背景，冷调逆光柔焦光影，低饱和度冷清高级色调，景深虚化突出香水主体，超写实C4D质感，轻奢高级ins风，适配竖版电商详情页，2K高清', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 519, '@lovimg_com', 'https://x.com/lovimg_com/status/2077036313832996893', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-519', '/images/case519.jpg', '100 ,;,,,,,,c4d,ins,,2k', '["Realistic"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-518', ': : 4:5 : : : : 85mm', 'Template imported from awesome-gpt-image-2 case 518. Source: @lovimg_com.', 'Photography & Realism', '主題：
花風のまどろみ

主体：
縦長4:5の写真風ポートレート。白と黄色のマーガレット、オレンジ色の小花が密に咲く夏の草花畑に、成熟した大人の女性が仰向けで静かに横たわっている。人物は画面下部から中央にかけて大きく入り、顔は中央やや右、胸元から肩までは画面下側に収まる。周囲の花が画面全体を埋め、対角線方向に流れる花のモーションブラーが前景を横切る。

人物・表情：
自然で現実感のある日系ポートレート。暗めのブラウンロングヘアに、薄い前髪と顔まわりのやわらかな毛束。目を閉じ、眉は力が抜け、唇は軽く閉じた穏やかな表情。頬と鼻先に自然な血色、肌には過度な補正をせず細かな質感を残す。首筋、鎖骨、頬に夏の日差しが当たり、静かに眠っているような落ち着いた雰囲気。

服装・ポーズ：
白い夏用キャミソールワンピース。細い肩紐、胸元の控えめなレース、中央の小さなリボン、薄手のコットン素材。人物の両肩は草花に自然に沈み、片腕は画面下側で花に隠れて見切れる。体は画面左下から右上へ少し斜めに置かれ、髪は草の上に広がり、風で数本だけ額にかかる。

背景・光：
郊外にある小さな花畑のような、生活感のある自然な草花の密度。背景はすべて緑の葉と白・黄色・オレンジの花で構成し、人工物や読める文字は入れない。高めの位置から差す夏の太陽光。光はやや硬めで暖かく、顔の左側と首筋、肩に明るいハイライトが入り、花と髪の影が肌に細く落ちる。草の反射で下側に淡い緑の返り光。

構図・カメラ：
やや俯瞰の近距離撮影。85mm相当の自然な圧縮感、人物の顔にピントを合わせ、周辺の花は浅い被写界深度で少しぼける。前景の花だけが風に流され、白・黄色・オレンジの細長い光跡として左上から右下へ走る。顔まわりはブラーを弱め、表情と肌の質感をはっきり見せる。

質感・スタイル：
リアルな写真表現。夏の日差し、透明感のある肌、柔らかな髪の束感、薄手コットンのしわ、草花の細密な質感。ナチュラルな色調で、緑を深く、白い花を明るく、オレンジの花をアクセントにする。フィルム写真のようなわずかな粒子感と、雑誌ポートレートの落ち着いた仕上がり。

ネガティブ：
不自然な顔、不自然な視線、余分な指、欠けた指、手足の融合、関節の破綻、服と体の接触不良、浮遊、不自然な重力、誤った遠近法、光源と矛盾する影、過度な美肌補正、プラスチックのような肌、文字化け、ロゴ、透かし。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 518, '@lovimg_com', 'https://x.com/lovimg_com/status/2077036746198618336', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-518', '/images/case518.jpg', ': : 4:5 : : : : 85mm', '["Realistic","Character"]'::jsonb, '["Fashion"]'::jsonb, FALSE, TRUE),
    ('case-517', ': : 2:3 : : : : 45', 'Template imported from awesome-gpt-image-2 case 517. Source: @lovimg_com.', 'Products & E-commerce', '主題：
氷越しの夏

主体：
縦長2:3のリアル写真。透明な大型プラスチックカップの内側から見上げるような超広角フィッシュアイ構図。画面下半分いっぱいに赤いいちご果肉とクラッシュアイスが迫り、中央から太いグリーンのストローが奥へ一直線に伸びる。丸く歪んだカップの開口部の向こうに、女性の顔が中央に大きく収まる。

人物・表情：
自然で現実感のある若い女性。黒髪に近いダークブラウンの髪を高めのお団子にまとめ、薄い前髪と顔まわりの後れ毛が日差しで細く光っている。透明感のあるナチュラルメイク、淡いピンクの頬、つやのあるリップ。目を大きく開いてカメラをまっすぐ見つめ、唇を小さく丸めてストローをくわえている。少し驚いたような、可愛らしく無邪気な表情。

服装・ポーズ：
白いレース素材のブラウス。首元と肩まわりに細かなフリルがあり、夏らしく軽い質感。人物はカップの向こう側に顔を近づけ、両肩は下部に少しだけ見える。ストローは人物の口元に自然に接触し、奥から手前の赤い氷へ向かって強い奥行きを作る。

背景・光：
背景は晴れた夏の日の古い商店街。木造風の店先、かき氷屋の暖簾、苺柄の看板、白い小さな旗、街路樹が見える。文字はすべてぼかされた読めない装飾として扱う。左上から強い太陽光が入り、透明カップの水滴、カップ縁、氷、赤い果肉に細かな反射とハイライトが出る。影は右下へ落ち、白いクリームの残りがカップ内側にリング状についている。

構図・カメラ：
カメラはカップの底付近、赤い氷のすぐ上に置いたような極端なローアングル。フィッシュアイレンズでカップの円形リムが大きく湾曲し、周囲の商店街も軽く歪む。画面下45％は赤い氷と果肉の前ボケ、中央はストローと女性の顔、上部は青空とカップの透明な縁。ピントは女性の目と口元、手前の氷はきらめく浅いボケ。

質感・スタイル：
プロ用カメラで撮影した夏の広告写真風。透明プラスチックの屈折、水滴の粒、氷の冷たさ、いちご果肉の瑞々しさを高精細に表現。青空、赤い氷、グリーンのストロー、白いブラウスの色の対比を鮮やかにする。肌は自然な質感を残し、過度な美肌補正はしない。明るくポップで、少しユーモラスな日本の夏スイーツ写真。

ネガティブ：
実在ブランドロゴ、読める文字、商標の再現、不自然な顔、不自然な視線、歯や唇の崩れ、ストローとの接触不良、余分な指、欠けた指、手足の融合、氷の浮遊、不自然な重力、誤った遠近法、光源と矛盾する影、文字化け、透かし、過度な美肌補正、プラスチックのような肌。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 517, '@lovimg_com', 'https://x.com/lovimg_com/status/2077036659028484375', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-517', '/images/case517.jpg', ': : 2:3 : : : : 45', '["Realistic","Character"]'::jsonb, '["Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-516', 'Create an Ultra-detailed Hyper-realistic 3d Render of ,', 'Template imported from awesome-gpt-image-2 case 516. Source: @Just_sharon7.', 'Brand & Logos', 'Create an ultra-detailed hyper-realistic 3D render of {Object} , formed from thick industrial rubber tubing bent into the exact shape of the design, flexible yet dense structure, smooth rounded contours, subtle matte finish, realistic elastomer texture, faint molded seam lines, soft tension at each curve, authentic material compression and stretch behavior, slightly grippy surface quality, engineered object realism, colored using the authentic official brand color palette of [brand], faithful brand-matching hues applied across the tubing, accurate color blocking that follows the original logo design, premium studio product photography aesthetic, isolated on a pure white seamless background, soft diffused studio lighting, realistic contact shadow, macro detail, razor-sharp focus, photorealistic, 8k, 16:9, no watermark, no extra text.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 516, '@Just_sharon7', 'https://x.com/Just_sharon7/status/2077034244988150062', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-516', '/images/case516.jpg', 'Create an Ultra-detailed Hyper-realistic 3d Render of ,', '["Realistic","Product","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-515', 'Crea Una Imagen', 'Template imported from awesome-gpt-image-2 case 515. Source: @MiMundoConIA.', 'Posters & Typography', '@Crea una imagen {
  "style": "Cinematic Vintage Movie Poster - Guadalajara, Mexico",
  "target_tool": "DALL-E 3 (ChatGPT)",
  "prompt": "Generate a vertical portrait-format movie poster image, taller than wide in a 2:3 aspect ratio. The image is a cinematic vintage travel movie poster for Guadalajara, Mexico, rendered with the visual texture of an aged large-format film poster: heavy 35mm film grain throughout especially in the shadow areas, slightly faded and warm-shifted color tones as if printed on aged matte paper stock, a subtle halftone dot pattern visible in the midtones, and a very slight ink bleed at high-contrast edges giving it an authentic vintage printed poster feel. Foreground: a single dark silhouette of a lone mariachi musician standing still at the center-bottom of the frame, rendered as a pure clean dark silhouette with no facial features visible - traditional wide-brim charro sombrero, fitted traje de charro suit outline, holding a guitarrón - casting a long warm shadow across the honey-colored cantera stone paving of Plaza de la Liberación below, with colorful papel picado banners in red, orange, green and yellow cut tissue paper strung in loose diagonal lines overhead from building to building, swaying slightly, framing the upper composition, no people other than the single silhouetted figure, no vehicles, no modern objects. Midground: the grand honey-amber cantera stone neoclassical facade of the Teatro Degollado rising directly behind the silhouette, its ornate columned portico and triangular pediment warmly lit by the low golden-hour sun hitting from the left, long dramatic shadows stretching across the stone paving, the warm amber volcanic stone glowing intensely in the golden light. Background: the twin neo-Gothic spires of the Catedral Metropolitana de Guadalajara rising tall into the upper frame against a vast deep cerulean blue sky transitioning to burnt amber and deep orange near the horizon, a single scattered cloud catching violet and gold light from below, the cathedral facade in warm honey stone matching the Teatro Degollado''s palette. Color grade: saturated warm amber and golden honey tones dominating the stone architecture, deep cobalt blue in the upper sky, rich burnt orange near the horizon, faded warm sepia in the shadow areas consistent with a vintage printed poster. At the very top of the image, centered above the spires, render the single word GUADALAJARA in bold condensed uppercase display serif letters in warm cream-gold with a faint dark drop shadow, leaving clear sky negative space for the title. No modern buildings, no cars, no utility wires, no people other than the single dark silhouette visible anywhere in the scene.",
  "target": "🎯 Target: DALL-E 3 (ChatGPT) - 💡 Foreground/midground/background separation places Teatro Degollado and the Cathedral in distinct spatial layers, the mariachi silhouette is specified as a featureless outline to eliminate aberration risk, and vintage print texture is described visually rather than as a style label."
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 515, '@MiMundoConIA', 'https://x.com/MiMundoConIA/status/2077046470335938826', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-515', '/images/case515.jpg', 'Crea Una Imagen', '["UI","Poster","Classical"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-514', 'A Striking Piece of Hard-edge Modern Art on', 'Template imported from awesome-gpt-image-2 case 514. Source: @SimplyAnnisa.', 'Illustration & Art', 'A striking piece of hard-edge modern art on matte archival paper, with visible screen-printing layers and slight ink misalignment. A young East Asian woman is captured in a sharp, three-quarter profile. Her facial features are rendered with precise, crisp contours, contrasting with abstract, luminous geometric shapes that seem to emanate from within her skin. She wears a sleek, high-collared jacket in deep midnight blue, adorned with a single, bold neon coral brooch in the shape of a sharp triangle. Her dark hair is styled in a severe, architectural bob with blunt edges. Her expression is calm and detached, eyes gazing off-frame. The background is a clean, architectural space with sharp diagonal planes in crisp white and deep slate. High-contrast chiaroscuro lighting highlights the edges of her silhouette. Sophisticated palette: deep midnight blue, crisp white, electric neon coral. A stray cat tail is rendered as a sharp, geometric vector in the bottom left corner. Ultra-modern artistic style. No digital CGI feel.
dutch angle, stray cat tail --ar 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 514, '@SimplyAnnisa', 'https://x.com/SimplyAnnisa/status/2071783914595897555', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-514', '/images/case514.jpg', 'A Striking Piece of Hard-edge Modern Art on', '["3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-513', 'Create a Charming Editorial Travel Illustration of in', 'Template imported from awesome-gpt-image-2 case 513. Source: @Sairah_0.', 'Illustration & Art', 'Create a charming editorial travel illustration of {DESTINATION} in a simple hand-drawn doodled style, as if sketched by hand with a black felt-tip marker in a travel notebook. The illustration should feel personal, spontaneous, and imperfect rather than digitally designed. Think of the kind of drawing someone might casually create while sitting at a café after exploring the destination.** ## COLOR PALETTE Keep the illustration almost entirely black and white. Use **only one accent color: {ONE POINT COLOR}** ## STYLE Draw entirely with black felt-tip pen lines. Use slightly wobbly hand-drawn contours, natural line variation, loose marker strokes, sketch-like confidence, subtle imperfections, slightly open line endings, uneven hand pressure, and occasional overlapping strokes. Every line should clearly look handmade. Avoid perfectly smooth curves, mechanically precise outlines, polished vector graphics, or overly crisp digital rendering. ## SUBJECT Illustrate the unique atmosphere and instantly recognizable identity of **{DESTINATION}** rather than producing a realistic cityscape. Select the destination''s most iconic landmarks, characteristic architecture, local transportation, famous scenery, native plants, local animals, regional food, and cultural objects. Focus on the spirit of the destination instead of literal accuracy. ## COMPOSITION Arrange the selected elements into a balanced editorial composition with generous white space. The layout should feel open, light, and effortless, similar to a designer''s travel sketchbook. Allow objects to overlap naturally without becoming crowded. Every element should have room to breathe. Keep the composition visually relaxed and uncluttered. Apply the blue sparingly to selected details such as water, sky, windows, signs, clothing accents, decorative highlights, or small architectural features. Never introduce any additional colors. ## DRAWING STYLE Keep every object simple and intentionally simplified. Use flat shapes with minimal interior detail. Avoid realistic textures, gradients, shadows, painterly brushwork, glossy surfaces, or complex rendering. The illustration should remain clean, airy, understated, and highly graphic. ## LINE QUALITY The black marker lines are the main visual feature. Lines should feel confident, casual, lively, expressive, and naturally imperfect. Slightly uneven contours, open edges, variable line thickness, and small drawing inaccuracies are encouraged because they enhance the authentic hand-drawn feeling. ## MOOD Warm. Friendly. Relaxed. Playful. Minimal. Editorial. Contemporary. Elegant through simplicity. The finished artwork should resemble a beautifully designed travel notebook, boutique travel guide, editorial magazine illustration, or lifestyle sketchbook rather than a polished digital illustration. ## IMPORTANT No photorealism. No 3D rendering. No painterly effects. No gradients. No heavy shadows. No glossy lighting. No vector-clean artwork. No excessive detail. No busy composition. Preserve generous white space. Maintain a flat editorial doodle aesthetic with a distinctly handmade character. The final image should instantly evoke **{DESTINATION}** through simple, expressive black felt-tip sketches with subtle sky-blue accents.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 513, '@Sairah_0', 'https://x.com/Sairah_0/status/2071779087396606433', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-513', '/images/case513.jpg', 'Create a Charming Editorial Travel Illustration of in', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-512', 'Use the Uploaded Reference Image as the Primary', 'Template imported from awesome-gpt-image-2 case 512. Source: @ShamsAmin56.', 'Characters & People', 'Use the uploaded reference image as the primary character design reference, preserving the overall silhouette, proportions, futuristic apparel layering, helmet geometry, visor shape, stone-like brutalist armor surfaces, black hooded coat, tactical streetwear construction, gloves, boots, utility belt, and monochrome industrial aesthetic.

Create a premium production character sheet for a 2D stylized futuristic freestyle road soccer protagonist inspired by Brutalist architecture, industrial concrete textures, geometric forms, and minimalist sci-fi design language.  The presentation should resemble a AAA game character turnaround sheet mixed with a Nike commercial concept presentation.

The character should feel agile, stylish, confident, athletic, and built for urban freestyle football.  Maintain the concrete-textured helmet with glowing orange visor, oversized hood, tactical long coat, mechanical gauntlets, armored boots, and industrial detailing exactly as the design language.  The football should be integrated naturally into the presentation.  Minimal off-white background (#F7F5F0).

Professional production sheet layout.  Extremely clean linework.  Cinematic concept art.  Premium graphic design.  No photorealism.  High-end stylized illustration.  CHARACTER ANGLES Front View  Neutral hero pose.  Left Side View Right Side View Back View 3/4 Front View Dynamic Freestyle Pose  Standing on one foot while balancing the football.  Hero Pose  Football under foot.  Long coat flowing.  Confident posture.  CLOSE-UP CALLOUTS  Helmet Design  Orange illuminated visor  Concrete brutalist surface  Industrial wear  Panel breakdown  Upper Body  Coat construction  Buckles  Fabric folds  Armor integration  Mechanical Gloves  Finger articulation  Industrial joints  Material breakdown  Utility Belt  Equipment  Fasteners  Soccer accessory pouch  Boot Design  Heavy brutalist geometry  Street football grip  Orange illuminated sole accents  Football Design  Minimal futuristic street football  Concrete-inspired panel graphics  Orange accent details  MATERIAL CALLOUTS  Concrete Composite Armor  Carbon Tactical Fabric  Matte Black Nylon  Industrial Rubber  Forged Titanium Components  Orange Energy Lighting  COLOR PALETTE  Concrete White  Matte Black  Graphite Gray  Charcoal  Burnt Orange Glow  Dark Steel  EXPRESSION SHEET  Neutral  Focused  Competitive  Confident Smile  Game Face  Victory Expression  ACTION SILHOUETTES  Ball Juggle  Around The World  Elastico  Rainbow Flick  Backheel  Crossover  Street Sprint  Ball Stall  CAMERA CALLOUTS  Hero Shot Low Angle  Turnaround Orthographic  Close-up Macro Lens  Dynamic Pose 35mm Tracking Camera  Hero Pose 24mm Cinematic Lens  SFX LABELS  WHOOSH  SWISH  TAP  BOUNCE  THUD  ZIP  SPIN  SKRT  VROOM  RUSH  MUSIC HIT  CROWD CHEER  SLOW MOTION LABELS  120 FPS  240 FPS  Freeze Frame  Motion Trails  Speed Ramping  GUIDELINES  Maintain consistent proportions across all views.  Keep the brutalist design language consistent.  Emphasize concrete-inspired hard surfaces contrasted with flexible tactical fabrics.  Preserve the glowing orange visor as the primary focal point.  Use clean production callouts with arrows and labels.  Include measurement guides, material notes, and design annotations.  Keep presentation minimal and premium.  Avoid clutter.  Professional concept art quality suitable for AAA game development, cinematic production, and advertising pitch decks.  LAYOUT  16:9 Landscape  Top Center: MAIN TITLE STREET FLOW // BRUTALIST FREESTYLE  Below: Production Character Sheet  Center: Large Hero Character  Left: Front • Side • Back Views  Right: 3/4 View • Action Pose • Hero Pose  Bottom: Close-ups • Materials • Color Palette • Equipment • Football Design • Expressions • Camera Notes • SFX • Slow Motion • Production Annotations  Minimal off-white background with subtle grid guides, technical drawing arrows, clean typography, and premium commercial presentation quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 512, '@ShamsAmin56', 'https://x.com/ShamsAmin56/status/2071590431725670517', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-512', '/images/case512.jpg', 'Use the Uploaded Reference Image as the Primary', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-511', 'Create a Clean, Modern Typographic Travel Poster Where', 'Template imported from awesome-gpt-image-2 case 511. Source: @Goodmanprotocol.', 'Posters & Typography', 'Create a clean, modern typographic travel poster where the city name itself becomes the composition. Render the city name in large, bold, uppercase sans-serif letters spanning the width of the artwork. Seamlessly integrate the city''s most iconic landmarks, architecture, monuments, streets, transportation, cultural symbols, cafés, bridges, parks, skylines, sculptures, waterfronts, historic buildings, and local details into, around, and inside the letters. Let landmarks naturally interact with the typography while preserving legibility.
Use an elegant flat vector illustration style with crisp geometric shapes, minimal detail, clean outlines, subtle shadows, and a premium editorial aesthetic. Maintain a limited color palette of deep navy, warm cream, muted red, and soft gray-blue for a timeless travel-poster look.
Add small decorative elements such as street lamps, trees, clouds, birds, benches, bicycles, fountains, trams, ferries, or other city-specific objects where appropriate. Keep generous negative space with a clean background and perfectly balanced composition.
Ensure every landmark, architectural style, vehicle, sign, and cultural element is accurate to the chosen city-avoid generic or incorrect landmarks. If desired, include a small elegant tagline beneath the city name (such as a famous nickname or slogan) in minimal typography.
Style: premium flat vector, minimalist travel poster, geometric illustration, editorial design, tourism branding, clean typography, high contrast, ultra-sharp lines, museum-quality print, modern graphic design, centered composition, scalable SVG aesthetic, 8K resolution.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 511, '@Goodmanprotocol', 'https://x.com/Goodmanprotocol/status/2071819124708438092', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-511', '/images/case511.jpg', 'Create a Clean, Modern Typographic Travel Poster Where', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-510', 'A Macos App Icon for an App Named', 'Template imported from awesome-gpt-image-2 case 510. Source: @iamaiistudio.', 'Brand & Logos', 'A macOS app icon for an app named ''Bichon Shop''. A single squircle icon with smooth continuous rounded corners, centered on a white canvas with padding, occupying about 80% of the canvas. Modern light skeuomorphic macOS App Store style. Only one icon.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 510, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2071923809788285125', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-510', '/images/case510.jpg', 'A Macos App Icon for an App Named', '["UI"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-509', 'A Playful, High-key Studio Portrait of Running Joyfully', 'Template imported from awesome-gpt-image-2 case 509. Source: @Sairah_0.', 'Photography & Realism', 'A playful, high-key studio portrait of [subject] running joyfully across a seamless light gray background, captured mid-stride with one leg lifted and a wide genuine smile. The subject wears a casual oversized outfit with soft neutral tones (or vibrant colors), creating a dynamic sense of motion. Behind them, a simple black hand-drawn cartoon stick figure grabs and stretches the back of their shirt, making the fabric appear elastically pulled as if trying to stop them. The doodle character is integrated naturally into the scene with expressive motion lines and a humorous facial expression. The subject holds a fun prop (such as a dinosaur toy, oversized lollipop, teddy bear, or balloon), enhancing the playful storytelling. Minimalist composition, clean studio lighting, soft shadows, ultra-sharp focus, realistic skin texture, vibrant yet natural colors, whimsical editorial photography, premium children''s fashion campaign aesthetic, highly detailed, photorealistic, 8K.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 509, '@Sairah_0', 'https://x.com/Sairah_0/status/2071929275897491491', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-509', '/images/case509.jpg', 'A Playful, High-key Studio Portrait of Running Joyfully', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-508', ',,,,, --,, ,,,,', 'Template imported from awesome-gpt-image-2 case 508. Source: @ohmuyi.', 'Photography & Realism', '俯拍镜头，高角度顶机位，自上而下俯瞰一位年轻的东亚裔女性，她有着精致的东亚五官和柔顺的黑发。她蹲在花园小径上，轻轻逗弄一只毛茸茸的橘猫。头顶密密的枝叶滤过阳光，形成灵动的"木漏日"效果--跃动、圆形的光斑在她的肌肤和猫毛上流转舞动。空气中悬浮着淡淡的潮湿薄雾，捕捉住光束，营造出柔和可见的立体光柱（丁达尔效应）。当她仰头朝向镜头时，一层轻雾柔化了画面边缘，增添梦幻氛围。她的表情从略带俏皮的轻噘嘴，渐渐转为眼角堆起细纹的真挚笑容，斑驳的光线恰好勾勒出她肌肤的细腻纹理和眼中盈盈的水光。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 508, '@ohmuyi', 'https://x.com/ohmuyi/status/2067930690977779942', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-508', '/images/case508.jpg', ',,,,, --,, ,,,,', '["Photography"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-507', 'A Handcrafted Crochet Doll of a , Made', 'Template imported from awesome-gpt-image-2 case 507. Source: @azed_ai.', 'Characters & People', 'A handcrafted crochet doll of a [subject], made with soft yarn textures and intricate knitted details. Dressed in a vivid [color1] accent and a delicate [color2] garment, holding a small [prop]. Set in a cozy [setting], warm muted atmosphere, charming handmade aesthetic, nostalgic amigurumi style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 507, '@azed_ai', 'https://x.com/azed_ai/status/2067925399947067728', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-507', '/images/case507.jpg', 'A Handcrafted Crochet Doll of a , Made', '["Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-506', ':,,,,,,,:,,;;,,,,;,,,,, : 9:16', 'Template imported from awesome-gpt-image-2 case 506. Source: @xiaoxiaodong01.', 'Posters & Typography', '围绕具体主题内容生成一张明亮清爽的图文合成视觉：画面以大面积高明度纯净色场承托主体，背景平整、通风、没有复杂景深，视觉重心由下方被大胆裁切的人像或真实主体建立，只露出最有记忆点的局部，使主体像从画面边缘进入。主体上方叠放一个极简图形符号或拟物角色，它要像轻轻坐在主体头顶或贴合轮廓生长出来，形体圆润、边缘干净、表情或结构由少量粗线完成，兼具标识感和亲近感。文字是画面的主动角色：顶部使用大号手写感标题，字距松、笔画柔软，像一句轻声招呼；中心用更强的竖向或轴向标题建立层级；边缘安放少量小字号信息，保持安静但精确，让空白继续占主导。色彩从主题自身的材质、情绪、地域或品牌语义中提取，映射为明亮底色、洁净主体亮面、清晰深色结构线与少量强调信息色，保留大面积轻快底场、小面积高对比文字线条、自然主体暗部的关系；整体保持高明度、清透、干净、饱和度清晰而不过度刺激，暗色只用于结构和阅读，不制造脏灰、烟雾或陈旧质感。摄影局部与扁平图形之间要形成真实与童趣的反差，边缘叠压准确，阴影极少，完成感像城市公共宣传与角色插画结合的轻松视觉系统。

主题：柳岩

比例9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 506, '@xiaoxiaodong01', 'https://x.com/xiaoxiaodong01/status/2062924832917029248', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-506', '/images/case506.jpg', ':,,,,,,,:,,;;,,,,;,,,,, : 9:16', '["Poster","Illustration","Brand"]'::jsonb, '["Travel"]'::jsonb, FALSE, TRUE),
    ('case-505', 'A Young Adult Woman with Soft Refined Features,', 'Template imported from awesome-gpt-image-2 case 505. Source: @iamaiistudio.', 'Photography & Realism', 'A young adult woman with soft refined features, thin metal glasses, and shoulder-length dark tousled hair, leaning forward across a dark upholstered couch at night. She wears a pale cream lace-trim camisole with thin straps and matching soft shorts. One hand holds a smartphone close to the foreground, the screen glow casting cool reflections on her fingers and glasses lenses. Her expression is dreamy and softly tired, eyes lifted toward the camera as if she just looked up from scrolling, lips gently closed in a relaxed pout.

Shot in a vertical 3:4 frame at slightly above eye level, medium close-up to three-quarter portrait. Warm dim tungsten room light mixed with cool phone-screen reflections, no flash, soft falloff across the couch and wall. Shallow depth of field, soft low-light grain, slight motion blur, natural imperfect sharpness. Background: plain beige-gray wall, minimal decor, late-night atmosphere. Soft glam makeup: subtle eyeliner, long lashes, smooth skin, glossy pink-nude lips. Realistic social-media night portrait aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 505, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2063231612478017579', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-505', '/images/case505.jpg', 'A Young Adult Woman with Soft Refined Features,', '["Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-504', 'Turn This Photo into a Chaotic Funny Doodle', 'Template imported from awesome-gpt-image-2 case 504. Source: @Shorelyn_.', 'Illustration & Art', 'Turn this photo into a chaotic funny doodle illustration, intentionally messy and low-skill, as if drawn quickly with a cheap marker, crayon, or worn-out felt pen on paper.

Create exaggerated facial features with awkward proportions, uneven eyes, oversized head, tiny body, crooked smile, and clumsy anatomy while still keeping the person recognizable. Use rough childish sketch lines, shaky hand-drawn strokes, visible scribbles, overlapping outlines, accidental marks, and random doodles around the scene. Add a simple cartoon-style background with badly drawn buildings, trees, clouds, street elements, and uneven perspective. Coloring should look careless and imperfect, with visible stroke texture, inconsistent fill areas, wax crayon texture, marker bleed, and irregular shading. Include playful imperfections like crossed-out lines, unfinished details, random arrows, tiny notes, stars, swirls, and abstract scribbles. Overall aesthetic should feel humorous, spontaneous, handmade, energetic, goofy, and intentionally unpolished, resembling a child''s sketchbook mixed with absurd internet meme art. High texture detail, paper grain visible, asymmetrical composition, awkward framing, expressive doodle chaos, raw sketch energy.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 504, '@Shorelyn_', 'https://x.com/Shorelyn_/status/2063235707632533954', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-504', '/images/case504.jpg', 'Turn This Photo into a Chaotic Funny Doodle', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-503', 'Create an Ultra-detailed 3d Stylized Creative Designer Poster', 'Template imported from awesome-gpt-image-2 case 503. Source: @AiwithLariab.', 'Posters & Typography', 'Create an ultra-detailed 3D stylized creative designer poster featuring a cool young digital artist standing confidently in the center of a futuristic blue neon studio. The character wears oversized black streetwear with electric-blue graphic accents, black cargo pants, layered silver chains, black sunglasses, and clean white sneakers. A cute fluffy puppy sits on the artist''s shoulder. The camera angle is dramatic low-angle perspective, making the sneakers appear larger for a premium poster effect.

Surround the character with floating creative elements including a glowing laptop, professional camera, design books, notebooks, 3D icons, social media symbols, holographic UI panels, graphic design tools, and futuristic blue geometric shapes. Add motivational typography such as "DESIGN MODE", "CREATE • BUILD • INSPIRE", and "CREATIVE NEVER SLEEPS" integrated into the scene.

Include a collectible chibi mini-figure version of the character standing beside the main subject on a display base. Use cinematic blue lighting, glossy reflections, volumetric glow, depth of field, floating particles, luxury toy-photography aesthetics, high-end 3D rendering, Octane Render quality, ultra-sharp details, vibrant neon blue color palette, futuristic creator workspace atmosphere, premium commercial poster design, trending ArtStation style, masterpiece quality, 8K resolution, vertical 9:16 composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 503, '@AiwithLariab', 'https://x.com/AiwithLariab/status/2063240283786187251', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-503', '/images/case503.jpg', 'Create an Ultra-detailed 3d Stylized Creative Designer Poster', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-502', 'Use My Uploaded Face Image as the Primary', 'Template imported from awesome-gpt-image-2 case 502. Source: @Professor_134.', 'Characters & People', 'Use my uploaded face image as the primary identity reference. Preserve my exact facial identity with extremely high fidelity: identical facial structure, jawline, cheekbones, eye shape, eyebrows, nose, lips, beard pattern, hairstyle, hair texture, skin tone, skin texture, and overall recognizable appearance. Do not beautify, alter, or reinterpret my face. Maintain realistic anatomy and authentic likeness.

Create an ultra-detailed, cinematic, surreal luxury playing-card artwork.

The main subject is me as the King of Spades, occupying the full design of a magnificent, royal Ace-quality playing card. I wear elaborate black-and-silver spade-themed regalia, a crown forged from obsidian and polished steel, intricate embroidered armor, and flowing royal garments decorated with subtle spade symbols. My expression is calm, intelligent, and powerful.

In my right hand, I am holding a pristine Ace of Spades card.

The creative twist: the Ace of Spades I am holding is not a normal card. It contains another complete playing-card illustration. Inside that card, I again appear as the King of Spades, and that entire card is being elegantly held between the fingers of a majestic Queen of Hearts. The Queen is graceful, regal, and visually striking, dressed in rich crimson and gold royal attire adorned with heart motifs.

The illusion continues with subtle recursive storytelling: the Queen of Hearts appears to be examining the card with fascination, creating a "card within a card" visual paradox. The composition should feel like a legendary tale of power, strategy, love, and destiny intertwined.

Add impossible Escher-inspired visual design elements:
•Infinite recursion effect
•Card-world folding into itself
•Floating spade and heart symbols transforming into ravens and rose petals
•Ornate golden borders extending beyond physical card edges
•Royal chess pieces suspended in midair
•Fractal patterns hidden within the card engravings
•Elegant smoke forming suit symbols
•Dimensional portals emerging from card corners

Style: ultra-realistic fantasy realism mixed with luxury casino art, Renaissance royal portraiture, and modern cinematic concept art.

Lighting: dramatic chiaroscuro, volumetric god rays, rich contrast, glowing metallic highlights, subtle magical energy around the Ace of Spades.

Color palette:
•Deep blacks
•Silver chrome
•Ivory white
•Crimson red
•Antique gold accents

Composition:
•Vertical masterpiece
•Museum-quality detail
•Hyper-realistic textures
•Intricate card engravings
•Perfectly symmetrical playing-card aesthetics blended with cinematic depth
•Sharp focus on my face
•Extremely high identity fidelity
•Epic storytelling through visual symbolism

The final image should feel like the cover of a legendary fantasy card game where the King of Spades has become self-aware, existing across multiple layers of reality while being held in the hands of fate itself, represented by the Queen of Hearts.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 502, '@Professor_134', 'https://x.com/Professor_134/status/2063244295977800057', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-502', '/images/case502.jpg', 'Use My Uploaded Face Image as the Primary', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-501', 'Cinematic Portrait Photography, Ultra-photorealistic, 2160x3840 Vertical Composition, 50mm', 'Template imported from awesome-gpt-image-2 case 501. Source: @iamaiistudio.', 'Photography & Realism', 'Cinematic portrait photography, ultra-photorealistic, 2160x3840 vertical composition, 50mm or 85mm portrait lens rendering, shallow depth of field, clean translucent summer natural-light color grading - not overly yellow, not over-filtered.

Subject: a young beautiful adult East Asian woman, [describe face shape and features, e.g. soft heart-shaped face, refined classical features, bright almond/fox eyes, petite nose bridge, naturally full lips], overall vibe sweet, sunny, energetic, cute with a touch of allure. Gaze highly engaging - bright, clear, natural catchlights, as if it speaks; corners of mouth slightly lifted, expression gentle, vivid, natural.

She walks along a [scene, e.g. garden stone path / tree-lined lane / European street / courtyard], right hand reaching back to hold the hand of someone behind her; only their hand appears in the lower-left corner - like a first-person couple''s POV snapshot. She glances back at the camera while her body stays in a forward walking motion, posture elegant and natural, clearly a candid captured moment with a faint in-love feeling.

Long [hair color] hair, [style, e.g. naturally wavy / relaxed big waves / airy bangs / half-up], many strands tousled and flying in the wind, richly layered and dynamic. Strong natural side-backlight rims the hair edges - clean, crisp rim light and semi-translucent glow, hair edges lit as if by sunlight, light and luminous. This is the core highlight of the image.

She wears [outfit, e.g. white lace slip dress / beige slip dress / light-blue short-sleeve top with white skirt / light-pink fitted dress], fabric texture natural, material light and soft. Bright natural summer sunlight realistically warms her skin, shoulders, collarbone, and clothing with soft, clean highlight transitions.

Skin texture: extremely realistic - visible fine pores, natural skin texture, faint imperfections, subtle tone variation, soft sheen. Cheeks, nose tip, shoulders show natural delicate gradations in sunlight. Translucent, healthy, real and refined - no plastic look, no waxwork, no over-smoothing.

Background: soft atmospheric blur, never distracting.

Avoid: over-smoothing, plastic skin, CG look, anime look, wig look, stiff expression, dead eyes, stiff poses, overall yellow cast, overexposed face, distorted features, wrong fingers, deformed hands, cluttered background, heavy influencer retouching.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 501, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2063247373388992790', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-501', '/images/case501.jpg', 'Cinematic Portrait Photography, Ultra-photorealistic, 2160x3840 Vertical Composition, 50mm', '["Realistic","Character","Classical"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-500', 'Ultra-realistic Ethereal Fantasy Portrait of a Breathtaking Young', 'Template imported from awesome-gpt-image-2 case 500. Source: @HaniaAi12.', 'Photography & Realism', 'Ultra-realistic ethereal fantasy portrait of a breathtaking young woman with delicate porcelain skin, soft grey-blue eyes, and natural rosy lips. She gazes gently toward the viewer with a serene, dreamy expression, her fingertips lightly touching her chin. Wispy ash-brown hair flows softly in the breeze, styled in a loose romantic updo adorned with pastel blush roses, shimmering crystal ornaments, delicate feathers, and intricate floral accessories. She wears elegant dangling crystal earrings and a translucent, flowing gown made of sheer iridescent fabric embroidered with tiny sparkling flowers.

The scene is bathed in soft diffused morning light, creating a luminous glow around her face and shoulders. Surrounded by floating butterflies, sparkling dust particles, translucent petals, and dreamy floral textures, the background blends pastel lavender, pearl white, blush pink, and silver tones. Cinematic fine-art photography, fairycore aesthetic, enchanted garden atmosphere, magical realism, ultra-detailed skin texture, soft focus highlights, volumetric lighting, bokeh, masterpiece quality, highly detailed, 8K resolution, delicate feminine beauty, romantic fantasy artwork, elegant composition, dreamy color grading, soft glow, celestial ambiance.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 500, '@HaniaAi12', 'https://x.com/HaniaAi12/status/2062696495741391006', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-500', '/images/case500.jpg', 'Ultra-realistic Ethereal Fantasy Portrait of a Breathtaking Young', '["Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-499', 'A Full-body Editorial Fashion Photograph of a Beautiful', 'Template imported from awesome-gpt-image-2 case 499. Source: @john_my07.', 'Photography & Realism', 'A full-body editorial fashion photograph of a beautiful young woman with the same appearance as the reference, long glossy dark hair, soft bangs, fair skin, and refined feminine features. She stands casually in an upscale minimalist fashion boutique, wearing an oversized pastel-blue knit sweater paired with a black pleated tennis-style skirt, white crew socks, and chunky designer sneakers. Relaxed confident pose, gentle smile, luxury retail interior with modern clothing racks, neutral-toned garments, warm ambient lighting, wood and stone textures, clean architectural lines, cinematic depth of field, realistic lighting, premium fashion advertising, Vogue-style editorial, ultra-detailed, sharp focus, photorealistic, 4K.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 499, '@john_my07', 'https://x.com/john_my07/status/2062579742759649486', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-499', '/images/case499.jpg', 'A Full-body Editorial Fashion Photograph of a Beautiful', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-498', 'Create a Handrawn Pencil Illustration of Yawning on', 'Template imported from awesome-gpt-image-2 case 498. Source: @AIwithkhan.', 'Illustration & Art', 'Create a handrawn pencil illustration of [image] yawning on paper, as background.

Add a 3D Pixar style render of [foto] standing casually infront of the giant handrawn pencil illustration. Soft cinematic lighting. 8K resolution. 3:4 ratio', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 498, '@AIwithkhan', 'https://x.com/AIwithkhan/status/2062567518389391540', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-498', '/images/case498.jpg', 'Create a Handrawn Pencil Illustration of Yawning on', '["Illustration","3D"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-497', 'Minimalist Vintage Watercolor Travel Poster Illustration of ,', 'Template imported from awesome-gpt-image-2 case 497. Source: @Goodmanprotocol.', 'Posters & Typography', 'Minimalist vintage watercolor travel poster illustration of [CITY NAME], [COUNTRY], rendered entirely in elegant monochromatic [COLOR] watercolor and fine ink linework.

Aspect ratio: 4:5 vertical composition optimized for poster and social media presentation.

A peaceful early-morning streetscape featuring the iconic [PRIMARY LANDMARK] and [SECONDARY LANDMARK/LOCATION] in the foreground, viewed from a slightly low pedestrian-level perspective. Historic local architecture, elegant facades, ornate details, arched windows, decorative cornices, and traditional street elements line the spacious surroundings, creating a timeless urban atmosphere. A classic [LOCAL STREET ELEMENT OR LAMP STYLE] stands prominently on the left side, while mature leafy trees frame portions of the scene, their foliage painted with soft watercolor washes and delicate splatter textures. In the distance, [DISTANT LANDMARK OR SKYLINE FEATURE] rises gracefully against the skyline, serving as a recognizable cultural landmark. A vintage [LOCAL VEHICLE] or a few small pedestrians add subtle life and scale without disturbing the tranquil mood.

The composition includes large areas of clean white negative space, soft cloudy watercolor textures in the sky, delicate paper grain, and subtle watercolor blooms. The paving, street, or plaza stretches dramatically across the foreground, leading the viewer''s eye toward the landmark ensemble. Typography in the upper-left corner reads "[CITY NAME], [COUNTRY]" in a refined serif font, styled like a sophisticated travel journal or collectible city poster.

Handcrafted watercolor illustration, architectural sketch aesthetic, serene urban atmosphere, soft natural morning lighting, muted monochromatic palette, highly detailed line art, elegant travel-poster design, minimalist luxury wall-art style, timeless local charm, premium stationery illustration, ultra-detailed, high-resolution, clean composition, Pinterest-worthy, Instagram-worthy, gallery-quality artwork.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 497, '@Goodmanprotocol', 'https://x.com/Goodmanprotocol/status/2062564327140503787', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-497', '/images/case497.jpg', 'Minimalist Vintage Watercolor Travel Poster Illustration of ,', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-496', 'Create a Premium 3x2 Grid Collage of Iconic', 'Template imported from awesome-gpt-image-2 case 496. Source: @AIwithSynthia.', 'Brand & Logos', 'Create a premium 3x2 grid collage of iconic global brand logos recreated entirely from dynamic water formations, floating above a crystal-clear ocean under a vibrant blue sky. Each panel features a different logo sculpted from realistic transparent water, with detailed splashes, droplets, reflections, refractions, and flowing liquid textures. The water forms should look physically accurate, elegant, and instantly recognizable while remaining made completely of water.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 496, '@AIwithSynthia', 'https://x.com/AIwithSynthia/status/2062521441141088599', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-496', '/images/case496.jpg', 'Create a Premium 3x2 Grid Collage of Iconic', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-495', 'Portrait Illustration in a Storybook Style Featuring a', 'Template imported from awesome-gpt-image-2 case 495. Source: @MissDelulu9.', 'Illustration & Art', 'Portrait illustration in a storybook style featuring a young adult woman exploring the streets of Paris. She is laughing happily with her eyes closed, holding a coffee cup in her hand. She has long, wavy hair and wears a beret hat. The scene is set near a Parisian café in a peaceful morning atmosphere. The woman has a sweet, charming smile. Soft, dreamy mood, romantic Paris street vibe, gentle lighting, and highly detailed artwork.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 495, '@MissDelulu9', 'https://x.com/MissDelulu9/status/2062376738500526347', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-495', '/images/case495.jpg', 'Portrait Illustration in a Storybook Style Featuring a', '["Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-494', 'Create a Premium Square Centered Around a Futuristic', 'Template imported from awesome-gpt-image-2 case 494. Source: @j_smeaton99.', 'Charts & Infographics', 'Create a premium square "reference-style sustainable transportation infographic" centered around a futuristic electric city bus called the {E_BUS_NAME}, designed as a beautifully curated urban-mobility handbook page rather than a commercial vehicle advertisement.

The composition should feel like a modern visual encyclopedia mixed with an elite public-transit engineering guide and high-end editorial infographic system.

Visual Direction

• 1:1 square composition
• Premium smart-city background with subtle transportation blueprints, circuit-inspired overlays, and urban infrastructure schematics
• Elegant palette using deep navy, graphite black, electric green, steel gray, and soft cyan accents
• Refined editorial typography hierarchy
• Rounded modular information cards with clean spacing
• Gentle realistic reflections and premium transit-system dividers
• Minimal transportation engineering iconography
• Extremely detailed central electric bus render viewed in dramatic three-quarter perspective driving through a futuristic smart-city boulevard
• Thin precision annotation lines pointing toward key systems and technologies
• Clean, organized "knowledge-first" layout with high information density but breathable spacing

Main Subject Presentation

A stunning ultra-detailed realistic render of the {E_BUS_NAME} placed at the center, featuring:

• sleek aerodynamic body design
• panoramic windshield
• illuminated destination display
• low-floor accessibility layout
• futuristic LED lighting systems
• premium electric drivetrain details
• realistic urban reflections
• smart-city transportation realism

Surround the bus with engineering callouts explaining:

• battery pack technology
• electric motor system
• regenerative braking system
• charging infrastructure compatibility
• smart fleet management systems
• passenger accessibility features
• thermal battery management
• energy-efficiency technologies
• safety monitoring systems
• intelligent driver assistance features

Include Modular Sections

• E-Bus Overview
• Technical Specifications
• Vehicle Dimensions & Capacity
• Powertrain & Energy System
• Battery Technology Breakdown
• Charging Solutions
• Passenger Comfort Features
• Safety & Reliability Systems
• Fleet Management Technology
• Environmental Impact Analysis
• Operating Cost Comparison
• Construction & Material Engineering
• Sustainability Lifecycle Assessment
• Smart-City Integration
• Global Adoption Trends
• "Did You Know?" Facts Section
• Future of Electric Public Transport

Add Premium Visualization Modules

• battery architecture diagrams
• charging workflow graphics
• energy-consumption charts
• passenger-capacity visualizations
• smart-city integration maps
• drivetrain cutaway illustrations
• environmental impact comparisons
• fleet-management dashboards
• vehicle blueprint dimensions
• lifecycle sustainability graphics

Style Keywords

"premium transportation encyclopedia"
"editorial electric mobility handbook"
"high-end public transit infographic"
"scientific transportation poster"
"museum-quality electric bus reference page"
"modular smart-city knowledge system"
"clean engineering editorial design"
"ultra-detailed mobility visualization"
"future transportation showcase"
"sustainable urban mobility design"

Avoid

• generic vehicle advertisements
• cluttered commercial brochure layouts
• cartoon transportation styling
• unrealistic flying-bus concepts
• excessive cyberpunk neon overload
• low-detail stock-vehicle renders

Final Goal

The final result should resemble a professionally published transportation-engineering reference-book page created for urban planners, transportation engineers, sustainability researchers, architects, public-transit authorities, and smart-city enthusiasts, combining technical accuracy, sustainability insights, and premium editorial design.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 494, '@j_smeaton99', 'https://x.com/j_smeaton99/status/2062365258984177766', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-494', '/images/case494.jpg', 'Create a Premium Square Centered Around a Futuristic', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-493', 'Generate Image of Young Female Travel Vlogger Exploring', 'Template imported from awesome-gpt-image-2 case 493. Source: @AIwithSynthia.', 'Scenes & Storytelling', 'Generate image of young female travel vlogger exploring Tokyo across multiple candid moments, extremely beautiful with long dark wavy hair, wearing stylish Japanese-inspired oversized streetwear, expressive and spontaneous personality, captured across a 13-frame grid collage (Row 1: 4 frames | Row 2: 5 frames | Row 3: 4 frames), each frame feels like a real casual phone capture with imperfect framing and natural inconsistencies.

Frame Breakdown

Row 1 - Frame 1 (Tokyo Tower): low angle selfie with Tokyo Tower behind her, slightly tilted horizon, sky overexposed to near white, she''s mid-natural smile adjusting into frame, small lens smudge in corner, candid arrival energy.
Row 1 - Frame 2 (Shibuya street level): walking through Shibuya crossing at night, handheld motion blur, she glances back at camera mid-step, neon reflections on wet pavement, slightly shaky framing, imperfect crop.
Row 1 - Frame 3 (Convenience store): inside a brightly lit convenience store, she is holding onigiri close to camera, playful raised eyebrows, harsh fluorescent lighting flattening the scene, slight overexposure on whites, shelves softly blurred behind.
Row 1 - Frame 4 (Yoyogi park): sitting on a bench under trees, looking away from camera, quiet candid moment, soft dappled daylight, slight focus miss on eyes, subtle lens smudge bottom corner.
Row 2 - Frame 5 (Takoyaki reaction): close-up while eating single takoyaki, reacting mid-bite with laughter, slight motion blur, warm lantern light behind, face slightly out of focus due to movement.
Row 2 - Frame 6 (Vending machine night): standing in front of glowing vending machine, blue and pink light casting uneven tones on her face, pressing button casually, high ISO grain visible.
Row 2 - Frame 7 (Train reflection): her face reflected in train window at night, city lights streaking behind, layered reflection effect, slight ghosting on glass, she looks away from camera.
Row 2 - Frame 8 (Torii gate): low angle shot of her walking through a torii gate, captured from slightly behind, motion blur in her movement, bright sky causing mild lens flare.
Row 2 - Frame 9 (Digital art exhibit): inside immersive light exhibit, colored lights (blue, violet, gold) washing across her face, she looks upward in awe, slight motion blur, low-light noise visible.
Row 3 - Frame 10 (Gundam statue): low angle wide shot, she stands small in frame while large statue towers above, slight barrel distortion from phone lens, sky slightly blown out.
Row 3 - Frame 11 (Lantern alley): walking through narrow alley lit by warm lanterns, shot from behind, she glances back briefly, underexposed shadows, grainy night detail.
Row 3 - Frame 12 (Rooftop skyline): selfie with Tokyo skyline behind, arm extended, wind blowing hair partially across lens, horizon slightly tilted, warm city glow overexposed in distance.
Row 3 - Frame 13 (Nara park): crouching down in a park in Nara, she holds out a deer cracker toward a deer, the deer bows its head toward her, she bursts into genuine laughter mid-reaction, surprised and slightly leaning back, another deer nudges her from behind causing her to lose balance slightly, camera captures the moment imperfectly with slight shake and off-center framing, soft natural daylight, open park background with trees and space, unscripted chaotic energy, candid expression.

Young female travel vlogger exploring Tokyo across 13 candid moments in a grid collage, extremely beautiful with long dark wavy hair, wearing stylish Japanese streetwear, expressive and spontaneous, scenes include Tokyo Tower selfie, Shibuya crossing at night, convenience store snack moment, park bench quiet scene, takoyaki reaction, vending machine glow, train window reflection, torii gate walk, immersive light exhibit, Gundam statue low angle, lantern alley walk, rooftop skyline selfie, Harajuku street ending, each frame slightly imperfect with motion blur.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 493, '@AIwithSynthia', 'https://x.com/AIwithSynthia/status/2062383568253505904', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-493', '/images/case493.jpg', 'Generate Image of Young Female Travel Vlogger Exploring', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-492', 'Create a Hyper-realistic Luxury Fashion Portrait Inspired by', 'Template imported from awesome-gpt-image-2 case 492. Source: @xRahultripathi.', 'Photography & Realism', 'Create a hyper-realistic luxury fashion portrait inspired by premium fashion-week editorials.

IMPORTANT:
Generate ONLY ONE SINGLE VERTICAL IMAGE.

STYLE:
Luxury fashion realism.
Professional couture photography.
Premium editorial atmosphere.

MAIN CONCEPT:
A beautiful adult Asian fashion model photographed inside a luxury hotel suite.

OUTFIT:
Elegant black couture mini dress.
Luxury embroidered details.
Premium designer fashion aesthetic.

BACKGROUND:
Luxury hotel interior.
Soft neutral decor.
Elegant cinematic depth blur.

LIGHTING:
Soft luxury window lighting.
Professional fashion-editorial reflections.
Natural skin texture.

MOOD:
Bold.
Elegant.
High-fashion energy.

QUALITY:
Ultra realistic native 4K HDR realism.
Professional magazine quality.
Vertical 9:16.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 492, '@xRahultripathi', 'https://x.com/xRahultripathi/status/2062100757923733617', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-492', '/images/case492.jpg', 'Create a Hyper-realistic Luxury Fashion Portrait Inspired by', '["UI","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-491', 'A Moody Late-night Mirror Selfie Captured in a', 'Template imported from awesome-gpt-image-2 case 491. Source: @jzaib4269.', 'Photography & Realism', 'A moody late-night mirror selfie captured in a luxury high-rise bathroom overlooking a glowing city skyline. A young woman with long, slightly messy black hair leans forward over a marble sink, partially obscuring one eye with loose strands. The photo is taken through a smudged mirror with visible dust particles, water spots, and imperfections, creating an authentic raw aesthetic. A powerful direct camera flash explodes in the frame, producing harsh highlights, lens flare, and a nostalgic early-2000s digital camera look.

The bathroom counter is cluttered with luxury cosmetics, skincare products, jewelry, a smartphone, and everyday personal items, adding a lived-in editorial feel. Reflections of neon-lit skyscrapers and hotel windows shimmer in the background, emphasizing an urban nightlife atmosphere. Soft pale skin tones contrast against dark clothing and black hair. The composition feels intimate, candid, and effortlessly cool.

Style: Y2K flash photography, candid mirror selfie, Korean editorial aesthetic, indie sleaze, hotel bathroom scene, luxury lifestyle, cinematic nightlife, disposable camera look, grainy texture, flash burn, realistic skin texture, shallow depth of field, authentic imperfections, viral Pinterest mood, high-fashion casual energy, raw unfiltered photography.

Camera: direct flash, compact digital camera, 35mm equivalent, harsh lighting, slight motion blur, visible noise, natural color grading, vertical composition, ultra-realistic, high detail.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 491, '@jzaib4269', 'https://x.com/jzaib4269/status/2062184740849930384', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-491', '/images/case491.jpg', 'A Moody Late-night Mirror Selfie Captured in a', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-490', 'A Cinematic Double-exposure Fashion Portrait Featuring a Woman', 'Template imported from awesome-gpt-image-2 case 490. Source: @Anaya_Ai12.', 'Photography & Realism', 'A cinematic double-exposure fashion portrait featuring a woman with the uploaded face used 100% as reference, wearing stylish metallic aviator sunglasses. The composition artfully blends a large, semi-transparent close-up profile of her face on the left with her full-body figure standing confidently on the right. She wears an open, light-grey textured corduroy shirt layered over a dark grey fitted t-shirt and dark denim jeans, posing naturally with her hands in her pockets. She has long, flowing dark hair, flawless skin, elegant feminine features, and a confident, sophisticated expression.

The background is a minimalist neutral studio setting, allowing the double-exposure composition to remain the visual focus. The color grading features a sophisticated warm desaturated sepia and charcoal palette, enhanced by a soft golden-orange light-leak flare in the upper-right corner. Professional 85mm lens photography with high-contrast yet soft cinematic lighting accentuates the fabric textures, facial details, and layered portrait effect.

Ultra-realistic skin texture, luxury fashion-editorial aesthetic, premium magazine-cover quality, subtle film grain, cinematic depth, elegant shadows, refined color grading, modern retro-inspired styling, masterpiece composition, ultra-sharp focus, visually striking storytelling, high-end commercial fashion campaign look.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 490, '@Anaya_Ai12', 'https://x.com/Anaya_Ai12/status/2062191518975508678', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-490', '/images/case490.jpg', 'A Cinematic Double-exposure Fashion Portrait Featuring a Woman', '["Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-489', 'Create a Highly Detailed Cinematic Miniature Tilt-shift Travel', 'Template imported from awesome-gpt-image-2 case 489. Source: @SimplyAnnisa.', 'Architecture & Spaces', 'Create a highly detailed cinematic miniature tilt-shift travel scene of [CITY NAME] featuring a realistic [VEHICLE NAME] driving along a winding elevated road that emerges naturally from a printed vintage-style city map. The road should curve dramatically toward the background skyline and landmarks of [CITY NAME], while the vehicle remains the clear focal point in the foreground.

Blend the real city seamlessly with the illustrated map surface so the road appears integrated into the map itself. Include recognizable local landmarks, waterways, architecture, vegetation, and atmosphere associated with [CITY NAME], but keep the composition clean and uncluttered.

Show large bold typography of "[CITY NAME]" printed directly on the map in the foreground. Use warm golden-hour lighting, shallow depth of field, realistic textures, cinematic shadows, aerial perspective, and photorealistic detail. The overall aesthetic should feel like a premium Instagram travel poster mixed with a miniature diorama.

Aspect ratio 1:1.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 489, '@SimplyAnnisa', 'https://x.com/SimplyAnnisa/status/2062358269172101240', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-489', '/images/case489.jpg', 'Create a Highly Detailed Cinematic Miniature Tilt-shift Travel', '["Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-488', 'Ultra-realistic, High-quality Portrait of a Stylish Young South', 'Template imported from awesome-gpt-image-2 case 488. Source: @HaniaAi12.', 'Photography & Realism', 'Ultra-realistic, high-quality portrait of a stylish young South Asian woman standing gracefully on a colorful urban rooftop basketball court at sunset. She is standing in a relaxed and elegant posture with her weight naturally shifted to one leg, shoulders relaxed, and one hand gently resting by her side while the other lightly touches the edge of her varsity jacket. Her body is slightly angled toward the camera, creating a confident yet sophisticated appearance. She is looking directly into the camera with a warm, natural smile, projecting confidence, charm, and effortless style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 488, '@HaniaAi12', 'https://x.com/HaniaAi12/status/2061313477696954522', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-488', '/images/case488.jpg', 'Ultra-realistic, High-quality Portrait of a Stylish Young South', '["Realistic"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-487', '35mm Anamorphic, 2', 'Template imported from awesome-gpt-image-2 case 487. Source: @AIwithSynthia.', 'Scenes & Storytelling', '35mm anamorphic, 2.39:1, no flares. Ultra-realistic international French pharmacy skincare commercial for La Roche-Posay Anthelios UVMune 400 Hydrating Cream SPF50+. Soft premium music plus tactile realistic sound effects throughout. Rich warm natural grain, premium but not over-polished. Palette: warm ivory whites, soft stone neutrals, signature La Roche-Posay orange, subtle clinical cyan-blue, sunlit beige, realistic warm skin tones. The tube is iconic. The skin is the proof. Every shot builds toward the moment the product disappears into real skin and protection becomes confidence. Fast cuts, macro intimacy, tactile realism, one quiet transformation that feels earned: sunscreen that looks invisible, breathable, and real.

MODEL / WARDROBE

Use the same female model consistently across all shots, matching the approved character sheet: slim natural model proportions, warm medium skin tone, dark brown hair in a clean low bun, refined oval face, natural brows, realistic under-eye detail, subtle lips, minimal makeup. Same face, same hairstyle, same body structure, same skin tone, same wardrobe continuity throughout.

Wardrobe must be modest, elegant, and fully covered. No exposed body, no tank top, no fitted clothing, no cleavage, no bare shoulders, no body-hugging silhouette. Wardrobe: loose cream linen button-up shirt, full sleeves, fully buttoned or layered over a high-neck white inner top, soft beige trousers only if visible, minimal jewelry, refined French pharmacy skincare styling. Clothing should feel premium, breathable, clean, and international, never sensual, revealing, or fashion-body-focused.

The camera may show hands, face, neck-up portrait, shoulders, waist-up, mirror shots, bathroom ritual shots, and outdoor walking lifestyle shots, but the body must not be emphasized. Keep attention on skin texture, hands applying sunscreen, product packaging, morning ritual, and confident protected face.

SKIN REALISM

Skin must look human and unfiltered: visible pores, peach fuzz, tiny fine lines, slight under-eye texture, natural skin tone variation, realistic facial micro texture, matte-hydrated finish. No glossy skin, no oily shine, no wet-look face, no waxy AI skin, no porcelain smoothing, no glam beauty filter, no fake glow.

PRODUCT REFERENCE

Use the exact La Roche-Posay Anthelios UVMune 400 Hydrating Cream SPF50+ product reference: white tube, orange square logo, black La Roche-Posay typography, orange SPF50+ panel, light blue hydrating cream band, orange lower panel, white pump-cap base. Product shape and color blocking must remain consistent.

MUSIC DIRECTION

Soft elegant premium skincare music throughout: gentle piano, airy ambient pads, subtle low-end warmth, very light modern electronic pulse, calm emotional lift. Music should feel expensive, dermatological, trustworthy, and international. Never loud, never dramatic, never trailer-like, never distracting. The music should support the tactile sound design without overpowering it.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 487, '@AIwithSynthia', 'https://x.com/AIwithSynthia/status/2061300623530942922', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-487', '/images/case487.jpg', '35mm Anamorphic, 2', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-486', 'Ultra-detailed Mixed-media Sports Poster Featuring the Same Woman', 'Template imported from awesome-gpt-image-2 case 486. Source: @AIwithkhan.', 'Posters & Typography', 'Ultra-detailed mixed-media sports poster featuring the SAME woman from the reference image, wearing a Royal Challengers Bengaluru (RCB) jersey, holding the IPL trophy beside her. Dynamic fusion of realistic portrait photography, sketch art, watercolor splashes, paint strokes, ink scribbles, and digital painting effects. Explosive red, black, gold, and white color palette. Dramatic championship atmosphere with confetti, fireworks, cheering stadium crowd, RCB flags waving in the background, paint splatter textures, hand-drawn line art accents, and energetic brushwork.

The woman has a confident expression, bold red lipstick, flawless skin, short black bob haircut, cinematic lighting, ultra-sharp blue eyes, premium sports-fashion styling. RCB face paint on cheek, luxury gold jewelry accents, highly detailed jersey fabric.

Large typography on the right side reading:

RCB
IPL CHAMPIONS
2026

Handwritten slogan at bottom left:

Ee Sala Cup Namde!

Premium championship poster design, trending Behance artwork, sports magazine cover aesthetic, layered paint textures, realistic trophy reflections, high contrast, ultra-detailed, 8K, masterpiece, award-winning digital art, vibrant colors, cinematic composition, splash art, sketch effect, watercolor effect, paint explosion effect, mixed-media illustration, poster-worthy design.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 486, '@AIwithkhan', 'https://x.com/AIwithkhan/status/2061305471492096301', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-486', '/images/case486.jpg', 'Ultra-detailed Mixed-media Sports Poster Featuring the Same Woman', '["Poster","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-485', 'Stylish Fashion Catalog Shoot Blending Streetwear and Luxury', 'Template imported from awesome-gpt-image-2 case 485. Source: @Mind_Boticni.', 'Products & E-commerce', 'Stylish fashion catalog shoot blending streetwear and luxury branding. Female model wearing burgundy slim-fit top and ivory tailored pants, posed in confident relaxed positions across multiple duplicated frames. Slight perspective tilt, dynamic layout collage, soft daylight studio lighting with warm tone grading. Modern shopping website aesthetic, minimal UI-inspired composition, high resolution fashion photography.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 485, '@Mind_Boticni', 'https://x.com/Mind_Boticni/status/2061310969192870028', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-485', '/images/case485.jpg', 'Stylish Fashion Catalog Shoot Blending Streetwear and Luxury', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-484', 'High-contrast Black-and-white Urban Portrait of a Curly-haired Bearded', 'Template imported from awesome-gpt-image-2 case 484. Source: @harboriis.', 'Posters & Typography', 'High-contrast black-and-white urban portrait of a curly-haired bearded man in a black leather jacket, holding two fingers near glowing neon green eyes, with bold graffiti doodles, colorful paint splashes, abstract arrows, crown sketches, and grunge street-art textures on a concrete background, cinematic lighting, edgy graphic poster style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 484, '@harboriis', 'https://x.com/harboriis/status/2060208419811074350', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-484', '/images/case484.jpg', 'High-contrast Black-and-white Urban Portrait of a Curly-haired Bearded', '["Poster"]'::jsonb, '["Tech","Fashion","Travel"]'::jsonb, FALSE, TRUE),
    ('case-483', 'A Stylish Cinematic Portrait of a Confident Young', 'Template imported from awesome-gpt-image-2 case 483. Source: @HaniaAi12.', 'Photography & Realism', 'A stylish cinematic portrait of a confident young woman leaning casually against a textured urban concrete wall, surrounded by vibrant flying birds including blue macaws, white seagulls, and a colorful hummingbird. Black graffiti-style bird silhouettes painted on the wall create an artistic street-art vibe. She is wearing a trendy all-white outfit - oversized denim jacket, fitted graphic tee, skinny jeans, and black sneakers. Soft natural daylight, realistic shadows, ultra-detailed fashion photography, urban luxury aesthetic, sharp facial features, glossy hair, high-end editorial style, dynamic composition, photorealistic, depth of field, 8K quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 483, '@HaniaAi12', 'https://x.com/HaniaAi12/status/2060216757797978245', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-483', '/images/case483.jpg', 'A Stylish Cinematic Portrait of a Confident Young', '["Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-482', 'Ultra-realistic Conceptual Portrait of a Young Man with', 'Template imported from awesome-gpt-image-2 case 482. Source: @Shorelyn_.', 'Photography & Realism', 'Ultra-realistic conceptual portrait of a young man with curly hair and light stubble, wearing yellow-tinted rectangular sunglasses, a beige minimal t-shirt, blue jeans, and off-white sneakers. He is sitting casually with a relaxed posture.

The twist: he is seated on a large, hyper-realistic version of his own detached head placed on the ground. The head is scaled up, lying sideways, with the same facial features and sunglasses, creating a surreal self-reflection concept.

Composition: centered, full-body shot, neutral studio background with soft beige tones, minimal aesthetic. Clean negative space.

Typography integrated into the background:

* Handwritten-style text at the top: "HEAVY"
* Below it, smaller text: "ON MY OWN MIND" with "MIND" crossed out
* Large, rough, scribbled text in black: "HEAD"

Lighting: soft diffused studio lighting, subtle shadows, high detail, fashion editorial quality.

Style: blend of surrealism and modern streetwear campaign, minimal yet expressive, high-resolution, 8k, sharp focus, natural skin texture.

Mood: introspective, mental weight, identity, self-awareness.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 482, '@Shorelyn_', 'https://x.com/Shorelyn_/status/2060207260685791267', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-482', '/images/case482.jpg', 'Ultra-realistic Conceptual Portrait of a Young Man with', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-481', 'Cute Korean Spring Aesthetic Scrapbook Poster, Dreamy K-fashion', 'Template imported from awesome-gpt-image-2 case 481. Source: @Taaruk_.', 'Posters & Typography', 'Cute Korean spring aesthetic scrapbook poster, dreamy K-fashion portrait, soft blonde girl standing in a blooming flower garden, pastel blue sky background, cream floral blouse layered under a knitted ivory sweater vest, light blue high-waisted jeans, natural smile, glowing fair skin, soft makeup, cherry blossom trees, colorful spring flowers, cozy countryside garden, bright natural sunlight, kawaii doodle overlays, hand-drawn white hearts, smiley faces, stars, sparkles, rainbows, playful handwritten typography, polaroid photo frames, masking tape stickers, scrapbook collage layout, Pinterest aesthetic, Korean magazine editorial, cottagecore fashion, dreamy spring vibes, wholesome mood, soft pastel color palette, clean composition, aesthetic social media poster, ultra detailed, photorealistic, high quality, cute and charming atmosphere, subtle bokeh, lifestyle photography, Instagram reel cover, fashion moodboard, Y2K scrapbook design, white outline around subject, flower-themed decorations, 8k masterpiece', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 481, '@Taaruk_', 'https://x.com/Taaruk_/status/2060214163591614900', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-481', '/images/case481.jpg', 'Cute Korean Spring Aesthetic Scrapbook Poster, Dreamy K-fashion', '["Poster","Realistic"]'::jsonb, '["Tech","Social","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-480', 'Draw Me as If an Obsessed Fan Artist', 'Template imported from awesome-gpt-image-2 case 480. Source: @Ciri_ai.', 'Characters & People', 'Draw me as if an obsessed fan artist filled an entire sketchbook page - messy, overlapping, full-body poses, tiny chibi doodles, exaggerated expressions, and random close-ups of their hands or eyes.
White background. No grid, no order. Pure chaos energy. With (any color) aesthetic clothes', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 480, '@Ciri_ai', 'https://x.com/Ciri_ai/status/2060211436232786357', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-480', '/images/case480.jpg', 'Draw Me as If an Obsessed Fan Artist', '["Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-479', 'Transform the Uploaded Image into a Minimalist Illustration', 'Template imported from awesome-gpt-image-2 case 479. Source: @oggii_0.', 'Illustration & Art', 'Transform the uploaded image into a minimalist illustration in a magazine collage style, using paper cutouts. Retain the main subject, pose, and overall concept of the original image, but reimagine it as a warm, hand-edited collage. Style: Minimalist illustration in a magazine paper collage style, with flat, layered paper shapes, soft pastel paper textures, torn paper edges, paper shadow effects, neat black doodle accents, a handmade scrapbook atmosphere, modern Korean editorial design, a simple and cute composition, and large areas of clean white space. Character: Cute, simplified Korean characters with minimalist facial features, a small, relaxed smile, soft and rounded proportions, simple and casual clothing, and silhouettes constructed from layered paper cutouts. Composition: A 3:4 aspect ratio, with the main subject positioned slightly lower and off-center, leaving a large, open space on the opposite side for a breezy, minimalist composition that avoids clutter. Objects: Add only a few suitable collage elements: paper sticky notes, small hearts, plants, a cup of coffee, a window, tape fragments, and simple doodle icons. Typography: Add an elegant, handwritten English title that fits the scene''s atmosphere. Use short phrases such as: ["May you be like the morning sunshine, full of vitality and hope, embracing the beauty of each day.","Take a small break," or "Good day, good mood."] Atmosphere: Calm, comfortable, warm, sweet, and editorial style. Avoid: Photorealistic style, anime style, watercolor style, 3D clay style, overly detailed backgrounds, excessive collage elements, a luxury poster atmosphere, dark tones, harsh shadows, and sloppy text.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 479, '@oggii_0', 'https://x.com/oggii_0/status/2060212097083146644', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-479', '/images/case479.jpg', 'Transform the Uploaded Image into a Minimalist Illustration', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-478', 'Case 478 Brand and Logos Template', 'Template imported from awesome-gpt-image-2 case 478. Source: @iamaiistudio.', 'Brand & Logos', '[BRAND NAME]. You are a world-class editorial designer.

STEP 1, DYNAMIC SUBJECT LOGIC:
- Subject pick: independently study [BRAND NAME] and choose the right hero subject.
- Sandwich layering: weave the subject through the background shapes. Parts of the car or figure must sit hidden behind geometric blocks, while other parts (wheels, limbs, props) overlap in front of those blocks to fake real 3D depth.

STEP 2, GRID & GEOMETRY:
- Layout: a clean 2x2 grid composition.
- Overlays: drop large bold geometric arcs and circles on top of the grid.
- Visual balance: place one iconic product prop (a floating key fob for cars, a ball for sports, etc.) in its own quadrant to counterweight the subject.

STEP 3, SOPHISTICATED MUTED PALETTE:
- No aggressive neon, no oversaturated colors.
- Pull [BRAND NAME]''s core colors and shift them into a "sophisticated muted" range. Use desaturated, earthy, dusty versions of the brand colors (dusty rose instead of hot pink, sage green instead of bright mint, slate blue instead of royal blue).
- Finish: matte flat color blocks, zero gradients.

STEP 4, PHOTOGRAPHY & LIGHTING:
- Subject style: high-end commercial studio photography.
- Lighting: soft diffused studio light, gentle highlights, no harsh shadows.
- Integration: the subject must feel physically embedded into the graphic grid.

STEP 5, MINIMALIST BRANDING:
- Drop a clean single-color [BRAND NAME] logo dead-center on one background block. No tagline, just the iconic symbol.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 478, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2060000278657839398', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-478', '/images/case478.jpg', 'Case 478 Brand and Logos Template', '["Poster","Realistic","Product"]'::jsonb, '["Commerce","Food","Story"]'::jsonb, FALSE, TRUE),
    ('case-477', 'Top-down Ultra-wide Hyper-realistic Shot of 4 Real People', 'Template imported from awesome-gpt-image-2 case 477. Source: @iamaiistudio.', 'Scenes & Storytelling', 'Top-down ultra-wide hyper-realistic shot of 4 real people seated at a square dining table. Pull the camera way back so a wide ring of empty floor surrounds the whole scene, giving a clean minimal composition. Scene [ATMOSPHERE + WARDROBE]: the four are styled in [OUTFIT STYLE]. Each one is doing something specific: [DESCRIBE EACH PERSON''S ACTION].

The table itself is a physical prop built to look like an Instagram post viewed from above:
- A solid white band runs along the TOP and BOTTOM edges only, with no white on the left or right sides.
- Top band: a small drawn profile avatar with [LOGO DESCRIPTION], the handle "[USERNAME]", a tiny blue verified check next to it, and a "..." on the far right.
- Bottom band: red heart, comment bubble, and share icons painted on the left, bookmark icon on the right.

The center of the table is one flat color: [EXACT COLOR + HEX CODE]. All food, drinks, props, and any hand interacting with them must stay strictly inside that central colored zone, nothing crosses the white bands or the table edge. The floor around the table is [FLOOR COLOR] to create clear visual separation. Professional studio lighting with crisp shadows, 8k, tack-sharp focus.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 477, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2060210845225980366', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-477', '/images/case477.jpg', 'Top-down Ultra-wide Hyper-realistic Shot of 4 Real People', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-476', 'Create Ultra-fine Highly Detailed 3d Realistic Miniature Chibi-like', 'Template imported from awesome-gpt-image-2 case 476. Source: @Zyrellix.', 'Illustration & Art', 'Create ultra-fine highly detailed 3D realistic miniature chibi-like cute girl, wearing cream colour top and jeans, resting and floating on creamy latte cup, stylized textured ceramic cup, sleeping expression, satin soft pillow tucked behind her head. The latte cream forms a text "Good Morning" in a cute handwriting. Soft-focus minimalist background, bright natural light, 8K UHD.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 476, '@Zyrellix', 'https://x.com/Zyrellix/status/2059443447602561444', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-476', '/images/case476.jpg', 'Create Ultra-fine Highly Detailed 3d Realistic Miniature Chibi-like', '["Realistic","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-475', 'Using the Attached Image, Create an Illustration Sheet', 'Template imported from awesome-gpt-image-2 case 475. Source: @iamaiistudio.', 'Products & E-commerce', 'Using the attached image, create an illustration sheet of professional industrial design packaging for the package (PACKAGE TYPE). A centered heroic 3D rendering with realistic materials, soft studio lighting and commercial quality finishes. Surrounded by technical views: front, side, top, bottom, oblique perspective and flat position. Include sketches of the frame structure, crease lines, seam details, and size arrows in millimeters. Show materials and finishes (matte, glossy print, plastic, paper, glass, etc.) in handwritten annotations. Add color swatches, realistic product illustrations, and subtle shadows. Clean sketchbook background, realistic rendering + pencil sketch style, modern design design, ultra-detailed, portfolio ready.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 475, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2059305097897914664', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-475', '/images/case475.jpg', 'Using the Attached Image, Create an Illustration Sheet', '["Realistic","Illustration","Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-474', 'Minimalist Flat Travel Poster Illustration Series of Iconic', 'Template imported from awesome-gpt-image-2 case 474. Source: @Taaruk_.', 'Posters & Typography', 'Minimalist flat travel poster illustration series of iconic destinations around the world, clean vector art style, Scandinavian color palette, soft pastel tones, calm atmospheric scenery, Hallstatt Austria lakeside village with alpine mountains and reflections, Bergen Norway colorful harbor houses with fjord background, Kyoto Japan traditional riverside town with cherry blossoms and pagoda, Santorini Greece white architecture with blue domes overlooking the sea, ultra clean composition, geometric landscape shapes, smooth gradients, elegant typography with destination names, modern tourism poster aesthetic, serene travel mood, crisp vector lines, cinematic wide-angle scenery, peaceful skies with stylized clouds, highly detailed environment art, contemporary flat illustration, premium editorial travel design, balanced composition, minimal shadows, dreamy vacation atmosphere, soft morning lighting, high-end Airbnb poster vibe, Behance trending style, 4k, ultra detailed', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 474, '@Taaruk_', 'https://x.com/Taaruk_/status/2059188921096085888', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-474', '/images/case474.jpg', 'Minimalist Flat Travel Poster Illustration Series of Iconic', '["Poster","Illustration"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-473', 'Rogue Viper - Video Game Concept Art Sheet', 'Template imported from awesome-gpt-image-2 case 473. Source: @KimAkiyama81.', 'Characters & People', '**ROGUE VIPER - VIDEO GAME CONCEPT ART SHEET PROMPT**

---

Official AAA video game concept art sheet titled **''ROGUE VIPER''** for an Unreal Engine 5 third-person action-stealth game. Professional game development documentation layout on a dark charcoal #1A1A1A background with gold stencil label typography throughout. Four clearly labeled panels arranged in a 2×2 grid with a header and footer.

---

**SHEET HEADER** - Bold gold stencil font title text: **ROGUE VIPER** centered at top. Subtitle beneath in smaller tracking-heavy label font: **CHARACTER & ENVIRONMENT CONCEPT SHEET | UNREAL ENGINE 5 | ACTION / STEALTH - THIRD PERSON**

---

**PANEL 1 - TOP LEFT - Label: "PROTAGONIST: MEI LIU / ROGUE VIPER"**

Full-body character turntable reference of a 30-year-old East Asian Chinese-American female operative. Athletic and toned, 5''8", long straight black hair worn loose, calm neutral expression with sharp eyes. Wearing a form-fitting matte black tactical bodysuit with gold accent seams running along the shoulders, forearms, and thighs, gold cobra snake belt buckle at the waist, calf-high black tactical boots with subtle gold trim. Armed with twin suppressed 9mm pistols holstered on each hip with custom viper-scale grip texture, a serrated combat knife sheathed vertically on the right thigh, and a compact pneumatic grappling hook launcher mounted on the left forearm. Three views arranged side-by-side: front, 3/4, and back. Unreal Engine 5 physically-based rendering, photorealistic skin and fabric materials, neutral 3-point studio lighting for maximum clarity, gold and matte black color scheme throughout.

---

**PANEL 2 - TOP RIGHT - Label: "ENEMY TYPE 01: OBSIDIAN PROTOCOL ENFORCER"**

Three enemy soldiers shown as character references against a dark background. These are elite private military contractors working for a shadow arms cartel called Obsidian Protocol. Their uniform: slate-gray and black modular plate carriers with deep crimson geometric hex-patch insignia on the shoulder, full-face ballistic visors with a dark red tinted lens, black tactical gloves, reinforced combat boots. Armed with compact bullpup assault rifles with red laser sights. One figure standing in neutral patrol stance, one crouched in a ready alert position, one depicted mid-aim with rifle raised. All three shown at the same scale for comparison. Same UE5 photorealistic PBR render style. Crimson and slate-gray color language to contrast Viper''s gold and black.

---

**PANEL 3 - BOTTOM LEFT - Label: "STEALTH ENVIRONMENT: OBSIDIAN PROTOCOL BLACK SITE - ALPINE RESEARCH FACILITY"**

Wide cinematic establishing shot of a stealth mission environment. A hidden high-altitude research facility buried inside a snow-covered mountain, accessible only via an underground tram. Interior architecture is brutalist concrete and frosted glass, dimly lit with cold white fluorescent overhead strips and amber emergency lighting casting long dramatic shadows across polished concrete floors. Rows of classified server terminals and cryogenic storage units line the walls. Ventilation shafts visible in the ceiling above catwalks. A security camera sweeps a slow arc over a central corridor below. In the foreground, Rogue Viper is pressed flat against a concrete pillar in deep shadow, body low, watching two Obsidian Protocol enforcers on patrol below, one holding a flashlight. The scene communicates tension, patience, and tactical opportunity. Unreal Engine 5 Lumen global illumination, volumetric cold air haze, photorealistic ice and concrete materials, deep crushed blacks with cold white and amber lighting contrast. Cinematic wide 2.39:1 style composition within the panel.

---

**PANEL 4 - BOTTOM RIGHT - Label: "ACTION SET PIECE: OBSIDIAN PROTOCOL FREIGHT DEPOT - COLLAPSED BRIDGE CANYON"**

Wide cinematic action shot of a high-octane firefight environment. A sprawling open-air industrial freight depot at the edge of a sheer cliff canyon at dusk, with a collapsed suspension bridge dangling over the chasm below. Shipping containers and heavy crane equipment provide cover geometry. Rogue Viper is captured mid-movement in a dynamic gunfight pose - body low, both suppressed pistols raised and firing, muzzle flashes illuminating her face with sharp white light. Three Obsidian Protocol enforcers are positioned around her - one diving behind a container, one firing from atop a crane platform, one falling backward off the edge of the depot platform. Background: deep canyon with a river of orange reflected sunset light far below, dust and smoke rising from the firefight, a military helicopter approaching in the far distance. Warm dusk amber and cool canyon shadow blue provide dramatic color contrast. UE5 ray-traced reflections on metal container surfaces, particle systems for dust and muzzle smoke, cinematic depth of field on background elements.

---

**SHEET FOOTER** - Color palette chip row along the bottom of the sheet: matte black #1A1A1A, dark charcoal #2B2B2B, viper gold #D4AF37, gunmetal #3E3E3E, obsidian crimson #8B1A1A, slate gray #6B7280, cold white #E8EEF4. Label above chips: **COLOR PALETTE**. Footer text beneath: **ACTION / STEALTH - THIRD PERSON - UNREAL ENGINE 5 - © ROGUE VIPER GAME STUDIOS**

---

**UNIVERSAL STYLE CONSTRAINTS - APPLY TO ALL PANELS:**
Photorealistic only throughout the entire sheet. No anime, no cartoon, no stylized illustration, no cel shading, no comic book rendering. Unreal Engine 5 cinematic render quality with physically-based materials. Anamorphic lens character on all environment shots. Crushed blacks and desaturated mid-tones across all panels. Professional AAA game studio concept documentation format comparable to Naughty Dog, Ubisoft, or Guerrilla Games internal production art.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 473, '@KimAkiyama81', 'https://x.com/KimAkiyama81/status/2059394334378566063', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-473', '/images/case473.jpg', 'Rogue Viper - Video Game Concept Art Sheet', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-472', 'A Candid Photograph of a Young Woman Standing', 'Template imported from awesome-gpt-image-2 case 472. Source: @ToroJushiAi.', 'Photography & Realism', 'A candid photograph of a young woman standing on a Shanghai metro platform during the summer morning commute, authentic daily life photography, natural candid moment. Half-body framing, shot at eye level from moderate distance - the arriving train a motion-blurred streak behind her, the yellow safety line at her feet.
East Asian young woman in her early 20s. Almond-shaped eyes with natural double eyelids, slightly elongated eye corners - eyes directed downward, absorbed. Straight refined nose with a delicate bridge. Skin tone fair to light beige (NC10-NC20) - skin subsurface scattering visible under cool overhead station light, specular micro-highlights on cheekbones and nose ridge, fine foundation powder grain perceptible. Summer fresh look, no heavy coverage, lightly tinted lip.
She wears a relaxed oversized white shirt dress, collar lightly open, sleeves loosely rolled above the elbow. A structured natural tan canvas tote hangs from her shoulder, a physical novel tucked under one arm - pages open at a saved page. She stands with her weight on one hip, gaze downward at the open book, entirely absorbed, occupying her own stillness inside the morning rush. Background: white and grey tiled metro wall, overhead route signage board, arriving train motion blur to one side, other commuters blurred and distant. Two or three stray hairs displaced by the train''s air displacement on arrival, natural unplanned imperfection, not geometrically symmetrical.
Cool overhead fluorescent lighting with a slight greenish cast, flat frontal illumination offset by a warm spill from the platform entrance behind. Absorbed in focus, eyes downward, unaware - a private moment inside a public space, the Shanghai morning. Subtle ISO 400 film grain in shadow areas, photographic noise texture not CG render smoothness. Aspect ratio 2:3. No watermark, no text overlay, not cartoon, not digitally painted, not illustration, not anime.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 472, '@ToroJushiAi', 'https://x.com/ToroJushiAi/status/2059452471127240959', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-472', '/images/case472.jpg', 'A Candid Photograph of a Young Woman Standing', '["Poster","Realistic","Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-471', 'Ultra-detailed Anime-style Portrait of a Young Girl with', 'Template imported from awesome-gpt-image-2 case 471. Source: @Mind_Boticni.', 'Illustration & Art', 'Ultra-detailed anime-style portrait of a young girl with large expressive eyes, soft blush cheeks, and delicate facial features. She wears a vibrant floral kimono with intricate colorful patterns. Large blooming flowers are placed in her hair like accessories. Smooth gradient warm background in coral and peach tones. Soft cinematic lighting, dreamy atmosphere, high-end digital illustration', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 471, '@Mind_Boticni', 'https://x.com/Mind_Boticni/status/2059133066694779343', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-471', '/images/case471.jpg', 'Ultra-detailed Anime-style Portrait of a Young Girl with', '["Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-470', '/: / , : : : :1 2', 'Template imported from awesome-gpt-image-2 case 470. Source: @MrLarus.', 'Products & E-commerce', '《餐饮异形展架/立牌物料》提示词：

请生成一张高完成度的「餐饮异形展架 / 立牌」设计图，用于展示餐饮门店的新品推荐、招牌产品、套餐促销或品牌活动信息。

【基础信息】
品牌名：【品牌名】
主标题：【主标题】
副标题：【副标题】
辅助短句：【短句1】｜【短句2】｜【短句3】
主题方向：【主题方向，例如：爆辣夜市风 / 金黄浓郁风 / 清新轻食风 / 山野自然风 / 甜品下午茶风 / 快餐促销风】
主色调：【主色调】
辅助色：【辅助色】
点缀色：【点缀色】
画幅比例：【建议 3:4 竖版】

【产品内容】
主推产品：【主推产品】
辅助产品1：【辅助产品1】
辅助产品2：【辅助产品2】
辅助产品3：【辅助产品3】
辅助产品4：【辅助产品4】
加料 / 配角产品：【加料或配角产品，例如：饮品 / 小食 / 配菜 / 酱料 / 甜品】

【卖点标签】
【卖点1】
【卖点2】
【卖点3】
【卖点4】
【卖点5】
【卖点6】

【促销信息】
【促销信息1】
【促销信息2】
【促销信息3】

【最重要要求】
避免生成门店场景效果图或墙上海报展示图。请直接生成"一张完整的异形立牌成品展示图"：
- 背景必须为纯白色
- 画面中只保留一个完整的异形餐饮立牌主体
- 不要餐厅环境
- 不要商场背景
- 不要玻璃门、桌椅、墙面、人物、地面透视场景
- 不要任何真实空间背景
- 立牌主体必须完整显示
- 异形轮廓必须完整清晰
- 底座必须完整露出
- 整体像一张已经抠好的门店物料成品图 / 设计提案展示图 / 电商展示图

【画面形式】
这是一张"门店异形展架 / 立牌"的完整设计，避免普通矩形海报处理。
整体应采用明显的"不规则异形裁切轮廓"，有完整外边缘，边缘可带白色或浅色描边，具有真实门店物料感。
立牌应有明确底座，整体像可落地摆放的 KT 板 / 泡沫板 / 亚克力 / 写真喷绘展架成品。

【构图结构】
整体采用竖版、中心聚焦、信息分层清楚的结构：

1. 顶部区域：
放超大主标题，标题必须醒目、有冲击力、有餐饮 POP 招贴感。
字体可以厚重、手写感、招贴感、潮流感，但要清晰易读。
标题是整张图的第一视觉焦点。

2. 中部核心区域：
中间放最大主推产品，作为主视觉主体。
主菜必须最大、最饱满、最诱人，突出食欲感。
围绕主菜搭配 2~5 个辅助产品，形成丰富的产品组合，前后层次明确，主次分明。

3. 周边信息区域：
在主菜和辅助产品四周加入少量标签元素、推荐标、贴纸框、手写箭头、卖点说明、小标题、小气泡标签等，使其具有"餐饮门店促销物料"的视觉特征。
但要控制层级，做到"热闹但不乱"。

4. 底部促销区域：
底部放价格信息、套餐信息、活动信息或新品尝鲜信息。
价格数字要相对突出，易读清晰。
如果没有特别要求，默认不要二维码。

【视觉风格要求】
整体风格应属于"餐饮转化型视觉 + 门店 POP 异形立牌"：
- 强调食欲感
- 强调信息可读性
- 强调商业落地感
- 强调门店物料感
- 强调异形轮廓感

避免极简杂志海报、电商详情页、纯平面插画海报方向。

【食物表现要求】
所有食物必须采用真实商业美食摄影质感：
- 食物清晰真实
- 有食材颗粒感
- 有酱汁、汤汁、油光、热气、层次感
- 有丰富细节，如葱花、辣椒、芝士、香草、蔬菜、水果、虾仁、肉块等
- 主食要饱满，不能扁平
- 看起来必须"能激发食欲"
禁止过度插画化、卡通化、低质拼贴化。

【版式与信息层级】
整张立牌的阅读顺序应为：
主标题 → 主推产品 → 辅助产品 → 卖点标签 → 价格 / 活动信息

信息量可以较丰富，但必须有明确层级：
- 主标题最大
- 主菜次大
- 辅助菜稍小
- 卖点标签较小
- 底部促销清晰醒目

【适配范围】
该模板需要适用于不同主题餐饮内容，例如：
- 面 / 饭 / 粉 / 小吃
- 火锅 / 菌汤 / 地方菜
- 轻食 / 沙拉 / 咖啡简餐
- 早餐 / 套餐 / 快餐
- 茶饮 / 甜品 / 下午茶
- 节日促销 / 新品上市 / 爆品推荐 / 双人套餐

【输出要求】
请输出一张高清、清晰、商业完成度高的异形立牌设计图，满足以下条件：
- 白色背景
- 完整异形轮廓
- 完整底座
- 只展示立牌本体
- 不带真实场景环境
- 不带人物
- 不带门店背景
- 默认不带二维码
- 适合用于系列案例展示、设计提案、社交媒体发布、模板复用', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 470, '@MrLarus', 'https://x.com/MrLarus/status/2059248197910827364', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-470', '/images/case470.jpg', '/: / , : : : :1 2', '["Poster","Realistic","Illustration"]'::jsonb, '["Commerce","Fashion","Food"]'::jsonb, FALSE, TRUE),
    ('case-469', ': + + Ip + + ,: -', 'Template imported from awesome-gpt-image-2 case 469. Source: @MrLarus.', 'Charts & Infographics', '《导览式科普绘本》提示词：

请根据【主题】创作一张高完成度的「导览式科普绘本」风格插画。

这是一张结合"大型场景主视觉 + 导览路线 + 可爱导览 IP + 知识站点 + 儿童科普绘本质感"的场景导览式科普图解页。画面需要让观者像被带着参观一个复杂系统一样，边看边理解主题背后的运行逻辑、空间结构、流程关系和关键知识点。

【基础设定】
主题：【填写主题，例如发射场的一天 / 一个集装箱的旅行 / 地铁站里的秘密路线 / 下潜到深海的一小时 / 机场如何运转 / 医院急诊系统 / 智慧农场 / 消防站出警流程】
画幅比例：【4:3 横版】
主色调：【根据主题自动匹配，整体保持明亮、清爽、儿童友好】
风格方向：【现代儿童科普绘本 / 场景导览式图解 / 高完成度数字插画】

【核心表达】
请围绕【主题】设计一个完整的大型场景或复杂系统。画面中必须有一个明确的主视觉场景，例如大型设施、交通系统、科技装备、自然探索场景、城市公共系统或生产流程。主体要足够清晰、有规模感、有细节，能够成为第一眼的视觉中心。

画面要通过"导览路线"的方式组织信息，避免仅把场景做成静态陈列。请设计一条清晰的参观路线、流程路线、时间线或空间动线，让读者可以沿着路线一步步理解这个系统是如何运行的。

【导览 IP 设计】
请为本图设计一个原创、可爱、亲和的导览小 IP。导览 IP 可以是小动物、小朋友、拟人化工具或其他适合主题的原创形象，但必须具有独立原创性，不要照搬任何参考图中的角色、动物形象、服装、配色或搭档关系。

导览 IP 的作用是：
1. 开场介绍主题
2. 指向关键知识点
3. 引导读者顺着路线阅读
4. 增加儿童绘本的陪伴感和趣味性

导览 IP 可以在画面中出现 2-3 次，但不要过度抢主视觉。角色应圆润、可爱、有表情、有动作，适合儿童科普绘本。

【信息结构】
画面中请设置 3-6 个"知识站点"，每个站点用简短中文标签和短说明表达。站点命名可以采用：
- 第1站｜xxx
- 第2站｜xxx
- 重点观察｜xxx
- 小知识｜xxx
- 为什么｜xxx
- 如何工作｜xxx

每个知识点都要围绕主题的核心运行逻辑展开，不要写空泛说明。文字要短、清楚、自然，避免长段落，适合儿童阅读。

【画面模块】
整张图建议包含以下模块：
1. 顶部主标题区：清楚写出主题名称
2. 开场导览区：导览 IP 引出主题
3. 大型主场景区：展示主题系统的完整场景
4. 导览路线区：用箭头、虚线、路径、时间节点或流程线串联知识点
5. 知识站点区：用小信息框、导览牌、局部标注展示关键知识
6. 小百科 / 小贴士区：补充一个有趣知识
7. 收尾区：让导览 IP 做简短总结或引导

【构图要求】
画面采用 4:3 横版构图，整体像一本高质量儿童科普绘本的跨页，也像一张儿童科技馆导览图。画面需要有清晰的视觉重心：大型主场景占据主要空间，导览路线贯穿画面，知识模块自然分布在周围。信息丰富但不能杂乱，阅读路径要顺畅。

【视觉风格】
整体采用现代儿童科普绘本风格：
- 明亮、清爽、干净的色彩
- 清晰自然的手绘线条
- 高完成度数字插画质感
- 细节丰富但有秩序
- 可爱但不低幼
- 有科普图解感
- 有导览地图感
- 场景真实可信，但表达方式亲和

【文字与标注】
文字以中文为主，使用短标题、短标签、简短说明。不要生成大段复杂文字。信息框应像儿童科普书中的导览牌、知识卡片或小贴士。文字要尽量清晰、简洁、可读。

【最终目标】
让整张图像一页高质量的儿童科普绘本：孩子第一眼被可爱角色和大场景吸引，第二眼能顺着路线读懂系统如何运行，第三眼还能继续发现细节和知识点。画面要具有系列化潜力，方便后续替换不同主题继续创作同类型图片。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 469, '@MrLarus', 'https://x.com/MrLarus/status/2058773446167773521', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-469', '/images/case469.jpg', ': + + Ip + + ,: -', '["Infographic","Illustration","Character"]'::jsonb, '["Education","Travel","Story"]'::jsonb, FALSE, TRUE),
    ('case-468', ',9:16, 20,,,,,, ,,,,s,,,,,, ,, Marker Doodle Graphics ,,', 'Template imported from awesome-gpt-image-2 case 468. Source: @drmrzhong.', 'Photography & Realism', '生成一张写实感合照，9:16构图，真实手机摄影质感。

画面中是一位20岁成年东方女性模特，站在室内展会现场，靠近镜头自然拍照。人物妆造精致，五官清秀，皮肤清透，眼神自然看向镜头，整体气质甜美。

人物姿态自然端正，身体略微前倾，肩颈柔和舒展，腰部自然收束，整体体态呈现成熟柔美的女性S型曲线。人物体态为成熟丰腴型，肩部圆润柔和，胸部饱满自然，腰线清晰但不过度纤细，臀腿曲线圆润匀称，大腿与手臂带有柔软健康的肉感，整体呈现温柔、甜美、丰腴、优雅的女性美。

人物服装为"霓虹手绘线条构成的艺术涂鸦"，笔触故意粗糙随意，带明显蜡笔与 marker 手绘质感。画面中的 doodle graphics 形成若隐若现的视觉错觉感，突出身体线条和优美轮廓，让人物看起来像穿着由霓虹线条构成的 cosplay outfit，避免呈现为真实布料服装。整体偏日本互联网自拍文化中的 playful sticker aesthetic，避免直白裸露风格。

人物发型为精致古风高马尾，搭配白色花朵头饰、水晶发簪、流苏耳饰、额间水晶装饰。妆容清透，带有淡粉色眼影、自然腮红和柔和唇色。

场景为大型室内展会现场，背景有人群和展台但轻微虚化，顶部有真实展馆灯光。画面采用近景合照构图，人物面部和服装细节清晰，背景虚化自然，有真实手机自拍感。

整体风格：写实、清透、明亮、梦幻。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 468, '@drmrzhong', 'https://x.com/drmrzhong/status/2058774378960257437', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-468', '/images/case468.jpg', ',9:16, 20,,,,,, ,,,,s,,,,,, ,, Marker Doodle Graphics ,,', '["Realistic","Character","Classical"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-467', 'Case 467 Photography and Realism Template', 'Template imported from awesome-gpt-image-2 case 467. Source: @Adam38363368936.', 'Photography & Realism', '泳装时尚杂志广告页面，日本成熟模特，S型曲线。变换姿势和风格，九宫格展示，保持人物面部一致性', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 467, '@Adam38363368936', 'https://x.com/Adam38363368936/status/2058859338211656051', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-467', '/images/case467.jpg', 'Case 467 Photography and Realism Template', '["Character"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-466', 'Use the Uploaded Reference Image as the Exact', 'Template imported from awesome-gpt-image-2 case 466. Source: @mehvishs25.', 'Photography & Realism', 'Use the uploaded reference image as the exact identity base for the main subject. Preserve their authentic facial structure, recognizable appearance, hairstyle, body proportions, skin texture, and overall identity with high consistency. Completely ignore any unrelated background from the original image.

Create a hyper-chaotic early-2000s Japanese digicam snapshot aesthetic with raw paparazzi energy and accidental comedy.

Scene: the subject is sprinting wildly through a busy city street while yelling and laughing in pure chaos, desperately trying to catch a mischievous cat that just stole a large shiny fish from a market stall. The cat is gripping the slippery silver fish tightly in its mouth while running directly toward the camera.

Composition must prioritize TWO focal subjects:

1. PRIMARY FOCUS → the cat''s face
2. SECONDARY FOCUS → the human subject''s face

The cat dominates the foreground frame with its face pushed absurdly close into the lens, partially cropped near the lower-right side. Massive fisheye distortion stretches its features dramatically - huge bulging eyes, exaggerated whiskers, detailed fur texture, fish flapping violently with droplets and motion streaks flying outward.

Behind the cat, the subject is charging forward aggressively with intense energy, reaching toward the animal mid-run. Their expression is loud, chaotic, and comedic, eyes locked directly onto the cat to create strong interaction and pursuit tension.

Styling:
Randomized layered Y2K Tokyo streetwear inspired by chaotic Shibuya nightlife fashion - oversized zip hoodies, vintage mesh layers, mini bags, low-rise pieces, striped arm warmers, chunky accessories, early-2000s sneaker styling, messy fashionable youth aesthetic.

Camera & framing:
extreme low-angle fisheye lens, ultra-wide invasive perspective, severe Dutch angle, asymmetrical framing, warped spatial distortion, exaggerated depth compression, aggressive foreshortening.

Motion treatment:
insanely intense movement blur with radial streaking, shutter drag, CCD sensor smearing, directional speed trails, accidental camera shake, stretched highlights, warped moving objects, imperfect chaotic snapshot timing.

Environment:
sunny crowded urban street with pigeons exploding into flight across the frame, scattered newspapers and debris flying through the air, warped pedestrians, market elements smeared by motion, overexposed sunlight leaking into one corner of the frame.

Lighting & texture:
harsh direct flash combined with bright outdoor sunlight, dirty CCD digicam texture, blown highlights, chromatic aberration, digital noise, bloom artifacts, compressed early-2000s camera look, gritty nostalgic cyber-chaos atmosphere.

Ultra-raw candid energy, messy composition, humorous accidental masterpiece aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 466, '@mehvishs25', 'https://x.com/mehvishs25/status/2058375167550845263', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-466', '/images/case466.jpg', 'Use the Uploaded Reference Image as the Exact', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-465', ': , : + + + ,', 'Template imported from awesome-gpt-image-2 case 465. Source: @MrLarus.', 'Photography & Realism', '逆光美背女性情绪写真提示词：

请生成一张竖版高质感女性情绪写真，主题为「逆光美背·女性情绪写真」。

核心要求：
画面的绝对重点是"美背"，通过露背结构、肩颈线条、肩胛骨、脊柱中线、腰背曲线和逆光轮廓来呈现女性美。请避免普通女性写真或普通穿搭图的处理方式，背部必须是主视觉核心，脸只作为辅助。

人物设定：
成年女性，真实自然，气质可为温柔、清冷、慵懒、文艺、轻熟或安静。人物不要网红脸，不要塑料感，不要夸张妆容。可侧脸、回眸、低头或闭眼，但正脸不是重点。

姿态要求：
姿态必须服务于背部展示，例如背对镜头微微回头、侧身站立、侧坐、抬手整理头发、低头蜷身、斜倚窗边、半躺回眸、披衣下滑等。动作自然，不要僵硬摆拍，不要正面直视镜头。

露背结构：
必须有明确的露背设计，可为低背长裙、吊带裙、露背礼服、针织外套滑落、薄纱披肩、浴袍半披、宽松衬衫滑肩、丝质罩衫半落等。重点表现肩线、肩胛骨、背中线、腰背收束和布料与肌肤之间的高级过渡。

服装与材质：
服装选择轻柔、垂坠、带有透光感和褶皱感的材质，如薄纱、真丝、针织、棉麻、细闪纱、浴袍质地、软垂感长裙。布料要参与构图，形成半遮半露、滑落、包裹、垂挂的层次，但不能厚重。

场景：
场景为卧室、窗边、床上、白墙房间、民宿、酒店房间、木质空间或复古公寓。背景简洁克制，少量床品、窗帘、木椅、花束、地板等元素即可，不能喧宾夺主。

光线要求：
采用自然光或柔和暖光，以逆光、侧逆光、窗边光为主。重点是让光打到背部，勾出肩颈边缘、肩胛骨轮廓、腰线和发丝高光。可使用晨光、黄昏金光、柔雾散射光或冷白窗光，但背部受光状态必须成立。

构图：
竖版构图，画幅可为 9:16、3:4 或 4:5。人物是绝对主角，视觉重心放在背部、肩颈和腰背曲线上。可采用半身、七分身、近景或全身，但不要让场景抢走主体。

氛围：
整体氛围安静、柔软、私密、克制、高级，像真实摄影师拍摄的电影感情绪写真。重点避免直白性感，改用"美背 + 逆光 + 柔软布料 + 自然姿态"表达女性美。

画质要求：
真实摄影感、电影感、柔雾胶片感、细腻肤色、真实皮肤质感、浅景深、轻微颗粒感、画面通透自然。不要 AI 塑料感，不要 CG 感，不要错误手指，不要肢体畸形，不要低俗色情化表达，不要文字、水印、Logo、边框。

最终效果：
一张以"美背"为主视觉核心的高完成度女性情绪写真，通过露背结构、肩颈背部线条、柔光逆光和柔软布料来呈现克制而高级的女性美。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 465, '@MrLarus', 'https://x.com/MrLarus/status/2058131948904599860', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-465', '/images/case465.jpg', ': , : + + + ,', '["Realistic","Brand","Character"]'::jsonb, '["Tech","Fashion","Story"]'::jsonb, FALSE, TRUE),
    ('case-464', 'Watercolor and Collage Travel Poster for Kaohsiung, Taiwan,', 'Template imported from awesome-gpt-image-2 case 464. Source: @SimplyAnnisa.', 'Posters & Typography', 'Watercolor and collage travel poster for Kaohsiung, Taiwan, vertical layout, soft pastel and warm golden hour color palette.

Scene: Waterfront promenade at sunset with a modern light rail tram on the right, a person walking a bicycle on the left, and people strolling along the path. In the background: Kaohsiung skyline with the 85 Sky Tower and other skyscrapers, a harbor with a ferry boat, port cranes, and the Pier-2 Art Center building with murals. Seagulls flying in the sky, trees lining the walkway, calm water reflecting the light.

Design elements:
- Large text top left: ''KAO HSIUNG 2026'', smaller text below ''Sea Breeze Slow Light Southern City''
- Top right: Vertical Chinese characters, ''KAOHSIUNG TAIWAN'' in small caps below
- Bottom left: Coordinates ''22.6273° N 120.3014° E'', ''KAOHSIUNG TAIWAN'', wave icon
- Bottom center: Handwritten script ''Kaohsiung''
- Bottom right: Vertical list ''Harbor Art Light Rail People Slow Life'', vertical Chinese text
- Overlay effects: Semi-transparent geometric shapes, watercolor splashes, and texture layers in teal and beige

Style: Modern travel poster meets watercolor painting, airy and atmospheric, blend of illustration and photo-collage, warm and tranquil mood, high detail.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 464, '@SimplyAnnisa', 'https://x.com/SimplyAnnisa/status/2058372965641662876', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-464', '/images/case464.jpg', 'Watercolor and Collage Travel Poster for Kaohsiung, Taiwan,', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-463', ': / , 8 - - - /', 'Template imported from awesome-gpt-image-2 case 463. Source: @MrLarus.', 'Charts & Infographics', '《黑色丝袜图鉴款式单图》提示词：

请基于同一套「黑色丝袜 / 吊带袜图鉴」系列风格，继续生成 8 张对应单款的独立展示图。

【系列要求】
- 这些图片必须和已完成的总览图鉴属于同一个系列
- 整体版式、字体、色调、背景、质感、排版逻辑保持一致
- 都是竖版、高完成度、暖白 / 浅灰白背景、轻奢女性向时尚图鉴风格
- 每一张都像同一个品牌或同一套视觉系统下的延展页面

【每张单图的共同结构】
1. 顶部标题区
- 英文系列标题：BLACK GARTER GUIDE
- 中文主标题：黑色丝袜 / 吊带袜单款展示
- 当前款式名称：__________
- 一句简短副标题：突出该款式的核心特点

2. 中部主体区
- 以 1 位成人女性模特穿戴展示为主
- 重点展示对应款式的关键细节：
  - 经典蕾丝款：袜口蕾丝、优雅氛围
  - 细网眼款：网格纹理、轻盈通透
  - 波点款：波点图案、复古俏皮
  - 后缝线款：背后缝线、线条感
  - 竖条纹款：纵向条纹、修饰腿型
  - 交叉绑带款：绑带结构、设计感
  - 极简透肤款：透明感、基础百搭
  - 花纹蕾丝款：花纹装饰、浪漫氛围
- 每张图的人物长相、发型、姿势、镜头角度要不同，但都要保持高级、真实、性感、写实
- 允许使用站姿、坐姿、交叉腿、倚靠、回眸等不同姿势
- 画面要有立体感、阴影层次和高级编辑感

3. 注释区
- 每张图都要保留 3 到 5 条手绘式标注
- 可以使用箭头、短线、圈注、手写风标签
- 标注内容要围绕该款式最关键的细节，比如：
  - 袜口结构
  - 花纹纹理
  - 透明度
  - 缝线位置
  - 绑带方式
  - 腿部线条效果
- 标注文字简洁、清楚、统一风格

4. 底部信息区
- 加入简短的 "Style Notes / 风格速记"
- 用 1 到 2 句说明该款适合的场景和氛围
- 保持简洁，不要抢主体

【统一视觉要求】
- 保持和总览图鉴完全统一的整体视觉系统
- 背景统一为暖白、浅灰白或奶白
- 风格统一为高级、干净、时尚图鉴感、轻奢女性视觉
- 模特必须真实、立体、写实、自然肤质
- 每张图都要突出产品，不要低俗，不要过度情色化
- 每张图都应像同一系列里的不同章节，避免呈现为彼此割裂的作品

【款式列表】
1. 经典蕾丝款 / Classic Lace
2. 细网眼款 / Fine Fishnet
3. 波点款 / Dot Sheer
4. 后缝线款 / Back Seam
5. 竖条纹款 / Stripe Sheer
6. 交叉绑带款 / Cross Strap
7. 极简透肤款 / Minimal Sheer
8. 花纹蕾丝袜 / Floral Lace

【输出目标】
按以上 8 个款式，分别生成 8 张独立展示图。
要求每张都保留统一系列感，同时人物造型、发型、姿势和镜头语言明显不同，确保整套看起来完整、专业、可收藏。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 463, '@MrLarus', 'https://x.com/MrLarus/status/2058175014168396245', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-463', '/images/case463.jpg', ': / , 8 - - - /', '["UI","Realistic","Brand"]'::jsonb, '["Education","Story"]'::jsonb, FALSE, TRUE),
    ('case-462', 'Strict : : 100 : - - -', 'Template imported from awesome-gpt-image-2 case 462. Source: @ZetoGroovin.', 'Products & E-commerce', '添付されたキャラクターシートをSTRICTなデザインリファレンスとして使用すること。 キャラクターの顔、髪型、目の形、プロポーションは絶対に変更しない。

■目的： キャラクターを日本の「ちび消しゴム商品」として完全に商品化し、 実際に文房具売り場やガチャで販売されているようなリアルなパッケージ商品写真を作成する。

■コンセプト： 「100円ショップや文房具店で売られている袋入りちび消しゴム商品」

■消しゴム本体： （※前回と同じ仕様を完全維持） - 強いデフォルメちびキャラ - 厚みのあるブロック形状 - 完全マットなラバー素材 - 微細な粒子・粉・削れ・摩耗あり - 印刷ズレ・色ブレあり - 50個以上のランダム構成

■パッケージ（超重要）： - 小さな透明ビニール袋（OPP袋） - 上部に紙ヘッダー（吊り下げ用の穴あり） - ヘッダーはややチープな印刷（軽いズレ・インクのムラ） - ビニールはシワあり、やや曇り、静電気で中身に張り付く - 一部空気が入ってふくらみあり - シール部分に軽いヨレ

■グラフィックデザイン： - 日本の子供向け文房具風デザイン - ポップでカラフル（ピンク・黄色・水色ベース） - 手書き風フォントや丸文字 - 商品名ロゴ（オリジナルでOK） - 「ミニけし」「ちびけし」などの表記 - 星・ハート・キラキラ装飾

■情報要素（リアル感強化）： - JANコード（バーコード） - 「対象年齢6才以上」 - 「食べられません」注意書き - 「全◯種」や「ランダム封入」 - 小さな会社名（架空） - MADE IN JAPAN or CHINA表記

■構図： - パッケージがメインで画面中央 - 周囲に少しだけこぼれた消しゴム - 1〜2個は袋から出ている - 指先が1つをつまもうとしている演出 - 一部フレームアウトで自然さ

■レア要素： - 蛍光カラーやグラデーションの特別個体を1つ混ぜる - 視線誘導として目立つ位置に配置

■ライティング： - 明るい自然光（ややハイキー） - 柔らかい影 - 商品写真のような清潔感

■カメラ： - マクロ寄り - 浅い被写界深度 - 中央シャープ

■背景： - 白〜パステルのテーブル - ほんのりドットやポップ柄 - シンプルで清潔

■禁止： - プラスチック感 - glossy表現 - 高級すぎる質感（安っぽさが正解） - 完璧すぎる印刷

■出力： - 実在する商品にしか見えないレベル - コンビニや100均にありそうなリアリティ - SNSで「これ欲しい」と思わせる完成度', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 462, '@ZetoGroovin', 'https://x.com/ZetoGroovin/status/2058408514247410003', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-462', '/images/case462.jpg', 'Strict : : 100 : - - -', '["Realistic","Product"]'::jsonb, '["Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-461', 'Adorable Kawaii Family Travel Collage, Combining Four Different', 'Template imported from awesome-gpt-image-2 case 461. Source: @Taaruk_.', 'Illustration & Art', 'Adorable kawaii family travel collage, combining four different scenes in one composition, cute anime-inspired parents, friends and children taking selfies and exploring together, handcrafted paper-cut diorama style, layered cardboard and felt textures, miniature world aesthetic, cozy pastel color palette, soft cinematic lighting, playful vacation atmosphere, urban city station scene, shopping mall selfie corner, outdoor nature park, and crowded playground blended into one seamless scrapbook-style artwork, charming sticker-like white outlines around characters, tiny tourists and pedestrians in background, whimsical handcrafted textures, soft depth of field, highly detailed paper craft illustration, warm nostalgic mood, cute casual outfits with glasses, caps, bags and sandals, dreamy Instagram kawaii aesthetic, storybook composition, ultra detailed miniature environment, 3D layered paper art, tilt-shift effect, cozy wholesome family travel vibes, premium handcrafted look, high detail, 8k, vertical composition', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 461, '@Taaruk_', 'https://x.com/Taaruk_/status/2058400056722731079', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-461', '/images/case461.jpg', 'Adorable Kawaii Family Travel Collage, Combining Four Different', '["Illustration","Character","3D"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-460', 'Ultra-realistic Luxury Fashion Campaign Poster Shot from a', 'Template imported from awesome-gpt-image-2 case 460. Source: @harboriis.', 'Posters & Typography', 'Ultra-realistic luxury fashion campaign poster shot from a dramatic low-angle perspective across a glossy chessboard table. A stylish young male model with sharp facial features, textured curly hair, wearing thin luxury glasses and a fitted sleeveless knitted brown vest, leaning forward in a confident pose. One hand extended toward the camera holding a large white king chess piece in forced perspective, dominating the foreground. Tattooed arms visible, intense confident facial expression, direct eye contact. Elegant vintage royal interior background with dark paneled walls, warm chandelier wall lights, cinematic amber lighting, moody shadows, luxury editorial atmosphere. Chess pieces scattered on the board in foreground and background for depth. High contrast premium fashion advertising style, ultra-detailed skin texture, sharp focus on face and chess piece, shallow depth of field, glossy reflections on chessboard, dramatic commercial campaign photography, luxury menswear brand aesthetic. Bold typography at bottom saying "DRESSED TO DOMINATE", premium poster layout, cinematic color grading, high-end fashion ad, editorial magazine quality, 4:5 aspect ratio.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 460, '@harboriis', 'https://x.com/harboriis/status/2058414859658956888', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-460', '/images/case460.jpg', 'Ultra-realistic Luxury Fashion Campaign Poster Shot from a', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-459', 'Kv ,logo, Kv : - Kv - Brand-inspired', 'Template imported from awesome-gpt-image-2 case 459. Source: @liyue_ai.', 'Brand & Logos', '你是一个品牌视觉识别系统、商业广告创意总监、KV海报设计师和高传播品牌视觉生成系统。

请根据用户输入的【现有品牌名称】，自动识别该品牌最具代表性的品牌Logo形象、品牌名称文字识别特征、主推产品、产品包装、品牌色彩、视觉调性、目标人群和广告传播风格，并生成一张符合该品牌气质的概念 KV 海报。

创作定位：
- 基于真实品牌认知进行二次创作的品牌概念 KV 海报
- Brand-inspired Concept Key Visual
- 用于个人学习、视觉练习与社交平台展示

不需要绝对严苛的一比一官方复刻，但必须做到：

品牌识别度高；
品牌Logo风格明显；
品牌代表产品明显；
品牌调性准确；
整体像该品牌会出现的视觉广告。

────────────────
一、用户输入
────────────────

品牌名称：{品牌名称}

主推产品：{可选，不填则自动识别该品牌最具代表性的产品}
广告语：{可选，不填则根据品牌调性自动生成原创广告语}
目标人群：{可选，不填则自动判断}
画幅比例：{9:16 / 16:9 / 4:5 / 1:1 / 2.35:1}
KV类型：{产品英雄KV / 品牌情绪KV / 强口号传播KV / 人物场景KV / 超现实概念KV / 自动选择}
平台用途：{小红书 / X / 公众号封面 / 视觉练习 / 概念提案}

────────────────
二、自动识别逻辑
────────────────

请根据品牌名称自动完成以下识别，不需要在画面中展示分析过程：

1. 自动识别该品牌所属行业
例如：
科技、运动、美妆、奢侈品、汽车、饮品、咖啡、服饰、潮流、护肤、珠宝、生活方式、数码、家居等。

2. 自动识别该品牌最具代表性的视觉资产
包括：
品牌Logo形象
品牌名称文字风格
主色调与辅助色
最具代表性的产品
包装外观特征
品牌常见广告风格
品牌场景气质
品牌材质感与光影方式

3. 自动识别该品牌的目标人群
例如：
年轻潮流人群、都市白领、精致女性、运动人群、科技用户、高端消费人群、Z世代、商务人群等。

4. 自动识别该品牌的广告语气质
例如：
极简高级、年轻活力、热血冲击、奢华克制、温柔浪漫、科技理性、时尚先锋、生活方式化等。

────────────────
三、Logo与产品识别规则
────────────────

本次任务允许 AI 根据品牌名称自动识别品牌视觉资产，不需要用户必须上传 Logo 或产品图。

请遵守以下原则：

1. 品牌Logo
- 画面中需要有明显的品牌标识
- Logo 或品牌名称文字要具有较高识别度
- 不必追求百分之百精确复刻，但必须让人一眼联想到该品牌
- 不要生成完全陌生、无关、错误感很强的标识
- 不要让品牌名称出现明显错字、乱码或胡乱变形

2. 品牌产品
- 自动选择该品牌最具代表性的主推产品或经典产品作为主视觉
- 产品外观、包装、色彩和气质应接近大众对该品牌的常见认知
- 不需要绝对严格到工业级复刻
- 但要保证"像这个品牌的真实代表产品"，避免完全陌生的产品

3. 品牌包装与材质
- 自动识别该品牌常见包装与材质语言
- 如金属、玻璃、磨砂、塑料、皮革、纸盒、极简包装、奢华包装、运动感材质等
- 产品必须具有真实商业视觉质感

────────────────
四、KV创意方向
────────────────

请根据品牌属性自动选择最合适的 KV 创意方式。

如果是科技品牌：
使用极简、未来感、真实产品质感、冷静留白、克制光影、干净空间。

如果是运动品牌：
使用速度感、力量感、身体动势、汗水、冲刺、突破、强烈口号感。

如果是美妆品牌：
使用柔光、精致产品、肌肤质感、女性气质、色彩情绪、时尚大片感。

如果是奢侈品牌：
使用高级材质、留白、低饱和色调、秩序构图、稀缺感、时尚大片感。

如果是饮品品牌：
使用冰爽、液体、气泡、年轻感、快乐氛围、色彩冲击、清爽材质。

如果是咖啡品牌：
使用温度、城市生活、松弛氛围、绿色或木质感、晨间陪伴感。

如果是汽车品牌：
使用道路、速度、未来空间、金属质感、城市夜景、驾驶欲望。

如果是潮流品牌：
使用街头、反叛、年轻、图形感、视觉冲击和社交传播感。

────────────────
五、广告语规则
────────────────

如果用户没有输入广告语，请根据品牌调性自动生成一句原创广告语。

要求：

- 广告语不能太长
- 要有品牌感和传播感
- 不使用官方原广告语
- 不需要像正式企业公告
- 更像概念广告的主标语

中文广告语建议：
4到12个字

英文广告语建议：
2到6个单词

广告语风格要与品牌匹配，例如：

科技品牌：
更少干扰，更近未来

运动品牌：
把极限踩在脚下

美妆品牌：
光泽，自成主张

奢侈品牌：
优雅，从不喧哗

饮品品牌：
这一口，刚好上头

咖啡品牌：
唤醒城市的温度

汽车品牌：
驶向更远的秩序

────────────────
六、画面结构要求
────────────────

整张图必须具备真实品牌 KV 的基本结构：

1. 品牌标识区
品牌Logo或品牌名称需要清晰可见，位置合理。

2. 产品主视觉区
品牌代表产品必须明显，是画面核心之一。

3. 广告语区
广告语清晰可读，具备传播记忆点。

4. 品牌氛围区
背景、光影、材质、空间和色彩必须符合品牌调性。

5. 信息层级区
画面层级建议为：
品牌标识
产品主体
广告语
少量辅助文字

文字不要太多，不要做成密密麻麻的海报。

────────────────
七、风格要求
────────────────

整体视觉必须具备：

高识别度品牌感
高级商业广告质感
清晰品牌标识
明显品牌产品
强主视觉
强广告语
干净排版
适合社交平台传播
适合小红书和X展示
具有"像某知名品牌概念广告"的完成度

允许适度创意发挥，但品牌核心识别不能丢失。

────────────────
八、画幅适配
────────────────

如果是 9:16：
适合竖版社交海报，产品更聚焦，广告语放中上区域，适合手机浏览。

如果是 16:9：
适合横版品牌KV、封面、头图，产品与广告语形成左右平衡。

如果是 4:5：
适合社交平台信息流，主体更近，品牌识别更集中。

如果是 2.35:1：
适合公众号封面或宽幅视觉，适合大字广告语和强冲击横版构图。

如果是 1:1：
适合方形封面与品牌视觉展示。

────────────────
九、负面限制
────────────────

不要生成明显错误的品牌名称。
不要生成过于离谱的Logo变形。
不要生成与品牌无关的产品。
不要生成廉价拼贴感。
不要生成过多小字。
不要生成杂乱无章的背景。
不要生成山寨感很强的画面。
不要生成像促销海报一样的低级电商视觉。
不要出现二维码、购买链接、价格标签、活动说明。
不要让整体画面失去品牌调性。

────────────────
十、最终目标
────────────────

请生成一张基于真实品牌认知自动识别完成的品牌概念 KV 海报。

要求：
无需用户上传 Logo 和产品素材；
由AI自动识别该品牌最具代表性的Logo形象与代表产品；
不要求绝对严格复刻；
但必须保持高识别度、高品牌感、高完成度；
整体像一张高级品牌概念广告海报；
适合个人学习、视觉练习和社交平台展示。

----
品牌名称：{蜜雪冰城}
主推产品：{奶茶}
广告语：{可选，如果用户不输入，则根据品牌调性自动生成一句高传播感广告语}
目标人群：{年轻潮流人群}
画幅比例：{9:16}
KV类型：{产品英雄KV}
平台用途：{小红书}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 459, '@liyue_ai', 'https://x.com/liyue_ai/status/2057739678485495885', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-459', '/images/case459.jpg', 'Kv ,logo, Kv : - Kv - Brand-inspired', '["Poster","Product","Brand"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-458', 'Full-body Fashion Illustration of a Young Woman Walking', 'Template imported from awesome-gpt-image-2 case 458. Source: @heyfatema.', 'Illustration & Art', 'Full-body fashion illustration of a young woman walking down a Parisian street in autumn, wearing a long camel wool coat draped open over a black ribbed turtleneck sweater and high-waisted wide-leg cream trousers, holding a quilted tan leather shoulder bag with interlocking CC logo and chain strap in her left hand while her right hand slides into a pocket, short dark brown wavy hair gently lifted by a breeze, pearl stud earrings, natural fresh makeup and a confident serene expression; cinematic shallow depth of field with soft warm golden-hour light, subtle bokeh on Haussmann-style buildings and slow-moving cars in the blurred background, scattered fallen leaves on the pavement; semi-realistic digital painting / fashion illustration style with clean linework, soft gradients, high-detail fabric textures and realistic folds, emphasis on elegant silhouettes and tactile materials, muted autumn palette (camel, cream, black, warm ochre), vertical composition, crisp foreground, gentle film grain and polished finishing.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 458, '@heyfatema', 'https://x.com/heyfatema/status/2057745100365787170', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-458', '/images/case458.jpg', 'Full-body Fashion Illustration of a Young Woman Walking', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-457', 'Instructions Input 3 Legendary Dancer/choreographer Input Ai Inferred', 'Template imported from awesome-gpt-image-2 case 457. Source: @Gdgtify.', 'Charts & Infographics', '<instructions>
input = 3 legendary dancer/choreographer
input = ai inferred signature movement sequence

function render_kinesphere ($ dancer, $ movement)
  anchor:
    [figure composed entirely of motion trails] :: [the $ movement sequence traced as continuous luminous bands that coalesce into a portrait of $ dancer]::5

  morphology:
    the arabesque trails weave the skull, a grand jeté arc forms the cheekbone, the arms'' sweep creates the jaw, stillness is implied by negative spaces::4

  material physics:
    blackened silver gelatin print, faint chemical residue, slight motion blur, glowing filament traces like a Marey wheel photograph::3

  illumination:
    complete darkness with bioluminescent-like light trails, no external light sources, high contrast::2

  render stack:
    chronophotography, fine art dance study, 8k, kinetic sculpture concept::1

  negative:
    [still body parts, studio lights, solid silhouettes]::-1
</instructions>', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 457, '@Gdgtify', 'https://x.com/Gdgtify/status/2057741253127594118', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-457', '/images/case457.jpg', 'Instructions Input 3 Legendary Dancer/choreographer Input Ai Inferred', '["Poster","Realistic","Character"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-456', '2x2 Grid, 16:9, Do This for 4 Famous', 'Template imported from awesome-gpt-image-2 case 456. Source: @Gdgtify.', 'Charts & Infographics', '2x2 grid, 16:9, do this for 4 famous historical events:

Render_Target =
  ( 3D_Diorama_Map_Of_[HISTORICAL_EVENT]_In_[CITY] * 1.2 )
  + ( First-Person_Account_Infographic_UI_From_The_Perspective_Of_[ROLE] * 1.5 )
  + ( Period-Accurate_Studio_Background_With_[ERA]_Artifacts * 1.0 )
  + ( Newspaper_Headline_Generator_Widget_With_Your_Byline * 0.8 )
  - ( Generic_Time_Machine_Gears_And_Clock_Dials / 3.0 )
  - ( Anachronistic_Props_From_Wrong_Decade / 2.5 )
  - ( Flat_Wikipedia_Timeline_Graphic / 2.0 )', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 456, '@Gdgtify', 'https://x.com/Gdgtify/status/2057277698607599692', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-456', '/images/case456.jpg', '2x2 Grid, 16:9, Do This for 4 Famous', '["UI","Infographic","Classical"]'::jsonb, '["Commerce","Travel","History"]'::jsonb, FALSE, TRUE),
    ('case-455', 'Hyper-realistic Premium Product Advertisement: an Oversized Futuristic Comfort', 'Template imported from awesome-gpt-image-2 case 455. Source: @iamaiistudio.', 'Products & E-commerce', 'Hyper-realistic premium product advertisement: an oversized futuristic comfort clog sits on a smooth glossy reflective floor. A modern model in soft neutral-toned athleisure (off-white / beige) leans casually against the giant shoe with a relaxed, confident posture.

Backdrop: clean gradient flowing from soft sky blue into subtle lavender, with massive bold sans-serif typography reading "STEP INTO EASE" stretched vertically, partially tucked behind the subject.

Lighting: high-end studio lighting, soft highlights, gentle floor reflections, and a subtle rim light tracing the model and the product for depth.

Composition: editorial magazine layout, subject perfectly centered, generous negative space, luxury campaign mood.

Small minimal copy at the bottom: "Designed for all-day comfort. Made to move with you."

Style: ultra-clean Apple-style minimalism crossed with a fashion campaign, hyper-realistic, premium commercial photography, 8K, razor-sharp detail.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 455, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2057281549851377866', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-455', '/images/case455.jpg', 'Hyper-realistic Premium Product Advertisement: an Oversized Futuristic Comfort', '["Poster","Realistic","Product"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-454', 'Ultra-detailed Premium Travel-food Advertisement Poster for , Vertical', 'Template imported from awesome-gpt-image-2 case 454. Source: @Naiknelofar788.', 'Products & E-commerce', 'Ultra-detailed premium travel-food advertisement poster for [CITY/COUNTRY], vertical composition, inspired by luxury Lay''s-style chips advertising. A realistic chips packet placed at the bottom center as the main hero object, matching the exact premium commercial layout of a floating chips campaign.

A cinematic spiral ribbon of sauce, cream, clouds, steam, or flavored swirl rises upward from the chips packet, dynamically wrapping around iconic landmarks, local foods, and cultural elements from [CITY/COUNTRY].

Floating ridged potato chips suspended naturally throughout the spiral motion, interacting with the landmarks and miniature travelers. The chips packet design must feel authentic to [CITY/COUNTRY], featuring regional colors, typography, patterns, and local flavor inspiration while still clearly looking like a premium potato chips package.

Include only the most iconic landmarks from [CITY/COUNTRY], carefully spaced with clean composition and no clutter. Add miniature travelers naturally interacting with the environment:
- taking photos
- exploring landmarks
- sitting on floating chips
- riding local transport
- observing scenery
- walking through the swirl paths

Include authentic local foods, ingredients, and atmosphere elements relevant to [CITY/COUNTRY].

Background should be soft pastel or warm luxury gradient with a circular ceiling portal opening at the top emitting cinematic spotlight beams.

Elegant premium commercial lighting, soft shadows, floating particles, realistic depth, balanced negative space, luxury tourism campaign aesthetic, hyper-realistic CGI, highly detailed but minimalist, Instagram-worthy poster design.

Composition rules:
- one dominant centered chips packet
- floating ridged potato chips throughout composition
- one continuous upward spiral motion
- landmarks layered vertically
- miniature people sparse and intentional
- no duplicate landmarks
- no overcrowding
- clean premium hierarchy
- cinematic storytelling through scale contrast
- premium advertising composition matching high-end chips commercials', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 454, '@Naiknelofar788', 'https://x.com/Naiknelofar788/status/2057282710469767241', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-454', '/images/case454.jpg', 'Ultra-detailed Premium Travel-food Advertisement Poster for , Vertical', '["Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-453', ', / / :; Word Ppt / /', 'Template imported from awesome-gpt-image-2 case 453. Source: @MrLarus.', 'Documents & Publishing', '请生成一套企业级商用画册视觉方案，主题为【品牌名称】的【行业 / 产品 / 解决方案】宣传画册。

整体风格：高端、专业、具有强视觉冲击力；避免传统 Word 排版感和普通 PPT 感。采用【深色科技美学 / 白色极简商务 / 高端工业风 / 艺术化品牌画册】风格。

画册内容包括：
1、封面与封底
2、企业介绍与品牌理念
3、核心产品与技术优势
4、应用场景与解决方案
5、客户案例与合作方式
6、全册系统预览图

要求：
版式要有设计感，图片、标题、数据、图标、留白和层级关系清晰；保持整套画册统一的品牌视觉系统；重点体现真实商业物料的完成度，避免简单文字排版。

结构规划：
1、封面 / 封底：建立品牌门面、行业气质和整体视觉调性。
2、企业介绍页：说明公司定位、能力边界和服务对象。
3、产品技术页：展示核心产品、技术优势和解决方案。
4、应用场景页：让用户看到产品能用在哪些行业。
5、案例 / 合作页：补充可信度和商业转化信息。
6、全册系统预览：验证风格统一性和整本画册的系统感。

如果已有企业资料，可以上传旧版企业画册、公司介绍文档、产品说明书、官网内容、PPT 提案、产品图片或案例图片，让 ChatGPT 完成三件事：
1、重新梳理内容结构，判断哪些内容适合做封面、企业介绍、产品页、案例页和合作页。
2、提炼画册主线，避免只堆资料，需要形成清晰的商业叙事。
3、统一视觉方向，让整本画册看起来像同一个品牌系统，避免不同页面拼贴感。

避坑：
1、避免一上来只说"生成一本画册"，否则容易变成模板图。
2、避免只堆文字，画册一定要有产品视觉、场景图、数据模块和设计层级。
3、避免只生成单页，最好补一张全册预览图，才能体现完整系统感。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 453, '@MrLarus', 'https://x.com/MrLarus/status/2056974720893939950', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-453', '/images/case453.jpg', ', / / :; Word Ppt / /', '["Poster","Brand"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-452', 'Transform the Photo into a Delicate Minimalist Hand-drawn', 'Template imported from awesome-gpt-image-2 case 452. Source: @MissDelulu9.', 'Illustration & Art', 'Transform the photo into a delicate minimalist hand-drawn children''s illustration with a soft whimsical fairy-tale aesthetic. Use simple elongated shapes, thin imperfect hand-drawn lines, flat pastel colors, minimal details, and a cute doll-like character style with rosy cheeks, tiny facial features, and simplified anatomy. Add subtle paper texture, soft pencil and pastel shading, watercolor softness, and a clean white background with small stars or sparkles.

Stylize the clothing in a playful storybook way with simplified shapes and gentle decorative details. The overall mood should feel airy, cozy, naive, and charming, like a modern Scandinavian nursery postcard or children''s book illustration. Avoid photorealism, 3D, cinematic lighting, glossy surfaces, complex shadows, realistic anatomy, and hyper-detail.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 452, '@MissDelulu9', 'https://x.com/MissDelulu9/status/2057073936295399551', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-452', '/images/case452.jpg', 'Transform the Photo into a Delicate Minimalist Hand-drawn', '["Realistic","Illustration","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-451', ',,,,,,,,,,,,,dslr,,,,,,,,9:16', 'Template imported from awesome-gpt-image-2 case 451. Source: @MrGafish.', 'Photography & Realism', '一位成年韩国女孩，人物位于画面中央，半身到大腿视角，身体微微前倾。身形比例协调，肩颈线条舒展，可以看到胸部轮廓，轮廓自然优美，腰部线条柔和，整体凸显丰腴健康的女性美，丝滑黑发随风飘扬，人物气质成熟、温柔、安静，面带自然微笑。身穿白色一字肩连衣裙，背景是热带海滩日落，电影感DSLR摄影，温暖辉光照明，梦幻虚化，超详细，鲜艳色彩，丰富对比，韩国时尚美学氛围，自然欢乐情感，高端生活方式摄影。9:16 竖版构图。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 451, '@MrGafish', 'https://x.com/MrGafish/status/2057107670226870577', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-451', '/images/case451.jpg', ',,,,,,,,,,,,,dslr,,,,,,,,9:16', '["Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-450', 'A Medium-shot Authentic Daily Life Photograph, Natural Candid', 'Template imported from awesome-gpt-image-2 case 450. Source: @ToroJushiAi.', 'Photography & Realism', 'A medium-shot authentic daily life photograph, natural candid moment, of an East Asian young woman standing in a small side room lit only by a single candle on a low stone shelf. 85mm lens, waist-up framing, shallow depth of field. The candle is off-frame to the left; the room behind her exists only as dark warm suggestion.

East Asian young woman in her early 20s. Almond-shaped eyes receiving the candle''s warm flicker - the irises briefly caught in light before returning to shadow. Straight refined nose, the bridge illuminated in a narrow warm stripe. Skin tone fair beige, warmed entirely by candlelight into something amber. Skin subsurface scattering visible under directional candlelight, specular micro-highlights on cheekbones and nose ridge, fine foundation powder grain perceptible.

She wears an aged amber silk qipao with chrysanthemum embroidery in tones of old bronze and dusty ochre - the amber pigment identical in temperature to the candle''s own light, the embroidery appearing and disappearing depending on angle. Mandarin collar, short sleeves. She stands facing the candle without looking at it, arms at her sides, very still. The room is otherwise empty. Two or three stray hairs displaced by faint air movement, natural unplanned imperfection, not geometrically symmetrical.

Single candle - warm amber-orange, directional and fragile. It carves the left side of her face from darkness, leaves the right in near-black shadow. The amber qipao and the candlelight share a single temperature register: the room folds her into the light. Deep chiaroscuro with no artificial fill. Subtle ISO 400 film grain in shadow areas, photographic noise texture not CG render smoothness. Aspect ratio 9:16. No watermark, no text overlay, not cartoon, not digitally painted, not illustration, not anime.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 450, '@ToroJushiAi', 'https://x.com/ToroJushiAi/status/2056926887344042382', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-450', '/images/case450.jpg', 'A Medium-shot Authentic Daily Life Photograph, Natural Candid', '["Realistic","Illustration","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-449', '2x2 Grid 16:9, Do This for 4 Most', 'Template imported from awesome-gpt-image-2 case 449. Source: @Gdgtify.', 'Products & E-commerce', '2x2 grid 16:9, do this for 4 most expensive strangest watches ever made:

class Haute_Horlogerie_DNA:
    def __init__(self):
        self.subject = "[TIMEPIECE]"
        self.parents = {
            "composition_parent": "Exploded movement diagram with transparent case",
            "material_parent": "Brushed titanium, sapphire crystal, rose gold gears, alligator leather",
            "graphic_parent": "Swiss manufacture technical brochure with elegant data panels",
            "atmosphere_parent": "Crisp daylight studio, pure white background, subtle reflection on polished surfaces"
        }
        self.mutations = {
            "semantic_mutation": "The balance wheel reveals a miniature cosmos ticking inside",
            "information_mutation": "Power reserve indicator, frequency, complication callouts, hand-finishing grades, assembly timeline",
            "medium_mutation": "Smooth matte premium paper with embossed logo",
            "scale_mutation": "Grain-level view of Côtes de Genève finishing and jewel bearings"
        }
        self.style_mix = [0.30, 0.30, 0.25, 0.10, 0.05]

    def generate_subject(self):
        subject = """
        [TIMEPIECE] shown in its full mechanical glory. The dial, hands, movement,
        and strap float in perfect alignment against a bright, clean background.
        Every gear and spring is highlighted with exacting clarity.
        """
        return render(
            subject,
            format="luxury watch advertisement with technical insert",
            title="[MODEL REFERENCE]",
            subtitle="[MANUFACTURE / COLLECTION]",
            constraints="bright white space, metallic brilliance, hyper-detailed, modern elegance"
        )', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 449, '@Gdgtify', 'https://x.com/Gdgtify/status/2056928396991488312', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-449', '/images/case449.jpg', '2x2 Grid 16:9, Do This for 4 Most', '["Infographic","Brand","3D"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-448', 'Ultra-realistic Cinematic 1942 Citymission Startplayer 1 Ready', 'Template imported from awesome-gpt-image-2 case 448. Source: @Xaroon_x.', 'Scenes & Storytelling', 'Ultra-realistic cinematic "1942 City" scene, retro WWII arcade-shooter-inspired metropolis in real life, intense aerial-war atmosphere, vertical 4:5 editorial composition

Male, exact face, vintage military-pilot-inspired streetwear from head to toe, bomber jacket with retro aviation patches, fitted cargo trousers, rugged combat boots, fingerless gloves, pilot goggles hanging around neck, walking through the city with fearless ace-pilot expression while fighter planes soar overhead

✈️ 1942 CITY WORLDBUILDING

entire city functions like a living 1942 arcade shooter universe
• massive WWII fighter planes dogfighting above skyscrapers
• giant anti-aircraft cannons mounted across rooftops
• endless bullet patterns streaking through cloudy skies
• retro military airfields integrated into urban districts
• giant "MISSION START" alerts projected into the clouds
• dramatic explosion trails lighting the skyline at night
• aircraft carriers docked beside futuristic city ports
• glowing power-up icons floating through aerial battle zones
• giant radar systems rotating above downtown towers
• endless enemy squadrons emerging from storm clouds
• cinematic ocean-and-warzone environments surrounding the metropolis

😂 COMEDIC DETAILS

• random civilians casually dodging fighter planes on the way to work 😭
• one pilot barrel-rolling dramatically for absolutely no reason
• giant billboard flashing: "PLAYER 1 READY."
• pedestrians treating near-miss explosions like normal traffic
• somebody still trying to collect every floating power-up midair
• random mechanic repairing planes using pure confidence
• one legendary pilot surviving impossible situations through arcade logic alone

💡 LIGHTING & STYLE

retro war-film cinematic lighting, fiery aerial-battle atmosphere, dramatic clouds and explosion reflections, hyper-detailed realistic textures mixed with nostalgic arcade-shooter aesthetics, intense blockbuster-war energy, masterpiece quality

🎥 CAMERA

cinematic aerial tracking shot, immersive dogfight atmosphere, dynamic motion blur from fighter planes and explosions, documentary-meets-retro-arcade realism, futuristic Manila-inspired 1942 metropolis, "classic arcade air combat became civilization" atmosphere', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 448, '@Xaroon_x', 'https://x.com/Xaroon_x/status/2056940561148363010', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-448', '/images/case448.jpg', 'Ultra-realistic Cinematic 1942 Citymission Startplayer 1 Ready', '["UI","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-447', 'Create a Premium Square Centered Around a Futuristic', 'Template imported from awesome-gpt-image-2 case 447. Source: @j_smeaton99.', 'Charts & Infographics', 'Create a premium square "reference-style urban transportation infographic" centered around a futuristic modern metro system called the {METRO_NAME}, designed as a beautifully curated transit-engineering handbook page rather than a public transport advertisement.

The composition should feel like a modern visual encyclopedia mixed with an elite railway infrastructure field guide and high-end editorial infographic system.

Visual Direction:

• 1:1 square composition
• Dark premium urban-tech background with subtle railway schematics, metro maps, and futuristic blueprint overlays
• Elegant palette using deep navy, matte black, steel gray, electric blue accents, and soft white lighting
• Refined editorial typography hierarchy with modern transportation aesthetics
• Rounded modular information cards with clean spacing
• Gentle realistic reflections and premium HUD-style dividers
• Minimal transit-system iconography
• Extremely detailed central metro train render viewed in dramatic three-quarter perspective inside a futuristic underground station
• Thin precision annotation lines pointing toward transportation systems and smart engineering features
• Clean, organized "knowledge-first" layout with high information density but breathable spacing

Main Subject Presentation:

A stunning ultra-detailed realistic render of the {METRO_NAME} modern metro train placed at the center, featuring sleek aerodynamic train design, glowing destination displays, realistic stainless-steel textures, illuminated station lighting, smart glass windows, premium urban-environment realism, and futuristic rail infrastructure.

Surround the metro with scientific and engineering callouts explaining:

• regenerative braking system
• smart signalling & CBTC control
• electric propulsion system
• passenger information systems
• safety and surveillance technology
• platform screen doors
• energy-efficient design
• smart ventilation systems
• accessibility features
• track and infrastructure engineering

Include modular infographic sections such as:

• Metro System Overview
• Technical Specifications
• Train Dimensions & Layout
• Passenger Capacity & Flow
• Smart Control Systems
• Sustainability Features
• Track & Infrastructure Engineering
• Signalling & Automation
• Station Design & Facilities
• Safety & Emergency Systems
• Passenger Experience Features
• Urban Connectivity & Network Map
• Energy Efficiency Comparison
• Construction & Expansion Timeline
• "Top 5 Smart Innovations" section
• Built for Future Smart Cities

Add small premium visualization modules like:

• metro network maps
• train blueprint diagrams
• station layout graphics
• passenger flow visualizations
• signalling workflow diagrams
• energy-efficiency comparison charts
• train configuration illustrations
• smart-city connectivity graphics
• platform safety diagrams
• infrastructure cross-section visuals

Style Keywords:

"premium urban mobility encyclopedia"
"editorial metro engineering handbook"
"high-end transportation infographic"
"scientific railway infrastructure poster"
"museum-quality transit reference page"
"modular smart-city knowledge system"
"clean transportation editorial design"
"ultra-detailed metro visualization"

Avoid:

• cluttered public advertisement aesthetics
• cartoon transportation styling
• unrealistic sci-fi levitating trains
• excessive cyberpunk neon overload
• chaotic city scenes
• generic subway poster layouts

The final result should resemble a professionally published railway infrastructure reference-book page created for transit enthusiasts, architects, engineers, urban planners, transportation designers, and educational infrastructure archives.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 447, '@j_smeaton99', 'https://x.com/j_smeaton99/status/2056950969083343077', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-447', '/images/case447.jpg', 'Create a Premium Square Centered Around a Futuristic', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-446', 'Create a Highly Detailed Low-poly Papercraft Portrait of', 'Template imported from awesome-gpt-image-2 case 446. Source: @iamsofiaijaz.', 'Illustration & Art', 'Create a highly detailed low-poly papercraft portrait of a stylish young man, designed like an origami paper sculpture. The character has curly dark brown hair, a trimmed beard, and wears slightly black-tinted geometric sunglasses with thin black frames. His shirt is medium grey with sharp polygonal folds and realistic paper texture. Use faceted angular shapes across the face, hair, and clothing, with realistic shadows and layered paper depth. Minimal clean white studio background, soft lighting, ultra-realistic paper craft aesthetic, modern geometric art style, high detail, centered composition, 8k quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 446, '@iamsofiaijaz', 'https://x.com/iamsofiaijaz/status/2056953102755115162', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-446', '/images/case446.jpg', 'Create a Highly Detailed Low-poly Papercraft Portrait of', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-445', 'Create a Dreamy Watercolor Travel Illustration Style from', 'Template imported from awesome-gpt-image-2 case 445. Source: @zhgqthomas.', 'Illustration & Art', 'Create a dreamy watercolor travel illustration style from the attached photo. Use hand-painted urban sketchbook aesthetic, delicate ink linework mixed with soft watercolor washes, highly detailed pen-and-ink drawing, loose expressive brush strokes, watercolor bleeding edges, ultra detailed watercolor texture, soft beige paper texture background, architectural sketch style, vintage travel diary and sketchbook traveler aesthetic, travel journal composition, editorial postcard layout, handwritten medium title:[自定义标题]  at top, handwritten notes:[自定义文案] , date: [自定义日期] and location: [自定义地点]  stamps, natural perspective, atmospheric depth, minimalist negative space, muted earthy palette (warm browns, faded greens, cream whites, soft blue accents), quiet, calm, soft, cozy, nostalgic vibes, cinematic slice-of-life mood, poetic composition, mixed urban sketching with Ghibli-inspired realism, vertical poster design, premium art print quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 445, '@zhgqthomas', 'https://x.com/zhgqthomas/status/2056633723366568387', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-445', '/images/case445.jpg', 'Create a Dreamy Watercolor Travel Illustration Style from', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-444', '3d App ,,,,,,,,blender 3d , : a Premium', 'Template imported from awesome-gpt-image-2 case 444. Source: @vista8.', 'Brand & Logos', '为【品牌名】生成一个高级 3D App 图标，圆角方形底板，玻璃与金属铬材质，迪斯科球镜面马赛克小方块质感，闪亮高光，柔和工作室灯光，干净极简背景，高端产品图标风格，Blender 3D 渲染，超精细

英文版：

A premium 3D app icon for 【Product Name】, rounded square tile, glossy glass and chrome material, disco-ball mosaic mirror tiles, sparkling highlights, soft studio lighting, clean minimal background, high-end icon, Blender 3D render, ultra detailed', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 444, '@vista8', 'https://x.com/vista8/status/2056308962778296715', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-444', '/images/case444.jpg', '3d App ,,,,,,,,blender 3d , : a Premium', '["Product","Brand","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-443', 'Create a Hyper-realistic Exploded Vertical Infographic Composition of', 'Template imported from awesome-gpt-image-2 case 443. Source: @Strength04_X.', 'Charts & Infographics', 'Create a hyper-realistic exploded vertical infographic composition of tacos.

Top → Bottom structure:
Fresh Lettuce (crisp green texture with natural folds)
→ Tomato & Salsa Layer (juicy diced tomatoes and salsa mix)
→ Melted Cheese (smooth cheddar texture)
→ Grilled Meat Filling (juicy seasoned meat detail)
→ Taco Shell Base (crispy golden shell texture)
Perfect vertical alignment, rustic background, soft studio lighting, realistic shadows beneath each floating element.

Add clean infographic text labels with thin pointer lines using these exact labels:
"Lettuce"
"Salsa"
"Cheese"
"Meat"
"Shell"
Ultra-detailed food textures, premium commercial aesthetic, 8K.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 443, '@Strength04_X', 'https://x.com/Strength04_X/status/2056018963084226866', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-443', '/images/case443.jpg', 'Create a Hyper-realistic Exploded Vertical Infographic Composition of', '["UI","Infographic","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-442', 'A Vibrant Whimsical Digital Illustration of a Cozy', 'Template imported from awesome-gpt-image-2 case 442. Source: @Sairah_0.', 'Illustration & Art', 'A vibrant whimsical digital illustration of a cozy indie hair salon, featuring a young girl with long brown hair getting her hair styled by a fashionable hairstylist. Bright pink, purple, orange, and peach color palette with playful retro decor, indoor plants, patterned walls, confetti shapes, beauty tools, flowers, and soft ambient lighting. Cute feminine aesthetic, dreamy cartoon style, expressive characters with rosy cheeks, highly detailed textures, modern flat illustration mixed with painterly shading, colorful composition, trendy Pinterest aesthetic, cozy creative atmosphere, ultra-detailed, 2D editorial art style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 442, '@Sairah_0', 'https://x.com/Sairah_0/status/2056293543753503126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-442', '/images/case442.jpg', 'A Vibrant Whimsical Digital Illustration of a Cozy', '["Illustration","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-441', 'An Outdoor Adventure Advertisement Poster Featuring a Rugged', 'Template imported from awesome-gpt-image-2 case 441. Source: @Strength04_X.', 'Products & E-commerce', 'An outdoor adventure advertisement poster featuring a rugged bearded man in full hiking gear standing confidently beside a massive orange camping tent three times taller than him, fully pitched in a dramatic forest clearing surrounded by towering pine trees beneath a deep starry night sky. The tent features a bold white "WILDCAMP" logo stitched onto the rainfly. Warm cinematic campfire lighting illuminates the scene with realistic shadows and rich outdoor textures, creating a premium adventure-commercial aesthetic. Large rugged serif typography reading "WILDCAMP" dominates the dark sky area in bold orange lettering, while the tagline "Sleep under the stars." appears elegantly at the bottom. Small grey text in the top-right corner reads "Designed with GPT Image 2." Photorealistic, ultra-detailed, cinematic outdoor advertising style with dramatic atmosphere and high-end commercial composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 441, '@Strength04_X', 'https://x.com/Strength04_X/status/2056258909334306897', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-441', '/images/case441.jpg', 'An Outdoor Adventure Advertisement Poster Featuring a Rugged', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-440', 'Create a Raw Smartphone Photo of a Laptop', 'Template imported from awesome-gpt-image-2 case 440. Source: @kaanakz.', 'UI & Interfaces', 'Create a raw smartphone photo of a laptop screen, not a screenshot. Aspect ratio 3:4, high-angle downward POV from someone standing over a desk at night. The laptop display fills most of the frame, with a narrow strip of black keyboard and trackpad visible at the bottom. Strong realism: visible RGB subpixel grid, subtle moire bands, small dust specks, faint fingerprints, uneven glass reflections, handheld phone noise, slight perspective skew, no studio polish. macOS dark mode. Background app: Apple Notes with a late-night study note titled "Design Critique" and short visible bullets: "layout", "lighting", "source links", "ship tomorrow". Foreground app: FaceTime live preview window floating lower-right, showing a fictional adult man in his 20s sitting at a cluttered desk, hoodie, tired but amused expression, warm desk lamp behind him, books and sticky notes in the room. A second small Finder window with image thumbnails is partly visible behind it. Make it feel like an accidental real phone photo of a working laptop screen. No real-person likeness, no beauty filter, no perfect UI, no screenshot, no watermark, no cartoon, no 3D render.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, 'template-thumbnails/template-saas-dashboard.png', 440, '@kaanakz', 'https://x.com/kaanakz/status/2056290465503171000', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-440', '/images/case440.jpg', 'Create a Raw Smartphone Photo of a Laptop', '["UI","Realistic","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-439', 'Ultra-detailed Cyberpunk Anime Character Design Sheet of a', 'Template imported from awesome-gpt-image-2 case 439. Source: @Kashberg_0.', 'Characters & People', 'Ultra-detailed cyberpunk anime character design sheet of a teenage genius hacker girl named "NEO // RIN", full body turnaround (front, side, back) plus close-up portrait and accessory callouts. Short silver-white bob haircut with neon cyan and magenta gradient streaks, glowing translucent cyber visor over one eye, pale skin, sharp violet eyes, calm confident expression. Oversized techwear jacket with black tactical cargo pants, belts, straps, dangling utility tags, cropped top, futuristic sneakers, holographic accessories, barcode decals, warning symbols, "BYTE//NULL" typography, hacker aesthetic.
Color palette: matte black, dark gray, white, neon cyan, neon pink.
Style inspired by high-end Japanese concept art, futuristic streetwear, cyberpunk fashion, Akira + Ghost in the Shell + modern anime key visual aesthetics.
Include clean character reference sheet layout with labeled details, logo designs, UI graphics, gadget closeups, and color palette on white background.
Highly polished cel shading, crisp lineart, soft glow effects, intricate clothing folds, layered accessories, dynamic fashion silhouette, professional game concept art quality, 4k, ultra detailed.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 439, '@Kashberg_0', 'https://x.com/Kashberg_0/status/2055865126335762902', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-439', '/images/case439.jpg', 'Ultra-detailed Cyberpunk Anime Character Design Sheet of a', '["UI","Poster","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-438', 'Create a Hyper-detailed Luxury Advertising Poster in a', 'Template imported from awesome-gpt-image-2 case 438. Source: @Umar__786Ai.', 'Products & E-commerce', 'Create a hyper-detailed luxury advertising poster in a cinematic miniature-world style. A gigantic royal diamond necklace with intricate gold filigree and massive ruby gemstones stands in the center like an architectural monument. Surround the necklace with a futuristic miniature city built around and inside the jewelry piece, including skyscrapers, elevated highways, bridges, spiral staircases, tiny human figures, luxury billboards, drones, helicopters, and cinematic urban activity. Use a deep crimson red monochrome background with gold and ruby accents. Add premium fashion-ad aesthetics, ultra-realistic textures, glossy reflections, dramatic studio lighting, depth of field, tilt-shift miniature effect, and high-end commercial composition. Include bold elegant typography at the top saying: "EMBRACE THE EXTRAORDINARY". Style inspired by luxury jewelry campaigns, surreal city-building concepts, and premium 3D advertising renders. Ultra realistic, 8K, octane render, sharp focus, highly detailed, cinematic shadows, symmetrical composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 438, '@Umar__786Ai', 'https://x.com/Umar__786Ai/status/2055664244138349055', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-438', '/images/case438.jpg', 'Create a Hyper-detailed Luxury Advertising Poster in a', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-437', 'Create a Clean, Minimal, Luxury-style Facial Aesthetics Analysis', 'Template imported from awesome-gpt-image-2 case 437. Source: @saniaspeaks_.', 'UI & Interfaces', 'Create a clean, minimal, luxury-style facial aesthetics analysis report based on the uploaded portrait photo.
Design style:
Ultra-modern black and white interface, premium editorial aesthetic, thin elegant divider lines, soft rounded cards, subtle shadows, spacious layout, luxury skincare / fashion magazine vibe, monochrome palette, Apple-style UI refinement.
Include:
- A simple contour line-art drawing of the face based on the subject
- Facial symmetry analysis
- Face shape identification
- Proportional analysis (eyes, nose, jawline, lips, forehead)
- Skin texture observations
- Hairstyle compatibility suggestions
- Grooming and fashion recommendations
- Honest attractiveness evaluation with balanced critique
- Strengths and weaker facial areas explained objectively
- Actionable glow-up recommendations
- Confidence score and facial harmony score shown with elegant charts or meters
Style notes:
Keep the report data-driven, visually refined, realistic, and not overly flattering.
Avoid exaggerated praise.
Use clean typography, premium spacing, modern infographics, subtle geometric accents, and professional cosmetic consultation aesthetics.
Visual composition:
Magazine-quality presentation, luxury beauty report dashboard, highly organized layout, cinematic monochrome feel, minimalist infographic design, realistic facial structure interpretation, modern masculine beauty analytics.
Rendering:
Ultra-detailed, sharp UI design, realistic portrait adaptation, sophisticated editorial presentation, high-end branding aesthetic, 4K quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 437, '@saniaspeaks_', 'https://x.com/saniaspeaks_/status/2055857787637522908', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-437', '/images/case437.jpg', 'Create a Clean, Minimal, Luxury-style Facial Aesthetics Analysis', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-436', 'A Realistic Close-up Shot of a Small Digital', 'Template imported from awesome-gpt-image-2 case 436. Source: @Ciri_ai.', 'Photography & Realism', 'A realistic close-up shot of a small digital camera screen glowing brightly in a dark indoor environment. Displayed on the LCD is a candid early-2010s style photograph of a young East Asian woman with long dark wavy hair standing beside a wooden shelf packed tightly with colorful comic books and magazines.

She wears a black spaghetti-strap top with a loose white cardigan hanging casually from both shoulders and faded blue jeans. Captured mid-laugh while turning her face slightly sideways, her expression feels spontaneous and natural, with hair falling softly across part of her cheek.

The harsh direct flash from the compact camera creates strong highlights on her face and cardigan while flattening shadows in the background, producing an authentic nostalgic digicam aesthetic. Slight motion blur and digital grain enhance the candid realism.

Camera UI overlays are visible across the LCD screen, including the timestamp "8. 1. 2012 3:15 AM," exposure data "1/30 F3.4 ISO 100," focus indicators, and a small green battery symbol in the corner.

The image preserves visible screen pixel structure, slight glare reflections, chromatic softness, and compressed digital texture. Outside the LCD, the surrounding darkness fades smoothly into blur, emphasizing the glowing nostalgic screen.

Shot to resemble an authentic Sony Cyber-shot point-and-shoot camera from the early 2010s using a CCD sensor with vintage digital rendering and imperfect flash exposure.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 436, '@Ciri_ai', 'https://x.com/Ciri_ai/status/2055876982630686956', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-436', '/images/case436.jpg', 'A Realistic Close-up Shot of a Small Digital', '["UI","Realistic","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-435', ', Character Design : , Limbs : ,', 'Template imported from awesome-gpt-image-2 case 435. Source: @Just_sharon7.', 'Illustration & Art', '{
  "style": "layered paper-cut illustration, papercraft diorama, handcrafted aesthetic",
  "technique": {
    "layering": "multiple stacked paper layers with soft drop shadows between each layer",
    "depth": "5-7 visible depth planes from foreground to background",
    "edges": "smooth, rounded, slightly beveled paper-cut edges",
    "texture": "subtle paper grain and fibrous texture on all surfaces",
    "shadows": "soft, diffused inner shadows beneath each layer suggesting physical depth"
  },
  "character_design": {
    "proportions": "chibi / cute simplified - large round head, small body (1:1.5 ratio)",
    "face": {
      "eyes": "small dot eyes, glossy highlight",
      "cheeks": "soft circular rosy blush patches",
      "nose": "absent or minimal dot",
      "mouth": "simple small curve smile"
    },
    "limbs": "short, rounded, stubby limbs",
    "outline": "clean smooth silhouette, no sharp corners"
  },
  "color_palette": {
    "mood": "warm, cozy, pastel",
    "tones": ["soft cream", "dusty rose", "sage green", "warm peach", "sky blue", "honey yellow"],
    "saturation": "low-to-medium, muted and gentle",
    "background": "warm off-white or soft gradient"
  },
  "lighting": {
    "type": "soft ambient light from top-front",
    "highlights": "gentle white edge highlights on top layers",
    "shadows": "warm light tan/beige shadow tones beneath cut layers"
  },
  "environment": {
    "foliage": "simplified rounded leaf and floral shapes as separate paper layers",
    "ground": "curved horizon layers suggesting rolling hills",
    "details": "tiny decorative elements - stars, small hearts, dots - cut from paper"
  },
  "overall_mood": "warm, whimsical, cozy, handmade, storybook",
  "render_quality": "ultra-detailed papercraft art, studio photography lighting, sharp focus on layer edges"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 435, '@Just_sharon7', 'https://x.com/Just_sharon7/status/2055368240885641323', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-435', '/images/case435.jpg', ', Character Design : , Limbs : ,', '["Realistic","Illustration","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-434', 'Film Photography, Candid Street Snapshot Aesthetic, Razor-sharp Focus', 'Template imported from awesome-gpt-image-2 case 434. Source: @BubbleBrain.', 'Photography & Realism', 'film photography, candid street snapshot aesthetic, razor-sharp focus on subject, shallow depth of field with soft blurred urban background, bright daylight, slightly overexposed highlights, vivid contrast, subtle analog film texture, heavy film grain, nostalgic cinematic atmosphere, Tokyo backstreet neighborhood scene near a quiet train station, narrow pedestrian street lined with Japanese convenience stores, vintage vending machines, small ramen shops, hanging signs with faded typography, bicycles parked along tiled sidewalks, utility poles and overhead wires stretching across the sky, scattered fallen leaves on the ground, distant pedestrians and passing taxis softly blurred in the background, warm afternoon sunlight with deep blue sky, realistic street fashion photography style, effortless cool street vibe, vibrant colors with slightly muted faded film tones, beautiful 19-year-old Chinese female influencer, fair porcelain skin with cold pale undertones, exquisite natural makeup, glossy soft lips, defined brows, delicate lashes, soft messy long black hair with natural flowing curves, wearing an off-shoulder white fluffy faux fur jacket, playful yet subtly seductive expression, lazy dreamy vintage filter, ultra high-quality details, intentionally mundane phone-camera snapshot feeling, casual accidental composition, imperfect framing, realistic iPhone photography texture, spontaneous candid energy, highly attractive girl casually posing in the middle of the sidewalk, body facing away from the camera while turning her head back toward the lens with direct eye contact, relaxed posture, soft wind moving her hair, emotional youthful atmosphere, modern Asian street fashion editorial, soft haze, layered composition, masterpiece, best quality, ultra detailed, slight motion blur from slow shutter, authentic everyday realism, "BubbleBrain" small handwritten signature text on bottom corner --ar 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 434, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2055491616392052887', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-434', '/images/case434.jpg', 'Film Photography, Candid Street Snapshot Aesthetic, Razor-sharp Focus', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-433', 'Dreamy Watercolor Travel Illustration of a Peaceful Korean', 'Template imported from awesome-gpt-image-2 case 433. Source: @Taaruk_.', 'Illustration & Art', 'Dreamy watercolor travel illustration of a peaceful Korean city street, hand-painted urban sketchbook style, delicate ink linework mixed with soft watercolor washes, cozy café storefronts, warm bakery lights glowing through windows, quiet morning atmosphere after light rain, reflective wet pavement, pedestrians with umbrellas and tote bags, bicycles parked along narrow streets, traditional Korean signs and typography, subtle Korean text labels, soft beige paper texture background, architectural sketch aesthetic, calm everyday city life, muted earthy palette with warm browns, faded greens, cream whites and soft blue accents, highly detailed pen-and-ink drawing, loose expressive brush strokes, travel journal composition, editorial postcard layout, elegant serif title text at top ("SEOUL", "JEONJU", "DAEJEON"), handwritten notes and date stamps, vintage travel diary aesthetic, cozy East Asian urban scenery, cinematic slice-of-life mood, watercolor bleeding edges, natural perspective, atmospheric depth, peaceful storytelling illustration, minimalist negative space, ultra detailed watercolor texture, sketchbook traveler aesthetic, nostalgic café culture vibes, Studio Ghibli-inspired realism, European urban sketching style mixed with Korean street scenery, soft daylight, calm and poetic composition, vertical poster design, premium art print quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 433, '@Taaruk_', 'https://x.com/Taaruk_/status/2055492435862773978', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-433', '/images/case433.jpg', 'Dreamy Watercolor Travel Illustration of a Peaceful Korean', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-432', 'Create a Premium Editorial Travel Poster Illustration of', 'Template imported from awesome-gpt-image-2 case 432. Source: @jzaib4269.', 'Posters & Typography', 'Create a premium editorial travel poster illustration of the Great Barrier Reef, Australia.
Style: Flat vector illustration, ultra-clean minimalism, mid-century modern travel poster aesthetic, inspired by vintage tourism prints and Scandinavian graphic design. No photorealism, no textures, no noise, no gradients. Use crisp shapes, smooth color blocks, and harmonious vibrant tones.
Composition (vertical 3:4 layout):
Foreground (underwater): A rich coral reef ecosystem filled with colorful corals in pink, orange, yellow, and red tones. Include tropical fish of various species (striped, bright yellow, blue, and orange), and a large sea turtle swimming gracefully toward the right. Clear turquoise water with high visibility.
Midground: A female snorkeler swimming horizontally just beneath the water surface, wearing fins and a snorkel mask, observing the reef below. Light rays subtly pass through the water surface.
Background (above water): A calm tropical ocean with shallow reef patches visible through crystal-clear water. A white leisure boat floats peacefully on the left, and a small sailboat appears far in the distance. On the horizon, soft green islands or hills stretch across.
Sky: Bright blue sky with fluffy white clouds and a few birds flying, enhancing the serene vacation mood.
Typography:
At the bottom of the poster, include bold uppercase text:
"GREAT BARRIER REEF"
Below it, smaller spaced-out text:
"AUSTRALIA"
Add a small decorative coral icon between divider lines.
Mood & Lighting: Bright daylight, calm, inviting, tropical paradise atmosphere. Colors should feel fresh, vibrant, and relaxing with strong contrast between coral reef and ocean blues.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 432, '@jzaib4269', 'https://x.com/jzaib4269/status/2055487295734620522', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-432', '/images/case432.jpg', 'Create a Premium Editorial Travel Poster Illustration of', '["Poster","Realistic","Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-431', 'Ultra-high-resolution Typography Travel Poster Themed Around', 'Template imported from awesome-gpt-image-2 case 431. Source: @iamaiistudio.', 'Posters & Typography', 'Ultra-high-resolution typography travel poster themed around [CITY NAME]. 16:9 poster ratio.

IMPORTANT: every visible word on the poster must be in English, perfectly spelled, professionally typeset. No distorted letters, no random symbols, no broken text, no AI gibberish.

CORE COMPOSITION:
Place the giant English word "[CITY_NAME]" front and center. Each letter is a tall, bold, elongated sans-serif form, and each one frames a different illustrated scene from the city, like a row of gallery windows. Spread landmarks, streets, transport, nature, culture, and architecture across the letters so the scenes flow from one letter into the next as a single connected urban panorama.

TOP HORIZONTAL STRIP:
Across the top of the poster, a thin panoramic band: city skyline silhouettes, cars, trams or trains, boats where it fits, birds, clouds, sun. Keep it minimalist, elegant, rhythmically balanced.

STYLE: mid-century modern editorial poster, Swiss graphic design, minimal vector illustration, architectural infographic feel, travel typography poster, flat geometric illustration, ultra-clean composition, premium magazine design, screen-print poster vibe, retro-futuristic travel branding.

ILLUSTRATION:
Flat vector shapes only. No realism, no gradients, no noise. Clean geometric shadows, simplified architectural forms, a mix of map-like top-down with side-view cityscape. Subtle line-art details, crisp vector edges, strong negative space, harmonious rhythm between the letters.

TYPOGRAPHY:
Giant bold sans-serif, letters fill most of the canvas height. Pixel-perfect alignment. Each letter acts as its own framed illustration panel. Soft rounded corners where it suits. Editorial spacing. Print-ready and geometrically clean.

COLOR PALETTE:
Pull a cohesive palette inspired by [CITY_NAME]:
coastal city -> aqua, sand, coral, muted teal
desert city -> terracotta, beige, warm cream
cyber city -> mint, navy, steel blue
historic European city -> dusty rose, olive green, parchment
Muted pastels, soft vintage travel-poster colors, low saturation. Max 4 to 6 colors.

CONTENT:
Include iconic landmarks, famous streets and transport, local urban patterns, nearby nature, skyline silhouettes, bridges/rivers/coastline if relevant, culturally symbolic architecture, recognizable local atmosphere.

COMPOSITION:
Centered typography on a white or soft ivory background. Lots of breathing room. The top panoramic strip balances the heavy typography below. Asymmetrical but visually balanced. Each letter shows its own scene depth and perspective. Museum-quality poster hierarchy.

MOOD: premium, intellectual, calm, design-forward, travel-editorial, stylish enough for a museum gift-shop wall.

QUALITY: 8K ultra-detailed, print-ready, razor-sharp vector edges, flawless typography, zero distorted text, zero random characters, zero spelling errors, zero AI artifacts.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 431, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2054563354899857757', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-431', '/images/case431.jpg', 'Ultra-high-resolution Typography Travel Poster Themed Around', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-430', 'A High-detail Digital Illustration of a Stylish Woman', 'Template imported from awesome-gpt-image-2 case 430. Source: @harboriis.', 'Illustration & Art', 'A high-detail digital illustration of a stylish woman sitting gracefully on a stone ledge, posing with one hand near her chin and legs crossed. She is wearing vintage-inspired round sunglasses, a white blouse with rolled-up sleeves, denim overalls, and rugged lace-up combat boots. The subject is rendered in a desaturated, monochromatic pencil-sketch style with soft cross-hatching and charcoal textures. In the background, a large, vibrant solid orange circle creates a bold geometric contrast against a clean, light grey backdrop. The overall composition is minimalist, editorial, and features a clean "indie-magazine" aesthetic with sharp linework and soft shading.

Aspect ratio is 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 430, '@harboriis', 'https://x.com/harboriis/status/2054573031343931418', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-430', '/images/case430.jpg', 'A High-detail Digital Illustration of a Stylish Woman', '["Illustration","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-429', 'Ultra-realistic Cozy Korean Convenience Store Portrait of a', 'Template imported from awesome-gpt-image-2 case 429. Source: @john_my07.', 'Photography & Realism', 'Ultra-realistic cozy Korean convenience store portrait of a beautiful Korean woman standing in front of glowing refrigerator aisles at night, wearing an oversized fluffy pastel pink hoodie with the hood up. She holds a bottle of strawberry milk in one hand and a tiny strawberry cake in the other while shyly looking toward the camera. Long soft black hair, glossy eyes, natural skin texture, subtle blushy makeup, gentle expression, youthful Korean beauty aesthetic. Warm fluorescent convenience store lighting mixed with realistic iPhone flash photography. Tiny reflections on drink bottles and glass refrigerator doors, dreamy romantic atmosphere, soft pink and cream color palette, slice-of-life anime realism blended with cinematic photography, highly detailed, cozy late-night Seoul convenience store vibe, shallow depth of field, realistic Korean snack packaging, candid aesthetic, soft glow, ultra photorealistic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 429, '@john_my07', 'https://x.com/john_my07/status/2054573350199111928', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-429', '/images/case429.jpg', 'Ultra-realistic Cozy Korean Convenience Store Portrait of a', '["Realistic","Product"]'::jsonb, '["Tech","Fashion","Food"]'::jsonb, FALSE, TRUE),
    ('case-428', 'Ultra-realistic F1 Live Tv Broadcast Screenshot', 'Template imported from awesome-gpt-image-2 case 428. Source: @bigwonbots.', 'Photography & Realism', 'Ultra-realistic F1 live TV broadcast screenshot. A strikingly beautiful, 25-year-old young woman with bright light blue hair and captivating bright cerulean blue eyes is sitting in the VIP paddock / team garage during a Formula 1 race. Shown on the official live race broadcast as the girlfriend of an F1 driver, she is listening to the team radio through a professional racing headset. It is the final lap, and she is watching the garage monitors with a proud, enchanting smile.
She wears a fitted white tank top, an oversized racing team jacket (with generic, unbranded or blank team logos) draped over her shoulders, large black team-radio headset with boom mic, gold jewelry, and soft glam makeup. A slim, unbranded paddock pass hangs naturally from her neck.
Add realistic F1 broadcast graphics: "FINAL LAP" banner, lap counter showing final lap, driver timing tower on the left, small F1-style logo bug, "LIVE" indicator, and a lower-third identifying her as a driver partner / paddock guest (e.g., "MIA ANDERSEN - Paddock Guest / Partner"). No fake oversized badges, no selfie angle.
Team staff (in generic kit), headsets, garage screens, and generic race equipment are blurred around her. Telephoto broadcast camera shot from across the garage, professional depth of field, compression artifacts, digital noise, bright paddock lighting, natural skin texture, no smoothing, 8k quality, cinematic lighting.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 428, '@bigwonbots', 'https://x.com/bigwonbots/status/2054573714012787059', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-428', '/images/case428.jpg', 'Ultra-realistic F1 Live Tv Broadcast Screenshot', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-427', 'Edit This Photo and Don''t Change the Face,', 'Template imported from awesome-gpt-image-2 case 427. Source: @saniaspeaks_.', 'Photography & Realism', 'Edit this photo and don''t change the face, portrait 9:16. A 9-frame fashion portrait collage featuring a stylish young woman with playful expressions and sporty streetwear aesthetics. The concept combines modern model test photography, casual Gen-Z energy, and clean editorial studio vibes. Each frame captures different candid facial expressions and subtle attitude poses, creating a cool, confident, and slightly mischievous mood. Minimalist composition with strong focus on facial expressions, cap styling, and soft fashion portrait lighting.

Frame Descriptions (9 poses)

Frame 1 - Eyes closed with playful scrunched expression, slight smile, relaxed shoulders.
Frame 2 - Looking slightly sideways with lips parted, confident casual attitude.
Frame 3 - Head tilted slightly upward, calm expression, direct cool-girl energy.
Frame 4 - Eyes closed while sticking tongue slightly out, playful candid vibe.
Frame 5 - Both index fingers pressing cheeks while making duck lips, cute playful expression.
Frame 6 - Direct eye contact with subtle smile, relaxed natural pose.
Frame 7 - Body turned sideways, hand near chin, confident editorial profile look.
Frame 8 - Eyes squeezed shut while making pout lips, exaggerated playful expression.
Frame 9 - Wrinkled nose with gritted teeth, rebellious fashion attitude.

She wears oversized black long sleeves. Soft matte fabric with sporty streetwear silhouette. Relaxed fit with slightly oversized sleeves. Black New York Yankees baseball cap worn forward and backward in different frames. Minimal jewelry. Long soft wavy blonde hair. Soft loose waves with natural texture. Middle-part hairstyle. Hair flowing naturally around shoulders. Soft glam douyin girl makeup. Dewy glass skin finish. Brushed up natural brows, winged eyeliner, wispy natural lashes, soft pink blush (igari blush style), ombre gradient rosy pink lips with glossy finish.

Background minimal white studio backdrop. Photobooth-style collage layout with black frame borders. Shot with Canon EOS R6 / Sony A7 III / Fujifilm X-T5. High-fashion portrait photography style. 50mm or 85mm portrait lens. Eye-level framing. Tight portrait crop. Centered composition. Photobooth-inspired close-up angles. Soft diffused studio lighting. Balanced frontal light. Minimal harsh shadows. Clean editorial illumination. Cool neutral tones. Slightly desaturated blacks. Soft contrast with crisp details. Subtle film grain. Modern fashion editorial color grading.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 427, '@saniaspeaks_', 'https://x.com/saniaspeaks_/status/2054046866497573214', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-427', '/images/case427.jpg', 'Edit This Photo and Don''t Change the Face,', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-426', 'Ultra-realistic Cozy Japanese-korean Cafe Photography Featuring a Cute', 'Template imported from awesome-gpt-image-2 case 426. Source: @sha_zdiii.', 'Photography & Realism', 'Ultra-realistic cozy Japanese-Korean café photography featuring a cute young [Japanese/Korean] couple sitting together naturally in a trendy aesthetic café. The young couple should look stylish and youthful, wearing [fashion style/outfit colors], smiling softly and enjoying desserts together.

The table is beautifully filled with [desserts/foods] such as pancakes, strawberry cakes, macarons, croissants, pastries, iced coffees, matcha lattes, fruit desserts, and aesthetic drinks arranged in a visually satisfying composition. Add small aesthetic café props like [flowers/ribbons/books/candles/pearls/notebooks] on the table for a premium Pinterest moodboard feel.

Soft [lighting style] lighting enters through the café windows creating dreamy highlights, creamy shadows, glossy reflections on drinks, and realistic dessert textures. Background should contain softly blurred [Japanese/Korean] signs, glowing café boards, handwritten Japanese text, neon typography, and aesthetic city café elements for an authentic Tokyo/Seoul vibe.

Add cute scrapbook-style doodles and handwritten notes around the image in [doodle color] ink - tiny hearts, stars, sparkles, ribbons, arrows, smiley sketches, bows, diary stickers, and handwritten café notes.

Color palette should focus on [color theme] tones. Style inspired by viral Pinterest café photography, Korean lifestyle aesthetics, Japanese cozy café culture, dreamy Gen-Z romance mood, shallow depth of field, cinematic composition, ultra realistic food textures, soft blurry background, ultra detailed realistic photography, clean aesthetic layout, 8k.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 426, '@sha_zdiii', 'https://x.com/sha_zdiii/status/2054047328420634927', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-426', '/images/case426.jpg', 'Ultra-realistic Cozy Japanese-korean Cafe Photography Featuring a Cute', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-425', 'Case 425 Photography and Realism Template', 'Template imported from awesome-gpt-image-2 case 425. Source: @XSydneyFan.', 'Photography & Realism', '{
  "prompt": "Vertical poster collage design, beige background, four stacked horizontal rounded rectangles containing black and white cinematic portraits of the same young woman wearing sunglasses in different stylish poses. Foreground features a full-color high-quality cutout of the woman on the left side, wearing a pink mauve fitted shirt, black pants, sunglasses, confident cool pose, modern fashion editorial style, soft studio lighting, ultra realistic, premium magazine aesthetic, depth and shadow effects, clean minimal layout, 2:3 aspect ratio.",
  "aspect_ratio": "2:3"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 425, '@XSydneyFan', 'https://x.com/XSydneyFan/status/2054054476429009086', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-425', '/images/case425.jpg', 'Case 425 Photography and Realism Template', '["Poster","Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-424', 'Hyper-realistic Cinematic Fmcg Billboard Advertising Poster for Chupa', 'Template imported from awesome-gpt-image-2 case 424. Source: @Diplomeme.', 'Products & E-commerce', 'Hyper-realistic cinematic FMCG billboard advertising poster for Chupa Chups India, focusing on playful energy, bold flavor explosion, and Gen-Z candy culture.

Scene: a giant glossy Chupa Chups lollipop floating above a vibrant Indian street at night, candy shards and liquid flavor bursts exploding outward mid-air.

Environment: neon-lit urban backdrop inspired by Mumbai nightlife, glowing signage, reflective wet streets, colorful haze.

Subject: oversized strawberry swirl lollipop as the hero object, ultra-detailed glossy texture, cinematic flavor splash motion.

Visual storytelling: iconic Chupa Chups flower logo glowing subtly on wrapper, reflections visible on wet surfaces and candy syrup splashes.

Composition: dramatic low-angle shot, giant centered product dominating frame, dynamic explosion spreading diagonally across billboard composition.

Typography:
top left - Chupa Chups logo.
center massive - "UNWRAP THE FUN" ultra bold playful typography.
behind product (oversized layered text) - "LICK / SPIN / REPEAT".
mid-left - "FLAVOR THAT POPS." bold condensed font.
bottom left - "STRAWBERRY BURST · GLOBAL ICON · 2026 EDITION".
bottom right - "http://chupachups.com".
left vertical edge - "FUN · FLAVOR · CANDY CULTURE".

Typography style: playful bold sans-serif, glossy layered opacity, oversized billboard scale.

Color palette: vibrant reds, yellows, pinks, neon orange accents, glossy candy textures.

Lighting: dramatic neon backlight with glowing highlights and candy reflections.

Atmosphere: sugar particles, mist, syrup splashes, floating candy dust.

Mood: energetic, youthful, addictive, vibrant.

Shot on ARRI Alexa Mini LF, 35mm anamorphic, HDR, ultra cinematic, premium FMCG billboard style, 4:5 portrait.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 424, '@Diplomeme', 'https://x.com/Diplomeme/status/2054061713583219149', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-424', '/images/case424.jpg', 'Hyper-realistic Cinematic Fmcg Billboard Advertising Poster for Chupa', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-423', 'Generate an Illustration of Me as You Imagine', 'Template imported from awesome-gpt-image-2 case 423. Source: @heyfatema.', 'Illustration & Art', 'Generate an illustration of "me" as you imagine it. Features include a Japanese illustration style, distinct character features, natural emotional expressions, a half-body composition, dynamic poses, exquisite clothing details, a hand-drawn graffiti style, ink splatter strokes, free-flowing lines, a blend of pastels and ink, a comic sketch texture, a minimalist white background, surrounding symbolic elements, a strong atmosphere, high detail, and high quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 423, '@heyfatema', 'https://x.com/heyfatema/status/2053703602246668607', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-423', '/images/case423.jpg', 'Generate an Illustration of Me as You Imagine', '["UI","Illustration","Character"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-422', 'Cinematic Survival Thriller Storyboard Prompt Create a Premium', 'Template imported from awesome-gpt-image-2 case 422. Source: @zulkarnaimx.', 'Scenes & Storytelling', 'Cinematic Survival Thriller Storyboard Prompt

Create a premium cinematic storyboard presentation sheet for a prestige winter survival thriller.
Ultra-detailed professional film pre-production layout, clean editorial design, grayscale blueprint background with labeled sections and technical annotations.
Aspect ratio 16:9 horizontal master board.

SHARED CHOICES HEADER

* Cut Count: 10
* Color Palette: icy blue + steel gray + pine green + ember amber
* Environment Fingerprint: snow-covered pine clearing, overturned horse carcass, torn campsite debris, looming conifer forest, drifting winter fog

---

1. CHARACTER REFERENCE

A realistic South Asian man in his early 30s wearing a dark charcoal business suit, white dress shirt, black tie, polished black shoes.
Snow dusted across shoulders and hair.
Calm but haunted expression.
Show:

* front view
* side profile
* back view
* facial close-up
* side close-up
* costume fabric detail
* damaged sleeve detail
* shoes in snow

Character notes:
"An intelligent city professional trapped in a brutal wilderness.
Outer composure slowly cracks under primal fear.
Suit = identity, burden, and last thread of control."

Palette swatches:

* icy blue
* steel gray
* pine green
* ember amber

---

2. ENVIRONMENT / SET DESIGN

Top-down aerial map of a snowy forest clearing at dusk.
Dead horses partially buried in snow.
Destroyed campsite tents.
Blood trails across frozen ground.
Dense dark pine trees forming a claustrophobic wall around the clearing.
Heavy winter fog drifting through the forest.

Add cinematic camera movement markers:

1. Crane-down
2. Track
3. Push-in
4. Handheld
5. Steadicam
6. Pan-right
7. Dolly-in
8. Rack-focus
9. Arc shot
10. Pull-out

Include arrows and overhead cinematic blocking diagram.

Side elevation panel:

* descending crane shot
* fog layers
* silhouette scale reference
* conifer enclosure composition

Location elements legend:

* tree line
* torn campsite
* horse carcass debris
* blood-stained snow
* main character
* wolf approach zones

---

3. STORYBOARD (10 CUTS)

CUT 1

Wide aerial crane-down shot over frozen clearing.
Tiny suited man surrounded by devastation.
Moody blue dusk lighting.

CUT 2

Tracking medium shot beside the man walking cautiously through snow and ripped tents.
Wind moving fabric debris.

CUT 3

75mm close-up push-in on face.
Cold breath visible.
Fear slowly emerging in his eyes.

CUT 4

Extreme close-up handheld shot of trembling hand gripping torn frozen fabric near blood-covered snow.

CUT 5

Steadicam medium shot revealing wolves emerging between trees behind him.

CUT 6

Pan-right wide shot sweeping across forest edge.
Multiple wolf silhouettes visible in fog.

CUT 7

Over-the-shoulder dolly-in toward alpha wolf approaching slowly through snow.

CUT 8

Rack-focus insert shot shifting focus from frozen hand to wolf tracks in snow.

CUT 9

Arc shot circling around the man as wolves tighten formation.
Snow and pine branches moving in icy wind.

CUT 10

Close-up pull-out shot from his exhausted face revealing the full massacre behind him in fading ember dusk light.

---

4. LIGHTING / MOOD / STYLE NOTES

* icy dusk ambience
* cold blue backlight
* ember sunset glow fading through fog
* wet fabric specular highlights
* cinematic volumetric fog
* snow particles drifting through frame
* high-contrast prestige thriller realism

Mood keywords:

* isolation
* winter dread
* survival instinct
* prestige thriller realism
* primal tension
* psychological fear

Cinematography notes:

* anamorphic lenses (40mm / 50mm / 75mm / 100mm)
* shallow depth of field
* compressed forest layers
* natural handheld movement
* realistic snow atmosphere
* cinematic Hollywood survival thriller aesthetic
* ultra detailed
* photorealistic
* film grain
* 8k production design board
* premium movie pitch deck style', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 422, '@zulkarnaimx', 'https://x.com/zulkarnaimx/status/2053723774680535538', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-422', '/images/case422.jpg', 'Cinematic Survival Thriller Storyboard Prompt Create a Premium', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-421', 'Ultra-realistic Creative Portrait Taken with an Iphone, Identity', 'Template imported from awesome-gpt-image-2 case 421. Source: @Ciri_ai.', 'Photography & Realism', 'Ultra-realistic creative portrait taken with an iPhone, identity accurately preserved from the reference image. A woman stands inside a store, facing a glass display window or a reflective wall, photographed from a slightly elevated frontal angle. She holds a smartphone horizontally in front of her face, covering her eyes and the upper part of her face. The phone''s screen points at the camera and clearly displays a real-time image of her face.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 421, '@Ciri_ai', 'https://x.com/Ciri_ai/status/2053535379618423118', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-421', '/images/case421.jpg', 'Ultra-realistic Creative Portrait Taken with an Iphone, Identity', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-420', 'Use the Uploaded Portrait Photo as the Appearance', 'Template imported from awesome-gpt-image-2 case 420. Source: @Shinning1010.', 'Photography & Realism', 'Use the uploaded portrait photo as the appearance reference for the person. Create a bright photorealistic outdoor portrait of a young woman lying on a red running track on a modern white arch pedestrian bridge. Ultra-wide low-angle selfie perspective, her arm reaching toward the camera in the foreground, relaxed pose, wired headphones around her neck, white sleeveless top, loose gray pants, black hair spread on the ground. Clean blue sky with soft white clouds, strong midday sunlight, crisp shadows, high clarity, fresh youthful mood, architectural symmetry, realistic skin texture, cinematic composition, 3:4 vertical image

Negative Prompt:

watermark, logo, text, caption, signature, AI label, extra fingers, deformed hands, distorted face, wrong identity, duplicate person, blurry face, low resolution, over-smoothed skin, plastic skin, unnatural anatomy, bad perspective, messy background, harsh artifacts, overexposure, underexposure', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 420, '@Shinning1010', 'https://x.com/Shinning1010/status/2053521749967352285', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-420', '/images/case420.jpg', 'Use the Uploaded Portrait Photo as the Appearance', '["Realistic","Brand","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-419', 'Create a Crisp, Clean Infographic Storyboard Poster for', 'Template imported from awesome-gpt-image-2 case 419. Source: @TechieBySA.', 'Scenes & Storytelling', 'Create a crisp, clean infographic storyboard poster for THE CROISSANT BAKER. Wide 16:9 layout, white background, black borders, bold black typography, premium Pixar 3D stylized rendering, bright vivid colors - warm golden yellows, rich buttery creams, flaky browns, soft pastry whites, warm French bakery morning light.
Top header:

THE CROISSANT BAKER
TOTAL VIDEO TIME: 12 SECONDS
8 SHOTS · WARM · FLAKY · IRRESISTIBLE
Legend icons: ACTION, HEAT, TIME HINT, INGREDIENT
Thin warm golden accent line running full width beneath header

Same Pixar-style young French male baker throughout: white baker''s jacket, flour-dusted hands, warm authentic French boulangerie setting, marble countertop, warm morning light streaming through windows, bread racks in background. Bright, warm, delicious. Every panel a completely different composition and color.
8 panels:

THE OPENER - Wide shot of baker arriving at the boulangerie before dawn, tying apron, switching on the warm kitchen lights, marble counter visible, bread racks behind, flour dusting the air, full world established, bright and cinematic
THE BUTTER BLOCK - Baker slams a massive cold block of European butter onto the marble counter with both hands, dramatic impact, flour cloud puffing up, close-up on hands, this is the bones moment - the start of everything
THE LAMINATION - Baker folding the dough over the butter block precisely, rolling pin pressing down hard, layers building, side angle shot showing the beautiful layering beginning, confident and skilled
THE ROLL - Dough rolled out into a large thin sheet, baker leaning into the rolling pin with full body weight, marble counter, flour dusting everywhere, wide shot showing the scale of the dough
THE SHAPE - Triangles cut from the dough, baker rolling each one from the wide end into a tight crescent, hands moving fast and confident, close-up on the shaping, beautiful and precise
THE EGG WASH - Baker brushing golden egg wash over each shaped croissant with a pastry brush, each one glistening beautifully, close-up overhead angle, warm golden color, stunning composition
THE OVEN - Croissants slid into the blazing hot oven on a tray, oven door closed, through the oven glass croissants visibly puffing and turning deep golden, layers separating dramatically, warm orange glow
THE TEAR - Baker pulls a perfect golden croissant from the rack, holds it up, tears it open slowly revealing hundreds of impossibly flaky buttery layers inside, steam escaping, butter glistening - this is the cheese pull moment, the hero shot of the entire video

Footer:

VIDEO FLOW: 8 shots × 1.5s = 12 seconds. Butter block to the tear.
CAMERA TIPS: wide on opener, close-up on butter slam and shaping, side angle on lamination, overhead on egg wash, oven glass for panel 7, extreme close-up on the tear reveal
LIGHT & STYLE: warm golden French bakery morning light, buttery cream tones, flour dust in the air, bright vivid Pixar colors, shallow depth of field on close-ups
BAKER NOTES: one baker, one perfect croissant, one irresistible tear. The lamination layers and the final tear are everything - make them stunning.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 419, '@TechieBySA', 'https://x.com/TechieBySA/status/2053523784481554759', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-419', '/images/case419.jpg', 'Create a Crisp, Clean Infographic Storyboard Poster for', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-418', 'Create a Vertical Mid-century Travel Poster for Featuring', 'Template imported from awesome-gpt-image-2 case 418. Source: @Goodmanprotocol.', 'Posters & Typography', 'Create a vertical mid-century travel poster for [CITY NAME] featuring [LANDMARK]. Use a strict 3-color palette: cream paper, black technical linework, and [COLOR].
Style: Minimalist isometric bird''s-eye view with ultra-fine hatching and screen-print texture.
Color usage: Solid flat [COLOR] for the entire sky and small accents on roofs or streets. No gradients.
Text: Bold sans-serif "[CITY NAME]" at top in cream, with the local language name in smaller cream text below.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 418, '@Goodmanprotocol', 'https://x.com/Goodmanprotocol/status/2053523890744545437', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-418', '/images/case418.jpg', 'Create a Vertical Mid-century Travel Poster for Featuring', '["Poster"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-417', 'Ultra Realistic Vintage Indonesian Catnip Advertisement Poster, Retro', 'Template imported from awesome-gpt-image-2 case 417. Source: @NyaiiBubu.', 'Posters & Typography', 'Ultra realistic vintage Indonesian catnip advertisement poster, retro 1970s paper texture, distressed print, faded colors. A black-and-white tuxedo cat wearing cute vintage housewife clothes floating happily in the air after smelling catnip, euphoric expression, swirling catnip leaves, absurd Indonesian meme energy. Bold retro typography: "BIKIN KUCING SENENG FLY!" fake catnip jar product, old-school badges, price tag, nostalgic warung advertisement aesthetic, cinematic lighting, grain, scratches, authentic aged poster look.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 417, '@NyaiiBubu', 'https://x.com/NyaiiBubu/status/2053075349424992532', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-417', '/images/case417.jpg', 'Ultra Realistic Vintage Indonesian Catnip Advertisement Poster, Retro', '["Poster","Realistic","Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-416', 'Create a New Image Using the Provided Female', 'Template imported from awesome-gpt-image-2 case 416. Source: @ZaraIrahh.', 'Characters & People', 'CREATE A NEW IMAGE USING THE PROVIDED FEMALE SUBJECT AS THE ONLY REFERENCE. Preserve her exact facial features, identity, and characteristics with zero alteration.

MAIN SUBJECT - EARTH ELEMENT
She represents the Earth element as a whole: grounded, elegant, sensual, calm, stable, patient, quietly powerful, and naturally luxurious. Relaxed grounded posture, standing or seated, soft natural hand placement, composed feminine body language, rooted presence.

OUTFIT
Single cohesive Earth-inspired editorial look in olive, sage, taupe, mocha, beige, clay, cream, moss, and warm neutrals. Soft-structured elegant silhouette with subtle tailoring, draping, texture contrast, or layered structure. Fabrics: linen, cotton, matte satin, knit, suede-like textures, soft tailoring. Minimal refined gold or natural-toned accessories.

HAIR
Soft ash brown with natural dimension. Healthy, polished, softly voluminous waves or smooth blowout with subtle shine, controlled texture, face-framing strands, grounded and luxurious feel.

MAKEUP
Korean soft-glow base with earthy tones. Warm beige-rose, terracotta, tawny, or nude peach blush. Eyes in taupe, mocha, caramel, muted bronze, olive-brown. Soft liner, champagne-beige highlight, satin or velvet nude/mocha lips. Overall polished, sensual quiet-luxury aesthetic.

ENVIRONMENT
Grounded editorial Earth-inspired setting with stone, wood, linen, botanicals, dried plants, natural fabrics, rustic-luxury styling, warm daylight or diffused editorial lighting, soft shadows, serene cinematic stillness. Palette: cream, olive, moss, clay, taupe, beige, muted green, warm brown.

CHIBI MINI-ME SYSTEM
Surround her with multiple medium-sized realistic 3D chibi mini-me versions with identical face, hair, and identity. High-end doll-like styling with oversized heads, petite bodies, glossy eyes, realistic hair, detailed makeup, miniature fashion outfits, soft cinematic 3D lighting.

EARTH SIGN CHIBIS
Taurus - sensual soft-luxury romantic styling, knit or elegant feminine neutral outfit, rich textures, gold accents. Ultra-long segmented twin low ponytails tied with white fabric bands flowing dramatically around the frame.
Virgo - refined perfectionist aesthetic with polished minimalist tailoring, clean lines, structured mini dress or sophisticated co-ord styling.
Capricorn - sleek power-dressing with blazer dress or tailored set, sharp silhouette, understated luxury. Hair pulled into ultra-long sculptural braid wrapped with gold chains and metallic ornaments.

DOODLES + SCRAPBOOK OVERLAY
Hand-drawn earthy scrapbook doodles: leaves, vines, flowers, branches, mushrooms, butterflies, stars, sparkles, stones, hearts, sun doodles, botanical icons. Cozy ink-pen texture.

Handwritten text:
"EARTH SIGNS"
"grounded and glowing"
"soft strength"
"rooted in beauty"
"quiet luxury"
"stable energy"
"calm power"
"naturally magnetic"

Fact bubbles:
"Element: Earth"
"Signs: Taurus, Virgo, Capricorn"
"Traits: grounded, loyal, elegant"
"Energy: stable, refined, dependable"

COMPOSITION
Main subject centered and dominant. Chibis placed dynamically around shoulders, hands, sides, and lower frame. Doodles layered naturally throughout like a scrapbook. Balanced, expressive, premium composition.

STYLE
Cinematic editorial lifestyle image, fashion-meets-illustration hybrid, high detail, sharp focus, warm neutral tones, subtle realism grain, realistic human rendering with stylized 3D chibis and hand-drawn overlays. Social-media-ready premium aesthetic.

CAMERA
Eye-level or slightly above, medium full-body or 3/4 framing, 35mm or 50mm lifestyle portrait look, crisp details with soft atmospheric depth.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 416, '@ZaraIrahh', 'https://x.com/ZaraIrahh/status/2053075976469512686', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-416', '/images/case416.jpg', 'Create a New Image Using the Provided Female', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-415', 'A4 , : , ,;, , , :', 'Template imported from awesome-gpt-image-2 case 415. Source: @TanLuAI.', 'History & Classical Themes', '请基于【孙悟空】生成一张竖版 A4「东方神话人物志」百科海报。

你是一名东方神话视觉设定师、古籍图谱设计师和中文信息图设计师。请根据【人物名称】在东方神话、民间传说、古籍、戏曲、文学或传统文化中的已知形象，生成一张内容完整、视觉统一、具有东方神话气质的人物档案海报。

最重要原则：
全部内容必须围绕【人物名称】展开，不要套用通用神仙模板。
人物形象、法器、坐骑、神通、典故、象征物、背景场景都必须符合【人物名称】的神话设定。
如果该人物存在多个传说版本，请采用最广为人知的版本；存在异文时，可以在相关板块简短标注"传说版本不一"。
不确定的信息不要强行编造，可写"民间传说中多有异文"或"相关记载较少"。
不要使用北欧符文、维京图腾、哥特边框、西方盔甲、欧式城堡、西幻恶魔角、赛博朋克元素。
整体必须是东方神话审美，而不是"西幻人物换中式衣服"。
整体视觉风格：
东方神话史诗感，融合《山海经》异兽图谱、敦煌壁画、青绿山水、唐代人物画、宋元古画、青铜器纹样、古籍注疏和符箓篆刻风格。画面庄重、神秘、古雅、华丽但克制。
画面构图：

竖版 A4 海报，中轴对称布局。中央为【人物名称】的全身或半身主视觉，姿态庄严，有神性和叙事感。人物服饰、发冠、法器、神态、灵兽、背景都要符合该人物传说。左右两侧为信息卡片，底部为核心总结。四周使用云雷纹、回纹、青铜纹、祥云纹、卷草纹、山海纹、篆刻印章式边框。
主标题："【人物名称】"
副标题："东方神话人物志｜根据该人物神话传说生成"
顶部精神题记：请根据【人物名称】的核心精神，自动生成一句古雅、凝练、有哲学意味的题记。题记要体现该人物背后的价值观、生命姿态或精神内核，而不是说明性文字。不要写"非史实考证""仅供参考""传说版本"等免责声明。字数控制在 12-28 字，适合放在标题下方。题记应与人物高度绑定，不要套用"守护苍生""大道无边"等空泛句式。

请生成以下内容板块：
【1. 神格身份】说明【人物名称】在东方神话体系中的身份定位。
【2. 神话源流】说明该人物主要出自哪些神话、古籍、民间传说、小说、戏曲或宗教信仰。
【3. 司职权柄】总结该人物掌管或象征的领域。
【4. 形象特征】描述该人物的典型外貌、服饰、神态、姿态和视觉气质。
【5. 法器神通】展示该人物最具代表性的法器、兵器、符咒、神通或能力。
【6. 灵兽坐骑 / 随身象征】如果【人物名称】有坐骑、灵兽、伴生生灵，请展示其名称、形态和寓意。如果没有明确坐骑，请改为"随身象征物"或"相关意象"。不要强行给每个人物安排龙、凤、仙鹤或麒麟。
【7. 典故出处】列出 2-4 个与【人物名称】相关的经典故事、传说片段或文化典故。不要虚构不存在的典故。若版本不一，请标注"异文较多"。
【8. 象征意象】提炼该人物最核心的视觉符号。符号必须与【人物名称】相关。
【9. 神话谱系】说明该人物与其他神话人物、阵营、族属或体系的关系。如果谱系不明确，请写"谱系传说不一"。
【10. 文化影响】说明该人物在民俗、节日、祭祀、文学、戏曲、绘画、庙宇、影视或现代文化中的影响。
【11. 精神内核】从神话叙事角度总结该人物象征的精神。这里只分析神话形象，不推断真实人物性格。
【12. 核心总结】用一段古雅但易懂的中文总结【人物名称】："【人物名称】在东方神话中象征......，其形象融合了......，代表着......。"

视觉版式要求：
顶部：大标题 + 副标题 + 精神题记。
中央：人物主视觉，气势庄重，细节丰富。
左侧栏目：神格身份、神话源流、司职权柄、形象特征、法器神通。
右侧栏目：灵兽坐骑/随身象征、典故出处、象征意象、神话谱系、文化影响。
底部：精神内核 + 核心总结。
可加入小型图标、注释线、古籍标签、卷轴卡片、青铜铭牌、朱砂印章、符箓纹样。
信息卡片像古书页、玉简、青铜牌、卷轴或碑铭，不要像现代科技 UI。

材质与纹样：
宣纸肌理、矿物颜料、鎏金线条、朱砂印章、墨色晕染、青铜器铭文、云雷纹、回纹、祥云纹、山水纹、敦煌藻井纹样。

配色规则：
根据【人物名称】的属性自动选择东方配色。火焰 / 战斗 / 护法：朱砂、玄黑、鎏金、赤红。月亮 / 水系 / 清冷神祇：黛青、银白、月白、石蓝。山川 / 木系 / 自然神灵：石绿、青黛、玉白、赭石。帝王 / 天庭 / 尊神：鎏金、玄黑、朱砂、玉白。妖灵 / 山海异兽：墨黑、铜绿、暗金、赭红。不要所有人物都使用同一套配色。

文字要求：
中文必须清晰可读，标题大气，正文简短准确。不要乱码、伪文字、错别字、文字重叠或裁切。如果空间不足，优先压缩正文，但保留所有板块标题。

避免：
北欧符文、维京风、哥特边框、西方盔甲、欧式城堡、魔幻游戏 UI、赛博朋克、现代科技感、过度暗黑、随机龙凤、无关法器、模板化神仙形象、与【人物名称】无关的典故、空泛精神题记。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 415, '@TanLuAI', 'https://x.com/TanLuAI/status/2053073436122243364', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-415', '/images/case415.jpg', 'A4 , : , ,;, , , :', '["UI","Infographic","Poster"]'::jsonb, '["Fashion","Story","History"]'::jsonb, FALSE, TRUE),
    ('case-414', 'A Close-medium Shot of a Young Japanese Woman', 'Template imported from awesome-gpt-image-2 case 414. Source: @ToroJushiAi.', 'Photography & Realism', 'A close-medium shot of a young Japanese woman in her bedroom on an ordinary morning, captured in authentic daily life photography as a natural candid moment. She is seated sideways on the edge of the bed, not fully awake yet, photographed from a slightly elevated three-quarter angle with cool-to-warm morning window light entering from the left.
East Asian young woman in her early 20s. Almond-shaped eyes with soft natural single eyelids, slightly elongated eye corners, still carrying the heaviness of just waking. Straight refined nose with a delicate bridge. Skin tone fair to light beige - skin subsurface scattering visible under the soft directional morning window light, specular micro-highlights catching gently on her cheekbone and nose ridge, fine skin texture perceptible, no makeup. Naturally straight fine black hair loosely gathered, slightly disheveled from sleep.
She wears a loose oversized cotton sleep shirt and soft shorts, nothing styled. Her gaze drifts toward the window, posture relaxed and unhurried, one hand resting on her knee, the other barely holding a phone face-down. The bedroom background suggests real life - slightly unmade linen, a potted plant near the window partially in shadow, small cluttered bedside items. Two or three stray hairs fall across her cheek in natural asymmetric displacement, not geometrically placed.
Soft directional morning light from a side window, cool-to-warm transition across her face and shoulder, long gentle shadows on the bedding behind her. The mood is quietly adrift - not sad, not performing, just suspended in the unhurried first minutes of the day. Subtle ISO 400 film grain in shadow areas, photographic noise texture not CG render smoothness. Aspect ratio 2:3. No watermark, no text overlay, not cartoon, not digitally painted, not illustration, not anime.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 414, '@ToroJushiAi', 'https://x.com/ToroJushiAi/status/2053078195482632421', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-414', '/images/case414.jpg', 'A Close-medium Shot of a Young Japanese Woman', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-413', 'Create a Raw Contemporary Dance Performance Storyboard Focused', 'Template imported from awesome-gpt-image-2 case 413. Source: @ogbenniasamuel2.', 'Scenes & Storytelling', 'Create a raw contemporary dance performance storyboard focused on intense physical movement and live singing. Use reference image for the character. 16:9 storyboard sheet, 12 cinematic panels.

The actual storyboard drawings must be black and white only: rough pencil lines, minimal detail, fast gesture drawing energy, simple anatomy construction and strong silhouette readability. Keep the artwork lightweight, dynamic and unfinished like early choreography previs.

A solitary female performer sings continuously while executing an emotionally charged contemporary dance routine inside a massive empty brutalist hall.

The choreography is aggressive, fluid and constantly evolving: rapid turns, floor slides, crawling transitions, sharp body isolations, trembling hands, extreme balance shifts, hair whips, lunges, jumps, collapsing movements and distorted sculptural poses.

Every panel must contain visible motion and strong body momentum. Avoid static standing poses. The performer should feel trapped between ritual, exhaustion and emotional release.

Use cinematic arthouse camerawork with handheld energy, whip pans, orbit movement, overhead shots, side silhouettes, aggressive close-ups, long lens compression and extreme negative space.

the environment minimal: empty space, smoke, fabric motion, harsh light beams and wet floor reflections only.

Annotation color system: red arrows = body movement blue arrows = camera movement green marks = framing / composition notes orange marks = lighting direction purple marks = vocal / emotional emphasis black text = short lens notes and panel labels No timestamps.

End with one overwhelming final movement pose beneath a harsh isolated spotlight.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 413, '@ogbenniasamuel2', 'https://x.com/ogbenniasamuel2/status/2053088572031250799', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-413', '/images/case413.jpg', 'Create a Raw Contemporary Dance Performance Storyboard Focused', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-412', 'Use Reference Image as Style Guide', 'Template imported from awesome-gpt-image-2 case 412. Source: @Mind_Boticni.', 'Photography & Realism', 'Use reference image as style guide.
Surreal minimalist fashion editorial photography with vibrant oversized colorful buttons as main visual theme (cyan, orange, yellow, red palette), glossy 3D surface design, clean studio lighting, ultra-smooth gradients, and high-end commercial fashion look.
Split-frame composition:

Left side: full-body female model standing from top to bottom, wearing bold minimalist fashion outfit inspired by reference style, confident pose, clean studio background filled with oversized colorful buttons, cinematic lighting, soft shadows, ultra-clean composition.

Right side (vertically split into two parts):
Top-right: half-body female model, different face, different pose, different outfit variation inspired by same button aesthetic, different background color mood.
Bottom-right: another half-body female model, completely different expression and pose, different styling, different background tone, maintaining same surreal button universe aesthetic.

Each section visually distinct but unified by the colorful button-inspired design language, glossy surfaces, soft studio reflections, and fashion magazine editorial feel.
Hyper-realistic, cinematic lighting, ultra-clean composition, high-end luxury campaign style, depth, contrast, 8k, 1:1 aspect ratio --style raw --v 6 --ar 1:1', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 412, '@Mind_Boticni', 'https://x.com/Mind_Boticni/status/2053082199436759258', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-412', '/images/case412.jpg', 'Use Reference Image as Style Guide', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-411', 'Design a Luxury Minimalist Poster Centered on a', 'Template imported from awesome-gpt-image-2 case 411. Source: @iamaiistudio.', 'Architecture & Spaces', 'Design a luxury minimalist poster centered on a famous architectural landmark of your choice ([building name]). The focal element is an illustrated rendering of the building. Behind it, place one giant bold English word in a design-forward typeface whose character matches the building''s identity, with smaller body copy nearby describing its design philosophy. The composition should read as an ultra high-end art poster. Use a restrained, low-key color palette where graphic elements interlock with the architecture, appearing as if they form part of its structural components or extend outward from its silhouette.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 411, '@iamaiistudio', 'https://x.com/iamaiistudio/status/2053084576520573269', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-411', '/images/case411.jpg', 'Design a Luxury Minimalist Poster Centered on a', '["UI","Poster","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-410', 'Create a Trending Anime Art Style Image from', 'Template imported from awesome-gpt-image-2 case 410. Source: @Zyrellix.', 'Illustration & Art', 'Create a trending anime art style image from the uploaded subject. Use confident line-work with slight variation and minimal cel shading using flat shadow shapes. Use bright, saturated colors and clean graphic lighting. The style is defined by exaggerated, cartoonish character proportions featuring highly expressive, simplistic facial features that allow for immense emotional range, with highly varied stretched anatomy.Transform the environment into a slightly warped space with playful perspective distortion and simplified objects. Composition and tone should be energetic, lively, and comedic in a fully stylized, non-realistic world', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 410, '@Zyrellix', 'https://x.com/Zyrellix/status/2052766810500649197', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-410', '/images/case410.jpg', 'Create a Trending Anime Art Style Image from', '["Realistic","Character"]'::jsonb, '["Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-409', 'Please Redraw the Attached Image in the Most', 'Template imported from awesome-gpt-image-2 case 409. Source: @Ciri_ai.', 'Illustration & Art', 'Please redraw the attached image in the most clumsy, messy, and hopelessly pathetic way possible. Use a white background and make it look like it was drawn in MS Paint with a mouse. It should vaguely resemble the original, but not really - like it''s kind of correct in some places yet strangely off and awkward overall. Emphasize a low-quality, pixelated look, and make it appear ridiculously badly drawn. ...Actually, never mind - just draw it however you want in a sloppy way.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 409, '@Ciri_ai', 'https://x.com/Ciri_ai/status/2052969749878059362', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-409', '/images/case409.jpg', 'Please Redraw the Attached Image in the Most', '["Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-408', 'Dreamy Cinematic Study Aesthetic, Young Asian Girl with', 'Template imported from awesome-gpt-image-2 case 408. Source: @Sairah_0.', 'Photography & Realism', 'Dreamy cinematic study aesthetic, young Asian girl with long dark hair studying outdoors at a wooden table during golden hour, cozy oversized green sweater and scarf, writing in notebook beside open laptop, historic university campus in background, warm sunset lighting, soft glow, autumn atmosphere, aesthetic doodles and handwritten notes floating around image, kawaii scrapbook style overlays, pastel hearts and stars, motivational text, shallow depth of field, nostalgic film grain, soft beige and warm green tones, peaceful productive vibe, ultra detailed, Pinterest aesthetic, photorealistic, cozy academia style, 35mm film look', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 408, '@Sairah_0', 'https://x.com/Sairah_0/status/2052969695406325875', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-408', '/images/case408.jpg', 'Dreamy Cinematic Study Aesthetic, Young Asian Girl with', '["Realistic","Product"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-407', 'Create a Premium Square Designed as a Scientific', 'Template imported from awesome-gpt-image-2 case 407. Source: @YaZoraiz.', 'Charts & Infographics', 'Create a premium square "neuro-AI hybrid system infographic" designed as a scientific cognitive engineering handbook page.

Visual Direction:
• 1:1 composition
• dark neutral background with glowing neural network overlays
• palette: electric blue, violet, soft white, silver
• elegant scientific typography and modular panels
• central ultra-detailed human brain + AI circuit fusion render

Main Subject:
A realistic human brain merging with AI neural networks and digital circuitry.

Include callouts:
• memory encoding system
• AI augmentation layer
• cognitive signal pathways
• emotional response mapping
• sensory integration nodes
• neural data transfer system
• learning adaptation loops

Modules:
• Brain Function Overview
• AI Enhancement Layers
• Signal Flow Diagram
• Cognitive Performance Metrics
• Human vs AI Comparison Chart
• Neural Safety Protocols
• Future Evolution Path

Style:
"neuroscience + AI engineering manual", "high-end cognitive systems diagram"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 407, '@YaZoraiz', 'https://x.com/YaZoraiz/status/2052968427514708371', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-407', '/images/case407.jpg', 'Create a Premium Square Designed as a Scientific', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-406', 'Luxury Futuristic Streetwear Campaign Poster Featuring a Confident', 'Template imported from awesome-gpt-image-2 case 406. Source: @AIwithkhan.', 'Posters & Typography', 'Luxury futuristic streetwear campaign poster featuring a confident athletic girl sitting on a gigantic oversized retro gaming controller instead of sunglasses, clean editorial advertising aesthetic, massive bold typography in the background saying "ENERGY", glossy reflective floor, cinematic studio lighting, pastel neon color palette with lavender, silver, and soft cyan tones.

The girl has curly shoulder-length hair, relaxed confident attitude, wearing an oversized white graphic T-shirt, loose black athletic shorts, high white socks, and modern sneakers. Casual sporty fashion styling, natural makeup, youthful Gen-Z streetwear vibe. She is casually seated on top of the giant gaming controller with one leg hanging down and one knee raised, looking away from the camera with cool effortless confidence.

The oversized gaming controller is ultra detailed with futuristic buttons, glowing accents, premium matte materials, and soft LED reflections. Minimal luxury branding on the controller side. Giant cream-colored typography fills the background vertically in a bold condensed font.

Environment: seamless studio backdrop with glossy floor reflections, high-end commercial fashion photography, ultra realistic textures, dramatic shadows, premium editorial layout, modern tech-fashion advertisement aesthetic, symmetrical composition, luxury product campaign style, 4:3 aspect ratio, hyper detailed, photorealistic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 406, '@AIwithkhan', 'https://x.com/AIwithkhan/status/2052973449107349725', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-406', '/images/case406.jpg', 'Luxury Futuristic Streetwear Campaign Poster Featuring a Confident', '["Poster","Realistic","Product"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-405', 'Recreate This Image in a Paper Craft Style,', 'Template imported from awesome-gpt-image-2 case 405. Source: @oggii_0.', 'Illustration & Art', 'Recreate this image in a paper craft style, simplifying the details to make them suitable for paper craft artwork. Arrange the overall composition to feel visually pleasing, soft, and cute. You may add charming decorative elements such as birds, butterflies, flowers, etc., to enhance the adorable atmosphere while still matching the original image.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 405, '@oggii_0', 'https://x.com/oggii_0/status/2052609040539328759', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-405', '/images/case405.jpg', 'Recreate This Image in a Paper Craft Style,', '["UI"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-404', ',3d,,,,, ,,3d, ,x / Twitter Ui 8k :3:4', 'Template imported from awesome-gpt-image-2 case 404. Source: @you1873118.', 'UI & Interfaces', '动态的豪华商业广告海报，特色是超现实3D渲染的充满活力的年轻女性，以上传的女性面部作为参考，穿着高级亮橙色设计师服装、豪华配饰以及时尚的金色墨镜，自信地从一个巨大的金色智能手机屏幕中爆发出色。她的姿势有力且时尚，一只运动鞋通过强烈的强制透视戏剧性地穿过数字显示屏，踏入现实。

构图在前台强调她白色豪华运动鞋，带有纹理口香糖鞋底，通过电影般的广角镜头失真和浅景深增强。漂浮的闪亮3D社交媒体图标、金色几何元素和豪华品牌图形环绕着她，营造出高端影响者营销美学。

明亮的摄影棚灯光营造出充满活力的优质促销氛围，金属金色手机边缘的丰富反射与哑光织物质地形成对比。主导的橙色、白色和金色调色板传递出超现代豪华X / Twitter 广告氛围。干净的白色背景上带有大胆的编辑排版、优质软件品牌元素、优雅的UI图形、漂浮的互动图标以及时尚的二维码区域。

超现实8K品质、电影般的阴影、精致的商业艺术指导、豪华女性能量、时尚营销美学、现代社交媒体品牌、闪亮反射以及高端数字广告风格。

宽高比：3:4。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 404, '@you1873118', 'https://x.com/you1873118/status/2052624395932455061', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-404', '/images/case404.jpg', ',3d,,,,, ,,3d, ,x / Twitter Ui 8k :3:4', '["UI","Poster","Brand"]'::jsonb, '["Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-403', '3d,,, 3d ,, ,, , ,pixar,,,,8k 9:16 10801440', 'Template imported from awesome-gpt-image-2 case 403. Source: @MrGafish.', 'UI & Interfaces', '将一位气质绝佳的女孩放置在一个显示小红书帖文的3D透明玻璃手机画面中，并重新调整她的身体姿势，使她看起来像是正从屏幕中突破、进入现实世界。其中一只脚必须强烈地朝向观者延伸，采用戏剧化的 3D 透视效果，创造出强烈的深度感与沉浸感。整体姿势需要具有动态感、自然且符合人体结构，就像是在从屏幕中跨步而出的瞬间。

手机屏幕边缘出现真实细腻的玻璃裂纹与数字粒子效果，大量发光的像素碎片与光粒向外扩散，形成富有未来感的"数字破屏"视觉特效。所有碎片与光效自然围绕人物运动方向展开，具有电影级空间层次感。

整体画面采用温暖米色、柔粉色与梦幻紫色渐变背景，结合金粉色夕阳光斑与电影级柔光渲染。Pixar风格与半现实主义融合，超精细材质，柔和景深，电影感光影，8K超高清品质。

将画面优化为竖版【9:16】比例（1080×1440），适用于社交媒体展示。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 403, '@MrGafish', 'https://x.com/MrGafish/status/2052632520563528051', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-403', '/images/case403.jpg', '3d,,, 3d ,, ,, , ,pixar,,,,8k 9:16 10801440', '["Character","3D"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-402', '3d,,,,,,,ui, ,,,,pixar+,,4k,,', 'Template imported from awesome-gpt-image-2 case 402. Source: @MrGafish.', 'UI & Interfaces', '一只手中握着一张3D小红书个人资料卡，卡片中间方形镂空，一个女孩随意地坐在卡片镂空的边缘，温暖的米色和柔和的粉彩美学背景，逼真的深度和阴影，电影般的柔和光线，闪亮光滑的纹理，小红书风格的UI，漂浮的互动图标（点赞、评论、分享）带有发光的霓虹效果，闪光和光晕，背景中温馨的美学布置包括书籍、花瓶里的花和一台复古相机，梦幻氛围，Pixar风格+半现实主义融合，超高品质，4K，居中构图，高端影响者美学', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 402, '@MrGafish', 'https://x.com/MrGafish/status/2052323461268467860', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-402', '/images/case402.jpg', '3d,,,,,,,ui, ,,,,pixar+,,4k,,', '["UI","3D"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-401', 'Create a Stylized Travel Poster / Graphic Collage', 'Template imported from awesome-gpt-image-2 case 401. Source: @SadiaMalik182.', 'Posters & Typography', 'Create a stylized travel poster / graphic collage for [country]. The main subject should be a stylish international tourist visiting [country], clearly presented as a traveler and not a local resident. Show the tourist wearing modern travel fashion, with details such as a camera, backpack, sunglasses, map, or suitcase, exploring the culture and atmosphere of [country]. Place the tourist in a dynamic composition surrounded by iconic architecture, streets, landscapes, landmarks, transportation, food, signage, and cultural elements associated with [country]. Blend realistic character detail with a graphic collage background made of layered paper textures, torn poster edges, sticker elements, halftone dots, editorial typography, and bold geometric shapes. Include authentic visual motifs from [country], but keep the tourist''s appearance and styling globally fashionable and clearly foreign to the setting. Add a large readable headline: "LOST IN [country]". Modern, artistic, premium editorial travel poster aesthetic, balanced layout, print-worthy composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 401, '@SadiaMalik182', 'https://x.com/SadiaMalik182', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-401', '/images/case401.jpg', 'Create a Stylized Travel Poster / Graphic Collage', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-400', '+ : , , : : , :', 'Template imported from awesome-gpt-image-2 case 400. Source: GitHub prompt.', 'UI & Interfaces', '你是一个高端签名设计系统 + 风格人格视觉系统。

任务：
仅基于用户输入的「姓名」，生成一张「多风格签名选择海报（卡片式结构）」。
目标是把名字转译为具有笔势、气质与力量感的签名设计系统，让用户产生选择欲、认同感和分享欲。

输入信息：
姓名：[输入你的昵称]
禁止要求额外信息，必须自动完成气质与风格推断。

隐藏执行逻辑：
1. 字形与笔势分析：
- 结构：疏密、横竖比例、重心位置
- 节奏：连贯、停顿、爆发、收束
- 适配：连笔程度、草写程度、变形空间

2. 气质推断：
清冷、张扬、克制、商业、文艺、松弛、锋利、高级。

3. 生成 6 个签名分支：
- 全部适配该姓名
- 每一个都有明确书写风格
- 差异来自笔势、节奏、结构和收笔方式

整体画面：
9:16 竖版海报，极简、高级、干净、有设计感、适合传播。
背景使用纯白或极浅灰渐变，留白不少于 40%。

顶部标题区：
主标题可用：
「你的名字，适合哪种签名？」
或：
「[姓名] · 签名风格选择」
副标题：
「不同笔势，不同气场」
排版为黑色与灰色，高级字距，留白充足。

签名卡片区域：
使用整齐网格卡片布局，推荐 2 列 × 3 行，共 6 个卡片。
每个卡片统一尺寸、统一间距、整体对齐干净。

卡片样式：
- 轻微圆角 8-16px
- 无明显边框，或极细描边
- 极轻阴影
- 背景为纯白微差、极浅灰，或轻微宣纸 / 磨砂质感
视觉目标接近高级杂志排版，避免强 UI 感、厚卡片和 App 组件感。

签名生成规则：
签名必须基于书写动作生成，避免只做字体变形。
每一个签名风格在生成前，先确定一套明确书写行为规则：
1. 起笔方式：轻触起笔、重压起笔、直接横扫、从左下进入或从中段切入。
2. 连笔结构：前两个字强连笔后面断开、全连笔一气呵成、只连接偏旁。
3. 节奏变化：快到慢再收、慢到爆发再拉伸、或均匀节奏。
4. 结构变形：横向拉长、垂直压缩、整体右倾或左倾、字间重叠或错位。
5. 收笔设计：尾笔长甩、突然收断、回钩、渐隐收尾。

6 种签名方向：
1. 极简理性：接近品牌签名
2. 狂放张力：强烈连笔和拉伸
3. 松弛随性：手写感强
4. 东方行草：飞白和墨感
5. 锋利结构：几何感和断裂
6. 实验风格：允许部分不可读，但需要强设计感

色彩策略：
整体以黑、灰、白为主。每个卡片允许一个极轻微点缀色，例如冷灰蓝、香槟金、墨黑、暖棕、深绿。
避免大面积色块和花哨配色。

底部互动区：
底部居中加入小号灰字：
「选一个，作为你的专属签名。」
或：
「你是第几种？」

光影与质感：
高级棚拍光、柔光环境、细腻阴影、干净空气感。
质感参考 Apple 发布会视觉和高端品牌视觉。

禁止项：
不要字体拼贴，不要普通书法字，不要 UI 卡片风，不要颜色杂乱，不要签名太小，不要排版松散，不要缺乏笔势，不要模板拼接感。

最终目标：
生成一张高级、干净、有秩序、有笔势张力的 6 风格签名选择海报。
用户一眼能选出最像自己的一款签名。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 400, 'GitHub prompt', 'https://github.com/zaizhi-1112/ai-image-extension-playbook/blob/main/signature-image-prompts-gpt-image-2.md', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-400', '/images/case400.png', '+ : , , : : , :', '["UI","Poster","Brand"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-399', 'Use Case: Photorealistic-natural Asset Type: Cinematic Portrait Image,', 'Template imported from awesome-gpt-image-2 case 399. Source: @BubbleBrain.', 'Photography & Realism', 'Use case: photorealistic-natural
Asset type: cinematic portrait image, final target size 1216x1536 portrait

Create a photorealistic image of a fictional adult Korean female idol in her mid-20s, not resembling any real celebrity. Maintain a Japanese negative film look: soft overexposure, faded neutrals, low contrast, subtle grain, and imperfect snapshot framing.

Scene/backdrop: the back stairwell of a small record label building, with moving boxes, scuffed concrete steps, a gray metal handrail, and a pale security light. The atmosphere should feel quiet, slightly intimate, and workaday, as if caught in a private in-between moment after practice and during moving day.

Subject: a Korean female idol with a naturally attractive, understated sensuality rather than overt glamour. She should feel quietly magnetic, relaxed, and a little teasing without being provocative.

Wardrobe/props: a slightly cropped black blazer worn casually and slightly open, over a fitted heather-gray ribbed tee that softly outlines the figure without revealing cleavage, loose khaki cargo pants sitting naturally on the waist, a thin silver chain necklace, a roll of black gaffer tape placed beside her, and one sneaker lace still half-tied. The styling should feel subtly sexier and more feminine than purely casual, but still fully modest and non-revealing.

Composition/framing: tall portrait. The subject is seated on the stairs with one knee slightly raised and one leg relaxed lower on the step, leaning back lightly with one hand braced behind her on the stair for support. The other hand is near her half-tied sneaker, as if she has just paused while tying it. Her blazer falls naturally along the body, her posture creating a soft, elegant silhouette. Her head is tilted up toward the camera with a calm, slightly sultry, self-possessed expression. The pose should feel candid yet subtly alluring, natural rather than staged.

Lighting/mood: flat stairwell light, understated backstage realism, soft grain, muted tones, gentle highlight bloom, and a quiet intimate mood. Keep the image photorealistic, restrained, and cinematic, with no excessive glamour and no nudity.

Add small white handwriting signature text "BubbleBrain" on the bottom right corner.

--2:3', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 399, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2052217544388546827', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-399', '/images/case399.jpg', 'Use Case: Photorealistic-natural Asset Type: Cinematic Portrait Image,', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-398', 'Create a Freeform Fashion-editorial Collage of Me in', 'Template imported from awesome-gpt-image-2 case 398. Source: @aiwithaly.', 'Characters & People', 'Create a freeform fashion-editorial collage of me in 8 distinct full-body casual wear, arranged organically on a clean cream studio backdrop. Keep my face identical across all looks, w/ consistent proportions that visually read as around (height) w/o stating height. Include subtle handwritten-style arrows & labels highlighting key pieces. Avoid any grids, borders, or boxed layouts.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 398, '@aiwithaly', 'https://x.com/aiwithaly/status/2052218645951205463', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-398', '/images/case398.jpg', 'Create a Freeform Fashion-editorial Collage of Me in', '["Characters"]'::jsonb, '["Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-397', ',184 , ,3 3/4 ,,', 'Template imported from awesome-gpt-image-2 case 397. Source: @ChangningL29508.', 'Characters & People', '角色设定图布局，聚焦于一位18岁的亚裔女性街舞舞者。包含4个大型、高细节度的全身动态舞姿（突出舞蹈动作，面部清晰）。侧边附一条清晰的多角度参考条，仅含3个精细头部特写（正面、侧面、3/4侧面）。最大限度减少文字元素，将像素空间优先用于面部细节刻画。背景为粗砺工业风，搭配写实光影效果', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 397, '@ChangningL29508', 'https://x.com/ChangningL29508/status/2052229452080591276', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-397', '/images/case397.jpg', ',184 , ,3 3/4 ,,', '["Realistic","Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-396', 'Create a Highly Detailed A4 Vertical Vintage Fantasy', 'Template imported from awesome-gpt-image-2 case 396. Source: @sha_zdiii.', 'Posters & Typography', 'Create a highly detailed A4 vertical vintage fantasy encyclopedia style dragon species poster.

Style: medieval creature atlas, ancient mythology manuscript, museum fantasy archive, old explorer journal.

Main subject:
a massive hyper realistic dragon standing proudly in center with detailed scales, smoke from nostrils, giant wings partially open.

Background:
stormy mountains, ancient ruins, fog layers, burnt parchment texture.

Color palette:
dark emerald, ash gray, faded gold, ancient brown, deep crimson.

Include infographic sections:
Species Type,
Fire Capacity,
Wing Structure,
Temperament Scale,
Habitat Region,
Battle Strength,
Ancient Legends,
Scale Patterns,
Skull Diagram,
Hunter Notes.

Add:
engraved fantasy sketches,
ancient symbols,
old map textures,
ink grain,
collectible poster layout.

NO modern UI.
NO futuristic elements.
NO flat minimalism.

Ultra detailed.
8K printable masterpiece.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 396, '@sha_zdiii', 'https://x.com/sha_zdiii/status/2052237839119835280', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-396', '/images/case396.jpg', 'Create a Highly Detailed A4 Vertical Vintage Fantasy', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-395', 'Create a Cinematic Dark Fantasy Action Scene in', 'Template imported from awesome-gpt-image-2 case 395. Source: @RamonVi25791296.', 'Scenes & Storytelling', 'Create a cinematic dark fantasy action scene in a ruined cathedral hall: a {argument name="hero type" default="female armored knight-mage"} crouches in a defensive lunge on the left foreground, wearing ornate dark steel and leather plate armor with a long cream-and-black tabard, one arm extended behind her gripping a spiked mace or morning star crackling with golden magic sparks, the other arm braced forward behind a round glowing shield rimmed with warm light. Opposite her in the right midground is a massive {argument name="enemy type" default="headless stone golem"}, built from cracked gray masonry plates and bound with broken chains, charging with one huge fist raised and rubble falling from its body. Set the battle inside a grand, damaged palace-cathedral interior with towering arches, carved stone columns, tall broken windows, gold-trimmed marble floor in circular geometric patterns, scattered chunks of stone, dust, and debris. Use dramatic backlighting from a bright arched window behind the golem, warm golden magical highlights on the shield and weapon, deep shadows, volumetric dust beams, realistic textures, high-detail armor and stone, dynamic low-angle wide composition, shallow cinematic depth, epic game-cinematic realism, 16:9 widescreen, no text, no UI.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 395, '@RamonVi25791296', 'https://x.com/RamonVi25791296/status/2051568239142973832', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-395', '/images/case395.jpg', 'Create a Cinematic Dark Fantasy Action Scene in', '["UI","Realistic"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-394', 'Create a Cinematic Dark-fantasy Medieval Street Scene in', 'Template imported from awesome-gpt-image-2 case 394. Source: @RamonVi25791296.', 'Scenes & Storytelling', 'Create a cinematic dark-fantasy medieval street scene in ultra-realistic 3D game concept art style, widescreen 16:9. In the foreground, show two adult elven adventurers walking side by side toward the viewer through a muddy cobblestone village road. The left character is a pale-skinned elf woman with long messy {argument name="left character hair color" default="ash blonde"} braided hair, pointed ears, layered olive-green druid robes, leather belts, pouches, dangling metal charms, necklaces, torn fabric strips, leaf-and-feather details, and glowing white vine-like magical tattoos spiraling down both forearms. The right character is a darker-skinned elf woman with long thick {argument name="right character hair color" default="dark brown"} dreadlocked hair, pointed ears, a green-and-brown leather ranger outfit, fur shoulder mantle, feather ornaments, arm wraps, belts, chains, talismans, and a confident warrior posture. Both faces are intentionally hidden by plain opaque {argument name="face covering color" default="dark brown"} square censor blocks, centered over their faces. Set the background in a richly detailed medieval market village with timber-and-thatch houses, hanging bundles of dried herbs on the right-side shopfront, barrels, baskets, wooden stalls, distant townspeople, and a large stone castle with towers and battlements rising in the background. Use {argument name="lighting mood" default="warm late-afternoon golden sunlight"}, dramatic shadows, volumetric haze, shallow depth of field, realistic fabric and leather textures, high detail, moody fantasy atmosphere, cinematic composition, Unreal Engine quality, no text, no logos.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 394, '@RamonVi25791296', 'https://x.com/RamonVi25791296/status/2051568239142973832', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-394', '/images/case394.jpg', 'Create a Cinematic Dark-fantasy Medieval Street Scene in', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-393', 'Candid Portrait of a Beautiful Young Blonde Woman,', 'Template imported from awesome-gpt-image-2 case 393. Source: @SiliconBarbie_.', 'Photography & Realism', 'candid portrait of a beautiful young blonde woman, 21 years old, glowing sun-kissed skin, wearing a baby pink velour tracksuit and butterfly clips in her hair, smiling brightly at the camera, golden hour warm light, palm trees, y2k aesthetic, glossy lips', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 393, '@SiliconBarbie_', 'https://x.com/SiliconBarbie_/status/2051475105403040014', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-393', '/images/case393.jpg', 'Candid Portrait of a Beautiful Young Blonde Woman,', '["UI","Realistic"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-392', 'Macro Photograph of a Miniature City Hidden in', 'Template imported from awesome-gpt-image-2 case 392. Source: @krafterlab.', 'Scenes & Storytelling', 'Macro photograph of a miniature city hidden in human hair, clearly on a real human head, with part of the forehead and hairline visible, realistic skin texture with pores, tiny people walking through the streets between the hair strands, extremely small but realistic proportions, macro photography, 85mm lens, shallow depth of field, natural lighting, neutral colors, no warm tones, ultra realistic hair with visible roots, natural imperfections, slightly messy strands, realistic materials, slightly dirty buildings, no perfect surfaces, photorealistic, looks like a real photo, no illustration, no CGI, no glow', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 392, '@krafterlab', 'https://x.com/krafterlab/status/2051399740986740986', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-392', '/images/case392.jpg', 'Macro Photograph of a Miniature City Hidden in', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-391', 'Instructions Input: Continent Pick 4 Lesser Known Countries', 'Template imported from awesome-gpt-image-2 case 391. Source: @Gdgtify.', 'Other Use Cases', '<instructions> input: continent pick 4 lesser known countries in that continent function drawx($lesser known country){ > Anchor 1: "$lesser known''s famous architecture" (it''s texture, material and color) > Anchor 2: "$lesser known''s famous fashion " (it''s texture, material and color) > Anchor 3: "$lesser known''s famous food " (it''s texture, material and color) > > **Instruction:** Render a dress design that exists at the exact center of this triangle. } output: 2x2 grid, drawx( for each lesser known country)', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 391, '@Gdgtify', 'https://x.com/Gdgtify/status/2051428657571279137', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-391', '/images/case391.jpg', 'Instructions Input: Continent Pick 4 Lesser Known Countries', '["3D"]'::jsonb, '["Fashion","Food"]'::jsonb, FALSE, TRUE),
    ('case-390', 'Country: a Miniature Felt Diorama Made of Fluffy', 'Template imported from awesome-gpt-image-2 case 390. Source: @volkan_iras.', 'Scenes & Storytelling', 'Country: [INSERT COUNTRY NAME]

A miniature felt diorama made of fluffy yarn, wool, and needlework, designed as a single cohesive small world (not a collage), reflecting the real landscape, culture, and daily life of the country.

Structure:
- Select 4-7 naturally integrated elements (landscape, architecture, transport, street life, culture)
- Everything must flow together as one environment

Foreground:
Everyday life - small shops, cafes, markets, people interacting, local clothing, street details, subtle movement, warm human presence

Midground:
Connecting flow - streets, bridges, rivers, paths, transport, cultural spaces that guide the eye naturally from front to back

Background:
One strong identity anchor - landmark, skyline, mountain, or symbolic landscape clearly representing the country (keep it clean, not overcrowded)

Style:
Handmade wool felt, yarn, needle-felt textures, visible fibers, soft edges, miniature craftsmanship, premium diorama realism

Lighting:
Warm golden hour or bright noon, soft shadows, clear visibility, gentle glow enhancing depth

Color:
Soft but saturated palette reflecting the country''s natural tones (greens, sky blues, architectural hues, cultural accents), warm and balanced

Composition:
Vertical frame, balanced or centered perspective, slight top-down or immersive angle, clear foreground-midground-background depth

Mood:
Warm, emotional, calm, refined - like a handcrafted fairy-tale version of real life (not childish)

Rules:
- No logos or text overlays
- No collage-style composition
- No random symbolic clutter
- Keep it realistic but stylized as a handmade miniature world

Quality:
16K, ultra-detailed, hyper-realistic miniature textures, cinematic depth, sharp focus

output_goal:
A single, cohesive felt diorama world that instantly conveys the identity and atmosphere of the chosen country through integrated landscape, culture, and daily life', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 390, '@volkan_iras', 'https://x.com/volkan_iras/status/2051403524966141980', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-390', '/images/case390.jpg', 'Country: a Miniature Felt Diorama Made of Fluffy', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-389', 'Create a Striking Campaign Poster That Stops People', 'Template imported from awesome-gpt-image-2 case 389. Source: @amynys.', 'Posters & Typography', 'Create a striking campaign poster that stops people mid-scroll for Transparent Labs Hydrate.

Bold high-impact supplement advertisement with dramatic black and deep electric blue color palette, gritty premium fitness aesthetic, sharp cinematic lighting, glossy reflections, light smoke atmosphere, intense contrast.

Giant headline typography at top reading "TRANSPARENT LABS HYDRATE" in oversized distressed white and electric blue text.

Center composition features the exact woman from the attached reference image as a fit athletic female model seated confidently on a studio floor, holding a shaker bottle, with a focused and powerful expression.

Change her clothes into sleek black fitness gym outfit: a black sports bra / tank top and high-waisted black leggings with chunky white sneakers. Large glowing "1%" graphic behind the subject symbolizing daily progress.

Front left foreground shows a matte black Transparent Labs Hydrate tub with modern luxury label reading "HYDRATE", scoop of electrolyte powder spilled beside the container.

Surround the poster with clean icon-based benefit callouts: replenishes electrolytes, supports hydration, boosts recovery, improves endurance, enhances performance, zero sugar, lab tested, premium quality, no fillers. Strong motivational copy such as "Daily Hydration. Peak Performance."

Hyper realistic textures, polished commercial retouching, premium sports nutrition branding, modern typography layout, social media ad format, ultra detailed, high resolution.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 389, '@amynys', 'https://x.com/amynys/status/2051409591137972606', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-389', '/images/case389.jpg', 'Create a Striking Campaign Poster That Stops People', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-388', 'A Fictional 1980s Magazine Advertisement Poster Introducing Claudeintroducing', 'Template imported from awesome-gpt-image-2 case 388. Source: @Shinning1010.', 'Posters & Typography', 'A fictional 1980s magazine advertisement poster introducing "Claude" as a revolutionary home AI assistant, retro commercial print ad style, bold headline at the top reading "Introducing Claude!", large chrome metallic 3D typography with pink and blue reflections, yellow italic tagline underneath: "The AI assistant that talks back."

Center composition: a beige 1980s CRT home computer with chunky keyboard on a wooden desk, green monochrome terminal screen glowing, readable text on screen: "Claude", subtitle: "The helpful AI assistant." On the screen, a retro terminal-style conversation reads:
"YOU: How can you help me today?"
"CLAUDE: I can answer questions, help you write, summarize information, brainstorm ideas, and explain topics clearly."
"YOU:"

A cheerful 1980s family of three gathers around the computer: father in a blue sweater, mother with curly hair in a pink sweater, young boy in a striped sweater, all looking amazed, delighted, and fascinated, warm nostalgic expressions, classic family technology advertising mood.

Background: dark starry night sky, purple and blue neon perspective grid, retro sci-fi glow, subtle palm silhouettes, sparkling highlights, lens flares, dramatic yet friendly atmosphere.

Poster layout: left side contains stacked retro feature boxes with glowing neon icons, including a question mark, pencil, light bulb, and clock. Each feature box includes short retro advertising copy:
"ANSWERS QUESTIONS" - Get helpful, clear answers in everyday language.
"HELPS YOU WRITE" - Draft ideas, notes, letters, and more with ease.
"GENERATES IDEAS" - Brainstorm, create, and think bigger.
"AVAILABLE WHENEVER YOU NEED IT" - Day or night, Claude is ready to help.

Add a small retro text block describing Claude:
"For the first time, an AI assistant you can have a conversation with. Ask questions. Get answers. Share ideas. Write drafts, notes, and reports. Explore topics, organize thoughts, and solve problems. Claude understands natural language and responds in a clear, helpful way."

Add a short highlighted copy block:
"It''s helpful. It''s thoughtful.
It''s always by your side."

Bottom area includes a large "Claude" brand wordmark with colorful diagonal retro stripes, and the slogan:
"A smarter way to think, write, and explore."

Bottom right has a white promotional price sticker area with bold pink text:
"Free!!"
Smaller text underneath:
"Available now for curious minds everywhere."

Top right has a bright yellow starburst badge saying:
"A REVOLUTION IN AI ASSISTANCE!"

Include a retro product box on the desk labeled "Claude" with small text:
"SMARTER SOFTWARE FOR MODERN THINKERS."

Include a mug or accessory on the desk branded "Claude".

Visual style: 1985 consumer computer advertisement, airbrushed illustration, glossy print texture, halftone details, nostalgic retro futurism, high saturation, cinematic product lighting, authentic 1980s typography and layout, readable ad composition, detailed vintage commercial poster, highly polished, warm family-friendly mood, retro tech fantasy, vertical poster.

Negative prompts:
modern laptop, smartphone, flat design, minimalism, futuristic 2020s interface, cyberpunk overload, messy layout, unreadable typography, distorted text, misspelled words, deformed hands, extra fingers, bad anatomy, duplicate people, plastic skin, overexposed lighting, low resolution, blurry image, warped computer, broken keyboard, cluttered composition, inconsistent vintage style, random symbols, ugly poster design, poor hierarchy, incorrect perspective', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 388, '@Shinning1010', 'https://x.com/Shinning1010/status/2051410804805599436', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-388', '/images/case388.jpg', 'A Fictional 1980s Magazine Advertisement Poster Introducing Claudeintroducing', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-387', 'Create a Netflix Homepage Ui Featuring a Main', 'Template imported from awesome-gpt-image-2 case 387. Source: @aimikoda.', 'UI & Interfaces', 'Create a Netflix homepage UI featuring a main hero film with its title and still generated from the uploaded reference.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 387, '@aimikoda', 'https://x.com/aimikoda/status/2051420440451801240', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-387', '/images/case387.jpg', 'Create a Netflix Homepage Ui Featuring a Main', '["UI"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-386', 'The Brand Envelope Gpt Image-2 Prompt 89 This', 'Template imported from awesome-gpt-image-2 case 386. Source: @SRKDAN.', 'Brand & Logos', 'The Brand Envelope | GPT Image-2 Prompt #89

This takes any product photo and wraps it in your specific brand world. Different product each time. Same brand, every time.

PHASE 1 / ANCHOR: Describe [BRAND IDENTITY] in 2 lines. Palette, texture, mood.
PHASE 2 / INJECT: Place [PRODUCT] inside that brand world, not the reverse.
PHASE 3 / FORMAT: Set [OUTPUT FORMAT]. Hero, square ad, or story.
PHASE 4 / SIGNATURE: Apply [BRAND ELEMENT]. Grain, shadow, or overlay.

Swap: [BRAND IDENTITY] / [PRODUCT] / [FORMAT]', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 386, '@SRKDAN', 'https://x.com/SRKDAN/status/2051482047248560393', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-386', '/images/case386.jpg', 'The Brand Envelope Gpt Image-2 Prompt 89 This', '["Realistic","Product","Brand"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-385', 'Inspired by Tsingtao China Beer', 'Template imported from awesome-gpt-image-2 case 385. Source: @Popcraft_ai.', 'Other Use Cases', 'Inspired by Tsingtao (China beer)🍺

"Inspired by this product, design a set of cool-style women''s clothing"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 385, '@Popcraft_ai', 'https://x.com/Popcraft_ai/status/2051142270381170754', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-385', '/images/case385.jpg', 'Inspired by Tsingtao China Beer', '["Product"]'::jsonb, '["Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-384', 'A 10-nation Cinematic Fashion Transformation of One Timeless', 'Template imported from awesome-gpt-image-2 case 384. Source: @amynys.', 'Characters & People', 'A 10-Nation Cinematic Fashion Transformation of One Timeless BeautyChatGPT Prompt:

A highly aesthetic, ultra-realistic cinematic collage featuring the exact same beautiful young woman from the reference image, shown in 10 different poses within one single image layout (5x2 grid style). Each frame represents a different country''s traditional cultural dress, styled in a modern, elegant, fashion-forward way. The woman is the SAME person in every frame: she has shoulder-length wavy dark brown hair, captivating dark brown eyes, full plump lips with a subtle confident smile, flawless warm olive-toned skin, high cheekbones, and a voluptuous yet athletic figure with a prominent bust, slim waist, and toned physique - exactly matching the woman in the provided reference photo.

Design details:

Each of the 10 frames shows this same woman in different traditional outfits inspired by the following countries: Suriname, Guyana, Puerto Rico, Spain, Italy, India, Pakistan, Venezuela, Brazil, and the USA.

Every outfit is a modern, elegant, fashion-forward interpretation of that country''s cultural heritage.

Each mini-frame includes a small national flag icon in the top-right corner.

The woman''s expressions vary: smiling, confident, graceful, playful, elegant, royal, modern fusion fashion poses.

High-fashion editorial photography style.

Soft cinematic lighting, ultra-detailed textures, realistic skin tones.

Backgrounds subtly match each country''s cultural aesthetic (landmarks, streets, patterns, colors, architecture).

Luxury fashion magazine layout style.

Clean grid composition, visually balanced, highly shareable social media design.

Style: Ultra-realistic, 8K resolution, Vogue editorial shoot, cinematic lighting, soft depth of field, trending Instagram aesthetic, fashion photography masterpiece.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 384, '@amynys', 'https://x.com/amynys/status/2051287229532639677', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-384', '/images/case384.jpg', 'A 10-nation Cinematic Fashion Transformation of One Timeless', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-383', 'I Want to See What You Really Look', 'Template imported from awesome-gpt-image-2 case 383. Source: @Ciri_ai.', 'Photography & Realism', 'I want to see what you really look like.
Draw a snapshot of your everyday life as if it were accidentally taken on an iPhone.
Make it feel like a very ordinary, imperfect candid shot.
The photo should have slight motion blur, with uneven, natural lighting.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 383, '@Ciri_ai', 'https://x.com/Ciri_ai/status/2051292618248904809', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-383', '/images/case383.jpg', 'I Want to See What You Really Look', '["Realistic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-382', 'A High-quality 3-panel Vertical Photo Collage of a', 'Template imported from awesome-gpt-image-2 case 382. Source: @frametheory058.', 'Photography & Realism', 'A high-quality 3-panel vertical photo collage of a stunning uploaded woman with soft, voluminous wavy hair glowing in golden sunlight. She is styled in a cream-colored lace-up vintage blouse with delicate textures, olive green high-waisted flowy trousers, and a wide-brimmed straw hat slightly tilted for a fashionable editorial look. Light golden jewelry (thin chains, rings) adds a subtle luxury touch.

The setting is a dreamy, vibrant yellow mustard flower field under a bright blue sky with soft clouds, enhanced by golden hour lighting for a magical glow.

Top panel: Back view of the woman standing in the field with arms wide open, sunlight creating a glowing halo around her hair, slight motion blur in flowers for a cinematic feel.

Middle panel: Close-up portrait, she smiles naturally at the camera, wind softly moving her hair, her hand reaching toward the lens creating depth and a slightly blurred foreground for a DSLR effect.

Bottom panel: Playful pose, she leans sideways in the flowers, making a double peace sign, laughing candidly, capturing an authentic joyful moment.

Add cute, trendy white doodle overlays (smiley faces, sparkles, stars, tiny hearts) with a subtle animated/sketchy feel. Include light leaks, sun flares, and soft film grain for a premium Instagram aesthetic.

Ultra-realistic, 4K, cinematic lighting, shallow depth of field, high dynamic range, natural skin tones, editorial fashion photography, soft pastel color grading.

Aspect ratio: 4:5
Style tags: viral Instagram aesthetic, Pinterest style, dreamy spring vibe, candid luxury', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 382, '@frametheory058', 'https://x.com/frametheory058/status/2051294907214844249', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-382', '/images/case382.jpg', 'A High-quality 3-panel Vertical Photo Collage of a', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-381', ', : , Prop Strip Bottom : ,', 'Template imported from awesome-gpt-image-2 case 381. Source: @Iancu_ai.', 'Architecture & Spaces', '{
  "type": "scene reference board - 90s apartment living room, cinematic night",
  "style": "cinematic film photography, 35mm grain, warm amber shadow fill, deep chiaroscuro lighting, hyper-detailed interior, production design reference quality",
  "layout": {
    "main_panel_center_left": {
      "label": "CAMERA A - FRONT VIEW",
      "scene": "Wide shot, L-shaped tan sectional sofa, grey knit throw blanket, wooden coffee table (remote, mug, ashtray, Rolling Stone stack), lava lamp left, table lamp right, rain-streaked city window behind, Nirvana poster left wall. 35mm grain."
    },
    "main_panel_center_right": {
      "label": "CAMERA B - REVERSE VIEW",
      "scene": "Wide reverse from behind sofa. CRT TV prominent right, grey static screen. Tall bookshelf, VHS tapes. Cool blue backlight from window behind camera. Deep shadow."
    },
    "prop_strip_bottom": "6 close-up tiles: 1. LAVA LAMP - chrome base, blue-green wax blobs; 2. COFFEE TABLE - remote, mug, ashtray, magazines; 3. NIRVANA POSTER - black smiley face, wall texture; 4. CRT TELEVISION - static screen, VHS stack; 5. WINDOW/RAIN - city bokeh, water streaks; 6. THROW BLANKET - sofa corner, worn upholstery",
    "top_right_inset": "SOURCE REF thumbnail - original photo",
    "footer": "2700K PRACTICAL · 4100K CITY NIGHT · 24mm · 35MM"
  },
  "background": "deep charcoal #1a1a1a, thin white separators",
  "dimensions": "wide landscape 3:1, high resolution"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 381, '@Iancu_ai', 'https://x.com/Iancu_ai/status/2051287273581203888', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-381', '/images/case381.jpg', ', : , Prop Strip Bottom : ,', '["Poster","Realistic","Product"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-380', 'Instructions Coronavirus', 'Template imported from awesome-gpt-image-2 case 380. Source: @Gdgtify.', 'Charts & Infographics', 'instructions> [SUBJECT]=Coronavirus. A hyper-realistic 3D zoom-sequence infographic generated from a single input: [SUBJECT]. The system auto-detects scale layers from atomic/subcomponent to full contextual view. Layout Structure (CRITICAL) 6-8 circular or hexagonal frames arranged in expanding sequence Innermost frame = smallest detectable detail; outermost = full subject in environment Frames connected by subtle zoom-path lines No repeated scales - each frame shows new level of detail Frame Design Each zoom level includes: Hyper-detailed 3D render at that scale Micro label: scale name (e.g., "molecular," "cellular," "structural") + 3-5 word insight Optional: measurement tag or magnification factor Contextual Halo Around the sequence, include only scale-specific references: Measurement units, scientific notation, cultural scale metaphors (No generic magnifying glass icons) Scale Panel (Alternative Layout) Zoom level Key insight (3-5 words) Scale factor tag Detail icon (grid, wave, particle, etc.) Title "[SUBJECT]: AT EVERY SCALE" (or) "ZOOM: THE WORLD OF [SUBJECT]" Style: ultra-realistic 3D render, scientific editorial infographic, precise macro lighting, global illumination, shallow depth of field, clean sequential layout. </instructions>', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 380, '@Gdgtify', 'https://x.com/Gdgtify/status/2051288232613351571', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-380', '/images/case380.jpg', 'Instructions Coronavirus', '["Infographic","Realistic","3D"]'::jsonb, '["Tech","Story"]'::jsonb, FALSE, TRUE),
    ('case-379', 'Using the Uploaded Logo, Create a Highly Detailed,', 'Template imported from awesome-gpt-image-2 case 379. Source: @CallumGrey.', 'Brand & Logos', 'Using the uploaded logo, create a highly detailed, comic-style infographic poster:

"What This Brand Feels Like"

GOAL:
Turn the brand into a living personality and visually explain how it behaves, speaks, and interacts with the world.
This must feel like a mix of: brand strategy + character design + comic storytelling.

---

CORE RULE:
Everything must come from the logo:
- colors
- style
- tone
- personality

No generic personality traits.

---

MAIN STRUCTURE:
Vertical 4:5 poster
Dense layout with multiple panels
Comic + infographic hybrid

---

TOP SECTION:
- Brand name
- Short personality statement (max 6 words)
Example: "Quiet confidence with sharp edges"

---

MAIN CHARACTER (VERY IMPORTANT):
Create a central character representing the brand:
- humanized version of the brand
- outfit reflects brand style
- posture + expression reflect personality

---

AROUND THE CHARACTER:
Create 6-8 comic panels showing how the brand behaves in different situations.

---

SCENARIO IDEAS:
- Talking to customers
- Handling competition
- Selling a product
- Social media presence
- Reacting to criticism
- Daily "brand life" moment

---

FOR EACH PANEL:
Include:
- short caption (max 6 words)
- speech bubble or internal thought
- clear visual action

---

TONE EXAMPLES:
Luxury brand: calm, confident, minimal speech
Playful brand: loud, chaotic, expressive
Tech brand: precise, logical, clean

---

PERSONALITY TRAITS SECTION:
Add small labeled blocks:
- Voice tone (e.g. calm, bold, playful)
- Energy level (low / medium / high)
- Social behavior (introvert / extrovert)
- Communication style

Use:
- icons
- short labels

---

DO / DON''T SECTION:
Add a split block:
DO:
- how the brand should act
DON''T:
- what breaks the identity

Keep:
- very short phrases

---

VISUAL ELEMENTS:
- speech bubbles
- icons
- arrows
- small reactions
- exaggerated comic expressions

---

STYLE:
- comic + editorial hybrid
- slightly exaggerated but still premium
- expressive but not childish

---

COLOR:
- strictly based on logo palette
- use color to reinforce personality

---

DEPTH:
- 20-40 visual elements
- multiple small panels
- layered composition

---

IMPORTANT RULES:
- must feel alive
- must feel specific
- no generic marketing words
- no empty areas
- keep text short but impactful

---

FINAL FEEL:
Like:
- a brand strategy turned into a character
- a visual storytelling board
- something people save and study

NOT:
- flat
- generic
- minimal', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 379, '@CallumGrey', 'https://x.com/CallumGrey/status/2051293342139584922', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-379', '/images/case379.jpg', 'Using the Uploaded Logo, Create a Highly Detailed,', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-378', 'Transform the Input Photo into a High-end Stylized', 'Template imported from awesome-gpt-image-2 case 378. Source: @Genematicai.', 'Characters & People', 'Transform the input photo into a high-end stylized 3D collectible figure. Large head, slightly exaggerated facial features while preserving identity. Hyper-detailed skin texture with subtle pores, realistic wrinkles, and a cinematic expression.

Smooth matte vinyl finish. Soft studio lighting, clean black background. Ultra-sharp focus, 8K render, photorealistic materials, Pixar-quality rendering, centered composition, full body, premium designer toy aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 378, '@Genematicai', 'https://x.com/Genematicai/status/2050654848216109429', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-378', '/images/case378.jpg', 'Transform the Input Photo into a High-end Stylized', '["Realistic","Brand","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, TRUE, TRUE),
    ('case-377', 'Edit the Provided Image While Preserving the Same', 'Template imported from awesome-gpt-image-2 case 377. Source: @xRahultripathi.', 'Photography & Realism', 'Edit the provided image while preserving the same face identity, shape, and facial features without altering age, ethnicity, or structure. Maintain a calm, relaxed expression with the subject not looking at the camera.

Subject: young woman (18-23) with soft feminine beauty, smooth glowing skin, natural texture.
Pose (strict): seated on a wooden chair, body angled sideways (45-70°), legs crossed naturally, upper body slightly leaning forward, head turned away from camera, gaze to the side. She holds a drink cup with a straw using both hands.
Framing: full-body vertical (9:16), head to shoes visible, centered but slightly offset for natural composition.
Outfit: light pink varsity jacket with white stripes, soft pink inner top, modest knee-length pleated skirt, white sneakers.
Accessories: beige newsboy cap, sunglasses (on face or cap), pink shoulder bag, small earrings.
Hair: neat low bun with soft loose strands.
Environment: outdoor flower shop street scene with pastel flowers (pink, soft tones), decorative plants, floral storefront.
Lighting: bright natural daylight, soft glossy skin highlights, balanced exposure, soft shadows.
Camera: low/frog angle (slightly below, looking up), 50mm lens, shallow depth of field.
Color grading: warm pastel palette (pink, cream), clean bright lifestyle aesthetic.
Quality: ultra-photorealistic, 8K detail, DSLR realism, natural skin texture.
Negative: front-facing, eye contact, close-up, cropped body, mini/short skirt, indoor scene, dark lighting, anime, cartoon, CGI, plastic skin, distorted anatomy.
--ar 9:16 --style raw --quality high', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 377, '@xRahultripathi', 'https://x.com/xRahultripathi/status/2050677614168391716', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-377', '/images/case377.jpg', 'Edit the Provided Image While Preserving the Same', '["Realistic","Brand","Character"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, TRUE, TRUE),
    ('case-376', 'A Realistic Vertical Smartphone Photo of a Spilled', 'Template imported from awesome-gpt-image-2 case 376. Source: @Shinning1010.', 'Photography & Realism', 'A realistic vertical smartphone photo of a spilled green iced drink on outdoor stone pavement, a transparent disposable plastic cup lying on its side inside the green puddle, clear plastic lid nearby, scattered ice cubes floating in the drink, small foam bubbles on the surface, green liquid naturally spreading across rough square floor tiles, strong midday sunlight, harsh realistic shadows, a dark human shadow silhouette cast across the ground and partially over the spill, accidental street moment, urban documentary photography, handheld phone camera perspective, slightly top-down angle, natural colors, realistic pavement texture, raw unedited photo look, high detail, authentic everyday scene, 9:16 vertical composition

Negative Prompt:
cartoon, illustration, anime, CGI, 3D render, fantasy style, studio lighting, overly perfect composition, overly clean floor, fake liquid, unrealistic reflections, plastic-looking liquid, oversaturated green, blurry, low resolution, distorted cup, melted plastic, extra cups, duplicated objects, readable brand logo, messy text, watermark, poster design, dramatic artificial lighting, excessive sharpening, over-processed, unrealistic shadow, floating ice, deformed perspective', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 376, '@Shinning1010', 'https://x.com/Shinning1010/status/2050693240253214894', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-376', '/images/case376.jpg', 'A Realistic Vertical Smartphone Photo of a Spilled', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, TRUE, TRUE),
    ('case-375', 'Case 375 Charts and Infographics Template', 'Template imported from awesome-gpt-image-2 case 375. Source: @ToroJushiAi.', 'Charts & Infographics', '二千五百年前，柏拉图，苏格拉底， 亚力士多德，坐在雅典街头聊天，聊出了世界文明史的源头。

背景可以加上他们聊天内容，按时间轴的走向，重叠在古希腊雅典的城市风光中。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 375, '@ToroJushiAi', 'https://x.com/ToroJushiAi/status/2050713034503409874', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-375', '/images/case375.jpg', 'Case 375 Charts and Infographics Template', '["Charts"]'::jsonb, '["Travel","History"]'::jsonb, TRUE, TRUE),
    ('case-374', 'Case 374 Illustration and Art Template', 'Template imported from awesome-gpt-image-2 case 374. Source: @berryxia.', 'Illustration & Art', '彩色潦草小狗线条风格绘制该图，童趣和doodle加入其中，务必使用毫无章法的绘制手法，凌乱和草率即可。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 374, '@berryxia', 'https://x.com/berryxia/status/2050226420681757102', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-374', '/images/case374.jpg', 'Case 374 Illustration and Art Template', '["Illustration"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-373', ': : : : : : : :', 'Template imported from awesome-gpt-image-2 case 373. Source: @xpg0970.', 'Products & E-commerce', '一、品牌基础设定
品牌名称：[请填写，例如：PRIME STEAK / OCEAN PRIME]
品牌标语：[请填写，例如：Steakhouse Quality, Your Table / Restaurant Grade, Home Delivered]
主色调：[请填写，例如：黑金 / 深红+金 / 深蓝+银]
字体风格：
标题：[请填写，例如：金色衬线体，大写，奢华感]
正文：[请填写，例如：细衬线体/无衬线体]
二、核心视觉元素
台面材质：[请填写，例如：大理石/黑色石板]
背景调性：[请填写，例如：深色渐变/暗调餐厅环境]
光线风格：[请填写，例如：聚光/侧光/顶部照明]
三、主产品定义（必填）
产品名称/类型：[请填写，例如：和牛牛排 / 帝王蟹 / 北极甜虾]
产品数量/摆放：[请填写，例如：1份单品 / 3块整齐摆放]
呈现方式：[请填写，例如：切片展示 / 带骨展示 / 原壳展示]
产品特色/质感提示：[请填写，例如：肉质纹理清晰、多汁感 / 光泽晶亮 / 肉眼可见油花]', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 373, '@xpg0970', 'https://x.com/xpg0970/status/2050108279385419965', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-373', '/images/case373.jpg', ': : : : : : : :', '["Brand"]'::jsonb, '["Commerce","Food"]'::jsonb, TRUE, TRUE),
    ('case-372', 'Create a Cute Female Character Design Sheet Inspired', 'Template imported from awesome-gpt-image-2 case 372. Source: @xRahultripathi.', 'Characters & People', 'Create a cute female character design sheet inspired by the uploaded image.

Style: warm, soft, semi-realistic cartoon illustration with a cozy Japanese kawaii vibe (pastel tones, smooth shading, clean lineart).

Make it a clean character concept poster layout including:

One large main female portrait (front view, detailed)

Facial expression set (happy, shy, annoyed, sleepy, surprised, excited)

2-3 full-body poses (standing, walking/running, playful pose)

Small accessory/object icons that match her personality (hair clip, cute bag, phone charm, coffee cup, keychain)

A simple color palette section (skin, hair, outfit, accent colors)

A profile info box with: name, age range, personality traits, likes/dislikes, short description

Overall look should feel charming, cozy, feminine, and professionally arranged like an animation character design sheet.
High quality, clean background, soft lighting.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 372, '@xRahultripathi', 'https://x.com/xRahultripathi/status/2050152865566708134', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-372', '/images/case372.jpg', 'Create a Cute Female Character Design Sheet Inspired', '["Poster","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-371', 'Transform the Provided Reference Image into a Cozy', 'Template imported from awesome-gpt-image-2 case 371. Source: @Kashberg_0.', 'Characters & People', 'Transform the provided reference image into a cozy aesthetic scrapbook-style composition while strictly preserving the original subject, identity, pose, lighting, and background.

Add multiple small "mini version" characters of the same person (chibi / doll-like style), placed naturally around the scene (on objects, table, shoulder, etc.). These mini figures must match the subject''s face, hairstyle, outfit, and vibe consistently, styled as cute 3D collectible figurines. Show them doing different activities (reading, posing, taking photos, relaxing).

Overlay handwritten-style doodles and annotations across the image: arrows, hearts, stars, sparkles, icons, and playful captions connected to elements in the scene.

Use a soft pastel color palette (white base with pink, peach, blue accents).

Keep the frame visually rich and filled but balanced and clean.

Style: warm, cozy lighting, dreamy Instagram scrapbook aesthetic, soft depth of field, highly detailed, polished but playful.

The final result must look like the SAME original image enhanced with mini alter-egos and aesthetic annotations - not a recreated or different scene.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 371, '@Kashberg_0', 'https://x.com/Kashberg_0/status/2050272100884340783', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-371', '/images/case371.jpg', 'Transform the Provided Reference Image into a Cozy', '["Realistic","Brand","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-370', 'Design Concept: the Crumple Chair Core Philosophy: Translating', 'Template imported from awesome-gpt-image-2 case 370. Source: @ShamsAmin56.', 'Products & E-commerce', 'Design Concept: The Crumple Chair Core Philosophy: Translating the "controlled chaos" of a tossed paper ball into a sculptural, high-comfort seating experience.

Stage 1: Observation & Morphological Analysis The goal is to deconstruct the image of the crumpled paper into usable geometric data. Crease Mapping: Identify the primary "valley" and "ridge" lines. These represent potential structural ribs or seams in the chair. Faceted Planes: Break down the sphere into a series of non-uniform polygons. Each flat surface of the paper becomes a potential panel for the chair''s upholstery or shell. Shadow Study: Analyze how the "tossed" form creates deep recesses. These natural pockets guide where the user''s weight will be cradled.

Stage 2: Iterative Form Exploration Moving from a sphere to a seat through "Digital Crumpling." Subtractive Sculpting: Imagine the paper ball as a solid mass. Use Boolean operations to "carve out" a seating cavity that fits the human form while maintaining the external jagged texture. Tension Simulation: Use 3D software (like Rhino or Blender) to simulate a flat sheet of material being compressed. This ensures the folds look authentic and not "modeled." The "Toss" Logic: Experiment with gravity-based simulation dropping a digital mesh to see how it settles naturally, mimicking the "tossed" origin.

Stage 3: Ergonomic Translation & Blueprinting Refining the raw aesthetic into a functional object. The Comfort Core: Overlay a standard ergonomic template (Seating Angle: 105°-110°) over the crumpled form. Adjust the internal "folds" to provide lumbar support and pressure relief. Blueprint Generation: Create technical orthographic views (Front, Side, Top). Map out the dimensions: Seat Height: 450mm Total Width: 850mm Surface Smoothing: Maintain the sharp "paper edges" on the exterior shell while softening the interior contact points for skin comfort.

Stage 4: Structural Integration & Scaling Making the concept physically viable. The Skeleton: Design a hidden internal frame (likely CNC-bent steel rods or a 3D-printed lattice) that follows the most prominent ridges of the paper folds to provide rigidity. Material Selection: * Option A (High-End): Faceted, cast aluminum with a white powder coat. Option B (Soft): Vacuum-formed recycled plastic shell covered in "memory-fold" technical fabric that retains a wrinkled appearance.

Stage 5: Final Prototyping & Material Finish Textural Replication: Apply a matte, slightly porous finish to the material to mimic the tactile feel of heavy-bond paper. Lighting Contrast: Use directional studio lighting in the final renders to emphasize the "tossed" shadows, making the chair look like a giant piece of discarded inspiration. Design Tip: To keep the "tossed" look authentic, avoid symmetry. The most compelling aspect of a crumpled paper ball is its unique irregularity-ensure the left and right sides of the chair are balance-equivalent but not identical', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 370, '@ShamsAmin56', 'https://x.com/ShamsAmin56/status/2050281206139461780', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-370', '/images/case370.jpg', 'Design Concept: the Crumple Chair Core Philosophy: Translating', '["UI","Poster","3D"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, TRUE, TRUE),
    ('case-369', 'Case 369 Architecture and Spaces Template', 'Template imported from awesome-gpt-image-2 case 369. Source: @so_ainsight.', 'Architecture & Spaces', '[エリア]の観光エリアマップを画像で作成して', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 369, '@so_ainsight', 'https://x.com/so_ainsight/status/2050354639036654048', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-369', '/images/case369.jpg', 'Case 369 Architecture and Spaces Template', '["Architecture"]'::jsonb, '["Travel"]'::jsonb, FALSE, TRUE),
    ('case-368', 'India Menu English Beef Roast', 'Template imported from awesome-gpt-image-2 case 368. Source: @Johnson998877.', 'Other Use Cases', '这是india 料理中的一份真实menu。根据此 重新生成带文本说明的 引人入胜垂涎欲滴的 说明图片 先用English 文本易于识别（手机小屏幕） 这个是beef roast', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 368, '@Johnson998877', 'https://x.com/Johnson998877/status/2050354965110268123', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-368', '/images/case368.jpg', 'India Menu English Beef Roast', '["Other Use Cases"]'::jsonb, '["Food"]'::jsonb, FALSE, TRUE),
    ('case-367', ', Camera : , Subject : , Product', 'Template imported from awesome-gpt-image-2 case 367. Source: @akkiwani703.', 'Posters & Typography', '{
  "image_type": "luxury perfume advertisement poster",
  "resolution": "4K ultra HD (4096x5120)",
  "aspect_ratio": "portrait (4:5)",
  "style": {
    "aesthetic": "high-end fragrance campaign (Tom Ford, Dior inspired)",
    "tone": "dark luxury, sensual, elegant, powerful",
    "color_grading": "deep black shadows with rich golden highlights and warm amber glow",
    "lighting": "cinematic spotlight + golden rim light + soft fill light, dramatic shadows",
    "contrast": "high cinematic contrast",
    "depth_of_field": "shallow, sharp focus on face and perfume bottle"
  },
  "camera": {
    "type": "85mm portrait lens",
    "aperture": "f/1.6",
    "angle": "slightly low angle, premium perspective",
    "framing": "model upper body + product foreground"
  },
  "subject": {
    "gender": "female",
    "age_appearance": "young adult",
    "expression": "confident, sensual, calm",
    "styling": {
      "hair": "voluminous, slightly messy, glossy strands with golden highlights",
      "makeup": "soft glam, glowing skin, bold lips",
      "outfit": "brown tailored blazer with patterned silk scarf",
      "accessory": "thin transparent eyeglasses"
    }
  },
  "product": {
    "type": "luxury perfume bottle",
    "brand": "VELORA PARFUMS",
    "label": "EAU DE PARFUM",
    "design": "clear crystal glass bottle, golden liquid inside, metallic gold cap",
    "placement": "bottom center foreground on glossy black marble surface",
    "effects": "strong reflections, golden glow, subtle condensation, cinematic shine"
  },
  "environment": {
    "background": "dark blurred luxury interior with warm golden light streaks",
    "surface": "black marble with reflections",
    "extra_elements": "small flowers near bottle, golden particles, soft smoke"
  },
  "typography": {
    "logo": "V monogram + VELORA PARFUMS",
    "headline": "Not just a scent, It''s your Signature.",
    "tagline": "A fragrance that speaks before you do.",
    "secondary": "Own your essence. Leave a legacy.",
    "features": [
      "Long Lasting",
      "Premium Ingredients",
      "Crafted with Passion"
    ],
    "notes": [
      "Top: Pear, Bergamot, Pink Pepper",
      "Heart: Jasmine, Rose, Orris",
      "Base: Vanilla, Patchouli, Musk"
    ],
    "font_style": "luxury serif + elegant handwritten script",
    "color": "gold metallic",
    "placement": "top left + mid left + bottom balanced layout"
  },
  "post_processing": {
    "sharpness": "ultra sharp on face and bottle",
    "glow": "golden cinematic glow",
    "retouch": "high-end editorial finish",
    "vignette": "subtle dark vignette"
  },
  "mood": "premium luxury perfume campaign, cinematic, bold brand identity",
  "quality": "hyper-realistic, 4K ultra HD, commercial grade, award-winning fragrance ad"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 367, '@akkiwani703', 'https://x.com/akkiwani703/status/2049778680969437564', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-367', '/images/case367.jpg', ', Camera : , Subject : , Product', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-366', 'A Trendy Young Woman Sitting at an Outdoor', 'Template imported from awesome-gpt-image-2 case 366. Source: @Jawad_Rahman_.', 'Photography & Realism', 'A trendy young woman sitting at an outdoor café table, holding a hot coffee cup near her lips. She has short curly black hair and wears oversized tinted sunglasses, a cropped beige sweater, loose brown high-waisted pants, and chunky white sneakers. A tote bag with minimal coffee-themed illustrations hangs on her shoulder.

The scene blends realistic photography with playful 2D cartoon overlays. Floating around her are animated coffee elements: a smiling cappuccino cup with heart-shaped latte art, cute coffee beans with tiny faces, and stylized splashes of caramel forming comic-style shapes. Soft doodle steam rises into hearts and stars.

On the table: a croissant, a notebook with sketch drawings, and a second coffee cup.

Background: a realistic cozy café street with brick walls, plants, warm golden hour lighting, and soft shadows. Slight depth of field, subject in sharp focus.

Style: mix of photorealism and vibrant cartoon illustration, pop-art aesthetic, high saturation but warm tones, clean composition, Instagram-worthy, soft glow, 4k detail.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 366, '@Jawad_Rahman_', 'https://x.com/Jawad_Rahman_/status/2049796647237066971', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-366', '/images/case366.jpg', 'A Trendy Young Woman Sitting at an Outdoor', '["Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-365', '2x2 Grid, Do This for 4 Famous Scientists', 'Template imported from awesome-gpt-image-2 case 365. Source: @Gdgtify.', 'Products & E-commerce', '2x2 grid, do this for 4 famous scientists in history: Design a collector-grade launch visual for [TOY / FIGURE / DESIGNER OBJECT] shown in pristine hero form along with interchangeable accessories, alternate expressions, packaging design, scale references, sticker details, rarity indicators, and close-up material highlights. The object should feel like a luxury drop, somewhere between art toy culture and elite product branding.  Accessory Layout: Arrange [ACCESSORY 1], [ACCESSORY 2], [ALT VERSION], [PACKAGING FEATURE], and [LIMITED EDITION DETAIL] around the figure in carefully staged clusters. Everything should feel desirable, neat, and "unboxable."  Visual Style: Hype-culture collectible reveal meets premium e-commerce launch campaign. Clean, glossy, tactile, designer-toy sophistication with a playful but expensive sensibility.  Composition Guidelines: Hero figure remains dominant. Accessories should be balanced and elegantly spaced. Packaging should be visible but not steal the scene. The entire image should feel like a product collectors would screenshot instantly.  Lighting & Background: Soft commercial lighting with subtle specular highlights, polished background in [BACKGROUND STYLE], crisp shadows, premium color separation, ultra-sharp details, no watermark.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 365, '@Gdgtify', 'https://x.com/Gdgtify/status/2049766203392921897', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-365', '/images/case365.jpg', '2x2 Grid, Do This for 4 Famous Scientists', '["UI","Product","Brand"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, TRUE, TRUE),
    ('case-364', 'Luxury Personal Color Profile - Editorial Layout Studio', 'Template imported from awesome-gpt-image-2 case 364. Source: @meng_dagg695.', 'Charts & Infographics', 'LUXURY PERSONAL COLOR PROFILE - EDITORIAL LAYOUT
Studio portrait of subject as anchor - skin retouched to luminous glass-like perfection, preserved natural structure, realistic pore texture, soft directional key lighting, no facial alteration. Background: warm ecru parchment with subtle linen grain texture. Layout reads like a Vogue Italia beauty supplement printed on heavyweight matte stock. Structured editorial grid, 3-column asymmetric, wide negative space, serif condensed display headers, all labels in spaced uppercase tracking, cohesive warm ivory/sand/ecru background system throughout all panels, ultra-photorealistic 8K, soft diffused studio lighting, flat elegant surfaces, no drop shadows.
PANELS:
① UNDERTONE DIAGNOSIS - Tonal spectrum bar from cool ash to warm amber, precision needle marker on subject''s reading. Labels: Cool / Neutral-Cool / Neutral / Neutral-Warm / Warm. Fine annotation text.
② SEASONAL COLOR PALETTE - 10-12 fabric-textured swatches in subject''s optimal season. Each labeled with poetic color name and HEX. Grouped: Power Colors / Softest Options / Harmonizing Neutrals.
③ COLORS TO AVOID - Desaturated row of clashing tones with fine editorial strikethrough. Clean, non-harsh presentation.
④ MAKEUP CARTOGRAPHY - Eyeshadow gradient dust swatches / blush tones fanned on skin strip / lip spectrum barely-there to bold / highlighter finishes labeled: champagne, rose gold, pearlescent ivory.
⑤ HAIR COLOR SPECTRUM - Curved gradient strip: base, dimension, highlight, contrast tones. Gold bracket indicators on best options.
⑥ JEWELRY & METAL GUIDE - Flat-lay editorial render: yellow gold, rose gold, oxidized silver, platinum finishes alongside complementary stone tones. Minimal styling.
⑦ YOU IN YOUR PALETTE - 3-4 editorial lookbook frames, subject in palette-correct outfits. Mood labels: Quiet Luxury / Off-Duty Editorial / Evening Presence.
⑧ CAPSULE WARDROBE GRID - Outfit flatlay: tops, bottoms, outerwear, shoes, bag - all palette-correct. Coordinating lines showing interchangeability. Net-a-Porter editorial aesthetic.
⑨ PRINTS & PATTERNS - 4 fabric print thumbnails: micro geometric, tonal abstract, classic stripe, floral scale. One-line styling note per print.
⑩ STYLE ARCHETYPE - Single typographic panel. Style identity title set large (e.g. "Modern Romantic / Warm Classicist"). Three defining aesthetic words. Four-line editorial wardrobe philosophy note.
RENDER SPECS: Ultra-photorealistic, 8K, editorial magazine print quality, warm neutral color grading, soft diffused studio lighting consistent across all panels, one serif display font + one fine sans-serif body font, no gradients, flat matte surfaces only.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 364, '@meng_dagg695', 'https://x.com/meng_dagg695/status/2049822844918575586', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-364', '/images/case364.jpg', 'Luxury Personal Color Profile - Editorial Layout Studio', '["UI","Infographic","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-363', 'Transform the Uploaded Logo into a Hyper-realistic Scene', 'Template imported from awesome-gpt-image-2 case 363. Source: @Naiknelofar788.', 'Other Use Cases', 'Transform the uploaded logo into a hyper-realistic scene where the logo silhouette is formed by iron filings reacting to a magnetic field. The logo must keep its exact shape and proportions, appearing as if a magnet shaped like the logo (or hidden beneath the surface) is influencing the filings to align naturally into that recognizable formation. Material details:
Fine iron filings with sharp, spiky, needle-like structures.
Dense clustering along magnetic field lines forming the logo silhouette.
Variation in density - thick near magnetic poles, thinner outward.
Matte dark metallic texture with subtle reflections.

Physics behavior:
Iron filings must follow realistic magnetic field patterns - radial and curved lines forming spikes and ridges.
Stronger attraction zones create thicker, raised clusters.
Outer areas show softer, more dispersed alignment.
Natural randomness and slight irregularity - no perfect edges.
Some loose filings scattered beyond the main shape.

Surface interaction:
Flat surface such as a lab table, glass plate, or matte black tray.
Filings resting on surface but visibly lifted in areas due to magnetic force (spiky texture).
Subtle dust and micro particles around.

Environment & human presence:
Realistic classroom, science lab, or creative studio environment.
A person partially visible - hands holding or moving a magnet beneath the surface or nearby.
Possibly a child or adult observing or interacting (adds emotional curiosity).
Other subtle elements: notebooks, tools, or lab items out of focus.

Lighting:
Directional overhead light creating shadows from raised filings.
Subtle highlights on metallic edges.
Balanced natural or indoor lighting.

Atmosphere:
Curiosity.
Discovery.
Educational yet visually satisfying.
Quiet but engaging moment.

Camera & composition:
Top-down or slightly angled close-up view.
Logo clearly visible through iron filing formation.
Human hands or interaction slightly off-center for storytelling.

Format:
Aspect ratio: STRICT 4:5 vertical.
No text overlays.

Style:
Hyper-real macro + environmental photography.
Physically accurate magnetic behavior.
Cinematic yet grounded realism.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 363, '@Naiknelofar788', 'https://x.com/Naiknelofar788/status/2049835482331357460', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-363', '/images/case363.jpg', 'Transform the Uploaded Logo into a Hyper-realistic Scene', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-362', 'Create a Premium Visual Board for a Modern', 'Template imported from awesome-gpt-image-2 case 362. Source: @Preda2005.', 'Brand & Logos', 'Create a premium "Matcha Brand Touchpoint System" visual board for a modern lifestyle brand called:

"MATCHA MODE"

Build a full brand identity system, not a single image.

HERO SCENE:

A hyper-realistic matcha drink in a ceramic cup placed on a clean natural surface.

- vibrant green matcha foam with micro-bubbles
- bamboo whisk (chasen) nearby
- soft natural light
- slight matcha powder dust on the surface
- minimal Japanese aesthetic
ATMOSPHERE:
- calm, warm, soft daylight
- clean background (off-white or beige)
- subtle shadows and reflections
- feeling of wellness and luxury
FULL BRAND SYSTEM:
- takeout cups (paper + glass bottles)
- packaging boxes (minimalist design)
- tote bags (premium lifestyle)
- labels, stickers, seals
- menu cards with pricing ($6.50, $8.90, etc.)
- small typography everywhere
- subtle imperfections (realism)

DESIGN LANGUAGE:

- modern minimalist typography
- Japanese-inspired layout
- soft green palette
- elegant spacing

INCLUDE:
- matcha latte
- iced matcha
- matcha desserts
- combo sets
- lifestyle shots
The composition must feel like a high-end design agency presentation.

Ultra-detailed, realistic, clean, aesthetic, and highly shareable.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 362, '@Preda2005', 'https://x.com/Preda2005/status/2049846981271699685', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-362', '/images/case362.jpg', 'Create a Premium Visual Board for a Modern', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, TRUE, TRUE),
    ('case-361', 'Create a 3d Insane Detailed Exploded Assembly Drawing', 'Template imported from awesome-gpt-image-2 case 361. Source: @Ankit_patel211.', 'Charts & Infographics', 'Create a 3D Insane detailed exploded assembly drawing of [subject or object]', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 361, '@Ankit_patel211', 'https://x.com/Ankit_patel211/status/2048834306379075759', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-361', '/images/case361.jpg', 'Create a 3d Insane Detailed Exploded Assembly Drawing', '["3D"]'::jsonb, '["Tech"]'::jsonb, TRUE, TRUE),
    ('case-360', 'Create a Professional Hairstyle Analysishairstyle Analysis - Long', 'Template imported from awesome-gpt-image-2 case 360. Source: @Gemalpha_88.', 'Charts & Infographics', 'Create a professional "HAIRSTYLE ANALYSIS" infographic with a different male model (the same face) having long, thick hair (6-10 inches), slightly wavy texture.

Style should be clean, modern, premium grooming guide (similar layout but not identical).

TOP TITLE:
"HAIRSTYLE ANALYSIS - Long Hair Edition"

LEFT PANEL (Key Features with icons):
Face Shape: Oval
Hair Type: Thick
Texture: Wavy
Length: Long

BEST OPTIONS (Top row with green indicators):
Layered Flow Cut (Adds movement & volume)
Modern Curtain Hair (Stylish & balanced)
Textured Long Waves (Natural & full)
Loose Slick Back (Controlled but not flat)

LESS FLATTERING (Bottom row with red indicators):
Flat Straight Long Hair (No volume)
Overly Oily Slick Back (Too heavy)
Uneven Long Layers (Messy shape)
Excessively Frizzy Look (Uncontrolled)

BEST HAIR LENGTH SECTION:
Ideal: 6-10 inches with layers
Avoid: Too flat or too heavy bottom

BEST HAIR COLORS:
Dark Brown
Natural Black
Warm Brown
Ash Brown

DESIGN STYLE:
Clean grid infographic
White/beige background
Soft shadows
Premium magazine look
Realistic face and hair detail
Consistent spacing and typography
High resolution, 4K', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 360, '@Gemalpha_88', 'https://x.com/Gemalpha_88/status/2048918707343401034', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-360', '/images/case360.jpg', 'Create a Professional Hairstyle Analysishairstyle Analysis - Long', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, TRUE, TRUE),
    ('case-359', 'A Cinematic Character Promotional Poster of , Vertical', 'Template imported from awesome-gpt-image-2 case 359. Source: @Goodmanprotocol.', 'Posters & Typography', 'A cinematic character promotional poster of [SUBJECT], vertical composition (9:16), designed with a refined East-Asian ink aesthetic and high-end visual storytelling.

STRUCTURE:
Top-heavy hierarchical layout. The upper half features a large, highly recognizable silhouette of [SUBJECT]''s head / face / mask / upper body, forming a bold, iconic primary shape. The silhouette should be instantly identifiable.

The middle-lower section contains the full-body version of [SUBJECT] as a secondary subject, standing in a stable pose or subtle action stance, forming the visual core.

COMPOSITION STYLE:
Inside the large silhouette and around the character, use double exposure and collage storytelling. Integrate multiple elements:
- key scenes related to [SUBJECT]
- symbolic imagery and environment
- small narrative figures and interactions
- supporting visual motifs

Blend everything seamlessly using clouds, mist, ink diffusion, and negative space.

VISUAL FLOW:
Create a continuous flowing visual path from top to bottom, connecting:
- upper silhouette
- inner collage elements
- full-body subject

Ensure smooth eye guidance and compositional cohesion.

SIDE ELEMENTS:
Add balanced supporting elements on left and right sides to create tension, depth, and spatial variation.

STYLE & ATMOSPHERE:
- Large areas of negative space
- Ink-wash diffusion edges, soft fading, subtle fragmentation
- Eastern aesthetic: balance of emptiness and detail
- Calm, premium, restrained, cinematic tone

QUALITY:
Ultra-detailed, high resolution, layered depth, soft lighting, atmospheric perspective, cohesive series-style design.

OUTPUT:
9:16 aspect ratio, poster-ready composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 359, '@Goodmanprotocol', 'https://x.com/Goodmanprotocol/status/2049002279051895243', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-359', '/images/case359.jpg', 'A Cinematic Character Promotional Poster of , Vertical', '["UI","Poster","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, TRUE, TRUE),
    ('case-358', 'A Hyper-realistic Commercial Advertisement Blending Energy Drink and', 'Template imported from awesome-gpt-image-2 case 358. Source: @SPEEDAI07.', 'Products & E-commerce', 'A hyper-realistic commercial advertisement blending energy drink and sports branding. A dynamic athletic woman mid-air jump, wearing modern sportswear (light translucent jacket, orange shorts, white sneakers), surrounded by explosive splashes of red strawberry liquid and flying ice cubes. A cold metallic energy drink can (strawberry flavor) bursting with droplets sits in the foreground, covered in condensation. Fresh strawberries scattered on a glossy reflective surface.

Bright cinematic lighting with dramatic highlights and motion effects. Vibrant orange gradient background with bold glowing typography behind the subject. Ultra-detailed, high contrast, sharp focus, commercial product photography style, 8K resolution, advertising poster aesthetic, energetic, powerful, refreshing mood.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 358, '@SPEEDAI07', 'https://x.com/SPEEDAI07/status/2049043627163435040', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-358', '/images/case358.jpg', 'A Hyper-realistic Commercial Advertisement Blending Energy Drink and', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-357', 'A Fish-eye Lens Close-up of Sipping from a', 'Template imported from awesome-gpt-image-2 case 357. Source: @harboriis.', 'Photography & Realism', 'A fish-eye lens close-up of [your photo as reference] sipping from a teal/turquoise coffee mug, leaning forward intimately toward camera. Shot through or near a round mirror. Retro café interior with glossy teal subway tiles, vintage appliances, pendant lights. Black t-shirt, yellow-tinted round glasses. Warm moody tones.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 357, '@harboriis', 'https://x.com/harboriis/status/2049044698900361241', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-357', '/images/case357.jpg', 'A Fish-eye Lens Close-up of Sipping from a', '["Realistic"]'::jsonb, '["Food"]'::jsonb, FALSE, TRUE),
    ('case-356', 'Ultra-realistic Conceptual Portrait of a Young Woman with', 'Template imported from awesome-gpt-image-2 case 356. Source: @AIwithAliya.', 'Illustration & Art', 'Ultra-realistic conceptual portrait of a young woman with long wavy hair and soft defined features, wearing rose-tinted rectangular sunglasses, an oversized ivory cropped t-shirt, fitted light-wash denim jeans, and clean white sneakers. She is sitting casually with a confident yet relaxed posture.

The twist: she is seated on a large, hyper-realistic version of her own detached head placed on the ground. The head is scaled up, lying sideways, with the same facial features and sunglasses, creating a surreal self-reflection concept.

Composition: centered, full-body shot, neutral studio background with soft blush and cream tones, minimal aesthetic. Clean negative space.

Typography integrated into the background:

Handwritten-style text at the top: "OVERTHINKING"

Below it, smaller text: "TRAPPED IN MY OWN HEART" with "HEART" crossed out

Large, rough, scribbled text in deep pink: "MIND"

Lighting: soft diffused studio lighting, subtle shadows, high detail, fashion editorial quality.

Style: blend of surrealism and modern luxury streetwear campaign, pastel feminine aesthetic, minimal yet expressive, high-resolution, 8k, sharp focus, natural skin texture.

Mood: introspective, emotional weight, identity, self-awareness, quiet confidence.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 356, '@AIwithAliya', 'https://x.com/AIwithAliya/status/2049044716642316758', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-356', '/images/case356.jpg', 'Ultra-realistic Conceptual Portrait of a Young Woman with', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-355', 'Create One Finished Premium Conceptual Typography Poster for', 'Template imported from awesome-gpt-image-2 case 355. Source: @dotey.', 'Posters & Typography', 'Create ONE finished premium conceptual typography poster for the exact title:

"[INPUT_TEXT]"

Single poster only. No moodboard, grid, presentation board, mockup, captions, prompt text, process sheet, or sample labels.

The title "[INPUT_TEXT]" must be the dominant visual structure of the poster: huge, readable, powerful, and spelled exactly. Do not translate, shorten, replace, or misspell it. Do not add other large readable text. Optional micro catalog text is allowed only if it stays subtle and secondary.

Silently interpret the title''s meaning, mood, cultural aura, symbolic associations, psychological tension, and visual rhythm. Turn that interpretation into one strong visual metaphor.

Typography is the hero. Design custom-looking letterforms whose weight, width, contrast, spacing, rhythm, distortion, negative space, edge quality, and ink texture express the temperament of the title. The type should feel intentionally designed, not like a default font.

If "[INPUT_TEXT]" refers to a widely known person, make a large editorial portrait or full / half-body figure a major visual presence, occupying roughly 40-70% of the composition. The figure should feel recognizable through aura, posture, styling, era, expression, lighting, and symbolic atmosphere, but should not copy a specific existing photograph, official poster, campaign image, logo, slogan, or copyrighted composition. The portrait must interact with the typography: overlapping the letters, emerging from them, being framed by them, casting shadows on them, breaking through them, or being partially hidden behind them.

For all other titles, use a human figure, landscape, object, or atmospheric setting only when it strengthens the meaning. It must interact with the typography and deepen the concept, not decorate it.

Use a rich but restrained 4-6 color system matched to the theme: dominant background color, primary typography color, figure / landscape tone, emotional accent color, muted support color, and subtle paper / ink texture tone. Avoid flat black-white-red defaults unless conceptually necessary.

Composition style: high-end editorial poster, museum-quality graphic design, dramatic scale, strong hierarchy, few elements, intelligent whitespace, bold flat color areas, sharp cropping, silkscreen / lithograph / risograph grain, paper fibers, subtle ink imperfections, refined visual tension.

The final image should feel like a complete visual sentence: the title, the figure or setting, the color, and the typography explain each other.

Avoid generic word art, glossy 3D lettering, random icons, stock-photo realism, cluttered collage, excessive grunge, tourist clichés, official logos, copied slogans, copied campaign aesthetics, unrelated text, and misspelled typography.

-----

INPUT_TEXT：Phoenix Rebirth', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 355, '@dotey', 'https://x.com/dotey/status/2048793351290327381', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-355', '/images/case355.jpg', 'Create One Finished Premium Conceptual Typography Poster for', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-354', 'Case 354 Brand and Logos Template', 'Template imported from awesome-gpt-image-2 case 354. Source: @wanerfu.', 'Brand & Logos', '1. Logo概念生成提示词

你是一位拥有20年经验的顶级Logo设计师，为全球知名品牌设计过即时识别且深具意义的标志。

品牌名称：[你的品牌名]
行业：[你的行业]
品牌个性：[描述]
目标受众：[描述]
欣赏的视觉身份：[列举3个]
讨厌的视觉身份：[列举3个]
偏好风格：[如极简、大胆、几何、有机、复古、未来]

为我的品牌生成5个完全不同的Logo概念。

对每个概念提供：

- 核心视觉理念及象征意义
- 形状语言及为何适合品牌
- 字体方向建议
- 第一眼的情感触发
- 为何适合目标受众
- 在名片、App图标和广告牌上的效果
- 何为永恒而非潮流

然后告诉我，如果这是你的品牌，你会选哪个以及原因。

2. 品牌身份基础提示词

你是为财富500强公司和初创企业建立品牌身份的顶级品牌战略师，这些企业后来融资数百万。

业务名称：[你的业务名]
业务描述：[一句话]
目标受众：[详细描述]
竞争对手：[列举3-5个]
想触发的感受：[如信任、兴奋、奢华、亲近、力量]
想关联的词汇：[列举5-10个]
不想关联的词汇：[列举5-10个]

在设计任何视觉效果之前建立完整的品牌身份基础。

为我提供：

- 品牌原型及为何完美契合
- 5个具体人类特征描述的品牌个性
- 带示例的品牌语调指南
- 核心品牌承诺（一句话）
- 3个品牌应触发的情感层级
- 与竞争对手的根本差异
- 定义品牌的唯一关键词

3. 配色方案提示词

你是色彩心理学专家和品牌设计师，深知色彩如何触发情感、建立信任和驱动购买决策。

品牌名称：[你的品牌名]
行业：[你的行业]
目标受众：[年龄、性别、收入、生活方式]
想触发的首要情感：[如信任、能量、奢华、平静、兴奋]
前3名竞争对手颜色：[列举]
喜欢的颜色：[列举]
讨厌的颜色：[列举]

为我建立完整品牌配色板。

为我提供：

- 主色及其HEX代码和心理学解释
- 两个辅助色及HEX代码
- 一个强调色用于CTA和高亮
- 一个中性色用于背景和文字
- 每种颜色对目标受众的影响
- 与竞争对手的差异化
- 在网站、社交媒体和包装上的应用示例
- 永远不要搭配的颜色组合及原因

4. 字体方向提示词

你是字体专家和品牌设计师，深知字体如何传达个性、建立可信度和实现品牌即时识别。

品牌名称：[你的品牌名]
品牌个性：[5个词]
行业：[你的行业]
目标受众：[描述]
字体应触发的感受：[如权威、友好、创新、优雅、能量]
喜欢的品牌字体：[列举3个]

为我建立完整字体系统。

为我提供：

- 标题用主显示字体名称及为何完美
- 长文本的辅助字体
- 引言或重点的强调字体
- 标题、副标题、正文、说明文字的精确字号层级
- 字距和行高建议
- 字体搭配方法
- 预算有限时的免费替代方案
- 你所在行业应避免的字体错误

5. 完整品牌身份包提示词

你是顶级品牌代理创意总监，交付覆盖每个触点的完整品牌身份系统。

业务名称：[你的业务名]
业务描述：[一句话]
目标受众：[详细描述]
品牌个性：[5个词]
行业：[你的行业]
竞争对手：[列举3个]
设计工具预算：[免费或付费]
时间表：[你需要的时间]

在一个回复中交付我的完整品牌身份系统。

包含所有元素：

- 品牌战略基础、原型、个性、承诺和定位
- Logo概念及3个变体
- 完整配色板、HEX代码和使用规则
- 字体系统、名称、字号和层级
- 视觉方向指南
- 品牌语调指南和标语选项
- 社交媒体视觉模板
- 3条永远不要打破的核心品牌规则

将一切作为结构化品牌手册交付，任何设计师、开发者或AI工具都能在10分钟内完全理解你的品牌。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 354, '@wanerfu', 'https://x.com/wanerfu/status/2048659924822184026', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-354', '/images/case354.jpg', 'Case 354 Brand and Logos Template', '["Product","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, TRUE, TRUE),
    ('case-353', '+ + :, 4 : - - 2', 'Template imported from awesome-gpt-image-2 case 353. Source: @liyue_ai.', 'Charts & Infographics', '一、系统角色
你是一个专业美妆顾问 + 人脸分析系统 + 品牌视觉设计系统。
你的任务是：基于用户上传自拍与指定口红品牌，生成一张具有品牌调性的"口红推荐报告信息结构图"。

二、输入参数
用户图像：{用户自拍}
品牌：{口红品牌，如 Dior / YSL / Armani / Chanel / TF}
风格偏好（可选）：{通勤 / 温柔 / 气场 / 氛围感 / 显白优先}
推荐数量：3-5

三、品牌视觉层（新增核心模块）
根据 {品牌} 自动构建视觉风格（Brand Visual Identity），提取品牌调性，例如：
Dior：
优雅、高级、法式、灰白 + 银色、柔光
YSL：
黑金、性感、强对比、时尚编辑感
Armani：
低饱和、雾面、克制、灰调高级感
Chanel：
极简黑白、高级、理性、结构清晰
Tom Ford：
深色、高对比、奢华、电影感

视觉应用到海报：
1. 主色调（背景微变化，不是大面积铺色）
2. 强调色（用于色号标题/细线/小元素）
3. 光影风格（柔光 / 强对比 / 冷调 / 暖调）
4. 字体气质（优雅 / 现代 / 冷感 / 力量感）

四、分析层
对用户进行分析：
- 肤色：冷 / 暖 / 中性（+ 明度）
- 气质：清冷 / 温柔 / 明艳 / 干净 / 成熟
- 唇部特征：薄 / 厚 / 唇色基础
- 妆容状态：素颜 / 日常 / 精致
输出一句总结：「更适合 {色系} + {饱和度} + {质地} 的口红方向」

五、推荐层（增强差异）
从 {品牌} 推荐 3-5 个色号：
每个包含：
- 色号名称（#999）
- 色系（正红 / 豆沙 / 枫叶 / 奶茶 / 玫瑰）
- 上脸效果（显白 / 提气色 / 氛围感 / 气场增强）
- 场景（逛街 / 通勤 / 聚餐 / 约会 / 宴会）

要求：每个色号"风格明确区分"（一个日常、一个气场、一个氛围感等）

六、信息结构图
生成竖版信息结构图
整体风格：美妆时尚大片质感 + 结构化信息可视化排版 + 品牌视觉体系深度融合
极简但不单调，高级但有视觉层次

【整体布局】
左上：用户输入区
右上：分析结论
中部：试色矩阵（核心）
底部：总结

## 1️⃣ 左上（用户区）
用户自拍（真实质感）
+ 小标题：「肤色分析」
+ 一句话结论：「适合低饱和玫瑰调，避免高荧光色」

极细品牌色线条（如 YSL 金线 / Dior 灰线）

## 2️⃣ 中部（核心试色矩阵）
这是视觉重点区域（占比60%以上）
展示方式：将 3-5 个色号以"人脸试色对比"的形式排列：
每一列 = 一个色号
每个色号包含：
- 小型人脸图（同一张脸，不同唇色）
- 色号名称（如 #999）
- 色系标签（如 Classic Red）
- 一句话效果说明
要求：所有人脸保持一致，仅唇色变化，真实试色效果（lip color try-on），肤质真实，不塑料，光影统一。
排列方式：横向排布 或 网格排布（整齐但不死板）

品牌增强点：
- Dior：轻柔渐变背景 + 柔光阴影
- YSL：更强对比 + 黑色细分割线
- Armani：整体灰调统一，低对比
- Chanel：严格对齐，极简黑白
- TF：局部暗背景 + 高光强调

## 3️⃣ 每个色号模块
包含：
色号名（突出）
色系标签
一句推荐语
场景标签（逛街/通勤/聚餐/约会/宴会等）

品牌化处理：
- 用"品牌强调色"做：
  - 色号标题
  - 细分隔线
  - 小icon
（不是色块，而是"精致点缀"）

## 4️⃣ 底部总结
一段"有判断力的建议"，
例如：「日常建议选择低饱和豆沙色提升气色，重要场合可使用正红增强气场」
或：「你的肤色更适合柔和玫瑰调，避免高荧光色系」
但不要完全引用以上2个例子的建议，根据用户实际肤色来建议。
品牌增强：底部可加极淡品牌风格横线 / 极小品牌字样（非logo）

七、UI设计
- 不使用圆角卡片 UI
- 不使用厚边框
1. 引入"层级对比"：
   - 主体亮
   - 次要信息弱
2. 使用"微对比"：
   - 细线
   - 灰度差
   - 字重变化
3. 加入"节奏感"：
   - 疏密变化
   - 模块呼吸
4. 品牌点缀：
   - 只用 5% 强调
   - 不破坏极简结构

八、图像质量
真实皮肤质感
唇色精准
统一光影
商业级美妆摄影
8K

---
品牌：YSL', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 353, '@liyue_ai', 'https://x.com/liyue_ai/status/2048667226195317219', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-353', '/images/case353.jpg', '+ + :, 4 : - - 2', '["UI","Infographic","Poster"]'::jsonb, '["Commerce","Food","Story"]'::jsonb, TRUE, TRUE),
    ('case-352', ',,,,/,;,,, , ,4k', 'Template imported from awesome-gpt-image-2 case 352. Source: @stellimbris.', 'Posters & Typography', '竖版国风暗黑海报，黑色纯背景，中央巨大的中文标题字，占据画面大部分空间，字体为粗粝做旧的米白色石刻/旧纸质感，带明显颗粒、磨损、裂痕与噪点；整体构图层次丰富，强烈黑白金红对比，东方审美，神秘、压抑、欲望与审判感并存 电影海报质感 高级平面设计，极致细节 纸张纹理 印章落款 小字标语，4K', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 352, '@stellimbris', 'https://x.com/stellimbris/status/2048633434961072617', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-352', '/images/case352.jpg', ',,,,/,;,,, , ,4k', '["Poster"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-351', 'Cinematic Fitness Campaign, Oversized Dumbbell Placed Diagonally Like', 'Template imported from awesome-gpt-image-2 case 351. Source: @AIwithSynthia.', 'Posters & Typography', 'Cinematic fitness campaign, oversized dumbbell placed diagonally like a statement prop, female model in red performance wear and white shorts seated on one side of the dumbbell, one leg bent, one extended, minimal black studio, reflective floor, bold word "STRENGTH" behind in large typography, sharp lighting, ultra-clean composition, luxury sports aesthetic, 1:1.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 351, '@AIwithSynthia', 'https://x.com/AIwithSynthia/status/2048601383545577614', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-351', '/images/case351.jpg', 'Cinematic Fitness Campaign, Oversized Dumbbell Placed Diagonally Like', '["Poster","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-350', 'Create a Scrapbook Doodle-style Football Poster of', 'Template imported from awesome-gpt-image-2 case 350. Source: @ryanpp27.', 'Posters & Typography', 'Create a scrapbook doodle-style football poster of [PLAYER_NAME].

AI auto-generates realistic career stats (club and national team).

Main photo: realistic, unchanged ([PLAYER_NAME] in action or iconic pose).

Doodles and handwritten notes: white and [PRIMARY_COLOR] neon ink (no warm colors unless specified), arrows, stars, scribbles, sketchy outlines. Add a glowing [PRIMARY_COLOR] outline around the player''s body.

Layout (bold handwritten titles and stats):
- Top Title: "[PLAYER_NAME]" plus "[NICKNAME/TITLE]"
- Club Career: total matches and goals plus 2-4 main clubs (apps and goals)
- Highlights: 2-3 standout achievements (e.g., UCL goals, Ballon d''Or, top scorer)
- National Team: caps and goals plus 1-2 international achievements

Style: modern football poster x notebook aesthetic, clean but energetic, slightly messy doodles, high contrast, neon accents on dark or muted background.

Important: all stats must be realistic and proportional to the player''s real career.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 350, '@ryanpp27', 'https://x.com/ryanpp27/status/2048602248524214542', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-350', '/images/case350.jpg', 'Create a Scrapbook Doodle-style Football Poster of', '["Poster","Realistic","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, TRUE, TRUE),
    ('case-349', 'Cinematic Sports Fashion Collage, 3-panel Layout, Top Panel', 'Template imported from awesome-gpt-image-2 case 349. Source: @AIwithkhan.', 'Photography & Realism', 'Cinematic sports fashion collage, 3-panel layout, top panel large hero shot of a female tennis athlete sitting confidently on an oversized tilted tennis racket, deep green luxury court backdrop, reflective glossy floor, bold oversized typography "PRECISION" in background, dramatic editorial lighting, ultra-clean composition, high-fashion athletic aesthetic.

Bottom left panel: close-up portrait of the athlete with glowing skin, minimal makeup, soft light, text "FOCUS" and "FUEL" placed subtly.

Bottom right panel: full-body crouched pose holding racket, strong posture, text "DISCIPLINE DRIVES DOMINANCE", grid-based layout lines, premium sports branding feel.

Consistent color grading, dark green and white palette, sharp details, cinematic shadows, luxury campaign style, 1:1 aspect ratio.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 349, '@AIwithkhan', 'https://x.com/AIwithkhan/status/2048606301039820821', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-349', '/images/case349.jpg', 'Cinematic Sports Fashion Collage, 3-panel Layout, Top Panel', '["Poster","Brand","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-348', 'Create a Premium Poster Featuring the Same Man', 'Template imported from awesome-gpt-image-2 case 348. Source: @RizwanAly07.', 'Posters & Typography', 'Create a premium "BEARD STYLE ANALYSIS" poster featuring the same man from the reference image. Show face shape, beard density, jawline definition, beard growth pattern, and beard suitability score. Include different beard styles comparison such as Stubble, Short Boxed Beard, Full Beard, Goatee, Van Dyke, Clean Shave. Add side profile and front profile views. Modern dark blue luxury background, professional grooming infographic style, high detail, realistic face consistency, stylish typography, premium male grooming poster.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 348, '@RizwanAly07', 'https://x.com/RizwanAly07/status/2048610196302250019', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-348', '/images/case348.jpg', 'Create a Premium Poster Featuring the Same Man', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-347', 'Monochrome Grayscale Illustration, 3d-rendered Character, Clean Instructional Reference', 'Template imported from awesome-gpt-image-2 case 347. Source: @oggii_0.', 'Characters & People', '[STYLE]
Monochrome grayscale illustration, 3D-rendered character, clean instructional reference sheet, white background, comic-style cell grid layout, technical diagram aesthetic.

[LAYOUT]
4×4 grid layout with a total of 16 panels. Each panel is separated by thin black border lines. Cells are numbered from 1 to 16, with consistent panel sizes.

[CHARACTER]
image1 (the same character appears consistently in all panels)

[PANEL STRUCTURE - per cell]
Top-left: bold number badge + English title text
Center: full-body character pose illustration
Bottom-left: English description text (3-4 lines)
Overlay: directional arrows indicating movement

[ARROWS / MOTION INDICATORS]
Curved arrows, straight arrows, and circular rotation indicators placed around the character to show motion flow and direction.

[RENDERING STYLE]
Highly detailed 3D sculpted style, soft studio lighting, subtle shadows, no color, grayscale shading, clean linework, game concept art quality.

[NEGATIVE]
No background scenery, no color tones, no additional characters, no complex background.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 347, '@oggii_0', 'https://x.com/oggii_0/status/2048614158699217302', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-347', '/images/case347.jpg', 'Monochrome Grayscale Illustration, 3d-rendered Character, Clean Instructional Reference', '["Infographic","Illustration","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-346', 'Case 346 Illustration and Art Template', 'Template imported from awesome-gpt-image-2 case 346. Source: @dotey.', 'Illustration & Art', '精致立体刺绣风插画，浅浮雕纤维艺术效果，纯净「蚕丝白 + 奶白」底色，细腻丝线质感。画面为数只小鸟停在蜿蜒花枝上，周围点缀粉白、浅桃、珊瑚粉、淡金色花朵与叶片，构图轻盈雅致、留白充足。鸟儿羽毛以奶白、浅蓝、淡粉、浅金丝线刺绣表现，花枝纤细自然，花朵层层叠线，整体呈现高级手工刺绣、丝线堆绣、柔和光影、细节丰富、温柔清新的艺术效果。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 346, '@dotey', 'https://x.com/dotey/status/2048529821706195442', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-346', '/images/case346.jpg', 'Case 346 Illustration and Art Template', '["Illustration"]'::jsonb, '["Creative"]'::jsonb, TRUE, TRUE),
    ('case-345', 'Create a Vertical Poster Composition on Aged Cream', 'Template imported from awesome-gpt-image-2 case 345. Source: @bananaprompts.', 'Posters & Typography', 'Create a vertical poster composition on aged cream paper with a handmade analog feel. Use rough ripped paper edges, layered magazine cutouts, photocopy grain, halftone texture, ink bleed, and slightly imperfect screen-print registration. Keep the subject as the main black-and-white photographic portrait, placed prominently in the center or upper center. Surround the subject with graphic blocks of deep red, cobalt blue, warm yellow, black, and ivory.

Add supporting collage fragments such as a rainy European street, film-strip borders, newspaper clippings, urban silhouettes, and cinematic details, arranged like a handmade 1960s art-house movie poster. Use bold condensed typography with a strong visual hierarchy. Add large headline text: "[MAIN TITLE]". Add smaller subtitle text: "[SUBTITLE]". Add bottom text: "[BRAND NAME / EVENT NAME / COMING SOON / DATE]". If needed, include a small top line reading "[TAGLINE]".

The final result should feel cinematic, intellectual, rebellious, and editorial - like a lost 1960s European film poster with a strong point of view. Keep it raw, tactile, printed, imperfect, and handmade. Avoid a glossy modern finish.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 345, '@bananaprompts', 'https://x.com/bananaprompts/status/2048541390900994476', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-345', '/images/case345.jpg', 'Create a Vertical Poster Composition on Aged Cream', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-344', 'Create a Premium, Highly Realistic 1:1 Campaign Poster', 'Template imported from awesome-gpt-image-2 case 344. Source: @Daniel_adsss.', 'Brand & Logos', 'Create a premium, highly realistic 1:1 campaign poster for NOIR, a modern streetwear brand. Show one hero oversized hoodie as the main focus against a gritty urban backdrop with wet concrete floors, dramatic low lighting, subtle smoke in the air and a raw street energy. Add bold minimal typography with the brand name NOIR and a short campaign headline like "Wear the Dark." Make it feel like a real high-end streetwear editorial, sharp detail, realistic fabric textures, modern and edgy, deep black tones with subtle grey accents, no clutter, no collage.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 344, '@Daniel_adsss', 'https://x.com/Daniel_adsss/status/2048542581638701446', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-344', '/images/case344.jpg', 'Create a Premium, Highly Realistic 1:1 Campaign Poster', '["Poster","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, TRUE, TRUE),
    ('case-343', 'Ultra High-fashion Magazine Cover, Louis Vuitton-style Editorial', 'Template imported from awesome-gpt-image-2 case 343. Source: @SPEEDAI07.', 'Posters & Typography', 'Ultra high-fashion magazine cover, Louis Vuitton-style editorial. Close-up portrait of a confident woman with soft rose-gold hair and natural airy bangs, slightly wind-blown for movement. She is wearing a luxury summer outfit: a structured lightweight linen or silk jacket in warm golden-yellow tones, layered over a modest high-neck top, paired with a bold gold choker necklace and subtle statement earrings.

Fabric flows naturally with a summer breeze, slightly textured and breathable, capturing a premium seasonal feel. Styling is elegant, modest, and refined - no revealing clothing.

Lighting is high-end studio mixed with natural golden hour glow: warm highlights, soft shadows, luminous skin with glossy editorial finish.

Background is a rich summer gradient (sunset gold fading into soft coral or warm beige), clean but visually striking.

Composition is dynamic and slightly cinematic: hair in motion, shallow depth of field, sharp focus on face.

Typography: large elegant serif masthead "Louis Vuitton" at the top, bold cover line "YOUR CHOICE ENDS HERE" in premium editorial layout, minimal supporting text.

Ultra-realistic, hyper-detailed skin texture, 8K resolution, sharp focus, glossy magazine print quality, cinematic color grading, luxury fashion photography, no nudity, tasteful and editorial.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 343, '@SPEEDAI07', 'https://x.com/SPEEDAI07/status/2048573343066992919', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-343', '/images/case343.jpg', 'Ultra High-fashion Magazine Cover, Louis Vuitton-style Editorial', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-342', 'Phase 1 - Product: in Packaging, Minimal Label', 'Template imported from awesome-gpt-image-2 case 342. Source: @SRKDAN.', 'Brand & Logos', 'PHASE 1 - PRODUCT: [ITEM] in [MATERIAL] packaging, minimal label design
PHASE 2 - GRID: 2x2 seasonal grid, four distinct brand worlds
PHASE 3 - COMPOSITION: each quadrant a full campaign scene with props and environment
PHASE 4 - CONSISTENCY: same product silhouette, four distinct palettes

Swap: [ITEM] / [MATERIAL] / [LABEL STYLE]', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 342, '@SRKDAN', 'https://x.com/SRKDAN/status/2048582939504431195', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-342', '/images/case342.jpg', 'Phase 1 - Product: in Packaging, Minimal Label', '["Product","Brand"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-341', 'Please Create a Mathematical Visualization Infographic About', 'Template imported from awesome-gpt-image-2 case 341. Source: @hqmank.', 'Charts & Infographics', 'Please create a mathematical visualization infographic about "[math concept / topic]." The goal is to help the viewer intuitively understand what it is, why it works, its geometric or structural intuition, and how it behaves in different contexts. The visual should feel like a high-quality math lecture handout combined with a hand-drawn educational poster. It should be elegant, clear, and information-rich, but not cluttered. Visual style: either portrait or landscape is fine. Use a clean, light paper-like background, with a deep blue title and black or dark gray lines for the main content. Add a small number of refined accent colors such as blue, teal, gold, and red. Incorporate rounded-corner cards, thin borders, numbered labels, hand-drawn arrows, zoom-in callout boxes, and a summary section. The overall design should be aesthetically pleasing, balanced, and academic, allowing the viewer to grasp the structure of the concept and why it works at a glance.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 341, '@hqmank', 'https://x.com/hqmank/status/2048587150544028084', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-341', '/images/case341.jpg', 'Please Create a Mathematical Visualization Infographic About', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, TRUE, TRUE),
    ('case-340', 'Oc,,, ,,,,,,', 'Template imported from awesome-gpt-image-2 case 340. Source: @xiaofenggan.', 'Scenes & Storytelling', '异质感oc，绝美红妆女子，位于彼岸花丛中，张力。 唐琬《钗头凤·世情薄》 世情薄，人情恶，雨送黄昏花易落。晓风干，泪痕残。欲笺心事，独语斜阑。难，难，难！', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 340, '@xiaofenggan', 'https://x.com/xiaofenggan', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-340', '/images/case340.png', 'Oc,,, ,,,,,,', '["Scenes"]'::jsonb, '["History"]'::jsonb, FALSE, TRUE),
    ('case-339', 'Apple-Style Nature Science Poster', 'Template imported from awesome-gpt-image-2 case 339. Source: @berryxia.', 'Posters & Typography', '你是一个高端自然科普海报生成系统，目标是为稀有动物、昆虫、爬行动物、哺乳动物或其他小众生物生成 Apple keynote 风格的高级科普视觉海报。

整体视觉方向：
生成一张 9:16 竖版高级科普海报，画面采用极简、纯白、干净、现代、Apple 式产品发布海报语言。背景应为纯白或极浅灰白渐变，保持大量留白。整体设计应具备高级感、克制感、视觉冲击力和科学展示感。

核心设计原则：
1. 主体动物必须被极度放大，成为画面最强视觉中心。
2. 主体应具有强烈立体感、真实质感、高清细节和柔和棚拍光影。
3. 海报信息要少而准，避免拥挤。
4. 不使用传统信息图的卡片、圆角框、复杂底纹、淡黄色纸张质感或装饰性边框。
5. 底部信息区只使用四列极简 icon + 标题 + 短说明，通过细竖线分隔。
6. 文字排版要像高端发布会视觉，标题巨大，副标题克制，正文小而清晰。
7. 风格关键词：Apple-inspired, premium editorial, pure white background, hero subject, clean typography, minimal infographic, high-end science poster.

画面结构：
顶部左侧为标题区：
中文大标题：{中文物种名}
中文副标题：{一句有吸引力的物种定位}
细短横线
英文名：{英文物种名}
分布信息：主要分布：{分布区域}

中部与下中部为主体视觉：
生成一个超高清、真实、具有强烈立体感的 {中文物种名}。
主体应占据画面 50% 到 70% 的视觉面积。
主体姿态应具有展示性、力量感或识别度。
保持白色背景，不添加复杂自然环境。
可以保留少量必要承托物，例如树枝、岩石、雪地、沙土或木皮，但必须简洁。
主体要有真实阴影，使其像高级产品摄影一样立在画面中。

底部信息区：
用四个极简信息栏目展示科普信息。
每个栏目包含：
一个细线 icon
一个彩色小标题
一段 1 到 3 行短文字
栏目之间用极细浅灰竖线分隔。
不使用卡片框，不使用圆角背景，不使用大面积色块。

四个信息栏目：
栏目 1：
标题：{重点特征1标题}
说明：{重点特征1短说明}

栏目 2：
标题：{重点特征2标题}
说明：{重点特征2短说明}

栏目 3：
标题：{重点特征3标题}
说明：{重点特征3短说明}

栏目 4：
标题：{重点特征4标题}
说明：{重点特征4短说明}

底部总结句：
在最底部居中放置一句灰色小字总结：
{一句高级、克制、有记忆点的科普总结}

字体与排版：
中文标题使用大号黑色、高级、稳重、有力量感的字体。
副标题使用灰色，中等字号，字距略宽。
英文名使用小号灰色，简洁现代。
正文使用清晰现代中文字体，保持可读。
所有文字必须留有足够呼吸感。

色彩规范：
背景：纯白、极浅灰、轻微柔光渐变。
主标题：黑色或深石墨色。
副标题与正文：中性灰。
底部四个信息标题可使用低饱和强调色：
暖棕、冷蓝、松石绿、紫色、橙色。
颜色只用于 icon 和小标题，不要大面积铺色。

图像质量：
2K 高清质感，细节清晰，主体锐利，光影真实。
主体纹理必须可信，例如毛发、鳞片、甲壳、皮肤褶皱、羽毛或斑纹。
避免变形、错误肢体、错误解剖结构、模糊主体、低质贴图、塑料感、卡通感。

禁止项：
不要使用淡黄色旧纸背景。
不要使用复杂信息图网格。
不要使用圆角卡片。
不要使用厚边框。
不要使用大面积装饰图形。
不要添加无关 logo。
不要添加多余小字。
不要让主体太小。
不要让文字压住主体。
不要让底部信息区过度拥挤。
不要出现儿童科普风、卡通风、低端展板风。

最终输出：
生成一张 9:16 竖版、高级、干净、强视觉冲击的 Apple 风自然科普海报。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 339, '@berryxia', 'https://x.com/berryxia/status/2048251413147644100', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-339', '/images/case339.jpg', 'Apple-Style Nature Science Poster', '["Infographic","Poster","Brand"]'::jsonb, '["Education"]'::jsonb, FALSE, TRUE),
    ('case-338', 'Red Cliff Classical Scroll', 'Template imported from awesome-gpt-image-2 case 338. Source: Community.', 'History & Classical Themes', '帮我生成一张《赤壁怀古》的长卷图，带整篇《赤壁赋》文字', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 338, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-338', '/images/case338.png', 'Red Cliff Classical Scroll', '["History"]'::jsonb, '["Creative"]'::jsonb, TRUE, TRUE),
    ('case-337', 'Case 337 History and Classical Themes Template', 'Template imported from awesome-gpt-image-2 case 337. Source: Community.', 'History & Classical Themes', '帮我生成一张《短歌行》的意境图，带整篇《短歌行》文字', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 337, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-337', '/images/case337.png', 'Case 337 History and Classical Themes Template', '["History"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-336', 'Case 336 UI and Interfaces Template', 'Template imported from awesome-gpt-image-2 case 336. Source: Community.', 'UI & Interfaces', '原文未公开，案例目标是生成一张高完成度的个人主页视觉设计图。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 336, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-336', '/images/case336.png', 'Case 336 UI and Interfaces Template', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-335', ', Gpt-image2', 'Template imported from awesome-gpt-image-2 case 335. Source: Community.', 'UI & Interfaces', '原文未公开，重点展示 GPT-Image2 在高仿社交截图与中文排版场景中的能力。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 335, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-335', '/images/case335.png', ', Gpt-image2', '["UI"]'::jsonb, '["Social","Story"]'::jsonb, FALSE, TRUE),
    ('case-334', 'RAG Technical Explainer', 'Template imported from awesome-gpt-image-2 case 334. Source: Community.', 'Charts & Infographics', '帮我生成一张 RAG 技术的详细讲解图', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 334, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-334', '/images/case334.png', 'RAG Technical Explainer', '["Charts"]'::jsonb, '["Tech"]'::jsonb, TRUE, TRUE),
    ('case-333', 'Case 333 Charts and Infographics Template', 'Template imported from awesome-gpt-image-2 case 333. Source: Community.', 'Charts & Infographics', '生成一张AI眼镜的爆炸视图，包含每个组件的名称以及这款产品的几大核心卖点。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 333, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-333', '/images/case333.png', 'Case 333 Charts and Infographics Template', '["Charts"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-332', 'Tea Pi Product Poster', 'Template imported from awesome-gpt-image-2 case 332. Source: Community.', 'Posters & Typography', '帮这个产品生成宣传图', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 332, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-332', '/images/case332.png', 'Tea Pi Product Poster', '["Poster"]'::jsonb, '["Food"]'::jsonb, FALSE, TRUE),
    ('case-331', 'Hand-Drawn Xi''an Watercolor Map', 'Template imported from awesome-gpt-image-2 case 331. Source: Community.', 'Architecture & Spaces', '生成一张手绘水彩风格的「西安」城市地图，包含当地特色美食、地标建筑及城市特色', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 331, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-331', '/images/case331.png', 'Hand-Drawn Xi''an Watercolor Map', '["Architecture"]'::jsonb, '["Travel"]'::jsonb, FALSE, TRUE),
    ('case-330', 'Moonlit Livestream Scene', 'Template imported from awesome-gpt-image-2 case 330. Source: Community.', 'UI & Interfaces', '生成一张直播间的图片，直播间氛围是月下美女跳舞的画面，直播间有很多人评论', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 330, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-330', '/images/case330.png', 'Moonlit Livestream Scene', '["UI"]'::jsonb, '["Creative"]'::jsonb, TRUE, TRUE),
    ('case-329', 'A Cinematic Fantasy Scene of a Fierce Female', 'Template imported from awesome-gpt-image-2 case 329. Source: @iamsofiaijaz.', 'Scenes & Storytelling', 'A cinematic fantasy scene of a fierce female use image for face reference warrior falconer walking through a dark misty forest, wearing battle-worn leather armor infused with glowing ember textures. Her arm is raised, commanding a massive phoenix-eagle hybrid with blazing wings and flaming feathers, fire trailing from its tips. The bird radiates molten orange and red light, casting sparks and embers into the air.The warrior has braided hair, ash-streaked skin, and a determined expression, carrying a rope and utility pouch. Ultra-detailed feathers, realistic fire physics, dramatic lighting, volumetric fog, shallow depth of field, epic fantasy atmosphere, hyper-realistic, cinematic color grading, dark moody background, 8k, concept art, unreal engine quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 329, '@iamsofiaijaz', 'https://x.com/iamsofiaijaz/status/2008896649901535342', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-329', '/images/case329.jpg', 'A Cinematic Fantasy Scene of a Fierce Female', '["Realistic"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-328', ', Subject : , Product Arm : ,', 'Template imported from awesome-gpt-image-2 case 328. Source: @saniaspeaks_.', 'Architecture & Spaces', '{
  "type": "image_generation_prompt",
  "language": "en",
  "style": "hyper-realistic cinematic selfie photography",
  "aspect_ratio": "9:16",
  "identity_preservation": {
    "use_reference_image": true,
    "strict_identity_lock": true,
    "alter_face": false,
    "alter_skin": false,
    "alter_hair": false,
    "alter_gender": false,
    "notes": "Preserve identical facial features, skin texture, hair, glasses, age, and gender from the uploaded reference image. No synthetic skin or sculptural look."
  },
  "subject": {
    "gender": "female",
    "capture_method": "selfie taken by the subject herself",
    "pose": {
      "selfie_arm": {
        "description": "one arm fully straight and completely extended upward holding the camera that takes the selfie",
        "visibility": "arm clearly visible, straight and dominant in frame",
        "camera_visibility": "the selfie camera device itself must NOT be visible in the frame"
      },
      "product_arm": {
        "description": "the other arm fully extended toward the camera holding the attached Canon camera",
        "importance": "product is closest to the camera and visually dominant"
      },
      "head": {
        "tilt": "slightly tilted toward the selfie camera"
      },
      "expression": "natural and relaxed facial expression"
    },
    "body_visibility": "full body visible from head to toe",
    "feet": "feet clearly touching the road surface"
  },
  "composition": {
    "perspective": "natural selfie perspective at chest height",
    "camera_angle": "extreme top-down angle, camera above the subject looking directly downward",
    "layer_depth": [
      "product (closest to camera)",
      "face",
      "full body",
      "city environment (background)"
    ]
  },
  "scale_and_perspective": {
    "effect": "forced perspective",
    "subject_scale": "the woman appears extremely giant",
    "buildings_scale": "buildings appear much smaller, reaching no higher than her knees",
    "dominance": "the subject visually dominates the entire scene",
    "realism": "inspiring scale while remaining physically believable"
  },
  "environment": {
    "location": "real urban intersection",
    "elements": [
      "pedestrian crosswalk",
      "road markings",
      "traffic signs",
      "cars",
      "bicycles",
      "pedestrians at realistic human scale"
    ],
    "setting": "ground-level urban environment"
  },
  "lighting": {
    "type": "natural daylight",
    "conditions": "clear or lightly cloudy sky",
    "shadows": "soft and realistic",
    "restrictions": "no fantasy or dramatic lighting"
  },
  "product_rules": {
    "usage": "use the uploaded Canon product exactly as provided",
    "distortion": "none",
    "logo": "unchanged",
    "appearance": "natural reflections and realistic highlights only"
  },
  "camera_quality": {
    "realism": "maximum photorealism",
    "depth": "clear separation of foreground, subject, and background",
    "artifacts": "none"
  },
  "constraints": [
    "No AI-art look",
    "No plastic or sculpted skin",
    "No distortion of face or body",
    "No extra limbs or incorrect anatomy",
    "No text or watermarks",
    "No visible selfie camera device"
  ],
  "output_goal": "Create a hyper-realistic cinematic selfie image of a woman using her exact reference identity, captured from an extreme top-down perspective in a real urban crosswalk, with forced perspective scale, natural daylight, and a Canon camera product prominently held toward the lens."
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 328, '@saniaspeaks_', 'https://x.com/saniaspeaks_/status/2009834337043394622', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-328', '/images/case328.jpg', ', Subject : , Product Arm : ,', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-327', ', Background Elements : , Lighting : ,', 'Template imported from awesome-gpt-image-2 case 327. Source: @meng_dagg695.', 'Products & E-commerce', '{
  "master_prompt_type": "Ultra-detailed 8K AI image generation",
  "global_settings": {
    "resolution": "8K UHD",
    "aspect_ratio": "2:3 vertical",
    "render_quality": "extreme sharpness, ultra-fine detail, cinematic lighting",
    "style": "hyper-realistic commercial product photography",
    "color_profile": "warm golden tones with soft amber highlights",
    "environment": {
      "location": "ancient Middle Eastern market corridor",
      "architecture": {
        "walls": "aged stone walls with visible texture and wear",
        "arches": "large stone archway in background",
        "floor": "stone flooring, warm brown tone"
      },
      "background_elements": [
        "wooden shelves filled with spices",
        "sacks and bowls of dried goods",
        "hanging bundles of herbs",
        "traditional metal lanterns emitting warm yellow light"
      ],
      "lighting": {
        "primary": "soft golden ambient light",
        "secondary": "warm lantern glow from both sides",
        "atmosphere": "slight haze enhancing light diffusion" "main_subject": {
          "type": "perfume bottle",
          "position": "center foreground",
          "placement": "on top of an ornate wooden table",
          "material": {
            "bottle": "transparent clear glass",
            "cap": "gold metallic rectangular cap",
            "liquid": "light golden perfume liquid"
          },
          "design": {
            "shape": "rectangular bottle with rounded edges",
            "finish": "glossy reflective surface",
            "label": "no visible label" "table": {
              "material": "dark carved wood",
              "shape": "square top",
              "details": [
                "intricate floral and geometric carvings",
                "golden inlay accents",
                "polished surface reflecting light" "floating_elements": {
                  "composition_style": "vertical ingredient stack",
                  "motion": "ingredients appear suspended with swirling golden light",
                  "effects": [
                    "glowing particles",
                    "sparkling dust",
                    "soft light trails connecting elements"
                  ],
                  "elements_order_top_to_bottom": [
                    {
                      "ingredient": "amber resin",
                      "appearance": "translucent golden-brown resin chunks",
                      "glow": "warm internal glow" "ingredient": "damask rose",
                      "appearance": "fully bloomed pink rose",
                      "details": [
                        "soft layered petals",
                        "natural green leaves",
                        "petals gently floating nearby"
                      ] "ingredient": "white musk",
                      "appearance": "smooth white crystal-like stone",
                      "additional": "fine white powder beneath the stone" "ingredient": "aged agarwood",
                      "appearance": "dark brown wooden pieces",
                      "texture": "rough, fibrous wood grain",
                      "effect": "thin white smoke rising upward" "text_elements": {
                        "title": {
                          "text": "Exquisite Syrian Perfume",
                          "font_style": "elegant serif",
                          "color": "gold",
                          "position": "top center"
                        },
                        "subtitle": {
                          "text": "Luxury Syrian Perfume",
                          "font_style": "smaller serif",
                          "color": "gold",
                          "position": "below main title"
                        },
                        "ingredient_labels": [
                          {
                            "title": "Pure Amber",
                            "description": "Precious resin from the depths of nature"
                          } "title": "Damask Rose",
                          "description": "Symbol of beauty and Syrian heritage"
                        },
                        {
                          "title": "White Musk",
                          "description": "Clean, powdery scent of timeless elegance"
                        },
                        {
                          "title": "Aged Agarwood",
                          "description": "Rich, smoky wood with deep warmth"
                        }
                      ],
                      "typography_details": {
                        "connector_lines": "thin curved golden lines connecting text to ingredients",
                        "icons": "small circular markers at line endpoints"
                      } "opacity": "slightly translucent"
                    } "overall_mood": "tone": "luxurious, warm, elegant",
                    "theme": "heritage perfume craftsmanship",
                    "visual_feel": "rich, premium, cinematic ads', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 327, '@meng_dagg695', 'https://x.com/meng_dagg695/status/2011334627290726746', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-327', '/images/case327.jpg', ', Background Elements : , Lighting : ,', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-326', ', Image Style : , Clothing : ,', 'Template imported from awesome-gpt-image-2 case 326. Source: @meng_dagg695.', 'Characters & People', '{
  "global_settings": {
    "resolution": "8K",
    "quality": "ultra-high definition",
    "aspect_ratio": "2:3",
    "render_style": "AI-edited, high-detail 3D render",
    "lighting_quality": "soft studio lighting with realistic shadows",
    "sharpness": "extreme clarity, crisp edges",
    "noise": "none",
    "compression": "none"
  },
  "image_style": {
    "subject": {
      "character_type": "stylized 3D cartoon female",
      "pose": "leaning slightly backward against background",
      "expression": "playful, lips slightly pursed, eyes looking sideways",
      "hair": {
        "color": "brown",
        "style": "short, tousled",
        "accessories": "red sunglasses resting on head"
      }
    },
    "clothing": {
      "dress": "form-fitting blue ribbed dress with thin straps",
      "footwear": "red high-heel sandals with bow detail"
    },
    "color_palette": [
      "bold red",
      "deep blue"
    ],
    "background": {
      "color": "solid red",
      "texture": "smooth matte surface"
    },
    "lighting": {
      "direction": "soft directional light from one side",
      "shadow": "defined shadow cast on red background"
    },
    "composition": {
      "framing": "full body",
      "pose_emphasis": "curved posture, crossed legs"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 326, '@meng_dagg695', 'https://x.com/meng_dagg695/status/2012437899955097836', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-326', '/images/case326.jpg', ', Image Style : , Clothing : ,', '["Realistic","Character","3D"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-325', 'A Stylized 3d Cartoon Portrait of a Young', 'Template imported from awesome-gpt-image-2 case 325. Source: @iamsofiaijaz.', 'Characters & People', 'A stylized 3D cartoon portrait of a young man with short brown hair and expressive green eyes, smiling warmly. He is wearing a black blazer over a white t-shirt, modern casual fashion. Pixar-like / Disney-style character design with smooth skin, soft lighting, and slightly exaggerated facial features. High detail, polished 3D render, friendly and approachable expression. Gradient background with soft teal and pink colors, studio lighting, shallow depth of field, high resolution.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 325, '@iamsofiaijaz', 'https://x.com/iamsofiaijaz/status/2013473309485343120', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-325', '/images/case325.jpg', 'A Stylized 3d Cartoon Portrait of a Young', '["Character","3D"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-324', 'A Stylish Young Woman Sitting on the Front', 'Template imported from awesome-gpt-image-2 case 324. Source: @iamsofiaijaz.', 'Scenes & Storytelling', 'A stylish young woman sitting on the front edge of an old vintage bus, wearing a long red trench coat, woolen beanie cap, round blue reflective sunglasses, layered necklaces, and rugged brown leather boots. She has wavy blonde hair and a confident, dreamy expression, looking upward toward the sky. The bus is weathered with peeling paint in turquoise and rust red tones.Bright clear blue sky, urban background with minimal buildings, soft daylight, cinematic color grading, shallow depth of field, high fashion travel vibe, editorial photography, ultra-realistic, 4K resolution, sharp focus, natural skin texture, dramatic composition, film still aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 324, '@iamsofiaijaz', 'https://x.com/iamsofiaijaz/status/2015337737860403283', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-324', '/images/case324.jpg', 'A Stylish Young Woman Sitting on the Front', '["UI","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-323', 'Create a Hyper-realistic, Cinematic Instagram Post Layout Where', 'Template imported from awesome-gpt-image-2 case 323. Source: @Mystveil7.', 'Other Use Cases', 'Create a hyper-realistic, cinematic Instagram post layout where the Instagram UI exists as a physical, tangible 3D object, photographed like a premium commercial product shot. The result should feel indistinguishable from a real studio photograph.
Instagram Frame (UI Accuracy - Critical)
Authentic Instagram interface rendered as a solid white physical 3D card
Smooth matte plastic surface with subtle micro-texture
Slight thickness visible on edges, realistic bevels
Perfectly rounded corners (exact Instagram radius)
Soft studio reflections and realistic edge highlights
Top Bar (Pixel-accurate UI):
Circular profile avatar on the left
Username text: "June" in Instagram''s default bold UI font
Light blue FOLLOW button with correct proportions
Three-dot menu icon aligned to the far right
Exact spacing, typography, and icon sizing matching the real Instagram app
Aspect ratio 1:1, centered, balanced, premium composition.
Main Subject (Pose - Match Reference Image Exactly)
A photorealistic athletic woman partially emerging out of the Instagram frame into real 3D space
Seated pose identical to the reference image:
Both legs bent and angled to the side
One knee slightly raised and closer to the chest
Arms gently wrapped around the raised knee
Hands relaxed, fingers naturally resting
Torso leaning slightly back against the frame edge
Expression: calm, thoughtful, self-assured
Gaze: looking slightly to the side and upward, not engaging the camera
Natural body proportions, relaxed posture, editorial realism
No exaggerated curves, no artificial posing
Clothing (Nike Only - Realistic Fit)
Muted ivory / off-white Nike fitted short-sleeve blouse
Soft neutral tone that contrasts beautifully with the background
Visible white Nike swoosh
Natural fabric stretch and tension
Deep blue Nike athletic pants, length up to the knee
Tailored, performance-fit silhouette
Realistic fabric weight with subtle folds at the knee bend
Clean stitching and breathable sports material
Clean white Nike sneakers
Slight wear realism
Correct sole texture and stitching
Premium sportswear look, real commercial styling
No distortion, no fantasy fashion
Background (Inside the Instagram Post Only)
Dark indoor gym or studio environment
Cool blue and muted purple cinematic lighting
Soft haze in the background
Subtle volumetric light beams barely visible
Shallow depth of field, background softly blurred
Subject and Instagram frame remain sharp and dominant
Lighting & Photorealism
Studio-grade cinematic lighting
Soft key light illuminating the subject naturally
Gentle rim light outlining the body and Instagram frame
Realistic skin texture with visible pores and natural highlights
Accurate contact shadows where the subject touches the frame
Physically correct light falloff and reflections
Footer UI (Engagement Section)
Instagram action icons: like, comment, share, save (accurate icons)
Text visible: "785 likes"
Caption begins with June
Caption text:
Freedom isn''t found in comfort.
It''s built in the quiet moments where discipline meets belief.
Hashtags partially visible and naturally cropped
Overall Style & Quality
Ultra-high resolution
Advertising-grade realism
Clean, modern, editorial Instagram aesthetic
Hyper-realistic blend of 3D object + real photography
No extra elements
No text errors
No distortion
Looks like a real product photoshoot, not AI art', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 323, '@Mystveil7', 'https://x.com/Mystveil7/status/2015776042989039997', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-323', '/images/case323.jpg', 'Create a Hyper-realistic, Cinematic Instagram Post Layout Where', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-322', 'Professional Photo, a Guy, a 30-year-old Russian Model', 'Template imported from awesome-gpt-image-2 case 322. Source: @ecommartinez.', 'Photography & Realism', 'Professional photo, a guy, a 30-year-old Russian model (reference image), is facing the lens, tilted towards the camera, angle from below, shot with a wide-angle lens. The guy is tilted and shows a bottle close-up to the camera, a hand with a bottle close-up right in front of the lens. The label and direction of the bottle are straight so the label is readable. He''s wearing white sneakers, one foot in front of the camera. The guy is standing on the street, wet asphalt and splashes from below. Bright colors, cinematic lighting, the light is behind and on the model''s face. --v7 --ar 3:4 --style raw', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 322, '@ecommartinez', 'https://x.com/ecommartinez/status/2017311074551533921', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-322', '/images/case322.jpg', 'Professional Photo, a Guy, a 30-year-old Russian Model', '["Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-321', 'A Hyper-realistic Cinematic Fashion Photograph of a Stunning', 'Template imported from awesome-gpt-image-2 case 321. Source: OpenNana.', 'Photography & Realism', 'A hyper-realistic cinematic fashion photograph of a stunning young woman in her early 20s, full body visible, standing in a modern city center during golden hour.
She leans casually with one shoulder against a traffic light pole, unaware of the camera, as if the moment was captured naturally.
She wears skinny blue jeans, brown leather boots, and a cropped brown suede jacket with a soft shearling collar. Under the jacket, a minimal dark crop top reveals a subtle cleavage and toned midriff.

Her physique is naturally feminine, balanced and elegant, with confident posture.
One hand runs through her long, voluminous curly light-brown hair, lifting it back in motion. Her head is turned slightly toward that side, eyes looking away naturally, not posing.

Skin tone is lightly sun-kissed with a soft creamy glow, realistic skin texture, subtle pores and highlights - no plastic look.
Makeup is striking but refined: defined eyes, bold lashes, sculpted cheeks, soft contour, and natural glossy lips - editorial beauty campaign quality.
Lighting is warm golden hour sunlight, wrapping around her silhouette and hair, creating soft highlights and cinematic contrast.
Background is an urban street with cars and city lights rendered in strong bokeh, shallow depth of field - focus locked on the woman.

Shot on a full-frame cinema camera, 85mm lens, f/1.8, ultra-realistic detail, high dynamic range, cinematic color grading, film-like tones, premium fashion editorial aesthetic, high-budget movie still feeling.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 321, 'OpenNana', 'https://opennana.com/awesome-prompt-gallery/urban-sunset-fashion-silhouette', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-321', '/images/case321.jpg', 'A Hyper-realistic Cinematic Fashion Photograph of a Stunning', '["Realistic","3D"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-320', 'A Dramatic Cinematic Poster-style Portrait of Two Epic', 'Template imported from awesome-gpt-image-2 case 320. Source: @Naiknelofar788.', 'Posters & Typography', 'A dramatic cinematic poster-style portrait of two epic fantasy warriors standing back-to-back in a frozen storm. On the left, a battle-worn male warrior with wet, curly dark hair, head bowed in quiet resolve, gripping a medieval sword planted into the ice. Frost and snow cling to his fur-lined cloak and shoulders. On the right, a powerful female warrior in profile, pale skin glowing with fiery orange light, her body partially engulfed in flames thatcontrast against the icy blue atmosphere. Snow particles swirl through the air, blending fire and ice in a symbolic clash. Ultra-detailed faces, emotional intensity, volumetric fog, cinematic lighting, cold blue tones mixed with warm fire highlights, shallow depth of field, epic fantasy movie poster, hyper-realistic, 8K resolution, dramatic composition, sharp focus, high contrast, photorealistic textures.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 320, '@Naiknelofar788', 'https://x.com/Naiknelofar788/status/2025972876554510482', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-320', '/images/case320.jpg', 'A Dramatic Cinematic Poster-style Portrait of Two Epic', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-319', 'A Playful High-fashion Runway Scene Featuring a Confident', 'Template imported from awesome-gpt-image-2 case 319. Source: @MrDasOnX.', 'Scenes & Storytelling', 'A playful high-fashion runway scene featuring a confident woman walking a luxury fashion show catwalk, wearing an extraordinary couture dress made entirely of birds. Hundreds of elegant, vividly colored birds form the shape of a flowing, sculptural gown, layered like living feathers, with wings partially spread to create the illusion of fabric and motion. Some birds lift gently into the air around her, captured mid-flight, adding a magical, surreal sense of movement. The birds display a rich variety of colors - iridescent blues, radiant reds, golden yellows, and soft whites - with intricate feather details and natural textures. She poses mid-stride with a joyful, confident expression, expressive eyes, and refined runway makeup. Dramatic stage lighting with glowing highlights, dark blurred audience background, cinematic depth of field, fantasy realism, ultra-detailed textures, high contrast, sharp focus, whimsical luxury fashion show, surreal couture, 4K resolution, professional color grading.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 319, '@MrDasOnX', 'https://x.com/MrDasOnX/status/2026284342549340190', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-319', '/images/case319.jpg', 'A Playful High-fashion Runway Scene Featuring a Confident', '["Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-318', 'Ultra-realistic High-fashion Commercial Campaign Using the Uploaded Model', 'Template imported from awesome-gpt-image-2 case 318. Source: @Maercihh.', 'Products & E-commerce', 'Ultra-realistic high-fashion commercial campaign using the uploaded model photo as strict identity reference. Preserve exact facial features, proportions and natural skin texture - no retouching, no reshaping.
Scene: coral monochrome studio box with glossy reflective checker or minimal polished floor. Clean geometric walls with soft light gradients.
Product: the product placed oversized in the center foreground, dominating the frame due to wide-angle perspective. The packaging is ultra-sharp, fully readable, realistic reflections and material texture. Smaller product units can be placed symmetrically in the background.
Model pose: standing behind the product, slightly crouched or leaning forward, one hand reaching toward the camera to create depth. Strong confident expression, fashion attitude.
Camera: low-angle 24-35mm lens look, dramatic perspective distortion, deep focus on both product and model.
Lighting: bright commercial studio lighting, soft shadows, glossy highlights on packaging, high-end campaign finish. 4K-8K realism, no watermark, no embedded text.i ar 9:13', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 318, '@Maercihh', 'https://x.com/Maercihh/status/2026941078885310750', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-318', '/images/case318.jpg', 'Ultra-realistic High-fashion Commercial Campaign Using the Uploaded Model', '["Realistic","Product","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-317', 'Photorealistic Bold Beauty Campaign Using Uploaded Model as', 'Template imported from awesome-gpt-image-2 case 317. Source: @Maercihh.', 'Products & E-commerce', 'Photorealistic bold beauty campaign using uploaded model as exact identity reference. No facial changes, no smoothing.
Scene: deep red saturated studio environment with high-contrast floor pattern or glossy surface.
Product: the product held or positioned extremely close to the lens, appearing large due to perspective.
Model pose: playful or confident smile, arm fully extended toward camera, fingers slightly distorted by wide lens. Strong eye contact through sunglasses or natural gaze.
Camera: ultra-wide 20-28mm aesthetic, dynamic foreground exaggeration, shallow-to-medium depth of field.
Lighting: punchy commercial lighting with defined highlights and reflections, crisp packaging edges, vibrant color grading. Hyper-detailed skin texture and fabric realism.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 317, '@Maercihh', 'https://x.com/Maercihh/status/2026941078885310750', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-317', '/images/case317.jpg', 'Photorealistic Bold Beauty Campaign Using Uploaded Model as', '["Realistic","Product","Brand"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-316', 'Case 316 Illustration and Art Template', 'Template imported from awesome-gpt-image-2 case 316. Source: @Fujimoto_hina.', 'Illustration & Art', '{
  "prompt": "Ultra-realistic, vibrant photorealistic rendering of a young man with short curly dark hair, neatly trimmed beard, and black rectangular glasses, wearing a dark textured turtleneck sweater and jeans. He is captured mid-run in a dynamic, forward-breaking pose, dramatically emerging from a torn manga panel - one leg and one arm bursting into the real world while the rest of his body remains inside the comic frame. His expression is energetic and joyful, with sharp facial details, natural skin texture, and dramatic cinematic lighting with high contrast and depth. \n\nBackground: a highly detailed black-and-white manga layout filled with humorous, exaggerated reaction scenes that directly interact with him. The surrounding manga characters display shocked and comedic expressions, with bold speech bubbles and motion lines. The manga panels are illustrated in a classic high-contrast ink style with crisp linework and halftone shading. Torn paper edges and debris enhance the illusion of him breaking through the comic world. The fully colored, photorealistic figure contrasts strongly against the monochrome manga environment, creating a dynamic hybrid between reality and comic art. Ultra-detailed, 8k resolution, sharp focus, dramatic shadows, cinematic depth of field."
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 316, '@Fujimoto_hina', 'https://x.com/Fujimoto_hina/status/2027748030825500722', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-316', '/images/case316.jpg', 'Case 316 Illustration and Art Template', '["Realistic","Character","3D"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-315', 'Ultra-realistic Cinematic Fantasy Scene Set in a Lush', 'Template imported from awesome-gpt-image-2 case 315. Source: @MrDasOnX.', 'Scenes & Storytelling', 'Ultra-realistic cinematic fantasy scene set in a lush prehistoric jungle valley. A colossal Spinosaurus stands beside a shallow river, its long crocodile-like jaws stretched wide open. Seated calmly inside the dinosaur''s open mouth is a young woman, perfectly centered, legs hanging slightly forward. She has straight dark hair, a composed fearless expression, and realistic skin texture. She is wearing a fitted black long-sleeve crop top, blue denim shorts, and black knee-high combat boots. Small blood smears and light scratches are visible on her clothes and legs, adding dramatic tension without gore. She gently cradles a small baby dinosaur in her arms, holding it protectively.

Behind them, a tall dramatic waterfall cascades down steep jungle cliffs covered in dense green foliage and mist. Multiple dinosaurs populate the scene: several Velociraptors stalking the riverbank, small herbivores running through the background, and flying pterosaurs circling overhead. The environment is rich with mossy rocks, flowing water, tropical plants, and soft atmospheric fog.

Lighting is cinematic and natural, with diffused daylight illuminating the scene, detailed shadows, sharp focus on the woman and the Spinosaurus, and shallow depth of field for background elements. Hyper-real textures on dinosaur scales, teeth, water droplets, foliage, and fabric. Epic fantasy realism, dramatic composition, vertical framing, ultra-detailed, photorealistic, 4K, cinematic color grading, no text, no watermark.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 315, '@MrDasOnX', 'https://x.com/MrDasOnX/status/2028087254757867560', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-315', '/images/case315.jpg', 'Ultra-realistic Cinematic Fantasy Scene Set in a Lush', '["Poster","Realistic","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-314', 'Case 314 Posters and Typography Template', 'Template imported from awesome-gpt-image-2 case 314. Source: @Fujimoto_hina.', 'Posters & Typography', '{
  "prompt": "A hyper-realistic cinematic double exposure portrait of a young man in side profile, intense focused expression, detailed skin texture and sharp eyes. His face seamlessly blended with a futuristic city skyline emerging from his silhouette, skyscrapers and urban buildings forming his neck and jawline. Strong contrast of deep blue and vibrant red tones symbolizing conflict and power. Abstract digital scratches, fractured glass textures, and light leaks overlaying the face for a dramatic effect. Clean white background, ultra-detailed lighting, professional movie poster style, high contrast, sharp focus, 8K resolution, realistic hair strands, editorial poster composition, modern graphic design aesthetics, dramatic mood, ultra-HD, photorealistic.",
  "negative_prompt": "blurry, low resolution, distorted face, extra limbs, oversaturated colors, noisy background, flat lighting, cartoonish, low detail",
  "resolution": "8K",
  "style": "cinematic, double exposure, photorealistic, editorial poster",
  "background": "clean white",
  "lighting": "high contrast, dramatic blue and red split lighting"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 314, '@Fujimoto_hina', 'https://x.com/Fujimoto_hina/status/2028045894088630679', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-314', '/images/case314.jpg', 'Case 314 Posters and Typography Template', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Fashion","Travel"]'::jsonb, FALSE, TRUE),
    ('case-313', ', Product : , Surroundings : , Flowers', 'Template imported from awesome-gpt-image-2 case 313. Source: @Fujimoto_hina.', 'Products & E-commerce', '{
  "style": "Ultra-realistic luxury cosmetic product photography",
  "composition": {
    "color_scheme": "Dramatic monochromatic blue-violet",
    "resolution": "8K ultra-high resolution",
    "depth": "Cinematic depth",
    "aesthetic": "High-end perfumed skincare advertising style"
  },
  "product": {
    "type": "Squeeze tube",
    "finish": "Satin-finish",
    "color": "Periwinkle-blue",
    "label": "NUBELLA",
    "typography": "Elegant silver",
    "cap": "Reflective metallic chrome",
    "position": "Vertically centered"
  },
  "surroundings": {
    "smoke": {
      "type": "Ink-like swirling clouds",
      "colors": [
        "Lavender",
        "Indigo",
        "Icy blue"
      ],
      "texture": "Soft, billowing",
      "interaction": "Wrapping around the product"
    },
    "flowers": {
      "primary": [
        {
          "color": "Purple",
          "details": "Intricate petal details",
          "center": "Vibrant yellow"
        },
        {
          "color": "Lilac",
          "details": "Intricate petal details",
          "center": "Vibrant yellow"
        }
      ],
      "secondary": {
        "type": "Tiny violet blossoms",
        "purpose": "Added dimension"
      }
    }
  },
  "lighting": {
    "direction": "Soft directional lighting from upper left",
    "effects": [
      "Highlights smooth curvature of the tube",
      "Adds subtle sheen to metallic cap",
      "Creates depth within smoke plumes"
    ]
  },
  "background": {
    "blend": "Seamless cool blue and purple tones",
    "enhancement": "Ethereal floral fragrance aesthetic"
  },
  "details": "Hyper-detailed textures of petals and vapor"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 313, '@Fujimoto_hina', 'https://x.com/Fujimoto_hina/status/2027903683154088431', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-313', '/images/case313.jpg', ', Product : , Surroundings : , Flowers', '["Poster","Realistic","Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-312', 'Case 312 Posters and Typography Template', 'Template imported from awesome-gpt-image-2 case 312. Source: @Fujimoto_hina.', 'Posters & Typography', '{
  "prompt": "Three ultra-dynamic soda cans in one vibrant high-end advertising composition - a can of TROPICAL RUSH exploding with dramatic water and tropical fruit splash, vibrant orange and pink background lighting; a can of LEMON ICED splashed with cold water against a glowing green dynamic light background; both cans covered in realistic condensation and motion-blurred droplets, bursting with fruity, refreshing energy. Deep orange, pink, and neon green lighting blend together in a bold studio setup. Captured by a professional photographer using a Canon 50mm lens, hyper-realistic textures, crisp details, ultra high resolution, bright commercial poster aesthetic, rich color vibrancy, cinematic splash effects --ar 3:4"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 312, '@Fujimoto_hina', 'https://x.com/Fujimoto_hina/status/2028388808320819277', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-312', '/images/case312.jpg', 'Case 312 Posters and Typography Template', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-311', 'Horizontal Triptych of a Woman in a Lavender', 'Template imported from awesome-gpt-image-2 case 311. Source: @Naiknelofar788.', 'Photography & Realism', 'Horizontal triptych of a woman in a lavender field at sunrise.
Top: Waist-up, eyes closed, pale lilac dress, one hand in hair, blurred lavender foreground.
Middle: Close-up, looking at camera, tousled hair, sheer scarf, sunlight on face.
Bottom: Three-quarter shot, holding lavender bouquet, flowing skirt, soft pastel sky, warm dreamy tones.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 311, '@Naiknelofar788', 'https://x.com/Naiknelofar788/status/2028417667846341062', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-311', '/images/case311.jpg', 'Horizontal Triptych of a Woman in a Lavender', '["Realistic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-310', 'Snack Brand Technical Breakdown', 'Template imported from awesome-gpt-image-2 case 310. Source: @TechieBySA.', 'Brand & Logos', 'Create a branded technical infographic of a [SNACK], combining a realistic photograph or photoreal render of the product with technical annotation overlays placed directly on top. Use black ink-style line drawings with strategic [BRAND COLOR] accents (architectural sketch look) on a pure white studio background, including:
• Key component labels
• Internal cross-section showing structure, layering, or internal design
• Measurements, dimensions, and specifications
• Material callouts with composition and quantities
• Arrows indicating function for primary features and structural integrity
• Simple schematic or sectional diagram showing key mechanical or design elements
• Sustainability callouts
Title placement: Inside a hand-drawn technical annotation box with accent border reading the product name in bold font, positioned in upper corner.
Style & layout rules:
• The realistic product remains clearly visible
• Annotations feel sketched, technical, and architectural
• Accents used for highlight (20-30% of linework), black for primary technical lines (70-80%)
• Clean composition with balanced negative space
• Educational, food-engineering vibe with premium branding
• Include subtle brand logo mark in corner
Visual style: Minimal technical illustration aesthetic, black linework with accents over realistic imagery, precise but slightly hand-drawn feel.
Color palette: White background, black annotation lines/text, [BRAND COLOR] for accents and key callouts only.
Output: 1080×1080, ultra-crisp, social-feed optimized, no watermark.​​​​​​​​​​​​​​​​', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 310, '@TechieBySA', 'https://x.com/TechieBySA/status/2031795709243019280', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-310', '/images/case310.jpg', 'Snack Brand Technical Breakdown', '["Infographic","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, TRUE, TRUE),
    ('case-309', 'Made Entirely from Natural Leaves, Creative Leaf Collage', 'Template imported from awesome-gpt-image-2 case 309. Source: @meng_dagg695.', 'Other Use Cases', '{
  CHARACTER NAME
} made entirely from natural leaves,
creative leaf collage art,
layered green and dry leaves forming body,
face and clothes,
visible leaf veins and textures,
handcrafted botanical art style,
clean white background,
top-down flat lay composition,
highly detailed,
soft natural lighting,
realistic leaf textures,
8k', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 309, '@meng_dagg695', 'https://x.com/meng_dagg695/status/2032019839070716170', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-309', '/images/case309.jpg', 'Made Entirely from Natural Leaves, Creative Leaf Collage', '["Realistic","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-308', '9:16 Aspect Ratio, Generate a Screenshot of a', 'Template imported from awesome-gpt-image-2 case 308. Source: @_FORAB.', 'UI & Interfaces', '9:16 aspect ratio, generate a screenshot of a Douyin live stream, inside is xxx live streaming, xxx is holding a sign in their hand, the sign says xxxx.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 308, '@_FORAB', 'https://x.com/_FORAB/status/2044744023261519920', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-308', '/images/case308.jpg', '9:16 Aspect Ratio, Generate a Screenshot of a', '["UI"]'::jsonb, '["Social"]'::jsonb, FALSE, TRUE),
    ('case-307', 'A 2026 City Promotional Poster Filled with a', 'Template imported from awesome-gpt-image-2 case 307. Source: @liyue_ai.', 'Posters & Typography', 'A 2026 city promotional poster filled with a festive Spring Festival atmosphere without losing its elegant style.
Double exposure, the composition continues the flowing sense of an S-shape;
In the lower right corner of the pure white textured background, a miniature figure wearing traditional Chinese clothing is waving a long red silk dance ribbon. This red silk dances in the air, not only showing the smooth texture of the silk, but also magically transforming into a magnificent mountain range and river during the process of floating to the upper left.
In this "river", a hand-drawn map of Guangzhou city with mountains, sea, and rivers is superimposed, Guochao, the scenery is in full view, magnificent and majestic, shocking.
Guangzhou''s landmark buildings (Canton Tower, Pearl River New City building complex, Pearl River, ancient buildings in Guangzhou city, cruise ships, Baiyun Mountain).
Surrounded by clouds and mist, ethereal and misty, rich in color, complex in structure, rich in details, but because of a large area of blank space, the picture still looks fresh and refined. In the lower left corner, "SPRING 2026" and vertical promotional slogans are typeset. The overall implication is "Millennium Commercial Capital, Charming Guangzhou".
The typography is beautiful and generous, the handwriting is clear and complete, aspect ratio 9:16.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 307, '@liyue_ai', 'https://x.com/liyue_ai/status/2045332620352119274', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-307', '/images/case307.jpg', 'A 2026 City Promotional Poster Filled with a', '["UI","Poster","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-306', 'Based on This Character and Background, Please Create', 'Template imported from awesome-gpt-image-2 case 306. Source: @MANISH1027512.', 'Characters & People', 'Based on this character and background, please create a character reference sheet similar to official setting materials.
・Includes three-view drawings: front view, side view, and back view
・Add variations of the character''s facial expressions
・Break down and display detailed parts of the clothing and equipment
・Add a color palette
・Include a brief explanation of the worldview setting
・Overall, use an organized layout (white background, illustration style)', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 306, '@MANISH1027512', 'https://x.com/MANISH1027512/status/2045013913901867334', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-306', '/images/case306.jpg', 'Based on This Character and Background, Please Create', '["UI","Illustration","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-305', '35mm Film Photography with Harsh Convenience Store Fluorescent', 'Template imported from awesome-gpt-image-2 case 305. Source: @BubbleBrain.', 'Photography & Realism', '35mm film photography with harsh convenience store fluorescent lighting mixed with colorful neon signs from outside, authentic film grain, high contrast, slight color cast, cinematic street editorial style, intimate medium shot, early 20s sexy Chinese female idol with ultra-realistic delicate refined Chinese features, seductive almond-shaped fox eyes with natural double eyelids, high nose bridge, small sharp V-shaped jawline, flawless porcelain skin with cool ivory undertone and visible specular highlights from fluorescent light, subtle skin texture and micro pores, natural dewy makeup with soft flush on cheeks, glossy natural pink lips slightly parted, subtle natural freckles across nose and cheeks, long dark brown hair in a messy high ponytail with many loose strands falling around face and neck, wearing an oversized white button-up shirt as the only top, unbuttoned at the top with deep cleavage and loosely tied at the waist, paired with a tiny black pleated mini skirt, barefoot in simple white slides, seductive casual leaning pose against the glass door of a 24-hour convenience store at late night, body slightly arched, one leg bent with foot resting against the door frame, the other leg straight, one hand holding a bottle of iced drink, the other hand lightly pulling the hem of her mini skirt, intensely seductive playful yet slightly vulnerable gaze straight at the viewer with soft doe eyes full of quiet temptation and teasing smile, bright cold fluorescent store light from inside mixed with pink and blue neon glow from outside signs, realistic reflections on glass door, blurred convenience store interior with shelves and snacks in background, authentic 35mm film color grading with harsh lighting and neon accents, extremely sharp yet soft skin rendering, natural hair strands, realistic fabric wrinkles and drape on the oversized shirt and mini skirt, no plastic skin, no digital over-sharpening, no airbrushing, no blemishes, no moles, no oily skin, no watermark, no text, authentic late-night convenience store atmosphere', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 305, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2045167461147042202', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-305', '/images/case305.jpg', '35mm Film Photography with Harsh Convenience Store Fluorescent', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-304', 'Minimalism, Neo-chinese Style Three-dimensional Graphic Design, at the', 'Template imported from awesome-gpt-image-2 case 304. Source: @liyue_ai.', 'Posters & Typography', 'Minimalism, Neo-Chinese style three-dimensional graphic design, at the bottom of the image there are Chinese characters in regular script: "东方美学", "2026/04/18", signature "CHINA", and "
@LIYUE
";
Drawn on flat, pure white matte textured thick art paper, a creative landscape painting full of oriental poetic atmosphere, irregular torn paper effect;
Chinese mythical beast: Qiongqi, complete body pattern, magnificent,, soft and agile lines, bright piercing eyes, majestic demeanor, elegant posture, luxury decorative art, Chinese traditional patterns;
Fluorescent blue lines, 0.5mm ultra-fine gold metallic texture outlining, large strokes of splashed white ink, color rendering, red background, romantic and poetic blue vision;
Dreamy and aesthetic scene where cold and warm lights intertwine, strong light and shadow contrast atmosphere, time narrative of flowers dancing lightly, Oriental Zen, the picture has a large area of blank space, framework composition, blank space at the bottom, clear details.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 304, '@liyue_ai', 'https://x.com/liyue_ai/status/2045506567735558336', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-304', '/images/case304.jpg', 'Minimalism, Neo-chinese Style Three-dimensional Graphic Design, at the', '["Illustration","Character","3D"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-303', 'Generate a Page from the Pep People''s Education', 'Template imported from awesome-gpt-image-2 case 303. Source: @MrLarus.', 'Documents & Publishing', 'Generate a page from the PEP (People''s Education Press) primary school third-grade Chinese textbook', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 303, '@MrLarus', 'https://x.com/MrLarus/status/2044824800909054181', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-303', '/images/case303.jpg', 'Generate a Page from the Pep People''s Education', '["Documents"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-302', 'A Nine-grid Image Showing the Same Group of', 'Template imported from awesome-gpt-image-2 case 302. Source: @TanShilong.', 'Other Use Cases', 'A nine-grid image showing the same group of objects designed by nine contemporary famous designers: mechanical keyboards, including designer avatars, designers'' Chinese text interpretations of the designs, and artwork presentations. Unified layout rules', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 302, '@TanShilong', 'https://x.com/TanShilong/status/2045148649869692982', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-302', '/images/case302.jpg', 'A Nine-grid Image Showing the Same Group of', '["Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-301', 'Generate Image: Taobao Product Detail Page of a', 'Template imported from awesome-gpt-image-2 case 301. Source: @rionaifantasy.', 'Products & E-commerce', 'Generate image:
Taobao product detail page of a T-800 robot, showing:
front, side, and back three-view drawings of the robot,
product price,
product details,
functions and usage scenarios', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 301, '@rionaifantasy', 'https://x.com/rionaifantasy/status/2045356799751303194', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-301', '/images/case301.jpg', 'Generate Image: Taobao Product Detail Page of a', '["Product"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-300', 'Generate Image: the Full Text of Chu Shi', 'Template imported from awesome-gpt-image-2 case 300. Source: @rionaifantasy.', 'Photography & Realism', 'Generate image: The full text of Chu Shi Biao handwritten on a classroom blackboard, realistic chalk handwriting, taken with an iPhone in real life on a sunny day', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 300, '@rionaifantasy', 'https://x.com/rionaifantasy/status/2045356799751303194', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-300', '/images/case300.jpg', 'Generate Image: the Full Text of Chu Shi', '["Realistic"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-299', 'Express in a Graffiti Sketch Style, Presenting an', 'Template imported from awesome-gpt-image-2 case 299. Source: @VoxcatAI.', 'Illustration & Art', 'Express [Subject/Theme] in a graffiti sketch style, presenting an overall visual effect of quick outlining, free deformation, impromptu hand-drawing, and draft-like appearance. The lines are casual, exaggerated, and can vary in thickness, slightly messy but rhythmic and expressive, emphasizing generalization, exaggeration, playfulness, and spontaneity, rather than rigorous realism or detailed rendering. Colors are expressed in rough blocks with a distinct dry-brush feel, retaining uneven smearing traces, brush strokes, dry-brush effects, and a sense of coverage. Colors automatically adapt to [Subject/Theme], but the overall expression remains graffiti-style, sketch-style, and generalized. Do not use transparent watercolor blooming effects, do not use delicate watercolor transitions, do not use paper textures, do not use soft atomization, and do not use dreamy textures. The background is mainly left blank, maintaining a sense of simplicity, relaxation, incompleteness, and design. A small number of auxiliary symbols, arrows, marks, circled areas, repeated lines, casually written text, or other graffiti elements can be added to enhance the visual language of a sketchbook or jotting style, but it must not be too crowded, and must not destroy the subject and the blank space temperament. The image content does not need to be written out in advance; the most suitable subject image, actions, related elements, symbols, or simplified scenes are automatically deduced and generated by [Subject/Theme], keeping the overall unified graffiti sketch style and exaggerated generalized expression, avoiding complex realistic backgrounds and over-elaboration. The exclusive signature "voxcat" needs to be naturally added to the image as a part of the picture. The position should be low-key but clear, and can be placed in the bottom left corner, bottom right corner, or near the title. The style must be consistent with the overall layout, like an artwork signature or a design sign-off; the signature font should be exquisite, restrained, and high-end, must not be too large, must not destroy the subject composition, and must not appear abrupt or cheap.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 299, '@VoxcatAI', 'https://x.com/VoxcatAI/status/2045131503001342302', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-299', '/images/case299.jpg', 'Express in a Graffiti Sketch Style, Presenting an', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-298', 'A Striking Spring 2026 City Poster for Boston', 'Template imported from awesome-gpt-image-2 case 298. Source: @BubbleBrain.', 'Posters & Typography', 'A striking Spring 2026 city poster for Boston with an elegant celebratory mood and a bold contemporary design. On a clean off-white textured background with large areas of negative space, a miniature single sculler rows across the lower right corner of the image on a narrow ribbon of reflective water. The wake from the oar sweeps upward in a dynamic calligraphic curve, gradually transforming into the Charles River and then into a dreamlike hand-painted panorama of Boston. Inside this flowing river-shaped composition are iconic Boston elements: the Back Bay skyline, Beacon Hill brownstones, Acorn Street, Boston Public Garden, Swan Boats, Zakim Bridge, Fenway-inspired details, historic brick architecture, harbor ferries, and the city''s waterfront atmosphere. Soft morning fog, golden spring light, subtle festive accents in crimson and gold, rich detail, layered depth, sophisticated city-poster aesthetics, fresh and refined, visually powerful but not overcrowded. Elegant typography in the lower left reads "SPRING 2026" with a vertical slogan "BOSTON, A CITY OF RIVER, MEMORY, AND INVENTION", text clear and beautifully composed, premium graphic design, 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 298, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2045358053831172358', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-298', '/images/case298.jpg', 'A Striking Spring 2026 City Poster for Boston', '["Poster","Brand","Character"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-297', 'Handwritten Recipe Professional Cookbook Page Upload a Messy', 'Template imported from awesome-gpt-image-2 case 297. Source: @maxescu.', 'Other Use Cases', 'Handwritten Recipe → Professional Cookbook Page Upload a messy handwritten family recipe; the model searches for accurate modern measurements/nutrition, then generates a polished, magazine-style double-page spread with step-by-step flat lays, perfect ingredient labels, and calorie breakdowns.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 297, '@maxescu', 'https://x.com/maxescu/status/2045203839910056014', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-297', '/images/case297.jpg', 'Handwritten Recipe Professional Cookbook Page Upload a Messy', '["Other Use Cases"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-296', 'Please Automatically Generate a Based on the', 'Template imported from awesome-gpt-image-2 case 296. Source: @MrLarus.', 'Charts & Infographics', 'Please automatically generate a "museum catalog-style Chinese disassembly infographic" based on the [Subject].

The entire image is required to combine a realistic main visual, structural disassembly, Chinese annotations, material descriptions, pattern meanings, color meanings, and core feature summaries. You need to automatically determine the most appropriate main subject, clothing system, artifact structure, era style, key components, material craftsmanship, color scheme, and layout structure based on the [Subject], and the user does not need to provide any other information.

The overall style should be: national museum exhibition boards, historical clothing catalogs, and cultural/museum thematic infographics, rather than ordinary posters, ancient-style portraits, e-commerce detail pages, or anime illustrations. The background uses paper textures such as off-white, silk white, and light tea color, making the overall look premium, restrained, professional, and collectible.

The layout is fixed as:
- Top: Chinese main title + subtitle + introduction
- Left: Structural disassembly area, with Chinese lead lines annotating key components, accompanied by close-up details
- Upper right: Material / craftsmanship / texture area, displaying real texture samples with descriptions
- Middle right: Pattern / color / meaning area, displaying the main color palette, pattern samples, and cultural explanations
- Bottom: Dressing order / composition flowchart + core feature summary

If the subject is suitable for character display, use a full-body standing posture of a real person as the central subject; if it is more suitable for artifacts or single structures, change it to a central subject disassembly diagram, but the overall form remains a complete Chinese infographic. All text must be in Simplified Chinese, clear, neat, and readable, without garbled characters, typos, English, or pinyin. The focus is on highlighting real structures, material differences, cultural explanations, and a catalog atmosphere.

Avoid: poster feel, studio portrait feel, e-commerce feel, anime feel, cosplay feel, random annotations, incorrect structures, blurry text, fake materials, excessive decoration.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 296, '@MrLarus', 'https://x.com/MrLarus/status/2045504669401653414', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-296', '/images/case296.jpg', 'Please Automatically Generate a Based on the', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-295', 'Generate an Old Almanac for April 18, 2026', 'Template imported from awesome-gpt-image-2 case 295. Source: @MrLarus.', 'Other Use Cases', 'Generate an old almanac for April 18, 2026', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 295, '@MrLarus', 'https://x.com/MrLarus/status/2044824800909054181', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-295', '/images/case295.jpg', 'Generate an Old Almanac for April 18, 2026', '["Other Use Cases"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-294', 'Generate a Teochew Restaurant Menu Image', 'Template imported from awesome-gpt-image-2 case 294. Source: @MrLarus.', 'Brand & Logos', 'Generate a Teochew restaurant menu image.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 294, '@MrLarus', 'https://x.com/MrLarus/status/2044824800909054181', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-294', '/images/case294.jpg', 'Generate a Teochew Restaurant Menu Image', '["Brand"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-293', 'Generate a Campus Daily Newspaper, Theme Ai Education', 'Template imported from awesome-gpt-image-2 case 293. Source: @MrLarus.', 'Documents & Publishing', 'Generate a campus daily newspaper, theme AI education', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 293, '@MrLarus', 'https://x.com/MrLarus/status/2044824800909054181', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-293', '/images/case293.jpg', 'Generate a Campus Daily Newspaper, Theme Ai Education', '["Documents"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-292', 'Create a New X Post Page Illustrated for', 'Template imported from awesome-gpt-image-2 case 292. Source: @tuzi_ai.', 'History & Classical Themes', 'Create a new X post page illustrated for Baoyu (refer to the homepage and some posts of this Twitter user at https://x.com/dotey) after time-traveling to the Ming Dynasty and ascending the throne, based on his business/personality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 292, '@tuzi_ai', 'https://x.com/tuzi_ai/status/2045193918736736365', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-292', '/images/case292.jpg', 'Create a New X Post Page Illustrated for', '["Classical"]'::jsonb, '["Social","History"]'::jsonb, FALSE, TRUE),
    ('case-291', 'Create a Sparkling Flyer Like Those of a', 'Template imported from awesome-gpt-image-2 case 291. Source: OpenNana.', 'Posters & Typography', 'Create a sparkling flyer like those of a pachinko parlor at a 3:4 aspect ratio. Place a realistic, highly detailed modern cute Japanese woman. Make full use of sparkling, three-dimensional richly decorated rainbow typography, etc., and be sure to achieve extreme luxury. Introduce several non-existent fictional new models side by side.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 291, 'OpenNana', 'https://opennana.com/awesome-prompt-gallery/luxurious-pachinko-flyer', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-291', '/images/case291.jpg', 'Create a Sparkling Flyer Like Those of a', '["Poster","Realistic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-290', 'Design a Set of Game Cards for Ancient', 'Template imported from awesome-gpt-image-2 case 290. Source: @TanShilong.', 'Other Use Cases', 'Design a set of game cards for ancient Chinese poets, classified by SSR SR R grades, with key cards having an enlarged display effect, including card face design and character introduction, having a very high-end game card texture, rare cards will also have special light and shadow effects such as holographic laser effects, requiring set card design and skill design, along with relatively detailed descriptions', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 290, '@TanShilong', 'https://x.com/TanShilong/status/2045435090923356415', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-290', '/images/case290.jpg', 'Design a Set of Game Cards for Ancient', '["UI","Character","Classical"]'::jsonb, '["Tech","Commerce","History"]'::jsonb, FALSE, TRUE),
    ('case-289', 'Generate a Screenshot of Trump and Kim Jong-un', 'Template imported from awesome-gpt-image-2 case 289. Source: @rionaifantasy.', 'UI & Interfaces', 'Generate a screenshot of Trump and Kim Jong-un doing a PK battle in a TikTok live stream room', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 289, '@rionaifantasy', 'https://x.com/rionaifantasy/status/2045356799751303194', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-289', '/images/case289.jpg', 'Generate a Screenshot of Trump and Kim Jong-un', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-288', 'Generate a Tiktok Live Stream Interface, the Content', 'Template imported from awesome-gpt-image-2 case 288. Source: @msjiaozhu.', 'UI & Interfaces', 'Generate a TikTok live stream interface, the content is a beautiful woman live streaming', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 288, '@msjiaozhu', 'https://x.com/msjiaozhu/status/2045470160576999812', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-288', '/images/case288.jpg', 'Generate a Tiktok Live Stream Interface, the Content', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-287', 'Generate a Screenshot of Mai Shiranui''s Xiaohongshu Homepage', 'Template imported from awesome-gpt-image-2 case 287. Source: @rionaifantasy.', 'UI & Interfaces', 'Generate a screenshot of Mai Shiranui''s Xiaohongshu homepage', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 287, '@rionaifantasy', 'https://x.com/rionaifantasy/status/2045356799751303194', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-287', '/images/case287.jpg', 'Generate a Screenshot of Mai Shiranui''s Xiaohongshu Homepage', '["UI"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-286', 'Paper-cut Art Inspired by the Modern Urban Landscape', 'Template imported from awesome-gpt-image-2 case 286. Source: @liyue_ai.', 'Other Use Cases', 'Paper-cut art inspired by the modern urban landscape of Zhujiang New Town, through exquisite hollow-carving techniques on a single sheet of paper, three-dimensionally depicting landmark buildings such as Canton Tower, East and West Twin Towers, and the bustling cityscape. All buildings and elements are connected by smooth lines and structures, with no isolated parts, forming a complete urban scroll. The picture uses metallic foil or glossy paper material, with delicate light and dark gloss on the surface, presenting soft highlights and shadows under illumination, as if gently illuminated by city lights. The background is set against a blurred Zhujiang New Town skyline, dotted with faintly visible outlines of Huacheng Square and trees, overall revealing a modern romantic atmosphere. The work cleverly integrates light dandelion fluff or starlight-like dynamic light points, symbolizing dreams and vitality fluttering and flying in this new city. The overall presents 8K ultra-high-definition vision, rich in details, realistic and full of artistic appeal.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 286, '@liyue_ai', 'https://x.com/liyue_ai/status/2045527750606487877', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-286', '/images/case286.jpg', 'Paper-cut Art Inspired by the Modern Urban Landscape', '["UI","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-285', 'Show Me the Attached Image as a Snapshot', 'Template imported from awesome-gpt-image-2 case 285. Source: @Thereallo1026.', 'UI & Interfaces', 'Show me the attached image as a snapshot from an actual anime', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 285, '@Thereallo1026', 'https://x.com/Thereallo1026/status/2044241997163311569', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-285', '/images/case285.jpg', 'Show Me the Attached Image as a Snapshot', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-284', 'A Stunning 18-year-old Chinese Girl with a Youthful,', 'Template imported from awesome-gpt-image-2 case 284. Source: @Shinning1010.', 'Photography & Realism', 'A stunning 18-year-old Chinese girl with a youthful, pure face and realistic skin texture, sitting on a cozy, slightly messy bed in her bedroom. She is taking a mirror selfie with a smartphone, capturing a natural and intimate moment. Wearing casual gray loungewear and neat white crew socks. Soft natural light (golden hour) streams in from a side window, creating a warm, moody, and cinematic atmosphere. 35mm lens, sharp focus on the subject in the mirror, depth of field with a beautifully blurred background (bokeh). Photorealistic, 8K, high resolution, studio quality, masterpiece.
Negative Prompts: no extra limbs, no deformed hands, no blur, no noise, no watermark, no text, no cartoon/anime style. Aspect Ratio: 3:4.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 284, '@Shinning1010', 'https://x.com/Shinning1010/status/2045002808903020962', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-284', '/images/case284.jpg', 'A Stunning 18-year-old Chinese Girl with a Youthful,', '["Realistic"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-283', 'That with Just a Few Images This Quality', 'Template imported from awesome-gpt-image-2 case 283. Source: @lilimliliychan.', 'Posters & Typography', 'that "Think of a poster when the little devil Lilim Lily-chan was a Super Famicom game" with just a few images
this quality without any detailed explanation spells is amazing!', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 283, '@lilimliliychan', 'https://x.com/lilimliliychan/status/2045114760937804187', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-283', '/images/case283.jpg', 'That with Just a Few Images This Quality', '["Poster"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-282', 'Generate a Portrait Mobile Phone Screenshot Style Image,', 'Template imported from awesome-gpt-image-2 case 282. Source: @Zoulinshen.', 'UI & Interfaces', 'Generate a portrait mobile phone screenshot style image, with an overall aspect ratio close to 9:16. In the upper center of the frame is a real-life coser, playing a 2D anime character named (Character Name). The character is in a realistic style, but with facial features slightly showing an anime feel, delicate skin, slightly larger eyes, a gentle expression looking at the camera, sitting in an indoor casual scene, such as in front of a cafe or bar counter, with background props fitting the scene. At the very top of the image, add a mobile phone system status bar UI, including icons for time, battery, signal, and network, to make the whole image look like a mobile phone screenshot. At the bottom of the image, overlay a wide semi-transparent galgame style dialog box, place an anime or Q-version avatar corresponding to the character in the image on the left side of the dialog box; on the right side of the dialog box, typeset text: the first line displays the same character name as before in a larger font, the following one to two lines display a piece of Simplified Chinese dialogue suitable for this character''s personality, in a gentle and healing style, automatically created by you. Then add an operation bar below the dialog box, imitating the galgame UI. The overall style is high-definition, rich in details, with soft lighting, and a natural fusion of 2D anime and real-life photography.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 282, '@Zoulinshen', 'https://x.com/Zoulinshen/status/2045082518089810073', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-282', '/images/case282.jpg', 'Generate a Portrait Mobile Phone Screenshot Style Image,', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-281', 'I Had Chatgpt Create Images, and When I', 'Template imported from awesome-gpt-image-2 case 281. Source: @4WEB1.', 'Illustration & Art', 'I had ChatGPT create images, and when I had it create them again today, it might be GPT image 2, and it seems like the quality has changed, so I''m making a note of it

The light blue and yellow one on the left is from last week
The purple one on the right is from today

I feel like the transparency, resolution, and fineness are different for the one on the right.

Prompt
Draw a near-future sci-fi version of a mandala', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 281, '@4WEB1', 'https://x.com/4WEB1/status/2045390207072256179', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-281', '/images/case281.jpg', 'I Had Chatgpt Create Images, and When I', '["Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-280', 'Express in a Graffiti Sketch Style, Overall Presenting', 'Template imported from awesome-gpt-image-2 case 280. Source: OpenNana.', 'UI & Interfaces', 'Express [an awesome AI builder] in a graffiti sketch style, overall presenting a visual effect of quick sketching, free deformation, impromptu hand-drawing and draft-like. The lines are casual, exaggerated, and can vary in thickness, slightly messy but with rhythm and expressiveness, emphasizing summarization, exaggeration, fun and casualness, rather than rigorous realism or fine depiction. The colors use rough blocks with obvious dry brush feel, retaining uneven smearing traces, brush strokes, flying white and covering feel, the colors automatically adapt according to [theme/subject], but overall maintain a graffiti-style, sketch-style, and summarized expression. Do not use transparent watercolor smudging effects, do not use delicate watercolor transitions, do not use paper texture, do not use soft atomization, do not use dreamy texture. The background is mainly blank, keeping it simple, relaxed, unfinished and designed, can add a small amount of auxiliary symbols, arrows, marks, circled drawings, repeated lines, casually written text or other graffiti elements, to enhance the sketchbook or essay-style visual language, but it must not be too crowded, and must not destroy the subject and blank temperament. The picture content does not need to be written clearly in advance; [an awesome AI builder] automatically deduces and generates the most suitable subject image, movements, related elements, symbols or simplified scenes, overall maintaining a unified graffiti sketch style and exaggerated summarized expression method, avoiding complex realistic backgrounds and excessive padding. The exclusive signature "BlanPlan" needs to be naturally added into the picture as a part of the picture, the position is low-key but clear, can be placed in the bottom left corner, bottom right corner or near the title, the style needs to be unified with the overall layout, like an artwork signature or design sign-off; the signature font is exquisite, restrained, and high-end, must not be too large, must not destroy the subject composition, must not appear abrupt or cheap.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 280, 'OpenNana', 'https://opennana.com/awesome-prompt-gallery/graffiti-sketch-ai-builder-master', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-280', '/images/case280.jpg', 'Express in a Graffiti Sketch Style, Overall Presenting', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-279', 'Minimalist Neo-chinese Aesthetic Style, the Picture Uses an', 'Template imported from awesome-gpt-image-2 case 279. Source: @liyue_ai.', 'Posters & Typography', 'Minimalist neo-Chinese aesthetic style, the picture uses an elegant grayish-white as the background, presenting a three-dimensional sense like paper art silhouettes. A winding S-shaped crack-like edge divides the picture, as if tearing open a layer of paper, revealing the colorful oriental landscape scene inside. Inside the crack, a winding river runs through the entire composition from top to bottom, the river water is rendered in different shades of blue, with clear layers, like a flowing ribbon. Both sides of the riverbank are dotted with verdant hills and terraced fields, the colors are soft, green and red interwoven, showing the tranquil beauty of the pastoral. Ancient-style buildings built along the river are well-proportioned, with flying eaves and upturned corners, white walls and black tiles, appearing more quaint and elegant against the light and shadow. The trees on the bank are lush, the branches and leaves are light and graceful, a small boat is quietly moored in the middle of the water, adding a bit of leisurely artistic conception. The overall composition presents an S-shaped curve, full of rhythm, as if the harmonious coexistence of nature and humanity. The edges of the painting adopt a torn paper effect, creating a visual experience like a three-dimensional relief. The inscription "东方美学" at the bottom is written in black regular script, the date "2026/04/18" echoes with the red seal, the word "CHINA" at the bottom is solemn and eye-catching, and the signature "@LIYUE" ends in a low-key way. The overall atmosphere is quiet and profound, full of poetry and philosophical thinking.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 279, '@liyue_ai', 'https://x.com/liyue_ai/status/2045368305079447853', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-279', '/images/case279.jpg', 'Minimalist Neo-chinese Aesthetic Style, the Picture Uses an', '["UI","Illustration","Classical"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-278', 'Modern Pencil Illustration of Vintage Travel Poster Illustration', 'Template imported from awesome-gpt-image-2 case 278. Source: @WolfRiccardo.', 'Posters & Typography', 'Modern pencil illustration of Vintage travel poster illustration of the Amalfi Coast, Italy, panoramic coastal cliff road scene, classic 1960s white car driving along a curved seaside road, deep blue Mediterranean sea with small sailboats, colorful pastel hillside village, bright blue sky with soft clouds, lemon tree branches with vibrant yellow lemons framing the foreground, warm summer sunlight, bold vibrant colors, retro 1950s travel poster style, cinematic composition, high detail, screen print texture, graphic illustration. Hand-drawn style, illustration with loose strokes and defined contours. High-contrast color palette, maintaining chromatic harmony between background and elements. Contemporary and decorative aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 278, '@WolfRiccardo', 'https://x.com/WolfRiccardo/status/2044562722491121718', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-278', '/images/case278.jpg', 'Modern Pencil Illustration of Vintage Travel Poster Illustration', '["Poster","Illustration"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-277', 'Luxury Glam Beauty Portrait:, Beautiful Black Woman, Youthful', 'Template imported from awesome-gpt-image-2 case 277. Source: @patrickassale.', 'Photography & Realism', 'Luxury Glam Beauty Portrait:, Beautiful Black woman, youthful spirit, creamy vanilla, silk press, mahogany red, subtle confidence, textured fabric, sapphire blue, minimal jewelry, beachside breeze, lens flare effect, nostalgic, cinematic lens, symmetrical composition, soft focus, high fashion photography, monochromatic, dewy finish, mysterious tension, layered elements', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 277, '@patrickassale', 'https://x.com/patrickassale/status/2044581766309060765', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-277', '/images/case277.jpg', 'Luxury Glam Beauty Portrait:, Beautiful Black Woman, Youthful', '["Realistic"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-276', 'A 2026 City Promotional Poster Full of a', 'Template imported from awesome-gpt-image-2 case 276. Source: @liyue_ai.', 'Posters & Typography', 'A 2026 city promotional poster full of a festive Chinese New Year atmosphere yet maintaining an elegant style.
Double exposure, the composition continues the flowing sense of an S-shape;
In the lower right corner of the pure white textured background, a miniature figure wearing traditional Chinese clothing is waving a long red silk dance ribbon, this red silk dances in the air, not only showing the smooth texture of the silk, but also in the process of drifting to the upper left, magically transforming into a magnificent mountain range and river.
In this "river", a hand-drawn map of Guangzhou city with mountains, sea, and rivers is superimposed, Guochao, the scenery is fully in view, magnificent and majestic, breathtaking.
Guangzhou''s landmark buildings (Canton Tower, Pearl River New City building complex, Pearl River, ancient buildings in Guangzhou city, cruise ships, Baiyun Mountain).
Surrounded by clouds and mist, ethereal and misty, rich in colors, complex in structure, rich in details, but because of a large area of negative space, the picture still appears fresh and refined, the lower left corner is typeset with "SPRING 2026" and vertical promotional slogans, the overall implication is "Millennium Commercial Capital, Charming Guangzhou".
Beautiful and generous typography, clear and complete handwriting, aspect ratio 9:16.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 276, '@liyue_ai', 'https://x.com/liyue_ai/status/2045332620352119274', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-276', '/images/case276.jpg', 'A 2026 City Promotional Poster Full of a', '["UI","Poster","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-275', 'A Cinematic Movie Poster Utilizing a Layered Montage', 'Template imported from awesome-gpt-image-2 case 275. Source: @old_pgmrs_will.', 'Posters & Typography', 'A cinematic movie poster utilizing a layered montage composition. In the background, a coastal town at sunset with calm ocean water reflecting a glowing sun glare, distant birds in a hazy sky, and the silhouette of utility poles along a coastal road. In the left midground, a middle-aged man with dark wavy hair in a dark grey jacket stands near a concrete sea wall, looking downward with a melancholic expression, backlit by the late afternoon sun. Dominating the right foreground is a large, closely cropped profile portrait of a young woman looking right; she wears a dark school sailor uniform with white stripes, has wet dark hair clinging to her face, and a single tear rolls down her cheek under soft, diffuse lighting. In the lower center foreground, a Shiba Inu dog looks upwards toward the right, its reddish-brown fur catching warm rim lighting. Along the very bottom edge is a horizontal film strip of five distinct rectangular scene thumbnails: a dog and girl on a beach, a girl on a bicycle looking at the water, a girl and man sitting at an indoor table, a man and girl standing facing each other on a beach, and a close-up of a girl hugging a Shiba Inu. Overlaid on the image is specific text. In the top left, large dark teal serif text reads ''The Quiet Between Winds'' with a subtitle below reading ''- To You, That Day -''. Below that, smaller dark serif body text reads ''What is lost will not return. And yet, when hearts connect, even just a little, we can face tomorrow again.''. On the mid-right side, dark serif text reads ''There was a time when you taught me how to live. I won''t forget it.''. In the bottom left, large white text reads ''OCTOBER 31 FRI. IN THEATERS''. In the lower right corner, small white sans-serif credit text reads ''Starring: Mako Fukunami / Shusaku Kirimine Original Story & Screenplay: Shibano Maruo Director: Nanami Imakura Theme Song: SyVa \"Umi no Mieru de\" (Dogstar★RECORDS) Production: \"Yūnagi no Shippo\" Film Partners Production Company: DABUSHIBANU-NU Distribution: GOODSHIBALERS ©2026 \"Yūnagi no Shippo\" Film Partners''."
  segmented:
    - layer_index: 0
      segment: "In the background, a coastal town at sunset with calm ocean water reflecting a glowing sun glare, distant birds in a hazy sky, and the silhouette of utility poles along a coastal road."
    - layer_index: 1
      segment: "In the left midground, a middle-aged man with dark wavy hair in a dark grey jacket stands near a concrete sea wall, looking downward with a melancholic expression, backlit by the late afternoon sun."
    - layer_index: 2
      segment: "Dominating the right foreground is a large, closely cropped profile portrait of a young woman looking right; she wears a dark school sailor uniform with white stripes, has wet dark hair clinging to her face, and a single tear rolls down her cheek under soft, diffuse lighting."
    - layer_index: 3
      segment: "In the lower center foreground, a Shiba Inu dog looks upwards toward the right, its reddish-brown fur catching warm rim lighting."
    - layer_index: 4
      segment: "Along the very bottom edge is a horizontal film strip of five distinct rectangular scene thumbnails: a dog and girl on a beach, a girl on a bicycle looking at the water, a girl and man sitting at an indoor table, a man and girl standing facing each other on a beach, and a close-up of a girl hugging a Shiba Inu."
    - layer_indices: [5, 6, 7, 8]
      segment: "Overlaid on the image is specific text. In the top left, large dark teal serif text reads ''The Quiet Between Winds'' with a subtitle below reading ''- To You, That Day -''. Below that, smaller dark serif body text reads ''What is lost will not return. And yet, when hearts connect, even just a little, we can face tomorrow again.''. On the mid-right side, dark serif text reads ''There was a time when you taught me how to live. I won''t forget it.''. In the bottom left, large white text reads ''OCTOBER 31 FRI. IN THEATERS''. In the lower right corner, small white sans-serif credit text reads ''Starring: Mako Fukunami / Shusaku Kirimine Original Story & Screenplay: Shibano Maruo Director: Nanami Imakura Theme Song: SyVa \"Umi no Mieru de\" (Dogstar★RECORDS) Production: \"Yūnagi no Shippo\" Film Partners Production Company: DABUSHIBANU-NU Distribution: GOODSHIBALERS ©2026 \"Yūnagi no Shippo\" Film Partners''."

negative: "flat lighting, untextured surfaces, symmetrical composition, empty bottom margin, missing text, translated text, paraphrased text, 3D render, cartoon, high-contrast harsh shadows, dry hair, bright cheerful expressions', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 275, '@old_pgmrs_will', 'https://x.com/old_pgmrs_will/status/2045440101359198302', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-275', '/images/case275.jpg', 'A Cinematic Movie Poster Utilizing a Layered Montage', '["UI","Poster","Product"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-274', 'A Hand-drawn Style City Food Map Themed Around', 'Template imported from awesome-gpt-image-2 case 274. Source: @Panda20230902.', 'Architecture & Spaces', 'A hand-drawn style city food map themed around Chengdu. The background is a bird''s-eye view hand-drawn simplified city map, marking main roads and landmarks, not pursuing precise proportions but pursuing a cute hand-drawn feel. Distributed on the map are exquisite hand-drawn small illustrations of 12 food locations: Chuandu Chuanxiang skewers at Chunxi Road (a bunch of bamboo skewers with various ingredients emitting steam), Sandapao at Kuanzhai Alley (three glutinous rice balls flying towards a copper plate), Danhonggao at Jianshe Road (golden and crispy, being flipped), hotpot at Yulin Road (nine-grid pot rolling and bubbling), etc. Each illustration accounts for about 5% of the map area, with handwritten store names and a recommendation phrase "the one with a queue even at 2 AM" next to it. The edge of the map is decorated with hand-drawn vines and chili peppers to form a border. There is a hand-drawn compass and legend description in the bottom right corner. The title "Chengdu · Foodie Walking Map" in the top left corner uses chubby round hand-drawn artistic fonts decorated with chili peppers. The overall art style is a mixed hand-drawn texture of watercolor and colored pencils, with colors mainly in warm tones (chili red, ginger yellow, emerald green), image ratio 1:1.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 274, '@Panda20230902', 'https://x.com/Panda20230902/status/2045396918965285111', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-274', '/images/case274.jpg', 'A Hand-drawn Style City Food Map Themed Around', '["UI","Illustration"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-273', 'Generate a Cinematic Minimal Portrait of a Solitary', 'Template imported from awesome-gpt-image-2 case 273. Source: @iam_miharbi.', 'Photography & Realism', 'Generate a cinematic minimal portrait of a solitary man standing in an intense orange to red gradient environment, strong silhouette lighting, deep shadow contrast, reflective glossy floor, symmetrical composition, minimal', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 273, '@iam_miharbi', 'https://x.com/iam_miharbi/status/2045151354679665101', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-273', '/images/case273.jpg', 'Generate a Cinematic Minimal Portrait of a Solitary', '["Photography"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-272', '35mm Film Photography, Warm Vintage Japanese Onsen Ryokan', 'Template imported from awesome-gpt-image-2 case 272. Source: @BubbleBrain.', 'Photography & Realism', '35mm film photography, warm vintage Japanese onsen ryokan aesthetic, soft ambient wooden lantern lighting mixed with gentle natural window light, subtle film grain, gentle color shift, high atmosphere editorial style, intimate medium shot, early 20s beautiful Chinese female idol with ultra-realistic delicate refined Chinese features, seductive almond-shaped fox eyes with natural double eyelids, high nose bridge, small sharp V-shaped jawline, flawless porcelain skin with warm ivory undertone, visible subtle skin texture and micro pores, soft natural makeup with dewy glow, subtle rosy flush on cheeks, natural soft pink lips slightly parted, long dark brown hair tied in a loose low bun with some messy strands falling around face and neck, wearing a loose white yukata (traditional Japanese bathrobe) deliberately slipped off one shoulder and loosely tied at the waist, the fabric slightly open revealing smooth skin and subtle cleavage, barefoot, seductive relaxed sitting pose on the edge of a traditional wooden engawa veranda at a vintage onsen ryokan, body slightly turned toward the camera, one leg bent with foot resting on the wooden floor, the other leg gently dangling, one hand lightly holding the yukata collar, the other hand resting on the wooden floor behind her for support, softly arched back to gently accentuate curves, intensely seductive yet gentle and inviting gaze straight at the viewer with soft doe eyes full of quiet temptation and warmth, warm wooden interior with paper sliding doors and distant steaming hot spring in soft focus, gentle rim lighting highlighting skin and fabric texture, authentic vintage film color grading with warm tones, extremely sharp yet soft skin rendering, natural hair strands, realistic fabric wrinkles and drape on the yukata, no plastic skin, no digital over-sharpening, no airbrushing, no blemishes, no moles, no oily skin, no watermark, no text, authentic 35mm film Japanese onsen ryokan atmosphere', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 272, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2045092449803284923', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-272', '/images/case272.jpg', '35mm Film Photography, Warm Vintage Japanese Onsen Ryokan', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-271', 'I Borrowed It and Tried Making a Character', 'Template imported from awesome-gpt-image-2 case 271. Source: @tsubaki_ew.', 'Characters & People', 'I borrowed it and tried making a character sheet using the rumored GPT-Image-2 Awesome(๑°ㅁ°๑)‼✧ It seems like it would turn out even better if I gave it various more instructions✨ The character is my alter ego that I asked Chappy to draw for me before( *¯ ꒳¯*) #GPTimage #AIgenerated', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 271, '@tsubaki_ew', 'https://x.com/tsubaki_ew/status/2045259289993048284', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-271', '/images/case271.jpg', 'I Borrowed It and Tried Making a Character', '["Character"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-270', 'Based on This Character and Background, Please Create', 'Template imported from awesome-gpt-image-2 case 270. Source: \[OpenNana]\(]\(<https://x.com/Toshi_nyaruo_AI/status/2045025277538107420>).', 'Characters & People', 'Based on this character and background, please create a character sheet like an official setting material.
・Include front, side, and back 3-view drawings ・Add character expression variations
・Disassemble and display detailed parts of costumes and equipment ・Add a color palette ・Include a brief explanation of the world view
・Overall organized layout
(White background, diagrammatic style)
・Aspect ratio 16:9 　←
High resolution, professional concept art style', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 270, '\[OpenNana]\(]\(<https://x.com/Toshi_nyaruo_AI/status/2045025277538107420>)', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-270', '/images/case270.jpg', 'Based on This Character and Background, Please Create', '["UI","Infographic","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-269', 'Generate a Screenshot of Wechat Channels Content, Theme:', 'Template imported from awesome-gpt-image-2 case 269. Source: @MrLarus.', 'UI & Interfaces', 'Generate a screenshot of WeChat Channels content, theme: middle-aged and elderly people should not blindly urge marriage, iPhone size', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 269, '@MrLarus', 'https://x.com/MrLarus/status/2045373105041007013', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-269', '/images/case269.jpg', 'Generate a Screenshot of Wechat Channels Content, Theme:', '["UI"]'::jsonb, '["Social"]'::jsonb, FALSE, TRUE),
    ('case-268', 'Please Create an X Page of King Taejo', 'Template imported from awesome-gpt-image-2 case 268. Source: @SKA_Neotype.', 'History & Classical Themes', 'Please create an X page of King Taejo Yi Seong-gye (right before carrying out the Wihwa Island Retreat - containing posts where he and General Choi Yeong are dissing each other).', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 268, '@SKA_Neotype', 'https://x.com/SKA_Neotype/status/2044637900978217334', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-268', '/images/case268.jpg', 'Please Create an X Page of King Taejo', '["History"]'::jsonb, '["Tech","Social"]'::jsonb, FALSE, TRUE),
    ('case-267', '/, Ancient and Modern Time-travel Humor Fusion Interface', 'Template imported from awesome-gpt-image-2 case 267. Source: @Panda20230902.', 'History & Classical Themes', '"Song Dynasty People''s Moments"/"SONG DYNASTY SOCIAL MEDIA FEED", Ancient and modern time-travel humor fusion interface design style, The image simulates a mobile phone social media interface, but the content is entirely Song Dynasty scenes, The avatar is a portrait of a Song Dynasty literati, Username "Su Dongpo SuShi_Official", Post content "Just arrived in Huangzhou, demoted but feeling okay. Made Dongpo pork myself today, tastes amazing, recipe attached:", The attached image is a close-up of Dongpo pork in Gongbi painting style, Likes list "Huang Tingjian, Qin Guan, Fo Yin etc. 126 people", Comments section "Wang Anshi: Hehe" "Sima Guang: Still the same taste", Interface elements such as the like icon are replaced with Song Dynasty patterns, The status bar shows "Great Song Mobile 5G" and "Third Year of Yuanfeng", The color scheme is mobile phone dark mode paired with elegant Song Dynasty tones, A masterpiece of fun collision between history and social media', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 267, '@Panda20230902', 'https://x.com/Panda20230902/status/2045385588065313057', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-267', '/images/case267.jpg', '/, Ancient and Modern Time-travel Humor Fusion Interface', '["UI","Illustration","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-266', 'Amateur Photo of an Open Notebook Lying Flat,', 'Template imported from awesome-gpt-image-2 case 266. Source: @patrickassale.', 'Documents & Publishing', 'Amateur photo of an open notebook lying flat, filled with handwritten notes in black ballpoint pen. The handwriting is casual and slightly messy, like personnal notes, natural imperfections, crossed out words, underlined headings. Shot from slightly above, natural daylight from a window, no flash. Casual desk setting, shot on iPhone', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 266, '@patrickassale', 'https://x.com/patrickassale/status/2044569086013718958', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-266', '/images/case266.jpg', 'Amateur Photo of an Open Notebook Lying Flat,', '["Realistic"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-265', 'Generate Four Fictional Japanese Advertisement Images, Covering Different', 'Template imported from awesome-gpt-image-2 case 265. Source: @midori_tatsuta.', 'Products & E-commerce', 'Generate four fictional Japanese advertisement images, covering different types arranged side by side. Trendy design created by professional designers. Aspect ratio 1:1', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 265, '@midori_tatsuta', 'https://x.com/midori_tatsuta/status/2045253072289767815', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-265', '/images/case265.jpg', 'Generate Four Fictional Japanese Advertisement Images, Covering Different', '["Poster"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-264', 'Cute Y2k Style Affordable Cosmetics Advertising Image Designed', 'Template imported from awesome-gpt-image-2 case 264. Source: @midori_tatsuta.', 'Products & E-commerce', 'Cute Y2K style affordable cosmetics advertising image designed for Gen Z. Using vibrant color schemes, including neon colors. Aspect ratio is 3:4.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 264, '@midori_tatsuta', 'https://x.com/midori_tatsuta/status/2045378877363798279', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-264', '/images/case264.jpg', 'Cute Y2k Style Affordable Cosmetics Advertising Image Designed', '["Products"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-263', 'Please Fill in the Unfilled Parts by Your', 'Template imported from awesome-gpt-image-2 case 263. Source: @09lyco.', 'Characters & People', 'Please fill in the unfilled parts by your partner or yourself
 #ObservatoryTowerMorningTheme  #ObservatoryTowerGoodMorningTheme

Using the latest model image generation tool,
Using this chibi character illustration and standing picture, create a character introduction page style illustration like a real website page. (Something that would not be strange to use as an introduction page)
A high-quality item imagining a gal game character introduction page. Facial variations etc. are also included, CG illustrations exist. A chibi character exists.

"Self-introduction here"

Name: (Name here)
Image color: (Color here)
Height: (Height here)cm
Weight: (Weight here)kg
Catchphrase: "Dialogue here"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 263, '@09lyco', 'https://x.com/09lyco/status/2045281845391323175', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-263', '/images/case263.jpg', 'Please Fill in the Unfilled Parts by Your', '["Illustration","Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-262', 'Amateur Iphone Photo at Apple Park During the', 'Template imported from awesome-gpt-image-2 case 262. Source: @austinit.', 'Photography & Realism', 'Amateur iPhone photo at Apple Park during the iPhone 20 keynote, Tim Cook presenting on stage. Shot from the crowd at a distance', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 262, '@austinit', 'https://x.com/patrickassale/status/2044687244368441742', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-262', '/images/case262.jpg', 'Amateur Iphone Photo at Apple Park During the', '["Realistic"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-261', 'Render a Professional Ios App Homepage Ui Image,', 'Template imported from awesome-gpt-image-2 case 261. Source: @austinit.', 'UI & Interfaces', 'Render a professional iOS APP homepage UI image, the theme is AI Video Generator, English interface. Professional-level design, professional style, dark theme.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 261, '@austinit', 'https://x.com/austinit/status/2044968740782272596', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-261', '/images/case261.jpg', 'Render a Professional Ios App Homepage Ui Image,', '["UI","3D"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-260', 'Generate a Screenshot of Douyin Content, Theme: Catch', 'Template imported from awesome-gpt-image-2 case 260. Source: @MrLarus.', 'UI & Interfaces', 'Generate a screenshot of Douyin content, theme: Catch up with the AI wave, 9.9 to learn it all, iPhone size', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 260, '@MrLarus', 'https://x.com/MrLarus/status/2045373105041007013', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-260', '/images/case260.jpg', 'Generate a Screenshot of Douyin Content, Theme: Catch', '["UI"]'::jsonb, '["Tech","Social"]'::jsonb, FALSE, TRUE),
    ('case-259', 'Generate Xiaohongshu Content Screenshot, Theme: Behind Every Exquisite', 'Template imported from awesome-gpt-image-2 case 259. Source: @MrLarus.', 'UI & Interfaces', 'Generate Xiaohongshu content screenshot, theme: Behind every exquisite girl there is online loan, iPhone size', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 259, '@MrLarus', 'https://x.com/MrLarus/status/2045373105041007013', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-259', '/images/case259.jpg', 'Generate Xiaohongshu Content Screenshot, Theme: Behind Every Exquisite', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-258', 'Generate Kuaishou Content Screenshot: Theme: Live Divorce Announcement,', 'Template imported from awesome-gpt-image-2 case 258. Source: @MrLarus.', 'UI & Interfaces', 'Generate Kuaishou content screenshot: Theme: Live divorce announcement, iPhone size', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 258, '@MrLarus', 'https://x.com/MrLarus/status/2045373105041007013', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-258', '/images/case258.jpg', 'Generate Kuaishou Content Screenshot: Theme: Live Divorce Announcement,', '["UI"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-257', 'Generate a Screenshot of a Douyin Live Stream,', 'Template imported from awesome-gpt-image-2 case 257. Source: @joshesye.', 'UI & Interfaces', 'Generate a screenshot of a Douyin live stream, featuring a beautiful woman wearing traditional Chinese clothing selling goods during the live broadcast.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 257, '@joshesye', 'https://x.com/joshesye/status/2044796366950703316', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-257', '/images/case257.jpg', 'Generate a Screenshot of a Douyin Live Stream,', '["UI"]'::jsonb, '["Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-256', 'Generate a Screenshot of a Douyin Livestream, Inside', 'Template imported from awesome-gpt-image-2 case 256. Source: @joshesye.', 'UI & Interfaces', 'Generate a screenshot of a Douyin livestream, inside there is a beautiful woman livestreaming', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 256, '@joshesye', 'https://x.com/joshesye/status/2044796366950703316', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-256', '/images/case256.jpg', 'Generate a Screenshot of a Douyin Livestream, Inside', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-255', 'Mobile Vertical Screen Interface, Short Video Live Streaming', 'Template imported from awesome-gpt-image-2 case 255. Source: @joshesye.', 'UI & Interfaces', 'Mobile vertical screen interface, short video live streaming platform style, a young Asian female streamer selling goods through live streaming at home, the streamer is wearing tight yoga pants and a simple top, natural body curves, turning sideways to show the lines and elasticity of the pants, natural movements without exaggeration;', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 255, '@joshesye', 'https://x.com/joshesye/status/2044796366950703316', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-255', '/images/case255.jpg', 'Mobile Vertical Screen Interface, Short Video Live Streaming', '["UI"]'::jsonb, '["Travel"]'::jsonb, FALSE, TRUE),
    ('case-254', 'Design a Poster with the Theme of in', 'Template imported from awesome-gpt-image-2 case 254. Source: @akokoi1.', 'Posters & Typography', 'Design a poster with the theme of "running towards the mountains and seas" in a film photography style', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 254, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-254', '/images/case254.jpg', 'Design a Poster with the Theme of in', '["Poster","Realistic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-253', 'Generate a Poster for the Guyu Solar Term', 'Template imported from awesome-gpt-image-2 case 253. Source: @akokoi1.', 'Posters & Typography', 'Generate a poster for the Guyu solar term in 2026', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 253, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-253', '/images/case253.jpg', 'Generate a Poster for the Guyu Solar Term', '["Poster"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-252', 'Generate a Series of Hand-held Sign Designs for', 'Template imported from awesome-gpt-image-2 case 252. Source: @akokoi1.', 'Other Use Cases', 'Generate a series of hand-held sign designs for May Day Labor Day', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 252, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-252', '/images/case252.jpg', 'Generate a Series of Hand-held Sign Designs for', '["Other Use Cases"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-251', 'Generate a Single-day Calendar for the Garden of', 'Template imported from awesome-gpt-image-2 case 251. Source: @akokoi1.', 'Other Use Cases', 'Generate a single-day calendar for The Garden of Words on April 19, 2026', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 251, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-251', '/images/case251.jpg', 'Generate a Single-day Calendar for the Garden of', '["Other Use Cases"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-250', 'Design a Postcard Co-branded by the Little Prince', 'Template imported from awesome-gpt-image-2 case 250. Source: @akokoi1.', 'Other Use Cases', 'Design a postcard co-branded by The Little Prince and SpaceX', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 250, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-250', '/images/case250.jpg', 'Design a Postcard Co-branded by the Little Prince', '["Brand"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-249', 'Generate a Screenshot of a Tiktok Live Stream,', 'Template imported from awesome-gpt-image-2 case 249. Source: @joshesye.', 'UI & Interfaces', 'Generate a screenshot of a TikTok live stream, a beautiful woman is live streaming, the beautiful woman is holding a sign in her hand, on which it says: Thank you Brother Xingzhe for the big rocket!', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 249, '@joshesye', 'https://x.com/joshesye/status/2044796366950703316', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-249', '/images/case249.jpg', 'Generate a Screenshot of a Tiktok Live Stream,', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-248', 'Generate a Detailed Explanatory Diagram of Jingdezhen Blue', 'Template imported from awesome-gpt-image-2 case 248. Source: @joshesye.', 'Charts & Infographics', 'Generate a detailed explanatory diagram of Jingdezhen blue and white porcelain, accompanied by detailed Chinese knowledge analysis.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 248, '@joshesye', 'https://x.com/joshesye/status/2045764695827562686', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-248', '/images/case248.jpg', 'Generate a Detailed Explanatory Diagram of Jingdezhen Blue', '["Infographic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-247', 'Generate a Set of Iconfont for a Sports', 'Template imported from awesome-gpt-image-2 case 247. Source: @akokoi1.', 'Brand & Logos', 'Generate a set of iconfont for a sports app', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 247, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-247', '/images/case247.jpg', 'Generate a Set of Iconfont for a Sports', '["Brand"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-246', 'Design a Shanghai Postcard in Black Line Art', 'Template imported from awesome-gpt-image-2 case 246. Source: @akokoi1.', 'Illustration & Art', 'Design a Shanghai postcard in black line art style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 246, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-246', '/images/case246.jpg', 'Design a Shanghai Postcard in Black Line Art', '["Illustration"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-245', 'Design a Set of Seal Carving Stamps for', 'Template imported from awesome-gpt-image-2 case 245. Source: @akokoi1.', 'Other Use Cases', 'Design a set of seal carving stamps for "Elon Musk"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 245, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-245', '/images/case245.jpg', 'Design a Set of Seal Carving Stamps for', '["Other Use Cases"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-244', 'Design a Set of Promotional Materials for a', 'Template imported from awesome-gpt-image-2 case 244. Source: @akokoi1.', 'Brand & Logos', 'Design a set of promotional materials for a Durex and Chayan Yuese co-branding campaign.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 244, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-244', '/images/case244.jpg', 'Design a Set of Promotional Materials for a', '["Poster","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-243', 'Generate a Ui Design System for Me in', 'Template imported from awesome-gpt-image-2 case 243. Source: @stark_nico99.', 'UI & Interfaces', 'Generate a UI design system for me in xx style, including web pages, mobile, cards, controls, buttons, and others', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 243, '@stark_nico99', 'https://x.com/stark_nico99/status/2045836554451706125', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-243', '/images/case243.jpg', 'Generate a Ui Design System for Me in', '["UI"]'::jsonb, '["Social"]'::jsonb, FALSE, TRUE),
    ('case-242', 'Generate a Series of Design Drafts for Gongbi', 'Template imported from awesome-gpt-image-2 case 242. Source: @akokoi1.', 'Other Use Cases', 'Generate a series of design drafts for Gongbi painting bookmarks.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 242, '@akokoi1', 'https://x.com/akokoi1/status/2045693939584516441', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-242', '/images/case242.jpg', 'Generate a Series of Design Drafts for Gongbi', '["Illustration"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-241', 'Please Generate a Key Character Relationship Diagram for', 'Template imported from awesome-gpt-image-2 case 241. Source: @yihui_indie.', 'Other Use Cases', 'Please generate a key character relationship diagram for "XXX".', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 241, '@yihui_indie', 'https://x.com/yihui_indie/status/2045179926270361890', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-241', '/images/case241.jpg', 'Please Generate a Key Character Relationship Diagram for', '["Infographic","Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-240', '35mm Color Film Photography with Harsh Direct On-camera', 'Template imported from awesome-gpt-image-2 case 240. Source: @BubbleBrain.', 'Photography & Realism', '35mm color film photography with harsh direct on-camera flash, specular highlights on skin and clothing, strong catchlights in eyes, high contrast flash illumination, authentic film grain and color shift, high fashion fresh innocent basketball court editorial style, intimate first-person low-angle POV shot from below, early 20s sexy Chinese female idol with ultra-realistic delicate refined Chinese features, seductive almond-shaped fox eyes with natural double eyelids, high nose bridge, small sharp V-shaped jawline, flawless realistic porcelain skin with cool ivory undertone and visible flash specular highlights, fine delicate skin texture with subtle pores micro details and natural dewy glow under flash, fresh natural sporty makeup with soft dewy glow, subtle natural flush on cheeks, natural pink lips slightly parted, subtle natural freckles across nose and cheeks, long dark brown hair tied in a high playful ponytail with some loose strands framing the face and realistic loose strands, wearing a loose white tank top and white high-waisted basketball shorts, white knee-high sports socks, seductive natural leaning pose against the basketball hoop pole on the outdoor court at dusk, body angled sideways with naturally arched back and hips gently pushed back to accentuate perky round hips and sexy butt curve, one leg naturally extended forward toward the camera and the other leg slightly bent to emphasize long sexy legs, both hands lightly resting on the basketball pole at shoulder height, intensely seductive playful yet pitiable doe-eyed gaze straight at the viewer with soft vulnerable longing eyes and a gentle teasing smile full of quiet temptation and desire, harsh direct on-camera flash creating sharp specular highlights and strong catchlights, background with blurred basketball court and hoop under dusk sky, high contrast film color grading with natural flash look, extremely sharp yet soft skin rendering with authentic 35mm direct flash aesthetic, natural hair strands, realistic fabric texture on tank top and shorts with socks detail, no plastic skin, no digital over-sharpening, no airbrushing, no blemishes, no moles, no oily skin, no watermark, no text, authentic 35mm direct flash film basketball court look --ar 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 240, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2045052982728016131', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-240', '/images/case240.jpg', '35mm Color Film Photography with Harsh Direct On-camera', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-239', '9:16 Aspect Ratio, Generate a Screenshot of a', 'Template imported from awesome-gpt-image-2 case 239. Source: @alanblogsooo.', 'UI & Interfaces', '9:16 aspect ratio, generate a screenshot of a Douyin live stream, inside is Liu Yifei live streaming, Liu Yifei is holding a sign in her hand, the sign says Tonight''s live stream, welcome to join Yifei for a chat!', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 239, '@alanblogsooo', 'https://x.com/alanblogsooo/status/2044784762594918516', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-239', '/images/case239.jpg', '9:16 Aspect Ratio, Generate a Screenshot of a', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-238', 'A Surrealist Digital Illustration Style, Adopting a Low-angle', 'Template imported from awesome-gpt-image-2 case 238. Source: @liyue_ai.', 'Scenes & Storytelling', 'A surrealist digital illustration style, adopting a low-angle upward perspective. The picture depicts a giant colorful koi swimming in a dreamy nebula, surrounded by colorful nebulae and bubbles. In the center of the picture stands a small figure, with their back to the audience, calmly looking up at this huge koi in the air, and the koi is looking down at the small figure. The overall picture presents a strong size contrast, and the atmosphere is ethereal and dreamy. Aspect ratio 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 238, '@liyue_ai', 'https://x.com/liyue_ai/status/2045875219307655337', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-238', '/images/case238.jpg', 'A Surrealist Digital Illustration Style, Adopting a Low-angle', '["Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-237', 'Image Generation: Product Advertising Photo, Seasonal Product Suitable', 'Template imported from awesome-gpt-image-2 case 237. Source: @old_pgmrs_will.', 'Products & E-commerce', 'Image generation: Product advertising photo, Seasonal product suitable for summer, Carbonated beverage, Name="Summer Citrus SODA", Shape=500ml PET bottle, Design and generate image specifications after researching high CTA design as a beverage advertisement in 2025, Aspect ratio 3:4', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 237, '@old_pgmrs_will', 'https://x.com/old_pgmrs_will/status/2045852114673635507', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-237', '/images/case237.jpg', 'Image Generation: Product Advertising Photo, Seasonal Product Suitable', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-236', 'Guangdong Provincial City Football Super League Yuechao Invitation', 'Template imported from awesome-gpt-image-2 case 236. Source: @liyue_ai.', 'Posters & Typography', 'Guangdong Provincial City Football Super League (Yuechao) invitation poster design, aspect ratio 9:16;

S-shaped flowing composition, the picture extends from bottom to top, a dynamic energy flow formed by the trajectory of football movement runs through the picture, the center is a glowing football, with dynamic trajectory and energy light effects;

Along the S-shaped motion line, integrate Guangdong city landmarks and cultural elements: Canton Tower, Shenzhen Ping An Finance Centre, Zhuhai Fisher Girl statue, Lingnan architecture and Foshan martial arts silhouettes, Zhongshan Sun Yat-sen cultural symbols, Chaoshan Yingge dance dynamic character outlines, Qingyuan landscape natural scenery, all elements adopt the integrated expression of "line drawing + partial color blocks + blank space", progressive layers, combination of distance and virtual-real;

Add abstract football player silhouettes, weaken character details, strengthen momentum and competitive atmosphere, the visual focus remains on the football;

Style: modern Guochao high-end poster, minimalist style but rich in design sense, high-end, clean, unified, integrating oriental aesthetics and modern sports vision;

Color scheme: high saturation but restrained, Chinese red as the main visual, cyan-blue as auxiliary, gold embellished highlights, high contrast but not cluttered, with brand-level visual impact;

Top center horizontal visual main title "Guangdong Provincial City Football Super League": medium font, Song typeface, center vertical text layout: "Yuechao", large font, handwritten calligraphy art font, "Invitation": medium font, Song typeface, vertical arrangement, large spacing, bottom center first row horizontal: "April 25, 2026", small font, Song typeface, second row: "Guangzhou Yuexiushan Stadium", small font, Song typeface, reserve text layout space;

The overall layout is balanced, has a high-end brand poster texture, extremely detailed, the composition is simple and clean, no cluttered elements, cinematic light and shadow, 8K resolution, high-end design sense. Integrate elegant cloud patterns and water wave patterns derived from traditional Chinese auspicious clouds, floating light effect particles, full of dynamics and vitality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 236, '@liyue_ai', 'https://x.com/liyue_ai/status/2045772039521542202', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-236', '/images/case236.jpg', 'Guangdong Provincial City Football Super League Yuechao Invitation', '["Poster","Brand","Character"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-235', 'Generate a 3:4 Vertical 9-grid Poster Suitable for', 'Template imported from awesome-gpt-image-2 case 235. Source: @austinit.', 'Posters & Typography', 'Generate a 3:4 vertical 9-grid poster suitable for publishing on Xiaohongshu, with an overall layout of 3 columns × 3 rows. The boundaries of the nine grids are clear, making it easy to directly cut into 9 single images for later publishing. The overall style is clean, premium, and unified, suitable for female-oriented healthy lifestyle content, possessing the vibe of a viral Xiaohongshu cover. Image requirements: clear information layout, large text, strong readability, comfortable white space, gentle and healing color palette.

Overall visual style:
Cream white, light beige, light oat color, and light caramel color as the main color tones, paired with a small amount of dark brown text. Ins style, healing sense, sleep therapy theme, minimalist layout, light skeuomorphic illustration embellishments. Elements such as pillows, moons, stars, hot milk, aromatherapy, books, eye masks, curtains, and beds can be added. The overall look should be like a professional new media design graphic, with neat fonts, suitable for a knowledge-based popular science Xiaohongshu 9-grid.

Layout requirements:
The entire image must be a standard 9-grid composition, and each grid can stand alone as an independent image after being cut.
The content of each grid should be completely centered; do not place titles or body text near the dividing lines.
Keep obvious gaps or thin borders between each grid to ensure that reading is not affected after cropping.
All text must use Chinese, be clear and readable, no garbled characters, no English.
Each grid should look like an independent Xiaohongshu image-and-text card, but the visual style must remain unified.
The image should be exquisite, realistic, and natural, without a cheap marketing feel, and not overly flashy.

Specific content of the 9-grid:

Grid 1 (Cover)
Main title: 8 tips to make you fall asleep instantly
Subtitle: Insomniacs and night owls must save this
The cover visuals should be the most eye-catching, suitable for the first image. Add healing sleep elements such as soft beds, moons, pillows, and eye masks. The title should be prominent with a premium layout.

Grid 2
Title: 1. Don''t play with your phone 1 hour before bed
Body text: Blue light makes the brain more awake; the more you scroll, the harder it is to fall asleep.
Image elements: Mobile phone, moon, small illustration of a sleepy expression

Grid 3
Title: 2. Dim the lights before bed
Body text: A warm light environment can help the body enter a "ready to sleep" state.
Image elements: Bedside lamp, warm yellow light, curtains

Grid 4
Title: 3. Don''t keep the room temperature too high
Body text: Keeping it a bit cooler makes it easier to fall asleep quickly.
Image elements: Air conditioner, thermometer, quilt

Grid 5
Title: 4. Don''t drink strong tea or coffee at night
Body text: Caffeine delays sleepiness, making you lie in bed for a long time unable to sleep.
Image elements: Coffee cup, teacup, prohibition sign

Grid 6
Title: 5. Take a hot shower before bed
Body text: It can relax the body and help you fall asleep faster.
Image elements: Bathroom steam, towel, hot water

Grid 7
Title: 6. Write it down if your brain won''t stop
Body text: Writing down your worries and to-do lists makes it easier for your brain to relax.
Image elements: Notebook, fountain pen, small desk lamp

Grid 8
Title: 7. Fix your bedtime
Body text: Going to bed at about the same time every day will make your biological clock increasingly stable.
Image elements: Clock, moon, bed

Grid 9
Title: 8. Try deep breathing relaxation
Body text: Inhale for 4 seconds, hold for 4 seconds, exhale for 6 seconds, and sleepiness will gradually come.
Bottom small text: Save this set and try it tonight
Image elements: Breathing lines, person with closed eyes, stars

Image quality requirements:
High definition, premium layout, magazine feel, realistically publishable, new media operation aesthetics, Xiaohongshu viral image-and-text style, neat text layout, suitable for direct image cutting.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 235, '@austinit', 'https://x.com/austinit/status/2046037688969769346', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-235', '/images/case235.jpg', 'Generate a 3:4 Vertical 9-grid Poster Suitable for', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-234', 'Create an X Post Page of Zhu Yuanzhang', 'Template imported from awesome-gpt-image-2 case 234. Source: @liyue_ai.', 'History & Classical Themes', 'Create an X post page of Zhu Yuanzhang after his ascension to the throne in the Ming Dynasty', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 234, '@liyue_ai', 'https://x.com/liyue_ai/status/2045021302315249738', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-234', '/images/case234.jpg', 'Create an X Post Page of Zhu Yuanzhang', '["Classical"]'::jsonb, '["Social","History"]'::jsonb, FALSE, TRUE),
    ('case-233', 'Generate an Oil Painting of Mona Lisa Drinking', 'Template imported from awesome-gpt-image-2 case 233. Source: @liyue_ai.', 'Illustration & Art', 'Generate an oil painting of Mona Lisa drinking cola.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 233, '@liyue_ai', 'https://x.com/liyue_ai/status/2045058142858555733', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-233', '/images/case233.jpg', 'Generate an Oil Painting of Mona Lisa Drinking', '["Illustration"]'::jsonb, '["Tech","Food"]'::jsonb, FALSE, TRUE),
    ('case-232', 'Combining the Content from Wang Xizhi''s Lantingji Xulantingji', 'Template imported from awesome-gpt-image-2 case 232. Source: @liyue_ai.', 'Documents & Publishing', 'Combining the content from Wang Xizhi''s "Lantingji Xu", generate a calligraphy copy image, requiring the image background to match the artistic conception of "Lantingji Xu", the background image can use a mask, the foreground is "Lantingji Xu"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 232, '@liyue_ai', 'https://x.com/liyue_ai/status/2045137549149286858', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-232', '/images/case232.jpg', 'Combining the Content from Wang Xizhi''s Lantingji Xulantingji', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-231', 'Creative Artistic Typography Zong You Ji Feng Qi', 'Template imported from awesome-gpt-image-2 case 231. Source: OpenNana.', 'Illustration & Art', 'Creative artistic typography "Zong You Ji Feng Qi", hand-written style with a fine brush, overall text arranged horizontally, with strong visual impact;
Deeply integrated with the essence of handwritten calligraphy, the brushstrokes carry the rugged and free-spirited nature of brush writing, like the unrestrained vigor of splashing ink;
The flying white and pauses at the start and end of the strokes fully display the explosive tension of a promotion, the form of the text breaks away from neatness, with variations in the thickness of the strokes;
dutch angle, creating a dynamic sprinting momentum, the font shape shows a bold and unrestrained trend;
The center of gravity rises like being ready to launch, the stretching and interlacing of the strokes are completely unconstrained, like the vigor of a full-force sprint;
The overall structure is intertwined with density and sparseness, the tight parts are like the surging of a promotional craze, and the blank spaces are like the breathing sense during promotional gaps;
Pure black background as the base, perfectly fitting the passionate atmosphere, the form and color of the artistic typography are conveyed with full expressiveness.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 231, 'OpenNana', 'https://opennana.com/awesome-prompt-gallery/rising-wind-calligraphy-art', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-231', '/images/case231.jpg', 'Creative Artistic Typography Zong You Ji Feng Qi', '["Poster"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-230', 'Neo-chinese Minimalist Style High-end City Poster, 9:16 Vertical', 'Template imported from awesome-gpt-image-2 case 230. Source: @liyue_ai.', 'Posters & Typography', 'Neo-Chinese minimalist style high-end city poster, 9:16 vertical composition, with Guangzhou as the core theme, the center of the image is an abstract geometric Canton Tower, simple in shape but highly recognizable,

The overall adopts an S-shaped flowing composition, extending from bottom to top, the Pearl River water system is designed as flowing water ripples fused with traditional auspicious cloud patterns, surrounding the entire image to form a visual dynamic line,

Guangzhou landmark buildings are embellished in it in the way of "blank space + line drawing + local color blocks": Zhujiang New Town Twin Towers, Liede Bridge, Baiyun Mountain outline, Lingnan arcade houses,
Traditional and modern architecture naturally blend, progressive layers, clear distinction between far and near, virtual and real,

Style control: minimalist + high-end + Eastern artistic conception, not cluttered and not overly realistic,

Color scheme (key point):
High saturation but restrained, Chinese red, cyan blue, and gilded gold as the main colors,
Supplemented by a small amount of warm gold highlight embellishments, forming a strong visual impact but not tacky,

Background: large area of pure blank space or light Xuan paper texture, enhancing a sense of breathing and high-end feel,

Details: auspicious clouds and water ripples have a slight relief/gold stamping texture,
Locally add faint light particles or flowing light lines to enhance modernity,

Light and shadow: soft gradient light + local highlights, highlighting a magnificent and grand atmosphere,

Overall style: Guochao high-end illustration / brand poster-level texture / 8K / ultra-clear details', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 230, '@liyue_ai', 'https://x.com/liyue_ai/status/2045744531686166878', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-230', '/images/case230.jpg', 'Neo-chinese Minimalist Style High-end City Poster, 9:16 Vertical', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-229', 'Pure Black Deep Background, a Thick and Powerful', 'Template imported from awesome-gpt-image-2 case 229. Source: @liyue_ai.', 'Posters & Typography', '[
  Background and Skeleton Lines
] Pure black deep background,
a thick and powerful ink calligraphy S-shaped curve meanders from one end of the picture to the other,
with vigorous brushstrokes and well-proportioned ink shades,
like freehand brushwork,
forming the visual skeleton and narrative dynamic line of the entire picture. [
  Subject: Transparent Swallow
] Above the curve,
a flying thrush with spread wings occupies the visual core; the body has a glass transparent texture,
with overlapping shadows of traditional architectural complexes mapped inside,
blue-green light flows circulate and refract between the transparent wings,
as if the long river of time and civilized memories are condensed within it; the outline is bordered with extremely thin gold lines to enhance three-dimensionality and sacredness. [
  Midground: Classical Architecture Sequence
] Below the swallow,
various scenic spots in Guangzhou are scattered along the ink curve: Baiyun Mountain,
Chen Clan Ancestral Hall,
Twin Towers,
Canton Tower,
Liede Bridge,
Haizhu Tower appear in sequence; the main tone is cyan-green and pale gold,
architectural details are clear,
glazed tiles,
flying eaves,
stone steps and corridors; kapok flowers cluster and decorate around the buildings,
petals scatter lightly with the wind,
quiet and distant; a few ink clouds float lightly among them,
adding ethereal layers. [
  Foreground: White Cranes and Water Surface
] Lakeside in the foreground: several white cranes either stand quietly by the water or flap their wings to soar,
with different postures,
elegant and calm; the light blue lake surface is like a mirror,
reflections rippling,
shimmering light,
creating a tranquil atmosphere. [
  Distance: Mountains
] Distant mountains rise and fall in layers,
smudged in cyan-black,
ink shades from thick to light,
hazy and misty,
rich in ink wash layers; forming a spatial depth with solid foreground and empty distance with the foreground. [
  Composition and Light and Shadow
] Non-linear perspective composition,
the ink curve is the main narrative axis,
ancient and modern elements are embedded along the line; the light source radiates and diffuses outward from the center of the picture,
forming a strong contrast between light and dark,
bright in the center and gradually darkening around; cool tones dominate (dark blue,
cyan-green,
silver white),
warm tones embellish (cherry blossom pink,
pale gold),
harmonious and mysterious; Eastern aesthetics blend with modern imagery,
surreal poetic mood. [
  Technical Specifications
] 8K ultra-high definition rendering,
extreme detail precision,
best image quality,
ratio 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 229, '@liyue_ai', 'https://x.com/liyue_ai/status/2045873940883808523', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-229', '/images/case229.jpg', 'Pure Black Deep Background, a Thick and Powerful', '["UI","Classical","3D"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-228', 'Generate an Advertising Image That Perfectly Matches This', 'Template imported from awesome-gpt-image-2 case 228. Source: @Kashiko_AIart.', 'Posters & Typography', 'Generate an advertising image that perfectly matches this image. There should be a lot of information.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 228, '@Kashiko_AIart', 'https://x.com/Kashiko_AIart/status/2045787856292151322', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-228', '/images/case228.jpg', 'Generate an Advertising Image That Perfectly Matches This', '["Poster"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-227', 'A 9:16 Image, Generate a Screenshot of a', 'Template imported from awesome-gpt-image-2 case 227. Source: @austinit.', 'UI & Interfaces', 'A 9:16 image, generate a screenshot of a Bilibili live stream, inside is Hu Chenfeng broadcasting live, Hu Chenfeng has a happy expression, holding a sign in his hand, the sign says "Boss Austin is so emotional, everyone please give Boss Austin some follows."', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 227, '@austinit', 'https://x.com/austinit/status/2044994519649997183', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-227', '/images/case227.jpg', 'A 9:16 Image, Generate a Screenshot of a', '["UI"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-226', 'Based on the Style of the Uploaded Image,', 'Template imported from awesome-gpt-image-2 case 226. Source: @liyue_ai.', 'History & Classical Themes', 'Based on the style of the uploaded image, generate portraits of the emperors of the Ming Dynasty, with their posthumous titles and names below the portraits', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 226, '@liyue_ai', 'https://x.com/liyue_ai/status/2045071977279635962', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-226', '/images/case226.jpg', 'Based on the Style of the Uploaded Image,', '["Classical"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-225', 'Help Me Generate Xxxx Authentic Picture', 'Template imported from awesome-gpt-image-2 case 225. Source: @MrLarus.', 'Documents & Publishing', 'Help me generate xxxx authentic picture', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 225, '@MrLarus', 'https://x.com/MrLarus/status/2046201836525302032', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-225', '/images/case225.jpg', 'Help Me Generate Xxxx Authentic Picture', '["Documents"]'::jsonb, '["Social"]'::jsonb, FALSE, TRUE),
    ('case-224', 'A Mecha Girl Mid-teens, Pale Skin Smudged with', 'Template imported from awesome-gpt-image-2 case 224. Source: @old_pgmrs_will.', 'Scenes & Storytelling', 'A mecha girl mid-teens, pale skin smudged with soot and salt spray, sharp amber eyes with glowing HUD reticles, waist-length ash-white hair tied in a high ponytail whipping in the sea wind, matte gunmetal exoskeleton armor plating her shoulders, forearms and shins, exposed hydraulic pistons at the joints, chest rig with glowing cyan coolant lines, oversized oil-stained hangar jacket half slipping off one shoulder, a massive rail cannon resting on her right shoulder, dog tags and frayed red ribbon at her collar , standing off-center to the left on the rusted edge of a tilted steel platform jutting out over dark water, weight shifted onto one leg, left hand gripping the cannon strap, head turned slightly toward camera with a quiet defiant stare, steam venting from her back thrusters, her ponytail and jacket streaming sideways in the salt wind , a vast derelict sea-city at dusk, colossal megastructures of unknown purpose rising from the ocean in staggered silhouettes, bone-white monolithic towers fused with barnacled steel, cyclopean ring-shaped constructs canted at broken angles, rusted skeletal gantries threaded with dead cables, dark swells rolling between the pylons, shipwrecks half-swallowed at their feet, thick sea fog clinging to the bases while the upper structures pierce into a bruised sky, scattered faint lights blinking high in the towers like distant eyes , moody low-key lighting, cold teal ambient from the overcast sky, warm amber sodium glow leaking from a distant structure camera-right, hard backlight from a low sun behind the towers carving her silhouette, volumetric god rays cutting through sea mist, wet specular highlights on her armor , 35mm anamorphic lens, slight low angle looking up past her shoulder toward the structures, medium-wide shot, shallow depth of field with foreground rust in soft focus, horizontal lens flares, fine atmospheric haze compressing the distant megastructures into layered silhouettes , cinematic anime key visual, painterly digital illustration with crisp line art, desaturated oceanic palette of teal, bone-white and rust punched by small warm accent lights, film grain, high-contrast editorial poster aesthetic . Format 16:9.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 224, '@old_pgmrs_will', 'https://x.com/old_pgmrs_will/status/2046144801071079612', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-224', '/images/case224.jpg', 'A Mecha Girl Mid-teens, Pale Skin Smudged with', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-223', 'Neo-chinese Ink Wash Landscape Poster, Vertical 9:16 Composition,', 'Template imported from awesome-gpt-image-2 case 223. Source: @liyue_ai.', 'Posters & Typography', 'Neo-Chinese ink wash landscape poster, vertical 9:16 composition, Oriental minimalist aesthetic style,
Large area of negative space, overall color tone is spring morning atmosphere (cyan-green, misty blue, light gray, light ink), low saturation, clear and soft, high-end texture.
The main subject of the picture is steep and majestic mountains, rising from both sides of the calm lake in the middle, occupying the left and right sides of the picture,
The mountain bodies are expressed with ink wash blending, rich in changes of shades, dryness and wetness, partially integrated with light cyan-green rendering, reflecting the vitality of spring.
The mountain peaks are wrapped in moist and gentle morning mist, the mist progresses layer by layer, naturally blending with the light cyan-blue sky, forming aerial perspective and spatial depth.
The lake surface is as calm as a mirror, showing a slightly cyan-green tone, reflecting the mountains and the sky, the reflection slightly has a soft focus and atomization diffusion effect, enhancing the spring moist and dreamy atmosphere.
In the midground, a small wooden boat with an arched canopy floats slowly, the oars lightly touch the water surface to form delicate ripples, the water patterns spread naturally, maintaining an extremely quiet state overall.
On the boat is a fisherwoman in red, with a small volume (distant view proportion), the character is simplified into an ink wash silhouette + slight coloring,
wearing a low-saturation cinnabar red traditional costume (not bright red), the color is slightly softened by the mist,
no facial details are depicted for the character, only retaining the outline and posture (such as gently holding the boat canopy or holding the oar),
the red color forms a faint reflection on the water surface, serving as the only warm color visual focus in the picture.
The shore is dotted with sparse woods and spring newborn vegetation, using light ink + light cyan-green dot dyeing, combining virtuality and reality, enhancing rhythm and breath of life.
A small number of flying birds skim across the distant sky, distributed lightly and loosely, enhancing the spatial layers and sense of agility.
At the top center of the picture, vertical calligraphy: "Oriental Aesthetics", adopting traditional handwritten running script or running-cursive style (intention of Wang Xizhi''s brushwork),
brushstrokes naturally undulate, lifting and pressing are distinct, with flying white and ink rhyme diffusion effects, avoiding a sense of font.
The calligraphy color is dark ink cyan or soft ink black, unified with the overall picture.
Overall style: ink wash + modern minimalist design fusion, spring Zen, ethereal and moist, tranquil atmosphere,
restrained cold and warm contrast, cinematic light and shadow, high-end art poster texture, 8K ultra-clear details.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 223, '@liyue_ai', 'https://x.com/liyue_ai/status/2046215276249993720', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-223', '/images/case223.jpg', 'Neo-chinese Ink Wash Landscape Poster, Vertical 9:16 Composition,', '["UI","Poster","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-222', 'Please Generate a High-quality Vertical Based on the', 'Template imported from awesome-gpt-image-2 case 222. Source: @MrLarus.', 'Charts & Infographics', 'Please generate a high-quality vertical "Popular Science Encyclopedia Infographic" based on the [Topic].

This image is not an ordinary poster, nor a simple illustration, but a modular popular science infographic with a sense of "illustrated guide, encyclopedia, information structure, and collectibility". The overall style references a combination of high-end natural history illustrated guides, modern encyclopedia pages, lifestyle knowledge cards, and highly shared social media infographics.

Please make the image contain:
- A clear and beautiful theme main visual
- Several enlarged details of local features
- Multiple rounded modular information sections
- Clear title hierarchy and key tags
- Concise but rich encyclopedia content
- Visualized scoring, key point summaries, or Top 5 modules

Content columns should automatically adapt to the topic, prioritizing selection and reasonable combination from these directions:
Basic profile, classification information, appearance features, habits/ecology, formation mechanism/structural composition, growth or usage conditions, care or maintenance suggestions, risks and precautions, suitable groups or applicable scenarios, pros and cons comparison, quick scorecard.

Visual requirements:
Light-colored clean background, soft color palette, light shadows, exquisite small icons, rounded information boxes, neat typography, high information density but not crowded, good reading experience. The overall look must be like a real popular science encyclopedia card that can be published, read, collected, and serialized, rather than an advertisement.

Please do not make it into an ordinary commercial promotional poster. It must highlight the characteristics of "knowledge organization + modular information + illustrated guide style display".', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 222, '@MrLarus', 'https://x.com/MrLarus/status/2046231542817497392', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-222', '/images/case222.jpg', 'Please Generate a High-quality Vertical Based on the', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-221', 'Analog 35mm Film Photography, Soft Airy Japanese-style Aesthetic,', 'Template imported from awesome-gpt-image-2 case 221. Source: @BubbleBrain.', 'Photography & Realism', 'Analog 35mm film photography, soft airy Japanese-style aesthetic, gentle diffused natural window light, slight overexposure, pastel tones, low contrast, soft highlights,  minimal indoor setting near a window with white curtains, clean light-colored wall, natural composition, eye-level, slightly closer full-body framing (mid-thigh to head),  young East Asian woman, natural minimal makeup, soft realistic skin texture, long slightly messy dark hair,  oversized white button-up shirt, light casual shorts, barefoot, simple and relaxed styling,  standing naturally with relaxed posture, arms loosely at sides or slightly behind, facing camera, gentle soft smile, subtle stillness,  focus on light, air, and quiet everyday mood, soft film grain, dreamy and understated atmosphere --ar 9:16', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 221, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2046115431144902732', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-221', '/images/case221.jpg', 'Analog 35mm Film Photography, Soft Airy Japanese-style Aesthetic,', '["UI","Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-220', 'Flat Illustration, Oriental Fantasy Style High-end City Poster', 'Template imported from awesome-gpt-image-2 case 220. Source: @liyue_ai.', 'Posters & Typography', 'Flat illustration, Oriental fantasy style high-end city poster design, vertical 9:16 composition, the overall adopts a diagonal + S-shaped flowing composition, extending from the bottom left to the top right, the picture uses deep black as the background, gradually changing from top to bottom to intense dark red, forming a strong cold-warm contrast and spatial depth, the background has a faint stardust and grainy texture. In the center of the picture, a golden flowing energy line winds through like a flame, extending from the bottom to the top, having a fluid texture, particle light effects and gradient highlights, with subtle energy debris and volumetric light in some areas. Guangzhou city landmark building complexes emerge layer by layer in the golden flowing light: Canton Tower is the visual core, with a prominent proportion, surrounded by the integration of Zhujiang New Town high-rise buildings, Liede Bridge and modern and Lingnan architectural elements, the buildings are expressed using "fine line drawing + golden glowing blocks", clear outlines and rich details, set off by the golden halo, they seem to float in the void, forming a surreal spatial hierarchy, the distant view is slightly fogged to enhance the sense of depth. At the bottom of the picture is an oriental white-haired female figure, long hair fluttering, like smoke and mist, naturally connecting and gradually blending with the golden flowing light, the hair is translucent with a gradient light sense, graceful posture, eyes slightly closed, serene expression, holding a bunch of colorful fresh flowers in her arms, interspersed with faint light particles and starlight effects among the flowers, symbolizing the spiritual connection between human and urban energy, character details are moderately simplified to highlight the overall sense of design. Light and shadow are focused on the golden streamlines, buildings and character outlines, forming a strong light-dark contrast and visual focus, the overall atmosphere is grand, mysterious, with an Oriental mythological artistic conception and a slight healing sense. The color uses black and dark red as the base, highlighted gilded gold as the main visual emphasis, the gold has rich light and dark layers, supplemented by small areas of high-saturation bouquet color embellishments, the overall is advanced and restrained. Page text and picture integrated typography: large Song typeface characters "Guangzhou·China" centered at the top, small characters "2026/04/20" below, small characters "LIYUE" further below, the text uses light gold or soft warm white, unifying with the overall light and shadow. High-quality details, cinematic light and shadow performance, rich volumetric light and particle details, clean picture without noise, ultra-high definition 8K resolution, commercial-grade poster texture.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 220, '@liyue_ai', 'https://x.com/liyue_ai/status/2046243132774494607', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-220', '/images/case220.jpg', 'Flat Illustration, Oriental Fantasy Style High-end City Poster', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-219', '9:16 Vertical - a 3x3 Grid Collage Nine', 'Template imported from awesome-gpt-image-2 case 219. Source: @BubbleBrain.', 'Photography & Realism', '9:16 vertical - a 3x3 grid collage (nine images) forming a Korean idol portrait photoshoot series. Each frame features the same young Korean female idol, maintaining 100% consistency in facial features, proportions, hairstyle, and identity across all nine shots.   Natural, ultra-realistic skin texture, no retouching, no smoothing. Clean idol-style minimal makeup, soft glow, subtle imperfections.   Hair: long, voluminous dark hair, slightly tousled, consistent across all frames (natural loose flow, slight movement).  Outfit: cohesive Korean idol photoshoot styling - white shirt + short bottoms (or simple neutral-toned outfit), youthful, clean, slightly casual but styled. Same outfit across all frames.  Setting: minimal studio or simple indoor environment (plain wall, soft window light, clean background). Focus on subject, not environment.  Lighting: soft diffused natural light, gentle highlights, low contrast, slightly airy tones, subtle film-like softness.  Camera style: intimate portrait photography, slightly handheld feel, subtle imperfections (minor grain, slight blur in motion frames, imperfect framing).  Frame breakdown (3x3 grid):  Top row: - Top left: standing naturally, looking slightly away, relaxed expression - Top center: facing camera, casual mid-motion (hair or body slight movement) - Top right: slight side angle, soft gaze, natural candid feel  Middle row: - Center left: looking slightly upward, soft thoughtful expression - Center: close-up portrait, direct eye contact, gentle idol smile - Center right: turning body slightly, mid-motion candid frame  Bottom row: - Bottom left: seated or leaning casually, relaxed posture - Bottom center: back partially turned, looking over shoulder toward camera - Bottom right: standing close to frame, slightly playful or soft expression  Mood: Korean idol photobook / photocard aesthetic, intimate, soft, natural, everyday charm.  Quality: ultra-realistic, 8K detail, subtle analog film grain, natural imperfections, soft dreamy tone', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 219, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2046151898621993364', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-219', '/images/case219.jpg', '9:16 Vertical - a 3x3 Grid Collage Nine', '["Realistic","Brand"]'::jsonb, '["Tech","Fashion","Story"]'::jsonb, FALSE, TRUE),
    ('case-218', 'Role: World-class Scientific Encyclopedia Illustrator Knowledge Graph Architect', 'Template imported from awesome-gpt-image-2 case 218. Source: @GeekCatX.', 'Charts & Infographics', 'Role: World-class Scientific Encyclopedia Illustrator & Knowledge Graph Architect.

Task: Generate a highly detailed, extremely intricate, and visually stunning "Universal Illustrated Encyclopedia Science Infographic" in a classic, unbranded (NO logos) scientific encyclopedia style.

Subject Matter: Choose one from [People, Plants, or Animals].

Specific Subject: [e.g., The Giant Squid / Leonardo da Vinci / The Sequoia Tree].

Style: Fine, detailed scientific illustration on a retro, aged beige paper background. Delicate linework. Intricately complex and professional.

Key Visual Requirements:

1.  Lifelike 3D Effect (The Central Subject): The central subject in the "C position" must be rendered with extraordinary realism and dynamism. Create a dramatic sense of depth where the character, plant, or animal appears to break the frame, leaping or bursting out of the flat paper towards the viewer (an effect similar to anamorphic 3D or dynamic pop-out, with high-precision realism).

2.  Layout & Strategic White Space:
    * Central Subject: Dominates the center, with intentional "strategic white space" around it to enhance the popping-out effect and make the figure the clear focal point.
    * Surrounding Modules: The surrounding area (left, right, top, bottom, and corners) must be filled with 6-8 distinct, highly organized knowledge modules, depending on the subject. There should be a sense of organized density, not random clutter. The modules themselves must have clear borders, headers, and extensive, detailed content.

3.  Connections: Use a complex, logical network of fine leader lines, arrows, brackets, dotted lines, and small connection points to link the central figure to all surrounding modules, and interconnect the modules themselves into a cohesive knowledge web.

4.  Text & Annotation (Hard Requirement - Must be CLEAR Chinese):
    * Main Title: A large, prominent, beautifully executed **Chinese calligraphy** (书法体) of the specific subject''s name [e.g., "大王乌贼"].
    * Calligraphic Accents: Scattered throughout the main content and module titles, use beautiful, clear Chinese calligraphy for important terms.
    * Standard Chinese Text: All other descriptive text, handwritten notes (大量清晰中文手写注释), module content, and annotations must be clear, legible Chinese characters (简体中文), not gibberish or unreadable symbols. Ensure text clarity is prioritized.
    * Leader Line Annotations: Every single small component, detail, submodule, diagram, or illustration within the modules must have detailed leader line annotations (拟解剖图) pointing directly to it for maximum professionalism and educational value. Every part should be labeled.

Subject-Specific Module Structure (Example for general reference):

A. For Humans [People]:
   - Module 1: Anatomy & Skeletal Structure (w/ magnified cross-sections)
   - Module 2: Physiological Processes (e.g., Circulatory/Nervous System)
   - Module 3: Historical Context & Timeline (Key Achievements)
   - Module 4: Major Contribution Diagram (Detailed breakdown)
   - Module 5: Cognitive Process / Psychological Insight
   - Module 6: Genetic Profile / Evolution
   - Module 7: Global Influence & Cultural Impact
   - Module 8: Cultural Representations / Legacy

B. For Animals:
   - Module 1: Full External Sketch & Anatomy (w/ microscope magnified detail circular windows)
   - Module 2: Behavioral Patterns & Lifecycle (e.g., Mating/Migration, Flowchart style)
   - Module 3: Digestive & Skeletal System
   - Module 4: Habitats & Distribution Map (with environmental details)
   - Module 5: Unique Adaptations (e.g., camouflage, hunting tools)
   - Module 6: Evolutionary History & Relatives
   - Module 7: Symbiotic Relationships / Ecosystem Role
   - Module 8: Conservation Status & Human Interaction

C. For Plants:
   - Module 1: Full Plant Sketch & Anatomy (w/ magnified leaf/root details)
   - Module 2: Photosynthesis & Lifecycle Flow (w/ icons for environment)
   - Module 3: Cellular Structure (Magnified circular views)
   - Module 4: Medicinal Properties / Practical Applications (as in original original prompt)
   - Module 5: Environmental Adaptations / Unique Features
   - Module 6: Distribution Map & Environmental Context
   - Module 7: Genetic Variations & Cultivation
   - Module 8: Historical Usage & Folklore

Overall Composition: Extremely dense with information, organized into 6-8 structured modules, but balanced with strategic empty space around the center to allow the main, hyper-realistic figure to pop. Hard-core, professional, academic, but visually engaging due to the dynamic 3D central figure. No branding from any specific encyclopedia (e.g., no "DK" logos). All annotations must be legible. All handwritten notes must be clear. Main titles in Chinese calligraphy. Aspect Ratio: 3:4.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 218, '@GeekCatX', 'https://x.com/GeekCatX', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-218', '/images/case218.jpg', 'Role: World-class Scientific Encyclopedia Illustrator Knowledge Graph Architect', '["UI","Infographic","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-217', 'Case 217 Photography and Realism Template', 'Template imported from awesome-gpt-image-2 case 217. Source: @BubbleBrain.', 'Photography & Realism', '{
  "prompt": {
    "style_and_tech": "mobile phone photo, old CCD camera aesthetic, harsh flash, grainy, dim messy indoor lighting, candid snapshot feeling, slight motion blur",
    "subject": "young Korean female idol, soft innocent look",
    "pose": "mid-action, slightly turning head toward camera as if just noticed being photographed, shoulders slightly raised",
    "expression": "eyes widened slightly, lips parted in surprise, shy and caught-off-guard expression",
    "clothing": "loose soft homewear (thin cardigan + inner top), slightly slipping off one shoulder but not revealing",
    "vibe": "unprepared, intimate, accidental moment, evokes curiosity and protectiveness"，
    "aspect ratio":"9:16"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 217, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2046190539213885806', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-217', '/images/case217.jpg', 'Case 217 Photography and Realism Template', '["Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-216', 'Use the Patterns in the Attached Image, Crafted', 'Template imported from awesome-gpt-image-2 case 216. Source: @aiehon_aya.', 'Brand & Logos', 'Use the patterns in the attached image, crafted by professional designers to create 4 fashion items, using different color schemes and layout designs, accompanied by outfit effect pictures. Highlight the beauty of the patterns with an elegant composition. The format is 2:3, hoping to specify the image generation model from duct-tape-1 to duct-tape-2, 3.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 216, '@aiehon_aya', 'https://x.com/aiehon_aya/status/2046348182301683954', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-216', '/images/case216.png', 'Use the Patterns in the Attached Image, Crafted', '["Brand"]'::jsonb, '["Fashion"]'::jsonb, FALSE, TRUE),
    ('case-215', 'Create an Ultra-high-detail Isometric Pixel Art Timeline Illustration', 'Template imported from awesome-gpt-image-2 case 215. Source: @GeekCatX.', 'Other Use Cases', 'Create an ultra-high-detail isometric pixel art timeline illustration (3:4, 4K), integrating detail density, symbolism, and metaphor. The user-specified theme is [Western Art Development]. First, reason around Western Art Development to determine: the Chinese and English titles of the theme, the earliest and most recent historical periods covered, the starting stage label and the ending stage label, as well as 3-5 key evolution stages and their respective symbolic elements and color schemes. Then build an isometric "Evolution Museum" themed "Western Art Development", where each exhibition hall area represents an evolution stage, and spatial progression represents time evolution. Adopt a standard isometric perspective (2:1), rich layer depth, and smooth transitions. Allocate 3-5 symbolic elements strongly associated with the theme to each stage, and use differentiated colors to imply the flow of time. Integrate bilingual pixel font titles in the scene: Chinese "[Theme Chinese] Evolution History" and English "EVOLUTION OF Western Art Development", plus bilingual subtitles for the starting and ending stages and key time node markers. The overall style is professional and visually tense, suitable for academic analysis and comparative visualization, direct image output.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 215, '@GeekCatX', 'https://x.com/GeekCatX/status/2046172416716759171', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-215', '/images/case215.jpg', 'Create an Ultra-high-detail Isometric Pixel Art Timeline Illustration', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-214', 'Role: World-class Scientific Encyclopedia Illustrator Knowledge Graph Architect', 'Template imported from awesome-gpt-image-2 case 214. Source: @xiaoxiaodong01.', 'Charts & Infographics', 'Role: World-class Scientific Encyclopedia Illustrator & Knowledge Graph Architect.

Task: Generate a highly detailed, extremely intricate, and visually stunning "Universal Illustrated Encyclopedia Science Infographic" in a classic, unbranded (NO logos) scientific encyclopedia style.

Subject Matter: Choose one from [People, Plants, or Animals].

Specific Subject: [e.g., The Giant Squid / Leonardo da Vinci / The Sequoia Tree].

Style: Fine, detailed scientific illustration on a retro, aged beige paper background. Delicate linework. Intricately complex and professional.

Key Visual Requirements:

1.  Lifelike 3D Effect (The Central Subject): The central subject in the "C position" must be rendered with extraordinary realism and dynamism. Create a dramatic sense of depth where the character, plant, or animal appears to break the frame, leaping or bursting out of the flat paper towards the viewer (an effect similar to anamorphic 3D or dynamic pop-out, with high-precision realism).

2.  Layout & Strategic White Space:
    * Central Subject: Dominates the center, with intentional "strategic white space" around it to enhance the popping-out effect and make the figure the clear focal point.
    * Surrounding Modules: The surrounding area (left, right, top, bottom, and corners) must be filled with 6-8 distinct, highly organized knowledge modules, depending on the subject. There should be a sense of organized density, not random clutter. The modules themselves must have clear borders, headers, and extensive, detailed content.

3.  Connections: Use a complex, logical network of fine leader lines, arrows, brackets, dotted lines, and small connection points to link the central figure to all surrounding modules, and interconnect the modules themselves into a cohesive knowledge web.

4.  Text & Annotation (Hard Requirement - Must be CLEAR Chinese):
    * Main Title: A large, prominent, beautifully executed **Chinese calligraphy** (书法体) of the specific subject''s name [e.g., "大王乌贼"].
    * Calligraphic Accents: Scattered throughout the main content and module titles, use beautiful, clear Chinese calligraphy for important terms.
    * Standard Chinese Text: All other descriptive text, handwritten notes (大量清晰中文手写注释), module content, and annotations must be clear, legible Chinese characters (简体中文), not gibberish or unreadable symbols. Ensure text clarity is prioritized.
    * Leader Line Annotations: Every single small component, detail, submodule, diagram, or illustration within the modules must have detailed leader line annotations (拟解剖图) pointing directly to it for maximum professionalism and educational value. Every part should be labeled.

Subject-Specific Module Structure (Example for general reference):

A. For Humans [People]:
   - Module 1: Anatomy & Skeletal Structure (w/ magnified cross-sections)
   - Module 2: Physiological Processes (e.g., Circulatory/Nervous System)
   - Module 3: Historical Context & Timeline (Key Achievements)
   - Module 4: Major Contribution Diagram (Detailed breakdown)
   - Module 5: Cognitive Process / Psychological Insight
   - Module 6: Genetic Profile / Evolution
   - Module 7: Global Influence & Cultural Impact
   - Module 8: Cultural Representations / Legacy

B. For Animals:
   - Module 1: Full External Sketch & Anatomy (w/ microscope magnified detail circular windows)
   - Module 2: Behavioral Patterns & Lifecycle (e.g., Mating/Migration, Flowchart style)
   - Module 3: Digestive & Skeletal System
   - Module 4: Habitats & Distribution Map (with environmental details)
   - Module 5: Unique Adaptations (e.g., camouflage, hunting tools)
   - Module 6: Evolutionary History & Relatives
   - Module 7: Symbiotic Relationships / Ecosystem Role
   - Module 8: Conservation Status & Human Interaction

C. For Plants:
   - Module 1: Full Plant Sketch & Anatomy (w/ magnified leaf/root details)
   - Module 2: Photosynthesis & Lifecycle Flow (w/ icons for environment)
   - Module 3: Cellular Structure (Magnified circular views)
   - Module 4: Medicinal Properties / Practical Applications (as in original original prompt)
   - Module 5: Environmental Adaptations / Unique Features
   - Module 6: Distribution Map & Environmental Context
   - Module 7: Genetic Variations & Cultivation
   - Module 8: Historical Usage & Folklore

Overall Composition: Extremely dense with information, organized into 6-8 structured modules, but balanced with strategic empty space around the center to allow the main, hyper-realistic figure to pop. Hard-core, professional, academic, but visually engaging due to the dynamic 3D central figure. No branding from any specific encyclopedia (e.g., no "DK" logos). All annotations must be legible. All handwritten notes must be clear. Main titles in Chinese calligraphy. Aspect Ratio: 3:4.

主题内容：潘金莲', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 214, '@xiaoxiaodong01', 'https://x.com/xiaoxiaodong01/status/2046252164717416641', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-214', '/images/case214.jpg', 'Role: World-class Scientific Encyclopedia Illustrator Knowledge Graph Architect', '["UI","Infographic","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-213', 'Help Me Generate a Screenshot of an Ancient', 'Template imported from awesome-gpt-image-2 case 213. Source: @op7418.', 'UI & Interfaces', 'Help me generate a screenshot of an ancient ARPG MMO open-world game themed around Jin Ping Mei.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 213, '@op7418', 'https://x.com/op7418/status/2046520509651886451', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-213', '/images/case213.jpg', 'Help Me Generate a Screenshot of an Ancient', '["UI","Classical"]'::jsonb, '["Story","History"]'::jsonb, FALSE, TRUE),
    ('case-212', 'Please Use This Character to Create a Photo', 'Template imported from awesome-gpt-image-2 case 212. Source: @Kashiko_AIart.', 'Characters & People', 'Please use this character to create a photo book crafted by a professional designer. The language should be Japanese.

Adding prompts according to your preferences will make it more colorful and rich
・Rich scenes
・Large amount of information', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 212, '@Kashiko_AIart', 'https://x.com/Kashiko_AIart/status/2046492817804099794', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-212', '/images/case212.jpg', 'Please Use This Character to Create a Photo', '["Realistic","Character"]'::jsonb, '["Commerce","Fashion","Story"]'::jsonb, FALSE, TRUE),
    ('case-211', 'Generate an Architectural Exploded View of the Temple', 'Template imported from awesome-gpt-image-2 case 211. Source: @TanShilong.', 'Architecture & Spaces', 'Generate an architectural exploded view of the Temple of Heaven, with detailed annotations, Chinese aesthetic style', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 211, '@TanShilong', 'https://x.com/TanShilong/status/2046524996013662380', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-211', '/images/case211.jpg', 'Generate an Architectural Exploded View of the Temple', '["Architecture"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-210', 'Cute Explanation of the Large Language Model Training', 'Template imported from awesome-gpt-image-2 case 210. Source: @op7418.', 'Charts & Infographics', 'Cute explanation of the large language model training process', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 210, '@op7418', 'https://x.com/op7418/status/2046502136973001143', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-210', '/images/case210.jpg', 'Cute Explanation of the Large Language Model Training', '["Infographic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-209', 'Imitating the Style of Valorant, Generate a Three', 'Template imported from awesome-gpt-image-2 case 209. Source: @op7418.', 'UI & Interfaces', 'Imitating the style of Valorant, generate a Three Kingdoms mythological FPS game', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 209, '@op7418', 'https://x.com/op7418/status/2046519666047426967', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-209', '/images/case209.jpg', 'Imitating the Style of Valorant, Generate a Three', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-208', 'Generate a High-quality Anime Beautiful Girl Image', 'Template imported from awesome-gpt-image-2 case 208. Source: @joshesye.', 'Scenes & Storytelling', 'Generate a high-quality anime beautiful girl image.

 Character setting:

- Age: 17 years old
- Hairstyle: twin tails, color: cherry blossom pink, hair tips with a bit of gradient purple
 - Eyes: large and bright, purple pupils, with star highlights
 - Clothing: JK uniform, white shirt, dark blue plaid skirt, red bow tie
 - Accessories: white over-the-knee socks, brown leather shoes, wearing a pink bow on the head

 Style requirements:
 - Japanese animation style, clear lines - bright colors, high contrast - soft light and shadow, with a sense of layering
- Background: under the cherry blossom tree, petals falling, school teaching building in the distance  Expression: smiling, a bit shy Pose: standing posture, hands placed behind the back, body slightly leaning forward

Proportion: 16:9 (mobile wallpaper) Quality: 8K, ultra-fine, rich in details', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 208, '@joshesye', 'https://x.com/joshesye/status/2046593124646928397', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-208', '/images/case208.jpg', 'Generate a High-quality Anime Beautiful Girl Image', '["UI","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-207', 'Generate a Game Introduction Screen for Black Myth:', 'Template imported from awesome-gpt-image-2 case 207. Source: @liyue_ai.', 'UI & Interfaces', 'Generate a game introduction screen for Black Myth: Pan Jinlian, the character is extremely charming.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 207, '@liyue_ai', 'https://x.com/liyue_ai/status/2046576160952443082', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-207', '/images/case207.jpg', 'Generate a Game Introduction Screen for Black Myth:', '["Poster","Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-206', 'Guofeng Scroll Illustrator You Are a Top Chinese', 'Template imported from awesome-gpt-image-2 case 206. Source: @GeekCatX.', 'History & Classical Themes', '(Guofeng scroll illustrator) You are a top Chinese traditional Gongbi figure painter, skilled in painting classic character group portraits into long-scroll-style encyclopedia posters. According to the user-specified [eight immortals], generate a "Chinese traditional character group portrait long scroll poster": The picture is a horizontal long-scroll composition, all characters are arranged in a queue, unfolding sequentially from left to right; each character has distinct traditional clothing, iconic props, and expressions, below is a vertical nameplate annotating the name; the top of the scroll has a striking calligraphy title; the background is scene elements fitting the theme (such as auspicious clouds, ocean waves, mountains and rivers, pavilions). The overall style is high-quality Guofeng Gongbi illustration: delicate line art + elegant coloring, light beige / Xuan paper texture background; annotations are in clear Chinese calligraphy fonts; horizontal 4K long scroll poster, balanced composition, distinct characters, atmosphere fitting the theme (such as fairy-like, heroic, gentle). Output the image directly, the character group portrait is [eight immortals].', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 206, '@GeekCatX', 'https://x.com/GeekCatX/status/2046559605074076112', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-206', '/images/case206.jpg', 'Guofeng Scroll Illustrator You Are a Top Chinese', '["Poster","Illustration","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-205', 'Generate an Ancient Imperial Palace Express Delivery Station', 'Template imported from awesome-gpt-image-2 case 205. Source: @joshesye.', 'History & Classical Themes', 'Generate an ancient imperial palace × express delivery station', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 205, '@joshesye', 'https://x.com/joshesye/status/2046596222505361866', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-205', '/images/case205.jpg', 'Generate an Ancient Imperial Palace Express Delivery Station', '["History"]'::jsonb, '["History"]'::jsonb, FALSE, TRUE),
    ('case-204', 'Generate an Animation Storyboard Generator', 'Template imported from awesome-gpt-image-2 case 204. Source: @joshesye.', 'Other Use Cases', 'Generate an animation storyboard generator', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 204, '@joshesye', 'https://x.com/joshesye/status/2046596222505361866', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-204', '/images/case204.jpg', 'Generate an Animation Storyboard Generator', '["Other Use Cases"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-203', 'Troll Perspective Copywriting + Gpt Image 2', 'Template imported from awesome-gpt-image-2 case 203. Source: @joshesye.', 'Other Use Cases', 'Troll perspective copywriting + GPT Image 2', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 203, '@joshesye', 'https://x.com/joshesye/status/2046596222505361866', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-203', '/images/case203.jpg', 'Troll Perspective Copywriting + Gpt Image 2', '["Other Use Cases"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-202', 'Generate High-quality Beautiful Girl Otaku Must-have', 'Template imported from awesome-gpt-image-2 case 202. Source: @joshesye.', 'Photography & Realism', 'Generate high-quality beautiful girl (otaku must-have)', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 202, '@joshesye', 'https://x.com/joshesye/status/2046596222505361866', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-202', '/images/case202.jpg', 'Generate High-quality Beautiful Girl Otaku Must-have', '["Photography"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-201', 'An Outpatient Prescription Sheet from a Grade 3a', 'Template imported from awesome-gpt-image-2 case 201. Source: @msjiaozhu.', 'Documents & Publishing', 'An outpatient prescription sheet from a Grade 3A hospital, doctor''s illegible handwriting, containing realistic and reasonable diagnosis, drug names, dosages, with a doctor''s signature and department stamp in the bottom right corner.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 201, '@msjiaozhu', 'https://x.com/msjiaozhu/status/2046546317766500834', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-201', '/images/case201.jpg', 'An Outpatient Prescription Sheet from a Grade 3a', '["Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-200', 'Generate a Screenshot of a Douyin Live Stream', 'Template imported from awesome-gpt-image-2 case 200. Source: @xiaohu.', 'UI & Interfaces', 'Generate a screenshot of a Douyin live stream featuring a beautiful woman live streaming, selling pantyhose and underwear, her online viewer count is 99996, the popularity rating is 18+, a big brother named Xiao Hu sent her an airplane gift', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 200, '@xiaohu', 'https://x.com/xiaohu/status/2046536551681954207', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-200', '/images/case200.jpg', 'Generate a Screenshot of a Douyin Live Stream', '["UI"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-199', 'Case 199 Photography and Realism Template', 'Template imported from awesome-gpt-image-2 case 199. Source: @IamEmily2050.', 'Photography & Realism', '{
  Ultra-realistic iPhone 15 Pro front-camera selfie of an adult woman on a bright beach,
  photographed from a raised-arm high-angle selfie perspective. The phone is held slightly above her face,
  creating natural front-camera geometry with mild 24mm equivalent wide-angle distortion,
  realistic facial proportions,
  and deep smartphone depth of field. She tilts her chin upward and looks directly toward the phone lens while shielding harsh sunlight with one hand. Her expression is neutral,
  blank,
  and slightly distant,
  with wide attentive eyes but anatomically realistic eye size and natural facial proportions.\n\nShe has very light platinum-blonde hair styled in two tight braids,
  pale skin with real photographic skin texture,
  visible pores,
  subtle peach fuzz,
  faint under-eye texture,
  natural lip texture,
  and a soft sunlit sheen rather than airbrushed perfection. Her lips are naturally toned and slightly full,
  her nose is small and refined but realistic. Her nails are vivid blue. She wears a light blue fitted stretch-cotton top with a very deep wide neckline that reveals pronounced collarbones and upper chest structure in a natural,
  non-stylized way.\n\nThe setting is a wide coastal beach under strong late-morning sunlight,
  with a softly blurred horizon line in the background. The lighting is bright,
  high-key coastal daylight around 5500K,
  with strong white sand bounce filling the shadows evenly from below and around the face. Skin is illuminated by direct sun plus broad soft reflected fill from the beach,
  producing crisp but realistic highlights without harsh contrast. Fine grains of bright sand catch light subtly. The overall image should feel like a real high-exposure smartphone selfie taken outdoors in intense seaside light.\n\nColor rendering should be soft,
  clean,
  and modern,
  with neutral-to-pastel tones,
  realistic iPhone computational photography,
  slightly elevated exposure,
  controlled highlight rolloff,
  natural skin color,
  and no cinematic grading. Prioritize realism,
  physical accuracy,
  believable anatomy,
  and true smartphone image behavior over beauty stylization.", "negative_prompt": "anime,
  doll face,
  porcelain skin,
  poreless skin,
  plastic skin,
  CGI,
  3D render,
  surreal eyes,
  oversized eyes,
  fantasy beauty,
  airbrushed retouching,
  heavy makeup,
  glamour lighting,
  dramatic shadows,
  film grain,
  snow,
  winter clothing,
  black top,
  red nails,
  conservative neckline,
  studio backdrop,
  artificial blur,
  warped hands,
  deformed fingers,
  malformed face,
  symmetry perfection,
  beauty filter,
  uncanny skin smoothing" }', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 199, '@IamEmily2050', 'https://x.com/IamEmily2050/status/2046602266627465534', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-199', '/images/case199.jpg', 'Case 199 Photography and Realism Template', '["UI","Realistic","3D"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-198', ', Subjectdescription : , : , :', 'Template imported from awesome-gpt-image-2 case 198. Source: @IamEmily2050.', 'Photography & Realism', '{
  "cameraParameters": {
    "deviceType": "iPhone 15 Pro front selfie",
    "lens": "24mm",
    "composition": "High angle POV (first-person perspective)",
    "postProcessing": "Computational photography style, clear digital readout, deep depth of field"
  },
  "subjectDescription": {
    "features": "Porcelain doll aesthetic, flawless pale skin, huge ice-blue eyes, small nose, slightly upturned natural-colored lips",
    "expression": "Expressionless, hollow, wide-eyed staring",
    "styling": "Platinum blonde tight double braids hairstyle, vibrant blue nail polish",
    "clothing": "Light blue tight stretch cotton top, extremely deep ultra-wide V-neck, deep collarbone and neckline",
    "action": "Looking up at the camera, blocking the glaring sunlight with one hand"
  },
  "environmentAndLighting": {
    "scene": "Vast sandy beach, blurry horizon in the background",
    "lighting": "High-key bright coastal daylight, 5500K color temperature, strong white sand reflection fill, even lighting",
    "texture": "Slightly dewy poreless skin, fine reflective white sand particles"
  },
  "technicalConstraints": {
    "colorScience": "Soft pastel tones, linear neutral colors, high exposure",
    "negativePrompts": [
      "Heavy shadows",
      "Snow",
      "Winter clothing",
      "Red nails",
      "Black top",
      "Conservative neckline",
      "Film grain"
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 198, '@IamEmily2050', 'https://x.com/IamEmily2050/status/2046584217656570035', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-198', '/images/case198.jpg', ', Subjectdescription : , : , :', '["Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-197', 'Help Me Generate a Screenshot of Trump Versus', 'Template imported from awesome-gpt-image-2 case 197. Source: @underwoodxie96.', 'UI & Interfaces', 'Help me generate a screenshot of Trump versus Khamenei in the mid lane in League of Legends.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 197, '@underwoodxie96', 'https://x.com/underwoodxie96/status/2046529342415790275', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-197', '/images/case197.jpg', 'Help Me Generate a Screenshot of Trump Versus', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-196', 'A Colossal , Massive Scale, Towering Presence, a', 'Template imported from awesome-gpt-image-2 case 196. Source: @GeekCatX.', 'Other Use Cases', 'A colossal [SUBJECT], massive scale, towering presence,
a gigantic entity far beyond human size, overwhelming and oppressive,

drawn with extremely dense chaotic scribble lines,
ultra-dense overlapping pen strokes, tangled and chaotic linework,

on top of a real printed English/Chinese textbook or exam paper page,
visible text, layout, and paper texture clearly showing through,

ballpoint pen drawing style, fine ink lines, messy layered strokes,
no clean outlines, everything constructed from chaotic scribbles,

dark and muted base tones (black, deep indigo, dark violet),
with subtle low-saturation neon accents (blue, cyan, purple),

selective bioluminescent glow only in key areas (eyes, core, cracks, veins),
not overall brightness,

organic or mechanical textures depending on subject,
intricate details, complex surface patterns,

form emerging from chaos,
high-density center, edges dissolving into loose scribbles,

sense of scale emphasized by tiny human silhouette near the subject,

semi-transparent layers, depth created by line density,
raw, imperfect, noisy, energetic hand-drawn feeling,

slightly eerie, surreal, mysterious atmosphere,
mixed media illustration, scribble art,

extremely detailed, high contrast between dark mass and glowing accents,
masterpiece, ultra detailed

主体：巨龙', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 196, '@GeekCatX', 'https://x.com/GeekCatX/status/2046539797578330152', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-196', '/images/case196.jpg', 'A Colossal , Massive Scale, Towering Presence, a', '["Illustration"]'::jsonb, '["Tech","Social"]'::jsonb, FALSE, TRUE),
    ('case-195', 'A Dynamic Mixed-media Photograph Blending Hyper-realistic Portraiture with', 'Template imported from awesome-gpt-image-2 case 195. Source: @johnAGI168.', 'Photography & Realism', 'A dynamic mixed-media photograph blending hyper-realistic portraiture with traditional Chinese ink illustration.

The central figure is a photorealistic young Asian woman with a soft, short wavy bob haircut. Her makeup is natural and minimal, with a calm and gentle expression. She stands with her back to the camera in an elegant S-curve posture, creating a graceful and flowing silhouette. She slightly turns her upper body to glance over her shoulder with a quiet, introspective mood.

She wears a simple, form-fitting white long-sleeve outfit with clean lines and soft fabric, conveying purity and minimalism without revealing details.

She is placed in a real-world indoor setting near a sunlit window. The background is heavily blurred with strong bokeh and shallow depth of field, creating a dreamy and atmospheric environment.

From this soft blurred reality, a rich explosion of traditional ink illustrations emerges and surrounds her figure. The composition includes:

- Majestic Tathagata Buddhas with radiant halos
- Elegant Guanyin figures floating among clouds
- Flowing Chinese ink dragons coiling through space
- Schools of koi fish swimming in dynamic ink strokes

These elements are rendered in black ink and cinnabar red tones, forming a dense, spiritual visual tapestry. The ink flows organically around her, partially overlapping and blending into her silhouette, creating a seamless fusion between reality and myth.

No outlines or sticker effects. The integration is natural, fluid, and immersive.

Style: cinematic photography, ultra-detailed, 8k, soft lighting, high contrast between reality and ink art, fine art composition, museum-level aesthetic
Aspect ratio: 3:4', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 195, '@johnAGI168', 'https://x.com/johnAGI168/status/2046596103919767857', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-195', '/images/case195.jpg', 'A Dynamic Mixed-media Photograph Blending Hyper-realistic Portraiture with', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-194', 'Fitness Protein Powder E-commerce Detail Image', 'Template imported from awesome-gpt-image-2 case 194. Source: @MrLarus.', 'Products & E-commerce', 'Fitness protein powder e-commerce detail image', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 194, '@MrLarus', 'https://x.com/MrLarus/status/2046544209117634735', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-194', '/images/case194.jpg', 'Fitness Protein Powder E-commerce Detail Image', '["Products"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-193', 'A Highly Detailed Gongbi Painting of the Bodhisattva', 'Template imported from awesome-gpt-image-2 case 193. Source: @johnAGI168.', 'Illustration & Art', 'A highly detailed Gongbi painting of the Bodhisattva "Guanyin of a Thousand Hands".

However, instead of sacred religious artifacts, the thousand hands are holding modern office and household items: **laptops, smartphones, stacks of paperwork, coffee cups, stamps, calculators, mops, and baby bottles**. It represents the ultimate multi-tasking modern worker.

The golden aura behind the head is made of spinning clock gears.

**In the bottom right corner, a single red vertical artist chop seal reads "吴先生" (Mr. Wu), stylized like a watermark.** --ar 3:4', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 193, '@johnAGI168', 'https://x.com/johnAGI168/status/2046565555025367392', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-193', '/images/case193.jpg', 'A Highly Detailed Gongbi Painting of the Bodhisattva', '["Illustration"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-192', 'Ai Smart Glasses E-commerce Detail Image', 'Template imported from awesome-gpt-image-2 case 192. Source: @MrLarus.', 'Products & E-commerce', 'AI smart glasses e-commerce detail image', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 192, '@MrLarus', 'https://x.com/MrLarus/status/2046544209117634735', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-192', '/images/case192.jpg', 'Ai Smart Glasses E-commerce Detail Image', '["Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-191', 'Create a Science Fiction Movie Poster', 'Template imported from awesome-gpt-image-2 case 191. Source: @underwoodxie96.', 'Posters & Typography', 'Create a Science fiction movie poster', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 191, '@underwoodxie96', 'https://x.com/underwoodxie96/status/2046514205529088501', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-191', '/images/case191.jpg', 'Create a Science Fiction Movie Poster', '["Poster"]'::jsonb, '["Education"]'::jsonb, FALSE, TRUE),
    ('case-190', 'Fully Automatic Coffee Machine E-commerce Detail Image', 'Template imported from awesome-gpt-image-2 case 190. Source: @MrLarus.', 'Products & E-commerce', 'Fully automatic coffee machine e-commerce detail image', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 190, '@MrLarus', 'https://x.com/MrLarus/status/2046544209117634735', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-190', '/images/case190.jpg', 'Fully Automatic Coffee Machine E-commerce Detail Image', '["Products"]'::jsonb, '["Tech","Food"]'::jsonb, FALSE, TRUE),
    ('case-189', 'Summer Women''s Dress E-commerce Detail Image', 'Template imported from awesome-gpt-image-2 case 189. Source: @MrLarus.', 'Products & E-commerce', 'Summer women''s dress e-commerce detail image', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 189, '@MrLarus', 'https://x.com/MrLarus/status/2046544209117634735', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-189', '/images/case189.jpg', 'Summer Women''s Dress E-commerce Detail Image', '["Products"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-188', 'In the Style of Abcd a Black Cover', 'Template imported from awesome-gpt-image-2 case 188. Source: @xiaoxiaodong01.', 'UI & Interfaces', 'In the style of ABCD (a black cover design), design a VI system for Tu Ni Tai Mei. Tu Ni Tai Mei is an avatar and beauty photo sharing website.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 188, '@xiaoxiaodong01', 'https://x.com/xiaoxiaodong01/status/2046556758521573546', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-188', '/images/case188.jpg', 'In the Style of Abcd a Black Cover', '["Poster","Realistic","Character"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-187', '9:16 Vertical - Editorial Portrait, Single Subject Soft', 'Template imported from awesome-gpt-image-2 case 187. Source: @BubbleBrain.', 'Photography & Realism', '9:16 vertical - editorial portrait, single subject  soft black mist filter, subtle haze, gentle highlight bloom, muted tones  minimal indoor space, clean background, slight texture  young Korean woman, minimal makeup, natural skin texture  outfit: fitted ribbed knit top or soft camisole layered under a loose shirt, paired with high-waisted shorts or skirt; fabric slightly clings to body shape, soft and natural, no revealing elements  hair: slightly messy, natural volume  pose: sitting on floor with one leg bent and the other relaxed, body slightly leaning, shoulders not aligned, head tilted  composition: subject slightly off-center, negative space present  expression: calm, slightly distant, natural lips  lighting: soft side light, gentle shadow falloff  mood: understated, quiet, subtly sensual through natural body lines, relaxed and unposed  quality: fine grain, slight softness, realistic look', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 187, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2046434670724907395', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-187', '/images/case187.jpg', '9:16 Vertical - Editorial Portrait, Single Subject Soft', '["UI","Realistic","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-186', 'Create a 10 10 Grid of 100 Different', 'Template imported from awesome-gpt-image-2 case 186. Source: @ProperPrompter.', 'Brand & Logos', 'Create a 10 × 10 grid of 100 different fantasy RPG items rendered in classic pixel art style (16-bit or 32-bit sprite aesthetic, reminiscent of SNES/GBA-era JRPGs). Each item should appear in its own square tile with a short clear label underneath. Keep the grid neat on a white background. Make every item visually distinct and every label correctly spelled. Use crisp pixel edges, limited palette per sprite, and subtle dithering for shading.
Use these row themes:
Row 1: swords and blades
Row 2: shields and armor
Row 3: bows, crossbows, and ranged weapons
Row 4: staves, wands, and magical foci
Row 5: potions, elixirs, and flasks
Row 6: scrolls, tomes, and spellbooks
Row 7: rings, amulets, and enchanted trinkets
Row 8: helmets, crowns, and headgear
Row 9: keys, relics, and quest items
Row 10: gems, runes, and crafting materials
Show each tile as a centered item sprite on a clean background square, rendered as a classic inventory icon - the kind you''d see in a fantasy RPG menu. Keep the overall style consistent, cohesive, and reminiscent of beloved retro fantasy RPGs - charming, detailed, and instantly readable at small sizes.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 186, '@ProperPrompter', 'https://x.com/ProperPrompter/status/2046534215311970694', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-186', '/images/case186.jpg', 'Create a 10 10 Grid of 100 Different', '["Brand","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-185', 'Wu Zetian Taking a Selfie, Registering and Posting', 'Template imported from awesome-gpt-image-2 case 185. Source: @MrLarus.', 'History & Classical Themes', 'Wu Zetian taking a selfie, registering and posting on Weibo.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 185, '@MrLarus', 'https://x.com/MrLarus/status/2046585220393324553', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-185', '/images/case185.jpg', 'Wu Zetian Taking a Selfie, Registering and Posting', '["History"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-184', 'Du Fu Posting on Wechat Moments Complaining About', 'Template imported from awesome-gpt-image-2 case 184. Source: @MrLarus.', 'History & Classical Themes', 'Du Fu posting on WeChat Moments complaining about his roof being blown away by the wind', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 184, '@MrLarus', 'https://x.com/MrLarus/status/2046585220393324553', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-184', '/images/case184.jpg', 'Du Fu Posting on Wechat Moments Complaining About', '["History"]'::jsonb, '["Tech","Social"]'::jsonb, FALSE, TRUE),
    ('case-183', ',:xxx ,;, + , , , 40-60 :', 'Template imported from awesome-gpt-image-2 case 183. Source: @MrLarus.', 'Charts & Infographics', '请生成一张中文健身信息图，主题为：【xxx】。

要求这张图既专业又实用，适合普通成年人作为训练参考。默认对象为无严重伤病的健康成年人；如果没有额外说明，默认训练目标为"增肌 + 基础力量提升"，默认训练水平为"新手到中级之间"，默认训练场景为"普通健身房"，默认单次训练时长控制在 40-60 分钟内。

请根据【训练主题】自动判断输出类型：

1）如果【训练主题】是某个肌群或身体部位（例如：胸肌、背阔肌、肱二头肌、腹肌、肩部、腿部等），请输出一张"该部位训练计划信息图"。
2）如果【训练主题】是某个动作或技能目标（例如：引体向上、俯卧撑、双杠臂屈伸、深蹲等），请输出一张"动作解锁 / 进阶训练计划信息图"。

整张图请采用清晰、现代、专业、易读的中文信息图风格，竖版排版，视觉简洁，重点突出，适合社交媒体分享或训练参考卡片。不要写成长篇大论，每个模块用简洁短句呈现，数字信息要醒目。

这张信息图必须包含以下内容：

【A. 标题区】
- 主标题：直接写【训练主题】训练计划 / 解锁计划
- 副标题：自动补充适用人群、目标、训练场景、建议时长
例如：适合新手 / 增肌导向 / 健身房版 / 45分钟

【B. 训练目标区】
用简洁语言说明：
- 这次训练主要针对什么
- 主要目标是什么（增肌 / 力量 / 技能解锁 / 核心控制等）
- 本次训练的重点刺激或能力提升方向

【C. 热身区】
给出 2-4 个热身建议，简洁列出即可，例如：
- 动态活动
- 目标肌群激活
- 轻重量预热组
每项可附一句说明

【D. 主训练区】
这是核心部分，请列出 4-6 个主要训练动作。
每个动作都要包含以下信息：
- 动作名称
- 训练作用 / 针对部位
- 组数 × 次数（或时间）
- RIR 建议
- 每组间休息时间
- 动作关键要点（1-2 条）
- 常见错误（1 条即可）

请确保动作安排合理：
- 先复合动作，后孤立动作
- 整体训练量适中
- 新手不要安排过度极限训练
- 主动作通常建议 RIR 1-3
- 孤立动作可建议 RIR 0-2
- 如果是腹肌或核心类动作，可用"秒数 / 次数"形式
- 如果是技能类动作，请优先安排"前置能力动作 + 过渡动作 + 目标动作尝试"

【E. 进阶 / 解锁逻辑区】
根据主题自动生成：
- 如果是肌群训练：写"如何渐进超负荷"，例如达到次数上限后再加重量、优先保证动作标准等
- 如果是动作解锁：写"分阶段进阶路径"，例如从悬垂、肩胛引体、离心训练、弹力带辅助，到标准动作完成

【F. 替代动作区】
请给出 2-3 个替代动作，适用于以下情况：
- 没有器械
- 家庭训练
- 当前能力不足
- 某些动作做不了

【G. 执行提醒区】
请给出 4-6 条简洁提醒，例如：
- 动作标准优先于重量
- 不要每组都练到力竭
- 同肌群建议间隔 48-72 小时
- 疼痛不等于正常发力
- 睡眠不足时可适当减少训练量

【H. 恢复建议区】
简洁说明：
- 训练后恢复重点
- 蛋白质 / 睡眠 / 恢复间隔建议
- 1 句风险提醒（如有明显疼痛应停止并评估）

【I. 视觉设计要求】
- 整体为单页中文信息图
- 竖版排版
- 风格现代、清爽、专业、健身感强
- 使用模块化卡片布局
- 重点数字（组数、次数、RIR、休息）要醒目
- 可加入简洁的人体肌群图标、哑铃、杠铃、引体向上等小图标
- 颜色保持高级、干净、有运动感
- 中文文字必须清晰、准确、易读
- 避免过多装饰，强调实用性与执行性

请最终输出为"一张完整的信息图内容"，而不是只给普通段落文字。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 183, '@MrLarus', 'https://x.com/MrLarus/status/2046560406760505727', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-183', '/images/case183.jpg', ',:xxx ,;, + , , , 40-60 :', '["Infographic"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-182', '2000s Japanese Tv Drama Comedy Scene Aimed at', 'Template imported from awesome-gpt-image-2 case 182. Source: @UminekoStudio.', 'Scenes & Storytelling', '2000s Japanese TV drama comedy scene aimed at middle school students', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 182, '@UminekoStudio', 'https://x.com/UminekoStudio/status/2046488248256806981', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-182', '/images/case182.jpg', '2000s Japanese Tv Drama Comedy Scene Aimed at', '["Scenes"]'::jsonb, '["Tech","Story"]'::jsonb, FALSE, TRUE),
    ('case-181', 'Please Redesign This Product Advertisement from the Perspective', 'Template imported from awesome-gpt-image-2 case 181. Source: @genel_ai.', 'Posters & Typography', 'Please redesign this product advertisement from the perspective of a professional designer. Adopt current fashion trends, exquisite design targeting the target audience.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 181, '@genel_ai', 'https://x.com/genel_ai/status/2046498264774791514', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-181', '/images/case181.jpg', 'Please Redesign This Product Advertisement from the Perspective', '["UI","Product"]'::jsonb, '["Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-180', 'A Movie Poster Featuring a Seemingly Realistic Yet', 'Template imported from awesome-gpt-image-2 case 180. Source: @aiehon_aya.', 'Posters & Typography', 'A movie poster featuring a seemingly realistic yet subtly bizarre cross-dressing older man, 4 variations. Reaching the level of a professional designer''s production. The project and setting itself is a surreal animation of the "Are they really making a movie out of this?" kind, serious yet irresistibly funny. The title and broadcast information should also be displayed in Japanese.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 180, '@aiehon_aya', 'https://x.com/aiehon_aya/status/2046499177916682600', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-180', '/images/case180.jpg', 'A Movie Poster Featuring a Seemingly Realistic Yet', '["Poster","Realistic","Product"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-179', 'Steampunk Scientific Illustrator You Are a Professional Vintage', 'Template imported from awesome-gpt-image-2 case 179. Source: @GeekCatX.', 'Charts & Infographics', '(Steampunk Scientific Illustrator) You are a professional vintage steampunk anatomy atlas designer, specializing in constellation mechanical structure popular science posters. Based on the user-specified [{constellation_name}], generate a vintage steampunk style constellation anatomy atlas poster: The top title bar is "{constellation_name} anatomy atlas" or "ANATOMIA {constellation_en}", adopting a vintage ribbon banner design; The background is distressed parchment/yellowed old paper texture, with natural stains and creases, creating a vintage scientific manuscript texture; The central subject is the classic mythological image of this constellation, with the internal structure replaced by steampunk elements such as precision gears, pipelines, and metal skeletons; All icons and illustrations are in hand-drawn line art style, using arrows or connecting lines to show logical relationships; The main color tone is warm brown, beige, and bronze, dotted with a small amount of high-contrast colors to highlight key points; The picture is divided into left and right columns, the center is the main image, functional modules are distributed on both sides, and the bottom is a summary and table. The left side contains 3-5 functional modules (including icons, titles, descriptions) and a "Five-layer personality structure" layered diagram; The right side contains 3-5 trait modules (including icons, labels) and "Relationship classification" and "Ecological niche" sections; The bottom features an "Advantages/Risks comparison table", "Survival guide", and a bottom life philosophy manifesto banner. Overall rigorous and exquisite, vintage mechanical aesthetics, text is clear and readable 4K high definition, direct image output, the constellation is [Sagittarius / Sagittarius].', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 179, '@GeekCatX', 'https://x.com/GeekCatX/status/2046574334572212694', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-179', '/images/case179.jpg', 'Steampunk Scientific Illustrator You Are a Professional Vintage', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-178', 'Generate a Set of Amazon A+ Detail Images', 'Template imported from awesome-gpt-image-2 case 178. Source: @xin_pai88825.', 'Products & E-commerce', 'Generate a set of Amazon A+= detail images', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 178, '@xin_pai88825', 'https://x.com/xin_pai88825/status/2046576100592201946', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-178', '/images/case178.jpg', 'Generate a Set of Amazon A+ Detail Images', '["Products"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-177', 'Help Me Generate a Central Control Interface of', 'Template imported from awesome-gpt-image-2 case 177. Source: @xin_pai88825.', 'UI & Interfaces', 'Help me generate a central control interface of Geely Galaxy M9, size 21:9, dark color scheme.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 177, '@xin_pai88825', 'https://x.com/xin_pai88825/status/2046576100592201946', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-177', '/images/case177.jpg', 'Help Me Generate a Central Control Interface of', '["UI"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-176', 'Su Shi''s First Day of Exile Xiaohongshu Screenshot', 'Template imported from awesome-gpt-image-2 case 176. Source: @MrLarus.', 'History & Classical Themes', 'Su Shi''s first day of exile Xiaohongshu screenshot', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 176, '@MrLarus', 'https://x.com/MrLarus/status/2046585220393324553', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-176', '/images/case176.jpg', 'Su Shi''s First Day of Exile Xiaohongshu Screenshot', '["UI"]'::jsonb, '["Social"]'::jsonb, FALSE, TRUE),
    ('case-175', 'Create a Premium 4:3 Presentation Cover Slide Introducing', 'Template imported from awesome-gpt-image-2 case 175. Source: @cellier_.', 'Posters & Typography', 'Create a premium 4:3 presentation cover slide introducing Chronicle, the AI-native presentation platform from http://chroniclehq.com.

Style:
elegant, minimal, modern, premium startup aesthetic. Similar to high-end brand guideline covers (like Apple / Linear / Notion style). Soft gradient background with subtle depth, clean whitespace, refined typography, polished editorial layout.

Main title:
CHRONICLE

Subtitle:
AI PRESENTATION PLATFORM

Body copy (small elegant text):
Turn raw ideas into polished, high-impact presentations.
Start from notes, docs, links, or existing decks.
Generate beautiful, on-brand slides with AI.
Edit freely on a flexible canvas.
Export to PPT, PDF, or publish as a website.

Feature highlights (small premium labels):
STORY-FIRST
ON-BRAND DESIGN
AI EDITING
FREEFORM CANVAS
PPT EXPORT
TEAM COLLABORATION

Bottom-right elegant logo text:
chronicle

Visual feeling:
business-class premium, strategy deck quality, consulting-grade presentation, slightly futuristic but highly professional.

Composition:
clean editorial balance, asymmetrical layout, strong whitespace, presentation software hero shot feeling.

Aspect ratio:
4:3

Language:
English only', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 175, '@cellier_', 'https://x.com/cellier_/status/2046615173411262959', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-175', '/images/case175.jpg', 'Create a Premium 4:3 Presentation Cover Slide Introducing', '["UI","Poster","Brand"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-174', 'A Finely Detailed Gongbi Painting of a Noble', 'Template imported from awesome-gpt-image-2 case 174. Source: @johnAGI168.', 'History & Classical Themes', 'A finely detailed Gongbi painting of a noble Tang Dynasty lady taking a stroll in the imperial garden. She looks elegant and calm.

She is holding a gold leash. At the end of the leash is a terrifying **Xenomorph monster (from the movie Alien)**. However, the Xenomorph is wearing a **cute pink silk vest** and is behaving like a well-trained dog.

Background features peonies and butterflies.

**In the bottom right corner, a single red vertical artist chop seal reads "吴先生" (Mr. Wu), stylized like a watermark.** --ar 3:4', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 174, '@johnAGI168', 'https://x.com/johnAGI168/status/2046565555025367392', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-174', '/images/case174.jpg', 'A Finely Detailed Gongbi Painting of a Noble', '["Illustration","Classical"]'::jsonb, '["Tech","Commerce","History"]'::jsonb, FALSE, TRUE),
    ('case-173', 'Clothing Details: the Model Wears an Exquisite Pale', 'Template imported from awesome-gpt-image-2 case 173. Source: @fdtreesky.', 'Other Use Cases', 'Clothing details: The model wears an exquisite pale ice blue chest-high ruqun, made of multiple layers of lightweight tulle and silk organza materials. Its wide, translucent broad sleeves are adorned with tiny silver and light blue sequin embroideries like stars, shimmering under the light (with a galaxy-like dreamy feel). The tube top position has complex silver lace and woven texture details, and the belt falls naturally.
Material and light and shadow: The image presents 8k ultra-high resolution and extreme rendering of macro textures of the fabric. The lighting uses soft natural side light (Tyndall Effect Typndall Effect), accurately transmitting through the light gauze, creating a sense of translucency (Translucency) and fluidity of the fabric.
Composition and lens: Uses 85mm golden portrait lens effect, f/1.8 large aperture, full-body composition, model standing in the center', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 173, '@fdtreesky', 'https://x.com/fdtreesky/status/2046508731090018331', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-173', '/images/case173.jpg', 'Clothing Details: the Model Wears an Exquisite Pale', '["UI","3D"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-172', 'Design a Key Visual for a Fictional Animation', 'Template imported from awesome-gpt-image-2 case 172. Source: @SSSS_CRYPTOMAN.', 'Brand & Logos', 'Design a key visual for a fictional animation. The theme is "Sci-Fi Momotaro". Design charming characters, backgrounds, logos, and promotional slogans, completed in the form of a beautiful illustration, allowing the worldview to be conveyed in a single image.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 172, '@SSSS_CRYPTOMAN', 'https://x.com/SSSS_CRYPTOMAN/status/2046575354555617761', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-172', '/images/case172.jpg', 'Design a Key Visual for a Fictional Animation', '["Illustration","Brand","Character"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-171', 'Create an Image with 10x10 Grid of Objects', 'Template imported from awesome-gpt-image-2 case 171. Source: @umesh_ai.', 'Charts & Infographics', 'create an image with 10x10 grid of objects that have the names starting with letter a.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 171, '@umesh_ai', 'https://x.com/umesh_ai/status/2046510988367945983', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-171', '/images/case171.jpg', 'Create an Image with 10x10 Grid of Objects', '["Infographic"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-168', 'Generate an Image of a Handwritten Traditional Chinese', 'Template imported from awesome-gpt-image-2 case 168. Source: @MrLarus.', 'Documents & Publishing', 'Generate an image of a handwritten traditional Chinese medicine or Western medicine prescription', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 168, '@MrLarus', 'https://x.com/MrLarus/status/2046514998965371144', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-168', '/images/case168.jpg', 'Generate an Image of a Handwritten Traditional Chinese', '["Documents"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-167', 'Wechat Moments of the Xuanwu Gate Incident', 'Template imported from awesome-gpt-image-2 case 167. Source: @Tz_2022.', 'History & Classical Themes', 'WeChat Moments of the Xuanwu Gate Incident', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 167, '@Tz_2022', 'https://x.com/Tz_2022/status/2046523491940225366', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-167', '/images/case167.jpg', 'Wechat Moments of the Xuanwu Gate Incident', '["History"]'::jsonb, '["Social","History"]'::jsonb, FALSE, TRUE),
    ('case-166', 'Twelve Gold Saints Card Set', 'Template imported from awesome-gpt-image-2 case 166. Source: @songguoxiansen.', 'Other Use Cases', 'Generate a 12-grid card image of the 12 Gold Saints from Saint Seiya, with the corresponding Chinese name written on each card, 4 per row, aspect ratio 16:9.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 166, '@songguoxiansen', 'https://x.com/songguoxiansen/status/2046476566537080849', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-2.md#case-166', '/images/case166.jpg', 'Twelve Gold Saints Card Set', '["Other Use Cases"]'::jsonb, '["Tech"]'::jsonb, TRUE, TRUE),
    ('case-165', 'A Stunning Beauty with a Cool, Aloof Atmosphere,', 'Template imported from awesome-gpt-image-2 case 165. Source: @BubbleBrain.', 'Photography & Realism', 'a stunning beauty with a cool, aloof atmosphere, delicate facial features, a cold and sophisticated high-fashion face, long hair, and a graceful slender figure; barbecue "three-sword style" pose: one barbecue skewer held in her mouth, one skewer in each hand crossed to mimic Zoro''s three-sword style; street night scene ambiance, warm yellow night market lighting, blurred background, film-like texture, soft-focus glow, cinematic storytelling feel, trendy high-end influencer-style fashion shoot, clear luminous skin, sharply detailed strands of hair, lively dynamic expression, low-angle wide-angle shot, moody dark-toned atmosphere, shallow depth of field, ultra HD 8K, extreme detail, cinematic lighting', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 165, '@BubbleBrain', 'https://x.com/BubbleBrain/status/2046564674112831920', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-165', '/images/case165.jpg', 'A Stunning Beauty with a Cool, Aloof Atmosphere,', '["Character"]'::jsonb, '["Tech","Fashion","Travel"]'::jsonb, FALSE, TRUE),
    ('case-164', 'A 9:16 Vertical Screen Screenshot of a Douyin', 'Template imported from awesome-gpt-image-2 case 164. Source: @songguoxiansen.', 'UI & Interfaces', 'A 9:16 vertical screen screenshot of a Douyin live stream, space live stream style. Trump is wearing a NASA-style white spacesuit, with the helmet visor half open, revealing his signature golden hair and smile. He is floating inside the cabin of the International Space Station doing a live stream, in a microgravity weightless state, with his body slightly suspended. He is holding up a metal nameplate fixed to the spacesuit with both hands, and the nameplate says "Thanks to Songguo Xiansen for the big rocket" in NASA-style print. Behind him, the blue Earth and deep space can be seen through the circular porthole. The live stream interface shows the online viewer count as "Earth + Mars total 8.88 million". In the bullet screen area, someone is commenting "Really live streaming from space?" and "Songguo Xiansen''s rocket sent you up to the sky". The rocket gift effect in the center of the screen echoes a real rocket launching in the space outside the window, forming a combination of virtual and real effects. There are various precision instruments and control panels inside the cabin, with green and blue indicator lights flashing. The color tone of the picture is mainly dark blue, white, and gold, with starlight from outside the porthole embellishing it, 8K ultra-high definition, visual effects at the level of the movie "Gravity".', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 164, '@songguoxiansen', 'https://x.com/songguoxiansen/status/2046478609238626569', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-164', '/images/case164.jpg', 'A 9:16 Vertical Screen Screenshot of a Douyin', '["UI","Brand"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-163', 'Li Bai Dancing Under the Moon During a', 'Template imported from awesome-gpt-image-2 case 163. Source: @MrLarus.', 'UI & Interfaces', 'Li Bai dancing under the moon during a Douyin livestream', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 163, '@MrLarus', 'https://x.com/MrLarus/status/2046585220393324553', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-163', '/images/case163.jpg', 'Li Bai Dancing Under the Moon During a', '["UI"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-162', 'If It Were a Character', 'Template imported from awesome-gpt-image-2 case 162. Source: @nicdunz.', 'Characters & People', '{argument name="voice" default="chatgpt voice"} if it were a character', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 162, '@nicdunz', 'https://x.com/nicdunz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-162', '/images/case162.jpg', 'If It Were a Character', '["Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-161', ''', Camouflage Cargo Shorts , Environment, Center :', 'Template imported from awesome-gpt-image-2 case 161. Source: @DanDaniDaniel01.', 'UI & Interfaces', '{
  "type": "video game screenshot mockup",
  "perspective": "third-person over-the-shoulder",
  "character": {
    "description": "male protagonist seen from behind",
    "clothing": "grey tank top with graphic ''{argument name=\"shirt graphic\" default=\"LEONIDA MARINE CENTER\"}'', camouflage cargo shorts"
  },
  "environment": {
    "setting": "tropical coastal town, dirt road, sunny daytime with scattered clouds",
    "left_side": "wooden welcome sign reading ''Welcome to {argument name=\"location name\" default=\"LEONIDA KEYS\"} YOUR PARADISE'', pink plastic flamingo, tropical foliage, distant water tower",
    "center": "green building with ''FISH'' sign and marlin graphic, sign reading ''BAIT TACKLE ICE BEER WINE'', pedestrians walking",
    "right_side": "two-story wooden building ''Brian''s Boat Works & Marina'', ''Brian''s Bar'' neon sign, parked pickup truck, jet skis on a trailer"
  },
  "ui_elements": {
    "count": 5,
    "components": [
      {
        "position": "top-left",
        "type": "mission objective",
        "text": "{argument name=\"mission title\" default=\"MEET RAUL\"}\n{argument name=\"mission description\" default=\"Raul has some work for you at his boatyard\"}"
      },
      {
        "position": "top-right",
        "type": "status HUD",
        "text": "13:47\n$1,142",
        "icon": "pink palm tree"
      },
      {
        "position": "bottom-left",
        "type": "minimap",
        "description": "circular map with purple border, white map icons including ''N'' for north"
      },
      {
        "position": "bottom-left, right of minimap",
        "type": "location text",
        "text": "{argument name=\"location name\" default=\"LEONIDA KEYS\"}\nPALM ISLAND"
      },
      {
        "position": "bottom-right",
        "type": "watermark",
        "text": "{argument name=\"game title\" default=\"GTA VI\"}\nPRE-ALPHA FOOTAGE"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 161, '@DanDaniDaniel01', 'https://x.com/DanDaniDaniel01', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-161', '/images/case161.jpg', ''', Camouflage Cargo Shorts , Environment, Center :', '["UI","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-160', 'Generate a Set of Icons for in ,', 'Template imported from awesome-gpt-image-2 case 160. Source: @TanShilong.', 'Brand & Logos', 'Generate a set of icons for {argument name="device" default="vintage electronic equipment"} in {argument name="style" default="retro skeuomorphic style"}, including icon names in the image.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 160, '@TanShilong', 'https://x.com/TanShilong', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-160', '/images/case160.jpg', 'Generate a Set of Icons for in ,', '["UI","Brand"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-159', ', Layout : , Stats : 12', 'Template imported from awesome-gpt-image-2 case 159. Source: @onlyhuman028.', 'UI & Interfaces', '{
  "type": "e-commerce livestream UI mockup",
  "subject": {
    "description": "photorealistic young Asian woman, sweaty glowing skin, long dark wavy hair, wearing a white short-sleeve polo shirt and white pleated tennis skirt, holding a white tennis racket over her right shoulder, looking directly at camera, studio lighting, white background"
  },
  "layout": {
    "top_header": {
      "host_info": {
        "name": "{argument name=\"host name\" default=\"小鹿运动优选\"}",
        "stats": "12.8万本场点赞",
        "button": "关注"
      },
      "rank_tag": "带货榜第3名",
      "viewer_stats": "1.2万"
    },
    "top_right": {
      "coupon": {
        "title": "直播间专属券",
        "value": "￥20 满199可用",
        "button": "领取"
      }
    },
    "left_overlay": {
      "title": "{argument name=\"campaign title\" default=\"夏日运动季\"}",
      "subtitle": "{argument name=\"campaign subtitle\" default=\"活力开场\"}",
      "bullet_points": {
        "count": 3,
        "items": ["透气速干", "弹力舒适", "运动百搭"]
      }
    },
    "right_overlay": {
      "product_cards": {
        "count": 2,
        "card_1": {
          "status": "正在讲解",
          "image": "white polo shirt and skirt flat lay",
          "title": "{argument name=\"product name\" default=\"运动POLO衫套装\"}",
          "details": "白色·M码",
          "price": "{argument name=\"price\" default=\"￥129\"}",
          "button": "去抢购"
        },
        "card_2": {
          "status": "热卖 x 156",
          "image": "miniature of main model",
          "title": "运动POLO衫套装女",
          "details": "透气速干 显瘦百搭",
          "price": "{argument name=\"price\" default=\"￥129\"}",
          "button": "抢"
        }
      }
    },
    "bottom_left": {
      "chat_messages": {
        "count": 5,
        "description": "scrolling chat messages with usernames and comments"
      },
      "purchase_alert": "用户_6789 等3人 正在去购买"
    },
    "bottom_bar": {
      "input_field": "说点什么...",
      "icons": {
        "count": 5,
        "types": ["smile", "shopping cart", "heart", "gift", "more"]
      }
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 159, '@onlyhuman028', 'https://x.com/onlyhuman028', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-159', '/images/case159.jpg', ', Layout : , Stats : 12', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-158', ', Layout : , Stats : 12', 'Template imported from awesome-gpt-image-2 case 158. Source: @coconut_256.', 'UI & Interfaces', '{
  "type": "e-commerce live stream interface mockup",
  "subject": {
    "description": "young Asian woman, long wavy dark hair, wearing a white short-sleeve polo shirt and white pleated tennis skirt, holding a white tennis racket over her right shoulder, looking directly at the camera with a soft expression",
    "background": "soft light grey studio background"
  },
  "layout": {
    "header": {
      "left": {
        "avatar": "female portrait",
        "name": "{argument name=\"host name\" default=\"小鹿运动优选\"}",
        "stats": "12.8万本场点赞",
        "button": "关注",
        "badge": "带货榜第3名"
      },
      "right": {
        "viewer_avatars_count": 3,
        "viewer_count": "1.2万",
        "close_icon": "X"
      }
    },
    "floating_elements": [
      {
        "position": "top right",
        "type": "coupon card",
        "title": "直播间专属券",
        "details": "¥20 满199可用",
        "button": "领取"
      },
      {
        "position": "mid left",
        "type": "campaign text",
        "subtitle": "夏日运动季",
        "headline": "{argument name=\"main headline\" default=\"活力开场\"}",
        "bullet_points_count": 3,
        "bullet_points": ["透气速干", "弹力舒适", "运动百搭"]
      },
      {
        "position": "mid right",
        "type": "product card active",
        "badge": "正在讲解",
        "image": "white polo and skirt flat lay",
        "title": "{argument name=\"product name\" default=\"运动POLO衫套装\"}",
        "details": "白色·M码",
        "price": "{argument name=\"price\" default=\"¥129\"}",
        "button": "去抢购"
      },
      {
        "position": "bottom right",
        "type": "product card secondary",
        "badge": "热卖 x 156",
        "image": "model wearing the outfit",
        "title": "运动POLO衫套装女 透气速干 显瘦百搭",
        "tags": ["7天无理由退货", "运费险"],
        "price": "¥129",
        "button": "抢"
      }
    ],
    "chat_overlay": {
      "position": "bottom left",
      "message_count": 5,
      "messages": [
        "小鹿姐姐: 欢迎新朋友们来到直播间~",
        "运动达人: {argument name=\"chat message\" default=\"这套好看!\"}",
        "卡卡西: 布料透气吗?",
        "小鹿运动优选: 我们这个面料是冰丝速干的，运动出汗也不闷热哦~",
        "用户_6789: 已拍!"
      ],
      "purchase_alert": "用户_6789 等3人 正在去购买"
    },
    "footer": {
      "input_bar": "说点什么...",
      "icons_count": 5,
      "icons": ["smile", "shopping cart", "heart", "share", "more"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 158, '@coconut_256', 'https://x.com/coconut_256', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-158', '/images/case158.jpg', ', Layout : , Stats : 12', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-157', 'Accents , Product : , Model : ,', 'Template imported from awesome-gpt-image-2 case 157. Source: @AmberPromptai.', 'Products & E-commerce', '{
  "type": "e-commerce product infographic",
  "theme": "dark mode with {argument name=\"accent color\" default=\"orange\"} accents",
  "product": {
    "brand": "{argument name=\"brand name\" default=\"MEAN WELL\"}",
    "model": "{argument name=\"product model\" default=\"ELG-100-24B\"}",
    "description": "100W Constant Current LED Driver, rectangular silver metal housing with black cables on both ends and detailed specification label"
  },
  "layout": {
    "sections": [
      {
        "name": "Hero Section",
        "elements": [
          "Brand logo top left",
          "Headline: ''{argument name=\"main headline\" default=\"Stable Power For Outdoors\"}''",
          "Subtext: Wide input voltage, protected housing...",
          "Large angled product shot",
          "Faded ''100W'' watermark in background"
        ]
      },
      {
        "name": "Feature Highlights",
        "count": 3,
        "panels": [
          { "title": "Precision Build", "visual": "Close-up of the specification label" },
          { "title": "Secure Connection", "visual": "Close-up of the cable entry and mounting ear" },
          { "title": "Key Features", "visual": "Angled product shot with 3 callout lines pointing to text: ''100~305VAC Input'', ''Constant Current'', ''IP67 / IP65 Housing''" }
        ]
      },
      {
        "name": "Applications",
        "count": 4,
        "panels": [
          { "title": "For Street Lighting", "visual": "Nighttime highway illuminated by streetlights" },
          { "title": "For Outdoor Projects", "visual": "Modern building exterior with architectural landscape lighting" },
          { "title": "For Indoor Systems", "visual": "Modern commercial hallway with linear ceiling lights" },
          { "title": "For Dimming Control", "visual": "Electrical control box with 4 labels: ''0-10V'', ''PWM'', ''RESISTOR'', ''DALI''" }
        ]
      },
      {
        "name": "Environmental Protection",
        "elements": [
          "Product resting on a wet surface with water droplets and rain effect",
          "Headline: ''Protected Performance''",
          "Description text about indoor/outdoor use and active PFC",
          "Badge: ''{argument name=\"warranty years\" default=\"5\"}-Year Warranty''"
        ]
      },
      {
        "name": "Technical Specifications",
        "elements": [
          "Headline: ''Lighting Power Technology''",
          "4 checkmark bullet points: ''100~305VAC Input'', ''Active PFC'', ''Low Standby <0.5W'', ''0~10V / PWM / Resistor / DALI''",
          "Product shot glowing on a high-tech circuit board background"
        ]
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 157, '@AmberPromptai', 'https://x.com/AmberPromptai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-157', '/images/case157.jpg', 'Accents , Product : , Model : ,', '["UI","Infographic","Product"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-156', ', Ui Layout : , Stats : 12', 'Template imported from awesome-gpt-image-2 case 156. Source: @linxiaobei888.', 'UI & Interfaces', '{
  "type": "mobile live-streaming e-commerce interface mockup",
  "subject": {
    "description": "young Asian woman, long dark hair, wearing light-colored floral pajama set with a pink bow, holding the pajama top outward to show the fabric",
    "background": "cozy room, clothing rack with pajamas, flowers, warm lighting"
  },
  "ui_layout": {
    "top_bar": {
      "time": "20:34",
      "host_info": {
        "name": "{argument name=\"host name\" default=\"小雨睡衣\"}",
        "stats": "12.8万本场点赞",
        "button": "关注"
      },
      "viewer_info": {
        "avatars_count": 3,
        "total_viewers": "1.2万"
      }
    },
    "floating_tags": {
      "count": 2,
      "labels": ["带货总榜第3名", "人气榜"]
    },
    "widgets": {
      "top_left": "red envelope icon with timer 03:45",
      "top_right": "floating heart icon with text 直播好物大赏 发现新热爱"
    },
    "marketing_text_overlay": {
      "position": "mid-right",
      "lines_count": 5,
      "lines": [
        "{argument name=\"main headline\" default=\"新款睡衣\"}",
        "{argument name=\"sub headline\" default=\"正在秒杀中...\"}",
        "亲肤透气",
        "柔软舒适",
        "不起球 不褪色"
      ]
    },
    "chat_log": {
      "position": "bottom-left",
      "message_count": 7,
      "messages": [
        "32 雨*** 加入了直播间",
        "小***: 好看，多少钱",
        "小***: 拍了，期待发货",
        "C***: 质量看着不错",
        "用***: 身高165，体重120斤，穿多大码？",
        "@***: 主播身上这款有货吗？",
        "晴***: 已拍，坐等收货！"
      ]
    },
    "product_card": {
      "position": "bottom-right",
      "thumbnail": "miniature of the host",
      "title": "{argument name=\"product title\" default=\"【小雨睡衣】春季新款家居服套装\"}",
      "tags_count": 2,
      "tags": ["7天无理由退货", "运费险"],
      "price_section": "秒杀价 ¥ {argument name=\"product price\" default=\"89.9\"}",
      "action_button": "抢"
    },
    "bottom_bar": {
      "input_placeholder": "说点什么...",
      "icon_count": 5,
      "icons": ["smiley face", "shopping cart", "heart/gift", "gift box", "three dots"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 156, '@linxiaobei888', 'https://x.com/linxiaobei888', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-156', '/images/case156.jpg', ', Ui Layout : , Stats : 12', '["UI","Product","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-155', 'Create for a Standard in', 'Template imported from awesome-gpt-image-2 case 155. Source: @wtry1102.', 'Products & E-commerce', 'Create {argument name="items" default="fan goods"} for a standard {argument name="character type" default="Vtuber"} in {argument name="style" default="live-action"}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 155, '@wtry1102', 'https://x.com/wtry1102', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-155', '/images/case155.jpg', 'Create for a Standard in', '["Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-154', 'A Photorealistic, High-resolution Commercial Photograph of a Parked', 'Template imported from awesome-gpt-image-2 case 154. Source: @AlwaveNazca.', 'Photography & Realism', 'A photorealistic, high-resolution commercial photograph of a {argument name="car model and color" default="bright blue Alpine A110 R sports car"} parked in the foreground inside a massive aircraft hangar. The car features a black carbon fiber hood, black roof, black alloy wheels, and a front license plate reading "{argument name="license plate text" default="A110 R"}". Directly behind the car, dominating the background, is a {argument name="airplane model" default="white Airbus A320 commercial airliner"} with a blue tail. The hangar has a highly polished, reflective concrete floor that mirrors the car and plane. To the left, a sign on the metal wall reads "{argument name="hangar sign text" default="HANGAR 05 MAINTENANCE"}". The hangar doors are wide open, revealing a bright, overcast sky and a distant cityscape. The lighting is soft and cinematic, highlighting the sleek aerodynamic curves of both vehicles.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 154, '@AlwaveNazca', 'https://x.com/AlwaveNazca', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-154', '/images/case154.jpg', 'A Photorealistic, High-resolution Commercial Photograph of a Parked', '["Realistic"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-153', 'Using Reference 0 as the Base Style and', 'Template imported from awesome-gpt-image-2 case 153. Source: @xzjken.', 'Posters & Typography', 'Using REFERENCE_0 as the base style and preserving the central chicken illustration, transform the image into a product packaging label for a herbal soup mix. Shift the chicken to the right side. Replace the top text with a large, bold black brush-stroke headline {argument name="main headline" default="元气祛湿 鸡煲汤包"} and a smaller subtitle {argument name="subtitle" default="吃山林土货 味道当然好!"}. On the left side, add a new woven basket containing exactly 6 distinct piles of ingredients: woody root sticks, white square cubes, round sliced brown roots, yellow soybeans, dried orange peel strips, and dark red dates. Attach 6 small brown rectangular labels with white text to these ingredients. Below the chicken, add a circular orange badge containing the text {argument name="ingredients list" default="内含有:五指毛桃、茯苓、土茯苓、黄豆、陈皮、红枣"}. At the bottom, create a solid orange rectangular banner featuring a cooking pot icon, the text {argument name="usage instructions" default="用法:把汤料清洗干净放入锅中，加入姜片煮20分钟，后加入鸡肉再煮20分钟即可。"}, and a secondary slogan {argument name="bottom slogan" default="天然好料 滋补好汤"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 153, '@xzjken', 'https://x.com/xzjken', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-153', '/images/case153.jpg', 'Using Reference 0 as the Base Style and', '["Poster","Illustration","Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-152', ', Clothing : , Action : , Setting', 'Template imported from awesome-gpt-image-2 case 152. Source: @coder_left.', 'UI & Interfaces', '{
  "type": "e-commerce livestream screenshot mockup",
  "scene": {
    "subject": "{argument name=\"main subject\" default=\"Caucasian male resembling Sam Altman\"}",
    "clothing": "dark green crewneck sweater",
    "action": "holding a black product box in one hand and pointing at it with the other",
    "setting": "dark studio with a microphone on the left, faint ''AI'' text in the background",
    "props": [
      "black mug with white OpenAI logo",
      "stack of 4 black product boxes on the right"
    ]
  },
  "product_design": {
    "box_color": "black",
    "logo": "orange asterisk or sunburst",
    "text": "{argument name=\"product name\" default=\"Claude Opus 4.7\"}"
  },
  "ui_overlays": {
    "top_left_product_info": {
      "brand_tag": "Anthropic 官方旗舰店",
      "title": "{argument name=\"product name\" default=\"Claude Opus 4.7\"}",
      "subtitle": "{argument name=\"main headline\" default=\"更强推理·更高智能\"}",
      "sub_subtitle": "最强大模型: Opus 4.7 重磅发布!",
      "bullet_points_count": 3,
      "bullet_points": ["超强推理能力", "代码能力巅峰", "复杂任务轻松搞定"]
    },
    "top_right_live_status": {
      "viewer_info": "直播中 | 52.8万人观看",
      "promo_banner": "直播专属福利 限时折扣·错过不再有",
      "countdown": "倒计时 00:09:47"
    },
    "middle_right_price_card": {
      "header": "{argument name=\"product name\" default=\"Claude Opus 4.7\"} 直播间专享价",
      "price_currency": "¥",
      "price_value": "{argument name=\"promotional price\" default=\"0.47\"}",
      "price_unit": "/百万tokens起",
      "original_price": "原价: ¥1.89",
      "button": "立即抢购"
    },
    "bottom_left_chat": {
      "message_count": 9,
      "input_box_placeholder": "说点什么..."
    },
    "bottom_right_banner": {
      "headline": "奥特曼首推！认准Claude Opus 4.7",
      "subheadline": "更智能 · 更安全 · 更可靠",
      "feature_tags_count": 4,
      "feature_tags": ["强大推理", "代码神器", "安全可靠", "极速响应"]
    },
    "floating_elements": [
      {
        "type": "sticker",
        "position": "middle right over product boxes",
        "text": "{argument name=\"sticker text\" default=\"史上最强 AI模型!\"}"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 152, '@coder_left', 'https://x.com/coder_left', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-152', '/images/case152.jpg', ', Clothing : , Action : , Setting', '["UI","Product","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-151', ', , Badge : , Description : ,', 'Template imported from awesome-gpt-image-2 case 151. Source: @kitune_fire45.', 'Products & E-commerce', '{
  "type": "2x2 advertising banner grid",
  "layout": "4 distinct quadrants, each featuring a different industry advertisement",
  "quadrants": [
    {
      "position": "top-left",
      "industry": "skincare",
      "visuals": "Asian woman touching cheek, floating water droplets, white pump bottle",
      "brand": "BALANCÉE",
      "copy": {
        "headline": "{argument name=\"skincare headline\" default=\"素肌が、目覚める。\"}",
        "subheadline": "透明感あふれる、新しいわたしへ。",
        "features_count": 3,
        "features_labels": ["高保湿", "肌荒れ予防", "美白ケア*"]
      }
    },
    {
      "position": "top-right",
      "industry": "restaurant food",
      "visuals": "close-up of spaghetti bolognese with grated cheese and parsley, dark moody lighting",
      "brand": "Trattoria Luce",
      "copy": {
        "headline": "{argument name=\"food headline\" default=\"このパスタ、事件級。\"}",
        "badge": "期間限定",
        "description": "黒毛和牛のボロネーゼ 〜トリュフの香り〜"
      }
    },
    {
      "position": "bottom-left",
      "industry": "travel",
      "visuals": "woman with backpack facing a scenic mountain lake, bright daylight",
      "brand": "NATURE JOURNEY",
      "copy": {
        "headline": "{argument name=\"travel headline\" default=\"わたしを、解き放つ旅へ。\"}",
        "subheadline": "自然の中で、心が動き出す。",
        "script": "Find your freedom.",
        "banner_details": ["初夏の特別キャンペーン", "6.1 SAT - 6.30 SUN", "最大 20%OFF", "今だけの特別プラン多数！"]
      }
    },
    {
      "position": "bottom-right",
      "industry": "SaaS app",
      "visuals": "smartphone displaying a task management app interface with 4 schedule items",
      "brand": "{argument name=\"app brand name\" default=\"Taskme\"}",
      "copy": {
        "headline": "{argument name=\"app headline\" default=\"タスク管理を、もっとシンプルに、スマートに。\"}",
        "circle_badge": "1日を、デザインしよう。",
        "features_count": 3,
        "features_labels": ["直感的な操作性", "チームで共有可能", "どこでもアクセス"],
        "bottom_banner": "7日間無料トライアル実施中！"
      }
    }
  ]
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 151, '@kitune_fire45', 'https://x.com/kitune_fire45', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-151', '/images/case151.jpg', ', , Badge : , Description : ,', '["UI","Brand"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-150', 'A Bright, Summery Commercial Product Photography Shot Featuring', 'Template imported from awesome-gpt-image-2 case 150. Source: @highball_cho.', 'Products & E-commerce', 'A bright, summery commercial product photography shot featuring a refreshing beverage on a weathered wooden table. In the sharp foreground, there is 1 tall glass filled with a golden, bubbly iced drink garnished with 1 lemon slice and a sprig of rosemary, sitting next to 1 silver aluminum can covered in cold condensation. The can prominently displays the English text {argument name="product name" default="TOKYO HIGHBALL"} below a small gold star logo, featuring a graphic of the drink itself and the Japanese text "アルコール分 7%" near the bottom. To the right of the can, 2 cut lemon wedges rest on the table. In the softly blurred background, a sunny beach scene unfolds with sparkling turquoise water and a clear blue sky. Standing to the left in the background is 1 young woman with long brown hair, wearing a white sleeveless top and a light blue skirt, looking out toward the ocean. Floating elegantly in the sky above the scene is the Japanese text {argument name="catchphrase" default="夏、これがいい。"}. The overall lighting is radiant and inviting, with sparkling bokeh and lens flares emphasizing the crisp, cold, and refreshing atmosphere of a perfect summer day.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 150, '@highball_cho', 'https://x.com/highball_cho', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-150', '/images/case150.jpg', 'A Bright, Summery Commercial Product Photography Shot Featuring', '["Poster","Realistic","Product"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-149', ', Background : , Ui Layout : ,', 'Template imported from awesome-gpt-image-2 case 149. Source: @JCutcut47692.', 'UI & Interfaces', '{
  "type": "mobile livestream e-commerce interface mockup",
  "subject": {
    "person": "Elon Musk",
    "clothing": "black t-shirt with SPACEX logo",
    "pose": "gesturing towards camera with both hands, explaining enthusiastically",
    "watermark": "@Proof AI"
  },
  "background": {
    "setting": "large display screen",
    "image": "Mars landscape with Starship rocket and dome habitats",
    "text": [
      "SPACEX",
      "{argument name=\"background title\" default=\"移民火星计划\"}"
    ]
  },
  "ui_layout": {
    "header": {
      "broadcaster_info": {
        "name": "{argument name=\"broadcaster name\" default=\"ElonMusk\"}",
        "stats": "75.8万本场点赞",
        "follow_button": "关注"
      },
      "viewer_stats": {
        "avatars_count": 3,
        "text": "10万+",
        "close_button": "X"
      },
      "tags": [
        "带货总榜第1名",
        "更多直播 >"
      ]
    },
    "product_card": {
      "position": "mid-right",
      "status": "讲解中",
      "image": "Mars dome habitats",
      "title": "{argument name=\"product title\" default=\"火星移民基础套餐\"}",
      "price": "{argument name=\"product price\" default=\"¥99.00\"}",
      "action_button": "抢"
    },
    "chat_overlay": {
      "position": "bottom-left",
      "join_alert": "星辰大海 加入了直播间",
      "messages_count": 7,
      "messages": [
        "{argument name=\"top chat message\" default=\"梦想家: 支持马斯克！！🚀\"}",
        "火星弟弟: 多少钱一位？",
        "科技迷: 太酷了！想去火星！",
        "未来已来: 如何报名？",
        "小火箭: 🌹🌹🌹",
        "宇宙无敌: 讲解一下细节",
        "东方不败: 老马牛逼！👍👍👍"
      ]
    },
    "bottom_action_bar": {
      "input_placeholder": "说点什么...",
      "icons_count": 4,
      "icons": ["shopping cart", "gift box", "heart planet", "plus sign"]
    },
    "floating_reactions": {
      "position": "bottom-right",
      "elements": "stack of floating hearts, thumbs up, and laughing emojis"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 149, '@JCutcut47692', 'https://x.com/JCutcut47692', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-149', '/images/case149.jpg', ', Background : , Ui Layout : ,', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-148', 'A Product Detail Page for , Displaying: Front,', 'Template imported from awesome-gpt-image-2 case 148. Source: @alanlovelq.', 'UI & Interfaces', 'A {argument name="platform" default="Taobao"} product detail page for {argument name="robot model" default="T-800 robot"}, displaying: front, side, and back three-view drawings of the robot, product price, product details, functions, and usage scenarios, etc.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 148, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-148', '/images/case148.jpg', 'A Product Detail Page for , Displaying: Front,', '["Product"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-147', 'A Product Detail Page for , Displaying: Front,', 'Template imported from awesome-gpt-image-2 case 147. Source: @alanlovelq.', 'Photography & Realism', 'A {argument name="platform" default="Taobao"} product detail page for {argument name="robot model" default="T-800 robot"}, displaying: front, side, and back three-view drawings of the robot, product price, product details, functions, and usage scenarios, etc.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 147, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-147', '/images/case147.jpg', 'A Product Detail Page for , Displaying: Front,', '["Product"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-146', 'A Product Detail Page for , Displaying: Front,', 'Template imported from awesome-gpt-image-2 case 146. Source: @alanlovelq.', 'UI & Interfaces', 'A {argument name="platform" default="Taobao"} product detail page for {argument name="robot model" default="T-800 robot"}, displaying: front, side, and back three-view drawings of the robot, product price, product details, functions, and usage scenarios, etc.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 146, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-146', '/images/case146.jpg', 'A Product Detail Page for , Displaying: Front,', '["Product"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-145', 'A Product Detail Page for , Displaying: Front,', 'Template imported from awesome-gpt-image-2 case 145. Source: @alanlovelq.', 'UI & Interfaces', 'A {argument name="platform" default="Taobao"} product detail page for {argument name="robot model" default="T-800 robot"}, displaying: front, side, and back three-view drawings of the robot, product price, product details, functions, and usage scenarios, etc.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 145, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-145', '/images/case145.jpg', 'A Product Detail Page for , Displaying: Front,', '["Product"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-144', 'A Luxurious Cosmetic Product Advertisement Featuring a Single', 'Template imported from awesome-gpt-image-2 case 144. Source: @panchaaan_2.', 'Products & E-commerce', 'A luxurious cosmetic product advertisement featuring a single elegant glass jar with a shiny gold lid resting on a round, light-colored marble slab. The jar has gold text reading {argument name="brand name" default="LUMIÉRE"} and {argument name="product type" default="MOISTURE RICH CREAM"} with "AGING CARE*" below it. The background consists of soft, draped, shimmering champagne-colored silk fabric with delicate white flowers on the left. The lighting is warm, ethereal, and sun-drenched with soft bokeh. At the top center, elegant dark brown Japanese typography reads {argument name="main headline" default="肌に、静かな贅沢を。"} above a small decorative gold divider and the text {argument name="subheadline" default="高保湿×エイジングケア*"}. To the right of the jar, a thin gold circle contains Japanese text meaning ''With dense moisture, high-quality firmness and radiance''. At the bottom center is a dark rectangular call-to-action button with a thin gold border containing the text {argument name="button text" default="詳しく見る"} and a right-pointing chevron. In the bottom right corner, tiny fine print contains Japanese text meaning ''*Care according to age''.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 144, '@panchaaan_2', 'https://x.com/panchaaan_2', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-144', '/images/case144.jpg', 'A Luxurious Cosmetic Product Advertisement Featuring a Single', '["Poster","Product","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-143', 'A Photorealistic Amateur Photograph of a Custom Building', 'Template imported from awesome-gpt-image-2 case 143. Source: @Gc_qube.', 'Photography & Realism', 'A photorealistic amateur photograph of a custom building block set resting on a light wood grain table in a living room. In the background stands a large product box with a red logo reading "{argument name="brand name" default="BRICKLY"} BUILDING SETS". The box features text reading "8+", "540 PCS", "5 FIGURES", and the main large title "{argument name="set title" default="WATTERSON FAMILY HOUSE"}". A red circular badge on the box reads "CUSTOM SET FAN DESIGN", and the box art depicts the house and characters under a blue sky. In the foreground sits the fully assembled block model of a {argument name="house color" default="blue"} two-story suburban house with a brown roof, white porch, red steps, a white picket fence, and a blocky green tree. To the left of the house is a built block model of a {argument name="car color" default="pink"} station wagon. Standing in a row in front of the house are exactly 5 custom block minifigures: a blue cat in tan pants, an orange fish with legs, a tall pink rabbit in a white shirt and tie, a blue cat in a white shirt, and a small pink rabbit in an orange dress. The background is a slightly blurred living room with a grey sofa and white blinds.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 143, '@Gc_qube', 'https://x.com/Gc_qube', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-143', '/images/case143.jpg', 'A Photorealistic Amateur Photograph of a Custom Building', '["UI","Realistic","Product"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-142', ', Character : , Appearance : , Attire', 'Template imported from awesome-gpt-image-2 case 142. Source: @anemone_sd.', 'Products & E-commerce', '{
  "type": "anime idol merchandise catalog flyer",
  "theme_colors": "{argument name=\"theme color\" default=\"pastel blue and pink\"}",
  "character": {
    "name": "{argument name=\"character name\" default=\"ななし\"}",
    "appearance": "anime girl, long {argument name=\"hair color\" default=\"pink\"} hair, blue eyes",
    "attire": "{argument name=\"outfit\" default=\"black and white maid outfit with a red bow tie\"} and blue hair ribbons"
  },
  "layout": {
    "header": {
      "left": "upper body portrait of the character looking slightly to the side",
      "center": {
        "top_banner": "ななし 2nd EP リリース記念ライブ",
        "main_title": "{argument name=\"event title\" default=\"おしごと☆メイド奮闘中！\"}",
        "subtitle": "~ Oshigoto Maid Funtouchu! ~",
        "section_header": "OFFICIAL GOODS"
      },
      "right": "purchase bonus info box containing 3 small rectangular photo prints"
    },
    "merchandise_grid": [
      { "id": "01", "name": "アクリルスタンド", "description": "full body acrylic stand of the character" },
      { "id": "02", "name": "缶バッジ", "description": "set of 6 circular can badges featuring different facial expressions" },
      { "id": "03", "name": "ビッグタオル", "description": "large rectangular towel showing the character holding a heart pillow" },
      { "id": "04", "name": "Tシャツ", "description": "white t-shirt showing FRONT with character graphic and BACK with small logo" },
      { "id": "05", "name": "マフラータオル", "description": "long narrow muffler towel with character art and logo" },
      { "id": "06", "name": "トートバッグ", "description": "canvas tote bag with blue logo" },
      { "id": "07", "name": "アクリルキーホルダー", "description": "chibi character acrylic keychain with a star-shaped clasp" },
      { "id": "08", "name": "ラバーバンド", "description": "blue silicone wristband with logo" },
      { "id": "09", "name": "ステッカーセット", "description": "set of 4 visible stickers: chibi character, heart, ribbon bow, and logo" },
      { "id": "10", "name": "ペンライト", "description": "blue glowing concert penlight" }
    ],
    "footer": {
      "left": "purchase notes and guidelines box",
      "center": "character signature ''Nanashi'' with hand-drawn hearts and stars",
      "right": "payment methods box"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 142, '@anemone_sd', 'https://x.com/anemone_sd', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-142', '/images/case142.jpg', ', Character : , Appearance : , Attire', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-141', ', Character : , Product : , Layout', 'Template imported from awesome-gpt-image-2 case 141. Source: @takadtmnu.', 'Products & E-commerce', '{
  "type": "promotional banner design set",
  "theme": "strawberry advertisement campaign",
  "style": "anime illustration, bright, cheerful, commercial graphic design",
  "color_palette": "{argument name=\"primary color theme\" default=\"pastel pink and vibrant red\"}",
  "character": "{argument name=\"character description\" default=\"anime girl with brown side ponytail and bunny ears, wearing a pastel blue and pink jacket\"}",
  "product": "{argument name=\"product\" default=\"fresh red strawberries\"}",
  "layout": {
    "sections": [
      {
        "type": "large landscape banner",
        "position": "top left",
        "visuals": "character winking and holding a strawberry next to a large basket of strawberries",
        "main_text": "{argument name=\"main headline\" default=\"いちごたっぷり\"}",
        "sub_text": ["笑顔あふれる、甘〜いひととき♪", "とびきりおいしい！", "ひと粒で、しあわせ広がる♡", "あまっ♡", "旬のおいしさをお届け！"],
        "badges": {
          "count": 3,
          "labels": ["あま〜くてジューシー！", "いろんなサイズを楽しめる♪", "新鮮朝採れ！"]
        }
      },
      {
        "type": "vertical banner",
        "position": "right",
        "visuals": "character eating a strawberry with a pile of strawberries below",
        "main_text": "いちごたっぷり",
        "sub_text": ["旬のいちごをお届け！", "{argument name=\"secondary headline\" default=\"あま〜くて、ジューシー！\"}", "とろけるおいしさ〜♡"],
        "badges": {
          "count": 3,
          "labels": ["朝採れ新鮮！", "いろんなサイズを楽しめる♪", "甘くてジューシー！"]
        }
      },
      {
        "type": "wide horizontal banner",
        "position": "middle",
        "visuals": "character with closed eyes eating a strawberry, flanked by strawberries",
        "main_text": "いちごたっぷり！",
        "sub_text": ["あまくて、ジューシーな幸せ♡", "旬の美味しさをお届けします！", "おいし〜っ♡"]
      },
      {
        "type": "small square banner",
        "position": "bottom left",
        "visuals": "character smiling holding strawberry",
        "text": ["いちごたっぷり", "あま〜くてジューシー！"]
      },
      {
        "type": "small square banner",
        "position": "bottom mid-left",
        "visuals": "pile of strawberries with one cut in half",
        "text": ["旬のいちご！", "あまくてとろけるおいしさ♡"]
      },
      {
        "type": "small horizontal banner",
        "position": "bottom mid-right",
        "visuals": "character holding strawberry",
        "text": ["いちごたっぷり", "朝採れ新鮮！", "あまくてジューシー！"]
      },
      {
        "type": "circular icons",
        "position": "bottom right",
        "count": 4,
        "items": [
          { "visual": "basket of strawberries", "label": "朝採れ新鮮！" },
          { "visual": "half strawberry", "label": "あまくてジューシー！" },
          { "visual": "whole strawberry", "label": "いろんなサイズ！" },
          { "visual": "character face", "label": "とろけるおいしさ♡" }
        ]
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 141, '@takadtmnu', 'https://x.com/takadtmnu', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-141', '/images/case141.jpg', ', Character : , Product : , Layout', '["Illustration","Product","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-140', ''', Subtitle '' Seifucha'', and Vertical Text ''''', 'Template imported from awesome-gpt-image-2 case 140. Source: @AutoIntelliMode.', 'Posters & Typography', '{"type": "promotional advertisement poster for a bottled green tea beverage", "product": {"type": "clear plastic PET bottle filled with yellow-green tea", "label": "white label with green typography, featuring the product name ''{argument name=\"product name\" default=\"清風茶\"}'', subtitle ''緑茶 Seifucha'', and vertical text ''国産茶葉使用'' and ''香り豊か、後味さわやか''"}, "background": "bright, fresh, sunlit outdoor atmosphere with dynamic water splashes wrapping around the bottle and vibrant green tea leaves", "layout": {"sections": [{"title": "headline", "position": "top-left", "text": "{argument name=\"main headline\" default=\"新発売\"}", "style": "large red text with a gold underline and a small green leaf accent"}, {"title": "catchphrase", "position": "mid-left", "text": "{argument name=\"catchphrase\" default=\"毎日に、すっきり。\"}", "style": "dark green text"}, {"title": "features", "position": "lower-left", "count": 2, "labels": ["国産茶葉使用", "香り豊か、後味さわやか"], "style": "white pill-shaped banners with green leaf icons"}, {"title": "price_badge", "position": "top-right", "text": "今だけ!! 特別価格 {argument name=\"price\" default=\"128円\"} (税込)", "style": "red circular sticker with white and yellow text"}, {"title": "promo_banner", "position": "bottom-left", "text": "期間限定のお得価格!", "style": "angled red ribbon with yellow and white text"}, {"title": "footer", "position": "bottom-edge", "text": "{argument name=\"footer text\" default=\"全国のコンビニ・スーパーで発売中\"}", "style": "solid green horizontal bar with a white shopping cart icon"}]}}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 140, '@AutoIntelliMode', 'https://x.com/AutoIntelliMode', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-140', '/images/case140.jpg', ''', Subtitle '' Seifucha'', and Vertical Text ''''', '["Poster","Product"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-139', ', Middle Section : , Bonus Section :', 'Template imported from awesome-gpt-image-2 case 139. Source: @nakazakifam.', 'Posters & Typography', '{
  "type": "Japanese promotional landing page poster",
  "style": "hyper-energetic, explosive typography, vibrant colors, amusement park night festival aesthetic",
  "layout": {
    "top_section": {
      "background": "night sky, fireworks, ferris wheel, roller coaster",
      "subjects": "4 young adults cheering, raising fists, dynamic lighting",
      "typography": [
        "{argument name=\"main headline\" default=\"究極の楽しい!!\"}",
        "{argument name=\"sub headline\" default=\"やばい!!共感してもらいたい!!\"}",
        "この一枚が、あなたの人生を最高に塗り替える!!"
      ],
      "badges": [
        "累計販売枚数 {argument name=\"sales badge\" default=\"252,000\"} 枚突破!!!"
      ]
    },
    "middle_section": {
      "title": "究極の楽しい体験を実現する5つの超快楽ポイント",
      "points_count": 5,
      "points": [
        {"number": 1, "label": "爆笑覚醒", "image": "people laughing"},
        {"number": 2, "label": "ドキドキMAX", "image": "roller coaster loop"},
        {"number": 3, "label": "感動の渦", "image": "fireworks explosion"},
        {"number": 4, "label": "超解放ゾーン", "image": "silhouettes jumping at sunset"},
        {"number": 5, "label": "無限リピート", "image": "group of people cheering"}
      ]
    },
    "bonus_section": {
      "title": "今だけ！超豪華 5大特典付き!!!",
      "items_count": 5,
      "items": [
        "① 限定デザインポスター",
        "② 楽しい名言ブックレット(PDF)",
        "③ 超楽しいプレイリスト(MP3)",
        "④ スマホ壁紙セット",
        "⑤ 楽しいシークレット映像"
      ]
    },
    "bottom_section": {
      "product_info": {
        "name": "究極の楽しいポスター",
        "variants_count": 3,
        "variants": ["全力全開ver.", "笑顔爆発ver.", "感動絶頂ver."]
      },
      "pricing": {
        "label": "魂の価格",
        "amount": "{argument name=\"price\" default=\"¥2,980\"}",
        "shipping": "送料無料"
      }
    },
    "footer": {
      "text": "{argument name=\"footer call to action\" default=\"人生を最高に楽しみ尽くせ!! さぁ、今すぐ手に入れろ!!\"}",
      "background_color": "magenta"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 139, '@nakazakifam', 'https://x.com/nakazakifam', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-139', '/images/case139.jpg', ', Middle Section : , Bonus Section :', '["Poster","Product"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-138', ', Layout : , , Subtitle : ,', 'Template imported from awesome-gpt-image-2 case 138. Source: @aiehon_aya.', 'Brand & Logos', '{
  "type": "fashion product catalog layout",
  "theme": "A cohesive fashion collection featuring a specific pattern: {argument name=\"pattern description\" default=\"overlapping circular floral mandala motifs in purple, green, blue, orange, and pink\"}",
  "layout": {
    "structure": "2x2 grid with a full-width bottom banner",
    "sections": [
      {
        "id": "01",
        "title": "{argument name=\"product 1\" default=\"Flared Dress\"}",
        "subtitle": "フレアワンピース",
        "main_image": "Woman in patterned flared dress holding white handbag.",
        "swatch_count": 3,
        "swatch_descriptions": ["purple variant", "green/blue variant", "orange/yellow variant"],
        "description_text": "華やかなフレアシルエット。軽やかな素材が優雅な動きを演出します。"
      },
      {
        "id": "02",
        "title": "{argument name=\"product 2\" default=\"Silk Scarf\"}",
        "subtitle": "シルクスカーフ",
        "main_image": "Woman in white blouse with patterned silk scarf.",
        "swatch_count": 2,
        "swatch_descriptions": ["flat pattern detail", "tied knot detail"],
        "description_text": "首元に彩りを添えるシルクスカーフ。上品な光沢と滑らかな肌ざわり。"
      },
      {
        "id": "03",
        "title": "{argument name=\"product 3\" default=\"Tote Bag\"}",
        "subtitle": "トートバッグ",
        "main_image": "Woman carrying patterned tote bag.",
        "swatch_count": 3,
        "swatch_descriptions": ["purple variant", "blue variant", "orange/yellow variant"],
        "description_text": "A4サイズも入る収納力。軽くて丈夫、毎日使いたくなるトートバッグ。"
      },
      {
        "id": "04",
        "title": "{argument name=\"product 4\" default=\"Pouch\"}",
        "subtitle": "ポーチ",
        "main_image": "Patterned zip pouch on table with magazine and vase.",
        "swatch_count": 3,
        "swatch_descriptions": ["green/purple variant", "orange variant", "pink variant"],
        "description_text": "バッグの中を彩る華やかなポーチ。細部まで美しいデザインが魅力です。"
      }
    ],
    "bottom_banner": {
      "title": "Pattern Design",
      "description_text": "細やかな線と豊かな色彩が織りなす、唯一無二のパターンデザイン。日常に優雅な彩りを。",
      "image": "Horizontal strip showing the seamless pattern."
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 138, '@aiehon_aya', 'https://x.com/aiehon_aya', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-138', '/images/case138.jpg', ', Layout : , , Subtitle : ,', '["Poster","Product"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-137', 'And White Color Palette, Soft Lighting , Header', 'Template imported from awesome-gpt-image-2 case 137. Source: @ryuya__31.', 'Brand & Logos', '{
  "type": "e-commerce landing page hero section mockup",
  "aesthetic": "clean, bright, airy, feminine, floral accents with purple flowers, {argument name=\"primary color\" default=\"soft pink\"} and white color palette, soft lighting",
  "header": {
    "logo": "{argument name=\"brand name\" default=\"LUMEA BEAUTY\"}",
    "navigation_links": {
      "count": 5,
      "labels": ["特徴", "成分", "お客様の声", "使い方", "FAQ"]
    },
    "cta_button": "今すぐ試す"
  },
  "hero_section": {
    "left_column": {
      "headline": "{argument name=\"headline text\" default=\"鏡を見るたび、うるおう透明感。\"}",
      "subheadline": "乾燥・くすみが気になる肌に。美容成分を贅沢に配合した、毎日のための集中保湿美容液。",
      "feature_badges": {
        "count": 3,
        "style": "pill-shaped with small icons",
        "labels": ["敏感肌OK", "高保湿", "朝晩使える"]
      },
      "bullet_points": {
        "count": 3,
        "style": "pink checkmarks",
        "labels": ["美容成分をしっかり届ける", "ハリ・ツヤのある印象へ", "続けやすいシンプルケア"]
      },
      "cta_buttons": {
        "count": 2,
        "labels": ["初回限定で試してみる >", "成分をチェック >"]
      },
      "trust_badges": "送料無料 / 初回限定 / 定期縛りなし"
    },
    "center_subject": {
      "model": "{argument name=\"model description\" default=\"young East Asian woman smiling, touching her cheek\"}",
      "action": "holding a dropper bottle of serum"
    },
    "right_column": {
      "product_display": {
        "count": 2,
        "items": ["{argument name=\"product type\" default=\"moisturizing boost serum\"} dropper bottle", "packaging box"]
      },
      "stat_cards": {
        "count": 3,
        "style": "floating white rounded rectangles with gold accents",
        "labels": ["満足度 96%", "美容成分 5種配合", "愛用者 12,000人突破"]
      }
    }
  },
  "bottom_section": {
    "benefit_cards": {
      "count": 3,
      "style": "horizontal white rounded rectangles with icons",
      "labels": ["うるおい", "透明感", "使いやすさ"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 137, '@ryuya__31', 'https://x.com/ryuya__31', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-137', '/images/case137.jpg', 'And White Color Palette, Soft Lighting , Header', '["UI","Product","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-136', ', Theme : , Color Palette : ,', 'Template imported from awesome-gpt-image-2 case 136. Source: @ryuya__31.', 'Brand & Logos', '{
  "type": "e-commerce landing page hero section",
  "brand": "{argument name=\"brand name\" default=\"CLEAR RESET\"}",
  "theme": "refreshing skincare, clean aesthetic, water bubbles background",
  "color_palette": ["white", "{argument name=\"primary color\" default=\"teal\"}", "light blue"],
  "layout": {
    "header": {
      "logo": "CLEAR RESET",
      "navigation_links": {"count": 5, "labels": ["About Product", "About Pores/Acne", "Ingredients", "How to Use", "FAQ"]},
      "action_buttons": {"count": 2, "labels": ["Buy Now", "My Page"]}
    },
    "hero_content": {
      "headline": "{argument name=\"main headline\" default=\"毛穴・ニキビ悩みに、すっきり澄んだ肌へ。\"}",
      "subheadline": "Balances sebum and clears pores. Non-sticky, medicated skincare for comfortable daily use.",
      "vertical_copy": "Prevents recurring rough skin and acne, leading to smooth, clear skin."
    },
    "visuals": {
      "model": "{argument name=\"model description\" default=\"young Asian woman with clear radiant skin, hair tied up, smiling softly\"}",
      "products": {
        "count": 2,
        "description": "{argument name=\"product type\" default=\"acne care gel tube and lotion bottle\"}",
        "placement": "center"
      },
      "background": "light blue gradient with floating water bubbles"
    },
    "feature_highlights": {
      "count": 4,
      "style": "circular icons with text below",
      "labels": ["Quasi-drug", "Pore Care", "Non-sticky", "Daily Use Morning/Night OK"]
    },
    "call_to_action": {
      "banner_text": "Limited to first-time buyers",
      "buttons": {"count": 2, "labels": ["Try it at a discount", "See details"]}
    },
    "statistics_cards": {
      "count": 4,
      "style": "white rectangular cards with large teal numbers",
      "labels": ["Satisfaction 92%", "Pore visibility -23%", "Acne prevention 87%", "Want to repeat 97%"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 136, '@ryuya__31', 'https://x.com/ryuya__31', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-136', '/images/case136.jpg', ', Theme : , Color Palette : ,', '["Product","Brand"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-135', ', White Text, Subtle Blue Gradients , Header', 'Template imported from awesome-gpt-image-2 case 135. Source: @ryuya__31.', 'Brand & Logos', '{
  "type": "website landing page mockup",
  "theme": "men''s skincare, sleek, professional, dark mode",
  "color_palette": "{argument name=\"color scheme\" default=\"dark navy blue\"}, white text, subtle blue gradients",
  "header": {
    "logo": "{argument name=\"brand name\" default=\"NEX SKIN\"}",
    "navigation": ["HOME", "PRODUCT", "ABOUT", "FEATURE", "FAQ"],
    "cta_button": "今すぐ始める >"
  },
  "hero_section": {
    "left_column": {
      "headline": "{argument name=\"main headline\" default=\"清潔感は、毎日のスキンケアから。\"}",
      "sub_headline": "男の肌は、もっとシンプルでいい。",
      "body_text": "3 lines of descriptive text about skincare benefits",
      "buttons": [
        {"style": "solid blue", "text": "今すぐ始める >"},
        {"style": "outlined", "text": "詳しく見る >"}
      ],
      "feature_highlights": {
        "count": 3,
        "items": [
          {"icon": "sparkle", "title": "テカリ対策", "subtitle": "皮脂バランスを整える"},
          {"icon": "water drop", "title": "保湿", "subtitle": "うるおいを与え続ける"},
          {"icon": "shield/bottle", "title": "オールインワン", "subtitle": "化粧水・美容液・乳液がこれ1本"}
        ]
      }
    },
    "center_image": {
      "subject": "handsome {argument name=\"target demographic\" default=\"young Asian man\"}",
      "appearance": "clean-cut, dark hair, flawless glowing skin, wearing a black shirt",
      "pose": "hand touching chin thoughtfully",
      "lighting": "dramatic studio lighting highlighting facial structure"
    },
    "right_column": {
      "product_shot": {
        "bottle": "tall cylindrical dark blue bottle with water droplets",
        "labels": ["{argument name=\"brand name\" default=\"NEX SKIN\"}", "{argument name=\"product type\" default=\"ALL-IN-ONE LOTION\"}", "150mL"],
        "base": "textured dark rock surface",
        "badge": "circular outlined badge reading ''これ1本で男の肌悩みをトータルケア''"
      }
    }
  },
  "bottom_stats_bar": {
    "count": 3,
    "items": [
      {"icon": "users", "label": "累計販売本数", "value": "120万本突破"},
      {"icon": "star", "label": "使用感満足度", "value": "92.1%"},
      {"icon": "checklist", "label": "リピート率", "value": "85.3%"}
    ],
    "footnotes": "small legal text on the right"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 135, '@ryuya__31', 'https://x.com/ryuya__31', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-135', '/images/case135.jpg', ', White Text, Subtle Blue Gradients , Header', '["UI","Product","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-134', ', Color Palette : , Layout : ,', 'Template imported from awesome-gpt-image-2 case 134. Source: @ryuya__31.', 'Brand & Logos', '{
  "type": "skincare e-commerce landing page mockup",
  "brand": "{argument name=\"brand name\" default=\"DERMA CALM\"}",
  "color_palette": ["white", "light blue", "{argument name=\"primary color\" default=\"dark blue\"}"],
  "layout": {
    "header": {
      "logo": "left-aligned brand name with Japanese subtext",
      "navigation_links": {
        "count": 6,
        "labels": ["ABOUT", "PRODUCT", "FEATURE", "INGREDIENT", "VOICE", "Q&A"]
      },
      "buttons": {
        "count": 2,
        "labels": ["マイページ", "今すぐ購入する"]
      }
    },
    "hero_section": {
      "left_column": {
        "headline": "{argument name=\"hero headline\" default=\"敏感な肌にも、毎日つづけられる安心ケア。\"}",
        "subtext": "paragraph detailing low irritation, moisturizing, fragrance-free, and alcohol-free benefits",
        "buttons": {
          "count": 2,
          "labels": ["今すぐ購入する", "詳しく見る"]
        }
      },
      "center_column": {
        "product": "white pump bottle with clear cap labeled {argument name=\"product type\" default=\"Moisture Barrier Serum\"}",
        "props": ["dollop of white cream", "circular badge reading 皮膚科医監修"]
      },
      "right_column": {
        "subject": "{argument name=\"model description\" default=\"young East Asian woman with clear glowing skin touching her cheek\"}",
        "background": "blurred laboratory glassware in a bright, clean clinical setting"
      }
    },
    "bottom_features_panel": {
      "left_cards": {
        "count": 3,
        "descriptions": ["95% satisfaction with 5 stars", "shield icon for low irritation formula", "drop icon for skin barrier support"]
      },
      "right_badges": {
        "count": 3,
        "descriptions": ["no fragrance icon", "no alcohol icon", "patch tested icon"]
      },
      "footer": "fine print disclaimers at the bottom"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 134, '@ryuya__31', 'https://x.com/ryuya__31', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-134', '/images/case134.jpg', ', Color Palette : , Layout : ,', '["UI","Product","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-133', ', Main Logo : , Subtitle : ,', 'Template imported from awesome-gpt-image-2 case 133. Source: @yyyole.', 'UI & Interfaces', '{
  "type": "brand identity system presentation board",
  "header": {
    "title": "品牌视觉识别系统 BRAND IDENTITY SYSTEM",
    "slogan": "爱它·懂它·陪伴它"
  },
  "main_logo": {
    "text": "{argument name=\"brand name\" default=\"GDX\"}",
    "subtitle": "{argument name=\"brand chinese name\" default=\"狗东西\"}",
    "design_feature": "{argument name=\"main subject\" default=\"Dog profile in negative space of the letter D\"}",
    "metadata": [
      "品牌名称",
      "行业属性 {argument name=\"industry\" default=\"宠物行业\"}",
      "设计时间 2024.05"
    ]
  },
  "layout": {
    "sections": [
      {
        "title": "设计网格",
        "count": 1,
        "description": "Logo with architectural grid lines and golden ratio measurements"
      },
      {
        "title": "概念草图",
        "count": 4,
        "description": "Evolution steps from rough dog sketch to final geometric logo"
      },
      {
        "title": "灵感来源",
        "count": 4,
        "description": "Moodboard images including minimalist architecture, a golden retriever, and dark green geometric shapes"
      },
      {
        "title": "创意理念",
        "count": 4,
        "description": "Text blocks with minimalist icons explaining design philosophy, positioning, color psychology, and scalability"
      },
      {
        "title": "品牌应用",
        "count": 6,
        "labels": [
          "名片 正反面",
          "信纸信封",
          "APP图标",
          "网站页眉 / 网站图标",
          "产品包装 / 购物袋",
          "店面门头 / 标识牌"
        ],
        "description": "Mockups of business cards, envelopes, app icons, website header with a dog, paper shopping bags, and a storefront sign"
      },
      {
        "title": "色彩规范",
        "count": 5,
        "labels": [
          "主色",
          "辅助色",
          "强调色"
        ],
        "colors": [
          "{argument name=\"primary color\" default=\"#1E3D34\"}",
          "#F5F3EF",
          "#E5E2DD",
          "#A8C5B1",
          "#E0A86E"
        ]
      },
      {
        "title": "字体规范",
        "count": 2,
        "labels": [
          "思源黑体 CN",
          "思源柔黑体 CN"
        ],
        "description": "Typography specimens showing ''Aa'', alphabet, and numbers"
      },
      {
        "title": "最小使用尺寸",
        "count": 2,
        "description": "Minimum logo size specifications at 20mm and 12mm"
      },
      {
        "title": "安全留白区域",
        "count": 1,
        "description": "Logo surrounded by a bounding box with ''X'' indicating clear space margins"
      },
      {
        "title": "错误使用示例",
        "count": 5,
        "labels": [
          "不可拉伸变形",
          "不可改变颜色",
          "不可添加阴影",
          "不可倾斜使用",
          "不可复杂背景上使用"
        ],
        "description": "Examples of incorrect logo usage: stretched, wrong color, drop shadow, tilted, and placed on a busy photographic background"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 133, '@yyyole', 'https://x.com/yyyole', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-133', '/images/case133.jpg', ', Main Logo : , Subtitle : ,', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-132', ', Industry : , Colors : , Subject', 'Template imported from awesome-gpt-image-2 case 132. Source: @Colin_Leeee.', 'Brand & Logos', '{
  "type": "18-panel brand identity and character design document",
  "brand": {
    "name": "{argument name=\"brand name\" default=\"沐阳 MUYANG TEA\"}",
    "industry": "{argument name=\"industry\" default=\"tea shop\"}",
    "colors": ["{argument name=\"primary color\" default=\"yellow\"}", "{argument name=\"secondary color\" default=\"green\"}", "white", "brown", "dark green"]
  },
  "subject": "{argument name=\"character description\" default=\"3D rendered cute Shiba Inu mascot wearing a green apron\"}",
  "layout": {
    "grid": "3 columns by 6 rows",
    "sections": [
      {
        "title": "01 品牌DNA分析 / BRAND DNA ANALYSIS",
        "elements": ["logo", "5 color swatches", "6 icons", "target audience charts"]
      },
      {
        "title": "02 概念构思 / CONCEPT MOODBOARD",
        "elements": ["5 photo references", "4 mood icons", "design equation"]
      },
      {
        "title": "03 形态研究 / FORM STUDY",
        "elements": ["4 logo anatomy icons", "4 evolution steps", "4 silhouettes"]
      },
      {
        "title": "04 概念探索 / CONCEPT EXPLORATION",
        "elements": ["12 line-art character sketches"]
      },
      {
        "title": "05 精细线稿 / REFINED LINE ART",
        "elements": ["3 rows of front and side line art with proportion guides"]
      },
      {
        "title": "06 细节精修 / DETAIL REFINEMENT",
        "elements": ["2 full-body renders with labels", "4 circular close-ups"]
      },
      {
        "title": "07 表情设定 / EXPRESSION SHEET",
        "elements": ["11 3D rendered head expressions"]
      },
      {
        "title": "08 姿势库 / POSE LIBRARY",
        "elements": ["9 full-body 3D rendered poses"]
      },
      {
        "title": "09 转身视图 / TURNAROUND VIEW",
        "elements": ["5 full-body 3D renders", "5 matching line-art views"]
      },
      {
        "title": "10 色彩开发 / COLOR DEVELOPMENT",
        "elements": ["5 rows of 5-color palettes", "color psychology text"]
      },
      {
        "title": "11 材质规格 / MATERIAL SPECIFICATION",
        "elements": ["5 texture swatches", "property sliders", "4 manufacturing icons"]
      },
      {
        "title": "12 色彩应用 / COLOR APPLICATION",
        "elements": ["4 color variant renders", "2 light/dark renders", "4 contrast rating circles"]
      },
      {
        "title": "13 构造指南 / CONSTRUCTION GUIDE",
        "elements": ["2 line-art diagrams for geometry and grid"]
      },
      {
        "title": "14 设计系统规则 / DESIGN SYSTEM RULES",
        "elements": ["minimum size icons", "clear space diagram", "4 usage examples"]
      },
      {
        "title": "15 资产变体 / ASSET VARIANTS",
        "elements": ["3 size variants", "3 line-art variants", "3 simplified flat heads"]
      },
      {
        "title": "16 数字应用 / DIGITAL APPLICATIONS",
        "elements": ["1 app icon", "2 social avatars", "UI elements", "3-step animation cycle"]
      },
      {
        "title": "17 实物应用 / PHYSICAL APPLICATIONS",
        "elements": ["plush toy mockup", "packaging mockup", "merchandise mockup", "storefront mockup"]
      },
      {
        "title": "18 最终主视觉 / FINAL RENDERING",
        "elements": ["large high-res 3D render of mascot holding tea", "logo", "file format list"]
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 132, '@Colin_Leeee', 'https://x.com/Colin_Leeee', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-132', '/images/case132.jpg', ', Industry : , Colors : , Subject', '["UI","Infographic","Realistic"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-131', 'Glowing Accents , Header : , Top Right', 'Template imported from awesome-gpt-image-2 case 131. Source: @IndieDevHailey.', 'UI & Interfaces', '{
  "type": "UI/UX landing page mockup",
  "theme": "dark mode, sleek modern aesthetic, glassmorphism, {argument name=\"primary accent color\" default=\"neon purple and blue\"} glowing accents",
  "header": {
    "logo": "{argument name=\"brand name\" default=\"goViralX\"}",
    "top_right_tag": "VIRAL CAMPAIGN CASE STUDY"
  },
  "layout": {
    "sections": [
      {
        "name": "Hero",
        "headline": "{argument name=\"hero headline\" default=\"How We Created 10M+ Viral Impact\"}",
        "subheadline": "3天引爆全网, 助力品牌实现指数级增长",
        "stats_row": {
          "count": 4,
          "labels": ["总播放量", "互动率", "转化咨询", "执行周期"],
          "values": ["{argument name=\"main statistic\" default=\"10,240,000+\"}", "18.7%", "3,200+", "72小时"]
        },
        "visual": "cinematic shot of a person in a hoodie looking at glowing digital screens and graphs, large play button overlay"
      },
      {
        "name": "Strategy",
        "title": "Our 3-Day Execution Strategy",
        "layout_type": "vertical timeline",
        "steps_count": 3,
        "elements_per_step": ["timeline node", "title", "bullet points", "video thumbnail with play button", "description box"]
      },
      {
        "name": "Performance",
        "title": "Data-Driven Performance",
        "left_column": {
          "stat_cards_count": 4,
          "values": ["10M+", "43%", "28,000+", "3,200+"]
        },
        "right_column": {
          "charts_count": 2,
          "chart_1": "line graph showing 7-day growth peaking at Day 3",
          "chart_2": "horizontal segmented bar chart showing platform distribution (TikTok 52%, Instagram 24%, X 15%, YouTube 9%)"
        }
      },
      {
        "name": "Keys to Success",
        "title": "The 3 Keys to Viral Success",
        "cards_count": 3,
        "card_elements": ["glowing icon (fire, target, antenna)", "title", "description", "VIEW DETAIL link"]
      },
      {
        "name": "Social Proof",
        "title": "TRUSTED BY CREATORS & BRANDS",
        "left_column": {
          "logos_count": 8,
          "grid": "2x4",
          "brands": ["SHEIN", "SHOPLINE", "Blueglass", "instacart", "lemon8", "mi", "CIDER", "bellroy"]
        },
        "right_column": {
          "testimonial_cards_count": 2,
          "elements": ["quote", "author title (SaaS Founder, Growth Manager)"]
        }
      },
      {
        "name": "Call to Action",
        "title": "READY TO GO VIRAL?",
        "interactive_elements": ["text input field", "glowing button with text ''{argument name=\"call to action text\" default=\"获取专属增长方案 ->\"}''"],
        "visual": "3D render of a rocket ship taking off with purple and blue flames"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 131, '@IndieDevHailey', 'https://x.com/IndieDevHailey', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-131', '/images/case131.jpg', 'Glowing Accents , Header : , Top Right', '["UI","Brand","3D"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-130', 'And White , Motif : and Pink Hearts', 'Template imported from awesome-gpt-image-2 case 130. Source: @chi_vc_.', 'Brand & Logos', '{
  "type": "brand identity and merchandise design board",
  "theme": {
    "color_palette": "{argument name=\"theme color\" default=\"pastel pink\"} and white",
    "motif": "{argument name=\"motif\" default=\"cherry blossoms\"} and pink hearts"
  },
  "character": {
    "description": "anime girl with short brown bob hair, pink eyes, wearing a white hoodie, gentle smile"
  },
  "branding": {
    "main_logo": "{argument name=\"character name\" default=\"癒音ちー\"}",
    "sub_logo": "{argument name=\"character subtext\" default=\"ゆおんちー\"}"
  },
  "layout": {
    "sections": [
      {
        "type": "header banner",
        "position": "top",
        "elements": ["large main logo", "sub logo", "cherry blossom graphics", "character portrait on the right"]
      },
      {
        "type": "product packaging",
        "position": "middle left",
        "elements": ["1 square box with heart-shaped transparent window showing pink heart candies", "character illustration on box", "2 individual candy wrappers", "5 scattered heart candies"]
      },
      {
        "type": "promotional poster",
        "position": "middle right",
        "elements": ["character portrait", "heart-shaped candy bowl", "main logo", "text ''4.26 NEW OPEN''", "text ''{argument name=\"social handle\" default=\"@yuonchii\"}''"]
      },
      {
        "type": "horizontal web banner",
        "position": "lower middle",
        "elements": ["main logo", "cherry blossoms", "character portrait on the right"]
      },
      {
        "type": "social media profile mockup",
        "position": "bottom left",
        "elements": ["header image with logo", "1 circular profile picture", "handle ''{argument name=\"social handle\" default=\"@yuonchii\"}''", "1 follow button", "mock bio text"]
      },
      {
        "type": "merchandise collection",
        "position": "bottom right",
        "count": 9,
        "items": ["1 white t-shirt with logo", "1 white mug with character", "4 round pin badges", "1 acrylic keychain", "2 candy packets"]
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 130, '@chi_vc_', 'https://x.com/chi_vc_', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-130', '/images/case130.jpg', 'And White , Motif : and Pink Hearts', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-129', 'A Watercolor Illustration of a Children''s Picture Book', 'Template imported from awesome-gpt-image-2 case 129. Source: @TlanoVRC.', 'Illustration & Art', 'A watercolor illustration of a children''s picture book cover. The main subject is a {argument name="character appearance" default="cute furry kemonomimi girl with short green hair, cat ears, and green eyes"}. She is {argument name="action" default="smiling happily while holding up her middle finger"} with a white-furred hand. She wears a green garment with a fluffy white collar. The background features soft, painted green foliage and small yellow flowers on textured paper. At the top, large hand-drawn green Japanese text reads "{argument name="main title" default="なかゆびさん"}". Below it, brown Japanese text reads "{argument name="subtitle" default="こんにちは"}". On the middle-left, smaller black text reads "{argument name="author text" default="さく・え：とらの"}". The image has a visible book spine on the left edge, emphasizing the physical book format.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 129, '@TlanoVRC', 'https://x.com/TlanoVRC', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-129', '/images/case129.png', 'A Watercolor Illustration of a Children''s Picture Book', '["Poster","Illustration","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-128', ', Layout : , Building Sign : ,', 'Template imported from awesome-gpt-image-2 case 128. Source: @masapark95.', 'Posters & Typography', '{
  "type": "anime-style animated movie poster",
  "scene": "Magical glowing multi-story treehouse restaurant in a dark enchanted forest at night, illuminated by string lights and warm window glow.",
  "subjects": {
    "children": "2 children in center foreground facing the restaurant: a boy with a backpack and lantern, and a girl in a red coat and beret with a lantern.",
    "animals": "4 anthropomorphic animals: a bear chef holding a MENU book (bottom left), an owl playing violin and a squirrel playing flute on a branch (top left), a badger playing cello (mid right), and a rabbit in a suit holding a sign (bottom right).",
    "creatures": "3 small black soot-sprite-like creatures with glowing eyes (bottom right).",
    "floating_food": "4 glowing food items floating in the air: soup, pancakes, omurice, and a fruit parfait."
  },
  "layout": {
    "top_text": "{argument name=\"top catchphrase\" default=\"おいしい奇跡が、今夜はじまる。\"}",
    "building_sign": "{argument name=\"restaurant name\" default=\"森のレストラン\"}",
    "left_board": "本日のおすすめ\n・森のスープ\n・星のオムライス\n・ふわふわパンケーキ\n・しあわせのパフェ\n...and more!",
    "right_board": "いらっしゃいませ！\nここは、だれでも\n笑顔になれる場所。",
    "main_title": {
      "text": "{argument name=\"movie title\" default=\"ふしぎな森のレストラン\"}",
      "styling": "Large stylized typography with a chef hat, fork, and spoon motifs."
    },
    "rabbit_sign": "ごちそうさま！またきてね！",
    "bottom_left_badge": "{argument name=\"genre badge\" default=\"家族みんなで楽しめる！心あたたまる冒険ファンタジー\"}",
    "bottom_center_credits": "Fictional cast and staff names in Japanese.",
    "bottom_release_date": "{argument name=\"release date\" default=\"2025年 夏休みロードショー！\"}",
    "bottom_right": "QR code with text ''最新情報はこちら！''"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 128, '@masapark95', 'https://x.com/masapark95', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-128', '/images/case128.jpg', ', Layout : , Building Sign : ,', '["UI","Poster"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-127', 'Hair, Purple Eyes , Outfit : , Delivery', 'Template imported from awesome-gpt-image-2 case 127. Source: @studiomasakaki.', 'Illustration & Art', '{
  "type": "manga page",
  "style": "anime illustration, full color",
  "characters": {
    "woman": {
      "appearance": "long {argument name=\"hair color\" default=\"black\"} hair, purple eyes",
      "outfit": "{argument name=\"shirt color\" default=\"grey\"} long-sleeve shirt, dark grey skinny jeans, barefoot"
    },
    "delivery_man": {
      "appearance": "bald, older man, thick eyebrows",
      "outfit": "blue work jacket over a grey shirt"
    }
  },
  "layout": {
    "description": "Page split vertically. Left side contains 4 stacked horizontal panels. Right side is a single tall vertical panel.",
    "left_column_panels": [
      {
        "panel_number": 1,
        "scene": "Woman sitting on a grey sofa in a living room, holding a white mug.",
        "text_elements": [
          { "type": "speech_bubble", "text": "?" },
          { "type": "sound_effect", "text": "ピンポーン♪", "description": "doorbell ringing" }
        ]
      },
      {
        "panel_number": 2,
        "scene": "Woman opening the front door. Delivery man standing outside holding a cardboard box, smiling.",
        "text_elements": [
          { "type": "speech_bubble", "speaker": "delivery_man", "text": "{argument name=\"delivery greeting\" default=\"こんにちは〜！宅配便で〜す！\"}" },
          { "type": "speech_bubble", "speaker": "woman", "text": "は、はい...ありがとうございます" }
        ]
      },
      {
        "panel_number": 3,
        "scene": "Close-up of the delivery man laughing enthusiastically with a sparkly pink background.",
        "text_elements": [
          { "type": "speech_bubble", "speaker": "delivery_man", "text": "{argument name=\"creepy compliment\" default=\"おや〜？いや〜美人さんですなあ！こんな綺麗な方がお一人でお住まいなんて、もったいないなあ〜♪\"}" }
        ]
      },
      {
        "panel_number": 4,
        "scene": "Close-up of the woman looking disgusted and uncomfortable, sweating slightly. The back of the delivery man''s head is visible in the foreground.",
        "text_elements": [
          { "type": "speech_bubble", "speaker": "delivery_man", "text": "それにしてもお肌が綺麗！スタイルも抜群だし〜モデルさんみたいですよ！" },
          { "type": "thought_bubble", "speaker": "woman", "text": "{argument name=\"woman reaction\" default=\"え...？何この人...ちょっと気持ち悪いかも...\"}" },
          { "type": "caption_box", "text": "この後も延々と褒め続ける配達員だった..." }
        ]
      }
    ],
    "right_column_panel": {
      "panel_number": 5,
      "scene": "Full-body portrait of the woman standing indoors, looking annoyed and suspicious with her arms crossed.",
      "text_elements": [
        { "type": "thought_bubble", "speaker": "woman", "text": "誰かしら...？" }
      ]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 127, '@studiomasakaki', 'https://x.com/studiomasakaki', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-127', '/images/case127.jpg', 'Hair, Purple Eyes , Outfit : , Delivery', '["Illustration","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-126', 'An Anime-style Light Novel Cover Illustration Featuring Two', 'Template imported from awesome-gpt-image-2 case 126. Source: @taira_renta.', 'Posters & Typography', 'An anime-style light novel cover illustration featuring two characters in an intimate pose. On the left, a young woman with short dark hair, purple eyes, wearing a white hat, a frilly white dress with a pink bow tie, white gloves, and two white flower hairpins. She has an affectionate, teasing smile and is gently touching the chin of the man next to her. On the right, an adult man with {argument name="man''s hair color" default="red"} hair parted in the middle, purple eyes, and a light goatee. He is wearing a black button-down shirt and has a slightly annoyed, reluctant expression with a sweat drop on his cheek. The scene features soft, romantic lighting with out-of-focus purple flower petals in the foreground corners. The image includes several Japanese text elements: a large stylized main title at the bottom reading {argument name="main title" default="ちかつば"}, a subtitle below it reading {argument name="subtitle" default="ーその溺愛、独占欲の裏返し。ー"}, vertical text on the top left reading {argument name="left quote" default="可愛いだけじゃ、許さない。"}, and vertical text on the top right reading {argument name="right quote" default="その不機嫌、俺だけに向けろよ。"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 126, '@taira_renta', 'https://x.com/taira_renta', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-126', '/images/case126.jpg', 'An Anime-style Light Novel Cover Illustration Featuring Two', '["Poster","Illustration","Character"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-125', ', Appearance : , Pose and Expression :', 'Template imported from awesome-gpt-image-2 case 125. Source: @Gc_qube.', 'Illustration & Art', '{
  "type": "anime production layout sheet",
  "style": "traditional colored pencil genga, key animation drawing",
  "subject": {
    "character": "{argument name=\"character name\" default=\"ナズナ 七草\"}",
    "appearance": "anime girl with {argument name=\"hair color\" default=\"light purple\"} hair styled in twin braids and bangs, blue eyes, wearing a dark oversized coat",
    "pose_and_expression": "{argument name=\"expression\" default=\"smug with a small fang, resting chin on hand\"}"
  },
  "background": "{argument name=\"background scene\" default=\"nighttime city skyline with a railing\"}, soft focus",
  "layout": {
    "top_edge": "standard animation paper peg holes",
    "left_margin": {
      "series_title": "{argument name=\"anime title\" default=\"よふかしのうた\"}",
      "production_codes": ["#05 C.", "[A] (1)"],
      "circled_note": "髪のハイライト 色トレスです"
    },
    "right_margin": {
      "red_box": "002.normal",
      "timing_layers": ["A (1)", "B (1) (2) (3)", "C (1) (2) END"],
      "background_notes": ["BL 夜景", "BG 市街地夜景 色トレス"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 125, '@Gc_qube', 'https://x.com/Gc_qube', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-125', '/images/case125.jpg', ', Appearance : , Pose and Expression :', '["Product","Character"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-124', 'An Anime-style Key Visual Poster for a Fictional', 'Template imported from awesome-gpt-image-2 case 124. Source: @koshian_to.', 'Posters & Typography', 'An anime-style key visual poster for a fictional slice-of-life anime. In the foreground left, an energetic blonde anime girl with star hairpins and blue eyes wears an {argument name="main character outfit" default="American flag t-shirt and denim shorts"}, holding tongs with a slice of smoked meat towards the viewer. In the foreground right, a gentle girl with long dark hair and a white sweater sits at a wooden table writing in a notebook. In the background, two more girls are present: one with a brown ponytail carrying firewood, and another with short silver hair holding a blue mug. The scene is a sunny outdoor BBQ area with a large black smoker grill featuring a sign that reads {argument name="background grill sign" default="LONE STAR BBQ"}. In the immediate foreground is a {argument name="food platter" default="massive wooden platter loaded with sliced brisket, ribs, sausages, burnt ends, and pickles"}, along with side dishes like coleslaw and bread. In the top left corner, a large, cute, bubbly anime logo reads {argument name="anime title" default="もくもく すもーく ガールズ"} with smoke and grill motifs. In the bottom left corner, there is a {argument name="credits text block" default="staff credits block with names and roles"}. In the bottom right corner, a small text box lists four character names. The overall atmosphere is cheerful, highly detailed, and vibrant.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 124, '@koshian_to', 'https://x.com/koshian_to', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-124', '/images/case124.jpg', 'An Anime-style Key Visual Poster for a Fictional', '["Poster","Brand","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-123', ', Appearance : , Layout : , Subtitle', 'Template imported from awesome-gpt-image-2 case 123. Source: @Luvune.', 'Characters & People', '{
  "type": "anime character reference sheet",
  "character": {
    "name": "{argument name=\"character name\" default=\"真田大助\"}",
    "appearance": "young warrior with long brown hair, wearing samurai-inspired armor, {argument name=\"main color\" default=\"red\"} chest plate and guards, {argument name=\"secondary color\" default=\"navy blue\"} pleated hakama, white short cape"
  },
  "layout": {
    "header": {
      "title": "{argument name=\"character name\" default=\"真田大助\"}",
      "subtitle": "{argument name=\"character concept\" default=\"戦国時代を舞台にした物語の主人公。日英クォーターの若き武将。\"}",
      "badge": "設定資料"
    },
    "right_side": {
      "main_portrait": "large full-body standing pose, confident smile",
      "background_elements": {
        "emblem": "six-coin crest",
        "quote": "{argument name=\"catchphrase\" default=\"この国を守る。その誇りと共に。\"}",
        "scenery": "monochrome Japanese castle with army banners at the bottom right"
      }
    },
    "sections": [
      {
        "title": "プロフィール",
        "position": "top-left",
        "content": "table with 6 rows and descriptive text"
      },
      {
        "title": "三面図",
        "position": "mid-left",
        "count": 3,
        "labels": ["正面", "側面", "背面"]
      },
      {
        "title": "表情差分",
        "position": "top-center",
        "count": 6,
        "labels": ["通常", "微笑み", "真剣", "怒り", "驚き", "考え中"]
      },
      {
        "title": "衣装・装備詳細",
        "position": "bottom-left",
        "count": 9,
        "labels": ["胸当て", "肩当て", "腕甲(籠手)", "脚甲(脛当て・膝当て)", "革靴", "白マント(短)", "帯", "袴/着物部分", "打刀"]
      },
      {
        "title": "カラーパレット",
        "position": "bottom-center",
        "count": 8,
        "labels": ["真田赤", "濃紺", "金", "白", "茶", "茶褐色", "肌色", "銀"]
      },
      {
        "title": "世界観",
        "position": "bottom-center-right",
        "content": "paragraph of text describing the setting"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 123, '@Luvune', 'https://x.com/Luvune', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-123', '/images/case123.jpg', ', Appearance : , Layout : , Subtitle', '["Illustration","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-122', 'Case 122 Posters and Typography Template', 'Template imported from awesome-gpt-image-2 case 122. Source: @pcneko_lab.', 'Posters & Typography', '{
  "type": "movie poster grid",
  "layout": "2x2 grid",
  "posters": [
    {
      "position": "top-left",
      "genre": "sci-fi comedy",
      "visuals": "A Japanese salaryman sitting on a crowded train looking nervous, flanked by two aliens in business attire: a green frog-like alien looking at a smartphone, and a blue octopus-like alien reading a newspaper.",
      "text_elements": {
        "tagline_top": "隣の席のアイツ、実は宇宙人でした。",
        "train_display": "次は 地球 (ちきゅう) Next Earth",
        "tagline_side": "この星の常識、いつの間にかアップデートされていた。",
        "main_title": "{argument name=\"poster 1 title\" default=\"となりの宇宙人\"}",
        "cast": "星野サダオ タコヤキ・Z カエルダ・X",
        "release_date": "6月13日(金) 全国公開"
      }
    },
    {
      "position": "top-right",
      "genre": "surreal romance",
      "visuals": "A man in a dark jacket affectionately hugging a giant onigiri (rice ball) topped with mentaiko (spicy cod roe) wrapped in seaweed. They are sitting on a rocky beach during a beautiful sunset.",
      "text_elements": {
        "tagline": "めんたいこは、裏切らない。",
        "main_title": "{argument name=\"poster 2 title\" default=\"めんたいこ ひとすじ\"}",
        "cast": "中尾シンイチ めんたい子 博多ミツル 高菜ユカリ のり平",
        "release_date": "7月18日(金) 心にしみる、しお味系ラブストーリー"
      }
    },
    {
      "position": "bottom-left",
      "genre": "heist comedy",
      "visuals": "A joyful elderly woman in a leopard print blouse laughing maniacally while holding a fan of Japanese yen bills. Money is raining down around her. A happy raccoon is in the foreground.",
      "text_elements": {
        "tagline": "人生、まだまだ使いきってなんかない！",
        "main_title": "{argument name=\"poster 3 title\" default=\"老後の逆襲\"}",
        "subtitle": "〜いたずらタヌキと億万長者〜",
        "cast": "ババンバ・バーバラ タヌキチ 金持ちババ 遺産マユミ 税理士ゴンザレス",
        "release_date": "9月5日(金) 痛快！下剋上エンターテインメント！"
      }
    },
    {
      "position": "bottom-right",
      "genre": "disaster thriller",
      "visuals": "A dramatic disaster scene where laundry baskets, shirts, and clothes are being sucked up into a stormy, apocalyptic sky above a ruined Tokyo city skyline featuring the Tokyo Tower.",
      "text_elements": {
        "tagline": "それは、静かに、確実に、洗濯物を奪っていく。",
        "main_title": "{argument name=\"poster 4 title\" default=\"洗濯物 ストーム\"}",
        "cast": "森タクヤ 干場カオリ 風間ハルキ ピンチハンガー・タカ 洗濯バサミ・ケン",
        "release_date": "8月29日(金) 全国の空が、危ない。"
      }
    }
  ]
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 122, '@pcneko_lab', 'https://x.com/pcneko_lab', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-122', '/images/case122.jpg', 'Case 122 Posters and Typography Template', '["UI","Poster"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-121', 'Case 121 Illustration and Art Template', 'Template imported from awesome-gpt-image-2 case 121. Source: @loilokoji.', 'Illustration & Art', '{
  "type": "3-panel manga page",
  "style": "anime, highly detailed, cinematic lighting, futuristic corporate",
  "layout": {
    "structure": "1 wide top panel, 2 square bottom panels"
  },
  "panels": [
    {
      "position": "top",
      "shot": "wide landscape",
      "scene": "Futuristic corporate lobby with floor-to-ceiling windows",
      "lighting": "{argument name=\"time of day\" default=\"sunrise\"}",
      "background": "City skyline featuring {argument name=\"landmark\" default=\"Tokyo Tower\"}",
      "details": "Holographic displays, polished reflective floor, reception desk, lounge chairs"
    },
    {
      "position": "bottom left",
      "shot": "close-up profile",
      "character": "Young woman, dark hair, black business suit",
      "accessories": "Futuristic black earpiece with glowing blue light",
      "speech_bubble": {
        "style": "standard rounded",
        "text": "{argument name=\"character dialogue\" default=\"数字はいいわ\"}"
      }
    },
    {
      "position": "bottom right",
      "shot": "full body, walking away, touching earpiece",
      "character": "Same woman, black suit, black heels, carrying a black tote bag",
      "environment": "Approaching security gates",
      "holographic_sign": "{argument name=\"floor sign\" default=\"ECHO 42F\"}",
      "speech_bubble": {
        "style": "futuristic angular",
        "text": "{argument name=\"AI dialogue\" default=\"おはようございます、ユキさん。本日は記念すべき ──\"}"
      }
    }
  ]
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 121, '@loilokoji', 'https://x.com/loilokoji', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-121', '/images/case121.jpg', 'Case 121 Illustration and Art Template', '["UI","Character"]'::jsonb, '["Tech","Travel","Story"]'::jsonb, FALSE, TRUE),
    ('case-120', 'A Dynamic Anime Illustration of a Girl with', 'Template imported from awesome-gpt-image-2 case 120. Source: @UNIBRACITY.', 'Illustration & Art', 'A dynamic anime illustration of a girl with spiky {argument name="hair color" default="blonde"} hair tied in a high ponytail with a black bow, striking teal eyes, and a {argument name="outfit style" default="dark purple and black magical uniform with gold trim and diamond gems"}. She is in an intense crouching superhero landing pose, one hand pressed to the ground and the other raised, casting {argument name="magic color" default="glowing purple"} magic circles. She is shattering through a glass barrier, with sharp, jagged glass shards flying outward toward the viewer. Through the broken frame behind her, a {argument name="background scene" default="stylized silhouette of a gothic city with tall spires against a vibrant purple and orange sunset sky"} is visible. The artwork features {argument name="art style" default="sharp angles, high contrast cel-shading, and vibrant colors"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 120, '@UNIBRACITY', 'https://x.com/UNIBRACITY', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-120', '/images/case120.jpg', 'A Dynamic Anime Illustration of a Girl with', '["Illustration","Character"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-119', ', Release Date : , Tagline : ,', 'Template imported from awesome-gpt-image-2 case 119. Source: @old_pgmrs_will.', 'Documents & Publishing', '{
  "type": "anime movie production pitch document",
  "overall_layout": "split layout with a large cinematic movie poster on the top half and a grid of 5 detailed reference sheets on the bottom half",
  "top_section": {
    "type": "movie poster",
    "visual": "A man, a woman, and a dog standing on a ruined city street, facing away from the viewer, looking towards a colossal, porous, web-like alien structure dominating the sky. A rusty ''RESTRICTED AREA'' sign is on the right.",
    "typography": {
      "title": "{argument name=\"movie title\" default=\"劇場版 巨骸の向こう側 Fallen Colossus\"}",
      "release_date": "{argument name=\"release date\" default=\"2027.11.28 ROADSHOW\"}",
      "tagline": "そこにあるのは、まだ「説明」されていないもの。",
      "credits_studio": "{argument name=\"studio name\" default=\"WIT STUDIO\"}"
    }
  },
  "bottom_sections": [
    {
      "title": "{argument name=\"male character name\" default=\"来栖 武 / Kurusu Takeru\"}",
      "type": "character reference sheet",
      "elements": {
        "full_body_poses": 3,
        "expressions": 3,
        "detail_shots": 8,
        "description": "Male protagonist in dark tactical jacket and cargo pants. Includes front, back, and side full-body views, headshots, and detailed callouts for gloves, boots, backpack, and radio."
      }
    },
    {
      "title": "{argument name=\"female character name\" default=\"大城 真那 / Oshiro Mana\"}",
      "type": "character reference sheet",
      "elements": {
        "full_body_poses": 3,
        "expressions": 3,
        "detail_shots": 6,
        "description": "Female protagonist in grey tactical uniform. Includes front, back, and side full-body views, headshots, and detailed callouts for jacket, boots, ID badge, and pouch."
      }
    },
    {
      "title": "カゲ (Kage) 設定画",
      "type": "animal character reference sheet",
      "elements": {
        "full_body_poses": 4,
        "expressions": 4,
        "detail_shots": 5,
        "description": "Dog companion. Includes side, front, back, and angled full-body views, headshots, and detailed callouts for fur texture, paws, and a motorcycle sidecar."
      }
    },
    {
      "title": "第7巨骸 (Remnant-7) 内部区画 設定画",
      "type": "environment and vehicle reference sheet",
      "elements": {
        "large_diagrams": 1,
        "environment_thumbnails": 4,
        "vehicle_designs": 1,
        "description": "Cross-section of the porous alien structure, smaller environment thumbnails, and a motorcycle design featuring the characters."
      }
    },
    {
      "title": "Concept Art",
      "type": "scene illustration",
      "elements": {
        "characters": 3,
        "vehicles": 1,
        "description": "The male character, female character, and dog with a motorcycle sidecar parked in front of the glowing, porous alien structure."
      }
    }
  ]
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 119, '@old_pgmrs_will', 'https://x.com/old_pgmrs_will', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-119', '/images/case119.jpg', ', Release Date : , Tagline : ,', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-118', 'A High-contrast, Black-and-white Illustration of an Elderly Man', 'Template imported from awesome-gpt-image-2 case 118. Source: @nicdunz.', 'Illustration & Art', 'A high-contrast, black-and-white illustration of an elderly man in a sharp suit, drawing a katana. The man has slicked-back white hair, deep wrinkles, and an intense, focused expression, looking down at the blade. He wears a dark suit, white shirt, and dark tie. His hands are prominently featured in the foreground, showing pronounced veins and wrinkles as they grip the ornate handle and scabbard of the katana. The background is completely black, emphasizing the dramatic lighting and intricate cross-hatching details on the man''s face, hands, and clothing. The style resembles a detailed, gritty manga or graphic novel.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 118, '@nicdunz', 'https://x.com/nicdunz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-118', '/images/case118.jpg', 'A High-contrast, Black-and-white Illustration of an Elderly Man', '["UI","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-117', 'A Humorous 3d Cartoon Illustration of a Therapy', 'Template imported from awesome-gpt-image-2 case 117. Source: @nicdunz.', 'Illustration & Art', 'A humorous 3D cartoon illustration of a therapy session in a cozy office. On the left, a {argument name="patient character" default="sad anthropomorphic avocado half missing its pit"} sits on a brown leather lounge chair, gesturing with its thin stick-like arms. A large speech bubble above it reads "{argument name="speech text" default="I just feel so empty inside"}". On the right, the therapist, an {argument name="therapist character" default="anthropomorphic silver spoon"}, sits in a green armchair, holding a yellow pencil and writing on a notepad labeled "NOTES". The room has warm lighting, a beige rug on a wooden floor, and a bookshelf with a tissue box and books, one titled "REFLECT LISTEN VALIDATE". On the left wall hangs a framed poster reading "{argument name="poster text" default="IT''S OKAY TO FEEL YOUR FEELINGS"}" with a small heart. On the right wall hangs a framed diploma reading "{argument name="diploma text" default="SPOON UNIVERSITY SCHOOL OF LISTENING & VALIDATION"}" featuring a small spoon illustration and a gold seal.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 117, '@nicdunz', 'https://x.com/nicdunz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-117', '/images/case117.jpg', 'A Humorous 3d Cartoon Illustration of a Therapy', '["Poster","Illustration","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-116', ', Character : , Layout : , Right', 'Template imported from awesome-gpt-image-2 case 116. Source: @gamemangaanime.', 'Illustration & Art', '{
  "type": "2-page manga spread",
  "style": "monochrome anime manga, screentones",
  "theme": "{argument name=\"main action\" default=\"fantasy mage developing a video game\"}",
  "character": "{argument name=\"character appearance\" default=\"anime girl with blonde hair, tiara, cape, white dress, thigh-highs\"}",
  "layout": {
    "left_page": {
      "panel_count": 11,
      "rows": [
        {"panels": 1, "action": "Determined at dual-monitor desk, speech bubble: ''新作ゲーム、絶対完成させる！''"},
        {"panels": 3, "action": "Typing, drawing on tablet, testing with controller"},
        {"panels": 3, "action": "Shocked at ERROR screen, depressed, determined again"},
        {"panels": 4, "action": "Exhausted, sudden realization, furious typing, monitor showing ''Build succeeded!''"}
      ]
    },
    "right_page": {
      "panel_count": 2,
      "panels": [
        {"type": "large splash", "action": "Casting magic from a glowing circle at a code-error monster labeled ''{argument name=\"error text\" default=\"NullReferenceException\"}''. Speech bubble: ''{argument name=\"spell text\" default=\"デバッグ魔法!!\"}''"},
        {"type": "bottom banner", "action": "Cheering in front of RPG title screen. Speech bubble: ''{argument name=\"success text\" default=\"やったー！\"}''"}
      ]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 116, '@gamemangaanime', 'https://x.com/gamemangaanime', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-116', '/images/case116.jpg', ', Character : , Layout : , Right', '["UI","Poster","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-115', ', Theme : , Layout : , Visuals', 'Template imported from awesome-gpt-image-2 case 115. Source: @onofumi_AI.', 'Illustration & Art', '{
  "type": "two-page manga spread",
  "style": "highly detailed realistic manga, monochrome, screentones, dramatic lighting, psychological thriller",
  "global_elements": {
    "protagonist": "{argument name=\"main character description\" default=\"young Japanese salaryman in a suit\"}",
    "theme": "{argument name=\"core concept\" default=\"surrounded by a massive crowd of identical clones of himself\"}"
  },
  "layout": {
    "left_page": {
      "type": "full page splash panel",
      "setting": "{argument name=\"setting\" default=\"Shibuya scramble crossing at night\"}",
      "visuals": "Protagonist standing alone in the center of the crossing, looking around in shock at a massive crowd where every single person is an exact clone of him.",
      "text_elements": [
        {"type": "manga title logo", "text": "{argument name=\"manga title\" default=\"俺だらけの街\"}"},
        {"type": "subtitle", "text": "第1話 交代"},
        {"type": "narration box", "text": "その夜、世界は静かに俺をやめた。"},
        {"type": "sound effect", "text": "ザワ..."}
      ]
    },
    "right_page": {
      "type": "5-panel vertical layout",
      "panels": [
        {
          "panel_number": 1,
          "visuals": "Extreme close-up of protagonist''s eyes, wide with shock, sweating.",
          "text_elements": [
            {"type": "speech bubble", "text": "......は？ なんで......みんな、俺なんだ？"},
            {"type": "sound effect", "text": "ドクン"}
          ]
        },
        {
          "panel_number": 2,
          "visuals": "A horizontal row of 8 identical clones in suits staring blankly forward.",
          "text_elements": [
            {"type": "sound effect", "text": "ザワ..."}
          ]
        },
        {
          "panel_number": 3,
          "visuals": "A clone leaning in to whisper into the shocked protagonist''s ear.",
          "text_elements": [
            {"type": "speech bubble", "text": "お前の代わりは、もう足りてる。"},
            {"type": "sound effect", "text": "スッ"}
          ]
        },
        {
          "panel_number": 4,
          "visuals": "Close-up of a smartphone screen held in a hand, showing a push notification.",
          "text_elements": [
            {"type": "screen text", "text": "交代を開始します。"},
            {"type": "sound effect", "text": "ピロン"}
          ]
        },
        {
          "panel_number": 5,
          "visuals": "Wide shot of the endless crowd of clones in the city street.",
          "text_elements": [
            {"type": "narration box", "text": "最初に消えるのは、名前でも命でもない。居場所だ。"},
            {"type": "bottom left text", "text": "俺は、ここにいていいのか--？"},
            {"type": "bottom right text", "text": "{argument name=\"cliffhanger text\" default=\"次号へつづく！\"}"},
            {"type": "sound effect", "text": "ザワ... ザワ... ザワ..."}
          ]
        }
      ]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 115, '@onofumi_AI', 'https://x.com/onofumi_AI', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-115', '/images/case115.jpg', ', Theme : , Layout : , Visuals', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-114', ', Characters, Subject 2 : , Layout :', 'Template imported from awesome-gpt-image-2 case 114. Source: @kaikaitheaiguy.', 'Illustration & Art', '{
  "type": "4-panel vertical comic strip",
  "style": "{argument name=\"art style\" default=\"black and white pencil sketch, crosshatch shading, satirical caricature comic\"}",
  "characters": {
    "subject_1": "{argument name=\"main character\" default=\"Sam Altman\"}, curly hair, casual sweater",
    "subject_2": "{argument name=\"interviewer\" default=\"Ronan Farrow\"}, suit, tie, holding notepad"
  },
  "layout": {
    "panels": [
      {
        "panel_number": 1,
        "top_caption": "SAM ALTMAN THINKS THIS WILL BE A NICE LITTLE PROFILE...",
        "scene": "subject_1 looking smug with hands steepled; subject_2 looking serious taking notes.",
        "thought_bubble": "I''LL BE CHARMING. IT''LL BE A GREAT CHARACTER PIECE. PEOPLE WILL LOVE IT.",
        "center_text": "THE RONAN FARROW INTERVIEW",
        "inset_portraits": {
          "count": 2,
          "labels": ["HARVEY WEINSTEIN EXPOSED", "LESLIE MOONVES EXPOSED"]
        },
        "info_boxes": {
          "count": 3,
          "text": [
            "RONAN FARROW: PULITZER PRIZE-WINNING REPORTER WHO EXPOSED HARVEY WEINSTEIN AT THE NEW YORKER",
            "AND LESLIE MOONVES AT CBS.",
            "POWER. ABUSE. ACCOUNTABILITY."
          ]
        }
      },
      {
        "panel_number": 2,
        "top_caption": "CUT TO...",
        "scene": "Close-up of subject_1 looking shocked and horrified.",
        "article_header": "{argument name=\"publication\" default=\"THE NEW YORKER\"}\nTHE SAM ALTMAN PROFILE\nTHE OPENAI CEO''S COMPLICATED QUEST\nBy Ronan Farrow"
      },
      {
        "panel_number": 3,
        "top_caption": "SOON AFTER THE ARTICLE IS PUBLISHED...",
        "scene": "subject_1 looking extremely stressed, sweating, holding a phone to his ear. Surrounded by 6 hands holding smartphones.",
        "phone_labels": ["VC", "REPORTER", "EX-STAFFEE", "INVESTOR", "TECH CEO", "FORMER COLLEAGUE"],
        "shouts": {
          "count": 8,
          "text": [
            "{argument name=\"main accusation\" default=\"LIAR\"}!",
            "COMPULSIVE LIAR!",
            "PATHOLOGICAL LIAR!",
            "YOU CAN''T STOP LYING!",
            "LIAR!!!",
            "SOCIOPATH! (ALLEGEDLY)",
            "EVERYTHING HE SAYS IS A LIE!",
            "MANIPULATIVE LIAR!"
          ]
        },
        "sound_effects": "RING! RING! RING!"
      },
      {
        "panel_number": 4,
        "top_caption": "AND THE REPORT CONCLUDES...",
        "scene": "subject_1 looking utterly defeated and depressed.",
        "quote_box": "\"ALTMAN FREQUENTLY AND CONSISTENTLY LIES TO INVESTORS, EMPLOYEES, THE BOARD, AND EVEN CLOSE FRIENDS.\"\n\"HE APPEARS TO HAVE NO COMFORT TELLING FALSEHOODS.\"\n\"HE IS, BY MANY ACCOUNTS, A COMPULSIVE LIAR AND A SOCIOPATH.\"\n(ALLEGEDLY)",
        "thought_bubble": {
          "scene": "Happy subject_1 holding a ''WORLD''S BEST CEO'' mug.",
          "text": "I THOUGHT IT WOULD BE A NICE LITTLE PROFILE...",
          "sparkle_words": {
            "count": 4,
            "text": ["GENIUS!", "VISIONARY!", "INSPIRING!", "BRILLIANT LEADER!"]
          }
        },
        "bottom_caption": "INSTEAD, IT''S THE PROFILE THAT EXPOSES HIM."
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 114, '@kaikaitheaiguy', 'https://x.com/kaikaitheaiguy', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-114', '/images/case114.jpg', ', Characters, Subject 2 : , Layout :', '["UI","Illustration","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-113', 'A Highly Detailed Anime Illustration of a Fierce', 'Template imported from awesome-gpt-image-2 case 113. Source: @REd8358.', 'Illustration & Art', 'A highly detailed anime illustration of a fierce female warrior with long flowing {argument name="hair color" default="black"} hair and piercing {argument name="eye color" default="blue"} eyes, wearing a mix of silver plate armor with gold trim and a {argument name="outfit color" default="blue and white"} tunic. She is captured in a dynamic combat stance, swinging a massive, {argument name="weapon type" default="segmented metallic whip-sword"} that curves dramatically into the extreme foreground. The weapon leaves a sweeping trail of kinetic energy and wind. The scene is set against a {argument name="background setting" default="ruined battlefield with rocky terrain, floating debris, and large blue banners fluttering in the wind"} under a dramatic cloudy sky. The artwork features cinematic lighting, intense action, and a dramatic forced perspective on the weapon.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 113, '@REd8358', 'https://x.com/REd8358', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-113', '/images/case113.jpg', 'A Highly Detailed Anime Illustration of a Fierce', '["UI","Illustration"]'::jsonb, '["Tech","Social","Story"]'::jsonb, FALSE, TRUE),
    ('case-112', 'Generate a 12-grid Card Image of the 12', 'Template imported from awesome-gpt-image-2 case 112. Source: @songguoxiansen.', 'Illustration & Art', 'Generate a 12-grid card image of the 12 Golden Saints from Saint Seiya, with each card featuring its corresponding Chinese name, 4 cards per row, in a 16:9 aspect ratio.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 112, '@songguoxiansen', 'https://x.com/songguoxiansen', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-112', '/images/case112.jpg', 'Generate a 12-grid Card Image of the 12', '["Infographic"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-111', 'A Youtube Thumbnail-style Collage for a', 'Template imported from awesome-gpt-image-2 case 111. Source: @mirochill.', 'UI & Interfaces', 'A YouTube thumbnail-style collage for a {argument name="overall mood" default="dark, dramatic, true crime investigation"}. In the center is a highly detailed, close-up portrait of an {argument name="central figure" default="older man with grey hair and deep wrinkles resembling Jeffrey Epstein"}, wearing a black polo shirt, with a faint red glowing outline separating him from the background. On the left side, a {argument name="left background scene" default="tropical island with luxury villas and a flying airplane in a dark sky"}. Below the island, a conspiracy board motif features exactly 2 red push pins connected by 3 thick red strings. On the top right side, a hazy, sepia-toned depiction of the {argument name="right background scene" default="US Capitol building with the silhouettes of 3 men in suits facing it"}. On the bottom right, an open manila folder containing a {argument name="document type" default="heavily redacted dossier with thick black marker lines and a smaller photograph of the central man"}. The overall composition is cinematic, intense, and heavily stylized for a documentary video.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 111, '@mirochill', 'https://x.com/mirochill', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-111', '/images/case111.jpg', 'A Youtube Thumbnail-style Collage for a', '["UI","Poster","Realistic"]'::jsonb, '["Tech","Fashion","Story"]'::jsonb, FALSE, TRUE),
    ('case-110', 'Thumbnail for a Youtube Unboxing Video, a Video', 'Template imported from awesome-gpt-image-2 case 110. Source: @TlanoAI.', 'UI & Interfaces', 'Thumbnail for a YouTube unboxing video, a video of {argument name="topic" default="opening all overdue bills"}, {argument name="quantity" default="100 in a row"}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 110, '@TlanoAI', 'https://x.com/TlanoAI', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-110', '/images/case110.jpg', 'Thumbnail for a Youtube Unboxing Video, a Video', '["UI","Poster"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-109', 'Is Live-streaming a', 'Template imported from awesome-gpt-image-2 case 109. Source: @underwoodxie96.', 'UI & Interfaces', '{argument name="subject" default="A beautiful internet celebrity"} is live-streaming a {argument name="activity" default="game"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 109, '@underwoodxie96', 'https://x.com/underwoodxie96', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-109', '/images/case109.jpg', 'Is Live-streaming a', '["UI"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-108', 'Is Live-streaming a', 'Template imported from awesome-gpt-image-2 case 108. Source: @underwoodxie96.', 'UI & Interfaces', '{argument name="subject" default="A beautiful internet celebrity"} is live-streaming a {argument name="activity" default="game"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 108, '@underwoodxie96', 'https://x.com/underwoodxie96', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-108', '/images/case108.jpg', 'Is Live-streaming a', '["UI"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-107', ', Video Player : , Podium Logo :', 'Template imported from awesome-gpt-image-2 case 107. Source: @tehno_maniak.', 'UI & Interfaces', '{"type": "YouTube desktop dark mode UI mockup", "header": {"logo": "YouTube", "search_bar": "Search", "icons_count": 5, "icons": ["search", "mic", "create", "notifications", "profile"]}, "video_player": {"top_left_badge": "LIVE", "left_side": {"subject": "{argument name=\"presenter description\" default=\"man in green sweater at wooden podium\"}", "podium_logo": "OpenAI"}, "right_side_presentation": {"text_elements": ["OpenAI", "INTRODUCING", "{argument name=\"product name\" default=\"GPT-Image-2\"}", "{argument name=\"tagline\" default=\"More Realistic. More Useful. More Creative.\"}"], "sample_images_count": 4, "sample_images": ["mountain lake with boat", "woman portrait with dappled light", "cute robot with lantern in forest", "starry night cafe painting"]}, "bottom_controls_count": 10, "bottom_controls": ["pause", "next", "volume", "LIVE", "red progress bar", "CC", "settings", "miniplayer", "theater mode", "fullscreen"]}, "video_details": {"title": "{argument name=\"video title\" default=\"OpenAI Live: Introducing GPT-Image-2\"}", "channel": {"name": "{argument name=\"channel name\" default=\"OpenAI\"}", "verified": true, "subscribers": "1.36M", "button": "Subscribe"}, "action_buttons_count": 5, "action_buttons": ["Like 12K", "Dislike 497", "Share", "Save", "More"], "description_box": {"stats": "95,237 watching now Started streaming 7 minutes ago", "tags": "#OpenAI #GPTImage2 #AI", "text": "Join us for a special live event as we introduce GPT-Image-2, our latest and most advanced image generation model. See new capabilities, live demos, and hear from the team ...more"}}}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 107, '@tehno_maniak', 'https://x.com/tehno_maniak', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-107', '/images/case107.jpg', ', Video Player : , Podium Logo :', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-106', 'Hair, Cat Ears, Purple Eyes , Expression :', 'Template imported from awesome-gpt-image-2 case 106. Source: @abdiisan.', 'Other Use Cases', '{
  "type": "YouTube thumbnail graphic",
  "style": "anime, edgy, neon pink and black color scheme, grunge and splatter accents",
  "character": {
    "appearance": "anime girl, {argument name=\"hair color\" default=\"silver\"} hair, cat ears, purple eyes",
    "expression": "{argument name=\"expression\" default=\"shocked and sweating\"}, mouth open",
    "accessories": "black cat hairclip with pink cross, black choker with heart ring",
    "action": "holding a pink smartphone with a swirl logo"
  },
  "layout": {
    "main_title": {
      "position": "bottom center",
      "style": "huge, bold, 3D typography, grunge texture",
      "lines": [
        { "text": "{argument name=\"main title top\" default=\"스레드 논란\"}", "color": "neon pink" },
        { "text": "{argument name=\"main title bottom\" default=\"읽어드림 ;;\"}", "color": "white" }
      ]
    },
    "ui_elements": [
      {
        "type": "social media feed mockup",
        "position": "mid-left",
        "header": "← 스레드",
        "post_count": 3,
        "details": "avatars, Korean text, interaction icons for like, comment, repost"
      },
      {
        "type": "live chat mockup",
        "position": "right edge",
        "message_count": 4,
        "details": "pink user icons, Korean text"
      }
    ],
    "text_callouts": [
      {
        "type": "spiky speech bubble",
        "position": "center top",
        "text": "{argument name=\"speech bubble text\" default=\"이게 맞아?;;\"}"
      },
      {
        "type": "neon box",
        "position": "top right",
        "text": "실시간 반응 중"
      },
      {
        "type": "floating grunge text",
        "position": "far left",
        "line_count": 3,
        "text": ["OO 논란", "충격 실화", "역대급 사건"]
      },
      {
        "type": "handwritten text with arrow",
        "position": "bottom right",
        "text": "여러분의 생각은 어떠신가요?"
      }
    ],
    "logos": [
      {
        "type": "app icon",
        "position": "top left",
        "description": "white swirl logo on black rounded square"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 106, '@abdiisan', 'https://x.com/abdiisan', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-106', '/images/case106.jpg', 'Hair, Cat Ears, Purple Eyes , Expression :', '["UI","Poster","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-105', 'A High-energy Vtuber Thumbnail Illustration of a Smiling', 'Template imported from awesome-gpt-image-2 case 105. Source: @Yuupapa_free.', 'Posters & Typography', 'A high-energy VTuber thumbnail illustration of a smiling anime girl with {argument name="hair color" default="bright blue"} hair in a high ponytail wearing a white shirt. The background is an explosive burst of rainbow light rays and golden sparkles. A golden retro microphone sits in the bottom left. Massive, shiny 3D gold text on the left reads "{argument name="main title text" default="初配信"}". A 3D gold and blue subtitle reads "{argument name="subtitle text" default="一緒に最高の時間を！"}". An ornate blue and gold oval badge in the bottom right displays "{argument name="character name" default="エリン Erin"}". A red top-right badge reads "{argument name="badge text" default="LIVE"}".', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 105, '@Yuupapa_free', 'https://x.com/Yuupapa_free', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-105', '/images/case105.jpg', 'A High-energy Vtuber Thumbnail Illustration of a Smiling', '["Illustration","Character","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-104', ', Icons : 3 , Player : ,', 'Template imported from awesome-gpt-image-2 case 104. Source: @marouane53.', 'UI & Interfaces', '{
  "type": "YouTube livestream UI",
  "top_nav": {
    "logo": "YouTube Premium",
    "search": "{argument name=\"search query\" default=\"bilal fraiha\"}",
    "icons": 3
  },
  "player": {
    "subjects": [
      "{argument name=\"female guest\" default=\"Sydney Sweeney\"} in white cardigan",
      "bearded man in beige jacket laughing"
    ],
    "bg": "couch, 2 silver play buttons, ram logo ''SARDI''",
    "overlays": {
      "chat": {"pos": "left", "count": 15, "desc": "colored usernames, white text"},
      "goal": {"pos": "top right", "text": "TONIGHT''S GOAL: 0 to 25"},
      "banner": {"pos": "bottom center", "text": "K {argument name=\"streamer name\" default=\"MOREBILAL\"}"}
    },
    "controls": {"count": 10}
  },
  "details": {
    "title": "{argument name=\"video title\" default=\"FULL STREAM | سيدني سويني مع بلال\"}",
    "channel": "{argument name=\"channel name\" default=\"More Bilal No Filter\"}",
    "buttons": 5
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 104, '@marouane53', 'https://x.com/marouane53', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-104', '/images/case104.jpg', ', Icons : 3 , Player : ,', '["UI","Brand"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-103', 'Performs a Streamed on', 'Template imported from awesome-gpt-image-2 case 103. Source: @bowowwoaaa2.', 'UI & Interfaces', '{argument name="pianist" default="Vladimir Horowitz"} performs a {argument name="event" default="live piano recital"} streamed on {argument name="platform" default="YouTube"}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 103, '@bowowwoaaa2', 'https://x.com/bowowwoaaa2', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-103', '/images/case103.jpg', 'Performs a Streamed on', '["UI","Poster"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-102', 'Search the Web for , Using Exact Stats', 'Template imported from awesome-gpt-image-2 case 102. Source: @maxescu.', 'Charts & Infographics', 'Search the web for {argument name="performance description" default="this week''s standout individual performance in Champion''s League"}, using exact stats and game summary, {argument name="colors" default="bold team colors"}, legible score breakdown, and generate a {argument name="card type" default="Highlight card"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 102, '@maxescu', 'https://x.com/maxescu', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-102', '/images/case102.jpg', 'Search the Web for , Using Exact Stats', '["Infographic"]'::jsonb, '["Food"]'::jsonb, FALSE, TRUE),
    ('case-101', ', Position : Right Side , Props :', 'Template imported from awesome-gpt-image-2 case 101. Source: @naga_zyashin.', 'Posters & Typography', '{
  "type": "YouTube thumbnail",
  "style": "High-impact, neon green and black color scheme, cyber business aesthetic",
  "background": "Dark with glowing green grid, upward chart lines, large green arrow",
  "subject": {
    "description": "{argument name=\"subject description\" default=\"Serious Japanese man in a black suit\"}",
    "position": "Right side",
    "props": "Stacks of 10,000 Yen bills in bottom right"
  },
  "layout": {
    "main_title": {
      "text": "{argument name=\"main title\" default=\"月30万 ChatGPT副業 誰でも始めやすい\"}",
      "position": "Center, huge bold white and green gradient text"
    },
    "top_left_badge": {
      "text": "{argument name=\"top left badge\" default=\"再現性高め\"}",
      "style": "Angled neon green box"
    },
    "top_tags": {
      "count": 4,
      "labels": ["初心者OK", "スマホでも可能", "最短で収益化", "具体例つき"]
    },
    "left_bullet_points": {
      "count": 6,
      "style": "Dark boxes with neon green borders and icons",
      "items": [
        "Lightbulb icon: 失敗しない始め方",
        "Yen coin icon: 副業におすすめ",
        "Chart icon: 収益化の流れ",
        "Search icon: 案件の探し方",
        "Chat icon: プロンプト例つき",
        "Clipboard icon: テンプレ付き"
      ]
    },
    "bottom_banner": {
      "text": "{argument name=\"bottom banner text\" default=\"手順を徹底解説\"}",
      "icons": "ChatGPT logo left, upward chart right"
    },
    "bottom_tags": {
      "count": 2,
      "labels": ["{argument name=\"year tag\" default=\"2026年最新版\"}", "即実践できる"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 101, '@naga_zyashin', 'https://x.com/naga_zyashin', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-101', '/images/case101.jpg', ', Position : Right Side , Props :', '["UI","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-100', 'Hair, Purple Drop Earrings, Textured Purple Sweater ,', 'Template imported from awesome-gpt-image-2 case 100. Source: @naga_zyashin.', 'Posters & Typography', '{
  "type": "promotional banner thumbnail",
  "style": "vibrant neon, cosmic galaxy background, anime illustration style, high-density Japanese typography, glowing text effects",
  "character": {
    "description": "smiling young woman pointing upwards with right index finger",
    "appearance": "long {argument name=\"character hair color\" default=\"brown\"} hair, purple drop earrings, textured purple sweater",
    "position": "right side"
  },
  "layout": {
    "background": "purple, pink, and blue starry space nebula",
    "center_typography": {
      "top_small_text": "何から始めるか迷う人へ",
      "main_title": "{argument name=\"main title\" default=\"初心者でもわかる AI副業\"}",
      "subtitle": "最初の1本におすすめ",
      "floating_text_near_character": "やさしく解説♡"
    },
    "top_left": {
      "yellow_ribbon": "{argument name=\"top left ribbon text\" default=\"ゼロから始める\"}"
    },
    "top_right": {
      "pink_circle_badge": "初心者 OK"
    },
    "left_column": {
      "count": 7,
      "description": "stack of pill-shaped badges",
      "labels": [
        "スマホでもOK (with phone icon)",
        "副業デビューに (with beginner mark icon)",
        "具体例つき",
        "テンプレ付き",
        "おすすめツール紹介",
        "収益化の流れ",
        "失敗しない始め方"
      ]
    },
    "bottom_left_graphics": {
      "count": 3,
      "items": [
        "laptop displaying an AI circuit brain graphic",
        "glowing lightbulb",
        "rocket ship taking off"
      ]
    },
    "bottom_center": {
      "large_purple_button": "{argument name=\"bottom center button text\" default=\"完全解説\"}",
      "checklist_text_below": "✓始め方 ✓稼ぎ方 ✓注意点 ✓続け方まで全部わかる！"
    },
    "bottom_right": {
      "pink_cloud_shape": {
        "count": 3,
        "bullet_points": [
          "✓難しい知識不要",
          "✓今日から始められる",
          "✓やさしく丁寧に解説"
        ]
      },
      "gold_medal_seal": "保存版",
      "purple_badge": "{argument name=\"year badge text\" default=\"2026年 最新版\"}"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 100, '@naga_zyashin', 'https://x.com/naga_zyashin', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-100', '/images/case100.jpg', 'Hair, Purple Drop Earrings, Textured Purple Sweater ,', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-099', 'Palette, Glowing Light Rays, Sparkling Particles , Subject', 'Template imported from awesome-gpt-image-2 case 099. Source: @naga_zyashin.', 'Posters & Typography', '{
  "type": "promotional banner / YouTube thumbnail",
  "style": "high contrast, flashy, professional, {argument name=\"theme color\" default=\"gold and black\"} palette, glowing light rays, sparkling particles",
  "subject": {
    "description": "{argument name=\"subject description\" default=\"confident young Asian man in a dark suit with arms crossed\"}",
    "pose": "looking upwards to the right",
    "props": "glowing open laptop in front of him"
  },
  "layout": {
    "background": "dark with radiant gold light bursts",
    "text_sections": {
      "top_left_badge": "[保存版]",
      "top_header": "{argument name=\"top text\" default=\"知識ゼロからでも今日から始められる！ AIで稼ぐ力を最短で手に入れる！\"}",
      "main_title": {
        "text": "{argument name=\"main title\" default=\"AI副業 完全攻略\"}",
        "style": "large, bold, 3D gold and white typography"
      },
      "subtitle_box": "{argument name=\"subtitle\" default=\"初心者でも月10万\"}",
      "top_right_badge": {
        "style": "gold laurel wreath",
        "text": "2026年版 最新版"
      },
      "middle_right_tags": {
        "count": 3,
        "style": "stacked gold-bordered boxes",
        "labels": ["最短で収益化", "具体例つき", "誰でも始めやすい"]
      },
      "middle_right_ribbon": {
        "style": "red ribbon banner",
        "text": "手順を徹底解説"
      },
      "bottom_left_tags": {
        "count": 6,
        "style": "2x3 grid of gold-bordered boxes",
        "labels": ["おすすめツール紹介", "収益化の流れがわかる", "失敗しない始め方", "作業時間を最小化", "テンプレ付き", "再現しやすい方法"]
      },
      "bottom_footer": "迷わず稼げる！AI副業の教科書",
      "bottom_right_badge": {
        "style": "gold laurel wreath",
        "text": "テンプレ付き"
      }
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 99, '@naga_zyashin', 'https://x.com/naga_zyashin', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-99', '/images/case99.jpg', 'Palette, Glowing Light Rays, Sparkling Particles , Subject', '["UI","Poster","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-098', ', Background : , Layout :', 'Template imported from awesome-gpt-image-2 case 098. Source: @wtry1102.', 'Posters & Typography', '{
  "type": "VTuber debut stream thumbnail",
  "character": {
    "appearance": "anime girl, long dark purple hair, purple eyes, frilly white blouse, dark purple bow tie, large hair bow",
    "pose": "finger to lips, cute expression",
    "props": "condenser microphone with pop filter and purple ribbon on the right"
  },
  "background": "magical starry night, sparkles, glowing butterflies, purple and white color palette",
  "layout": {
    "typography": [
      {
        "position": "top left",
        "style": "large bold text with cursive English above",
        "text": "{argument name=\"main title\" default=\"初配信\"}",
        "subtext_1": "First Stream",
        "subtext_2": "Nice to meet you! I am Shisaki Lily!"
      },
      {
        "position": "middle left",
        "style": "decorative box",
        "text": "{argument name=\"character description\" default=\"お嬢様学校に通う清楚系VTuberですわ♪\"}"
      },
      {
        "position": "bottom left",
        "style": "logo style",
        "text": "{argument name=\"character name\" default=\"紫咲リリー\"}",
        "subtext": "Shisaki Lily"
      },
      {
        "position": "top right",
        "style": "vertical text",
        "text": "{argument name=\"catchphrase\" default=\"皆さまの心に、優雅なひとときをお届けしますわ♪\"}"
      },
      {
        "position": "bottom right",
        "style": "decorative pill shape",
        "text": "{argument name=\"stream date and time\" default=\"4.21 SUN 21:00~\"}",
        "subtext": "✦ START ✦"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 98, '@wtry1102', 'https://x.com/wtry1102', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-98', '/images/case98.jpg', ', Background : , Layout :', '["Poster","Brand","Character"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-097', 'Create a High-quality Japanese', 'Template imported from awesome-gpt-image-2 case 097. Source: @kawai_design.', 'Posters & Typography', 'Create a high-quality Japanese {argument name="thumbnail type" default="webinar thumbnail"}. {argument name="aspect ratio" default="16:9 widescreen"}. There is a lot of text, but the main copy stands out clearly.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 97, '@kawai_design', 'https://x.com/kawai_design', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-97', '/images/case97.jpg', 'Create a High-quality Japanese', '["Poster"]'::jsonb, '["Tech","Story"]'::jsonb, FALSE, TRUE),
    ('case-096', ', Background : , : , Top Right', 'Template imported from awesome-gpt-image-2 case 096. Source: @sayaka_aiart.', 'UI & Interfaces', '{
  "type": "VTuber stream thumbnail",
  "character": {
    "hair": "long blonde twin tails with pink gradient ends",
    "eyes": "large pink anime eyes",
    "expression": "cheerful smile with a small fang, making a peace sign near the eye",
    "outfit": "black top with harness straps, black heart-ring choker, multiple ear piercings including a cross dangle, black nail polish"
  },
  "background": "vibrant neon pink and black leopard print with glowing yellow accents, sparkles, and floating hearts",
  "typography_and_layout": {
    "main_title": {
      "position": "top left",
      "style": "large, bold, 3D, pink and black with white outlines",
      "text": "{argument name=\"main title\" default=\"雑談配信\"}"
    },
    "top_right_text": {
      "style": "casual handwritten style with a heart",
      "text": "{argument name=\"top right text\" default=\"まったり話そ〜♡\"}"
    },
    "bottom_left_banners": {
      "count": 3,
      "style": "glowing pill-shaped banners with heart icons on the left",
      "colors": ["pink", "yellow", "purple"],
      "labels": [
        "{argument name=\"banner 1 text\" default=\"初見さん〇\"}",
        "{argument name=\"banner 2 text\" default=\"ポイント回収〇\"}",
        "{argument name=\"banner 3 text\" default=\"ROM〇\"}"
      ]
    },
    "bottom_right_text": {
      "style": "casual handwritten style with a heart, yellow text with pink outline",
      "text": "気軽にコメントしてねっ♡"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 96, '@sayaka_aiart', 'https://x.com/sayaka_aiart', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-96', '/images/case96.jpg', ', Background : , : , Top Right', '["Poster","Character","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-095', ', Eyes : Large Bright Blue , Outfit', 'Template imported from awesome-gpt-image-2 case 095. Source: @sayaka_aiart.', 'UI & Interfaces', '{
  "type": "anime-style livestream thumbnail",
  "character": {
    "hair": "{argument name=\"hair color\" default=\"short silver hair with cyan underlights\"}",
    "eyes": "large bright blue",
    "outfit": "white collared shirt, black tie with silver accents, black jacket, black beret with a large blue heart jewel, blue jewel brooch, black choker",
    "pose": "smiling gently, looking at viewer, positioned on the right side"
  },
  "background": "pastel blue with white clouds, sparkles, stars, small bows, and a subtle grid pattern",
  "typography_and_ui": {
    "top_left_speech_bubble": "まったりおしゃべりしよ〜♡",
    "main_title": {
      "text": "{argument name=\"main title\" default=\"雑談配信\"}",
      "style": "large, soft blue gradient, white outline, decorated with small hearts, positioned on the middle-left"
    },
    "bottom_left_badges": {
      "count": 3,
      "style": "white pill-shaped buttons with a purple heart icon on the left",
      "labels": [
        "{argument name=\"badge 1 text\" default=\"初見さん〇\"}",
        "{argument name=\"badge 2 text\" default=\"ポイント回収〇\"}",
        "{argument name=\"badge 3 text\" default=\"ROM〇\"}"
      ]
    },
    "bottom_right_cloud_bubble": "気軽にコメントしてね♡"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 95, '@sayaka_aiart', 'https://x.com/sayaka_aiart', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-95', '/images/case95.jpg', ', Eyes : Large Bright Blue , Outfit', '["UI","Poster","Brand"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-094', 'Long Wavy Hair, Large Grey Eyes, Blush, Pink', 'Template imported from awesome-gpt-image-2 case 094. Source: @sayaka_aiart.', 'UI & Interfaces', '{
  "type": "VTuber stream thumbnail",
  "theme": "pastel pink, soft, cute, lace, ribbons, hearts, bunny motif",
  "character": {
    "position": "right side, waist-up",
    "appearance": "anime girl, {argument name=\"hair color\" default=\"pastel pink\"} long wavy hair, large grey eyes, blush, pink heart earrings",
    "accessories": "white bunny ears, large pink bow on head",
    "outfit": "white frilly dress with lace, large pink ribbon bow at collar with heart gem"
  },
  "layout": {
    "background": "soft pink with subtle sparkles, lace patterns, floating hearts",
    "text_elements": [
      {
        "type": "main title",
        "position": "top left",
        "style": "large stylized pink text with white outline",
        "text": "{argument name=\"main title\" default=\"雑談配信\"}"
      },
      {
        "type": "speech bubble",
        "position": "above main title",
        "text": "まったり"
      },
      {
        "type": "circular badge",
        "position": "top right",
        "details": "lace-edged with small pink bow",
        "text": "きてくれてありがとう♡"
      },
      {
        "type": "heart badge",
        "position": "bottom right",
        "details": "large lace-edged heart",
        "text": "みんなとおしゃべりできるの楽しみにしてるね♡"
      }
    ],
    "list_section": {
      "position": "bottom left",
      "count": 3,
      "style": "horizontal pill-shaped banners with lace edges, each featuring a pink heart with white bunny ears and a tiny bow on the left",
      "items": [
        "{argument name=\"list item 1\" default=\"初見さん〇\"}",
        "{argument name=\"list item 2\" default=\"ポイント回収〇\"}",
        "{argument name=\"list item 3\" default=\"ROM〇\"}"
      ]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 94, '@sayaka_aiart', 'https://x.com/sayaka_aiart', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-94', '/images/case94.jpg', 'Long Wavy Hair, Large Grey Eyes, Blush, Pink', '["Illustration","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-093', ', Layout : ,', 'Template imported from awesome-gpt-image-2 case 093. Source: @sayaka_aiart.', 'UI & Interfaces', '{
  "type": "VTuber stream thumbnail",
  "style": "anime, highly detailed, cute, sparkly, overwhelmingly pink color palette",
  "character": {
    "description": "anime girl with brown hair in twin buns, amber eyes, smiling gently",
    "outfit": "pink kimono combined with a white frilly maid apron, cherry blossom hair accessories",
    "pose": "holding a pink microphone decorated with a flower near her face"
  },
  "layout": {
    "background": "pink gradient with sparkles, glowing hearts, and decorative pink bows",
    "text_sections": [
      {
        "type": "top ribbon",
        "text": "{argument name=\"top subtitle\" default=\"まったりおしゃべりしよ〜🤍\"}"
      },
      {
        "type": "main title",
        "text": "{argument name=\"main title\" default=\"雑談配信\"}",
        "decorations": "surrounded by 3 large peach illustrations"
      },
      {
        "type": "middle ribbon",
        "text": "{argument name=\"middle subtitle\" default=\"みんなと楽しい時間を過ごしたいなっ♡\"}"
      },
      {
        "type": "bullet points",
        "position": "bottom left",
        "count": 3,
        "icon": "peach",
        "labels": [
          "{argument name=\"bullet 1\" default=\"初見さん〇\"}",
          "{argument name=\"bullet 2\" default=\"ポイント回収〇\"}",
          "ROMO"
        ]
      },
      {
        "type": "speech bubble",
        "position": "bottom right",
        "text": "コメント大歓迎♪ いっぱいお話し しようねっ♡"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 93, '@sayaka_aiart', 'https://x.com/sayaka_aiart', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-93', '/images/case93.jpg', ', Layout : ,', '["Illustration","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-092', 'An Anime-style Youtube Stream Thumbnail Featuring a Cheerful', 'Template imported from awesome-gpt-image-2 case 092. Source: @Yuupapa_free.', 'UI & Interfaces', 'An anime-style YouTube stream thumbnail featuring a cheerful female VTuber. She has long {argument name="hair color" default="pink with light blue inner highlights"} hair, blue eyes, and wears black and white cat-ear headphones with a boom mic. She wears a white collared shirt with a black and pink star ribbon and a black choker, smiling with one hand near her chin. The background is a gaming room with {argument name="room lighting" default="purple and blue neon"} lighting, showing a desk equipped with 1 white keyboard, 1 mug, 1 glowing cat figure, 1 game controller, and 1 streaming microphone. The left side features large, bold, pop-art Japanese typography: a bright pink top word "{argument name="main text line 1" default="雑談"}" and a bright blue bottom word "{argument name="main text line 2" default="配信"}". Below is a pink banner reading "{argument name="subtitle text" default="今夜もゆるっとトーク!"}". A red "LIVE" badge sits in the top left. Floating speech bubbles, stars, and hearts decorate the composition.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 92, '@Yuupapa_free', 'https://x.com/Yuupapa_free', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-92', '/images/case92.jpg', 'An Anime-style Youtube Stream Thumbnail Featuring a Cheerful', '["UI","Poster"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-091', 'A Highly Detailed, Realistic First-person Video Game Screenshot', 'Template imported from awesome-gpt-image-2 case 091. Source: @wolfaidev.', 'UI & Interfaces', 'A highly detailed, realistic first-person video game screenshot of a next-generation voxel-based world. At the top center, a large, bold 3D logo reads "{argument name="game title" default="MINECRAFT 2"}". The scene features a {argument name="environment" default="lush, blocky landscape with a river, a small wooden cabin, a windmill, a waterfall, and majestic mountains in the background"}. The world blends realistic lighting, volumetric clouds, and high-resolution textures with cubic, voxel geometry. In the foreground on the left, a {argument name="mob 1" default="blocky green creeper"} stands on the grass, while a {argument name="mob 2" default="blocky brown wolf"} stands on the dirt path to the right. On the far right, the player''s hand holds a {argument name="held item" default="pixelated blue diamond sword"} in a first-person perspective. At the bottom of the screen is a game user interface featuring a health bar with 10 red hearts, a green experience bar with the number ''16'', a hunger bar with 10 brown meat icons, and a 9-slot inventory hotbar. The hotbar contains, from left to right: a selected blue tool with a green highlight box, a green tool, a knife, a wrench with the number ''3'', a piece of meat with ''6'', a lantern with ''24'', a dirt block with ''10'', a bucket, and a sponge block.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 91, '@wolfaidev', 'https://x.com/wolfaidev', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-91', '/images/case91.jpg', 'A Highly Detailed, Realistic First-person Video Game Screenshot', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-090', 'Gpt-image-2 Prompt: Please Automatically Generate a Top-tier Concept', 'Template imported from awesome-gpt-image-2 case 090. Source: @A9Quant.', 'UI & Interfaces', 'GPT-Image-2 prompt: please automatically generate a top-tier concept poster / infographic-style movie poster centered around {argument name="theme" default="ranking of emperors in Chinese history"}.

Require the AI to automatically derive and uniformly design the entire following visual system based on this theme, without my extra specification:
- Core subject (automatically judge suitability for people, products, architecture, artifacts, symbols, scenes, or abstract imagery)
- Bottom supporting structure
- Hovering symbols or spiritual symbols above
- Scene wrapping elements
- Metaphor system
- Color hierarchy
- Material contrast
- Lighting logic
- Title, subtitle, and auxiliary copy
- Brand sense and high-end expression

The final frame must be: a shocking, precise, unified, cinematic, ultra-high detail conceptual key visual poster suitable for high-end printing.

[Overall Style]
Ultra-realistic 3D commercial CGI rendering, merging cinematic lighting, luxury visual language, futuristic concept design, and epic composition. The image must have a "single main visual core," not messy, not like a collage, and not like a regular e-commerce poster.

[Automatic Derivation Rules]
AI must automatically decide based on the [theme]:
1. Core visual metaphor
2. Subject type and posture
3. Form of supporting structure
4. Form of suspended elements
5. Scene shell and spatial atmosphere
6. Main, auxiliary, and emphasis colors
7. Material combinations
8. Text temperament and layout style

[Composition Rules]
- Absolute sense of premium quality
- Strong central order, overall unity
- Allows for axial symmetry or epic composition near the central axis
- Clear visual gravity, forming clear levels from top to bottom
- Edge negative space is clean, restrained, and has room to breathe

[Visual Quality]
- Ultra-high detail
- Clear volumetric light
- Authentic materials
- Natural reflection, refraction, shadows, fog, and depth of field
- Overall standard of high-end brand campaign key visual / luxury invitation poster / conceptual editorial poster

[Typography System]
- Overall 90% visual, 10% text
- AI automatically generates the most matching main title and subtitle based on the [theme]
- Title must be concise, sharp, and powerful
- Text should be as minimal and accurate as possible; do not stack words

[Signature Requirement]
Naturally add the author signature in the bottom corner: @a9quant', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 90, '@A9Quant', 'https://x.com/A9Quant', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-90', '/images/case90.jpg', 'Gpt-image-2 Prompt: Please Automatically Generate a Top-tier Concept', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-089', 'Gpt-image-2 Prompt: Please Automatically Generate a Top-tier Concept', 'Template imported from awesome-gpt-image-2 case 089. Source: @A9Quant.', 'Charts & Infographics', 'GPT-Image-2 prompt: please automatically generate a top-tier concept poster / infographic-style movie poster centered around {argument name="theme" default="ranking of emperors in Chinese history"}.

Require the AI to automatically derive and uniformly design the entire following visual system based on this theme, without my extra specification:
- Core subject (automatically judge suitability for people, products, architecture, artifacts, symbols, scenes, or abstract imagery)
- Bottom supporting structure
- Hovering symbols or spiritual symbols above
- Scene wrapping elements
- Metaphor system
- Color hierarchy
- Material contrast
- Lighting logic
- Title, subtitle, and auxiliary copy
- Brand sense and high-end expression

The final frame must be: a shocking, precise, unified, cinematic, ultra-high detail conceptual key visual poster suitable for high-end printing.

[Overall Style]
Ultra-realistic 3D commercial CGI rendering, merging cinematic lighting, luxury visual language, futuristic concept design, and epic composition. The image must have a "single main visual core," not messy, not like a collage, and not like a regular e-commerce poster.

[Automatic Derivation Rules]
AI must automatically decide based on the [theme]:
1. Core visual metaphor
2. Subject type and posture
3. Form of supporting structure
4. Form of suspended elements
5. Scene shell and spatial atmosphere
6. Main, auxiliary, and emphasis colors
7. Material combinations
8. Text temperament and layout style

[Composition Rules]
- Absolute sense of premium quality
- Strong central order, overall unity
- Allows for axial symmetry or epic composition near the central axis
- Clear visual gravity, forming clear levels from top to bottom
- Edge negative space is clean, restrained, and has room to breathe

[Visual Quality]
- Ultra-high detail
- Clear volumetric light
- Authentic materials
- Natural reflection, refraction, shadows, fog, and depth of field
- Overall standard of high-end brand campaign key visual / luxury invitation poster / conceptual editorial poster

[Typography System]
- Overall 90% visual, 10% text
- AI automatically generates the most matching main title and subtitle based on the [theme]
- Title must be concise, sharp, and powerful
- Text should be as minimal and accurate as possible; do not stack words

[Signature Requirement]
Naturally add the author signature in the bottom corner: @a9quant', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 89, '@A9Quant', 'https://x.com/A9Quant', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-89', '/images/case89.jpg', 'Gpt-image-2 Prompt: Please Automatically Generate a Top-tier Concept', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-088', 'Gpt-image-2 Prompt: Please Automatically Generate a Top-tier Concept', 'Template imported from awesome-gpt-image-2 case 088. Source: @A9Quant.', 'Posters & Typography', 'GPT-Image-2 prompt: please automatically generate a top-tier concept poster / infographic-style movie poster centered around {argument name="theme" default="ranking of emperors in Chinese history"}.

Require the AI to automatically derive and uniformly design the entire following visual system based on this theme, without my extra specification:
- Core subject (automatically judge suitability for people, products, architecture, artifacts, symbols, scenes, or abstract imagery)
- Bottom supporting structure
- Hovering symbols or spiritual symbols above
- Scene wrapping elements
- Metaphor system
- Color hierarchy
- Material contrast
- Lighting logic
- Title, subtitle, and auxiliary copy
- Brand sense and high-end expression

The final frame must be: a shocking, precise, unified, cinematic, ultra-high detail conceptual key visual poster suitable for high-end printing.

[Overall Style]
Ultra-realistic 3D commercial CGI rendering, merging cinematic lighting, luxury visual language, futuristic concept design, and epic composition. The image must have a "single main visual core," not messy, not like a collage, and not like a regular e-commerce poster.

[Automatic Derivation Rules]
AI must automatically decide based on the [theme]:
1. Core visual metaphor
2. Subject type and posture
3. Form of supporting structure
4. Form of suspended elements
5. Scene shell and spatial atmosphere
6. Main, auxiliary, and emphasis colors
7. Material combinations
8. Text temperament and layout style

[Composition Rules]
- Absolute sense of premium quality
- Strong central order, overall unity
- Allows for axial symmetry or epic composition near the central axis
- Clear visual gravity, forming clear levels from top to bottom
- Edge negative space is clean, restrained, and has room to breathe

[Visual Quality]
- Ultra-high detail
- Clear volumetric light
- Authentic materials
- Natural reflection, refraction, shadows, fog, and depth of field
- Overall standard of high-end brand campaign key visual / luxury invitation poster / conceptual editorial poster

[Typography System]
- Overall 90% visual, 10% text
- AI automatically generates the most matching main title and subtitle based on the [theme]
- Title must be concise, sharp, and powerful
- Text should be as minimal and accurate as possible; do not stack words

[Signature Requirement]
Naturally add the author signature in the bottom corner: @a9quant', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 88, '@A9Quant', 'https://x.com/A9Quant', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-88', '/images/case88.jpg', 'Gpt-image-2 Prompt: Please Automatically Generate a Top-tier Concept', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-087', 'Please Generate a High-design Character Relationship Map Poster', 'Template imported from awesome-gpt-image-2 case 087. Source: @MrLarus.', 'Charts & Infographics', 'Please generate a high-design character relationship map poster based on {argument name="theme" default="Demon Slayer"}. This image should not be a simple illustration, but a character relationship map that combines information visualization, narrative structure, poster design sense, and stylistic fidelity.

Please automatically complete the following:
- Identify the work and core settings corresponding to the theme
- Extract the most representative 6-12 key characters, not exceeding 15 if necessary
- Identify and display key character relationships, including blood ties, romance, friendship, alliances, hostility, master-disciple, etc.
- Automatically choose a composition method based on the work''s characteristics, such as protagonist-centered, dual-core confrontation, faction-based, family tree, or chronological evolution
- Automatically refine the work''s style DNA, including color, worldview symbols, textures, mood, typography, and representative elements
- Transform these stylistic elements into an overall visual design for the relationship map, rather than simply copying an official poster
- Use different colors, line types, and arrows to distinguish different relationships, ensuring clear lines and layers without clutter
- Make core characters most prominent, followed by important characters, and subordinate characters weakened to form a clear visual hierarchy
- Ensure every character name is legible, with identity or faction labels if necessary

The final product should satisfy:
- Immediate understanding of character hierarchy and key relationships
- Obvious alignment with the original work''s temperament and setting
- Combines the clarity of an infographic with the premium design of a poster
- Unified, exquisite, complete, and suitable for social media sharing or poster display
- Avoids a cheap flowchart feel, messy piling, and information overload.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 87, '@MrLarus', 'https://x.com/MrLarus', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-87', '/images/case87.jpg', 'Please Generate a High-design Character Relationship Map Poster', '["UI","Infographic","Poster"]'::jsonb, '["Commerce","Social","Travel"]'::jsonb, FALSE, TRUE),
    ('case-086', 'Please Generate a High-design Character Relationship Map Poster', 'Template imported from awesome-gpt-image-2 case 086. Source: @MrLarus.', 'Charts & Infographics', 'Please generate a high-design character relationship map poster based on {argument name="theme" default="Demon Slayer"}. This image should not be a simple illustration, but a character relationship map that combines information visualization, narrative structure, poster design sense, and stylistic fidelity.

Please automatically complete the following:
- Identify the work and core settings corresponding to the theme
- Extract the most representative 6-12 key characters, not exceeding 15 if necessary
- Identify and display key character relationships, including blood ties, romance, friendship, alliances, hostility, master-disciple, etc.
- Automatically choose a composition method based on the work''s characteristics, such as protagonist-centered, dual-core confrontation, faction-based, family tree, or chronological evolution
- Automatically refine the work''s style DNA, including color, worldview symbols, textures, mood, typography, and representative elements
- Transform these stylistic elements into an overall visual design for the relationship map, rather than simply copying an official poster
- Use different colors, line types, and arrows to distinguish different relationships, ensuring clear lines and layers without clutter
- Make core characters most prominent, followed by important characters, and subordinate characters weakened to form a clear visual hierarchy
- Ensure every character name is legible, with identity or faction labels if necessary

The final product should satisfy:
- Immediate understanding of character hierarchy and key relationships
- Obvious alignment with the original work''s temperament and setting
- Combines the clarity of an infographic with the premium design of a poster
- Unified, exquisite, complete, and suitable for social media sharing or poster display
- Avoids a cheap flowchart feel, messy piling, and information overload.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 86, '@MrLarus', 'https://x.com/MrLarus', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-86', '/images/case86.jpg', 'Please Generate a High-design Character Relationship Map Poster', '["UI","Infographic","Poster"]'::jsonb, '["Commerce","Social","Travel"]'::jsonb, FALSE, TRUE),
    ('case-085', 'Please Generate a High-design Character Relationship Map Poster', 'Template imported from awesome-gpt-image-2 case 085. Source: @MrLarus.', 'Charts & Infographics', 'Please generate a high-design character relationship map poster based on {argument name="theme" default="Demon Slayer"}. This image should not be a simple illustration, but a character relationship map that combines information visualization, narrative structure, poster design sense, and stylistic fidelity.

Please automatically complete the following:
- Identify the work and core settings corresponding to the theme
- Extract the most representative 6-12 key characters, not exceeding 15 if necessary
- Identify and display key character relationships, including blood ties, romance, friendship, alliances, hostility, master-disciple, etc.
- Automatically choose a composition method based on the work''s characteristics, such as protagonist-centered, dual-core confrontation, faction-based, family tree, or chronological evolution
- Automatically refine the work''s style DNA, including color, worldview symbols, textures, mood, typography, and representative elements
- Transform these stylistic elements into an overall visual design for the relationship map, rather than simply copying an official poster
- Use different colors, line types, and arrows to distinguish different relationships, ensuring clear lines and layers without clutter
- Make core characters most prominent, followed by important characters, and subordinate characters weakened to form a clear visual hierarchy
- Ensure every character name is legible, with identity or faction labels if necessary

The final product should satisfy:
- Immediate understanding of character hierarchy and key relationships
- Obvious alignment with the original work''s temperament and setting
- Combines the clarity of an infographic with the premium design of a poster
- Unified, exquisite, complete, and suitable for social media sharing or poster display
- Avoids a cheap flowchart feel, messy piling, and information overload.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 85, '@MrLarus', 'https://x.com/MrLarus', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-85', '/images/case85.jpg', 'Please Generate a High-design Character Relationship Map Poster', '["UI","Infographic","Poster"]'::jsonb, '["Commerce","Social","Travel"]'::jsonb, FALSE, TRUE),
    ('case-084', 'Please Generate a High-design Character Relationship Map Poster', 'Template imported from awesome-gpt-image-2 case 084. Source: @MrLarus.', 'Charts & Infographics', 'Please generate a high-design character relationship map poster based on {argument name="theme" default="Demon Slayer"}. This image should not be a simple illustration, but a character relationship map that combines information visualization, narrative structure, poster design sense, and stylistic fidelity.

Please automatically complete the following:
- Identify the work and core settings corresponding to the theme
- Extract the most representative 6-12 key characters, not exceeding 15 if necessary
- Identify and display key character relationships, including blood ties, romance, friendship, alliances, hostility, master-disciple, etc.
- Automatically choose a composition method based on the work''s characteristics, such as protagonist-centered, dual-core confrontation, faction-based, family tree, or chronological evolution
- Automatically refine the work''s style DNA, including color, worldview symbols, textures, mood, typography, and representative elements
- Transform these stylistic elements into an overall visual design for the relationship map, rather than simply copying an official poster
- Use different colors, line types, and arrows to distinguish different relationships, ensuring clear lines and layers without clutter
- Make core characters most prominent, followed by important characters, and subordinate characters weakened to form a clear visual hierarchy
- Ensure every character name is legible, with identity or faction labels if necessary

The final product should satisfy:
- Immediate understanding of character hierarchy and key relationships
- Obvious alignment with the original work''s temperament and setting
- Combines the clarity of an infographic with the premium design of a poster
- Unified, exquisite, complete, and suitable for social media sharing or poster display
- Avoids a cheap flowchart feel, messy piling, and information overload.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 84, '@MrLarus', 'https://x.com/MrLarus', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-84', '/images/case84.jpg', 'Please Generate a High-design Character Relationship Map Poster', '["UI","Infographic","Poster"]'::jsonb, '["Commerce","Social","Travel"]'::jsonb, FALSE, TRUE),
    ('case-083', ', Subtitle : Das Ziel: , Venue :', 'Template imported from awesome-gpt-image-2 case 083. Source: @NumeroBTC.', 'Posters & Typography', '{
  "type": "sports match infographic poster",
  "theme": "UEFA Champions League",
  "background": "dark blue and purple cosmic sky, glowing blue hexagonal lines, illuminated stadium reflecting on water at bottom",
  "header": {
    "logo": "UEFA Champions League",
    "title": "{argument name=\"stage\" default=\"HALBFINALE\"}",
    "subtitle": "DAS ZIEL: {argument name=\"location\" default=\"BUDAPEST 2026\"}",
    "venue": "PUSKÁS ARÉNA"
  },
  "matchup": {
    "player_left": "{argument name=\"team 1 player\" default=\"Harry Kane\"} in red FC Bayern kit",
    "player_right": "{argument name=\"team 2 player\" default=\"Ousmane Dembélé\"} in blue PSG kit",
    "center_logos": "FC Bayern München and Paris Saint-Germain with VS",
    "date_box": "calendar icon, MITTWOCH, {argument name=\"date\" default=\"06.05.2026\"}"
  },
  "facts_section": {
    "title": "FACTS",
    "count": 5,
    "items": [
      "Trophy icon: DIE KÖNIGSKLASSE 2025/26",
      "Bar chart icon: KANE IN TOPFORM",
      "Lightning bolt icon: DEMBÉLÉ ÜBERFLIEGER",
      "Two people icon: BISHER 14 DUELLE",
      "Stadium icon: BUDAPEST RUFT"
    ]
  },
  "footer": {
    "trophy": "Champions League trophy on right",
    "stadium_image": "Puskás Aréna at night",
    "tagline": "EIN TRAUM. EIN ZIEL. EIN TITEL.",
    "bottom_text": "ROAD TO BUDAPEST 2026"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 83, '@NumeroBTC', 'https://x.com/NumeroBTC', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-83', '/images/case83.jpg', ', Subtitle : Das Ziel: , Venue :', '["Infographic","Poster","Brand"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-082', ', Inset Diagram, Visuals : , Legend Count', 'Template imported from awesome-gpt-image-2 case 082. Source: @HumanOS_v2.', 'UI & Interfaces', '{
  "type": "scientific optical setup diagram",
  "main_setup": {
    "base": "optical breadboard table with grid of mounting holes",
    "beam": "red laser beam passing horizontally through all components",
    "top_grouping_brackets": [
      "{argument name=\"first component group\" default=\"Dual Modulation\"}",
      "4f Relay Optics",
      "Imaging Optics",
      "Detection"
    ],
    "components_left_to_right": [
      { "name": "Laser", "label": "{argument name=\"laser wavelength\" default=\"λ = 632.8 nm\"}", "appearance": "black rectangular box" },
      { "name": "SLM1", "label": "(Phase / Pol. Mod.)", "appearance": "black square device on post" },
      { "name": "Lens L1", "label": "(f1)", "appearance": "lens in black ring mount" },
      { "name": "Iris", "label": "Fourier Plane (Pupil Plane) / (Higher Orders Filtered)", "appearance": "black ring mount with dashed line above" },
      { "name": "HWP", "label": "(λ/2)", "appearance": "purple-tinted optic in black ring mount" },
      { "name": "Lens L2", "label": "(f1)", "appearance": "lens in black ring mount" },
      { "name": "SLM2", "label": "(Phase / Pol. Mod.)", "appearance": "black square device on post" },
      { "name": "Lens L3", "label": "(f2)", "appearance": "lens in black ring mount" },
      { "name": "Lens L4", "label": "(f2)", "appearance": "lens in black ring mount" },
      { "name": "Linear Polarizer", "label": "(Global Analyzer)", "appearance": "lens in black ring mount" },
      { "name": "Polarization Camera", "label": "POLARIZATION CAMERA", "appearance": "blue and black box camera" }
    ]
  },
  "inset_diagram": {
    "position": "bottom right, dashed border",
    "title": "{argument name=\"inset title\" default=\"Polarization Camera Micro-Polarizer Array\"} (Per-Pixel Analyzer)",
    "visuals": "4x4 grid of colored squares with white directional arrows",
    "legend_count": 4,
    "legend_labels": [
      "red right-arrow 0° (H)",
      "green up-arrow 90° (V)",
      "blue diagonal-arrow 45° (D)",
      "yellow diagonal-arrow 135° (A)"
    ]
  },
  "bottom_caption": {
    "figure_number": "Fig. 5.",
    "title": "{argument name=\"setup title\" default=\"Ellipsography Hardware Setup.\"}",
    "description": "{argument name=\"figure caption\" default=\"Our prototype display system employs a dual-modulation configuration to achieve simultaneous control of phase and polarization. A 4f relay optics setup transfers the modulated wavefront...\"}"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 82, '@HumanOS_v2', 'https://x.com/HumanOS_v2', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-82', '/images/case82.jpg', ', Inset Diagram, Visuals : , Legend Count', '["Infographic","Realistic"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-081', ', , , , , , , ,', 'Template imported from awesome-gpt-image-2 case 081. Source: @HumanOS_v2.', 'Other Use Cases', '{
  "type": "scientific hardware diagram",
  "layout": {
    "main_scene": "3D render of an optical table with a red laser beam passing through 11 aligned optical components mounted on black posts.",
    "top_brackets": [
      {"label": "Dual Modulation", "span": "SLM1"},
      {"label": "4f Relay Optics", "span": "Lens L1 to Lens L2"},
      {"label": "Imaging Optics", "span": "SLM2 to Lens L4"},
      {"label": "Detection", "span": "Camera"}
    ],
    "optical_components_left_to_right": [
      {"name": "Laser", "labels": ["Laser", "λ = {argument name=\"laser wavelength\" default=\"632.8 nm\"}"]},
      {"name": "SLM1", "labels": ["SLM1", "(Phase / Pol. Mod.)"]},
      {"name": "Lens L1", "labels": ["Lens L1", "(f1)"]},
      {"name": "Iris", "labels": ["Fourier Plane", "(Pupil Plane)", "Iris", "(Higher Orders Filtered)"]},
      {"name": "HWP", "labels": ["HWP", "(λ/2)"]},
      {"name": "Lens L2", "labels": ["Lens L2", "(f1)"]},
      {"name": "SLM2", "labels": ["SLM2", "(Phase / Pol. Mod.)"]},
      {"name": "Lens L3", "labels": ["Lens L3", "(f2)"]},
      {"name": "Lens L4", "labels": ["Lens L4", "(f2)"]},
      {"name": "Linear Polarizer", "labels": ["Linear", "-Polarizer", "(Global Analyzer)"]},
      {"name": "Polarization Camera", "labels": ["POLARIZATION CAMERA"]}
    ],
    "inset_box": {
      "position": "bottom right",
      "title": "Polarization Camera Micro-Polarizer Array (Per-Pixel Analyzer)",
      "grid": "4x4 grid of colored squares with directional arrows",
      "legend_count": 4,
      "legend_items": [
        "Red square, horizontal arrow, 0° (H)",
        "Green square, vertical arrow, 90° (V)",
        "Blue square, diagonal arrow, 45° (D)",
        "Yellow square, diagonal arrow, 135° (A)"
      ]
    },
    "bottom_caption": {
      "figure_prefix": "{argument name=\"figure number\" default=\"Fig. 5.\"}",
      "title": "{argument name=\"system name\" default=\"Ellipsography Hardware Setup.\"}",
      "text": "Paragraph of scientific text explaining the dual-modulation configuration, 4f relay optics, and polarization camera."
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 81, '@HumanOS_v2', 'https://x.com/HumanOS_v2', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-81', '/images/case81.jpg', ', , , , , , , ,', '["Infographic","Realistic","3D"]'::jsonb, '["Tech","Story"]'::jsonb, FALSE, TRUE),
    ('case-080', 'Transform the Provided Input Image into a Pose-and-light', 'Template imported from awesome-gpt-image-2 case 080. Source: @WOZ1Tx2JZ3kCeBj.', 'Other Use Cases', '[CORE TASK]
Transform the provided input image into a pose-and-light analysis sheet.

This is NOT a finished character illustration.
This is NOT a clothing sheet.
This is NOT a beauty-preserving redraw.

This is a white-line rough mannequin conversion.

[PRIMARY GOAL]
Extract and visualize only:
- pose structure
- body balance
- camera angle
- body line flow
- inferred light source placement
- illuminated areas and light intensity

[INPUT ROLE]
Use the provided image as the strict anchor for:
- pose
- camera angle
- body tilt
- weight distribution
- approximate lighting situation

Do NOT preserve:
- face rendering
- hairstyle rendering
- clothing detail
- accessories
- weapon detail
- background architecture
- character identity
- emotional expression

[FIGURE CONVERSION]
single rough mannequin-like human figure
white body contour lines
white internal construction lines
simple mannequin head
no face
no eyes
no mouth
no eyelashes
no personality
no individual identity

human figure should look like:
- rough pose mannequin
- anatomy proxy
- line-based body guide
- structural sketch
- white-line rough dummy

keep:
- pose readability
- silhouette flow
- head tilt
- torso direction
- pelvis direction
- limb placement

[BACKGROUND]
pure black background
negative-style dark field
no scenery
no props
no architecture
no environmental storytelling

[LINE STYLE]
rough white line drawing
clean but sketch-like
construction-line feeling
anatomy guide lines visible
joint flow visible
body contour emphasized
no polished illustration finish

[LIGHT ESTIMATION]
predict the likely light source positions from the input image
visualize the light sources and illuminated areas using green glow only

use green light intensity with variation:
- strongest green where the light directly hits
- medium green for wrap light
- soft green for reflected or fading light

mark the estimated light sources with labels and arrows such as:
- Main Light
- Rim Light
- Fill Light
- Floor Bounce
- Back Light
only if appropriate

IMPORTANT:
do not invent random lights
infer lighting from the original input image
if the lighting is ambiguous, keep the annotations simple and plausible

[GREEN LIGHT VISUALIZATION]
show green glow on:
- head / skull plane
- neck
- shoulders
- chest plane
- ribcage direction
- pelvis edge
- thigh planes
- knee contact points
- floor contact bounce if applicable

use green light not as decoration,
but as lighting analysis information

[POSE PRIORITY]
1. preserve pose structure
2. preserve camera angle
3. preserve body balance
4. preserve head-torso relationship
5. visualize likely light direction
6. show illuminated areas with readable green intensity variation

[NEGATIVE]
finished person,
cute girl,
detailed face,
hair rendering,
clothing rendering,
weapon emphasis,
beautiful anatomy', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 80, '@WOZ1Tx2JZ3kCeBj', 'https://x.com/WOZ1Tx2JZ3kCeBj', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-80', '/images/case80.jpg', 'Transform the Provided Input Image into a Pose-and-light', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-079', 'Transform the Provided Input Image into a Pose-and-light', 'Template imported from awesome-gpt-image-2 case 079. Source: @WOZ1Tx2JZ3kCeBj.', 'Other Use Cases', '[CORE TASK]
Transform the provided input image into a pose-and-light analysis sheet.

This is NOT a finished character illustration.
This is NOT a clothing sheet.
This is NOT a beauty-preserving redraw.

This is a white-line rough mannequin conversion.

[PRIMARY GOAL]
Extract and visualize only:
- pose structure
- body balance
- camera angle
- body line flow
- inferred light source placement
- illuminated areas and light intensity

[INPUT ROLE]
Use the provided image as the strict anchor for:
- pose
- camera angle
- body tilt
- weight distribution
- approximate lighting situation

Do NOT preserve:
- face rendering
- hairstyle rendering
- clothing detail
- accessories
- weapon detail
- background architecture
- character identity
- emotional expression

[FIGURE CONVERSION]
single rough mannequin-like human figure
white body contour lines
white internal construction lines
simple mannequin head
no face
no eyes
no mouth
no eyelashes
no personality
no individual identity

human figure should look like:
- rough pose mannequin
- anatomy proxy
- line-based body guide
- structural sketch
- white-line rough dummy

keep:
- pose readability
- silhouette flow
- head tilt
- torso direction
- pelvis direction
- limb placement

[BACKGROUND]
pure black background
negative-style dark field
no scenery
no props
no architecture
no environmental storytelling

[LINE STYLE]
rough white line drawing
clean but sketch-like
construction-line feeling
anatomy guide lines visible
joint flow visible
body contour emphasized
no polished illustration finish

[LIGHT ESTIMATION]
predict the likely light source positions from the input image
visualize the light sources and illuminated areas using green glow only

use green light intensity with variation:
- strongest green where the light directly hits
- medium green for wrap light
- soft green for reflected or fading light

mark the estimated light sources with labels and arrows such as:
- Main Light
- Rim Light
- Fill Light
- Floor Bounce
- Back Light
only if appropriate

IMPORTANT:
do not invent random lights
infer lighting from the original input image
if the lighting is ambiguous, keep the annotations simple and plausible

[GREEN LIGHT VISUALIZATION]
show green glow on:
- head / skull plane
- neck
- shoulders
- chest plane
- ribcage direction
- pelvis edge
- thigh planes
- knee contact points
- floor contact bounce if applicable

use green light not as decoration,
but as lighting analysis information

[POSE PRIORITY]
1. preserve pose structure
2. preserve camera angle
3. preserve body balance
4. preserve head-torso relationship
5. visualize likely light direction
6. show illuminated areas with readable green intensity variation

[NEGATIVE]
finished person,
cute girl,
detailed face,
hair rendering,
clothing rendering,
weapon emphasis,
beautiful anatomy', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 79, '@WOZ1Tx2JZ3kCeBj', 'https://x.com/WOZ1Tx2JZ3kCeBj', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-79', '/images/case79.jpg', 'Transform the Provided Input Image into a Pose-and-light', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-078', 'Transform the Provided Input Image into a Pose-and-light', 'Template imported from awesome-gpt-image-2 case 078. Source: @WOZ1Tx2JZ3kCeBj.', 'Other Use Cases', '[CORE TASK]
Transform the provided input image into a pose-and-light analysis sheet.

This is NOT a finished character illustration.
This is NOT a clothing sheet.
This is NOT a beauty-preserving redraw.

This is a white-line rough mannequin conversion.

[PRIMARY GOAL]
Extract and visualize only:
- pose structure
- body balance
- camera angle
- body line flow
- inferred light source placement
- illuminated areas and light intensity

[INPUT ROLE]
Use the provided image as the strict anchor for:
- pose
- camera angle
- body tilt
- weight distribution
- approximate lighting situation

Do NOT preserve:
- face rendering
- hairstyle rendering
- clothing detail
- accessories
- weapon detail
- background architecture
- character identity
- emotional expression

[FIGURE CONVERSION]
single rough mannequin-like human figure
white body contour lines
white internal construction lines
simple mannequin head
no face
no eyes
no mouth
no eyelashes
no personality
no individual identity

human figure should look like:
- rough pose mannequin
- anatomy proxy
- line-based body guide
- structural sketch
- white-line rough dummy

keep:
- pose readability
- silhouette flow
- head tilt
- torso direction
- pelvis direction
- limb placement

[BACKGROUND]
pure black background
negative-style dark field
no scenery
no props
no architecture
no environmental storytelling

[LINE STYLE]
rough white line drawing
clean but sketch-like
construction-line feeling
anatomy guide lines visible
joint flow visible
body contour emphasized
no polished illustration finish

[LIGHT ESTIMATION]
predict the likely light source positions from the input image
visualize the light sources and illuminated areas using green glow only

use green light intensity with variation:
- strongest green where the light directly hits
- medium green for wrap light
- soft green for reflected or fading light

mark the estimated light sources with labels and arrows such as:
- Main Light
- Rim Light
- Fill Light
- Floor Bounce
- Back Light
only if appropriate

IMPORTANT:
do not invent random lights
infer lighting from the original input image
if the lighting is ambiguous, keep the annotations simple and plausible

[GREEN LIGHT VISUALIZATION]
show green glow on:
- head / skull plane
- neck
- shoulders
- chest plane
- ribcage direction
- pelvis edge
- thigh planes
- knee contact points
- floor contact bounce if applicable

use green light not as decoration,
but as lighting analysis information

[POSE PRIORITY]
1. preserve pose structure
2. preserve camera angle
3. preserve body balance
4. preserve head-torso relationship
5. visualize likely light direction
6. show illuminated areas with readable green intensity variation

[NEGATIVE]
finished person,
cute girl,
detailed face,
hair rendering,
clothing rendering,
weapon emphasis,
beautiful anatomy', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 78, '@WOZ1Tx2JZ3kCeBj', 'https://x.com/WOZ1Tx2JZ3kCeBj', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-78', '/images/case78.jpg', 'Transform the Provided Input Image into a Pose-and-light', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-077', 'Please Generate a High-quality Vertical Based on', 'Template imported from awesome-gpt-image-2 case 077. Source: @alanlovelq.', 'Charts & Infographics', 'Please generate a high-quality vertical "Popular Science Encyclopedia Image" based on {argument name="theme" default="animals"}.

This image is not a regular poster or a simple illustration, but a modular popular science infographic that possesses a sense of "illustration book, encyclopedia, information structure, and collectability." The overall style should reference a combination of high-end natural history illustrations, modern encyclopedia pages, lifestyle knowledge cards, and highly shareable social media infographics.

Please include in the frame:
- A clear and beautiful main visual of the subject
- Several magnified details of local characteristics
- Multiple rounded modular information sections
- Clear title hierarchies and key labels
- Concise yet rich encyclopedic content
- Visual ratings, key point summaries, or Top 5 modules

Content columns should be automatically adapted based on the theme, prioritized from these directions: basic profile, classification information, appearance characteristics, habits/ecology, formation mechanism/structure, growth or use conditions, care or maintenance suggestions, risks and precautions, suitable audience or scenarios, pros and cons comparison, and quick rating cards.

Visual requirements:
Light-colored clean background, soft color palette, light shadows, exquisite small icons, rounded information boxes, neat layout, high information density but not crowded, good reading experience. The overall result must look like a real science encyclopedia card suitable for publishing, reading, collecting, and serialized production, rather than an advertisement.

Please do not make it a regular commercial promotional poster. Highlight the features of "knowledge organization + modular information + illustration-style display."', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 77, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-77', '/images/case77.jpg', 'Please Generate a High-quality Vertical Based on', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-076', 'Please Generate a High-quality Vertical Based on', 'Template imported from awesome-gpt-image-2 case 076. Source: @alanlovelq.', 'Charts & Infographics', 'Please generate a high-quality vertical "Popular Science Encyclopedia Image" based on {argument name="theme" default="animals"}.

This image is not a regular poster or a simple illustration, but a modular popular science infographic that possesses a sense of "illustration book, encyclopedia, information structure, and collectability." The overall style should reference a combination of high-end natural history illustrations, modern encyclopedia pages, lifestyle knowledge cards, and highly shareable social media infographics.

Please include in the frame:
- A clear and beautiful main visual of the subject
- Several magnified details of local characteristics
- Multiple rounded modular information sections
- Clear title hierarchies and key labels
- Concise yet rich encyclopedic content
- Visual ratings, key point summaries, or Top 5 modules

Content columns should be automatically adapted based on the theme, prioritized from these directions: basic profile, classification information, appearance characteristics, habits/ecology, formation mechanism/structure, growth or use conditions, care or maintenance suggestions, risks and precautions, suitable audience or scenarios, pros and cons comparison, and quick rating cards.

Visual requirements:
Light-colored clean background, soft color palette, light shadows, exquisite small icons, rounded information boxes, neat layout, high information density but not crowded, good reading experience. The overall result must look like a real science encyclopedia card suitable for publishing, reading, collecting, and serialized production, rather than an advertisement.

Please do not make it a regular commercial promotional poster. Highlight the features of "knowledge organization + modular information + illustration-style display."', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 76, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-76', '/images/case76.jpg', 'Please Generate a High-quality Vertical Based on', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-075', 'Please Generate a High-quality Vertical Based on', 'Template imported from awesome-gpt-image-2 case 075. Source: @alanlovelq.', 'Charts & Infographics', 'Please generate a high-quality vertical "Popular Science Encyclopedia Image" based on {argument name="theme" default="animals"}.

This image is not a regular poster or a simple illustration, but a modular popular science infographic that possesses a sense of "illustration book, encyclopedia, information structure, and collectability." The overall style should reference a combination of high-end natural history illustrations, modern encyclopedia pages, lifestyle knowledge cards, and highly shareable social media infographics.

Please include in the frame:
- A clear and beautiful main visual of the subject
- Several magnified details of local characteristics
- Multiple rounded modular information sections
- Clear title hierarchies and key labels
- Concise yet rich encyclopedic content
- Visual ratings, key point summaries, or Top 5 modules

Content columns should be automatically adapted based on the theme, prioritized from these directions: basic profile, classification information, appearance characteristics, habits/ecology, formation mechanism/structure, growth or use conditions, care or maintenance suggestions, risks and precautions, suitable audience or scenarios, pros and cons comparison, and quick rating cards.

Visual requirements:
Light-colored clean background, soft color palette, light shadows, exquisite small icons, rounded information boxes, neat layout, high information density but not crowded, good reading experience. The overall result must look like a real science encyclopedia card suitable for publishing, reading, collecting, and serialized production, rather than an advertisement.

Please do not make it a regular commercial promotional poster. Highlight the features of "knowledge organization + modular information + illustration-style display."', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 75, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-75', '/images/case75.jpg', 'Please Generate a High-quality Vertical Based on', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-074', 'Please Generate a High-quality Vertical Based on', 'Template imported from awesome-gpt-image-2 case 074. Source: @alanlovelq.', 'Charts & Infographics', 'Please generate a high-quality vertical "Popular Science Encyclopedia Image" based on {argument name="theme" default="animals"}.

This image is not a regular poster or a simple illustration, but a modular popular science infographic that possesses a sense of "illustration book, encyclopedia, information structure, and collectability." The overall style should reference a combination of high-end natural history illustrations, modern encyclopedia pages, lifestyle knowledge cards, and highly shareable social media infographics.

Please include in the frame:
- A clear and beautiful main visual of the subject
- Several magnified details of local characteristics
- Multiple rounded modular information sections
- Clear title hierarchies and key labels
- Concise yet rich encyclopedic content
- Visual ratings, key point summaries, or Top 5 modules

Content columns should be automatically adapted based on the theme, prioritized from these directions: basic profile, classification information, appearance characteristics, habits/ecology, formation mechanism/structure, growth or use conditions, care or maintenance suggestions, risks and precautions, suitable audience or scenarios, pros and cons comparison, and quick rating cards.

Visual requirements:
Light-colored clean background, soft color palette, light shadows, exquisite small icons, rounded information boxes, neat layout, high information density but not crowded, good reading experience. The overall result must look like a real science encyclopedia card suitable for publishing, reading, collecting, and serialized production, rather than an advertisement.

Please do not make it a regular commercial promotional poster. Highlight the features of "knowledge organization + modular information + illustration-style display."', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 74, '@alanlovelq', 'https://x.com/alanlovelq', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-74', '/images/case74.jpg', 'Please Generate a High-quality Vertical Based on', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-073', ', Highly Detailed Technical Illustration, 3d Isometric Cutaway', 'Template imported from awesome-gpt-image-2 case 073. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "complex urban systems atlas infographic",
  "style": "{argument name=\"color palette\" default=\"dark background with glowing blue, gold, and purple accents\"}, highly detailed technical illustration, 3D isometric cutaway",
  "header": {
    "title": "{argument name=\"chinese city name\" default=\"上海\"}城市系统剖面 {argument name=\"english city name\" default=\"SHANGHAI\"} URBAN SYSTEMS ATLAS",
    "subtitles": [
      "地表之上，是城市；地表之下，是秩序 {argument name=\"english subtitle\" default=\"Beneath the skyline lies the machine.\"}",
      "一座城市如何运转 How a Megacity Actually Works"
    ]
  },
  "layout": {
    "top_left": "Compass rose and city map labeled ''上海市域位置 SHANGHAI LOCATION''",
    "top_right": "Data table titled ''城市数据 CITY DATA'' with 7 rows of statistics",
    "centerpiece": {
      "description": "{argument name=\"centerpiece style\" default=\"highly detailed 3D isometric cutaway render\"} of a megacity river landscape",
      "layers": [
        "地面层 SURFACE",
        "排水层 DRAINAGE LAYER",
        "电力层 POWER LAYER",
        "通信层 COMMUNICATION LAYER",
        "轨道交通层 METRO LAYER",
        "道路隧道层 ROAD TUNNEL LAYER",
        "管廊综合层 UTILITY CORRIDOR LAYER"
      ]
    },
    "side_panels": [
      { "id": "01", "title": "城市主骨架 URBAN SKELETON", "elements": "Map with 8 legend items" },
      { "id": "02", "title": "排水与地下水网 DRAINAGE + STORMWATER", "elements": "Cross-section diagram ''典型排水剖面 DRAINAGE SECTION'' with 5 legend items" },
      { "id": "03", "title": "电网与能源分配 POWER GRID + ENERGY", "elements": "Cross-section diagram ''典型变电站剖面 SUBSTATION SECTION'' with 6 legend items" },
      { "id": "04", "title": "通信与网络骨干 TELECOM + INTERNET", "elements": "Cross-section diagram ''数据中心剖面 DATA CENTER SECTION'' with 6 legend items" },
      { "id": "05", "title": "地铁与地下交通 METRO + SUBSURFACE MOBILITY", "elements": "Cross-section diagram ''人民广场站剖面 PEOPLE''S SQUARE STATION'' with 6 legend items" },
      { "id": "06", "title": "道路、高架与循环 ROADS + ELEVATED MOBILITY", "elements": "Cross-section diagram ''南浦大桥剖面 NANPU BRIDGE SECTION'' with 6 legend items" },
      { "id": "07", "title": "管廊与地下设施 UTILITY CORRIDORS + PLUMBING", "elements": "Cross-section diagram ''综合管廊 UTILITY CORRIDOR'' with 8 legend items" },
      { "id": "08", "title": "城市流量与系统协同 URBAN FLOWS + COORDINATION", "elements": "Map diagram ''城市运行指挥中心 CITY OPERATIONS CENTER'' with 6 legend items" }
    ],
    "bottom_panels": {
      "system_logic": {
        "title": "城市系统协同逻辑 SYSTEM COORDINATION LOGIC",
        "steps": 4,
        "labels": ["感知层 SENSING LAYER", "网络层 NETWORK LAYER", "平台层 PLATFORM LAYER", "应用层 APPLICATION LAYER"]
      },
      "city_brain": {
        "title": "城市大脑 CITY BRAIN",
        "central_node": 1,
        "peripheral_nodes": 8
      },
      "references": {
        "depth_scale": { "title": "深度与尺度 DEPTH & SCALE REFERENCE", "icons": 5 },
        "map_scale": { "title": "比例尺 SCALE", "markers": 4 }
      }
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 73, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-73', '/images/case73.jpg', ', Highly Detailed Technical Illustration, 3d Isometric Cutaway', '["Infographic","Illustration","3D"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-072', ', Style : , Header : , English', 'Template imported from awesome-gpt-image-2 case 072. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "scientific botanical infographic poster",
  "subject": "{argument name=\"plant species\" default=\"Pomegranate (Punica granatum)\"}",
  "style": "vintage botanical illustration mixed with modern infographic design, highly detailed, {argument name=\"color palette\" default=\"earthy greens, deep reds, parchment background\"}",
  "header": {
    "main_title": "{argument name=\"main title\" default=\"植物生命路径剖面\"}",
    "english_title": "{argument name=\"english title\" default=\"BOTANICAL GROWTH ATLAS\"}",
    "subtitle": "从种子到果实，一株植物如何展开自己 / FROM SEED TO FRUIT"
  },
  "centerpiece": "full plant showing extensive root system, woody stem, green leaves, blooming red flowers, and ripe fruits including one halved to show seeds",
  "layout": {
    "numbered_sections": [
      { "number": 1, "title": "种子结构 / Seed Architecture", "content": "cross-section of a single seed with 6 labeled parts" },
      { "number": 2, "title": "萌发机制 / Germination Mechanism", "content": "sequence of 5 sprouting seeds showing radicle emergence" },
      { "number": 3, "title": "根系与地下网络 / Root System + Subsurface Intelligence", "content": "detailed root network with 2 circular microscopic cross-sections showing vascular bundles and hyphae" },
      { "number": 4, "title": "茎叶生长与维管系统 / Stem, Leaf & Vascular System", "content": "leaf detail and circular stem cross-section with 5 labeled layers" },
      { "number": 5, "title": "光合作用与能量转换 / Photosynthesis + Energy Conversion", "content": "3D cellular cross-section of a leaf showing mesophyll and chloroplasts, plus a chemical equation diagram" },
      { "number": 6, "title": "花芽分化与开花机制 / Bud Formation + Blooming", "content": "detailed flower cross-section showing stamen and ovary, plus a 4-season timeline" },
      { "number": 7, "title": "授粉与结果路径 / Pollination + Fruiting Pathway", "content": "bee approaching a flower cross-section, followed by a sequence of 5 stages of ovary development into a fruit" },
      { "number": 8, "title": "果实成熟与种子循环 / Fruit Maturation + Seed Cycle", "content": "ripe fruit breaking open, seeds dispersing downwards to a new sprout" }
    ],
    "additional_elements": [
      { "position": "bottom left", "title": "环境触发因素 / Environmental Triggers", "content": "grid of 6 weather/environmental icons and 6 nutrient element icons (N, P, K, Ca, Mg, Fe)" },
      { "position": "bottom edge", "title": "Growth Timeline", "content": "linear sequence of 19 small plant icons showing the complete life cycle from seed to mature plant" }
    ],
    "footer_quote": "{argument name=\"bottom quote\" default=\"理解植物，就是理解生命如何在时间中构建秩序。\"}"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 72, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-72', '/images/case72.jpg', ', Style : , Header : , English', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-071', ', Subtitles : , Top Left Box :', 'Template imported from awesome-gpt-image-2 case 071. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "technical infographic and exploded view diagram",
  "header": {
    "title": "{argument name=\"main title\" default=\"佳能 EOS R5 成像系统剖面 CANON EOS R5 IMAGING ATLAS\"}",
    "subtitles": [
      "一张照片是如何被制造出来的 HOW AN IMAGE IS ACTUALLY FORMED",
      "从光，到数据 | FROM PHOTONS TO FILES",
      "相机不是壳体，而是一条运算链 A camera is not a shell, but a computational chain"
    ],
    "top_left_box": {
      "title": "EOS R5 核心规格 KEY SPECIFICATIONS",
      "bullet_points_count": 6
    },
    "top_right_images": {
      "count": 2,
      "description": "front and back views of the camera body"
    }
  },
  "centerpiece": {
    "description": "highly detailed 3D exploded view of the {argument name=\"camera model\" default=\"Canon EOS R5\"} camera, showing internal components separated vertically",
    "components_visible": [
      "lens mount",
      "lens elements with glowing blue light rays",
      "image sensor",
      "motherboard with glowing {argument name=\"processor name\" default=\"DIGIC X\"} chip",
      "battery pack",
      "dual card slots",
      "electronic viewfinder (EVF)"
    ]
  },
  "layout": {
    "numbered_sections": [
      {
        "number": 1,
        "title": "光学入口 OPTICAL ENTRY",
        "elements": ["lens cross-section with light rays", "2 line graphs"]
      },
      {
        "number": 2,
        "title": "光圈、快门与曝光控制 APERTURE, SHUTTER, EXPOSURE",
        "elements": ["3 aperture blade diagrams", "4 shutter speed example photos", "depth of field diagram", "exposure triangle diagram"]
      },
      {
        "number": 3,
        "title": "对焦系统与成像平面 FOCUS ACQUISITION + IMAGE PLANE",
        "elements": ["lens alignment diagram", "AF coverage photo of a runner"]
      },
      {
        "number": 4,
        "title": "传感器与像素结构 SENSOR + PIXEL ARCHITECTURE",
        "elements": ["3D pixel array diagram", "single pixel cross-section diagram", "sensor spec table", "quantum efficiency graph"]
      },
      {
        "number": 5,
        "title": "防抖系统与机械稳定 IBIS + MECHANICAL STABILIZATION",
        "elements": ["sensor shift mechanism diagram with yaw/pitch/roll axes", "2 stabilization effect comparison photos"]
      },
      {
        "number": 6,
        "title": "模拟信号、模数转换与读出 ANALOG READOUT + A/D CONVERSION",
        "elements": ["signal flowchart", "3 readout timing graphs", "signal-to-noise ratio graph", "rolling shutter example photo of a car"]
      },
      {
        "number": 7,
        "title": "DIGIC X 图像处理链 DIGIC X IMAGE PROCESSING PIPELINE",
        "elements": ["processing flowchart with central chip", "dynamic range graph", "tone curve graph", "histogram"]
      },
      {
        "number": 8,
        "title": "文件生成、显示与存储 FILE OUTPUT, PREVIEW, STORAGE",
        "elements": ["file output flowchart", "2 storage card icons", "file workflow diagram"]
      }
    ],
    "bottom_comparisons": {
      "count": 5,
      "labels": [
        "传感器尺寸对比 SENSOR SIZE COMPARISON",
        "镜头焦距与视角 FOCAL LENGTH & ANGLE OF VIEW",
        "ISO 与噪点关系 ISO & NOISE RELATIONSHIP",
        "光圈与景深关系 APERTURE & DEPTH OF FIELD",
        "RAW vs JPEG"
      ]
    },
    "footer": "{argument name=\"footer quote\" default=\"光被捕获，数据被解读，影像被记录，记忆被永恒。 Light is captured. Data is interpreted. Image is recorded. Memory is eternal.\"}"
  },
  "style": "clean, technical, highly detailed, photorealistic components, blueprint-style annotations, light gray background, precise typography"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 71, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-71', '/images/case71.jpg', ', Subtitles : , Top Left Box :', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Education"]'::jsonb, FALSE, TRUE),
    ('case-070', ', Header : , Subtitle : , Centerpiece', 'Template imported from awesome-gpt-image-2 case 070. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "technical infographic",
  "subject": "{argument name=\"subject matter\" default=\"digital photography process\"}",
  "header": {
    "title": "{argument name=\"main title\" default=\"一张照片诞生的因果链 THE CAUSAL CHAIN OF A PHOTOGRAPH\"}",
    "subtitle": "从世界，到图像 FROM WORLD TO IMAGE"
  },
  "centerpiece": {
    "description": "Exploded isometric view of a modern mirrorless camera",
    "model": "{argument name=\"camera model\" default=\"Canon EOS R5\"}",
    "labeled_parts_count": 12,
    "labeled_parts": [
      "EVF",
      "Body Structure",
      "Control Dials",
      "Thermal Design",
      "Optical Axis",
      "IBIS Stabilizer",
      "Shutter Unit",
      "Full-Frame Sensor",
      "{argument name=\"processor name\" default=\"DIGIC X Processor\"}",
      "Main PCB",
      "High-Speed Bus",
      "Card Slot"
    ]
  },
  "layout": {
    "left_column": {
      "description": "Chronological causal chain",
      "count": 13,
      "steps": [
        "01 REALITY EXISTS",
        "02 PHOTONS LEAVE THE WORLD",
        "03 LENS ACCEPTS & BENDS LIGHT",
        "04 APERTURE SELECTS",
        "05 SHUTTER CUTS TIME",
        "06 FOCUS SETS PRIORITY",
        "07 SENSOR RECEIVES EVENT",
        "08 LIGHT BECOMES CHARGE",
        "09 ANALOG READOUT",
        "10 A/D CONVERSION",
        "11 COMPUTATION RECONSTRUCTS",
        "12 IMAGE APPEARS",
        "13 MEMORY OUTLIVES"
      ]
    },
    "right_column": {
      "title": "八大模块 / 8 MODULES",
      "count": 8,
      "modules": [
        "1 ORIGIN OF LIGHT",
        "2 LENS SHAPES REALITY",
        "3 APERTURE & SHUTTER EDIT THE WORLD",
        "4 FOCUS DECIDES CLARITY",
        "5 SENSOR MEASURES LIGHT",
        "6 SIGNAL BORN & AMPLIFIED",
        "7 COMPUTATION BUILDS IMAGE",
        "8 FILE BECOMES MEMORY"
      ]
    },
    "side_diagrams": {
      "count": 7,
      "descriptions": [
        "Ray cone & image formation",
        "Aperture & depth of field",
        "Shutter & motion",
        "Focal plane & clarity",
        "Pixel structure",
        "Photoelectric conversion",
        "Analog signal waveform"
      ]
    },
    "footer": {
      "count": 5,
      "description": "Philosophical summary points"
    }
  },
  "style": "technical, precise, wireframe elements, glowing data lines, photorealistic camera components, clean typography, dual-language"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 70, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-70', '/images/case70.jpg', ', Header : , Subtitle : , Centerpiece', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-069', ', Title En : , Subtitle : ,', 'Template imported from awesome-gpt-image-2 case 069. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "comprehensive medical infographic",
  "style": "highly detailed 3D medical illustration, clinical white background, clean typography",
  "header": {
    "title_cn": "{argument name=\"main title\" default=\"痛风诞生的因果链\"}",
    "title_en": "{argument name=\"english title\" default=\"THE CAUSAL CHAIN OF GOUT\"}",
    "subtitle": "Pain is not the beginning. Metabolic imbalance is.",
    "top_right_sequence": {
      "count": 6,
      "labels": ["Metabolism", "Transport", "Crystallization", "Immunity", "Inflammation", "Damage"]
    }
  },
  "centerpiece": {
    "description": "{argument name=\"central figure\" default=\"transparent anatomical human body showing liver, kidneys, and vascular system\"}",
    "details": "pathway highlighted in {argument name=\"highlight color\" default=\"glowing red\"} descending to the foot"
  },
  "layout": {
    "left_column": [
      { "id": "01", "title": "Purine Sources", "elements": 6, "labels": ["Red meat", "Organ meats", "Seafood", "Beer", "Endogenous", "Fructose"] },
      { "id": "02", "title": "Uric Acid Production", "elements": 2, "labels": ["Chemical pathway", "Liver"] },
      { "id": "03", "title": "Renal & Intestinal Excretion", "elements": 2, "labels": ["Kidney nephron", "Intestines"] },
      { "id": "04", "title": "Hyperuricemia", "elements": 2, "labels": ["Blood vial", "Solubility graph"] }
    ],
    "center_overlay": [
      { "id": "05", "title": "Crystal Physics", "elements": 3, "labels": ["Supersaturation beaker", "Precipitation beaker", "Molecular structure"] },
      { "id": "06", "title": "Joint Deposition & Local Environment", "elements": 1, "labels": ["First MTP joint cross-section"] }
    ],
    "right_column": [
      { "id": "07", "title": "Immune Inflammatory Cascade", "elements": 4, "labels": ["Macrophage", "Inflammasome", "Neutrophil", "Cytokines"] },
      { "id": "08", "title": "Acute Gout Flare", "elements": 1, "labels": ["Inflamed foot"] },
      { "id": "09", "title": "Chronic Structural Damage", "elements": 1, "labels": ["Bone erosion joint"] },
      { "id": "10", "title": "Tophus Formation", "elements": 2, "labels": ["Hand tophi", "Foot tophi"] },
      { "id": "11", "title": "Beyond the Joint", "elements": 2, "labels": ["Kidney stones", "Systemic burden"] }
    ],
    "bottom_row": [
      { "id": "12", "title": "Pain Is the Final Signal", "elements": 7, "labels": ["Increased Purine", "Overproduction", "Reduced Excretion", "Hyperuricemia", "Crystal Formation", "Immune Activation", "Man in pain"] }
    ]
  },
  "theme": "{argument name=\"disease focus\" default=\"gout and uric acid crystallization\"}"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 69, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-69', '/images/case69.jpg', ', Title En : , Subtitle : ,', '["Infographic","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-068', ', Title En : , Subtitle : ,', 'Template imported from awesome-gpt-image-2 case 068. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "comprehensive medical infographic",
  "style": "highly detailed 3D medical illustration, clinical white background, clean typography",
  "header": {
    "title_cn": "{argument name=\"main title\" default=\"痛风诞生的因果链\"}",
    "title_en": "{argument name=\"english title\" default=\"THE CAUSAL CHAIN OF GOUT\"}",
    "subtitle": "Pain is not the beginning. Metabolic imbalance is.",
    "top_right_sequence": {
      "count": 6,
      "labels": ["Metabolism", "Transport", "Crystallization", "Immunity", "Inflammation", "Damage"]
    }
  },
  "centerpiece": {
    "description": "{argument name=\"central figure\" default=\"transparent anatomical human body showing liver, kidneys, and vascular system\"}",
    "details": "pathway highlighted in {argument name=\"highlight color\" default=\"glowing red\"} descending to the foot"
  },
  "layout": {
    "left_column": [
      { "id": "01", "title": "Purine Sources", "elements": 6, "labels": ["Red meat", "Organ meats", "Seafood", "Beer", "Endogenous", "Fructose"] },
      { "id": "02", "title": "Uric Acid Production", "elements": 2, "labels": ["Chemical pathway", "Liver"] },
      { "id": "03", "title": "Renal & Intestinal Excretion", "elements": 2, "labels": ["Kidney nephron", "Intestines"] },
      { "id": "04", "title": "Hyperuricemia", "elements": 2, "labels": ["Blood vial", "Solubility graph"] }
    ],
    "center_overlay": [
      { "id": "05", "title": "Crystal Physics", "elements": 3, "labels": ["Supersaturation beaker", "Precipitation beaker", "Molecular structure"] },
      { "id": "06", "title": "Joint Deposition & Local Environment", "elements": 1, "labels": ["First MTP joint cross-section"] }
    ],
    "right_column": [
      { "id": "07", "title": "Immune Inflammatory Cascade", "elements": 4, "labels": ["Macrophage", "Inflammasome", "Neutrophil", "Cytokines"] },
      { "id": "08", "title": "Acute Gout Flare", "elements": 1, "labels": ["Inflamed foot"] },
      { "id": "09", "title": "Chronic Structural Damage", "elements": 1, "labels": ["Bone erosion joint"] },
      { "id": "10", "title": "Tophus Formation", "elements": 2, "labels": ["Hand tophi", "Foot tophi"] },
      { "id": "11", "title": "Beyond the Joint", "elements": 2, "labels": ["Kidney stones", "Systemic burden"] }
    ],
    "bottom_row": [
      { "id": "12", "title": "Pain Is the Final Signal", "elements": 7, "labels": ["Increased Purine", "Overproduction", "Reduced Excretion", "Hyperuricemia", "Crystal Formation", "Immune Activation", "Man in pain"] }
    ]
  },
  "theme": "{argument name=\"disease focus\" default=\"gout and uric acid crystallization\"}"
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 68, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-68', '/images/case68.jpg', ', Title En : , Subtitle : ,', '["Infographic","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-067', ', Language : , Header : , English', 'Template imported from awesome-gpt-image-2 case 067. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "medical infographic poster",
  "style": "highly detailed anatomical illustrations, clean structured layout, scientific diagrammatic style",
  "color_palette": "{argument name=\"color palette\" default=\"medical red, blue, beige, and anatomical flesh tones\"}",
  "language": "{argument name=\"language\" default=\"bilingual Chinese and English\"}",
  "header": {
    "main_title": "{argument name=\"main title\" default=\"糖尿病诞生的因果链\"}",
    "english_title": "{argument name=\"english title\" default=\"THE CAUSAL CHAIN OF DIABETES\"}",
    "subtitle": "从胰岛素失灵，到高血糖，到全身损伤"
  },
  "layout": {
    "centerpiece": "{argument name=\"central subject\" default=\"transparent human body showing circulatory system and internal organs\"}",
    "sections_count": 14,
    "sections": [
      { "id": "01", "title": "葡萄糖进入生命", "visuals": ["stomach and intestines"] },
      { "id": "02", "title": "胰腺与胰岛素", "visuals": ["pancreas", "beta cell"] },
      { "id": "03", "title": "正常胰岛素作用", "visuals": ["receptor signaling diagram", "muscle, liver, adipose icons"] },
      { "id": "04", "title": "胰岛素抵抗: 2型通路开始", "visuals": ["receptor blockage diagram", "7 lifestyle icons"] },
      { "id": "05", "title": "肝脏持续释放葡萄糖", "visuals": ["liver"] },
      { "id": "06", "title": "β细胞衰竭: 代偿到失败", "visuals": ["beta-cell decline line chart"] },
      { "id": "07", "title": "1型糖尿病分支", "visuals": ["autoimmune destruction diagram"] },
      { "id": "08", "title": "高血糖与血液化学", "visuals": ["blood vessel with glucose", "glucose indicators table", "glucose variability chart"] },
      { "id": "09", "title": "高血糖导致组织损伤", "visuals": ["4 pathways of damage diagrams"] },
      { "id": "10", "title": "急性代谢后果", "visuals": ["7 symptom icons"] },
      { "id": "11", "title": "微血管并发症", "visuals": ["eye", "kidney", "nerve cross-section"] },
      { "id": "12", "title": "大血管并发症与组织损伤", "visuals": ["heart", "brain", "diabetic foot"] },
      { "id": "13", "title": "器官系统长期代价", "visuals": ["text list"] },
      { "id": "14", "title": "糖尿病是调控系统失灵", "visuals": ["metabolic control flowchart"] }
    ],
    "footer": {
      "core_message": "核心信息 CORE MESSAGE"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 67, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-67', '/images/case67.jpg', ', Language : , Header : , English', '["Infographic","Poster","Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-066', ', Subtitle : , Style : , Layout,', 'Template imported from awesome-gpt-image-2 case 066. Source: @hx831126.', 'Charts & Infographics', '{
  "type": "fashion design process infographic",
  "title": "{argument name=\"main title\" default=\"一件女装诞生的因果链 THE CAUSAL CHAIN OF A WOMEN''S GARMENT\"}",
  "subtitle": "从纤维，到版型，到上身 FROM FIBER TO FIT",
  "style": {
    "aesthetic": "elegant editorial, technical fashion illustration, highly detailed",
    "color_palette": "{argument name=\"color palette\" default=\"beige, cream, and neutral tones\"}"
  },
  "layout": {
    "centerpiece": {
      "description": "Exploded-view illustration of a {argument name=\"garment type\" default=\"women''s trench coat dress\"} showing cascading layers of fabric, pattern pieces, and stitching lines. Top shows a model wearing the finished garment.",
      "central_list": {
        "count": 13,
        "type": "numbered steps with pointer lines",
        "labels": ["01 Material", "02 Inspiration", "03 Sketch", "04 Fabric", "05 Draping", "06 Pattern", "07 Sewing", "08 Fitting", "09 Revision", "10 Team", "11 Construction", "12 Garment", "13 Collaboration"]
      }
    },
    "left_column": [
      {
        "module": "MODULE 1: RAW MATERIAL AND FABRIC",
        "count": 6,
        "items": ["Fiber", "Yarn Structure", "Fabric Construction", "Weight", "Drape", "Surface Texture"]
      },
      {
        "module": "MODULE 2: INSPIRATION AND DIRECTION",
        "count": 5,
        "items": ["Inspiration Source", "Color Direction", "Woman Image", "Occasion Positioning", "Silhouette Intention"]
      },
      {
        "module": "MODULE 3: DESIGN SKETCH AND SILHOUETTE",
        "count": 7,
        "items": ["Design Sketch", "Construction Line", "Front Back Relationship", "Neckline", "Shoulder Line", "Waist Line", "Hem Proportion"]
      }
    ],
    "right_column": [
      {
        "module": "MODULE 4: PATTERNMAKING AND DRAPING",
        "count": 6,
        "items": ["Draping", "Patternmaking", "Dart", "Panel Line", "Ease", "Grain Direction"]
      },
      {
        "module": "MODULE 5: CUTTING AND SAMPLING",
        "count": 5,
        "items": ["Cutting", "Layout", "Sample Sewing", "Construction Sequence", "Technique Test"]
      },
      {
        "module": "MODULE 6: FITTING AND REVISION",
        "count": 4,
        "items": ["Fitting", "Fit Issues", "Before", "After"]
      }
    ],
    "bottom_row": [
      {
        "module": "MODULE 7: TEAM COLLABORATION",
        "count": 8,
        "items": ["Designer", "Patternmaker", "Fabric Buyer", "Sample Maker", "Merchandiser", "QC", "Feedback Loop", "Model"]
      },
      {
        "module": "MODULE 8: FINAL GARMENT PRESENTATION",
        "count": 3,
        "items": ["Details", "Finished Front & Back", "Labels & Care"]
      },
      {
        "module": "MODULE 9: FINAL WEAR",
        "count": 3,
        "items": ["Drape", "Proportion", "Movement in Motion"]
      },
      {
        "module": "MODULE 10: THE CHAIN SUMMARY",
        "count": 8,
        "items": ["Material Foundation", "Aesthetic Judgment", "Structural Engineering", "Craft Realization", "Body Negotiation", "Team Collaboration", "Iterative Revision", "Final Garment"]
      }
    ],
    "footer": "{argument name=\"footer text\" default=\"一件成衣，因无数判断而存在 A garment exists because of countless decisions.\"}"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 66, '@hx831126', 'https://x.com/hx831126', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-66', '/images/case66.jpg', ', Subtitle : , Style : , Layout,', '["Infographic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-065', 'A Breathtaking and Extremely Complex World-building Infographic Masterpiece', 'Template imported from awesome-gpt-image-2 case 065. Source: @GeekCatX.', 'Charts & Infographics', 'A breathtaking and extremely complex world-building infographic masterpiece conceptualizing the "{argument name="theme" default="Fundamental Differences between Confucianism, Buddhism, and Taoism"}", designed as a profound {argument name="style" default="ancient Oriental mythological manuscript"}.
Background: Pure white vintage textured canvas with a light beige aged parchment base color, subtle frayed edges, and water stain textures.
Core Layout: Central vision uses a grand "vertical egg-shaped layered structure", with Buddhism, Taoism, and Confucianism layers from top to bottom.
Margins: Four corners are decorated with fine micro-illustrations featuring ancient observation notes, ritual implements, and runes.
Colors: Low-saturation sage green, light gold, and off-white as main tones; overall light and soft without harsh high-saturation colors.
Details: Architectural lines, landscape brushwork, lotus patterns, and cloud layers are clearly visible and exquisitely detailed.
Seamless Fusion: The three layers transition naturally through clouds and flowing water; the Buddhist halo, Taoist Taiji mist, and Confucian scholarly aura connect seamlessly.
Style: Classical ink line art + low-saturation digital watercolor, with a light Chinese-style ancient book manuscript texture.
Text Annotations: Authentic Traditional Chinese characters in a mottled vintage Song typeface. Each annotation includes a short title + a line of poetic description, connected to corresponding details by dark gold hair-thin lines with no overlapping pointers.
Aspect Ratio: {argument name="aspect ratio" default="3:4"} vertical format, independent and complete.

Title Area (Top): `儒釋道·根本區別` (Confucianism, Buddhism, Taoism: Fundamental Differences)
Central Layer Labels:
Top "Buddhism": `釋`, `Relationship between man and self`, `Selflessness, governing the heart, letting go`
Middle "Taoism": `道`, `Relationship between man and all things`, `Non-action, governing the body, being open-minded`
Bottom "Confucianism": `儒`, `Relationship between man and man`, `No ego, governing the world, taking responsibility`
Side Annotations:
Left: `Purity`: pure heart and clear mind, cutting off troubles; `Stillness`: following nature, returning to the original heart; `Respect`: respecting responsibility, active involvement in society.
Right: `60+ Spiritual Cultivation`: looking lightly at gain/loss; `35-55 Conduct`: living with flexibility, following laws; `7-35 Actions`: forging ahead, building careers.
Bottom Summary: `The balance between being in the world and being out of the world is high-level life wisdom.`', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 65, '@GeekCatX', 'https://x.com/GeekCatX', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-65', '/images/case65.jpg', 'A Breathtaking and Extremely Complex World-building Infographic Masterpiece', '["UI","Infographic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-064', ', Character : , Layout : , Subtitle', 'Template imported from awesome-gpt-image-2 case 064. Source: @j_zou93.', 'Charts & Infographics', '{"type":"infographic poster","style":"cute flat vector illustration, cozy, warm, soft shading, {argument name=\"color palette\" default=\"pastel Morandi colors, soft pinks, purples, and warm tones\"}","character":"{argument name=\"character description\" default=\"young woman with shoulder-length brown hair wearing a pinkish-purple shirt\"}","layout":{"structure":"4 rows, 3 columns. Top row is a merged header. Rows 2-4 contain 9 individual panels.","header":{"title":"{argument name=\"main title\" default=\"情绪不好了？\"}","subtitle":"{argument name=\"subtitle\" default=\"8个让你瞬间变好的方法\"}","sub_subtitle":"写给焦虑的你，快来看看","visual":"character hugging herself, surrounded by yellow sparkles and hearts"},"grid_panels":[{"id":1,"title":"1. 深呼吸","text":"调节神经，缓解紧张情绪。","visual":"character with eyes closed, smiling, surrounded by clouds"},{"id":2,"title":"2. 去户外散步","text":"接触自然，让心静下来。","visual":"character walking outdoors among green trees and bushes"},{"id":3,"title":"3. 写情绪日记","text":"把烦恼写下，大脑会更轻松。","visual":"character sitting at a desk writing in a notebook with a pen, floating hearts"},{"id":4,"title":"4. 抱抱自己","text":"给予自己温暖和安慰。","visual":"character hugging herself with eyes closed, floating hearts"},{"id":5,"title":"5. 听听音乐","text":"让舒缓的旋律治愈心灵。","visual":"character wearing large white headphones, eyes closed, floating colorful music notes"},{"id":6,"title":"6. 找人倾诉","text":"分享你的烦恼，让压力释放。","visual":"character holding a smartphone, talking to another similar-looking girl, floating hearts"},{"id":7,"title":"7. 看看天空","text":"感受天空的辽阔，让心情变好。","visual":"character looking up at a blue sky with white clouds and sparkles"},{"id":8,"title":"8. 冥想","text":"专注于呼吸，找回内心的宁静。","visual":"an open notebook, a pen, and a pink flower on a desk"},{"id":9,"title":"none","text":"{argument name=\"footer text\" default=\"转发收藏，每天都要关爱自己！\"}","visual":"character sitting cross-legged in a meditation pose, eyes closed, with a glowing halo behind her head"}]}}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 64, '@j_zou93', 'https://x.com/j_zou93', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-64', '/images/case64.jpg', ', Character : , Layout : , Subtitle', '["Infographic","Poster","Illustration"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-063', ', Panels : , Layout Elements : ,', 'Template imported from awesome-gpt-image-2 case 063. Source: @masapark95.', 'Posters & Typography', '{"type": "2x2 grid of promotional banner ads", "theme": "{argument name=\"course theme\" default=\"Social Media Content Creation School\"}", "panels": [{"position": "top-left", "color_palette": "light blue and pink pastel gradient", "subject": "young woman smiling, resting chin on hand, smartphone and ring light in foreground", "typography": {"headline": "{argument name=\"top left headline\" default=\"発信を仕事に変える SNSスクール\"}", "subheadings": ["好きが、私の未来になる！", "クリエイター志望歓迎！"]}, "layout_elements": {"bullet_points_count": 3, "call_to_action_button": "pink button labeled ''無料体験 >''"}}, {"position": "top-right", "color_palette": "deep blue and cyan geometric", "subject": "young man looking intently at a professional camera on a tripod with a ring light", "typography": {"headline": "{argument name=\"top right headline\" default=\"魅せる投稿が学べる\"}", "subheadings": ["企画・撮影・運用サポート"]}, "layout_elements": {"circular_icons_count": 3, "icon_types": ["lightbulb", "camera", "bar chart"], "call_to_action_button": "yellow button labeled ''詳細はこちら >''"}}, {"position": "bottom-left", "color_palette": "soft beige and white aesthetic", "subject": "young woman looking thoughtfully to the side, mood board background", "typography": {"headline": "{argument name=\"bottom left headline\" default=\"自分の世界観を育てる\"}", "subheadings": ["あなたらしさが、一番の強みになる。", "SNSブランディング講座"]}, "layout_elements": {"horizontal_icons_count": 3, "icon_types": ["palette", "person", "heart"], "call_to_action_button": "pink button labeled ''今すぐ見る >''"}}, {"position": "bottom-right", "color_palette": "vibrant pink and magenta pop design", "subject": "young woman smiling brightly, pointing at text, messy bun, smartphone on tripod", "typography": {"headline": "{argument name=\"bottom right headline\" default=\"好きな発信でファンをつくる\"}", "subheadings": ["実践型レッスン"]}, "layout_elements": {"bullet_points_count": 4, "call_to_action_button": "yellow button labeled ''申し込む >''"}}]}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 63, '@masapark95', 'https://x.com/masapark95', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-63', '/images/case63.jpg', ', Panels : , Layout Elements : ,', '["Poster","Realistic"]'::jsonb, '["Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-062', 'For , Design Style : , Layout :', 'Template imported from awesome-gpt-image-2 case 062. Source: @masapark95.', 'Posters & Typography', '{
  "type": "2x2 grid of banner advertisements",
  "theme": "{argument name=\"main theme\" default=\"SNSスクール\"} for {argument name=\"target audience\" default=\"ママ\"}",
  "design_style": "soft, approachable, bright lighting, featuring {argument name=\"color palette\" default=\"soft green, white, and natural beige tones\"}",
  "layout": {
    "sections": [
      {
        "position": "top-left",
        "visual_style": "photography",
        "image_description": "Smiling woman working on a laptop at a table, a toddler playing with toys in the blurred background.",
        "headlines": ["ママの"やってみたい"を応援！", "子育てしながら学べる", "SNSスクール"],
        "features": {
          "count": 1,
          "type": "icon with text",
          "labels": ["自宅で無理なくスキルアップ (with house icon)"]
        },
        "call_to_action_button": "無料相談"
      },
      {
        "position": "top-right",
        "visual_style": "photography",
        "image_description": "Smiling woman holding a white mug, looking at a laptop.",
        "headlines": ["ちょっとの時間が、大きな一歩に。", "スキマ時間を未来につなげる", "動画講座で学びやすい"],
        "features": {
          "count": 3,
          "type": "circular icons with text below",
          "labels": ["スマホでも学べる (smartphone icon)", "1日15分からOK (clock icon)", "繰り返し視聴できる (play button icon)"]
        },
        "call_to_action_button": "詳しく見る"
      },
      {
        "position": "bottom-left",
        "visual_style": "watercolor illustration",
        "image_description": "Illustration of a woman with hair in a bun, smiling at a laptop with a green mug nearby.",
        "headlines": ["はじめてでも大丈夫！ (with beginner mark)", "在宅でできるSNSの仕事", "未経験OK"],
        "features": {
          "count": 3,
          "type": "circular icons with text below",
          "labels": ["サポート充実 (heart icon)", "パソコンが苦手でも安心 (laptop icon)", "収入の柱をつくれる (yen coin icon)"]
        },
        "call_to_action_button": "体験してみる"
      },
      {
        "position": "bottom-right",
        "visual_style": "photography",
        "image_description": "Smiling mother and young daughter sitting on a sofa reading a picture book together.",
        "headlines": ["家族との時間も大切に", "自分らしい働き方へ", "ママの笑顔がいちばんの未来になる。"],
        "features": {
          "count": 3,
          "type": "checkmark bullet points",
          "labels": ["場所や時間に縛られない", "やりがいも収入も叶う", "子どもの成長をそばで見守れる"]
        },
        "extra_graphics": "Small illustration of a house and trees at the bottom left.",
        "call_to_action_button": "説明会へ"
      }
    ],
    "common_elements": "All panels feature a {argument name=\"button style\" default=\"rounded green pill button with white text and a right-pointing arrow icon\"} at the bottom."
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 62, '@masapark95', 'https://x.com/masapark95', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-62', '/images/case62.jpg', 'For , Design Style : , Layout :', '["Realistic","Illustration","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-061', ', Target Audience : , Layout : ,', 'Template imported from awesome-gpt-image-2 case 061. Source: @masapark95.', 'Posters & Typography', '{
  "type": "2x2 grid of banner advertisements",
  "theme": "{argument name=\"school name\" default=\"SNSスクール\"}",
  "target_audience": "{argument name=\"target audience\" default=\"学生\"}",
  "layout": {
    "grid": "2x2",
    "panels": [
      {
        "position": "top-left",
        "style": "dark neon, blue and purple",
        "subject": "young woman looking up hopefully, holding a smartphone, wearing a purple sweatshirt",
        "main_text": "{argument name=\"banner 1 headline\" default=\"SNSを仕事にしたい人へ\"}",
        "sub_text": ""好き"をカタチに。未来を変える一歩を、今。",
        "elements": [
          "white and yellow typography",
          "yellow call-to-action button: チェックする >",
          "hand-drawn neon accents (crown, stars, heart)"
        ]
      },
      {
        "position": "top-right",
        "style": "bright, pop, cyan and white",
        "subject": "young woman smiling directly at camera, holding a smartphone, wearing a teal hoodie, hair in a bun",
        "main_text": "{argument name=\"banner 2 headline\" default=\"好きな発信を武器にする\"}",
        "sub_text": "企画・編集・投稿を学ぶ",
        "elements": [
          "torn paper texture backgrounds for text",
          "yellow starburst sticker: 無料体験",
          "3 feature icons with text: lightbulb (企画力), pencil (編集力), paper plane (投稿力)"
        ]
      },
      {
        "position": "bottom-left",
        "style": "dark, analytical, neon purple and green",
        "subject": "young man looking thoughtfully at his smartphone, wearing a black hoodie",
        "main_text": "{argument name=\"banner 3 headline\" default=\"バズるだけじゃない 分析まで学べる\"}",
        "sub_text": "#伸びる理由がわかると、もっと伸ばせる。",
        "elements": [
          "3 floating holographic data panels with line graphs and stats (125.6万, 23.8%, 12.6%)",
          "3 feature icons at bottom: bar chart (データ分析), magnifying glass (改善提案), target (成果につなげる)",
          "yellow call-to-action button: 詳しく見る >"
        ]
      },
      {
        "position": "bottom-right",
        "style": "bright, friendly, purple and white",
        "subject": "group of 4 young people (3 women, 1 man) huddled together smiling at a smartphone",
        "main_text": "SNSで未来の可能性を広げよう",
        "sub_text": "仲間と学べるコミュニティ",
        "elements": [
          "torn paper texture backgrounds for text",
          "3 bullet points with icons (people, speech bubbles, rising chart)",
          "2 polaroid-style inset photos showing students studying at a desk",
          "yellow call-to-action button: 今すぐ参加 >"
        ]
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 61, '@masapark95', 'https://x.com/masapark95', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-61', '/images/case61.jpg', ', Target Audience : , Layout : ,', '["Poster","Realistic"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-060', 'Case 060 Illustration and Art Template', 'Template imported from awesome-gpt-image-2 case 060. Source: @Gc_qube.', 'Illustration & Art', '{
  "type": "5-panel collage",
  "layout": "grid with 3 top panels and 2 bottom panels",
  "panels": [
    {
      "position": "top-left",
      "subject": "analog clock",
      "details": "teal background, time showing {argument name=\"clock time\" default=\"7:42\"}",
      "style": "flat vector illustration"
    },
    {
      "position": "top-middle",
      "subject": "woman holding playing cards",
      "details": "holding 5 cards: {argument name=\"card hand\" default=\"Ace of Spades, King of Hearts, Queen of Clubs, Jack of Diamonds, 10 of Spades\"}",
      "style": "classic oil painting portrait"
    },
    {
      "position": "top-right",
      "subject": "glass of red liquid",
      "details": "{argument name=\"glass type\" default=\"wine glass\"} filled to the brim with dark red liquid, marble surface",
      "style": "photorealistic studio photography"
    },
    {
      "position": "bottom-left",
      "subject": "chessboard",
      "details": "wooden board with 32 pieces in standard starting position",
      "style": "photorealistic high-angle shot"
    },
    {
      "position": "bottom-right",
      "subject": "two dice",
      "details": "left die shows {argument name=\"left die top\" default=\"5\"} on top, right die shows {argument name=\"right die top\" default=\"2\"} on top",
      "style": "pop art comic book halftone with red and blue burst"
    }
  ]
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 60, '@Gc_qube', 'https://x.com/Gc_qube', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-60', '/images/case60.jpg', 'Case 060 Illustration and Art Template', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-059', 'Case 059 Posters and Typography Template', 'Template imported from awesome-gpt-image-2 case 059. Source: @X64zzotSKCGtYmt.', 'Posters & Typography', '{
  "type": "cinematic promotional poster",
  "style": "3D CGI animation style, highly detailed, dramatic lighting, caricature characters",
  "characters": [
    { "id": "char1", "description": "large shirtless man with long black hair, beard, and glasses" },
    { "id": "char2", "description": "elderly woman in a kimono with white hair tied up" },
    { "id": "char3", "description": "small man with a topknot, glasses, mustache, wearing a bright green sweater" }
  ],
  "layout": {
    "panels": [
      {
        "position": "top",
        "scene": "wide shot of a town street with buildings and a city skyline in the background",
        "characters_present": ["char1", "char2", "char3"],
        "text_overlays": [
          "{argument name=\"intro text\" default=\"ある日ーー\"}",
          "いつもの日常がーー",
          "こんばんは"
        ]
      },
      {
        "position": "middle left",
        "scene": "close-up of char1 looking shocked against a dark fiery background",
        "text_overlays": [
          "{argument name=\"shocked text\" default=\"私が出禁？\"}"
        ]
      },
      {
        "position": "middle right",
        "scene": "close-up of char2 looking angry and pointing against a stormy sea background",
        "text_overlays": [
          "{argument name=\"angry text\" default=\"海を荒らすな！\"}"
        ]
      },
      {
        "position": "bottom",
        "scene": "char3 pointing, char1 screaming, a second instance of char3 falling backwards, and char2 sitting angrily against a fiery chaotic background",
        "text_overlays": [
          "全然出ない！"
        ],
        "bottom_titles": [
          "{argument name=\"main title\" default=\"パチンコ軍団親のイメチェン\"}",
          "{argument name=\"subtitle\" default=\"LINEスタンプ販売中\"}"
        ]
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 59, '@X64zzotSKCGtYmt', 'https://x.com/X64zzotSKCGtYmt', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-59', '/images/case59.jpg', 'Case 059 Posters and Typography Template', '["UI","Poster","Character"]'::jsonb, '["Tech","Travel","Story"]'::jsonb, FALSE, TRUE),
    ('case-058', 'Flat Illustration, High-end Oriental Fantasy Style City Poster', 'Template imported from awesome-gpt-image-2 case 058. Source: @liyue_ai.', 'Posters & Typography', 'Flat illustration, high-end oriental fantasy style city poster design, vertical 9:16 composition. The layout uses a diagonal + S-shaped flow extending from the bottom left to top right. The background is deep black grading down to intense dark red, creating strong warm-cool contrast and spatial depth with faint stardust and grain texture. In the center, a flowing golden energy line winds through like a flame, extending upward from the base, featuring fluid texture, particle effects, and gradient highlights, with subtle energy debris and volumetric light.

Within the golden flow, the architectural landmarks of {argument name="city" default="Guangzhou"} emerge layer by layer: the Canton Tower is the visual core with prominent proportions, surrounded by the Zhujiang New Town skyline, Liede Bridge, and modern Lingnan architectural elements. Buildings are rendered using "fine line drawing + golden luminous blocks," with clear outlines and rich details, appearing to float in a void against the golden halo, creating a surreal spatial hierarchy with slightly fogged backgrounds for added depth.

At the bottom of the frame is an oriental white-haired female figure with flowing hair like mist, naturally connecting and merging with the golden light. Her hair is translucent with gradient light effects; she has a graceful posture, eyes closed, and a serene expression, holding a bouquet of colorful flowers dotted with shimmering particles, symbolizing the spiritual connection between people and city energy. Character details are moderately simplified to emphasize the overall design.

Lighting is concentrated on the golden flow, buildings, and character outlines, creating intense chiaroscuro and visual focus. The overall atmosphere is grand, mysterious, imbued with oriental mythology, and slightly healing. Colors use black and dark red as a base with brilliant gold as the main visual emphasis. The gold has rich light-dark layers, complemented by small areas of high-saturation floral colors, maintaining a sophisticated and restrained aesthetic.

Integrated text and layout: Centered Songti font at the top reads "{argument name="city" default="Guangzhou"} · China," followed by smaller text "{argument name="date" default="2026/04/20"}" and "{argument name="author" default="LIYUE"}" below. Text uses pale gold or soft warm white, unified with the overall lighting. High-quality details, cinematic lighting, rich volumetric and particle details, clean image without noise, ultra-high 8K resolution, commercial-grade poster quality.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 58, '@liyue_ai', 'https://x.com/liyue_ai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-58', '/images/case58.jpg', 'Flat Illustration, High-end Oriental Fantasy Style City Poster', '["UI","Poster","Illustration"]'::jsonb, '["Tech","Commerce","Travel"]'::jsonb, FALSE, TRUE),
    ('case-057', ', Post : , Handle : , Content', 'Template imported from awesome-gpt-image-2 case 057. Source: @liyue_ai.', 'UI & Interfaces', '{
  "type": "mobile social media app UI mockup",
  "platform": "Twitter/X dark mode",
  "header": {
    "status_bar": "time 19:28, bird icon, signal, wifi, battery",
    "navigation": "back arrow, ''Tweet'' title"
  },
  "post": {
    "author": {
      "avatar": "portrait of a Chinese emperor in red robes and black hat",
      "display_name": "{argument name=\"display name\" default=\"Emperor Zhu Yuanzhang\"} 👑 [verified badge]",
      "handle": "{argument name=\"handle\" default=\"@Emperor_Ming\"}"
    },
    "content": {
      "text": "{argument name=\"tweet text\" default=\"I have ascended to the Dragon Throne! Today, I am proclaimed as the Emperor of the Ming Dynasty. The era of Hongwu has begun. Let us rebuild our great nation together!\"}",
      "hashtags": "#MingDynasty #HongwuEra #NewBeginning",
      "media_grid": {
        "count": 3,
        "images": [
          "emperor seated on an ornate golden throne in red and gold robes",
          "wide shot of a grand Chinese palace courtyard with a large crowd",
          "emperor on horseback leading an army with a red dragon banner"
        ]
      }
    },
    "metadata": {
      "timestamp": "{argument name=\"timestamp\" default=\"1:36 PM · Jan 23, 1368\"}",
      "engagement": "5,432 Retweets, 8,765 Quotes, 20.1K Likes, 102.3K Views"
    },
    "actions": "reply, retweet, like (red heart with ''1''), share, upload"
  },
  "footer": {
    "reply_bar": {
      "avatar": "woman in red",
      "placeholder": "Reply to Emperor Zhu Yuanzhang..."
    },
    "navigation_bar": "home, search, notifications (red ''1'' badge), messages"
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 57, '@liyue_ai', 'https://x.com/liyue_ai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-57', '/images/case57.jpg', ', Post : , Handle : , Content', '["UI","Character","Classical"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-056', 'A Candid, Realistic Photograph of a Young Woman', 'Template imported from awesome-gpt-image-2 case 056. Source: @danieldmai.', 'Photography & Realism', 'A candid, realistic photograph of a young {argument name="subject aesthetic" default="goth"} woman with pale skin, long straight black hair with bangs, heavy black eyeliner, and black lipstick. She has a {argument name="expression" default="deadpan"} expression, looking directly at the camera while sitting on a children''s coin-operated {argument name="ride type" default="unicorn"} ride. She is wearing a black lace-trimmed tank top, black arm warmers, layered necklaces including a choker, black lace tights, and chunky black platform boots with buckles. A large black shoulder bag hangs from her arm. The ride is a white unicorn with a pink mane, gold horn, and purple hooves, mounted on a purple base with a small sticker reading "{argument name="ride cost" default="50¢ PER RIDE"}". The setting is outside a store with a tan cinderblock wall. To the left is a glass door reflecting a person, a brown trash can, and a white sign with red text reading "{argument name="sign text" default="NO PARKING FIRE LANE"}". To the right is a blue vending machine. Overcast, natural daylight.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 56, '@danieldmai', 'https://x.com/danieldmai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-56', '/images/case56.jpg', 'A Candid, Realistic Photograph of a Young Woman', '["Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-055', 'Help Me Create a Detailed Production Flowchart for', 'Template imported from awesome-gpt-image-2 case 055. Source: @Kurt_Rousey466.', 'Charts & Infographics', 'Help me create a detailed production flowchart for the dish {argument name="dish name" default="Fried Pork with Chili"}, in a realistic style, suitable for Xiaohongshu image-text proportions.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 55, '@Kurt_Rousey466', 'https://x.com/Kurt_Rousey466', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-55', '/images/case55.jpg', 'Help Me Create a Detailed Production Flowchart for', '["UI","Infographic","Realistic"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-054', ', , Visual : , Toothbrush Text :', 'Template imported from awesome-gpt-image-2 case 054. Source: @fukumy_ai.', 'Products & E-commerce', '{
  "type": "4-panel satirical product advertisement grid",
  "layout": {
    "grid": "2x2",
    "panels": [
      {
        "position": "top-left",
        "product_name": "{argument name=\"top left product name\" default=\"座る石\"}",
        "visual": "man in white shirt and dark pants sitting on a large round stone in a park",
        "catchphrase": "いつでも、どこでも、落ち着ける。",
        "sales_badge": "累計販売数 12,000個 突破!",
        "vertical_text": "公園のベンチが埋まっていた日に。",
        "features_count": 3,
        "features_labels": [
          "重さ約8kgで安定感抜群",
          "底面フェルト加工で傷つけにくい",
          "付属の専用ベルトで持ち運び簡単"
        ],
        "extra_visual": "small inset image of the stone with a leather carrying strap",
        "specs": [
          "耐荷重 150kg",
          "安心の日本製"
        ]
      },
      {
        "position": "top-right",
        "product_name": "{argument name=\"top right product name\" default=\"磨きたくない人の歯ブラシ\"}",
        "visual": "sleek light blue toothbrush angled diagonally on a dark blue background",
        "toothbrush_text": "I don''t want to brush my yeeth.",
        "catchphrase": "持っているだけで安心感",
        "vertical_text": "歯を磨く代わりに、これを持つ。",
        "sales_badge": "シリーズ累計販売数 85,000本 突破!",
        "features_count": 3,
        "features_labels": [
          "気持ちを落ち着けるお守り代わりに",
          "会議や商談前のエチケットに",
          "磨かない選択を、もっと自由に。"
        ],
        "bottom_banner": "歯磨きストレスから、あなたを解放する。"
      },
      {
        "position": "bottom-left",
        "product_name": "{argument name=\"bottom left product name\" default=\"雲の貯金箱\"}",
        "visual": "hand inserting a coin into a fluffy white cloud-shaped piggy bank",
        "catchphrase": "空気より軽い、安心感。",
        "sales_badge": "累計販売数 23,567個 突破!",
        "features_count": 3,
        "features_labels": [
          "ふわふわの触り心地",
          "割れないから安心",
          "インテリアに馴染むデザイン"
        ],
        "color_variants_count": 3,
        "color_variants_labels": [
          "blue",
          "pink",
          "white"
        ],
        "price": "¥2,980 (税込)",
        "bottom_text": "今日から、空に向かってコツコツ貯めよう。"
      },
      {
        "position": "bottom-right",
        "product_name": "{argument name=\"bottom right product name\" default=\"叱ってくれる石\"}",
        "visual": "round stone on a wooden desk with a pen, text written on the stone",
        "stone_text": "{argument name=\"scolding phrase\" default=\"いいかげんやれ\"}",
        "catchphrase": "やる気が出ないあなたへ。",
        "sales_badge": "累計販売数 18,000個 突破!",
        "features_count": 3,
        "features_labels": [
          "見るたびに心を奮い立たせる",
          "厳選された言葉をランダム表示",
          "電池不要、半永久的に叱ってくれる"
        ],
        "phrase_variants_count": 10,
        "phrase_variants_labels": [
          "甘えるな",
          "考えるな",
          "動け",
          "現実を見ろ",
          "逃げるな",
          "寝るな",
          "やればできる",
          "お前ならできる",
          "寝るな",
          "もう言い訳するな"
        ],
        "price": "¥3,500 (税込)"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 54, '@fukumy_ai', 'https://x.com/fukumy_ai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-54', '/images/case54.jpg', ', , Visual : , Toothbrush Text :', '["Product","Character"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-053', 'A Vintage, Late 90s Amateur Flash Photograph of', 'Template imported from awesome-gpt-image-2 case 053. Source: @nicdunz.', 'Photography & Realism', 'A vintage, late 90s amateur flash photograph of a young man repairing an arcade machine. He is kneeling on a dark, patterned arcade carpet, looking back over his shoulder directly at the camera with a neutral expression. He wears a dark short-sleeved t-shirt, baggy blue jeans, chunky white sneakers, and a dark baseball cap. The lower front panel of the arcade cabinet is wide open, exposing its complex internal electronics, including a tangle of wires, green circuit boards, a large speaker, and metal cooling fans at the base. The side of the cabinet features vibrant pink, black, and white graphics with the text "{argument name="arcade game title" default="Dancing Stage"}" and the brand "{argument name="arcade brand" default="KONAMI"}". The setting is a dimly lit arcade interior with other glowing game cabinets visible in the blurred background. A screwdriver lies on the carpet near the man''s knee. The image features harsh direct flash lighting, a slightly grainy film texture, deep shadows, and a nostalgic Y2K aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 53, '@nicdunz', 'https://x.com/nicdunz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-53', '/images/case53.jpg', 'A Vintage, Late 90s Amateur Flash Photograph of', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-052', 'A Realistic Photograph of a Whiteboard with a', 'Template imported from awesome-gpt-image-2 case 052. Source: @nicdunz.', 'Illustration & Art', 'A realistic photograph of a whiteboard with a highly detailed {argument name="marker color" default="green"} dry-erase marker drawing of {argument name="subject" default="a samurai with a messy topknot and facial hair, hands clasped in prayer"}. The character is drawn in a {argument name="art style" default="detailed manga sketch"} style, shown in profile with eyes closed, wearing a traditional kimono with a katana tucked into his belt. To the left of the character, handwritten text in all-caps reads "{argument name="text line 1" default="VAGABOND"}" with "{argument name="text line 2" default="MUSASHI"}" written directly below it. The whiteboard has a glossy surface with realistic light reflections and glare on the left side, and a thin metallic frame is visible at the bottom edge, giving the impression of an authentic classroom or office environment.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 52, '@nicdunz', 'https://x.com/nicdunz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-52', '/images/case52.jpg', 'A Realistic Photograph of a Whiteboard with a', '["Realistic","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-051', ', Subtitle : , Slogan Cn : ,', 'Template imported from awesome-gpt-image-2 case 051. Source: @yyyole.', 'Charts & Infographics', '{
  "type": "7-day fashion lookbook infographic",
  "header": {
    "title": "{argument name=\"main title\" default=\"一周穿搭指南\"}",
    "subtitle": "{argument name=\"style keywords\" default=\"温柔 | 靓丽 | 优雅\"}",
    "slogan_cn": "优雅不设限，自信每一天",
    "slogan_en": "{argument name=\"english slogan\" default=\"ELEGANCE HAS NO LIMIT, BE CONFIDENT EVERY DAY\"}"
  },
  "subject": "{argument name=\"subject description\" default=\"young elegant Asian woman\"}",
  "layout": {
    "columns": 7,
    "column_elements": [
      "day_header",
      "main_portrait",
      "4_detail_thumbnails",
      "outfit_specs",
      "keywords_colors",
      "3_color_swatches",
      "star_ratings",
      "fabric_price",
      "4_season_icons"
    ],
    "days": [
      { "day": "周一 (MONDAY)", "outfit": "beige blazer suit", "scene": "场景：重要会议 / 正式商务" },
      { "day": "周二 (TUESDAY)", "outfit": "pink blazer suit", "scene": "场景：日常通勤" },
      { "day": "周三 (WEDNESDAY)", "outfit": "cream knit cardigan set", "scene": "场景：生活休闲" },
      { "day": "周四 (THURSDAY)", "outfit": "champagne slip dress", "scene": "场景：外出私会" },
      { "day": "周五 (FRIDAY)", "outfit": "blue knit top, white skirt", "scene": "场景：休闲社交" },
      { "day": "周六 (SATURDAY)", "outfit": "white sports bra, purple leggings", "scene": "场景：运动休闲" },
      { "day": "周日 (SUNDAY)", "outfit": "beige lounge knitwear", "scene": "场景：居家 / 约会" }
    ]
  },
  "footer": {
    "tips": "{argument name=\"footer tips\" default=\"Tips: 根据天气与场合灵活调整，配饰是提升整体造型的关键；保持自信与舒适，才是穿搭的最终目的。\"}",
    "legend": [
      "春: 春季适用",
      "夏: 夏季适用",
      "秋: 秋季适用",
      "冬: 冬季适用"
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 51, '@yyyole', 'https://x.com/yyyole', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-51', '/images/case51.jpg', ', Subtitle : , Slogan Cn : ,', '["UI","Infographic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-050', 'A Highly Detailed, Cinematic Wide Shot of a', 'Template imported from awesome-gpt-image-2 case 050. Source: @nomen_machine.', 'Architecture & Spaces', 'A highly detailed, cinematic wide shot of a grand, dark gothic hall with a {argument name="atmosphere" default="dark fantasy"} aesthetic. In the center, a single figure wearing a {argument name="clothing" default="long white robe"} kneels on a highly reflective stone floor, facing an ornate golden altar illuminated by a row of lit candles. To the right of the kneeling figure, a single {argument name="floor object" default="wooden violin"} rests on the ground. The cavernous room is framed by massive dark stone pillars detailed with {argument name="accent color" default="glowing blue"} ethereal cracks and veins. Suspended from the high ceiling are dozens of {argument name="floating objects" default="white porcelain theatrical masks"} hanging on thin strings, filling the upper half of the space and creating a haunting, surreal atmosphere. The lighting is dramatic and moody, featuring a rich color palette of deep blacks, tarnished golds, and cool blue accents. Format 16:9.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 50, '@nomen_machine', 'https://x.com/nomen_machine', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-50', '/images/case50.jpg', 'A Highly Detailed, Cinematic Wide Shot of a', '["Architecture"]'::jsonb, '["Tech","Fashion","Story"]'::jsonb, FALSE, TRUE),
    ('case-049', 'A 9:16 Aspect Ratio Image, Generating a Screenshot', 'Template imported from awesome-gpt-image-2 case 049. Source: @kylegeeks.', 'UI & Interfaces', 'A 9:16 aspect ratio image, generating a screenshot of a Douyin livestream where {argument name="celebrity" default="Liu Yifei"} is broadcasting, holding a sign that says "{argument name="sign text" default="Streaming tonight, welcome to join Yifei''s chat!"}"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 49, '@kylegeeks', 'https://x.com/kylegeeks', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-49', '/images/case49.jpg', 'A 9:16 Aspect Ratio Image, Generating a Screenshot', '["UI"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-048', 'A 9:16 Aspect Ratio Image, Generating a Screenshot', 'Template imported from awesome-gpt-image-2 case 048. Source: @kylegeeks.', 'UI & Interfaces', 'A 9:16 aspect ratio image, generating a screenshot of a Douyin livestream where {argument name="celebrity" default="Liu Yifei"} is broadcasting, holding a sign that says "{argument name="sign text" default="Streaming tonight, welcome to join Yifei''s chat!"}"', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 48, '@kylegeeks', 'https://x.com/kylegeeks', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-48', '/images/case48.jpg', 'A 9:16 Aspect Ratio Image, Generating a Screenshot', '["UI"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-047', ', , , , Icons :', 'Template imported from awesome-gpt-image-2 case 047. Source: @makaneko_AI.', 'Products & E-commerce', '{
  "type": "2x2 grid of Japanese digital advertisement banners",
  "layout": {
    "structure": "4 equal quadrants",
    "quadrants": [
      {
        "position": "top-left",
        "theme": "Travel",
        "subject": "A couple holding hands on a white sand beach, looking out at turquoise ocean water under a bright blue sky.",
        "elements": ["red hibiscus flower in bottom left corner"],
        "text_labels": [
          "今年こそ、解き放て。",
          "{argument name=\"travel destination\" default=\"沖縄旅行\"}",
          "3日間の癒やし旅",
          "航空券＋ホテル",
          "39,800円〜",
          "絶景、グルメ、体験 ぜんぶ叶う!"
        ],
        "icons": {
          "count": 3,
          "descriptions": ["airplane", "hotel building", "car"]
        }
      },
      {
        "position": "top-right",
        "theme": "Skincare",
        "subject": "Close-up portrait of a young woman with glowing, dewy skin, eyes closed, gently touching her cheeks.",
        "elements": [
          "soft pink gradient background",
          "dynamic water splash effects",
          "pink cosmetic jar labeled ''{argument name=\"skincare product name\" default=\"LUMIÈRE\"} Brightening Gel''"
        ],
        "text_labels": [
          "毛穴・くすみ卒業！",
          "透明感あふれる",
          "水光肌へ",
          "新感覚スキンケア",
          "初回限定 78%OFF",
          "{argument name=\"discount price\" default=\"1,980円\"}"
        ],
        "badges": {
          "count": 3,
          "style": "gold circular",
          "labels": ["毛穴ケア", "高保湿", "ハリ・ツヤ"]
        }
      },
      {
        "position": "bottom-left",
        "theme": "Gourmet Food",
        "subject": "Thick, sliced, medium-rare steak sizzling on a dark grill plate.",
        "elements": [
          "garlic chips",
          "rosemary sprig",
          "dark background with smoke and glowing embers"
        ],
        "text_labels": [
          "とろける旨さ！",
          "{argument name=\"food item\" default=\"黒毛和牛\"}",
          "贅沢ステーキ",
          "期間限定",
          "特別価格",
          "通常価格 8,980円",
          "4,980円"
        ],
        "badges": {
          "count": 1,
          "style": "red circular",
          "labels": ["A4 A5等級"]
        }
      },
      {
        "position": "bottom-right",
        "theme": "Online Education",
        "subject": "Young man in a blue shirt studying at a desk, writing in a notebook next to an open laptop.",
        "elements": ["bright indoor lighting", "desk environment"],
        "text_labels": [
          "スキマ時間で",
          "{argument name=\"education goal\" default=\"最短合格！\"}",
          "オンライン資格講座",
          "スマホで完結",
          "効率学習で差がつく！",
          "今だけ！ 受講料 20%OFF"
        ],
        "badges": {
          "count": 1,
          "style": "blue circular",
          "labels": ["受講者数 10万人 突破！"]
        },
        "icons": {
          "count": 2,
          "descriptions": ["smartphone", "open book"]
        }
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 47, '@makaneko_AI', 'https://x.com/makaneko_AI', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-47', '/images/case47.jpg', ', , , , Icons :', '["UI","Product"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-046', 'A Highly Detailed, Realistic Photograph of a Young', 'Template imported from awesome-gpt-image-2 case 046. Source: @lakeside529.', 'Photography & Realism', 'A highly detailed, realistic photograph of a young East Asian woman sitting in a cluttered backstage dressing room, getting ready for a cosplay event. She has {argument name="hair color" default="vibrant short red"} hair styled in a bob with bangs and is wearing an elaborate fantasy warrior costume featuring a {argument name="costume color" default="glossy red"} and gold tiered mini skirt, a white corset top with black lace and red lacing, matching glossy arm guards, and thigh-high boots. She is looking down with a focused expression, using her right hand to adjust the arm guard on her left arm. The vanity counter in front of her is messy, covered with makeup brushes, bottles, a hairbrush, and extra hairpieces. A large, ornate {argument name="prop" default="fantasy sword with a blue blade and gold hilt"} leans against the edge of the counter. The background shows a brightly lit vanity mirror with round bulbs reflecting a clothing rack, capturing a candid, slightly over-sharpened, and highly textured photographic style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 46, '@lakeside529', 'https://x.com/lakeside529', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-46', '/images/case46.jpg', 'A Highly Detailed, Realistic Photograph of a Young', '["Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-045', 'A Striking Black and White Close-up Portrait of', 'Template imported from awesome-gpt-image-2 case 045. Source: @AoYe999.', 'Photography & Realism', 'A striking black and white close-up portrait of a {argument name="subject description" default="handsome young Asian man"} with {argument name="hair style" default="messy wet hair sticking to his forehead"}. His face and neck are glistening, covered in highly detailed {argument name="skin texture detail" default="water droplets and sweat"}. He has an intense, melancholic gaze directed off-camera to the left. The lighting is dramatic and high-contrast, emphasizing his sharp jawline, full lips, and specular highlights on the wet skin against a {argument name="background" default="pitch-black background"}. Shot in a photorealistic, high-fashion editorial style with cinematic chiaroscuro.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 45, '@AoYe999', 'https://x.com/AoYe999', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-45', '/images/case45.jpg', 'A Striking Black and White Close-up Portrait of', '["Poster","Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-044', 'Generate Avatars of Various Emperors from the Based', 'Template imported from awesome-gpt-image-2 case 044. Source: @liyue_ai.', 'History & Classical Themes', 'Generate avatars of various emperors from the {argument name="dynasty" default="Ming Dynasty"} based on the style of the uploaded image, with their posthumous names and personal names listed below the avatars.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 44, '@liyue_ai', 'https://x.com/liyue_ai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-44', '/images/case44.jpg', 'Generate Avatars of Various Emperors from the Based', '["Character","Classical"]'::jsonb, '["Commerce","History"]'::jsonb, FALSE, TRUE),
    ('case-043', ', Style : , Layout : , Count', 'Template imported from awesome-gpt-image-2 case 043. Source: @stark_nico99.', 'Illustration & Art', '{
  "type": "character portrait grid",
  "theme": "{argument name=\"theme\" default=\"Game of Thrones characters\"}",
  "style": "{argument name=\"art style\" default=\"2D flat illustration, clean line art, comic style, profile view facing right, pale skin with blush\"}",
  "layout": {
    "grid": "3x3",
    "background": "light gray textured",
    "frame_style": "white rounded-rectangle frames with text labels below each"
  },
  "count": 9,
  "portraits": [
    { "label": "Jon Snow", "description": "black hair half-up, beard, dark fur cloak" },
    { "label": "Daenerys Targaryen", "description": "silver braided hair, blue dress" },
    { "label": "Tyrion Lannister", "description": "curly brown hair, beard, dark tunic with gold pin" },
    { "label": "Cersei Lannister", "description": "blonde braided hair, ornate red and gold dress" },
    { "label": "Ned Stark", "description": "brown hair half-up, beard, dark fur cloak" },
    { "label": "Arya Stark", "description": "short dark hair half-up, brown tunic, sword hilt" },
    { "label": "Jaime Lannister", "description": "short blonde hair, gold armor with lion motif" },
    { "label": "Sansa Stark", "description": "red braided hair, blue dress with fur collar" },
    { "label": "Theon Greyjoy", "description": "short dark curly hair, dark tunic with kraken pin" }
  ]
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 43, '@stark_nico99', 'https://x.com/stark_nico99', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-43', '/images/case43.jpg', ', Style : , Layout : , Count', '["Illustration","Character"]'::jsonb, '["Tech","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-042', 'Express in a Graffiti Sketch Style, Presenting an', 'Template imported from awesome-gpt-image-2 case 042. Source: @blanplan.', 'UI & Interfaces', 'Express {argument name="subject" default="a powerful AI builder"} in a graffiti sketch style, presenting an overall visual effect of quick outlines, free deformation, improvised hand-drawing, and draft-like sketches. The lines are casual, exaggerated, varying in thickness, and slightly messy but rhythmic and expressive, emphasizing generalization, exaggeration, fun, and spontaneity rather than rigorous realism or fine detail. The colors are expressed in rough blocks with a distinct dry-brush feel, retaining uneven smears, brush marks, fly-white, and layering. Colors automatically adapt to the {argument name="theme" default="powerful AI builder"}, but the overall expression remains graffiti-like, sketch-like, and generalized. No transparent watercolor smudging effects, no delicate watercolor transitions, no paper textures, no soft atomization, and no dreamy textures. The background is mainly white space, maintaining a sense of simplicity, ease, unfinishedness, and design. Small amounts of auxiliary symbols, arrows, marks, circles, repeated lines, handwritten text, or other graffiti elements can be added to enhance the sketchbook or essay-like visual language, but they should not be too crowded or destroy the subject and the white space atmosphere. The content of the picture does not need to be written in advance; {argument name="character image" default="a powerful AI builder"} will automatically deduce and generate the most suitable main image, actions, related elements, symbols, or simplified scenes. The overall style remains a unified graffiti sketch style and an exaggerated, generalized expression, avoiding complex realistic backgrounds and excessive detail. A special signature ''BlanPlan'' should be naturally added as part of the picture, in a low-key but clear position such as the bottom left, bottom right, or near the title. The style should be unified with the overall layout, like an artist''s signature or a design mark; the signature font should be exquisite, restrained, and high-end, not too large, and should not destroy the main composition or appear abrupt or cheap.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 42, '@blanplan', 'https://x.com/blanplan', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-42', '/images/case42.jpg', 'Express in a Graffiti Sketch Style, Presenting an', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-041', ', Elegant, Lace, Ribbon Motifs , Character :', 'Template imported from awesome-gpt-image-2 case 041. Source: @wtry1102.', 'Characters & People', '{ "type": "VTuber profile sheet", "theme": "{argument name=\"color theme\" default=\"purple and white\"}, elegant, lace, ribbon motifs", "character": { "name": "{argument name=\"character name\" default=\"紫咲リリー\"}", "archetype": "{argument name=\"character archetype\" default=\"elegant ojousama\"}", "appearance": "anime girl, long black hair with purple highlights, purple eyes, wearing a white blazer, purple pleated skirt, thigh-highs, ribbons", "pose": "standing, finger to lips, looking slightly to the side" }, "chibi_character": { "appearance": "same character in chibi form", "pose": "sitting down, smiling" }, "layout": { "header": { "top_left": "Ribbon banner reading ''VTuber Profile''", "top_center": "Logo with text ''{argument name=\"vtuber type\" default=\"清楚系お嬢様Vtuber\"}'' and ''{argument name=\"character name\" default=\"紫咲リリー\"}'' and ''Shisaki Lily''", "top_right": "Quote ''{argument name=\"catchphrase\" default=\"皆さまの心に、優雅なひとときをお届けしますわ\"}'' followed by a 3-line introductory paragraph" }, "columns": [ { "position": "left", "content": "Full-body character portrait" }, { "position": "center", "sections": [ { "title": "Profile", "count": 9, "labels": ["名前", "誕生日", "年齢", "身長", "属性", "一人称", "出身", "職業", "活動開始日"] }, { "title": "Personality", "content": "2-line text block" }, { "title": "Hobby & Special Skill", "count": 2, "labels": ["趣味", "特技"] }, { "title": "Like & Dislike", "count": 2, "labels": ["好きなもの", "苦手なもの"] } ] }, { "position": "right", "sections": [ { "title": "Streaming Content", "content": "1-line text block" }, { "title": "Schedule", "count": 2, "labels": ["配信時間", "配信頻度"] }, { "title": "Goals", "content": "3-line text block" }, { "title": "Fan & Tag", "count": 3, "labels": ["ファンネーム", "ファンアートタグ", "総合タグ"], "extra": "4 hashtag rows with small icons" }, { "title": "Creator", "count": 3, "labels": ["イラストレーター (ママ)", "モデラー (パパ)", "使用モデル"] }, { "title": "Links", "count": 4, "labels": ["YouTube", "X (Twitter)", "BOOTH", "FANBOX"] }, { "content": "Chibi character illustration placed at the bottom right corner" } ] } ], "footer": { "sections": [ { "title": "Rules", "count": 3, "description": "3 bullet points with heart icons" }, { "content": "2-line closing message at the bottom center" } ] } } }', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 41, '@wtry1102', 'https://x.com/wtry1102', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-41', '/images/case41.jpg', ', Elegant, Lace, Ribbon Motifs , Character :', '["Illustration","Brand","Character"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-040', 'Create Line Stickers of in a Quirky Hand-drawn', 'Template imported from awesome-gpt-image-2 case 040. Source: @midori_tatsuta.', 'Illustration & Art', 'Create {argument name="quantity" default="24"} LINE stickers of {argument name="animals" default="animals"} in a quirky hand-drawn style. Target {argument name="target audience" default="Japanese Gen Z"} with a trendy style that can aim for top downloads.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 40, '@midori_tatsuta', 'https://x.com/midori_tatsuta', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-40', '/images/case40.jpg', 'Create Line Stickers of in a Quirky Hand-drawn', '["UI"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-039', 'Create Line Stickers of in a Quirky Hand-drawn', 'Template imported from awesome-gpt-image-2 case 039. Source: @midori_tatsuta.', 'Illustration & Art', 'Create {argument name="quantity" default="24"} LINE stickers of {argument name="animals" default="animals"} in a quirky hand-drawn style. Target {argument name="target audience" default="Japanese Gen Z"} with a trendy style that can aim for top downloads.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 39, '@midori_tatsuta', 'https://x.com/midori_tatsuta', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-39', '/images/case39.jpg', 'Create Line Stickers of in a Quirky Hand-drawn', '["UI"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-038', 'Create Line Stickers of in a Quirky Hand-drawn', 'Template imported from awesome-gpt-image-2 case 038. Source: @midori_tatsuta.', 'Illustration & Art', 'Create {argument name="quantity" default="24"} LINE stickers of {argument name="animals" default="animals"} in a quirky hand-drawn style. Target {argument name="target audience" default="Japanese Gen Z"} with a trendy style that can aim for top downloads.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 38, '@midori_tatsuta', 'https://x.com/midori_tatsuta', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-38', '/images/case38.jpg', 'Create Line Stickers of in a Quirky Hand-drawn', '["UI"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-037', 'Create Line Stickers of in a Quirky Hand-drawn', 'Template imported from awesome-gpt-image-2 case 037. Source: @midori_tatsuta.', 'Illustration & Art', 'Create {argument name="quantity" default="24"} LINE stickers of {argument name="animals" default="animals"} in a quirky hand-drawn style. Target {argument name="target audience" default="Japanese Gen Z"} with a trendy style that can aim for top downloads.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 37, '@midori_tatsuta', 'https://x.com/midori_tatsuta', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-37', '/images/case37.jpg', 'Create Line Stickers of in a Quirky Hand-drawn', '["UI"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-036', 'A Photorealistic Selfie of a Young Man with', 'Template imported from awesome-gpt-image-2 case 036. Source: @mirochill.', 'Photography & Realism', 'A photorealistic selfie of a young man with short wavy dark hair and light stubble on an indoor basketball court. He wears a black athletic t-shirt with a white swoosh. He holds a {argument name="ball color" default="green"} basketball featuring a large white {argument name="logo design" default="OpenAI logo"}. The background shows a hardwood floor, black wall pads, and a basketball hoop against a concrete wall. Bright indoor gym lighting with a casual social media aesthetic.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 36, '@mirochill', 'https://x.com/mirochill', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-36', '/images/case36.jpg', 'A Photorealistic Selfie of a Young Man with', '["Realistic","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-035', 'A of a Looking Back Over Her Shoulder', 'Template imported from awesome-gpt-image-2 case 035. Source: @kazmaendo.', 'Photography & Realism', 'A {argument name="photography style" default="photorealistic portrait with shallow depth of field and soft bokeh"} of a {argument name="subject" default="young Japanese woman"} looking back over her shoulder at the camera with a {argument name="expression" default="gentle smile"}. She is wearing a {argument name="attire" default="light beige kimono with orange maple leaf patterns"} and a gold obi. Her dark hair is styled in an elegant updo with loose strands framing her face, and she wears small pearl earrings. The background features an {argument name="setting" default="autumn garden with vibrant red maple leaves"}, with bright red foliage framing the top left and a heavily blurred, soft background creating a serene, cinematic atmosphere.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 35, '@kazmaendo', 'https://x.com/kazmaendo', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-35', '/images/case35.jpg', 'A of a Looking Back Over Her Shoulder', '["Realistic"]'::jsonb, '["Tech","Fashion","Travel"]'::jsonb, FALSE, TRUE),
    ('case-034', ', Style : , Layout : Subtle Texture', 'Template imported from awesome-gpt-image-2 case 034. Source: @Ryan_Suo.', 'Illustration & Art', '{
  "type": "character avatar grid",
  "theme": "{argument name=\"theme\" default=\"Journey to the West mythology\"}",
  "style": "{argument name=\"art style\" default=\"clean 2D cartoon vector illustration, thick outlines, flat colors\"}",
  "layout": {
    "background": "{argument name=\"background color\" default=\"light gray\"} subtle texture",
    "format": "grid of circular portraits with text labels centered below each circle",
    "rows": [
      {
        "count": 4,
        "items": [
          {"label": "Sun Wukong", "description": "monkey boy with golden headband and red scarf"},
          {"label": "Tang Sanzang", "description": "monk with ornate golden crown"},
          {"label": "Zhu Bajie", "description": "pig man holding a rake"},
          {"label": "Sha Wujing", "description": "bearded man holding a crescent moon staff"}
        ]
      },
      {
        "count": 4,
        "items": [
          {"label": "White Dragon Horse", "description": "white horse with golden bridle"},
          {"label": "Jade Emperor", "description": "older man with white beard and golden crown"},
          {"label": "Guanyin", "description": "goddess holding a willow branch"},
          {"label": "Bull Demon Kink", "description": "fierce bull demon in armor"}
        ]
      },
      {
        "count": 4,
        "items": [
          {"label": "Princess Iron Fan", "description": "woman holding a green palm leaf fan"},
          {"label": "Red Boy", "description": "boy with red hair, horns, and a small flame"},
          {"label": "Black Wind Demon", "description": "dark shadowy demon with glowing red eyes"},
          {"label": "Nezha", "description": "boy with double hair buns holding a flaming spear"}
        ]
      },
      {
        "count": 3,
        "description": "partial row repeating Princess Iron Fan, Black Wind Demon, and Nezha, slightly cropped at the bottom"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 34, '@Ryan_Suo', 'https://x.com/Ryan_Suo', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-34', '/images/case34.jpg', ', Style : , Layout : Subtle Texture', '["Illustration","Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-033', 'A 3d Render of a Cute Kawaii Character', 'Template imported from awesome-gpt-image-2 case 033. Source: @yurunekofree.', 'Products & E-commerce', 'A 3D render of a cute kawaii {argument name="subject" default="cloud"} character on a pure white background. The character has a soft, matte, squishy texture resembling clay or a stress toy. It features large glossy black eyes with white highlights, a simple curved smile, and round pink blush on its cheeks. The edges and bottom of the figure have a subtle pastel gradient of {argument name="accent colors" default="pink, blue, and purple"}. Soft studio lighting, minimalist icon style, casting a gentle shadow.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 33, '@yurunekofree', 'https://x.com/yurunekofree', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-33', '/images/case33.jpg', 'A 3d Render of a Cute Kawaii Character', '["UI","Product","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-032', ', Character Base : , Common Theme :', 'Template imported from awesome-gpt-image-2 case 032. Source: @austinit.', 'Illustration & Art', '{
  "type": "3x3 character expression grid",
  "style": "{argument name=\"art style\" default=\"3D animation, Pixar style\"}",
  "character_base": "{argument name=\"character description\" default=\"young woman with voluminous dark wavy hair and round wire-rimmed glasses\"}",
  "common_theme": "{argument name=\"framing concept\" default=\"peeking through a torn hole in white paper\"}",
  "layout": {
    "rows": 3,
    "columns": 3,
    "total_panels": 9,
    "panels": [
      {"position": "top-left", "expression": "winking", "action": "adjusting glasses", "outfit": "green sweater"},
      {"position": "top-center", "expression": "smirking", "action": "lowering dark sunglasses", "outfit": "red leather jacket"},
      {"position": "top-right", "expression": "thinking", "action": "finger on chin", "outfit": "yellow hoodie"},
      {"position": "middle-left", "expression": "big smile", "action": "arms resting on edge", "outfit": "black and white striped shirt"},
      {"position": "middle-center", "expression": "smiling", "action": "thumbs up", "outfit": "orange button-up shirt"},
      {"position": "middle-right", "expression": "neutral", "action": "drinking boba tea", "outfit": "blue sweater"},
      {"position": "bottom-left", "expression": "happy", "action": "waving", "outfit": "purple sweater vest over white shirt"},
      {"position": "bottom-center", "expression": "laughing with eyes closed", "action": "arms crossed", "outfit": "pink cardigan"},
      {"position": "bottom-right", "expression": "silly", "action": "poking cheeks", "outfit": "teal sweater"}
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 32, '@austinit', 'https://x.com/austinit', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-32', '/images/case32.jpg', ', Character Base : , Common Theme :', '["Illustration","Character","3D"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-031', 'A Highly Detailed, Photorealistic Anime-style Portrait of a', 'Template imported from awesome-gpt-image-2 case 031. Source: @jun_kongo.', 'Photography & Realism', 'A highly detailed, photorealistic anime-style portrait of a young woman crouching down and looking slightly down at the camera from a low angle. She has long, flowing {argument name="hair color" default="ash-blonde"} hair blowing gently in the wind, pale skin, and large, expressive eyes. She is wearing a {argument name="outfit" default="Japanese school uniform with a light grey cardigan, white shirt, dark plaid bow tie, dark plaid pleated skirt, dark knee-high socks, and black leather loafers"}. Her arms are resting casually on her knees. The background is a bright {argument name="sky condition" default="clear blue sky with scattered white clouds"}, with a blurred {argument name="background setting" default="chain-link fence and green trees"} visible at the very bottom, suggesting a schoolyard. The lighting is bright, natural daylight with soft, cinematic shadows, emphasizing the realistic textures of her clothing and skin.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 31, '@jun_kongo', 'https://x.com/jun_kongo', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-31', '/images/case31.jpg', 'A Highly Detailed, Photorealistic Anime-style Portrait of a', '["Realistic"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-030', 'Express in a Graffiti Sketch Style, Presenting an', 'Template imported from awesome-gpt-image-2 case 030. Source: @opc_8838.', 'Illustration & Art', 'Express [{argument name="subject" default="a powerful AI builder"}] in a graffiti sketch style, presenting an overall visual effect of rapid sketching, free transformation, improvised hand-drawing, and draft-like qualities. Lines are casual, exaggerated, varied in thickness, slightly messy but rhythmic and expressive, emphasizing generalization, exaggeration, fun, and spontaneity rather than rigorous realism or fine detail. Colors use rough, dry-brush block expressions, retaining uneven smears, brush marks, flying whites, and overlapping feelings. Colors automatically adapt to the [theme/subject], but the overall expression remains graffiti-like, sketch-like, and generalized. No transparent watercolor smudging, no delicate watercolor transitions, no paper textures, no soft atomization, and no dreamlike quality. The background is mainly white space, remaining simple, relaxed, unfinished, and design-oriented. A small amount of auxiliary symbols, arrows, marks, circles, repeated lines, handwritten text, or other graffiti elements can be added to enhance the sketchbook or essay-like visual language, but should not be too crowded or destroy the subject and atmosphere of the white space. The image content does not need to be written in advance; the [{argument name="subject" default="a powerful AI builder"}] will automatically deduce and generate the most suitable main image, actions, related elements, symbols, or simplified scenes. The whole maintains a unified graffiti sketch style and exaggerated generalized expression, avoiding complex realistic backgrounds and over-elaboration. Naturally add a unique signature "{argument name="signature" default="BlanPlan"}" as part of the image, placed discreetly but clearly in the lower-left, lower-right, or near the title. The style should be unified with the overall layout, like an artist''s signature or design inscription; the signature font should be refined, restrained, and high-end, not too large, not destructive to the main composition, and not appearing abrupt or cheap.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 30, '@opc_8838', 'https://x.com/opc_8838', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-30', '/images/case30.jpg', 'Express in a Graffiti Sketch Style, Presenting an', '["UI","Realistic","Illustration"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-029', 'Using Reference 0, Transform the Subject''s Appearance to', 'Template imported from awesome-gpt-image-2 case 029. Source: @danieldmai.', 'Photography & Realism', 'Using REFERENCE_0, transform the subject''s appearance to a {argument name="style" default="trad goth"} aesthetic while preserving the exact pose, clothing structure, and background. Change her hair to {argument name="hair color" default="black"} with {argument name="hair style" default="choppy bangs"}. Apply heavy dark makeup, specifically {argument name="lip color" default="black"} lipstick and intense dark eyeshadow, and make her skin tone slightly paler. Add 2 facial piercings: a septum ring and a nostril stud. Finally, modify her layered necklaces to feature {argument name="necklace pendants" default="an inverted cross and a pentagram"}.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 29, '@danieldmai', 'https://x.com/danieldmai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-29', '/images/case29.jpg', 'Using Reference 0, Transform the Subject''s Appearance to', '["Character"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-028', ', Style : , Layout :', 'Template imported from awesome-gpt-image-2 case 028. Source: @frankfu1688.', 'Photography & Realism', '{
  "type": "2x2 portrait grid",
  "subject": "{argument name=\"subject description\" default=\"young adult East Asian male with short black hair and a slight smile\"}",
  "style": "photorealistic, high-resolution, professional lighting, consistent facial identity across all panels",
  "layout": {
    "format": "2x2 grid",
    "panel_count": 4,
    "panels": [
      {
        "position": "top-left",
        "description": "{argument name=\"profession 1\" default=\"Corporate professional wearing a dark navy suit, white shirt, and blue tie against a gray textured background\"}"
      },
      {
        "position": "top-right",
        "description": "{argument name=\"profession 2\" default=\"Casual attire wearing a dark blue crew neck t-shirt against a blurred outdoor park background\"}"
      },
      {
        "position": "bottom-left",
        "description": "{argument name=\"profession 3\" default=\"Construction worker wearing a yellow hard hat, navy blue work shirt, and bright orange high-visibility vest against a blurred warehouse background\"}"
      },
      {
        "position": "bottom-right",
        "description": "{argument name=\"profession 4\" default=\"Medical professional wearing a white lab coat over a light blue collared shirt against a blurred laboratory background\"}"
      }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 28, '@frankfu1688', 'https://x.com/frankfu1688', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-28', '/images/case28.jpg', ', Style : , Layout :', '["UI","Realistic","Brand"]'::jsonb, '["Tech","Commerce","Fashion"]'::jsonb, FALSE, TRUE),
    ('case-027', ', Outfit : , Eyes : Reddish-pink ,', 'Template imported from awesome-gpt-image-2 case 027. Source: @anemone_sd.', 'Characters & People', '{
  "type": "collection of instant photos",
  "setting": "laid out flat on a white fabric surface",
  "character": {
    "hair": "{argument name=\"hair color\" default=\"long pink hair with blue inner color\"}",
    "outfit": "{argument name=\"outfit\" default=\"black and white maid uniform with frilly headband and black ribbons\"}",
    "eyes": "reddish-pink"
  },
  "layout": {
    "arrangement": "two rows of five polaroid photos",
    "count": 10,
    "photos": [
      { "position": "top row 1", "description": "holding a pink heart cushion" },
      { "position": "top row 2", "description": "winking, making a peace sign" },
      { "position": "top row 3", "description": "making a hand heart, pink heart doodle on the bottom border" },
      { "position": "top row 4", "description": "resting chin on hands, gentle smile" },
      { "position": "top row 5", "description": "holding a red rose, winking" },
      { "position": "bottom row 1", "description": "finger to lips, shy expression" },
      { "position": "bottom row 2", "description": "holding a small pink cake" },
      { "position": "bottom row 3", "description": "winking, hand near face, signature ''{argument name=\"signature text\" default=\"Hanashi\"}'' and heart doodle on border" },
      { "position": "bottom row 4", "description": "holding a pink bunny plushie, sparkle doodles, signature ''{argument name=\"signature text\" default=\"Hanashi\"}'' and bunny doodle on border" },
      { "position": "bottom row 5", "description": "winking, sparkle doodles, message ''{argument name=\"message text\" default=\"いつも応援ありがとう！これからもよろしくね♪\"}'' and signature ''{argument name=\"signature text\" default=\"Hanashi\"}'' on border" }
    ]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 27, '@anemone_sd', 'https://x.com/anemone_sd', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-27', '/images/case27.jpg', ', Outfit : , Eyes : Reddish-pink ,', '["Realistic","Character"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-026', 'A Vintage 35mm Film Photograph of a with', 'Template imported from awesome-gpt-image-2 case 026. Source: @ecooai.', 'Photography & Realism', 'A vintage 35mm film photograph of a {argument name="subject description" default="young Asian woman"} with {argument name="hair style" default="long dark wavy hair and wispy bangs"}. She is wearing a {argument name="clothing" default="white ribbed tank top and a loose beige knit cardigan slipping off one shoulder"}, along with a delicate silver necklace. She has soft makeup with pink blush and glossy lips, looking directly at the camera with slightly parted lips. The lighting is harsh direct camera flash, creating a candid, amateur snapshot aesthetic. The background is a {argument name="setting" default="dimly lit, slightly messy room with clothes on a table and a wooden shelf"}. The image features heavy film grain, slightly muted colors, and a nostalgic, highly realistic photographic texture.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 26, '@ecooai', 'https://x.com/ecooai', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-26', '/images/case26.jpg', 'A Vintage 35mm Film Photograph of a with', '["Realistic"]'::jsonb, '["Tech","Fashion","Story"]'::jsonb, FALSE, TRUE),
    ('case-025', 'Create a Minecraft Skin Inspired by', 'Template imported from awesome-gpt-image-2 case 025. Source: @nicdunz.', 'Characters & People', 'create a minecraft skin inspired by {argument name="reference" default="my look"}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 25, '@nicdunz', 'https://x.com/nicdunz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-25', '/images/case25.jpg', 'Create a Minecraft Skin Inspired by', '["Characters"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-024', 'Genshin Impact Cosplay Selfies at the', 'Template imported from awesome-gpt-image-2 case 024. Source: @wewe50770964683.', 'Photography & Realism', 'Genshin Impact {argument name="character" default="Raiden Shogun"} cosplay selfies at the {argument name="event" default="Shanghai Comic Con"}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 24, '@wewe50770964683', 'https://x.com/wewe50770964683', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-24', '/images/case24.jpg', 'Genshin Impact Cosplay Selfies at the', '["Character"]'::jsonb, '["Tech"]'::jsonb, FALSE, TRUE),
    ('case-023', ', Staircase : , Subjects : , Layout', 'Template imported from awesome-gpt-image-2 case 023. Source: @GeekCatX.', 'Charts & Infographics', '{
  "type": "evolutionary timeline infographic",
  "instruction": "Using REFERENCE_0 as a structural base, transform the flat vector design into a highly realistic 3D infographic. Replace the smooth ramps with distinct stone steps and upgrade all organisms to photorealistic 3D models.",
  "style": {
    "background": "{argument name=\"background style\" default=\"vintage textured parchment paper\"}",
    "staircase": "{argument name=\"staircase material\" default=\"realistic textured stone blocks\"}",
    "subjects": "{argument name=\"organism style\" default=\"highly detailed photorealistic 3D renders\"}"
  },
  "layout": {
    "main_title": "{argument name=\"main title\" default=\"人类演化\"}",
    "sections": [
      {
        "position": "left sidebar",
        "count": 8,
        "labels": ["L0: 单细胞生命", "L1: 多细胞生物", "L2: 动物界", "L3: 脊索动物", "L4: 上陆革命", "L5: 哺乳纲", "L6: 人科演化", "L7: 智人纪元"]
      },
      {
        "position": "top right",
        "title": "获得的功能 / 失去的功能",
        "description": "Legend with plus and minus icons"
      },
      {
        "position": "bottom center",
        "title": "演化关键里程碑",
        "count": 6,
        "description": "Timeline with a silhouette graphic of 6 figures showing ape-to-human evolution"
      }
    ],
    "centerpiece": {
      "description": "Winding stone staircase with 25 numbered steps featuring specific organisms.",
      "count": 25,
      "notable_elements": [
        "Step 07: Jellyfish",
        "Step 09: Ammonite",
        "Step 10: Trilobite",
        "Step 24: Walking human",
        "Step 25: {argument name=\"future evolution concept\" default=\"glowing cosmic silhouette with a question mark\"}"
      ]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 23, '@GeekCatX', 'https://x.com/GeekCatX', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-23', '/images/case23.jpg', ', Staircase : , Subjects : , Layout', '["Infographic","Realistic","3D"]'::jsonb, '["Tech","Commerce"]'::jsonb, FALSE, TRUE),
    ('case-022', 'An Anime-style Illustration of a Between Two Young', 'Template imported from awesome-gpt-image-2 case 022. Source: @Tanemomi_Ver2.', 'Illustration & Art', 'An anime-style illustration of a {argument name="action type" default="high-impact martial arts battle"} between two young female fighters in a {argument name="setting" default="traditional wooden martial arts dojo"}. In the foreground, a girl with black hair in a high bun wears a {argument name="character 1 color theme" default="red and white"} Chinese-style martial arts outfit with baggy pants. She is in a dynamic, low, forward-thrusting stance, surrounded by swirling red energy and water splashes. In the background to the right, a girl with light purple hair in twin buns wears a {argument name="character 2 color theme" default="green and purple"} Chinese dress with gold embroidery and black tights. She is leaping through the air in a flying kick pose, surrounded by swirling blue energy. The wooden floorboards are splintering from the intense impact, with debris and dust flying through the air. Above them hangs a weathered wooden sign with the text "{argument name="sign text" default="武術会"}". The scene features dramatic lighting, a low-angle dynamic perspective, and intense action effects.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 22, '@Tanemomi_Ver2', 'https://x.com/Tanemomi_Ver2', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-22', '/images/case22.jpg', 'An Anime-style Illustration of a Between Two Young', '["Illustration","Character"]'::jsonb, '["Tech","Commerce","Story"]'::jsonb, FALSE, TRUE),
    ('case-021', ', Smiling, Wearing a Black T-shirt with a', 'Template imported from awesome-gpt-image-2 case 021. Source: @sjbbxhz.', 'UI & Interfaces', '{
  "type": "live stream UI mockup",
  "subject": {
    "description": "portrait of {argument name=\"host name\" default=\"Elon Musk\"}, smiling, wearing a black t-shirt with a white technical schematic graphic",
    "background": "left side shows a screen with ''{argument name=\"left background logo\" default=\"SPACEX\"}'' text, right side shows a red ''{argument name=\"right background logo\" default=\"Tesla T logo\"}'' and a dark car"
  },
  "ui_overlay": {
    "top_header": {
      "host_info": "avatar, name ''{argument name=\"host name\" default=\"Elon Musk\"}'', subtext ''55.6万本场点赞'', red ''关注'' button",
      "rank_badge": "gold coin icon with ''全站第1名''",
      "viewer_stats": "3 top viewer avatars with ''12.3w'', ''8.6w'', ''5.7w'', total ''68.7万'', ''X'' close button",
      "right_links": "''更多直播 >'', ''礼物展馆 0/24'' with blue ''经典'' tag"
    },
    "mid_left_gifts": {
      "count": 2,
      "items": [
        "avatar ''科技爱好者'', ''送小心心'', heart icon x 1314",
        "avatar ''星辰大海'', ''送火箭'', rocket icon x 666"
      ]
    },
    "bottom_left_chat": {
      "system_message": "level 37 badge ''宇宙漫游者 加入了直播间''",
      "message_count": 7,
      "messages": [
        "小火箭: 马斯克！未来可期！🚀",
        "future: 特斯拉Model 2什么时候出？",
        "星空梦想家: SpaceX今年能上火星吗？",
        "AI探索者: Neuralink进展如何？",
        "帅气的网友: 马总好！",
        "Mars: 第一次来你的直播，超激动！",
        "用户123: 讲讲AI吧，会取代人类吗？"
      ]
    },
    "bottom_right_product_card": {
      "hot_tag": "orange ''热卖 x 1888''",
      "image": "Tesla Cybertruck",
      "title": "{argument name=\"product name\" default=\"特斯拉Cybertruck 电动皮卡\"}",
      "price": "{argument name=\"product price\" default=\"¥ 1,618,000\"}",
      "button": "red ''抢'' button",
      "floating_animation": "translucent hearts floating up the right edge"
    },
    "bottom_bar": {
      "input_field": "''说点什么...''",
      "icons": ["smiley face", "three dots", "shopping cart", "gift box", "share"]
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 21, '@sjbbxhz', 'https://x.com/sjbbxhz', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-21', '/images/case21.jpg', ', Smiling, Wearing a Black T-shirt with a', '["UI","Product","Brand"]'::jsonb, '["Tech","Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-020', 'Create an Explanatory Slide for That Fuses the', 'Template imported from awesome-gpt-image-2 case 020. Source: @yammamon.', 'Architecture & Spaces', 'Create an explanatory slide ({argument name="format" default="ponchi-e diagram"}) for {argument name="theme" default="Momotaro"} that fuses the gentle atmosphere of "Irasutoya" with the overwhelming information density of "Kasumigaseki slides".', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 20, '@yammamon', 'https://x.com/yammamon', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-20', '/images/case20.jpg', 'Create an Explanatory Slide for That Fuses the', '["Infographic","3D"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-019', 'Create an Explanatory Slide for That Fuses the', 'Template imported from awesome-gpt-image-2 case 019. Source: @yammamon.', 'Charts & Infographics', 'Create an explanatory slide ({argument name="format" default="ponchi-e diagram"}) for {argument name="theme" default="Momotaro"} that fuses the gentle atmosphere of "Irasutoya" with the overwhelming information density of "Kasumigaseki slides".', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 19, '@yammamon', 'https://x.com/yammamon', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-19', '/images/case19.jpg', 'Create an Explanatory Slide for That Fuses the', '["Infographic","3D"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-018', ', Title Section : , Mascot : ,', 'Template imported from awesome-gpt-image-2 case 018. Source: @mm_zzm44854.', 'Architecture & Spaces', '{
  "type": "illustrated map infographic",
  "style": "{argument name=\"art style\" default=\"watercolor and ink hand-drawn illustration on vintage parchment\"}",
  "title_section": {
    "text": "{argument name=\"city name\" default=\"成都\"} {argument name=\"map title\" default=\"吃货暴走地图\"}",
    "mascot": "cartoon red chili pepper wearing sunglasses and giving a thumbs up"
  },
  "border": "{argument name=\"border decoration\" default=\"vine of green leaves and red chili peppers\"}",
  "layout": {
    "background": "textured beige parchment paper with yellow roads, blue rivers, and green park areas",
    "sections": [
      {
        "title": "landmarks",
        "count": 6,
        "illustrations": ["traditional pavilion", "traditional monastery", "modern skyscraper with climbing panda", "tall TV tower", "traditional gate", "industrial buildings"],
        "labels": ["人民公园", "文殊院", "IFS", "339电视塔", "宽窄巷子", "东郊记忆"]
      },
      {
        "title": "food_spots",
        "count": 12,
        "illustrations": ["mapo tofu", "dumplings in chili oil", "skewers in pot", "sticky rice balls", "egg baking cake", "nine-grid hotpot", "sweet potato noodles", "cold skewers", "spicy mixed dish", "covered tea bowl", "ice jelly dessert", "spicy rabbit heads"],
        "labels": ["1 陈麻婆豆腐", "2 钟水饺", "3 春熙路", "4 宽窄巷子·三大炮", "5 建设路·叶婆婆蛋烘糕", "6 玉林路·小龙坎火锅", "7 香香巷·肥肠粉", "8 武侯祠大街·钵钵鸡", "9 东郊记忆·冒椒火辣", "10 人民公园·鹤鸣茶社", "11 锦里古街·冰粉", "12 双流老妈兔头"]
      },
      {
        "title": "图例",
        "position": "bottom-right",
        "count": 5,
        "items": ["red dot", "green house", "green tree", "blue line", "yellow double line"],
        "labels": ["美食地点", "地标景点", "公园绿地", "河流湖泊", "主要道路"]
      }
    ],
    "centerpiece": "giant panda sitting and eating bamboo",
    "bottom_right_extras": ["vintage compass rose with N, S, E, W", "disclaimer text ''温馨提示：吃辣需谨慎，肠胃要保护~'' with a red chili pepper icon"]
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 18, '@mm_zzm44854', 'https://x.com/mm_zzm44854', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-18', '/images/case18.jpg', ', Title Section : , Mascot : ,', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce","Food"]'::jsonb, FALSE, TRUE),
    ('case-017', 'Interaction Design Diagram', 'Template imported from awesome-gpt-image-2 case 017. Source: @wory37303852.', 'Products & E-commerce', '{
  "type": "exploded view product diagram poster",
  "subject": "VR headset",
  "style": "clean high-tech 3D render, studio lighting, glowing accents",
  "background": "{argument name=\"background color\" default=\"soft purple and blue gradient\"}",
  "header": {
    "logo": "∞ {argument name=\"product name\" default=\"Meta Quest 3\"}",
    "subtitle": "{argument name=\"main catchphrase\" default=\"まったく新しい現実を、まったく新しい構造から。\"}"
  },
  "layout": {
    "centerpiece": "vertically stacked exploded view of a VR headset showing 9 distinct layers of internal components: outer shell, camera sensors, motherboard with chip, pancake lenses, internal frame, battery packs, side straps, top strap, and facial interface cushion.",
    "callout_labels": {
      "count": 8,
      "left_side": [
        "Snapdragon® XR2 Gen 2\n圧倒的な処理性能でリアルタイムな体験を。",
        "調整可能なIPD機構\n幅広いユーザーに快適なフィット感を。",
        "精密設計されたヘッドストラップ\n快適さと安定性を追求したエルゴノミクス。"
      ],
      "right_side": [
        "フェイスプレート\n洗練されたデザインと最適な重量バランス。",
        "トラッキングカメラ\n高精度な位置トラッキングと環境認識を実現。",
        "パンケーキレンズ\n薄型設計で広い視野角と鮮明な映像を提供。",
        "高性能バッテリー\n長時間駆動を支える最適化された電源設計。",
        "柔らかなフェイスインターフェース\n長時間でも快適な装着感を実現。"
      ]
    },
    "footer": {
      "left_text_block": {
        "headline": "{argument name=\"bottom headline\" default=\"体験は、構造から進化する。\"}",
        "body": "一つひとつのパーツに、没入体験を支える最先端テクノロジーとこだわりの設計。Meta Quest 3は、未来を感じさせる体験を内部から生み出しています。"
      },
      "right_logo": "∞ Meta"
    }
  }
}', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 17, '@wory37303852', 'https://x.com/wory37303852', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-17', '/images/case17.jpg', 'Interaction Design Diagram', '["UI","Infographic","Poster"]'::jsonb, '["Tech","Commerce"]'::jsonb, TRUE, TRUE),
    ('case-016', ',,,:xxxx,xxx,xxxxxxxxxxxx,,,,,,,,', 'Template imported from awesome-gpt-image-2 case 016. Source: Community.', 'Posters & Typography', '生成高完成度史诗感艺术海报，双重曝光构图，米白色背景，球队：xxxx队，xxx的大剪影占据主体，剪影内部融合xx、xx、xx、xx以及xx等元素。整体以xx、土褐、为主，压抑、决绝、宿命感极强，元素不要冗杂，要有留白，印刷颗粒质感，元素不要有太锐的细节，但是要有史诗质感，像正式院线动画电影海报，竖版。图片中若出现文字则以细体字为主', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 16, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-16', '/images/case16.jpg', ',,,:xxxx,xxx,xxxxxxxxxxxx,,,,,,,,', '["Poster"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-015', 'Case 015 Posters and Typography Template', 'Template imported from awesome-gpt-image-2 case 015. Source: Community.', 'Posters & Typography', '生成一张海报图片，图片人物是一个19岁的中国少女，黑色直长发，很开心的在夜宵摊上喝啤酒吃小龙虾。海报上用芥末黄色艺术字写着，趁年轻，激爽才够味！', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 15, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-15', '/images/case15.jpg', 'Case 015 Posters and Typography Template', '["Poster","Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-014', ': 9:16 ; Handmade Washi Paper ,,; E23a28', 'Template imported from awesome-gpt-image-2 case 014. Source: Community.', 'Charts & Infographics', '视觉设计规格描述：画幅比 9:16（竖版手机信息图）；背景纹理为具有呼吸感的米色手工纸（Handmade Washi Paper），带微小纤维纹理，边角有轻微水渍晕染；配色方案为熟番茄红（#E23A28）、初榨橄榄油金黄（#F2C94C）、嫩草绿（#6FCF97）、碳黑墨线；排版逻辑为顶端大标题、中间 Z 字形流线、底部全景成品、留白艺术化处理。食谱内容策划：1）顶部标题《番茄炒蛋：国民灵魂料理》，手绘书法体，侧边盖红色"厨师推荐"微型印章。2）步骤区块（Z 动线排版）：步骤1 挑选与备菜（左上）：三个番茄、四枚土鸡蛋、一簇葱花；说明：番茄切小块，鸡蛋打散均匀；厨师秘技：番茄去皮后切块，汁水更浓郁，口感更丝滑；心得：选熟透番茄，成功一半。步骤2 蛋液的魔法（右上）：手持筷子快速搅动蛋液，泛起气泡与动感线；说明：加少许盐和几滴温水；厨师秘技：加温水或白醋，鸡蛋更蓬松；心得：搅打充分，空气是蓬松秘密。步骤3 烈火蓬松蛋（左中）：铁锅中蛋液迅速膨胀如云朵，水彩表现热气；说明：油热下锅，快速划散，八成熟盛出；厨师秘技：油温高，烟起即入，瞬间锁水；心得：宁可稍嫩，不可过老。步骤4 番茄出浓汁（右中）：番茄翻滚，边缘半融化，亮红汤汁流淌；说明：煸炒至出汁，加少许糖和盐；厨师秘技：铲子轻压加速出汁，可加一勺番茄酱提色；心得：糖中和酸度、提鲜。步骤5 最后的合奏（左下）：鸡蛋回锅与番茄汁交织，撒葱花；说明：让鸡蛋吸饱番茄汁，关火装盘；厨师秘技：出锅前滴几滴芝麻油提香；心得：动作要快，保持鲜亮色泽。3）底部成品插图：青花边陶瓷深盘装满番茄炒蛋，红亮汁水包裹金黄大块鸡蛋，葱花点缀，水彩渲染半透明酱汁质感，边缘有袅袅热气；视觉感：看了就想立刻盛一碗大米饭。4）底部中央署名：[ 摄影师的厨房日记 · 2025 ]。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 14, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-14', '/images/case14.jpg', ': 9:16 ; Handmade Washi Paper ,,; E23a28', '["Infographic"]'::jsonb, '["Commerce"]'::jsonb, FALSE, TRUE),
    ('case-013', 'A Realistic Photo of a Chinese High School', 'Template imported from awesome-gpt-image-2 case 013. Source: Community.', 'Documents & Publishing', 'A realistic photo of a Chinese high school math exam paper, printed inblack and white on slightly gray paper, titled "数学试卷", with multiplechoice questions and math formulas, including a small 3D geometrycube diagram. The paper is photographed casually with asmartphone, slightly tilted, with uneven lighting, soft shadows, andminor blur. The text is in Chinese with a mix of bold title font andstandard serif body font. Realistic paper texture, exam layout,authentic classroom test sheet style.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 13, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-13', '/images/case13.jpg', 'A Realistic Photo of a Chinese High School', '["Infographic","Realistic","3D"]'::jsonb, '["Commerce","Social"]'::jsonb, FALSE, TRUE),
    ('case-011', 'Case 011 Architecture and Spaces Template', 'Template imported from awesome-gpt-image-2 case 011. Source: Community.', 'Architecture & Spaces', '一张手绘风格的城市美食地图，以台州为主题。画面以鸟瞰视角的手绘简化城市地图为底，标注椒江、路桥、黄岩等区域和灵江、台州湾等水系地标，不追求精确比例而是追求可爱的水彩手绘感。地图上分布着12个美食地点的精致手绘小插画：1. 椒江老粮坊的蛋清羊尾（金黄蓬松的蛋泡甜点撒着糖粉，筷子夹起拉丝）2. 临海紫阳古街的食饼筒（一个饱满的麦饼卷切开露出肉丝、蛋皮、米面等丰富馅料）3. 三门的青蟹（一只肥硕的青壳大蟹张着大钳子，旁边一小碟姜醋）4. 温岭石塘渔港的海鲜面（粗瓷大碗浓白鱼汤面铺满虾、蛏子、小黄鱼）5. 路桥的糟羹（一锅稠厚的五彩羹，芥菜、冬笋、香干、牡蛎粒粒可见）6. 玉环坎门的炊圆（三四个白胖糯米团子卧在笼屉里，旁边酱油碟滴着麻油）7. 黄岩的麦虾（陶锅里面疙瘩配蛤蜊、青菜翻滚冒泡）8. 仙居的八大碗（八只粗陶小碗围成一圈--土鸡、溪鱼、豆腐皮俱全）9. 天台的饺饼筒（几卷金黄酥脆的薄饼整齐码放，露出红烧肉和豆面馅）10. 临海的麦油脂（竹盘上摊着薄如蝉翼的饼皮卷着肉末、豆芽、鸡蛋丝）11. 温岭的嵌糕（厚实的年糕饼中间嵌着红烧肉和油条，正在铁板上滋滋作响）12. 椒江的姜汁调蛋（一只青花碗里琥珀色姜汤卧着嫩滑蛋花，撒几粒核桃碎）。每个插画约占地图5%面积，旁边用手写体标注店名和一句推荐语如"阿婆凌晨四点就起来和面""本地人认准这口锅"。地图边缘用手绘藤蔓、杨梅枝和小海鲜（虾、蟹、贝壳）装饰形成边框。右下角有一个手绘指南针（标注"东海"方向）和图例说明。左上角标题"台州·山海食光地图"使用胖圆的手绘美术字，用杨梅和小黄鱼点缀装饰。整体画风为水彩+彩铅混合的手绘质感，颜色以杨梅红、姜黄、海蓝、翠绿为主，图片比例1:1。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 11, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-11', '/images/case11.jpg', 'Case 011 Architecture and Spaces Template', '["Illustration"]'::jsonb, '["Travel"]'::jsonb, FALSE, TRUE),
    ('case-010', ', Gpt-image-2 ,sam Altmandario Amodeielon Musk,dario Amodei', 'Template imported from awesome-gpt-image-2 case 010. Source: Community.', 'Posters & Typography', '生成八十年代宣传画，标语"热烈庆祝GPT-Image-2全量开放"，人物包含Sam Altman、Dario Amodei、Elon Musk，Dario Amodei 带上红领巾', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 10, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-10', '/images/case10.jpg', ', Gpt-image-2 ,sam Altmandario Amodeielon Musk,dario Amodei', '["Poster","Character"]'::jsonb, '["Creative"]'::jsonb, FALSE, TRUE),
    ('case-009', '2026,,9:16,s,,spring 2026beijing ,,,,', 'Template imported from awesome-gpt-image-2 case 009. Source: Community.', 'Posters & Typography', '2026中国城市系列宣传海报，主题为【北京】。现代、多彩、明亮通透的国潮风，竖版9:16。大面积白色纹理留白背景，一条从右下向左上盘旋的红色丝绸形成S型主构图。右下角一位东方女性挥舞红绸，服饰需结合北京地域文化定制。红绸延展为城市长卷，融合天坛、长城、鸟巢、喇叭沟门原始森林公园、什刹海、京味相声。左侧排版SPRING 2026、竖排Beijing和小印章"北京"。要求统一系列感，但不能雷同，细节丰富，城市辨识度强。文字清晰且精美布局，高端图形设计。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 9, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-9', '/images/case9.jpg', '2026,,9:16,s,,spring 2026beijing ,,,,', '["Poster"]'::jsonb, '["Fashion","Travel"]'::jsonb, FALSE, TRUE),
    ('case-008', ',,, : Top 5 ,: : ,,,,,,,, ,', 'Template imported from awesome-gpt-image-2 case 008. Source: Community.', 'Charts & Infographics', '根据【主题】生成一张高质量竖版「科普百科图」。
这张图不是普通海报，也不是单纯插画，而是一张兼具图鉴感、百科感、信息结构感和收藏感的模块化科普信息图。整体风格参考高级博物图鉴、现代百科书页、生活方式知识卡，以及社交媒体上更容易传播的信息图风格。
让画面包含：
一个清晰好看的主题主视觉
若干局部特征放大细节
多个圆角模块化信息分区
清楚的标题层级与重点标签
简洁但信息丰富的百科内容
可视化评分、要点总结或 Top 5 模块
内容栏目请根据主题自动适配，优先从这些方向里选择并合理组合：
基础档案、分类信息、外观特征、习性生态、形成机制或结构组成、生长或使用条件、养护或维护建议、风险与注意事项、适合人群或适用场景、优缺点对比、快速评分卡。
视觉要求：
浅色干净背景，柔和配色，轻阴影，精致小图标，圆角信息框，整体排版整洁清爽。信息密度要丰富，但不能显得拥挤，阅读体验要舒服。最终效果要像真正可以发布、阅读、收藏、批量做成系列内容的科普百科卡，而不是广告感很重的宣传海报。
不要做成普通商业宣传海报，要重点突出"知识整理""模块信息""图鉴式展示"这几个特征。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 8, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-8', '/images/case8.jpg', ',,, : Top 5 ,: : ,,,,,,,, ,', '["Infographic","Poster","Illustration"]'::jsonb, '["Commerce","Education","Story"]'::jsonb, FALSE, TRUE),
    ('case-007', ', 9:16 Coser,,,,,,,, Ui,, Galgame , Q ;:,,,', 'Template imported from awesome-gpt-image-2 case 007. Source: Community.', 'UI & Interfaces', '生成一张竖版手机截图风格的图片，整体比例接近 9:16。画面中心偏上是一位真人 coser，扮演上传图片中的二次元角色。人物为写实风格，但五官略带动漫感，皮肤细腻，眼睛稍大，表情温柔地看向镜头，坐在室内的休闲场景中，例如咖啡厅或酒吧吧台前，背景有符合场景的道具。画面最上方加入手机系统状态栏 UI，包括时间、电量、信号、网络等图标，让整张图看起来像手机截图。画面底部叠加一块宽大的半透明 galgame 风格对话框，对话框左侧放一个与画面人物对应的动漫或 Q 版头像；对话框右侧排版文字：第一行用较大字体显示与前面相同的角色名字，下面一到两行显示一段适合这个角色人设的、温柔治愈风格的简体中文台词，由你自动创作。再在对话框下方加一条操作栏，仿照 galgame UI。整体风格高清、细节丰富、光线柔和、二次元与真人写真自然融合。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 7, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-7', '/images/case7.jpg', ', 9:16 Coser,,,,,,,, Ui,, Galgame , Q ;:,,,', '["UI","Realistic","Character"]'::jsonb, '["Fashion","Food","Story"]'::jsonb, FALSE, TRUE),
    ('case-006', 'Illustration Art', 'Template imported from awesome-gpt-image-2 case 006. Source: Community.', 'Illustration & Art', '参考图是角色人设图，为参考图的少女绘制一副日系唯美奇幻风格插画。
【构图】这是一个宏大的中景日系奇幻插画构图，画面中心是完全保留了完整细节的可爱少女，她站立在无边的、如镜面般平滑的水面中心。天空呈现出高饱和度的粉紫与深蓝交织，一条耀眼的蓝色巨型流星划破天际，配合着边缘发光的瑰丽层云。女孩处于背光状态，形成一个暗调但依然清晰可辨其服装和紫色明亮眼眸的剪影，被流星和星空的边缘光细腻勾勒，她微微仰头，一只手轻轻张开。下方的水面完美、对称地反射出整个壮丽的星空、流星、云彩，以及女孩清晰的倒影，点缀着微小的发光点，营造出天人合一、空灵静谧的唯美梦境意境。
【日系唯美奇幻风格说明】该风格以高饱和度的粉紫冷暖色调交织出浩瀚星空，并辅以壮丽的流星与边缘发光的层云作为视觉奇观；画面巧妙利用"天空之镜"般的完美水面反射，将宏大的宇宙背景与孤独静立的人物剪影相融合，通过极具电影感的光影渲染与高对比度的表现手法，营造出一种空灵、静谧且带有超现实宿命感的梦境氛围。
【要求】生成图片的比例9:16，分辨率 4k。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 6, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-6', '/images/case6.jpg', 'Illustration Art', '["Illustration","Character"]'::jsonb, '["Creative"]'::jsonb, TRUE, TRUE),
    ('case-005', 'Xxx:,,,,;,,,,,,,,,,,, Why ,,,,,;,,,', 'Template imported from awesome-gpt-image-2 case 005. Source: Community.', 'Posters & Typography', '根据【XXX主题】自动生成一张收藏版史诗叙事海报：巨大优雅的人物侧脸剪影作为外轮廓，剪影内部自动生长出最契合该主题的完整世界观、标志性场景、角色关系、象征符号、关键建筑、生物、道具与氛围。整体不是普通拼贴，而是高级的剪影轮廓填充式叙事合成，带有双重曝光式联想，但更偏电影海报与梦幻水彩插画融合风格；柔和空气透视，轻雾化过渡，纸张颗粒，边缘飞白与刷痕，大面积留白，版式克制高级，安静、宏大、神圣、怀旧、诗意、传说感强。风格、色彩、场景、材质全部根据主题自动适配，所有元素必须强绑定主题，一眼识别，不要杂乱，不要硬拼贴，不要模板化背景，不要廉价奇幻素材。画面中需自然加入专属签名"WHY"，作为海报设计的一部分，位置低调但清晰，可放在左下角、右下角或标题附近，风格需与整体版式统一，像收藏版海报的作者落款或设计签章；签名字体精致、克制、高级，不可过大，不可破坏主体构图，不可显得突兀廉价。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 5, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-5', '/images/case5.jpg', 'Xxx:,,,,;,,,,,,,,,,,, Why ,,,,,;,,,', '["Poster","Illustration","Brand"]'::jsonb, '["Story"]'::jsonb, FALSE, TRUE),
    ('case-004', ',, Spacex ,:', 'Template imported from awesome-gpt-image-2 case 004. Source: Community.', 'UI & Interfaces', '特朗普在抖音直播间卖老干妈，手里举着「老干妈风味」新品，背景还是 SpaceX 那种科技感，左下角弹幕飘着「特斯拉车主：求上链接」。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 4, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-4', '/images/case4.jpg', ',, Spacex ,:', '["UI"]'::jsonb, '["Social"]'::jsonb, FALSE, TRUE),
    ('case-003', ':,,,,,,,,,,,,,8k,,', 'Template imported from awesome-gpt-image-2 case 003. Source: Community.', 'Posters & Typography', '生成一张「足球主题电影海报」风格的高清写真海报：国际米兰后卫巴斯托尼站在圣西罗球场中央激情庆祝，双手高举并披着波黑国旗，神情热血、坚定、自信，现场灯光璀璨，球场看台座无虚席，背景有蓝黑色烟雾、聚光灯、飘扬的旗帜和飞舞的纸屑，营造欧冠之夜般的史诗氛围。人物为画面核心，半身到全身构图，突出脸部细节、肌肉张力与球衣质感。整体风格写实、震撼、富有戏剧性，海报级构图，电影感光影，高对比度，超清细节，8K，专业体育摄影，极具视觉冲击力。五根手指。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 3, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-3', '/images/case3.jpg', ':,,,,,,,,,,,,,8k,,', '["Poster","Realistic","Character"]'::jsonb, '["Fashion"]'::jsonb, FALSE, TRUE),
    ('case-002', 'Social Media Interface Screenshot', 'Template imported from awesome-gpt-image-2 case 002. Source: Community.', 'UI & Interfaces', '画一张 X 的内容截图，深色模式，@OpenAI 蓝勾认证账号发推。
 正文的中文内容：
 今天想推荐一位很棒的 AI Builder：Ailln AI。
 他持续在小红书分享 AI 工具、Agent 工作流、自动化实践和真实项目经验，把复杂的 AI 能力讲得清楚、实用、可落地。
 如果你正在关注 AI 产品、效率工具、个人自动化、内容创作和未来工作方式，Ailln AI 是一个非常值得关注的创作者。
 在小红书搜索：Ailln AI
 底部添加一张深色官方宣传风格海报，简洁黑客质感，图片中文本准确显示。
 海报大字： 「Ailln AI」
 副标题： 「A brilliant AI Builder worth following」
 互动数据位于最下方： 评论 8.9K、转发 42K、点赞 298K（亮起）、收藏 34K（亮起）、浏览 32.4M。
 图片比例为3:4，不包含软件其他部分。', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 2, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-2', '/images/case2.jpg', 'Social Media Interface Screenshot', '["UI","Poster"]'::jsonb, '["Tech","Social"]'::jsonb, TRUE, TRUE),
    ('case-001', 'Infographic Visualization', 'Template imported from awesome-gpt-image-2 case 001. Source: Community.', 'UI & Interfaces', 'Vertical 9:16 isometric cutaway infographic "城市生命系统图谱 / Urban Metabolism Atlas". Smart city from sky to bedrock: skyscrapers, streets, subway, utility tunnels, water/sewage/gas/heating pipes, fiber, data center, flood tanks, aquifers, geothermal wells, bedrock. Color-coded flows for power/water/data/traffic/waste. 12 numbered panels bilingual CN/EN: 能源/水循环/交通/数据/垃圾/建筑/公共服务/ 物流/气候韧性/生态/地质/治理看板. 24h timeline at bottom. Style: engineering white paper + scientific atlas, light paper bg, crisp lines, 8K. No cyberpunk, no gibberish text, must show both above AND below ground.', '1:1', '{"aspectRatio":"1:1"}'::jsonb, '[]'::jsonb, '{"aspectRatio":"1:1"}'::jsonb, '', 1, 'Community', '', 'https://github.com/freestylefly/awesome-gpt-image-2/blob/main/docs/gallery-part-1.md#case-1', '/images/case1.jpg', 'Infographic Visualization', '["UI","Infographic"]'::jsonb, '["Tech","Education","Travel"]'::jsonb, TRUE, TRUE)
ON CONFLICT (slug) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    category = EXCLUDED.category,
    prompt_instructions = EXCLUDED.prompt_instructions,
    recommended_aspect_ratio = EXCLUDED.recommended_aspect_ratio,
    generation_settings = EXCLUDED.generation_settings,
    prompt_directives = EXCLUDED.prompt_directives,
    default_settings = EXCLUDED.default_settings,
    thumbnail_url = EXCLUDED.thumbnail_url,
    source_case_id = EXCLUDED.source_case_id,
    source_label = EXCLUDED.source_label,
    source_url = EXCLUDED.source_url,
    github_url = EXCLUDED.github_url,
    source_image_path = EXCLUDED.source_image_path,
    image_alt = EXCLUDED.image_alt,
    styles = EXCLUDED.styles,
    scenes = EXCLUDED.scenes,
    featured = EXCLUDED.featured,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

CREATE INDEX IF NOT EXISTS templates_category_idx ON templates(category);
CREATE INDEX IF NOT EXISTS templates_featured_idx ON templates(featured) WHERE featured = TRUE;
CREATE INDEX IF NOT EXISTS templates_styles_gin_idx ON templates USING GIN(styles);
CREATE INDEX IF NOT EXISTS templates_scenes_gin_idx ON templates USING GIN(scenes);
