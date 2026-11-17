---
title: oakville demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/oakville/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-oakville/"]
tags: [source, demo, municipality, fragment, dynamic-content]
updated: 2026-07-29
---

# oakville demo

A municipality site — news, events, services, a city map. 4 pages, 268 nodes, 24 element types.
Part of [[sources/websites-demo]].

## Element mix

`column` 48 · `grid_item` 35 · `headline` 33 · `row` 31 · `grid` 15 · `button` 14 · `section` 10 ·
`fragment` 10 · `panel-slider_item` 7 · `map` 1 (+2 items)

A civic portal is grids of links: 15 `grid` elements on 10 sections, `panel_link: true` ×12.

## What it teaches

- **`fragment` for per-breakpoint row duplication**: `home` wraps the same row twice in fragments
  with `visibility: "m"` / `visibility: "hidden-m"` — the duplication idiom applied to whole
  compositions rather than single elements. 5 of the 10 fragments are `source`-bound, grouping
  repeated bound rows (news, announcements)
- **`grid_default: "auto"`** ×6 — the only demo leaning on auto columns, for link lists and logo
  strips whose item count varies with the bound query
- **The date-column idiom**: `.el-row > div:first-child { width: 120px; }` ×3 — a fixed-width
  first column for event dates, overriding the fraction system for one structural column. The
  named-width `layout` vocabulary (`large,expand`) solves adjacent cases; `120px` is not on its
  scale
- Broad civic dynamic content: 55 bound nodes across 11 types — `events.customEvents`,
  `posts.customPosts`, `announcementCats`, `places.customPlaces`, plus a bound `map_item`
  (markers from a source). See [[concepts/dynamic-content]]
- `height_viewport: "70"` / `"50"` — fractional viewport heroes, more restrained than the
  full-viewport demos
- `title_element: "div"` 24 vs `h2`/`h3` 28 — the semantics/style split again

## `css` usage — 6 nodes, 2,2%

The date-column rule above, one `min-height: 45vh` column, one `max-width: 20vw` image, and an
8-column cap for a logo wall (`max-width: calc(100% / 8)`). Near-zero CSS on a content-heavy site —
the civic counterpart to framerate's finding. See [[concepts/custom-css-boundary]].

## The theme — `master-oakville`

603 lines.

| | |
|---|---|
| fonts | Inter throughout |
| palette | `#4E4E4E` text, `#171712` emphasis, primary `#00509D` civic blue |
| `@global-link-color` | `lighten(@global-primary-background, 10%)` — **derived, not literal** |
| `@global-secondary-background` | `#0B294F` |
| `@global-border-radius` | `2px` |

The only theme in the corpus deriving a global colour with a LESS function — change the primary and
the link colour follows. 5 variants, all `white-*`.

## Caveats

`home` and `news-events` are `5.0.32`; `imprint` and `map` are `5.0.0-beta.4` — a wide version gap
inside one small demo.
