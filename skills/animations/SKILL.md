---
name: animations
description: Use when adding or configuring animations and scroll effects on YOOtheme Pro builder sections or elements - scrollspy fade/slide/scale entrances, staggered grid or gallery item animation, element parallax, background-image or background-colour parallax, overlay opacity parallax, SVG stroke drawing, Ken Burns - or when explaining how YOOtheme Pro animations work.
argument-hint: <section JSON, file path, or description — e.g. "fade in the hero" or "vertical parallax on the background image">
version: 2.0.0
---

# YOOtheme Pro Animations

Add or configure animations on the sections and/or elements of a YOOtheme Pro builder JSON, or
explain how the animation system works, based on the user's description.

Paths are relative to this skill's base directory. The mechanism by which the builder turns these
props into HTML attributes is documented in `../builder/wiki/props/animation.md` — read it when the
behaviour matters (e.g. why an element animation "does nothing").

## Input handling

1. **Pasted JSON or a file path** → read/parse the JSON and add the animation props to the right nodes.
2. **Text description** → produce a JSON snippet with the props to add, plus an explanation.
3. **No specific input** → ask: "Which effect do you want? (e.g. fade-in on entry, background
   parallax, staggered slide-in of the items)".

---

## The YOOtheme animation system — overview

YOOtheme Pro has **two separate systems**, triggered differently:

| System | Trigger | Props involved | UIkit mechanism |
|---|---|---|---|
| **Scrollspy** | Entering the viewport | `animation` + `animation_delay` | `uk-scrollspy` |
| **Parallax** | Continuous scroll | `parallax_*`, `image_parallax_*` | `uk-parallax` |

The two are configured independently and can coexist in the same section.

**Hard rule:** scrollspy animations are opt-in **per section**. If no ancestor `section` sets
`animation`, an element's own `animation` value is overwritten with `'none'` at render time.
`'parallax'` is the exception — it works without any section animation.

---

## Step 1: scrollspy animation (fade-in on viewport entry)

### On the section

```json
{
  "type": "section",
  "props": {
    "animation": "fade",
    "animation_delay": "150"
  },
  "children": []
}
```

- `animation` on the section → every child element inherits the animation.
- `animation_delay` → delay in ms between one element and the next (automatic staggering).
- Valid `animation` values → `references/animation-props.md`.

### Per-element override

An element can override the section animation through its own `animation` prop:

```json
{
  "type": "headline",
  "props": {
    "content": "Headline",
    "animation": "slide-top-small"
  }
}
```

- `""` (empty string) → inherits from the section
- `"none"` → disables the animation on this element
- any other value → overrides

### Item animation (grid and gallery)

For grids and galleries, enable `item_animation: true` to animate each card separately:

```json
{
  "type": "grid",
  "props": {
    "animation": "slide-bottom-small",
    "item_animation": true
  },
  "children": []
}
```

**Note**: `item_animation` has no effect when `animation` is `"none"` or `"parallax"`.

---

## Step 2: parallax (continuous scroll)

### Element parallax

Set `animation: "parallax"` on the element and configure the `parallax_*` props:

```json
{
  "type": "image",
  "props": {
    "image": "wp-content/uploads/deco.png",
    "animation": "parallax",
    "parallax_y": "-100,0",
    "parallax_opacity": "0,1",
    "parallax_easing": "0.5",
    "parallax_breakpoint": "m"
  }
}
```

**Stop format** for `parallax_*` props: a string of comma-separated values.
- `"0,100"` → from 0 to 100 while scrolling
- `"-50,0,50"` → three stops (start, middle, end)
- `"0%,50,100%"` → with positioning percentages

All props → `references/parallax-props.md`

### Section background-image parallax

Add these props on the `section` for a background-image parallax:

```json
{
  "type": "section",
  "props": {
    "image": "wp-content/uploads/bg.jpg",
    "image_effect": "parallax",
    "image_parallax_bgy": "-200,200",
    "image_parallax_easing": "0",
    "image_parallax_breakpoint": "m"
  },
  "children": []
}
```

- `image_effect: "parallax"` enables parallax on the background image
- `image_parallax_bgx` → horizontal translation
- `image_parallax_bgy` → vertical translation (the most common; typical value `"-200,200"`)

### Background-colour parallax

To animate the background colour on scroll (requires a section with no `style`):

```json
{
  "type": "section",
  "props": {
    "style": "",
    "background_color": "#ffffff",
    "background_parallax_background": "#ffffff,#1a1a2e",
    "background_parallax_easing": "0"
  },
  "children": []
}
```

### Overlay opacity parallax

To animate the opacity of the image overlay on scroll:

```json
{
  "type": "section",
  "props": {
    "image": "wp-content/uploads/bg.jpg",
    "media_overlay": "rgba(0,0,0,1)",
    "media_overlay_parallax_opacity": "0,0.6",
    "media_overlay_parallax_easing": "0"
  },
  "children": []
}
```

---

## Step 3: special effects

### SVG stroke animation

Animate the strokes of an SVG (the path "draws" itself progressively):

```json
{
  "type": "image",
  "props": {
    "image": "wp-content/uploads/icon.svg",
    "image_svg_inline": true,
    "image_svg_animate": true
  }
}
```

**Requirement**: the image must be an SVG file with defined strokes. The duration is `2s` (LESS
variable `@animation-stroke-duration`).

### Ken Burns (background image)

Ken Burns applies a slow zoom to a section's background image. It is **not** a builder prop — it
is achieved with custom CSS, e.g. in the section's `css` prop or the theme LESS:

```css
.tm-section-kenburns > .uk-background-cover {
  animation: uk-animation-kenburns 15s ease-in-out infinite;
}
```

Treat the selector as a starting point and check it against the rendered markup.

### Column parallax (columns of different heights)

To make columns of different heights justify to the bottom while scrolling (staggered effect):

```json
{
  "type": "row",
  "props": {
    "parallax": true,
    "parallax_start": "100",
    "parallax_end": "0"
  },
  "children": []
}
```

---

## Output format

```markdown
### Animation applied: [effect type]

**Effect**: [short description of what is seen]
**Where**: Section / [type] element

(JSON snippet, or the full updated layout saved to a file)

**Notes**:
- [browser support, requirements, mobile behaviour, if relevant]
```

When editing a full layout, keep the root `{"type":"layout", …}` object and run the validator
from the builder skill: `bash ../builder/scripts/validate.sh <file>.json`.

---

## Validation checklist

- [ ] `animation_delay` on the section is a numeric string (`"150"`, not `150`)
- [ ] `parallax_*` props are stop strings (`"0,100"`, not arrays)
- [ ] `image_effect: "parallax"` is present when using `image_parallax_*`
- [ ] `item_animation` is not relied upon when `animation` is `"none"` or `"parallax"`
- [ ] `image_svg_animate` requires `image_svg_inline: true`
- [ ] Element-level scrollspy animations have a `section` ancestor with `animation` set
- [ ] No node-level `id` fields added; leaf nodes carry no `children` key

---

## Reference files

- `references/animation-props.md` — every `animation` value (section + element)
- `references/parallax-props.md` — every parallax prop with ranges and descriptions
- `references/uikit-animation-classes.md` — UIkit CSS classes and LESS variables
- `examples/hero-fade-in.json` — hero with staggered fade-in
- `examples/grid-slide-up.json` — 3-column grid with `slide-bottom-small` and `item_animation`
- `examples/parallax-section.json` — section with background parallax and a decorative element
