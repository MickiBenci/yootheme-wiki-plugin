---
title: design-escapes demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/design-escapes/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-design-escapes/"]
tags: [source, demo, travel, dynamic-content, panel-slider]
updated: 2026-07-29
---

# design-escapes demo

A travel platform — accommodations and destinations. 11 pages, 892 nodes, 28 element types. Part of
[[sources/websites-demo]].

## Element mix

`column` 193 · `row` 118 · `headline` 71 · `section` 69 · `button_item` 61 · `button` 59 ·
`grid_item` 53 · `list_item` 46 · `grid` 31 · `panel-slider` 19 · `panel` 19 · `gallery_item` 17

## The dynamic-content demo

**236 of its 892 nodes carry a `source` binding — 45% of all bindings in the corpus.** This is the
demo to read for [[concepts/dynamic-content]]:

- The six `discover-<country>` pages are **84 nodes each and structurally identical** — one template,
  re-exported per country, each driven by a different `discoverTags.customDiscoverTag` query. The
  layout JSON is the same; only the bound tag differs
- **38 `section` nodes are themselves bound** — background images and decorative titles pulled from
  the source, not just item text
- `#parent` (130 uses) inherits the enclosing query into items: a bound `panel-slider_item` maps
  `image`, `link`, `title`, `content` from fields like `field.intro_image.url`, with `filters`
  (e.g. `after: " Guests"`) transforming values inline
- Every `panel-slider` sets `panel_link: true` — the card loop is fully clickable

## What it teaches

- **`animation: "none"` is stored explicitly** (73 nodes) — the demo switches scrollspy off per
  element inside animated sections rather than leaving the prop empty. `fade` (60) is the sitewide
  entrance; only 3 parallax
- `layout: "1-3,2-3"` ×27 — the sidebar-plus-content split as the dominant row shape, not halves
- `media_blend_mode: "overlay"` ×13 — blend modes at volume, unique in the corpus
- `visibility` used in mirrored pairs (`m` 26 / `hidden-m` 17, `s` 13 / `hidden-s` 7) — the
  duplicated-element-per-breakpoint idiom of [[sources/demo-balou]] at scale
- `title_element: "h3"` 69 vs `title_style: "h3"` 48 — element and style chosen independently
  throughout, confirming the decoupling noted in [[sources/websites-demo]]

## `css` usage — 25 nodes, 2,8%

`panel` 13 · `section` 8 — and for once **not** the image idiom:

```css
@media (max-width: 959px) { .el-link { display: none; } }
```

×13 on panels: the card's link line is hidden below tablet-landscape while `panel_link` keeps the
card clickable — responsive de-cluttering with no prop equivalent, since `visibility` exists per
element, not per card sub-part. The `section` rules push `padding-bottom` to 240–260px for
overlap compositions. See [[concepts/custom-css-boundary]].

## The theme — `master-design-escapes`

561 lines.

| | |
|---|---|
| fonts | IBM Plex Sans body / Heebo headings |
| palette | `#666` text, `#000` emphasis, link and primary `#008776` green |
| `@global-secondary-background` | `#000` |
| `@global-border-radius` | `0` — the only sharp-cornered travel brand move |

5 style variants: `light-blue`, `white-darkblue`, `white-darkgreen`, `white-green`, `white-red`.

## Caveats

10 of 11 exports are `5.0.0-beta.8`; only `discover.json` is `5.0.32`. The custom sources
(`accommodations`, `discoverTags`, `accommodationCats`) are site configuration not included in the
export — the bindings reference fields the JSON alone cannot resolve.
