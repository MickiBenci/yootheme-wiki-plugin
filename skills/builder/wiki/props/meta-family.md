---
title: meta prop family
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, meta, eyebrow, typography]
updated: 2026-07-29
---

# The `meta_*` family

Six props on 12 elements. `meta` is the short secondary label beside a title — a category, a date, a
role, a price. Definitions from `elements/grid/element.php:911-1002`, rendering from
`elements/panel/templates/template-content.php:22-32`.

The smallest of the card families, and the one that does the most work per prop, because
`meta_align` alone moves the text to four different places in the tree.

| Prop | Values | Default | Emits |
|---|---|---|---|
| `meta_style` | `''` · `text-meta` `text-lead` `text-small` `text-large` · `heading-3xlarge`…`heading-small` · `h1`–`h6` | `'text-meta'` | `uk-{meta_style}` |
| `meta_color` | `''` `muted` `emphasis` `primary` `secondary` `success` `warning` `danger` | — | `uk-text-{meta_color}` |
| `meta_align` | `'above-title'` `'below-title'` `'above-content'` `'below-content'` | `'below-title'` | Position in the tree, not a class |
| `meta_element` | `h1`–`h6` `div` | `'div'` | The tag itself |
| `meta_margin` | `xsmall` `small` `''` `medium` `large` `xlarge` `remove` | — | `uk-margin-{value}-top` |
| `meta_margin_auto` | bool | — | `uk-margin-auto-bottom` |

Note `meta_color` lacks the `background` value that [[props/title-family]] has — no `<span>`
wrapping happens here.

## `meta_align` is placement, not alignment

The name misleads: it does not align the text horizontally. It chooses **which of four slots** the
meta element is rendered into (`template-content.php:102-141`):

```
above-title    →  before the title, inside the title cell
below-title    →  after the title, inside the title cell
above-content  →  after the image (if `between`), before the content
below-content  →  after the content, before the link
```

The first two sit inside the title grid cell when `title_align: 'left'`; the last two sit in the
content cell. So switching from `below-title` to `above-content` moves the meta **across a grid
boundary** in a left-aligned-title layout, which changes its width and its wrapping behaviour, not
just its order.

`'above-title'` is the **eyebrow** position — the short label above a heading. Using the built-in
`meta` prop for this is preferable to a separate `headline` element with a utility class wherever the
element has one, because it keeps the label inside the card's own flex flow. All the eyebrow
variants — including styling the slot via the `css` prop's `.el-meta` selector — are in
[[recipes/eyebrow-label]].

## The conditional bottom-margin reset

`template-content.php:29`:

```php
'uk-margin-remove-bottom {@!meta_margin_auto}' => str_starts_with($props['meta_style'] ?? '', 'h') || $props['meta_element'] != 'div',
```

The reset is applied **only** when the style is a heading (`h1`–`h6`) **or** the element is not a
`div`. With the defaults — `meta_style: 'text-meta'`, `meta_element: 'div'` — neither holds, so no
reset is emitted and the meta keeps whatever bottom margin its style carries.

The equivalent line for `content` (`:45`) tests only the style, and the one for `title` (`:15`) is
unconditional. Three sibling regions, three different rules — worth checking the template rather than
assuming symmetry when spacing looks off.

## Interaction with the title sub-grid

`template-content.php:67-68` — when the title is a left-aligned grid and the image is aligned `top`,
the grid's own top margin comes from `meta_margin` instead of `title_margin` if a meta exists in the
`above-title` position:

```php
'uk-margin[-{title_margin}]-top … ' => !$props['meta'] || $props['meta_align'] != 'above-title',
'uk-margin[-{meta_margin}]-top … {@meta} {@meta_align: above-title}',
```

The topmost visible region owns the spacing. Adding an eyebrow therefore transfers control of the
block's top margin from `title_margin` to `meta_margin`.

## Display gating

`show_meta: false` blanks the prop before render — see [[props/show-switches]]. Unlike title and
content, `meta` has **no** `meta_display` prop: it is never a lightbox caption. See
[[props/lightbox]].

## Related

[[props/title-family]] · [[props/content-family]] · [[props/margin]] · [[props/show-switches]] ·
[[elements/panel]] · [[elements/grid]] · [[elements/grid_item]] · [[recipes/eyebrow-label]]
