---
title: kojiiro demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/kojiiro/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-kojiro/"]
tags: [source, demo, restaurant, parallax, typography]
updated: 2026-07-29
---

# kojiiro demo

A Japanese restaurant — *KOJIRŌ, Traditional. Regional.* 3 pages, 165 nodes, 16 element types — the
narrowest vocabulary in the corpus. Part of [[sources/websites-demo]]. Theme folder is
`master-kojiro` (single `i`), the one spelling mismatch in the corpus.

## Element mix

`column` 42 · `row` 27 · `headline` 25 · `image` 24 · `panel` 10 · `gallery_item` 8 · `section` 7 ·
`gallery` 4 · `overlay` 3 · `map` 1

## What it teaches

- **`animation: "parallax"` is the only animation value in the file** — all 42 occurrences. With
  [[sources/demo-balou]], the proof that a coherent motion design can be one value applied
  everywhere. See [[props/animation]]
- **Scroll-over composition**: full-screen image rows followed by
  `.el-row { margin-top: -100vh; }` + `z-index` scoped CSS — the next row scrolls *over* the
  hero instead of after it. The manual cousin of `sticky: "cover"`
  ([[recipes/sticky-cover-sections]]), built from CSS because it predates or avoids the prop
- **The `heading-*` scale as the main type voice**: `title_style` is `heading-large` 12,
  `heading-medium` 11, `heading-xlarge` 4 — display styles over `h*` styles, on `title_element:
  "div"` 24 of 43. Typography demos invert the corpus's usual h-scale habit
- **`&shy;` soft hyphens in duplicated headlines** — `Tradi&shy;tional.` — with mirrored
  `visibility` (`s` 9 / `hidden-s` 7): manual hyphenation control per breakpoint, the same
  duplication idiom as balou's hero buttons
- `width: "expand"` ×10 of 16 width values — a full-bleed design
- Dynamic content minimal but structural: the 3 `overlay` nodes on `home` are bound to
  `dishCats.customDishCat` — the menu categories teaser. See [[concepts/dynamic-content]]

## `css` usage — 10 nodes, 6,1%

`row` 4 · `headline` 3 · `image` 2 · `section` 1. Half is the scroll-over machinery above
(`margin-top: -100vh`, `height: 100vh`, `z-index` layering); the rest is vw image sizing
(`max-width: 60vw` with `translateY(-50%)`) and `margin-bottom: 15vh`/`30vh` rhythm. Viewport-unit
margins appear nowhere in the prop scale. See [[concepts/custom-css-boundary]].

## The theme — `master-kojiro`

410 lines.

| | |
|---|---|
| fonts | Manrope throughout |
| palette | pure `#000` on `#FFF`, link and primary `#E3A154` gold |
| `@global-secondary-background` | `#3E5249` — pine green |
| `@global-border-radius` | `2px` |

Black, white, gold, green — a four-colour identity. 5 variants: `dark-red`, `white-darkred`,
`white-green`, `white-red`, `white-yellow`.

## Caveats

`about` and `home` are `5.0.0-beta.8`; `contact` is `5.0.32`.
