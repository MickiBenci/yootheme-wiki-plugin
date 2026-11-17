---
title: uk-grid and uk-child-width
type: uikit
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [uikit, grid, layout, less-variables, responsive]
updated: 2026-07-29
---

# `uk-grid` and `uk-child-width-*`

The flexbox grid behind [[elements/grid]], behind the two-cell layout a [[elements/panel]] builds
for a left- or right-aligned image, and behind `row`/`column`. Source:
`raw/yootheme-pro-5.0.33/vendor/assets/uikit/src/less/components/grid.less` and `width.less`.

## Two things, not one

- **`uk-grid`** is both a class *and* an attribute. The class carries the negative-margin gutter
  mechanics; the bare `uk-grid` attribute activates the JavaScript component (stacking detection,
  masonry, parallax). `elements/grid/templates/template.php` emits both
- **`uk-child-width-*`** is a separate component that sizes the children. The grid itself does not
  know how many columns you want

## How the columns prop maps

`grid/templates/template.php:36-40`:

```php
'uk-child-width-[1-{@!grid_default: auto}]{grid_default}',
'uk-child-width-[1-{@!grid_small: auto}]{grid_small}@s',
…
```

| `grid_*` value | Class |
|---|---|
| `'3'` | `uk-child-width-1-3` |
| `'auto'` | `uk-child-width-auto` |
| `''` | nothing emitted — inherits the previous breakpoint |

`width.less:33-39` gives the widths: `1-2` is 50%, `1-3` is `calc(100% / 3)`, `1-4` 25%, `1-5` 20%,
`1-6` `calc(100% / 6)`, `auto` is `width: auto`.

Breakpoint suffixes are `@s @m @l @xl`. There is **no `@xs`** — `grid_default` is unsuffixed and
covers phone portrait upward, which is why it alone has no "Inherit" option in
[[elements/grid]]. Inheritance is plain CSS cascade: an unemitted breakpoint keeps the last one set.

## Gutters

`grid.less:29-46` — a gutter is a negative margin on the container plus matching padding on the
children, not a `gap`.

| Variable | Default |
|---|---|
| `@grid-gutter-horizontal` | `@global-gutter` |
| `@grid-gutter-vertical` | `= @grid-gutter-horizontal` |
| `@grid-gutter-horizontal-l` / `-vertical-l` | `@global-medium-gutter` |
| `@grid-small-gutter-horizontal` | `@global-small-gutter` |
| `@grid-medium-gutter-horizontal` | `@global-gutter` |
| `@grid-large-gutter-horizontal` | `@global-medium-gutter`, `@global-large-gutter` at `l` |
| `@grid-divider-border-width` | `@global-border-width` |
| `@grid-divider-border` | `@global-border` |

Note the default gutter and the *medium* gutter are the same value: `grid_column_gap: ''` and
`grid_column_gap: 'medium'` are visually identical below the `l` breakpoint, and diverge above it
because only the default gutter steps up.

### Equal vs split gap classes

`grid/templates/template.php:43` branches:

```php
$props['grid_column_gap'] == $props['grid_row_gap']
  ? 'uk-grid-{grid_column_gap}'
  : '[uk-grid-column-{grid_column_gap}] [uk-grid-row-{grid_row_gap}]'
```

`uk-grid-small` sets both axes; `uk-grid-column-small` + `uk-grid-row-small` set them separately.
The same equal/different branch appears in `section` padding — see [[elements/section]].

`'collapse'` → `uk-grid-collapse` (`grid.less:187-195`), zero on both axes.

## `uk-grid-match`

Added by `template.php:45` whenever masonry is off, so cards stretch to equal height by default in a
YOOtheme grid. Masonry deliberately drops it — unequal heights are the point of masonry.

`uk-grid-match` stretches the immediate children. Making the *card contents* align — links on a
common baseline — is a different mechanism, the `*_margin_auto` expand flags on
[[elements/panel]].

## `uk-grid-divider`

`grid.less:202-251`. The divider is a `::before` pseudo-element on every child except
`.uk-first-column`, and it **doubles the gutter**: `margin-left: -(@grid-gutter-horizontal * 2)`,
with the rule repeating at the `l` breakpoint.

So turning `grid_divider` on visibly widens the gaps, independently of `grid_column_gap`. That is
why [[elements/grid]] gates it on neither gap being `collapse` — a divider with no gutter has
nowhere to sit.

`uk-first-column` and `uk-grid-margin` are applied by the JavaScript component at runtime, which is
why the bare `uk-grid` attribute is required for dividers and stacking to behave.

## `uk-grid-stack`

Set by the JS when children wrap onto multiple rows. `uk-grid-divider.uk-grid-stack` then also
doubles the vertical margin and draws horizontal dividers between rows.

## Where else the builder emits a grid

Not only the `grid` element:

- **`panel` with `image_align: left|right`** — `panel/templates/template.php:108-124` builds a
  two-cell `uk-grid` with `uk-width-{image_grid_width}@{breakpoint}` and `uk-width-expand`. This is
  `uk-width-*` on individual cells, not `uk-child-width-*`
- **`grid` with `filter_position: left|right`** — a wrapper grid around navigation and content
- **`row` / `column`** — the page layout grid, driven by `row.layout` fractions

`uk-width-*` sizes one element, `uk-child-width-*` sizes all children of a container. YOOtheme uses
both, and mixing them up is a common source of confusion when reading emitted markup.

## `tm-grid-expand`

`raw/yootheme-pro-5.0.33/less/theme.less:533-580` — a YOOtheme extension, not UIkit:
`.uk-grid.tm-grid-expand > * { flex-grow: 1 }` with `.uk-width-expand` getting `flex-grow: 999`,
repeated per breakpoint. The comment in the source says it exists to override
`uk-child-width-auto` for the WooCommerce Filter element.

## Where to override

`@grid-*` variables belong in the child theme's `theme.<slug>.less`. `tm-*` classes are not LESS
variables and go in `custom-child-style.css`. Per-element tweaks go in the element `css` field —
see [[props/advanced-group]]. For the Customizer's own two style mechanisms (physical
`theme.<slug>.less` files vs the `styler.library.{id}` custom-style JSON) see
[[concepts/customizer-less-map]].

## Related

[[elements/grid]] · [[elements/grid_item]] · [[elements/panel]] · [[elements/section]] ·
[[uikit/uk-card]] · [[recipes/service-card-grid]]
