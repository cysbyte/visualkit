# AI Image Style & Generation iOS App

## Product, UX, Architecture, and Implementation Specification for Codex

---

# 1. Purpose

Build a brand-new native iOS application for AI image creation.

The core product differentiator is:

> **Upload an image → understand its visual characteristics → turn those characteristics into reusable Visual DNA → combine the Visual DNA with a new prompt and creative template → generate a new image.**

The application should NOT be implemented as a generic "AI image generator with some templates."

The primary product concept is:

**Understand visual style → reuse visual style → create new images.**

The application should feel polished, visual, simple, and native to iOS.

Use Swift + SwiftUI.

---

# 2. Core Product Concept

The application supports three related workflows.

## Workflow A — Text to Image

User enters:

> A woman walking through Tokyo at night

Then optionally selects:

* Template
* Style
* Aspect ratio
* Generation settings

Then generates an image.

---

## Workflow B — Image to Visual DNA

User uploads an image.

The AI analyzes the image and extracts structured visual characteristics.

Example:

```text
Style:
Cinematic
Editorial

Lighting:
Soft
Golden Hour

Colors:
Warm
Muted

Camera:
35mm Look

Depth of Field:
Shallow

Composition:
Centered
Portrait

Mood:
Nostalgic
Premium

Texture:
Subtle Film Grain
```

This structured result is called:

**Visual DNA**

The user can edit Visual DNA.

---

## Workflow C — Visual DNA + Prompt → New Image

Example:

Reference image:

```text
A cinematic travel photograph
```

Extracted Visual DNA:

```text
cinematic
warm
35mm
shallow depth of field
soft lighting
muted colors
film grain
```

User enters:

> A woman riding a bicycle in Paris

User selects:

> Fashion Editorial

The generation request conceptually becomes:

```text
User Intent
+
Reference Visual DNA
+
Preservation Settings
+
Fashion Editorial Template
+
Generation Settings
```

The result should preserve the selected visual characteristics while generating new content.

---

# 3. Critical Product Principle

## DO NOT build a prompt editor as the primary product.

The user should not have to understand prompt engineering.

The primary UI concepts are:

* Image
* Style
* Visual DNA
* Template
* Preserve
* Prompt
* Generate

The app should convert these structured choices into AI instructions.

The user can optionally inspect the generated prompt, but the prompt should not dominate the UX.

---

# 4. User Prompt Must Remain Independent

This is extremely important.

Suppose the user writes:

> A woman walking in Tokyo

Then selects:

> Cinematic

The visible prompt must remain:

> A woman walking in Tokyo

Do NOT replace it with:

> A cinematic photograph of a woman walking in Tokyo with 35mm lens, shallow depth of field...

The template should remain a separate object.

Internally:

```text
User Prompt
+
Template
```

Later:

```text
User Prompt
+
Visual DNA
+
Preservation Settings
+
Template
+
Generation Settings
```

The backend constructs the actual provider-specific AI prompt.

---

# 5. Visual DNA Is a First-Class Product Object

Do not represent Visual DNA as one giant text string.

It must be structured.

Conceptual model:

```swift
VisualDNA {
    style: [...]
    lighting: [...]
    colorPalette: [...]
    camera: [...]
    depthOfField: [...]
    composition: [...]
    mood: [...]
    texture: [...]
    subject: [...]
    background: [...]
}
```

The exact Swift implementation can be improved based on the project architecture, but the conceptual separation must remain.

The UI should allow the user to inspect and modify these characteristics.

---

# 6. Visual DNA Categories

Initial categories:

### Style

Examples:

* Cinematic
* Editorial
* Photorealistic
* Minimal
* Anime
* 3D
* Film

### Lighting

Examples:

* Golden Hour
* Soft
* Hard
* Studio
* Backlit
* Neon

### Color

Examples:

* Warm
* Cool
* Muted
* Vibrant
* Pastel
* High Contrast

### Camera

Examples:

* 35mm
* 50mm
* Wide Angle
* Telephoto
* Portrait Lens

Avoid claiming exact camera metadata unless it is actually known.

Use wording such as:

> 35mm look

rather than:

> Shot on a 35mm camera

when the AI is only inferring appearance.

### Depth of Field

Examples:

* Shallow
* Deep
* Soft Background
* Strong Bokeh

### Composition

Examples:

* Centered
* Portrait
* Wide
* Close-up
* Rule of Thirds

### Mood

Examples:

* Nostalgic
* Dramatic
* Calm
* Premium
* Energetic

### Texture

Examples:

* Film Grain
* Clean Digital
* Soft Texture
* Matte

### Subject

Describe what is visually present.

### Background

Describe the environment/background.

---

# 7. Visual DNA Must Distinguish Observation From Inference

The AI may not know exact technical metadata.

For example, it can infer:

> "35mm photographic look"

but should not automatically claim:

> "Camera was a Canon EOS R5 with a 35mm lens."

Similarly:

> "warm golden-hour lighting"

is acceptable as visual analysis.

Avoid presenting uncertain technical facts as confirmed metadata.

---

# 8. Create Screen

The Create screen is the central creation interface.

Conceptually:

```text
Create

Reference
[ + Add Image ]

Prompt
[ Describe what you want to create... ]

Template
[ Cinematic ] [ Fashion ] [ Product ]

Style
[ None ] [ From Reference ] [ My Style ]

Aspect Ratio
[ 1:1 ] [ 4:5 ] [ 9:16 ] [ 16:9 ]

[ Generate ]
```

The exact UI can be refined, but the conceptual structure must remain.

---

# 9. Reference Image

Users can optionally select an image from their photo library.

After selection:

```text
[ Image ]

Replace
Remove

Analyze Image
```

The image should not automatically become the generation prompt.

It can serve several different purposes:

1. Analyze Visual DNA
2. Use as a visual reference
3. Extract style
4. Generate a new image based on selected characteristics

These concepts should remain distinguishable internally.

---

# 10. Image Analysis Flow

The flow should be:

```text
Add Image
    ↓
Analyze Image
    ↓
Analyzing...
    ↓
Visual DNA
```

The analysis screen should prominently show the reference image.

Then show structured attributes.

Example:

```text
Visual DNA

Style
[Cinematic] [Editorial]

Lighting
[Golden Hour] [Soft]

Color
[Warm] [Muted]

Camera
[35mm Look]

Depth
[Shallow]

Composition
[Portrait] [Centered]

Mood
[Nostalgic]
```

---

# 11. Preserve Controls

After Visual DNA is extracted, users should be able to decide what to preserve.

Example:

```text
Preserve

[✓ Style]
[✓ Lighting]
[✓ Color]
[✓ Composition]

[ Camera ]
[ Depth ]
[ Mood ]
[ Texture ]
[ Subject ]
[ Background ]
```

Default:

* Style
* Lighting
* Color
* Composition

The exact defaults can later be changed based on user testing.

The important concept is that users should not need to write:

> Keep the lighting and color from the reference but change the subject.

Instead they simply select:

```text
Preserve:
Lighting
Color
```

---

# 12. Templates

Templates are creative presets.

They are NOT prompt replacements.

Initial templates:

* Cinematic
* Fashion
* Product Photography
* Travel
* Portrait
* Editorial
* Anime
* 3D
* Minimal
* Social Media

A template should conceptually contain:

```text
id
name
description
category
thumbnail
promptInstructions
recommendedAspectRatio
generationSettings
```

Templates can later be loaded from the backend.

For the first implementation, local mock templates are acceptable.

---

# 13. Template Behavior

When the user selects:

> Fashion Editorial

the user's prompt remains unchanged.

For example:

```text
Prompt:
A woman walking in Paris
```

remains exactly that.

The generation configuration contains:

```text
prompt:
A woman walking in Paris

template:
fashion-editorial
```

The backend later interprets the template.

Do not concatenate everything into a single UI string.

---

# 14. My Styles

Users should be able to save Visual DNA.

Example:

```text
My Styles

Cinematic Tokyo
Warm Film
Luxury Editorial
My Travel Style
```

A saved style contains:

```text
id
name
previewImage
visualDNA
createdAt
```

The user can:

* Use Style
* Rename
* Edit
* Delete

Selecting:

> Use Style

should open the Create workflow with that style already selected.

---

# 15. Important Distinction: Style vs Template

These must not become the same object.

### Style

Represents visual characteristics extracted from an image or manually configured.

Example:

```text
Warm
Cinematic
35mm
Shallow DOF
Film Grain
```

### Template

Represents a creative/use-case preset.

Example:

```text
Fashion Editorial
```

Therefore:

```text
Style
+
Template
+
Prompt
```

is valid.

Example:

```text
Style:
Warm Cinematic

Template:
Fashion Editorial

Prompt:
A woman walking in Paris
```

These three layers should remain separate in the data model.

---

# 16. Generation Draft

The application should have a structured generation draft.

Conceptually:

```swift
GenerationDraft {
    prompt
    referenceImage
    visualDNA
    preservationSettings
    template
    style
    aspectRatio
    generationSettings
}
```

The exact implementation may differ, but the concept must remain.

Do not make the generation state a single giant prompt string.

---

# 17. Backend Boundary

The backend will eventually be implemented in Go.

The iOS app communicates with the Go API only.

The iOS app must NOT directly access:

* AWS SQS
* AWS ECS
* AWS credentials
* S3 credentials
* OpenAI API keys
* other AI provider keys

The architecture should be:

```text
iOS
 |
 | HTTPS
 v
Go API
 |
 +---- S3
 |
 +---- PostgreSQL
 |
 +---- SQS
        |
        v
    ECS Worker
        |
        +---- Vision Provider
        |
        +---- Image Generation Provider
```

The iOS app does not need to know any of this infrastructure.

---

# 18. Image Upload Architecture

Do not upload large images through the Go API if avoidable.

Preferred flow:

```text
iOS
 |
 | request upload URL
 v
Go API
 |
 | presigned URL
 v
iOS
 |
 | direct upload
 v
S3
```

Then:

```text
iOS
 |
 | create analysis job
 v
Go API
```

The backend can then process the S3 object.

No AWS credentials should be embedded in the iOS application.

---

# 19. Asynchronous Jobs

Image analysis and generation can take significant time.

The iOS application should therefore use asynchronous jobs.

Conceptual API:

```text
POST /v1/image-analyses
POST /v1/generations

GET /v1/jobs/{jobId}
```

Job states:

```text
queued
processing
completed
failed
```

The iOS app should have a reusable JobService.

Do not put polling directly into SwiftUI screens.

Use Swift concurrency.

Polling should respect cancellation.

---

# 20. Generation Flow

Conceptually:

```text
User taps Generate
        ↓
Create generation request
        ↓
Backend creates job
        ↓
iOS receives job ID
        ↓
Job = queued
        ↓
Job = processing
        ↓
Job = completed
        ↓
Display generated image
```

During generation, the UI can show messages such as:

```text
Creating your image...
Applying visual style...
Generating...
```

Do not pretend these messages represent actual backend stages unless the backend provides those stages.

If the backend only exposes `processing`, use generic progress messaging.

---

# 21. Structured Generation Request

The iOS app should eventually send something conceptually similar to:

```json
{
  "prompt": "A woman riding a bicycle in Paris",
  "reference_image": {
    "id": "..."
  },
  "visual_dna": {
    "style": ["cinematic"],
    "lighting": ["soft"],
    "colors": ["warm", "muted"],
    "camera": ["35mm-look"],
    "depth_of_field": ["shallow"]
  },
  "preservation": {
    "style": true,
    "lighting": true,
    "colors": true,
    "camera": false,
    "subject": false,
    "background": false
  },
  "template_id": "fashion-editorial",
  "aspect_ratio": "4:5"
}
```

This is an example of the conceptual API.

The actual schema should follow the Go backend contract.

---

# 22. Prompt Construction Belongs to Backend

The iOS app should NOT decide how a particular AI provider should be prompted.

The backend should perform:

```text
Structured User Intent
        ↓
Prompt Builder
        ↓
Provider-specific request
        ↓
Image model
```

This allows the backend to support multiple providers.

For example:

```text
Provider A
Provider B
Provider C
```

without requiring an iOS update every time prompt logic changes.

---

# 23. Provider Abstraction

The backend should ideally use an abstraction similar to:

```text
ImageGenerationProvider
        |
        +--- Provider A
        +--- Provider B
        +--- Provider C
```

Likewise for visual analysis.

The iOS app should never care which provider is being used.

---

# 24. Home Screen

Recommended conceptual structure:

```text
Home

Create Image

Quick Start

[ From Prompt ]
[ From Photo ]
[ From Style ]

My Styles

[ style ] [ style ]

Recent Creations

[ image ] [ image ]
[ image ] [ image ]
```

The product should visually emphasize image creation rather than settings.

---

# 25. Creations / History

Provide a grid of generated images.

Each creation should store:

```text
id
generatedImage
prompt
template
style
visualDNA
referenceImage
createdAt
status
```

Creation detail can expose metadata.

The main result should remain image-focused.

Actions:

* Share
* Regenerate
* Use as Reference
* Use This Style
* Delete

---

# 26. Result Screen

The generated image should be the dominant element.

Conceptually:

```text
Generated Image

[ large image ]

[ Share ]
[ Regenerate ]

Use as Reference
Use This Style

Details
Prompt
Template
Style
```

Do not put all metadata above the image.

---

# 27. "Use This Style"

A generated image can itself become a reference for style extraction.

Therefore:

```text
Generated Image
      ↓
Use This Style
      ↓
Analyze / Extract Visual DNA
      ↓
Save Style
```

This creates a loop where users can build their own visual style library.

---

# 28. Navigation

Use a simple native navigation structure.

A reasonable initial structure:

```text
Home
Create
Styles
Creations
Settings
```

Do not add excessive tabs.

The Create experience should be the primary action.

If the existing app design suggests a better native navigation pattern, use that instead, but preserve the product structure.

---

# 29. Design Direction

The app should feel:

* modern
* premium
* visual
* minimal
* creative
* native iOS

Avoid:

* web dashboard appearance
* excessive borders
* excessive gradients
* dense technical forms
* huge amounts of text
* prompt-engineering terminology everywhere

Use:

* large image previews
* rounded cards where appropriate
* horizontal chips
* bottom sheets
* native navigation
* strong typography hierarchy
* subtle animation
* clear primary actions

---

# 30. Advanced Prompt View

Advanced users may want to inspect what the AI will receive.

Provide an optional:

> View AI Prompt

section.

However:

The raw prompt is secondary.

It should not be the primary creation interface.

The user should be able to create excellent results without understanding prompt engineering.

---

# 31. Error Handling

Every asynchronous operation must have clear states.

Examples:

### Upload

```text
Uploading...
Upload failed
Retry
```

### Analysis

```text
Analyzing image...
Analysis failed
Try Again
```

### Generation

```text
Creating image...
Generation failed
Retry
```

Errors shown to users should be understandable.

Do not expose:

```text
SQS timeout
ECS task failure
HTTP 500 from provider
```

unless appropriate for developer/debug logging.

---

# 32. Offline / Network Behavior

The app should gracefully handle:

* no network
* connection interruption
* request timeout
* app backgrounding
* task cancellation

Do not assume the user remains on the screen for the entire generation.

Generation state should be recoverable from the backend.

---

# 33. Authentication

Do not make authentication the center of the initial UI unless the product requirements require it.

The architecture should allow authentication to be added cleanly.

Never put API secrets in the app.

If anonymous generation is supported, the backend must still use appropriate abuse/rate-limit protection.

---

# 34. Credits / Monetization

Do not implement monetization prematurely unless explicitly requested.

However, the architecture should allow the backend to return generation cost information.

For example:

```text
generationCost
remainingCredits
```

The iOS UI can later show:

```text
Generate · 20 credits
```

But this should not be hardcoded into the image-generation UI.

The backend is the source of truth for credits.

---

# 35. Persistence

Use a repository abstraction.

Do not directly scatter UserDefaults calls throughout SwiftUI views.

Potential local data:

* saved styles
* draft generation
* cached templates
* recent creations metadata

The implementation can start locally and later synchronize with the backend.

---

# 36. Image Caching

The app will contain many images.

Avoid repeatedly downloading full-resolution images.

Use:

* thumbnails for grids
* appropriate caching
* full-resolution images only when needed

The architecture should allow the image source to eventually be:

```text
local
remote
cached
```

without changing every view.

---

# 37. Accessibility

Support:

* Dynamic Type
* VoiceOver
* sufficient contrast
* accessible button labels
* meaningful image descriptions where appropriate
* scalable layouts

Do not rely solely on color to communicate selected/unselected states.

---

# 38. Dark Mode

The application must support both light and dark mode.

Do not hardcode colors inside individual views.

Create a centralized design system.

---

# 39. Testing

At minimum, implement tests for:

### Models

* VisualDNA encoding/decoding
* Template encoding/decoding
* GenerationDraft
* PreservationSettings

### Services

* API request construction
* job polling
* cancellation
* error handling

### UI/state

* selecting a template does not modify the user's prompt
* selecting Visual DNA updates generation state
* removing a reference image works
* generation disabled when required information is missing
* retry behavior works

---

# 40. Important Architectural Rules

These rules should not be violated.

## Rule 1

Do not turn the app into a generic prompt-to-image app.

The central differentiator is:

**Image → Visual DNA → Reusable Style → New Image**

---

## Rule 2

Do not replace the user's prompt when a template is selected.

---

## Rule 3

Do not represent Visual DNA only as a string.

Use structured data.

---

## Rule 4

Do not make Style and Template the same concept.

Style:

> How the image looks.

Template:

> What kind of creative result the user wants.

---

## Rule 5

Do not put AI provider API keys into iOS.

---

## Rule 6

Do not connect iOS directly to SQS or ECS.

---

## Rule 7

Do not put backend infrastructure logic inside SwiftUI views.

---

## Rule 8

Do not construct provider-specific prompts in the iOS UI.

---

## Rule 9

Do not require users to understand technical photography terminology.

Technical attributes can be displayed, but should be translated into understandable language.

---

## Rule 10

Do not implement every possible AI feature in the first version.

The MVP should be focused.

---

# 41. MVP Scope

The first production-capable version should focus on:

```text
1. Home
2. Create
3. Upload Reference Image
4. Analyze Image
5. Visual DNA
6. Preserve Controls
7. Templates
8. Prompt
9. Generate
10. Result
11. Save Style
12. My Styles
13. Creation History
```

Do NOT initially add:

* video generation
* complex manual image editing
* social network
* community marketplace
* complex prompt marketplace
* custom model training
* local GPU inference
* complicated image layers
* advanced Photoshop-like editing

Keep the product focused.

---

# 42. Future Features

The architecture should leave room for:

### Style transfer

```text
Reference A
+
Subject B
=
Image C
```

### Multi-reference generation

```text
Image A → style
Image B → subject
Image C → composition
```

### Style strength

```text
Style Strength
○──────●──────○
```

### Selective preservation

```text
Keep lighting
Change background
Keep colors
Change subject
```

### Image variations

```text
Generate 4 variations
```

### Style marketplace

Potentially allow users to discover reusable styles later.

These should NOT be implemented in the MVP unless specifically requested.

---

# 43. Recommended Development Order

Implement in this order:

```text
Phase 1
Project architecture
        ↓
Home
        ↓
Create
        ↓
Photo picker

Phase 2
Visual DNA models
        ↓
Visual DNA UI
        ↓
Preserve controls

Phase 3
Templates
        ↓
Generation Draft
        ↓
Result UI

Phase 4
Async Job architecture
        ↓
API client
        ↓
S3 upload
        ↓
Real analysis API
        ↓
Real generation API

Phase 5
My Styles
        ↓
Creations
        ↓
Persistence

Phase 6
UX polish
        ↓
Accessibility
        ↓
Error handling
        ↓
Performance
        ↓
Production testing
```

---

# 44. Codex Working Rules

When implementing this specification:

1. Inspect the existing code before changing it.
2. Do not rewrite architecture unnecessarily.
3. Prefer small, composable SwiftUI components.
4. Keep business logic outside Views.
5. Keep networking outside Views.
6. Keep persistence outside Views.
7. Use protocols where a service will eventually have multiple implementations.
8. Use mock services during UI development.
9. Build after every meaningful implementation stage.
10. Fix compilation errors before moving to the next feature.
11. Do not invent backend APIs if the actual backend contract is available.
12. If backend details are unavailable, isolate assumptions behind protocols.
13. Do not introduce unnecessary dependencies.
14. Do not implement features outside the requested scope.
15. Preserve the distinction between Prompt, Visual DNA, Style, Template, and Generation Settings.

---

# 45. Final Product Mental Model

The entire application should ultimately feel like this:

```text
                    CREATE
                      │
             ┌────────┴────────┐
             │                 │
         Text Prompt       Reference Image
             │                 │
             │                 ▼
             │            AI Analysis
             │                 │
             │                 ▼
             │            Visual DNA
             │                 │
             │          ┌──────┴──────┐
             │          │             │
             │      Preserve       Save Style
             │          │             │
             └──────────┴──────┬──────┘
                                │
                           Template
                                │
                                ▼
                             Generate
                                │
                                ▼
                         Generated Image
                                │
                    ┌───────────┼───────────┐
                    │           │           │
                 Save Style   Reference   Regenerate
                    │
                    ▼
                My Styles
```

The central loop is:

**Discover a visual style → understand it → save it → reuse it → create new images.**

That is the product direction Codex should preserve throughout implementation.
