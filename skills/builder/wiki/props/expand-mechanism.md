---
title: the expand mechanism
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/yootheme-pro-5.0.53-source]]"]
tags: [props, cross-cutting, expand, flex, height, alignment]
updated: 2026-10-30
---

# `height_expand`, `image_expand` and the `*_margin_auto` flags

How a card fills its available height and how its regions distribute the slack. Five props across
**11 elements**, feeding two internal flags that appear in no field definition and that 12 render
templates read.

The single most useful thing to understand about the card system: it is what makes a row of cards
with unequal text lengths keep their links on a shared baseline.

| Prop | Present on | Meaning |
|---|---|---|
| `height_expand` | `panel`, `overlay`, `overlay-slider`, `panel-slider`, `slideshow`, `popover`, `column`, `image`, `video` | Fill the containing column's height |
| `image_expand` | `panel`, `grid`, `gallery`, `panel-slider`, `overlay-slider` | Let the media absorb the extra height |
| `title_margin_auto` | the card elements | Push everything below the title down |
| `meta_margin_auto` | idem | Same, from the meta |
| `content_margin_auto` | idem | Same, from the content — **the usual choice** |

## The two derived flags

Every card template opens with the same two lines
(`elements/panel/templates/template.php:21-22`, and identically in `grid`, `gallery`,
`panel-slider`, `overlay-slider`, `slideshow` and their `_item` templates):

```php
$props['content_expand'] = $props['title_margin_auto'] ?: $props['meta_margin_auto'] ?: $props['content_margin_auto'];
$props['panel_expand']   = $props['image_expand'] || $props['content_expand'];
```

- `content_expand` — **any one** of the three `*_margin_auto` checkboxes. They are not additive: the
  `?:` chain takes the first truthy one, and the flag is a boolean either way
- `panel_expand` — either the media or the content is absorbing slack

`panel_expand` then switches the panel to `uk-flex uk-flex-column`, and the region that owns the
auto margin gets `uk-margin-auto-bottom` while the others get `uk-margin-remove-bottom`. See
[[props/margin]] for the `'auto'` value itself.

## The recipe

Equal-height cards with links on a common baseline:

```json
{ "height_expand": true, "content_margin_auto": true }
```

`height_expand` makes the card fill the column; `content_margin_auto` makes the description absorb
the difference so the link is pushed to the bottom. On a [[elements/grid]] the column heights are
already equalised by `uk-grid-match`, so `content_margin_auto` alone is usually enough — see
[[uikit/uk-grid]].

Without it, cards stretch but their contents stay top-aligned and the links land at different
heights.

## `text_align` is re-read on the vertical axis

`template.php:24-39` — when `panel_expand` is set, the element translates `text_align` from
horizontal words into vertical ones for the flex column axis:

```php
$props['flex_column_align'] = str_replace(['left','center','right'], ['top','middle','bottom'], $props['text_align'] ?? '');
```

So in expand mode **`text_align` drives two axes at once**: `uk-text-center` horizontally and
`uk-flex-middle` vertically. Setting it to centre a card's text also vertically centres the card's
content block. `text_align_fallback` is translated the same way. See [[props/alignment]].

For a **blank** panel the template additionally forces `uk-flex-top` when `text_align` is unset, with
the reason in the source comment: *"`uk-flex-top` prevents child inline elements from taking the
whole width, needed for floating shadow + hover image"*.

## `image_expand` is heavily gated

`image_expand` is reset to `''` unless `height_expand` is set **or** the image is aligned `left` or
`right` (`template.php:13-15`). On [[elements/grid]] it is also blanked by masonry unless the
alignment is left/right, since masonry exists precisely to allow unequal heights.

When it does apply, the media gets `uk-flex-1` plus `uk-object-{focal_point}`, and a video gets an
inline `aspect-ratio` instead of a crop — see [[props/image-family]] and [[props/media]].

## Structural consequences

`panel_expand` changes the DOM, not just classes. It adds `uk-flex uk-flex-column` to the panel
body, and where a padded content container exists it also gains `uk-flex-1 uk-flex uk-flex-column`
plus `uk-width-1-1`. With a left- or right-aligned image the two grid cells each acquire their own
expand classes, and the cell that expands differs depending on whether `image_expand` or
`content_expand` is the one set (`template.php:126-155`).

Since 5.0.44 those two cells no longer emit `uk-flex` twice (changelog: *"Fix duplicate flex utility
classes in Grid, Panel, and Slider items"*). The image cell now gets `uk-flex` only when
`image_expand` is set or `image_vertical_align` and `content_expand` are both set; the content cell
gets `uk-flex uk-flex-column` only when `content_expand` is set or `image_vertical_align` and
`image_expand` are both set. The same change is in `panel`, `grid_item` and `panel-slider_item` —
see [[sources/yootheme-pro-5.0.53-source]]. Rendered layout is the same; only the class list is
cleaner.

So CSS written against a card's internal structure can behave differently once an expand prop is
switched on. Scope to `.el-content` and `.el-image` rather than to positional selectors — see
[[props/advanced-group]].

## `height_expand` outside the card elements

`column`, `image`, `video` and `popover` carry `height_expand` without the `*_margin_auto` family.
There it simply means "fill the available height", with no slack distribution. On `image` and
`video` it also changes what `text_align` does — see the exception documented in
[[props/alignment]].

## Related

[[props/margin]] · [[props/alignment]] · [[props/image-family]] · [[props/content-family]] ·
[[props/panel-style]] · [[uikit/uk-grid]] · [[uikit/uk-card]] · [[elements/panel]] ·
[[elements/grid]]
