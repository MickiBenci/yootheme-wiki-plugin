---
title: slider navigation props
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, slider, navigation, slidenav, dotnav, thumbnav]
updated: 2026-07-29
---

# The `nav_*`, `slidenav_*` and `thumbnav_*` families

Navigation controls shared by the four sliding elements: `slideshow`, `overlay-slider`,
`panel-slider` and `switcher`. Roughly 30 props, defined per element but with identical values —
read here from `elements/slideshow/element.php`, the most complete of the four.

Two independent control sets that are easy to confuse:

- **`nav`** — the dot or thumbnail strip that shows *which* slide you are on
- **`slidenav`** — the previous/next arrows

They are separate props with separate positioning, and an element can have either, both or neither.

## `nav` — the indicator strip

| Prop | Values | Present on |
|---|---|---|
| `nav` | `''` (None) `'dotnav'` `'thumbnav'` | all four |
| `nav_position` | `top-left` `top-right` `center-left` `center-right` `bottom-left` `bottom-center` `bottom-right` | slideshow, overlay-slider, switcher |
| `nav_below` | bool — place it under the slider instead of over it | slideshow, overlay-slider |
| `nav_align` | `left` `center` `right` — `'show' => 'nav && nav_below'` | all four |
| `nav_breakpoint` | `''` `s` `m` `l` `xl` — show from this width up | slideshow, overlay-slider, panel-slider |
| `nav_hover` | bool — reveal on hover only | slideshow, overlay-slider |
| `nav_margin`, `nav_position_margin` | spacing | varies |
| `nav_vertical` | bool — stack the items | slideshow, overlay-slider |

`nav_position` and `nav_align` are both labelled **"Position"** in the builder but are mutually
exclusive by gate: `nav_align` only appears once `nav_below` is on, at which point the navigation is
in the flow and `nav_position` no longer applies. Reading the JSON, only one of them is ever
meaningful.

### `switcher` has its own nav sub-grid

`switcher` replaces the positional props with `nav_grid_width`, `nav_grid_column_gap`,
`nav_grid_row_gap`, `nav_grid_breakpoint`, plus `nav_wrap`, `nav_vertical_align` and
`nav_style_primary` — the same sub-grid pattern as `title_grid_*` in [[props/title-family]]. A
switcher's navigation is a real tab list beside the content, not an overlay. See [[uikit/uk-grid]].

## `slidenav` — the arrows

| Prop | Values |
|---|---|
| `slidenav` | `''` (None) `'default'` `'outside'` `top-left` `top-right` `center-left` `center-right` `bottom-left` `bottom-center` `bottom-right` |
| `slidenav_large` | bool — larger style |
| `slidenav_hover` | bool — show on hover only |
| `slidenav_breakpoint` | `''` `s` `m` `l` `xl` |
| `slidenav_outside_breakpoint` | `s` `m` `l` `xl` — gated on `slidenav == 'outside'` |
| `slidenav_margin` | spacing |

Present on `slideshow`, `overlay-slider` and `panel-slider`; **not on `switcher`**, which navigates
by tab rather than by arrow.

`slidenav_outside_breakpoint` has no "Always" value: outside arrows need horizontal room, so below
the breakpoint they fall back inside. The description says so explicitly — *"Otherwise, display it
inside."*

## `thumbnav_*`

| Prop | Gate |
|---|---|
| `thumbnav_width`, `thumbnav_height` | `nav == 'thumbnav' && show_thumbnail` |
| `thumbnav_shrink` | idem |
| `thumbnav_svg_inline`, `thumbnav_svg_color` | idem |

On `slideshow` and `switcher` only. The double gate matters: thumbnails need both the navigation
type **and** the `show_thumbnail` switch from [[props/show-switches]]. Turning off `show_thumbnail`
while `nav: 'thumbnav'` leaves a navigation with nothing to show.

Each item then supplies the image through its own `thumbnail` prop — see the item types page.

## `slider_*` — the carousel-only family

`overlay-slider` and `panel-slider` are sliders rather than slideshows: several items visible at
once, scrolling horizontally. They carry a family the other two do not:

| Group | Props |
|---|---|
| Sizing | `slider_width` plus `slider_width_default/small/medium/large/xlarge` — a per-breakpoint set, unlike the grid's column counts |
| Motion | `slider_velocity`, `slider_finite`, `slider_center`, `slider_sets` |
| Autoplay | `slider_autoplay`, `slider_autoplay_interval`, `slider_autoplay_pause` |
| Layout | `slider_gap`, `slider_divider`, `slider_row_align`, `slider_min_height` (overlay-slider only) |
| Parallax | `slider_parallax`, `_start`, `_end`, `_easing`, `_target` |

`slider_parallax_*` mirrors the element parallax panel documented in the canonical
`animations` skill — see [[props/animation]] for how parallax props reach the markup.

## Reading order for a slider element page

These families account for most of a slider's prop count — `slideshow` has 60 nav-related lines,
`overlay-slider` 43, `switcher` 42, `panel-slider` 28. An element page should link here and document
only its own delta: which of the four sets it has, and what its content model is.

## Related

[[props/show-switches]] · [[props/title-family]] · [[props/image-family]] · [[props/animation]] ·
[[uikit/uk-grid]] · [[elements/grid]]
