---
title: single Grid element, importable from the Library
type: recipe
status: verified
yootheme_version: "5.0.51"
sources: ["[[sources/grid-element-export]]"]
tags: [recipe, grid, library, import, cards]
updated: 2026-10-14
---

# Single Grid element (card grid) for Library > Elements > Import

Format: [[concepts/single-element-export-format]]. Elements: [[elements/grid]], [[elements/grid_item]].

- `props`: start from the full set in `raw/element-export-grid-example.json`; change only what the layout
  needs. `grid_default`/`grid_small`/`grid_medium` are numeric strings (columns), e.g. `"2"`/`"3"`/`"4"` for 12
  items (4×3 on desktop).
- Text-only cards: `show_image: false`, `show_link: false`, `meta_align: "above-title"`, `panel_style: "card-default"`,
  `title_element: "h3"`, `title_style: "h4"`, `item_animation: true` (stagger).
- Each `grid_item`: `{"type":"grid_item","props":{"content":"<p>…</p>","meta":"…","title":"…"}}`, no `children`.
- Root also needs `name`, `modified`, `version`.

Used for Cloris: 12 zodiac signs (`title` = glyph + sign, `meta` = stones) and 12 birth months.
