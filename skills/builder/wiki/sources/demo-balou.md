---
title: balou demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/balou/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-balou/"]
tags: [source, demo, shop, parallax]
updated: 2026-07-29
---

# balou demo

A knitwear shop — *Knit & More*. 4 pages, 268 nodes, 21 element types. Part of
[[sources/websites-demo]].

## Element mix

`column` 57 · `row` 35 · `image` 28 · `headline` 26 · `section` 16 · `description_list_item` 16 ·
`text` 14 · `grid_item` 13 · `overlay-slider_item` 12 · `button_item` 9

The smallest vocabulary of any demo with a shop, and the highest `image`-to-`headline` ratio outside
`kojiiro`: this design carries its message in pictures.

`description_list` (7 containers, 16 items) is used for opening hours and product specs — the demo that
justifies the element existing.

## What it teaches

- **`animation: parallax` is the only animation in the file** — 24 occurrences, no `fade`, no `slide-*`.
  Consistent with the corpus-wide finding that `parallax` is the most used value, not a special effect.
  See [[props/animation]]
- **`layout: grid-2` on `description_list`** (7 of 16) — the value vocabulary of `description_list.layout`
  has nothing in common with `row.layout`, despite the shared prop name
- `title_style` sits low on the scale: `h5` 15, `h6` 12, `h4` 5. A single `heading-2xlarge` for the hero.
  Small type is a deliberate design choice carried by props, not CSS
- Section widths stay at `default` (10) — this is a boxed design, not a full-bleed one

## `css` usage — 25 nodes, 9,3%

The second-highest ratio in the corpus, and almost all of it one idiom:

```css
.el-image { max-width: 25vw; }
```

22 of 25 are `image`, setting `max-width` in `vw` — sometimes floored with `min-width: 150px`. This is
decorative-image art direction: a size that scales with the viewport, which `image_width` cannot express
because it takes a single pixel value. See [[concepts/custom-css-boundary]].

The two `section` rules push hero padding past what `padding: xlarge` gives:

```css
@media (min-width: 960px) { .el-section > div { padding-top: 350px; padding-bottom: 350px; } }
```

## The theme — `master-balou`

The shortest `_import.less` in the corpus at 362 lines.

| | |
|---|---|
| fonts | Raleway 500 body / Montserrat 600-700 headings |
| `@global-font-size` | `15px` — the smallest in the corpus |
| `@global-primary-text-transform` | `uppercase`, `@global-primary-letter-spacing: 3px` |
| palette | `#515070` text on `#fff`, emphasis `#26244c`, link `#82a0b5` |
| `@global-primary-background` | `#e2e9ee` — a pale tint, not a saturated accent |
| `@global-border-radius` | `4px` |

The uppercase + 3px letter-spacing on `@global-primary-*` is what gives every `title_style: h5` and `h6`
in the layout its look. Nothing in the JSON says "uppercase": the theme does. See
[[concepts/styling-hierarchy]].

5 style variants: `white-beige`, `white-grey`, `white-orange`, `white-pink`, `white-turquoise` — all
light, all differing only in accent.

## Caveats

3 of 4 exports are `5.0.32`; `home.json` is `5.0.0-beta.8`.
