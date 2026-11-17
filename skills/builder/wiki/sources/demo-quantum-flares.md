---
title: quantum-flares demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/quantum-flares/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-quantum-flares/"]
tags: [source, demo, music, dark-theme, countdown, table]
updated: 2026-07-29
---

# quantum-flares demo

A music band — shows, music, videos, gallery. 6 pages, 585 nodes, 26 element types. Part of
[[sources/websites-demo]].

## Element mix

`headline` 100 · `column` 96 · `row` 71 · `overlay-slider_item` 68 · `gallery_item` 57 · `image` 34 ·
`section` 25 · **`table_item` 16** · `social_item` 16 · `overlay` 10 · `video` 7 · **`countdown` 2**

Sole user of `table` (2 containers, 16 items — the tour-date listings) and `countdown` (album
release, duplicated per breakpoint like everything else here).

## The dark-theme demo

The only corpus theme with a dark page ground: `@global-background: #121212`,
`@global-color: rgba(255, 255, 255, 0.8)`, `@global-primary-background: #fff` — primary is *white*,
and `style` props barely appear in the JSON (`section.style: default` ×25, one `tile-primary`).
Dark sites are built in the theme, not with `style: secondary` sections.

## What it teaches

- **`visibility: "xl"` ×45 / `"hidden-xl"` ×45** — the duplication idiom at its absolute peak: the
  band name and display headlines exist twice, with `&shy;` soft-hyphen variants for narrow
  viewports (`Quan&shy;tum<br>Fla&shy;res`), switched at the largest breakpoint
- **Video as first-class media**: 7 `video` elements — full-viewport hero
  (`height_viewport: true`, `animation: "parallax"`) and background loops. The corpus's main
  evidence for [[props/media]] video behaviour on elements rather than sections
- **`height_viewport` in pixel mode**: values `200`–`400` alongside `80` and `true` — the same
  prop carrying vh percentages, pixel heights and a boolean depending on element and `height`
  mode. Presence proves nothing about unit
- `animation: "parallax"` ×92 — the heaviest parallax demo in absolute terms
- `link_style: "iconnav"` ×4 on `social` — the value in the wild
- `title_style` runs the whole display scale (`heading-xlarge` 24, `heading-2xlarge` 17,
  `heading-3xlarge` 12) on `title_element: "div"` ×79 — poster typography, no heading semantics

## `css` usage — 48 nodes, 8,2%

`image` 23 · `row` 12 · `overlay` 10. The scroll-over machinery of [[sources/demo-kojiiro]] at
scale — `.el-row { margin-top: -100vh; }` ×8, `translateY(-50%)` ×8 pulling images across section
seams — plus the vw sizing idiom (`max-width: 50vw`, `width: 300px; max-width: 28vw`). See
[[concepts/custom-css-boundary]].

## The theme — `master-quantum-flares`

566 lines.

| | |
|---|---|
| fonts | Source Sans 3 body / Geologica headings |
| palette | white-on-`#121212`, link `#6a6a6a`, muted `#262626` |
| `@global-primary-text-transform` | `uppercase` |
| `@global-border-radius` | `0` |

5 variants: `black-blue`, `black-red`, `dark-green`, `dark-orange` — and `light-black`, the
inverted light version.

## Caveats

5 of 6 exports are `5.0.0-beta.8`; `shows.json` is `5.0.0-beta.12`. Only 2 bound nodes — a
portfolio demo, hand-filled.
