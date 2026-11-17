---
title: design-bites demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/design-bites/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-design-bites/"]
tags: [source, demo, resources, newsletter, accordion]
updated: 2026-07-29
---

# design-bites demo

A design-resources site — freebie downloads by category. 4 pages, 141 nodes, 17 element types — the
smallest demo in the corpus. Part of [[sources/websites-demo]].

## Element mix

`column` 28 · `headline` 22 · `row` 19 · `section` 10 · `image` 10 · `accordion_item` 10 · `text` 8 ·
`grid` 5 · `grid_item` 5 · `accordion` 4 · `newsletter` 2

One of only two demos using **`newsletter`** (with `layout: "grid"` — the inline field+button form),
and the corpus's cleanest **accordion FAQ**: 4 `accordion` containers, 10 items, on `about`.

## What it teaches

- **`style: muted` on 9 of 10 sections** — the whole site alternates muted panels on white, the
  opposite strategy to every other demo (which defaults to `default`). The tenth is `secondary`
- **`header_transparent` on every page** (5 occurrences across 4 pages, one per top section plus the
  landing variant) — small site, uniform hero treatment
- **Asymmetric `row.layout` as identity**: `1-4,3-4` ×4 and its mirror `3-4,1-4` — a narrow label
  column against wide content, rather than the usual halves
- `panel_style: "tile-secondary"` ×3 — tiles used for colour blocks, where cards would add chrome
- `grid` + `panel_link` ×5 with `grid_medium: "4"` — the resource-card wall
- Dynamic content on a small scale: 10 bound nodes — `grid_item` from `resources.customResources`
  and `resourceCats.customResourceCats`, two `button_item` from `pages.customPage` — see
  [[concepts/dynamic-content]]

## `css` usage — 8 nodes, 5,7%

All 8 are `image`, all the fluid-sizing idiom, at unusually large sizes for hero collage art:
`.el-image { max-width: 43vw; }` up to `70vw`. Nothing else — the design otherwise lives entirely in
props and theme. See [[concepts/custom-css-boundary]].

## The theme — `master-design-bites`

364 lines — nearly as short as `master-balou`.

| | |
|---|---|
| fonts | Poppins body / Montserrat headings |
| `@global-font-size` | `15px` |
| palette | `#444` text, `#333` emphasis, link and primary `#E64577` pink |
| `@global-secondary-background` | `#1C5BEA` — a second saturated accent, not a dark neutral |
| `@global-muted-background` | `#F7F7F7` — carries the 9 muted sections |
| `@global-primary-letter-spacing` | `-0.05rem` — tightened, not spaced |

The muted-section strategy only works because `@global-muted-background` is one step off white;
the two accents (pink primary, blue secondary) do the talking. 5 style variants, all `white-*`.

## Caveats

3 of 4 exports are `5.0.0-beta.8`; only `home.json` is `5.0.32`.
