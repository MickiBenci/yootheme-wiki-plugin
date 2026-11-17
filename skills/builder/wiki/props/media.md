---
title: media background and video props
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, media, video, background, blend]
updated: 2026-07-29
---

# The `media_*` and `video_*` families

Two related families. `media_*` styles a background image or video on a **container** —
[[elements/section]], `column`, `row`, `overlay`. `video_*` controls playback wherever a video can
appear. Shared definitions at
`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:501-538`, with per-element additions.

Not to be confused with [[props/image-family]], which styles a *content* image inside a card. These
props are about the box behind the content.

## `media_*` — background layer

| Prop | Type | Notes |
|---|---|---|
| `media_background` | color | A colour behind the media. Fills the gap when the image does not cover the box, and is the second operand of the blend mode |
| `media_blend_mode` | select, 16 CSS blend modes | `'enable' => 'media_background'` — **inert without a background colour** |
| `media_overlay` | gradient | A transparent wash over the media to soften it |
| `media_overlay_gradient` | hidden | Written by the gradient widget alongside `media_overlay` |
| `media_focal_point` | 9 positions, `''` = centre | Controls cropping |
| `media_visibility` | `''` `s` `m` `l` `xl` | Show the media from this width up. The content stays either way |

The sixteen blend values are the full CSS set: `''` (Normal), `multiply`, `screen`, `overlay`,
`darken`, `lighten`, `color-dodge`, `color-burn`, `hard-light`, `soft-light`, `difference`,
`exclusion`, `hue`, `saturation`, `color`, `luminosity`.

### The gradient pair

`media_overlay` is declared `'internal' => 'media_overlay_gradient'`: a flat colour lands in
`media_overlay`, a gradient in `media_overlay_gradient`, and the template emits `background-color`
from the first and `background-image` from the second
(`elements/section/templates/template.php:144-152`). The same pattern applies to
`background_color` / `background_color_gradient` on [[elements/section]].

Both are reset to `false` when there is no image and no video (`template.php:9-12`) — an overlay
with nothing to overlay is discarded.

`media_visibility` is not [[props/visibility]]: it hides the **background media only**, not the
element.

## Where the settings actually live

On `section` and `column` these props sit in a **button-panel** (`builder-section-media`,
"Edit Settings"), which is a UI grouping only. **They are flat props on the same node:**

```json
{
  "type": "section",
  "props": {
    "image": "wp-content/uploads/hero.jpg",
    "image_size": "cover",
    "media_background": "#2F3334",
    "media_blend_mode": "multiply"
  },
  "children": []
}
```

No nesting, no `media` object. See [[elements/section]] for the rest of that panel — `image_size`,
`image_position`, `image_effect`, `image_width`/`image_height`, `image_loading`.

## `video_*` — playback

| Prop | Values | Notes |
|---|---|---|
| `video_autoplay` | `''` (On) `'inview'` `'hover'` | Gated on `show_video` where switches exist |
| `video_autoplay_restart` | bool | "Restart from beginning". Gated on `video_autoplay` |

The value mapping inverts the usual convention: **`''` means autoplay On**, not off. There is no
"never autoplay" value in this select — a video without `uk-video` options still gets `uk-video`
set to `true` (`elements/panel/templates/template-video.php:16-20`).

Every builder video is emitted with `playsinline`, `loop` and `muted` hard-coded, and
`preload="none"` unless `image_loading` is set. So a card video is always a silent looping clip —
these are decorative videos, not media players. The `video` element is the one with real controls.

`'hover'` adds `hover-target: !.tm-video-toggle`, which is why [[elements/panel]] emits
`tm-video-toggle` on its outer element when a video or hover video is present: the video looks
upward for that class to know what counts as "hovered".

`video_autoplay_restart` emits `restart: true` and only applies when autoplay is set.

## Videos are not cropped like images

`elements/panel/templates/template-media.php:39-54` — when a video has both `image_width` and
`image_height`, an inline `aspect-ratio: {w} / {h}` is emitted instead of a crop, with a comment
saying why: *"Keep video responsiveness but with new proportions (because video isn't cropped like an
image)"*.

So `image_width`/`image_height` mean **crop** for an image and **aspect ratio** for a video. A mixed
grid of images and videos with the same dimensions will not necessarily line up.

## Auto-correction between image and video

`panel`, `grid_item` and their siblings run a transform that swaps the two props when the file type
contradicts the field: a video path in `image` moves to `video`, and vice versa, for both the base
and `hover_` prefixes. It exists for dynamic content, where the bound field's type is unknown until
render. See [[elements/panel]].

## Related

[[props/image-family]] · [[props/visibility]] · [[elements/section]] · [[elements/panel]] ·
[[elements/grid]] · [[props/animation]]
