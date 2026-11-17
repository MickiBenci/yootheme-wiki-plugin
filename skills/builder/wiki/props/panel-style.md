---
title: panel style props
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/yootheme-pro-5.0.53-source]]"]
tags: [props, cross-cutting, panel, card, tile, padding]
updated: 2026-10-30
---

# The `panel_*` family

Six props that turn a bare content block into a card or a tile. Present on the largest elements —
[[elements/panel]], [[elements/grid]], `gallery`, `panel-slider`, `overlay-slider` — and on
`grid_item` and `panel-slider_item` as a per-item override.

Definitions from `elements/grid/element.php:618-697`, rendering from
`elements/panel/templates/template.php:73-100`. What the emitted classes then do is
[[uikit/uk-card]].

| Prop | Values |
|---|---|
| `panel_style` | `''` · `card-default` `card-primary` `card-secondary` `card-hover` `card-overlay` · `tile-default` `tile-muted` `tile-primary` `tile-secondary` · **`tile-checked`** (grid only) |
| `panel_link` | bool — whole panel clickable |
| `panel_link_hover` | bool — add a hover style (see note below the table) |
| `panel_padding` | `''` `small` `default` `large` |
| `panel_image_no_padding` | bool — attach the image to the panel edge |
| `panel_content_width` | `''` `xsmall` `small` — 1-column content width |

`panel_link_hover` is a real boolean: write `true`, not `"true"`. Up to 5.0.43 the legacy
`4.5.0-beta.0.3` migration in `panel`, `grid` and `panel-slider` `updates.php` set it to the
**string** `'true'`; by 5.0.53 it writes the boolean `true` (the changelog does not name the release).
Both render the same, since the template only checks truthiness — but exports from old upgraded
layouts may carry the string form. See [[sources/yootheme-pro-5.0.53-source]].

## Card, tile and blank are three different boxes

| `panel_style` | Classes emitted |
|---|---|
| `''` | `uk-panel` |
| `card-*` | `uk-card uk-card-<variant>` |
| `tile-*` | `uk-panel uk-tile-<variant>` |

A tile is a `uk-panel` that carries a tile background; a card is not a panel at all. The difference
propagates into padding, into which props survive, and into whether the title gets restyled — see
[[uikit/uk-card]].

### `tile-checked` is grid-only

The eleventh value exists on `grid` and nowhere else. It alternates `uk-tile-default` and
`uk-tile-muted` across items via a `uk-grid-checked` attribute, and it is **the one panel style that
loads JavaScript**: `elements/grid/element.php:118-123` registers `assets/site/js/grid.js`. Absent
from `panel` and from `grid_item`, since alternation is a property of the collection.

[[sources/skill-yootheme-json-schema]] omits it — filed as A3 in
[[issues/element-types-skill-vs-source]].

## `panel_padding` behaves differently on cards

`template.php:97-100`:

```php
'uk-padding[-{!panel_padding: default}] {@panel_style: |tile-.*} {@panel_padding}',
'uk-card-body {@panel_style: card-.*} {@panel_padding}',
```

| Style | `panel_padding` | Class |
|---|---|---|
| blank / tile | `default` | `uk-padding` |
| blank / tile | `small` / `large` | `uk-padding-small` / `uk-padding-large` |
| card | any non-empty | `uk-card-body` — **the size is discarded** |

On a card `panel_padding` is effectively a boolean. To vary card padding, override
`@card-body-padding-*` in the child theme's LESS or scope CSS to `.el-element` via
[[props/advanced-group]].

`panel_padding` is also blanked entirely when there is neither a panel style nor a non-`between`
image (`template.php:16-18`) — there is nothing to pad.

## `panel_link` and its side effects

Documented in full in [[props/link]], because its consequences are about links. In summary: the
whole panel becomes the anchor, the link region degrades to a `<div>`, `title_link` and `image_link`
are reset, and title/meta/content are passed through `striptags()`.

`panel_link_hover` is gated on
`$match(panel_style, 'card-(default|primary|secondary|overlay)|tile-')`. It does nothing on
`card-hover` — already hovering — and nothing on a blank panel, which has no background to shift.

## `panel_image_no_padding`

`'show' => 'panel_style'`: the field only appears once a style is chosen. With a `card-*` style and
an alignment other than `between`, the image is wrapped in `uk-card-media-{image_align}`
(`template.php:167-181`) so it bleeds to the card edge, plus a `uk-toggle` that flips it to
`uk-card-media-top` when the card stacks below the image breakpoint.

It also suppresses `image_border` unless the alignment is `between` — see [[props/image-family]].
And with an `icon` and no image or video it is blanked outright (`template.php:4`).

## `panel_content_width`

`'show' => '!panel_style'` plus a long gate requiring top-aligned media, no padding, no
`item_maxwidth`, and **every** `grid_*` column count either unset or `'1'`. It exists for exactly one
layout: a single-column blank panel where the text should be narrower than the image. Outside that
configuration the field is not even shown.

## Related

[[uikit/uk-card]] · [[props/link]] · [[props/image-family]] · [[props/title-family]] ·
[[props/show-switches]] · [[elements/panel]] · [[elements/grid]] · [[elements/grid_item]] ·
[[recipes/service-card-grid]]
