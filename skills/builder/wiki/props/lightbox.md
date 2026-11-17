---
title: lightbox props
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, lightbox, gallery, media]
updated: 2026-07-29
---

# The `lightbox_*` family

Present on three elements and two item types: [[elements/grid]] and `gallery` carry the full set of
eleven, `image` carries a reduced four, and `grid_item` / `gallery_item` add three per-item
overrides. Definitions from `elements/grid/element.php:510-617`, rendering from
`elements/gallery/templates/template.php:62-70`.

## The full set

| Prop | Values | Default |
|---|---|---|
| `lightbox` | bool — enable the gallery | — |
| `lightbox_controls` | bool — "Show controls always" | — |
| `lightbox_counter` | bool | — |
| `lightbox_bg_close` | bool — close on background click | **`true`** |
| `lightbox_animation` | `''` (Slide) `'fade'` `'scale'` | `''` |
| `lightbox_nav` | `''` (Slidenav) `'dotnav'` `'thumbnav'` | `''` |
| `lightbox_image_width` / `_height` | number, placeholder `auto` | — |
| `lightbox_image_orientation` | bool — allow mixed orientations | — |
| `lightbox_video_autoplay` | `''` (None) `'true'` (Autoplay) `'inline'` (Animated Image) | — |
| `lightbox_text_color` | `''` `'light'` `'dark'` | — |

Every one except `lightbox` itself is gated `'enable' => 'lightbox'`.

`image` has a different, smaller set: `lightbox`, `lightbox_width`, `lightbox_height`,
`lightbox_image_focal_point` — note **`lightbox_width`, not `lightbox_image_width`**. The prefixes
diverge between elements; check the element's own `fields` rather than assuming.

## What gets emitted

```php
'uk-lightbox' => $props['lightbox'] ? [
    'toggle: a[data-type];',
    'animation: {lightbox_animation};',
    'nav: {lightbox_nav}; slidenav: false;',
    'delay-controls: 0;'  => $props['lightbox_controls'],
    'counter: true;'      => $props['lightbox_counter'],
    'bg-close: false;'    => !$props['lightbox_bg_close'],
    'video-autoplay: {lightbox_video_autoplay};',
] : false,
```

Three things worth reading off that:

- **`slidenav: false` is hard-coded.** `lightbox_nav` therefore selects between dotnav and thumbnav,
  and its `''` value — labelled *Slidenav* — means the UIkit default rather than an explicit setting
- **`lightbox_controls` is inverted.** The label is "Show controls always"; the emitted option is
  `delay-controls: 0`, i.e. disable the auto-hide delay
- **`lightbox_bg_close` is emitted only when false**, as `bg-close: false`. Its `true` default
  produces no option at all

`lightbox_video_autoplay: 'inline'` is labelled *Animated Image*: autoplay, loop, muted, no
controls — see [[props/media]] for the same idea applied to card videos.

## `title_display` and `content_display`

Two props that exist only because of the lightbox, and that gate large parts of two other families:

| Value | Meaning |
|---|---|
| `''` | Show in the panel **and** as the lightbox caption |
| `'item'` | Panel only |
| `'lightbox'` | Lightbox caption only |

Gated on `show_title && lightbox` / `show_content && lightbox`. There is no `meta_display`: meta is
never a caption.

**These are the gate behind most of [[props/title-family]] and [[props/content-family]].** Nearly
every prop in those families carries the condition:

```
(title_display != 'lightbox' && lightbox || !lightbox)
```

Read it as: *the field is styleable unless it has been moved into the lightbox only.* Choosing
*Lightbox only* removes the field from the panel, so the entire panel-side styling group for it goes
inert. If a title's style props suddenly stop appearing in the builder, check `title_display` before
anything else.

Note the condition is also satisfied when `lightbox` is off entirely — the props stay available on
elements with no lightbox enabled.

## Item-level overrides

`grid_item` and `gallery_item` add `lightbox_image_focal_point` and `lightbox_text_color`, so one
image can be cropped or inverted differently in the lightbox than in the panel. Their panel-side
counterparts `image_focal_point` and `image_text_color` are separate props — see
[[props/image-family]].

## Sizing

`lightbox_image_width` / `_height` size the **lightbox** image, independently of the thumbnail
dimensions in [[props/image-family]]. Setting one preserves proportions; high-resolution variants
are generated where possible.

`lightbox_image_orientation` — *"allow mixed image orientations"* — flips width and height per image
according to whether it is portrait or landscape. Without it a fixed size crops portraits badly in a
mixed gallery.

## Related

[[props/image-family]] · [[props/title-family]] · [[props/content-family]] ·
[[props/show-switches]] · [[props/media]] · [[elements/grid]] · [[elements/grid_item]]
