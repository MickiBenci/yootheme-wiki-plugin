---
title: section element
type: element
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]", "[[sources/websites-demo]]"]
tags: [element, structural, container, layout]
updated: 2026-07-29
---

# `section`

The top-level structural container. A layout is a sequence of sections; everything else nests inside
one. `raw/yootheme-pro-5.0.33/packages/builder/elements/section/element.php`.

```php
'name' => 'section',  'title' => 'Section',  'container' => true,
```

`'element' => true` is **absent** — a section cannot be inserted as an element, only as a layout
container. It has no `transform` prop for the same reason.

Baseline prop table: [[sources/skill-yootheme-json-schema]] `references/element-types.md:67-105`.

## `section` is the odd one out

Only **43% of its props are shared** with 5+ other elements — the lowest ratio of any large element.
It carries almost none of the card families and instead has its own vocabulary for backgrounds,
height and page rhythm. Most of this page is therefore element-specific rather than links.

## Defaults that are not empty

```php
'style' => 'default',  'width' => 'default',  'vertical_align' => 'middle',
'title_position' => 'top-left',  'title_rotation' => 'left',  'title_breakpoint' => 'xl',
'image_position' => 'center-center',
```

`style` defaults to `'default'`, not `''`. A section with no `style` prop still renders
`uk-section-default` with the theme's default background. **To get a genuinely transparent section
you must write `"style": ""` explicitly.**

## Padding: the two-branch rule

`padding_top` and `padding_bottom` share one option set — `'xsmall' 'small' '' 'large' 'xlarge'
'none'` — where `''` is labelled *Default* and `'none'` removes the padding. `''` is a real value,
not an unset.

`templates/template.php:96-121` branches on whether the two are equal:

- **equal** → one shared `uk-section-<value>`, plus `uk-padding-remove-vertical` for `none`
- **different** → separate `-top` / `-bottom` classes, and the empty value expands to
  `uk-section-medium-top` / `-bottom`

So "Default" padding is UIkit's **medium**, and asymmetric padding produces a visibly different class
set from symmetric padding at the same nominal size. The same equal/different branch appears in grid
gaps — see [[uikit/uk-grid]].

## Width and expansion

| Prop | Values | Notes |
|---|---|---|
| `width` | `'default'` `'xsmall'` `'small'` `'large'` `'xlarge'` `'expand'` `''` | `''` = **no container element at all** |
| `padding_remove_horizontal` | bool | Gated on `width && width != 'expand'` |
| `width_expand` | `''` `'left'` `'right'` | Expand one side, constrain the other |

With `width: ''` the container is not emitted unless a video or overlay forces one
(`template.php:158`), and content runs edge to edge. `width_expand` is one of the four conditions
`container_padding_remove` needs — see [[props/visibility]].

## Height

| Prop | Values |
|---|---|
| `height` | `''` `'pixels'` `'viewport'` `'section'` `'page'` |
| `height_viewport` | number — vh percentage, or px when `height: 'pixels'` |
| `height_viewport_offset` | bool — subtract the header height |
| `vertical_align` | `''` `'middle'` `'bottom'` — gated on `height` |

`'section'` means "viewport minus the next section"; `'page'` expands short pages to fill the
viewport. `template.php:16-18` resets `vertical_align` to false when `height` is empty, so alignment
without a height is a no-op.

## Background, colour, overlap, sticky

| Prop | Values | Notes |
|---|---|---|
| `style` | `''` `default` `muted` `primary` `secondary` | Emits `uk-section-{style}` |
| `background_color` + `background_color_gradient` | gradient pair | **`'enable' => '!style'`** |
| `preserve_color` | bool | `uk-preserve-color` |
| `text_color` | `''` `light` `dark` | Forces contrast over media |
| `overlap` | bool | `uk-section-overlap` — the next section overlaps this one |
| `sticky` | `''` `'cover'` `'reveal'` | `cover` pins the section while the next slides over it; `reveal` is the mirror. 12 `cover` uses in [[sources/websites-demo]], zero `reveal` — see [[recipes/sticky-cover-sections]] for the full pattern including the `parallax_target` trick a pinned section needs |

**A section with a `style` ignores its custom background colour entirely.** Set `"style": ""` first.
The gradient pair works like `media_overlay` — see [[props/media]].

## Transparent header

`header_transparent`, `header_transparent_noplaceholder`, `header_transparent_text_color`.

The render transform (`element.php:24-37`) writes `header.section.transparent` into **global
config** — the only element in the pilot that mutates state outside its own node. It checks
`is_null()` first, so only the first such section on a page wins — observed in the wild in
[[sources/demo-line-gallery]], which declares it on a second section to no effect.

## Decorative section title

A rotated label pinned to the section edge, unrelated to any heading element and to
[[props/title-family]].

| Prop | Values | Default |
|---|---|---|
| `title` | free string | — |
| `title_position` | `top-left` `center-left` `bottom-left` `top-right` `center-right` `bottom-right` | `'top-left'` |
| `title_rotation` | `'left'` `'right'` | `'left'` |
| `title_breakpoint` | `''` `s` `m` `l` `xl` | `'xl'` |

Renders as `tm-section-title uk-position-… uk-position-medium uk-visible@…`, with `tm-rotate-180`
when rotation is `left`. Both are `tm-` classes — YOOtheme extensions, not UIkit, so they are
overridden in `custom-child-style.css`. Setting `title` also restructures the content wrapper
(`template.php:195-200`), moving where the vertical alignment classes land.

## Background media

`image` / `video` are top-level and mutually exclusive — `template.php:20` drops the video if both
are set. Their settings live in the `builder-section-media` button-panel: `image_width`,
`image_height`, `media_focal_point`, `image_loading`, `image_size`, `image_position`, `image_effect`,
`media_visibility`, `media_background`, `media_blend_mode`, `media_overlay`.

**Panel fields are flat props on the section node** — the panel is a UI grouping only. Values and
behaviour in [[props/media]]; `image_size` (`''` `cover` `contain` `width-1-1` `height-1-1`),
`image_position` and `image_effect` (`''` `parallax` `fixed`) are section-specific.

## Families used

[[props/advanced-group]] (with `status` declared inline so it can read "Disable section"),
[[props/media]], [[props/visibility]] for `html_element`, and `animation` + `animation_delay` —
which on a section are the **switch that enables scrollspy for every descendant**, see
[[props/animation]].

No margin props: sections use padding. No [[props/position]], no [[props/alignment]] — a section is
not positioned within anything.

## Real-world usage

From the 338 sections of [[sources/websites-demo]]:

- **`style` stays `default`** (280 of 358 values) — colour comes from the LESS theme, not section
  styles; the dark quantum-flares demo uses `default` on a `#121212` global background rather than
  `secondary` sections
- **Exports always serialise `title_position` / `title_rotation` / `title_breakpoint`** even with
  no decorative `title` set — presence of the trio is serialisation noise, not intent
- Sections are a **dynamic-content binding point**: 46 demo sections carry a node-level `source`
  pulling background image or decorative title from content, and query-only `source` on a section
  sets the record context for every `#parent` binding below it — see [[concepts/dynamic-content]]
- The transparent-header hero contract (`padding: none` + media element with
  `height_viewport: "viewport"`) is worked through in [[recipes/fullscreen-hero-slideshow]]
- fc-greenfield stacks viewport units: section `height_viewport: "80"` over an inner row at
  `height_viewport: "100"` — an 80vh window onto a 100vh composition
  ([[sources/demo-fc-greenfield]])

## UIkit output

```html
<div class="uk-section-default">
  <div class="uk-section uk-section-large">
    <div class="uk-container">…children…</div>
  </div>
</div>
```

Outer element carries style and positioning, inner carries `uk-section` plus padding, the third
appears only if `width` is set. With a background image the inner element becomes the image wrapper.

Scoped CSS selector: `.el-section` — see [[props/advanced-group]].

## Related

[[elements/grid]] · [[elements/panel]] · [[props/media]] · [[props/animation]] ·
[[props/visibility]] · [[uikit/uk-grid]] · [[recipes/service-card-grid]]
