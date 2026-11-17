# Parallax Props Reference

Verified source: `packages/builder/config/customizer.php` (YOOtheme Pro 5.0.x).

---

## Stop format

`parallax_*` props accept **strings of comma-separated values** (stops):

```
"0,100"          → from 0 to 100 while scrolling
"-50,0,50"       → three stops: start, middle, end
"0%,50,100%"     → with positioning percentages
"-200px,0"       → with px units
"0,50vh"         → with viewport units
```

---

## `builder-parallax` panel — element parallax

Enabled on an element with `animation: "parallax"`.

| Prop | Type | Range | Units | Description |
|---|---|---|---|---|
| `parallax_x` | stops | -600..600 | px, %, vw | Horizontal translation |
| `parallax_y` | stops | -600..600 | px, %, vh | Vertical translation (most used) |
| `parallax_scale` | stops | 0.5..2 | — | Scale (1 = normal size) |
| `parallax_rotate` | stops | 0..360 | deg | Rotation in degrees |
| `parallax_opacity` | stops | 0..1 | — | Opacity (0 = transparent, 1 = opaque) |
| `parallax_blur` | stops | 0..100 | px | Blur |
| `parallax_transform_origin` | select | — | — | Origin point for scale and rotate |
| `parallax_easing` | range | -2..2 | — | Speed curve: 0 = constant, <0 = starts fast, >0 = starts slow |
| `parallax_target` | select | — | — | Reference element for the position calculation |
| `parallax_start` | string | — | px, vh, % | Animation start offset |
| `parallax_end` | string | — | px, vh, % | Animation end offset |
| `parallax_zindex` | boolean | — | — | Raised z-index during the parallax |
| `parallax_breakpoint` | select | — | — | Minimum breakpoint at which the parallax is active |

### `parallax_transform_origin` values

| Value | Position |
|---|---|
| `"top-left"` | Top left |
| `"top-center"` | Top centre |
| `"top-right"` | Top right |
| `"center-left"` | Centre left |
| `""` | Centre (default) |
| `"center-right"` | Centre right |
| `"bottom-left"` | Bottom left |
| `"bottom-center"` | Bottom centre |
| `"bottom-right"` | Bottom right |

### `parallax_target` values

| Value | Reference |
|---|---|
| `""` | Element (the element itself) |
| `"!.tm-grid-expand>*"` | Column |
| `"!.tm-grid-expand"` | Row |
| `"!.uk-section"` | Section |
| `"![class*='uk-section-'] ~ [class*='uk-section-']"` | Next section |

### `parallax_breakpoint` values

| Value | Device |
|---|---|
| `""` | Always |
| `"s"` | Small — phone landscape and up |
| `"m"` | Medium — tablet landscape and up |
| `"l"` | Large — desktop and up |
| `"xl"` | X-Large — large screens and up |

---

## `image-parallax` panel — section background-image parallax

Requires `image_effect: "parallax"` on the section.

| Prop | Type | Range | Description |
|---|---|---|---|
| `image_parallax_bgx` | stops | -600..600 | Horizontal background-image translation |
| `image_parallax_bgy` | stops | -600..600 | Vertical background-image translation (typical: `"-200,200"`) |
| `image_parallax_easing` | range | -2..2 | Speed curve |
| `image_parallax_target` | select | — | Reference: `""` (section) or `"next-section"` |
| `image_parallax_start` | string | — | Start offset |
| `image_parallax_end` | string | — | End offset |
| `image_parallax_breakpoint` | select | — | Minimum breakpoint |

**Typical example** (classic depth effect), props fragment:

```text
"image": "wp-content/uploads/bg.jpg",
"image_effect": "parallax",
"image_parallax_bgy": "-200,200",
"image_parallax_easing": "0"
```

---

## `background-parallax` panel — section background-colour parallax

Requires `style: ""` (no preset style). Animates the background colour on scroll.

| Prop | Type | Description |
|---|---|---|
| `background_parallax_background` | stops (colour) | Colour stops, e.g. `"#ffffff,#1a1a2e"` |
| `background_parallax_easing` | range -2..2 | Speed curve |
| `background_parallax_start` | string | Start offset |
| `background_parallax_end` | string | End offset |

---

## `media-overlay-parallax` panel — section overlay opacity parallax

Animates the opacity of the overlay above the background image.

| Prop | Type | Range | Description |
|---|---|---|---|
| `media_overlay_parallax_opacity` | stops | 0..1 | Overlay opacity stops, e.g. `"0,0.6"` |
| `media_overlay_parallax_easing` | range | -2..2 | Speed curve |
| `media_overlay_parallax_target` | select | — | Position reference |
| `media_overlay_parallax_start` | string | — | Start offset |
| `media_overlay_parallax_end` | string | — | End offset |

---

## Common parallax recipes (props fragments)

### Floating decorative element (slow y)

```text
"animation": "parallax",
"parallax_y": "-80,80",
"parallax_easing": "0.5",
"parallax_breakpoint": "m"
```

### Text that rises as you scroll

```text
"animation": "parallax",
"parallax_y": "50,0",
"parallax_opacity": "0,1",
"parallax_easing": "0"
```

### Classic background-image depth

```text
"image_effect": "parallax",
"image_parallax_bgy": "-150,150",
"image_parallax_easing": "0"
```

### Overlay reveal on scroll

```text
"media_overlay_parallax_opacity": "0.8,0.2",
"media_overlay_parallax_easing": "0"
```
