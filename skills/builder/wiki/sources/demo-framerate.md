---
title: framerate demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/framerate/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-framerate/"]
tags: [source, demo, magazine, dynamic-content, slideshow]
updated: 2026-07-29
---

# framerate demo

A film-review magazine — reviews, news, trailers, episodes. 4 pages, 152 nodes, 22 element types.
Part of [[sources/websites-demo]].

## Element mix

`column` 32 · `row` 25 · `section` 14 · `headline` 14 · `grid_item` 14 · `grid` 9 ·
`overlay-slider_item` 8 · `panel` 6 · `quotation` 1 · `slideshow` 2

Small page count, wide type spread: a magazine front-end is many small loops, not long pages.

## What it teaches

- **Dynamic slideshow heroes.** `movies` and `tv-shows` open with a full-viewport `slideshow`
  (`height_viewport: "viewport"`) whose `slideshow_item` nodes are `source`-bound to
  `movies.customMovie` / `tvShows.customTvShow` — the hero *is* the loop. 28 of 152 nodes are
  bound (18%, the corpus's highest density), across 12 different node types including `fragment`,
  `overlay` and `image`. See [[concepts/dynamic-content]]
- **The lowest CSS ratio in the corpus: 1 node, 0,7%** (`.el-column { min-height: 590px; }`).
  Proof that a fully dynamic magazine layout needs essentially no custom CSS — the finding that
  anchors the corpus's CSS-budget argument in [[sources/websites-demo]]
- `grid_medium: "1"` ×3 — a *one-column* grid at tablet: the grid element used purely as a styled
  item loop, not for columns
- `quotation` (1 of only 2 in the corpus) — the pull-quote on `about`
- `layout: "large,expand"` — the named-width row vocabulary in the wild (fixed sidebar, fluid rest)
- `animation: "none"` 21 vs `fade` 11 — explicit scrollspy opt-out again

## The theme — `master-framerate`

556 lines.

| | |
|---|---|
| fonts | Roboto body / DM Sans headings |
| palette | `#444` text, `#111` emphasis, link `#e9b108`, primary `#fddf00` yellow |
| `@global-secondary-background` | `#111` — carries the cinema-dark sections |
| `@global-border-radius` | `0` |
| `@global-primary-letter-spacing` | `-0.02em` |

5 variants, two of them dark (`black-blue`, `black-red`) plus `dark-blue` — the darkest variant set
in the corpus, fitting the subject.

## Caveats

All 4 exports are `5.0.0-beta.8`. The `movies`/`tvShows` custom sources are site configuration not
present in the export.
