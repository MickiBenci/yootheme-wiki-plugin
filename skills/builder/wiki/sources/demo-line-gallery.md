---
title: line-gallery demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/line-gallery/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-line-gallery/"]
tags: [source, demo, gallery, dynamic-content, css-heavy]
updated: 2026-07-29
---

# line-gallery demo

An art gallery — exhibitions, artists, workshops. 6 pages, 539 nodes, 30 element types. Part of
[[sources/websites-demo]].

## Element mix

`column` 109 · `row` 75 · `headline` 56 · `list_item` 44 · `image` 42 · `section` 32 · `grid_item`
25 · `list` 22 · `panel` 16 — plus one each of `slideshow`, `video`, `map`, `description_list`.

## What it teaches

- **`list` + `source` is the archive idiom**: all 44 `list_item` nodes are dynamically bound —
  exhibition and artist indexes are `list` elements fed by `exhibitions.customExhibition` /
  `artists.customArtist`, not grids. 124 of 539 nodes are bound (23%), second only to
  design-escapes in volume. See [[concepts/dynamic-content]]
- **Bound `section` backgrounds** (×7) and bound `image` (×19) — like design-escapes, whole-page
  art direction driven from content fields
- `header_transparent` ×7 across 6 pages — one page re-declares it on a second section, showing
  that only the first section's declaration wins (the `is_null()` guard in [[elements/section]])
- `layout: "1-4,1-4,1-4,1-4|1-2,1-2,1-2,1-2"` ×5 — the two-tier quarters preset in the wild
- `position: relative` 75 + `absolute` 36 — collage compositions of overlapping images throughout
  → [[recipes/parallax-image-collage]]
- `maxwidth: "2xlarge"` ×41 — wide text measure as gallery house style

## `css` usage — 53 nodes, 9,8% — the corpus maximum

`image` 25 · `column` 21. Two idioms beyond the usual vw sizing:

```css
.el-column > * { position: static; }        /* ×12 */
@media (min-width: 960px) { .el-column .uk-tile { background-size: auto 55%; } }  /* ×5 */
```

The first neutralises the positioning context a column creates, so an absolutely positioned child
inside it anchors to a *higher* ancestor — position-context surgery with no prop equivalent. The
second art-directs a tile's background image scale. Both are why this demo tops the CSS table
despite being mid-sized: overlap-heavy editorial design, not sloppiness. See
[[concepts/custom-css-boundary]].

## The theme — `master-line-gallery`

550 lines.

| | |
|---|---|
| fonts | Inter body / Poppins headings |
| palette | pure `#000` text, emphasis *and* link on `#FFF` |
| `@global-primary-background` | `#F5FC59` — acid yellow |
| `@global-secondary-background` | `#000000` |
| `@global-border-radius` | `0` |

Black-on-white with one acid accent — links are colourless like glowbar, distinguished by context.
5 variants: `black-orange`, `colored-blue`, `colored-green`, `light-green`, `white-green`.

## Caveats

All 6 exports are `5.0.0-beta.8`. The exhibitions/artists custom sources are site configuration not
in the export.
