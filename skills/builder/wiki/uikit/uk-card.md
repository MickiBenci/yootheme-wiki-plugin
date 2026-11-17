---
title: uk-card and uk-tile
type: uikit
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [uikit, card, tile, panel, less-variables]
updated: 2026-07-29
---

# `uk-card` and `uk-tile`

The two UIkit components behind the `panel_style` prop of [[elements/panel]] and
[[elements/grid]]. Component source: `raw/yootheme-pro-5.0.33/vendor/assets/uikit/src/less/components/card.less`
and `.../tile.less`, with the YOOtheme overrides in `vendor/assets/uikit-themes/master/`.

## What `panel_style` actually emits

Read off `elements/panel/templates/template.php:73-74`:

| `panel_style` | Classes emitted |
|---|---|
| `''` | `uk-panel` |
| `card-default` … `card-overlay` | `uk-card uk-card-<variant>` |
| `tile-default` … `tile-secondary` | `uk-panel uk-tile-<variant>` |

**A tile is a `uk-panel` that happens to have a tile background; a card is not a panel at all.**
That distinction drives everything below.

## The padding split

`template.php:97-100` picks the padding class from the same branch:

```php
'uk-padding[-{!panel_padding: default}] {@panel_style: |tile-.*} {@panel_padding}',
'uk-card-body {@panel_style: card-.*} {@panel_padding}',
```

| Style | `panel_padding` value | Class |
|---|---|---|
| blank / tile | `'default'` | `uk-padding` |
| blank / tile | `'small'` `'large'` | `uk-padding-small` / `uk-padding-large` |
| card | any | `uk-card-body` |

So `panel_padding` on a card is effectively a **boolean**: any non-empty value emits the same
`uk-card-body`, and the small/large distinction is lost. To vary padding inside a card you override
`@card-body-padding-*` in LESS, or scope CSS to `.el-element` — see [[props/advanced-group]].

## Card LESS variables

From `card.less:29-80`. These are the hooks to override in a child theme's
`theme.<slug>.less`; naming follows `@{component}-{sub-object}-{modifier}-{state}-{property}`.

| Variable | Default |
|---|---|
| `@card-body-padding-horizontal` / `-vertical` | `@global-gutter` |
| `@card-body-padding-horizontal-l` / `-vertical-l` | `@global-medium-gutter` — the desktop step-up |
| `@card-title-font-size` | `@global-large-font-size` |
| `@card-title-line-height` | `1.4` |
| `@card-default-background` | `@global-muted-background` |
| `@card-default-color` | `@global-color` |
| `@card-default-title-color` | `@global-emphasis-color` |
| `@card-default-hover-background` | `darken(@card-default-background, 5%)` |
| `@card-default-color-mode` | `dark` |
| `@card-primary-background` | `@global-primary-background` |
| `@card-primary-color` | `@global-inverse-color` |
| `@card-secondary-background` | `@global-secondary-background` |
| `@card-overlay-background` | `fade(@global-background, 90%)` |
| `@card-hover-background` | `@global-muted-background` |
| `@card-badge-*` | Position `15px/15px`, height `22px`, primary background |

Card padding responds to the `l` breakpoint on its own — a card is roomier on desktop without any
prop being set.

### `color-mode` and automatic inversion

`card.less:273-276` — each variant carries a `@card-<variant>-color-mode` of `light` or `dark`, and
the LESS extends `.uk-light` or `.uk-dark` accordingly. `light` means *light text on a dark
background*.

Defaults: `card-default` is `dark`, `card-primary` and `card-secondary` are `light`. **Change
`@card-primary-background` to a pale colour and the text stays white** until you also flip
`@card-primary-color-mode` to `dark`. The commonest card-styling mistake.

The extend deliberately skips media: `> :not([class*="uk-card-media"])`, so an image inside a card
is not colour-inverted.

## Tile LESS variables

From `tile.less:23-49`:

| Variable | Default |
|---|---|
| `@tile-padding-horizontal` | `15px`, rising to `@global-gutter` at `s` and `@global-medium-gutter` at `m` |
| `@tile-padding-vertical` | `@global-medium-margin`, `@global-large-margin` at `m` |
| `@tile-xsmall/small/large/xlarge-padding-vertical` | Size steps |
| `@tile-default-background` | `@global-background` |
| `@tile-muted-background` | `@global-muted-background` |
| `@tile-primary-background` | `@global-primary-background` |
| `@tile-secondary-background` | `@global-secondary-background` |
| `@tile-<variant>-color-mode` | `dark` for default and muted, `light` for primary and secondary |

Tiles have **no `@tile-title-*`**: a tile does not restyle its heading, a card does. If a card style
is changing your heading colour unexpectedly, `@card-<variant>-title-color` is why.

Note `@card-default-background` is `@global-muted-background` while `@tile-default-background` is
`@global-background` — "default" means opposite things in the two components.

## Hover

`card.less:233` — `uk-card-hover` only applies its hover background when the element is *not*
already `uk-card-default|primary|secondary|overlay`. The styled variants get their hover from
`@card-<variant>-hover-background` instead.

Which is exactly why `panel_link_hover` is gated on
`$match(panel_style, 'card-(default|primary|secondary|overlay)|tile-')` in `element.php`: on
`card-hover` the class is already there, and on a blank panel there is nothing to hover. See
[[props/link]].

`uk-tile-hover` is the tile equivalent, added by the same prop.

## `uk-card-media-*`

`card.less:163-169`. When a card has `panel_image_no_padding` and a non-`between` image alignment,
`panel/templates/template.php:167-181` wraps the image in `uk-card-media-{image_align}` so it
bleeds to the card edge, and attaches a `uk-toggle` that swaps to `uk-card-media-top` below the
image breakpoint — a left-aligned image becomes a top image when the card stacks.

## Where to override

Per this repo's CSS override hierarchy:

1. **UIkit variables and hooks** → the child theme's `theme.<slug>.less`. Anything in the tables above
2. **`tm-*` classes and rules not expressible as LESS** → `custom-child-style.css`
3. **One element only** → the element's `css` field, scoped to `.el-element` / `.el-title` / …

For the Customizer's own two style mechanisms (physical `theme.<slug>.less` files vs the
`styler.library.{id}` custom-style JSON) see [[concepts/customizer-less-map]].

## Related

[[elements/panel]] · [[elements/grid]] · [[uikit/uk-grid]] · [[props/link]] ·
[[props/advanced-group]]
