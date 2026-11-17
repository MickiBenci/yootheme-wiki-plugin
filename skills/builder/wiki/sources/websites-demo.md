---
title: YOOtheme demo websites corpus
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/"]
tags: [source, corpus, demo, layout, less, statistics]
updated: 2026-07-29
---

# YOOtheme demo websites corpus

77 page layouts exported from **12 official YOOtheme demo sites**, in `raw/websites-demo/<demo>/<page>.json`.
6.268 nodes, 47 element types, 399 distinct props.

Its value is different in kind from every source ingested so far. [[sources/yootheme-pro-5.0.33-source]]
says what a prop *can* be; [[sources/production-layout-sample]] says what one professional *did* set.
This corpus says what **YOOtheme itself** sets, across twelve complete sites — and it is the first source
that can be read **against the LESS theme that dresses it**.

## The LESS pairing

Every demo has its theme in `raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-<name>/`.
The mapping is one to one, with a single spelling shift: the export folder `kojiiro` pairs with
`master-kojiro`.

A theme is two files deep:

- `_import.less` — 360-645 lines. Redefines ~48 `@global-*` variables, always the same 48, plus
  component variables specific to the design
- `styles/*.less` — exactly 5 per theme, 105-135 lines each. Colour variants, almost nothing but
  `@global-*-color` and `@global-*-background`

37 further themes ship in `uikit-themes/` without a JSON export in this corpus. They are not documented.

## Why it matters: the CSS budget

**312 of 6.268 nodes carry a non-empty `css` prop — 5,0%.** Everything else is built from native props
and theme variables. That number is the empirical answer to "how do I build YOOtheme-friendly pages with
less CSS": you already can, and YOOtheme does.

Where the 5% goes is analysed in [[concepts/custom-css-boundary]]; the classes the CSS hooks onto are
[[concepts/el-classes]]; the six layers it sits at the bottom of are [[concepts/styling-hierarchy]].

## Per-demo profile

| demo | pages | nodes | `css` | %`css` | types | export versions | theme |
|---|---:|---:|---:|---:|---:|---|---|
| [[sources/demo-balou]] | 4 | 268 | 25 | 9,3 | 21 | beta.8 · 5.0.32 | `master-balou` |
| [[sources/demo-dennis-miller]] | 8 | 591 | 46 | 7,8 | 24 | beta.8 · 5.0.32 | `master-dennis-miller` |
| [[sources/demo-design-bites]] | 4 | 141 | 8 | 5,7 | 17 | beta.8 · 5.0.32 | `master-design-bites` |
| [[sources/demo-design-escapes]] | 11 | 892 | 25 | 2,8 | 28 | beta.8 · 5.0.32 | `master-design-escapes` |
| [[sources/demo-devstack]] | 10 | 937 | 22 | 2,3 | 27 | beta.8 | `master-devstack` |
| [[sources/demo-fc-greenfield]] | 5 | 618 | 22 | 3,6 | 28 | beta.2.1 · beta.12 · 5.0.3 · 5.0.17 | `master-fc-greenfield` |
| [[sources/demo-framerate]] | 4 | 152 | 1 | 0,7 | 22 | beta.8 | `master-framerate` |
| [[sources/demo-glowbar]] | 12 | 1112 | 46 | 4,1 | 31 | beta.8 · 5.0.32 | `master-glowbar` |
| [[sources/demo-kojiiro]] | 3 | 165 | 10 | 6,1 | 16 | beta.8 · 5.0.32 | `master-kojiro` |
| [[sources/demo-line-gallery]] | 6 | 539 | 53 | 9,8 | 30 | beta.8 | `master-line-gallery` |
| [[sources/demo-oakville]] | 4 | 268 | 6 | 2,2 | 24 | beta.4 · 5.0.32 | `master-oakville` |
| [[sources/demo-quantum-flares]] | 6 | 585 | 48 | 8,2 | 26 | beta.8 · beta.12 | `master-quantum-flares` |

`framerate` at 0,7% and `line-gallery` at 9,8% bracket the range. Neither is the more sophisticated
design — the difference is what the design asks of images, not how well it was built.

## Element type coverage

Every node root is `{"type": "layout", "children": [...], "version": "..."}` — no `id`, `props` absent
on the root. Consistent with the invariants in [[sources/skill-yootheme-json-schema]] throughout all 77 files.

47 of the 59 in-scope types appear. Frequency, and how many of the 12 demos use each:

| type | nodes | demos | | type | nodes | demos |
|---|---:|---:|---|---|---:|---:|
| `column` | 1145 | 12 | | `divider` | 72 | 10 |
| `row` | 752 | 12 | | `nav_item` | 55 | 3 |
| `headline` | 705 | 12 | | `gallery` | 51 | 8 |
| `grid_item` | 431 | 11 | | `overlay` | 50 | 6 |
| `image` | 413 | 12 | | `social_item` | 50 | 5 |
| `section` | 338 | 12 | | `description_list` | 47 | 4 |
| `list_item` | 259 | 9 | | `fragment` | 41 | 5 |
| `button_item` | 211 | 12 | | `accordion` | 38 | 6 |
| `button` | 203 | 12 | | `panel-slider` | 27 | 5 |
| `text` | 199 | 12 | | `overlay-slider` | 21 | 8 |
| `description_list_item` | 156 | 4 | | `table_item` | 16 | 1 |
| `gallery_item` | 155 | 8 | | `social` | 14 | 5 |
| `grid` | 142 | 11 | | `slideshow_item` | 12 | 5 |
| `panel` | 124 | 10 | | `video` | 12 | 3 |
| `overlay-slider_item` | 123 | 8 | | `nav` | 9 | 3 |
| `accordion_item` | 123 | 6 | | `map_item` | 8 | 6 |
| `list` | 81 | 9 | | `map` | 7 | 6 |
| `layout` | 77 | 12 | | `slideshow` | 6 | 5 |
| `panel-slider_item` | 73 | 5 | | `popover_item` | 5 | 1 |

Tail, one or two demos each: `subnav` 3, `subnav_item` 3, `quotation` 2, `newsletter` 2, `table` 2,
`countdown` 2, `html` 1, `search` 1, `popover` 1.

**Six builder elements never appear**: `alert`, `code`, `icon`, `switcher`, `switcher_item`, `totop`.
Absence from a marketing demo is not evidence of disuse — `totop` in particular is a template-part
element, not a page one.

Two used types live outside `packages/builder/`: `newsletter` (`packages/builder-newsletter/`) and
`search` (`packages/builder-wordpress/`).

## The structural spine

Four parent→child pairs account for 2.769 of the 6.268 nodes:

```
layout > section  338      section > row  698
row > column     1145      column > <anything>
```

`column` is the universal wrapper: every content element in the corpus is a child of a `column`, without
exception. `grid > grid_item` (431) and `list > list_item` (259) are the only other high-volume pairs, and
both are container/item families, not layout.

`fragment` appears 41 times and always wraps rows (`fragment > row` 54) — a reusable block, not a layout node.

## Dynamic content: the `source` node key

**521 nodes across 11 demos carry a `source` key at node level** — a sibling of `type` and `props`,
not inside `props`. It holds a `query` (a named source field with `arguments` such as
`offset`/`limit`/`order`, or `#parent` — 319 of 521 — to inherit the enclosing query) and a `props`
map binding element props to source fields, optionally through `filters`. The
[[sources/skill-yootheme-json-schema]] skill does not cover this key at all; these exports are its
first verified documentation. Full write-up: [[concepts/dynamic-content]].

Most bound types: `list_item` 72 · `headline` 71 · `button_item` 65 · `panel` 59 · `grid_item` 55 ·
`section` 46 (background images and titles from content). Nearly every query name is a **custom
source** (`accommodations.customAccommodations`, `movies.customMovies`, …): the demos run on custom
post types whose definitions are site configuration, absent from the export.
[[sources/demo-design-escapes]] (236 bound nodes) and [[sources/demo-line-gallery]] (124) are the
demos to read.

## Recurring techniques

Extracted as recipes or verified against the source during this ingest:

- **`sticky: "cover"` section sequences** — glowbar ×11, fc-greenfield ×1, with
  `parallax_target: "![class*='uk-section-'] ~ [class*='uk-section-']"` so child parallax runs on
  the covering section's scroll → [[recipes/sticky-cover-sections]]
- **Parallax image collages** — clusters of `position: absolute` images with
  `animation: "parallax"` (balou, kojiiro, fc-greenfield, quantum-flares, devstack) →
  [[recipes/parallax-image-collage]]
- **Full-viewport hero slideshow behind a transparent header** — balou, framerate →
  [[recipes/fullscreen-hero-slideshow]]
- **`description_list` price/menu lists** — glowbar ×37, balou →
  [[recipes/price-list-description-list]]
- **Duplicated elements per breakpoint** — two siblings with mirrored `visibility` (`m`/`hidden-m`,
  `xl`/`hidden-xl`) whenever a breakpoint needs different *props*, which `visibility` alone cannot
  express. Peaks at 45+45 nodes in quantum-flares
- **`fragment` as the grouping wrapper** — shared `animation`, `visibility`, margin or `source`
  binding over a set of rows (fc-greenfield timeline, oakville news blocks)
- **Column widths live on the column.** 549 columns carry `width_medium`, 221 `width_small` —
  `row.layout` is the authoring shorthand, the per-breakpoint `column.width_*` props are what the
  template renders. This contradicted a wiki claim → [[issues/column-width-props]]

## Dominant values

The distributions that matter when writing a snippet by hand. Full context in the linked prop pages.

| prop | dominant value | share | note |
|---|---|---|---|
| `image_position` | `center-center` | 1438 / 1483 | the default is essentially never changed — see [[props/image-family]] |
| `margin_top` / `margin_bottom` | `default` | 854 / 2130 · 850 / 2129 | `remove` second at ~22% — see [[props/margin]] |
| `block_align` | `center` | 442 / 478 | `right` 36, `left` never — see [[props/alignment]] |
| `animation` | `parallax` | 343 / 877 | **beats `fade` (141)**; `none` 316 — see [[props/animation]] |
| `image_align` | `left` | 809 / 1117 | `top` 251, `right` 47, `bottom` 10 |
| `column_breakpoint` | `m` | 298 / 327 | the tablet breakpoint is the stacking point |
| `grid_column_gap` | `small` | 267 / 344 | `medium` 43, `large` 21 — `default` is never written |
| `maxwidth` | `large` | 290 / 546 | `xlarge` 135, `2xlarge` 92 |
| `panel_style` | `card-default` | 38 / 51 | `card-primary` 12, `card-overlay` 1 — see [[props/panel-style]] |
| `style` (section) | `default` | 280 / 358 | `primary` 29, `muted` 11, `secondary` 9 |
| `title_style` | `h5` | 153 / 902 | then `h3` 141, `h1` 121 — the `heading-*` scale takes ~20% |
| `title_element` | `h2` | 392 / 1181 | **`div` is second at 387** — style and semantics are decoupled |
| `vertical_align` | `middle` | 333 / 655 | |
| `padding_bottom` (section) | `none` | 143 / 306 | `xlarge` 93, `large` 69 |

## What is new

- **`headline.link_style` is a checkbox, not a style select.** In the corpus it carries `true` (26) and
  `false` (8) — boolean, where 533 other nodes carry it as a string. `headline/element.php:122` confirms:
  `'type' => 'checkbox'`, label *"Show hover effect if linked"*, gated by `enable => 'link'`. Same prop
  name, different field type, different meaning. Recorded in [[props/link]]
- **`row.layout` has three vocabularies, not one.** Fractions (`1-2,1-2`), named widths
  (`large,expand`, `expand,large,expand`, `large,expand,large` — 4 occurrences), and a `|` separator
  carrying a second layout for the smaller breakpoint
  (`1-4,1-4,1-4,1-4|1-2,1-2,1-2,1-2`, `1-5,1-5,1-5,1-5,1-5|1-2,1-2,1-3,1-3,1-3`). 18 distinct values on
  320 rows. Detailed in [[elements/row]]
- **`layout` is a prop name on three unrelated elements.** `row.layout` is the column split;
  `description_list.layout` takes `grid-2` / `grid-2-m`; `newsletter.layout` takes `grid`. Nothing is
  shared between them but the key
- **`column.style` accepts card and tile values.** All nine card/tile `style` occurrences in the
  corpus sit on `column` nodes — `fc-greenfield` `card-default` (4) and `card-primary` (3),
  `oakville` `card-overlay`, plus `tile-*` in five demos. `column/element.php` declares the full
  ten-value list (`'source' => true`), turning a layout column into a styled box. *(Corrected
  2026-07-29: a first draft of this page attributed these values to `section.style`; per-node
  verification shows `section.style` never leaves its own four values.)*
- **`animation: parallax` is the single most used animation value**, not a special effect. 343 of 877.
  Two demos (`kojiiro`, `balou`) use it as their *only* animation
- **Exports serialise the resolved prop set**, confirming [[sources/production-layout-sample]]:
  `image_position: center-center` on 1483 nodes is the default written out, not 1483 decisions

## What it confirms

- The invariants of [[sources/skill-yootheme-json-schema]] hold on 6.268 real nodes: no node `id`,
  `props` always an object, `children` always an array, `image` and `link` always strings, no `null`
- `grid` is used for card collections and `panel` for the standalone case — no `panel` inside a `grid`
  anywhere in 77 files. Confirms [[elements/grid]]
- `column_breakpoint: m` is the idiom, not `s` — [[elements/grid_item]] and [[props/alignment]]

## What it contradicts

One wiki claim: [[recipes/service-card-grid]] listed `column.width_medium` as an inert pre-5.0
leftover. The corpus (770 columns carrying `width_*`) and the source
(`column/templates/template.php:45-51` renders them; the row's *Column Layout* panel writes them as
`child-prop` fields) prove the opposite — see [[issues/column-width-props]]. The recipe page carries
the correction. Beyond that, only the `headline.link_style` name collision, which is friction rather
than contradiction.

## Caveats

- **52 of the 77 exports declare `5.0.0-beta.8`**, and `fc-greenfield` alone mixes four versions
  (`beta.2.1`, `beta.12`, `5.0.3`, `5.0.17`). Only 17 files are at `5.0.32`. Before treating any prop
  seen here as current, check `packages/*/elements/<name>/updates.php` — a value present in the JSON may
  have been migrated since
- These are **marketing demos**. They optimise for showing range, not for the restraint a client project
  needs. The frequency tables say what YOOtheme demonstrates, not what is always correct
- The exports are page layouts only. No template parts, no theme settings, no Customizer state — the
  LESS side of the pairing comes from the theme files, not from the export
- `styles/*.less` variants cannot be matched to a specific export: the JSON does not record which style
  was active
