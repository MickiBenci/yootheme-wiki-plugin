---
title: panel element
type: element
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]", "[[sources/websites-demo]]"]
tags: [element, card, basic, panel]
updated: 2026-07-29
---

# `panel`

The single card: title, meta, content, one image or video or icon, and a link — inside an optional
card or tile box. `raw/yootheme-pro-5.0.33/packages/builder/elements/panel/element.php`, 1209 lines,
~90 props.

```php
'name' => 'panel',  'title' => 'Panel',  'group' => 'basic',  'element' => true,
```

Not a `container`: `panel` has no meaningful `children`, all its content lives in props.

Baseline prop table: [[sources/skill-yootheme-json-schema]] `references/element-types.md:513-571`.

## panel is grid's vocabulary for one item

The most useful structural fact about this element, and it appears in no skill. Diffing
`panel/element.php` against `grid/element.php`: **93% of panel's props are shared with 5+ other
elements**, and almost all of them with `grid` specifically — same names, same values, same defaults.

- `grid` adds the collection-level props: `grid_*`, `filter_*`, `lightbox_*`, `show_*`,
  `item_maxwidth`, `item_animation`, `container_padding_remove`
- `panel` adds only `height_expand` and `html_element`

So learning `panel` is most of learning [[elements/grid]], `gallery`, `panel-slider` and
`overlay-slider`. And the practical rule follows from it: **you do not put a `panel` inside a
`grid`** — a grid renders its own panels from [[elements/grid_item]] children.

## Defaults that are not empty

```php
'defaults' => [
    'link_text' => 'Read more',   'link_style' => 'default',
    'title_element' => 'h3',      'title_align' => 'top',    'title_hover_style' => 'reset',
    'title_grid_width' => '1-2',  'title_grid_breakpoint' => 'm',
    'meta_style' => 'text-meta',  'meta_align' => 'below-title',  'meta_element' => 'div',
    'content_column_breakpoint' => 'm',
    'image_align' => 'top',       'image_grid_width' => '1-2',
    'image_grid_breakpoint' => 'm',  'image_svg_color' => 'emphasis',
    'margin_top' => 'default',    'margin_bottom' => 'default',
],
```

`panel_style` is **absent** — an unstyled panel is a blank panel, not a card.

## Props unique to `panel`

| Prop | Type | Notes |
|---|---|---|
| `height_expand` | checkbox | Fill the containing column's height. Emits `uk-flex-1` plus `uk-flex uk-flex-column` |
| `html_element` | select | The wrapper tag — see [[props/visibility]] |

Everything else comes from a family.

## Families used

| Family | Notes for `panel` |
|---|---|
| [[props/panel-style]] | Ten values — **no `tile-checked`**, which is grid-only |
| [[props/title-family]] | Full set |
| [[props/meta-family]] | Full set |
| [[props/content-family]] | Full set, minus `content_display` — no lightbox on `panel` |
| [[props/image-family]] | Full set. `image_expand` is gated on `height_expand` here |
| [[props/expand-mechanism]] | `height_expand` + `image_expand` + the three `*_margin_auto` flags |
| [[props/link]] | Full set. `panel_link` has the widest consequences — see below |
| [[props/margin]] · [[props/position]] · [[props/alignment]] · [[props/visibility]] · [[props/animation]] · [[props/advanced-group]] | Standard |

No [[props/lightbox]], no [[props/show-switches]]: both are collection-level.

## Content model and the empty-render rule

`title` `meta` `content` are text/HTML; `image` and `video` are mutually exclusive
(`'show' => '!video'` / `'!image'`); `icon` is the fallback, gated `'enable' => '!image && !video'`;
`hover_image` / `hover_video` need a base media.

`element.php:75-82` — the element emits **nothing at all** unless one of `title`, `meta`, `content`,
`image`, `video`, `icon` is non-empty. A panel carrying only a link and a `panel_style` renders as an
empty string, not an empty card.

The same transform (`:59-73`) auto-corrects media type between `image` and `video` for dynamic
content — see [[props/media]].

## The resets at the top of the template

`templates/template.php:3-18` silently blanks props before rendering. These are the behaviours most
likely to look like bugs:

| Condition | Reset |
|---|---|
| `icon` set, no image or video | `panel_image_no_padding` → `''` |
| `panel_style` set, **or** no media | `image_box_decoration`, `image_transition_border` → `''` |
| `panel_link` on | `title_link`, `image_link` → `''` |
| no `height_expand` and image not left/right | `image_expand` → `''` |
| no `panel_style` and no non-`between` media | `panel_padding` → `''` |

The second is the common surprise: **box decorations and transition borders are discarded the moment
you pick a card or tile style.** They are for blank panels only.

## Expand and markup shape

`height_expand` plus one of the `*_margin_auto` checkboxes is what keeps a row of cards aligned on a
common baseline. The mechanism is shared with `grid`, `gallery` and the sliders — see
[[props/expand-mechanism]].

`image_align` produces three structurally different outputs: **top/bottom** puts the image as a
sibling of the content; **left/right** builds a two-cell `uk-grid` (`template.php:106-157`);
**between** places it inside the content flow and disables `panel_padding` handling. With a `card-*`
style plus `panel_image_no_padding` the image becomes `uk-card-media-*` instead. Values in
[[props/image-family]], classes in [[uikit/uk-card]].

## Real-world usage

From the 124 panels of [[sources/websites-demo]]:

- **A standalone `panel` is usually a bound one.** 59 of 124 carry a node-level `source`
  ([[concepts/dynamic-content]]) — the single-card element earns its place when the card is a
  dynamic teaser (fc-greenfield's match fixtures: 21 bound panels inside `fragment` wrappers).
  Hand-filled card collections use [[elements/grid]] instead, confirming the structural rule
- **`column.style` is the panel's rival.** Columns declare the same ten card/tile values
  (`column/element.php`), and the demos style columns directly nine times where a blank panel plus
  a wrapper would otherwise be needed — see the correction note in [[sources/websites-demo]]
- `panel_style` values cluster on `card-default` (38 of 51 in the corpus), `card-primary` for
  emphasis tiers ([[sources/demo-devstack]] pricing) — the exotic styles are demo-rare

## UIkit output

`uk-panel` for a blank panel, `uk-card uk-card-<variant>` for a card, `uk-panel uk-tile-<variant>`
for a tile. Padding is `uk-padding*` on the first two and `uk-card-body` on a card. Details in
[[uikit/uk-card]]; the two-cell image layout is [[uikit/uk-grid]].

## Templates

`template.php` plus six partials: `template-content.php` (title/meta/content/link assembly),
`template-media.php` (the image/video/icon dispatcher), `template-image.php`, `template-video.php`,
`template-icon.php`, `template-link.php`.

Scoped CSS selectors: `.el-element` `.el-title` `.el-meta` `.el-content` `.el-image` `.el-link`
`.el-hover-image` — see [[props/advanced-group]].

## Related

[[elements/grid]] · [[elements/grid_item]] · [[elements/section]] · [[uikit/uk-card]] ·
[[uikit/uk-grid]] · [[recipes/service-card-grid]]
