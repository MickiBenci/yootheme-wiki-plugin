---
title: devstack demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/devstack/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-devstack/"]
tags: [source, demo, saas, subnav, search, html]
updated: 2026-07-29
---

# devstack demo

A SaaS product site — features, pricing, careers, support. 10 pages, 937 nodes, 27 element types.
Part of [[sources/websites-demo]].

## Element mix

`grid_item` 184 · `column` 136 · `row` 102 · `image` 83 · `headline` 67 · `section` 52 · `grid` 42 ·
`text` 42 · `list_item` 41 · `panel-slider_item` 40 · `subnav` 3 · `search` 1 · `html` 1

The highest `grid_item` count in the corpus — feature matrices, logo walls, job listings, support
topics are all grids. Three single-demo rarities:

- **`subnav`** ×3 (`about`, `careers`, `our-story`) — in-page section navigation, items bound to
  `customMenuItems` via [[concepts/dynamic-content]]
- **`search`** ×1 — the support-page hero is a `search` element (`search_size: "large"`,
  `block_align: "center"`, `maxwidth: "2xlarge"`)
- **`html`** ×1 — the pricing comparison is a hand-written `uk-table uk-table-divider` inside an
  `html` element. The builder has a `table` element; the authors dropped to HTML for column-scoped
  markup it cannot express

## What it teaches

- **`header_transparent` on all 10 pages** — the sitewide policy, where other demos reserve it for
  heroes
- **`position` at volume**: `relative` 75 + `absolute` 64 — the floating-UI collage (screenshots
  with badges and cards hovering over them) is built from positioned images, not background media.
  See [[recipes/parallax-image-collage]] for the technique family
- `visibility: "xl"` ×21 — decorative layers dropped below desktop wholesale, the widest use of the
  largest breakpoint in the corpus
- `title_style: "h1"` ×31 against `title_element: "h2"`/`"h3"` — marketing-scale display type on
  correct heading semantics
- `animation: "none"` 84 vs `fade` 36 — like design-escapes, scrollspy opt-*out* is explicit
- `panel_style: "card-primary"` ×5 for pricing-tier emphasis next to `card-default` ×15

## `css` usage — 22 nodes, 2,3%

`image` 12 · `panel-slider` 4 · `button` 3. The signature rule is the floating badge:

```css
.el-element { width: 195px; box-shadow: 0 5px 30px rgba(60, 65, 124, 0.12); border-radius: …; }
```

fixed-width shadowed chips over screenshots (11 of the 12 image rules). One image carries a pulsing
ring — `border-radius: 50%` + `box-shadow` + a keyframe `animation` — the only CSS animation in the
corpus. `.el-item { box-shadow: none; }` on panel-sliders strips card shadows the theme adds.

## The theme — `master-devstack`

567 lines.

| | |
|---|---|
| fonts | Manrope throughout (`@global-primary-font-family: inherit`) |
| palette | `#555371` text, `#0D0A46` emphasis, link and primary `#6F40F1` violet |
| `@global-background` | `#F7F8FC` — off-white page ground, so white cards read as raised |
| `@global-secondary-background` | `#171258` |
| `@global-border-radius` | `2px` |

The off-white `@global-background` is the load-bearing decision: every `card-default` pops without
borders. 5 style variants including two dark (`dark-purple`, `dark-red`).

## Caveats

All 10 exports are `5.0.0-beta.8` — the oldest uniformly-versioned demo. Check
`updates.php` before treating any prop as current ([[sources/websites-demo]], caveats).
