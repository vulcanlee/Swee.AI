# Design QA

## Comparison Target

- Source visual truth: `C:\Users\vulca\.codex\generated_images\01a02cf8-3897-78e3-9506-751796f9a583\exec-f764ef56-b9f9-4ab5-9bd5-257b94a0f65a.png`, selected concept B「產品先行」.
- Normalized source crop: `D:\Vulcan\GitHub\Swee.AI\artifacts\qa\reference-b-product-first.png`.
- Browser-rendered implementation: `D:\Vulcan\GitHub\Swee.AI\artifacts\qa\home-desktop-1440x900.png`.
- Full-view comparison: `D:\Vulcan\GitHub\Swee.AI\artifacts\qa\design-comparison-desktop.png`.
- Focused card comparison: `D:\Vulcan\GitHub\Swee.AI\artifacts\qa\design-comparison-cards.png`.
- Responsive evidence:
  - `D:\Vulcan\GitHub\Swee.AI\artifacts\qa\home-tablet-768x1024.png`
  - `D:\Vulcan\GitHub\Swee.AI\artifacts\qa\home-mobile-390x844.png`

## Viewport And Normalization

- State: default dark theme, homepage loaded, no hover or focus overlay.
- Implementation viewport: 1440 × 900 CSS px, device scale factor 1.
- Implementation full-page capture: 1440 × 1230 px.
- Source board: 1674 × 941 px; selected B crop: 530 × 740 px.
- The selected source is a narrow concept panel rather than a production viewport. The full comparison scales the B crop to the implementation capture height while preserving each image's aspect ratio. Comparison therefore evaluates hierarchy, layout direction, palette, surfaces and product distinction rather than pixel-identical proportions.

## Findings

- No actionable P0, P1 or P2 findings remain.
- Fonts and typography: system CJK sans-serif typography produces clear Traditional Chinese hierarchy; heading, body, metadata and card labels retain the weight and density of the selected concept without truncation at tested widths.
- Spacing and layout rhythm: the left-aligned hero and product-first grid match concept B. Desktop uses three equal cards as required by the final specification; tablet uses two active-product columns plus a full-width Coming Soon card; mobile uses a single column.
- Colors and visual tokens: near-black navy, rose DocInsight accent and emerald KnowledgeExtraction accent match the selected direction. Text and controls maintain clear foreground/background contrast.
- Image quality and asset fidelity: the generated network background is sharp at desktop size and remains deliberately subdued behind text. The concept's cube illustrations were exploratory placeholders; the approved implementation replaces them with richer product information and does not substitute fake CSS artwork.
- Copy and content: final Traditional Chinese copy matches the approved content design. The third Coming Soon card is an intentional requirement added after the two-product concept mock.

## Focused Comparison Evidence

- The focused card comparison confirms consistent card height, border treatment, product-specific color, title hierarchy and CTA placement.
- Product descriptions and capability tags remain readable at the smallest tested viewport. No additional focused crop is needed because all card typography is legible in the dedicated comparison image.

## Browser And Interaction Evidence

- Chrome loaded the HTTP version at 1440 × 900, 768 × 1024 and 390 × 844 with no horizontal overflow.
- Direct `file:///` loading successfully loaded the stylesheet, favicon reference and generated background.
- Exactly three cards render; two are links and Coming Soon is a non-link article.
- Both product links use `_blank` and `noopener`; DocInsight opened in a new page successfully.
- Keyboard tab order reaches the DocInsight card and exposes its descriptive accessible label.
- Reduced-motion emulation reduced card transitions to `0.00001s`.
- DocInsight contains 24 source slides, advances from 1/24 to 2/24, and reading mode toggles on with `aria-pressed="true"`.
- KnowledgeExtraction contains 36 source slides and advances from 1 to 2 by keyboard and click.
- Console errors: 0. Failed requests: 0.

## Comparison History

1. Initial responsive capture found a P2 tablet rhythm issue: the third Coming Soon card occupied only the left column and left a large empty region.
2. Added a regression assertion, then changed the 900px breakpoint so Coming Soon spans both columns and the 640px breakpoint resets it to one column.
3. Post-fix evidence shows the tablet grid and Coming Soon card both measure 720px wide, with no horizontal overflow.

## Follow-up Polish

- No blocking polish remains. Product-specific illustration assets can be explored later if official brand marks are created; they are intentionally outside this version's approved scope.

final result: passed
