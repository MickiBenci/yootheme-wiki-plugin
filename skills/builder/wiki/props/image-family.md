---
title: image prop family
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, image, media, svg, hover]
updated: 2026-07-29
---

# The `image_*` family

Twenty-eight props on **33 elements** — the largest and most widely shared family after
[[props/position]]. Definitions from `elements/grid/element.php:1105-1355`, rendering from
`elements/panel/templates/template-media.php` and `template-image.php`.

The `image` prop itself is a plain string path; see [[sources/skill-yootheme-json-schema]] for the
invariant. Everything below configures how it renders.

## Sizing and cropping

| Prop | Type | Notes |
|---|---|---|
| `image_width` / `image_height` | number, placeholder `auto` | Setting one preserves proportions. The image is resized and cropped automatically, and high-resolution variants are generated where possible |
| `image_focal_point` | select, 9 positions, `''` = centre | Controls which part survives the crop |
| `image_loading` | checkbox — **"Load image eagerly"** | See the polarity warning below |

### `image_loading` is inverted from what it sounds like

Images are lazy by default. The checkbox **enables eager loading** for images in the initial
viewport. `template-image.php:7` makes it explicit:

```php
'loading' => $props['image_loading'] ? false : null,
```

`true` removes the `loading` attribute (browser default = eager); the unset value leaves lazy
loading in place. [[sources/skill-yootheme-json-schema]] describes it with the opposite polarity —
filed as A4 in [[issues/element-types-skill-vs-source]].

## Frame and decoration

| Prop | Values | Gate |
|---|---|---|
| `image_border` | `''` `rounded` `circle` `pill` | Not when a card style hides the image behind `panel_image_no_padding` |
| `image_box_shadow` | `''` `small` `medium` `large` `xlarge` | `!panel_style` |
| `image_hover_box_shadow` | idem | `!panel_style` and the image or panel is linked |
| `image_box_decoration` | `''` `default` `primary` `secondary` `shadow` `mask` | `!panel_style` |
| `image_box_decoration_inverse` | bool | plus decoration in `default\|primary\|secondary` |

**Three of these are silently disabled by any `panel_style`.** `elements/panel/templates/template.php:5-8`
blanks `image_box_decoration` and `image_transition_border` outright when a card or tile style is
set. Box decorations are for blank panels only — see [[props/panel-style]].

`image_box_decoration` emits `tm-` classes, not UIkit ones: `tm-box-decoration-*`,
`tm-mask-default`, `tm-transition-border`. These are YOOtheme extensions and live in
`less/theme.less`, so they are overridden in `custom-child-style.css`, not via UIkit variables.
Only `shadow` maps to a real UIkit class, `uk-box-shadow-bottom`.

## Hover behaviour

| Prop | Values | Gate |
|---|---|---|
| `image_link` | bool | media present and `show_link` |
| `image_transition` | `''` `scale-up` `scale-down` | plus `image_link \|\| panel_link` |
| `image_transition_border` | bool | idem |
| `hover_image` / `hover_video` | media | `'enable' => 'image \|\| video'` — needs a base image |
| `hover_image_focal_point` | 9 positions | — |

A transition or a hover image inserts an extra `<div class="uk-inline-clip">` wrapper
(`template-media.php:57-66`), and `uk-transition-toggle` lands on the outermost of
decoration → transition → media. So the DOM depth under `.el-image` varies with the props — worth
knowing before writing CSS against it.

The hover media gets its own resets (`:109-133`): a hover **video** is forced to `preload="none"`
and swaps `uk-video` for `uk-cover`; a hover **image** is forced to `loading="lazy"`, its `alt` is
cleared, `uk-svg` is disabled and `uk-cover` applied. You cannot make a hover image eager or inline
an SVG into it.

## Alignment and the image sub-grid

| Prop | Values |
|---|---|
| `image_align` | `top` `bottom` `left` `right` `between` |
| `image_grid_width` | `auto` `4-5` `3-4` `2-3` `3-5` `1-2` `2-5` `1-3` `1-4` `1-5` `small` `medium` `large` `xlarge` `2xlarge` |
| `image_grid_column_gap` / `image_grid_row_gap` | `small` `medium` `''` `large` `collapse` |
| `image_grid_breakpoint` | `''` `s` `m` `l` `xl` |
| `image_vertical_align` | bool — centre the cells |

The four `image_grid_*` props apply **only** when `image_align` is `left` or `right`, where the
element builds a two-cell `uk-grid`. This is the same sub-grid pattern as `title_grid_*` in
[[props/title-family]] and `filter_grid_*` in [[elements/grid]] — identical four props, identical
equal-gap/split-gap branch. See [[uikit/uk-grid]].

`'between'` places the image between title and content, and disables `panel_padding` handling and
`image_margin`'s usual gate.

`image_margin` applies only when the alignment is `between`, or `bottom` without a padding-less card
(`template-media.php:98`).

## SVG

| Prop | Effect |
|---|---|
| `image_svg_inline` | Injects the SVG into the markup so CSS can style it — emits `uk-svg` |
| `image_svg_animate` | Animates strokes. Requires `image_svg_inline` |
| `image_svg_color` | `''` `muted` `emphasis` `primary` `secondary` `success` `warning` `danger`. Default `'emphasis'` |

`template-image.php:15` gates the colour class on the source actually being an SVG
(`$this->isImage($src) == 'svg'`), so `image_svg_color` on a JPEG is inert.

`image_svg_animate` rewrites `image_svg_inline` from a boolean into a configuration string at
transform time — see [[props/animation]].

## `image_text_color` and `image_expand`

`image_text_color` (`''` `light` `dark`) emits `uk-inverse-*` and exists for one situation: a sticky
transparent navbar sitting over the image. It sets the colour mode for controls above it, not for the
image.

`image_expand` makes the media fill the available height (`uk-flex-1`), and is one of the two inputs
to the panel expand mechanism in [[elements/panel]]. It is reset unless `height_expand` is set or the
image is aligned left/right, and masonry blanks it too.

When expanding — or on a video with both dimensions set — the media also gets `uk-object-{focal}` and,
for video only, an inline `aspect-ratio` (`:39-54`), because a video is not cropped the way an image
is.

## Icon as fallback

`icon` is gated `'enable' => '!image && !video'`: it is the media slot's fallback, and
`template-media.php:3-14` dispatches video → image → icon → nothing. This is why
`show_image: false` also blanks `icon` — see [[props/show-switches]].

## Related

[[props/media]] · [[props/title-family]] · [[props/content-family]] · [[props/panel-style]] ·
[[props/show-switches]] · [[props/animation]] · [[props/link]] · [[uikit/uk-grid]] ·
[[uikit/uk-card]] · [[elements/panel]] · [[elements/grid]]
