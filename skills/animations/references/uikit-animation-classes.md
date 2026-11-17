# UIkit Animation Classes Reference

Verified source: `vendor/assets/uikit/src/less/components/animation.less` (UIkit 3.25.x, bundled
with YOOtheme Pro 5.0.x).

---

## UIkit CSS classes

These classes are applied through custom CSS or markup (e.g. inside an `html` element or a custom
template). Builder elements do not expose them as props — use the `animation` props instead.

| Class | Effect | Default duration |
|---|---|---|
| `.uk-animation-fade` | Fade in | 0.8s |
| `.uk-animation-scale-up` | Fade + scale from 0.9 to 1 | 0.5s |
| `.uk-animation-scale-down` | Fade + scale from 1.1 to 1 | 0.5s |
| `.uk-animation-slide-top` | Slide from above 100% | 0.5s |
| `.uk-animation-slide-bottom` | Slide from below 100% | 0.5s |
| `.uk-animation-slide-left` | Slide from the left 100% | 0.5s |
| `.uk-animation-slide-right` | Slide from the right 100% | 0.5s |
| `.uk-animation-slide-top-small` | Slide from above 10px | 0.5s |
| `.uk-animation-slide-bottom-small` | Slide from below 10px | 0.5s |
| `.uk-animation-slide-left-small` | Slide from the left 10px | 0.5s |
| `.uk-animation-slide-right-small` | Slide from the right 10px | 0.5s |
| `.uk-animation-slide-top-medium` | Slide from above 50px | 0.5s |
| `.uk-animation-slide-bottom-medium` | Slide from below 50px | 0.5s |
| `.uk-animation-slide-left-medium` | Slide from the left 50px | 0.5s |
| `.uk-animation-slide-right-medium` | Slide from the right 50px | 0.5s |
| `.uk-animation-kenburns` | Slow Ken Burns zoom | 15s (infinite loop) |
| `.uk-animation-shake` | Horizontal shake | 0.5s |
| `.uk-animation-stroke` | SVG stroke draw | 2s |

### Modifiers

| Class | Behaviour |
|---|---|
| `.uk-animation-reverse` | Reverses the direction (e.g. fade-out instead of fade-in) |
| `.uk-animation-fast` | 0.1s duration instead of the default |

---

## Customisable LESS variables

In the child theme's `theme.{name}.less` (or a Customizer style's `less` map), these variables
change the global timings:

```less
@animation-duration:               0.5s;  // default duration for scale and slide
@animation-fade-duration:          0.8s;  // fade duration
@animation-stroke-duration:        2s;    // SVG stroke draw duration
@animation-kenburns-duration:      15s;   // Ken Burns loop duration
@animation-fast-duration:          0.1s;  // duration with .uk-animation-fast
@animation-slide-small-translate:  10px;  // slide-*-small offset
@animation-slide-medium-translate: 50px;  // slide-*-medium offset
```

**Example**: speed up every slide animation:

```less
@animation-duration: 0.3s;
@animation-slide-small-translate: 8px;
```

---

## How `uk-scrollspy` is used

YOOtheme uses `uk-scrollspy` to trigger animations on viewport entry. The builder emits:

```html
<div uk-scrollspy="target: [uk-scrollspy-class]; cls: uk-animation-fade; delay: 150">
  <div uk-scrollspy-class>...</div>
</div>
```

For custom CSS + JS implementations (outside the builder):

```html
<div uk-scrollspy="cls: uk-animation-slide-bottom-small; delay: 200; repeat: false">
  Element that appears from below
</div>
```

---

## CSS vs builder props

| Situation | Approach |
|---|---|
| Animation on a builder section/element | `animation` + `animation_delay` props in the JSON |
| Continuous scroll parallax | `parallax_*` props in the JSON |
| Customising global timings | LESS variables in the theme / Customizer style |
| Ken Burns on a section background | Custom CSS with `uk-animation-kenburns` |
| SVG stroke draw on an image element | `image_svg_inline: true` + `image_svg_animate: true` in the JSON |
| Animation on custom HTML | UIkit class + `uk-scrollspy` in the markup |
