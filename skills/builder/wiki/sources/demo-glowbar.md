---
title: glowbar demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/glowbar/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-glowbar/"]
tags: [source, demo, salon, sticky-cover, description-list, price-list]
updated: 2026-07-29
---

# glowbar demo

A beauty salon — services, prices, lookbook. 12 pages, 1112 nodes, 31 element types — the largest
demo in the corpus by both counts. Part of [[sources/websites-demo]].

## Element mix

`headline` 153 · `column` 133 · **`description_list_item` 131** · `accordion_item` 90 · `image` 89 ·
`row` 86 · `gallery_item` 60 · `section` 41 · `nav_item` 40 · `description_list` 37 · `accordion` 30 ·
`gallery` 30 · `video` 4

Five service pages (`permanent-makeup`, `manicure-pedicure`, `skin-care`, `hair-removal`,
`eyelashes-eyebrows`) are **143 nodes each and structurally identical** — the same template
duplicated and re-filled by hand (unlike design-escapes, whose clones are dynamic).

## The price-list demo

37 `description_list` elements with 131 items are the service menus: `layout: "grid-2-m"`,
`title_leader: true` (the dotted leader line), `meta` carrying the price, `meta_color: "emphasis"`.
Lifted into [[recipes/price-list-description-list]]. The 30 `accordion` containers do the same job
in collapsed form on the service pages — two idioms for one content model.

## What it teaches

- **`sticky: "cover"` at scale**: 11 of the corpus's 12 sticky-cover sections are here
  (`pricing.json`, `services.json`). Each price section pins while the next slides over it;
  `image_effect: "parallax"` ×23 and `media_overlay: "rgba(0, 0, 0, 0.75)"` ×23 run the backgrounds,
  and child parallax uses `parallax_target: "![class*='uk-section-'] ~ [class*='uk-section-']"` to
  animate on the *covering* section's scroll → [[recipes/sticky-cover-sections]]
- **`height_viewport: true` ×65** — the corpus's heaviest use of viewport-sized elements
  (`image`, `video`, `map`), giving every page full-bleed media panels
  (`section.width: "expand"` ×25)
- **`nav` as anchor menu**: `pricing` opens with a `nav` of `#permanent-makeup`-style anchor links
  into its own sticky sections — in-page wayfinding with section `id` props
- `text_color: "light"` ×103 — dark imagery under light text as the default state
- Mirrored `visibility` at maximum: `m` 39 / `hidden-m` 39 — every service page duplicates its
  header composition per breakpoint
- `maxwidth: "large"` ×211 — one value, applied almost everywhere text runs over media

## `css` usage — 46 nodes, 4,1%

`headline` 37 · `row` 9, and **none of it is image sizing** — it is editorial stagger:

```css
@media(min-width: 1200px) { .el-element { margin-top: 100px; } }   /* ×30 */
@media(min-width: 1200px) { .el-row { margin-top: 30vh!important; } }
```

offset columns and overlapping rows above the desktop breakpoint, plus `translate: 0 -50%` ×5
pulling headlines across section boundaries. The margin scale caps at `xlarge`; `30vh` does not
exist as a prop. See [[concepts/custom-css-boundary]].

## The theme — `master-glowbar`

512 lines.

| | |
|---|---|
| fonts | Be Vietnam Pro throughout |
| palette | near-monochrome: `#1D1D1D` text and primary, `#000` emphasis, link `#1D1D1D` |
| `@global-muted-background` | `#F7F7F7` |
| `@global-border-radius` | `2px` |

A colourless theme — the photography is the palette; links are not even distinguished by colour.
5 variants: `colored-pink`, `light-brown`, `light-green`, `light-red`, `white-brown`.

## Caveats

10 of 12 exports are `5.0.0-beta.8`; `home` and `services` are `5.0.32`. Only 2 dynamic bindings in
1112 nodes — the demo is hand-filled, which is what makes its five identical service pages a
maintenance cautionary tale rather than a pattern to copy.
