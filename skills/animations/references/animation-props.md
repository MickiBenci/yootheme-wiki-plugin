# Animation Props Reference

Verified source: `packages/builder/elements/section/element.php` and
`packages/builder/config/builder.php` (YOOtheme Pro 5.0.x).

---

## `animation` prop — section

Set on the **section**. Applies the animation to **every child element** when it enters the
viewport (`uk-scrollspy`).

| Value | UI label | Effect |
|---|---|---|
| `""` | None | No animation (default) |
| `"fade"` | Fade | Fade in — 0.8s |
| `"scale-up"` | Scale Up | Fade + zoom from small to large |
| `"scale-down"` | Scale Down | Fade + zoom from large to small |
| `"slide-top-small"` | Slide Top Small | Slide from above + fade, 10px offset |
| `"slide-bottom-small"` | Slide Bottom Small | Slide from below + fade, 10px offset |
| `"slide-left-small"` | Slide Left Small | Slide from the left + fade, 10px offset |
| `"slide-right-small"` | Slide Right Small | Slide from the right + fade, 10px offset |
| `"slide-top-medium"` | Slide Top Medium | Slide from above + fade, 50px offset |
| `"slide-bottom-medium"` | Slide Bottom Medium | Slide from below + fade, 50px offset |
| `"slide-left-medium"` | Slide Left Medium | Slide from the left + fade, 50px offset |
| `"slide-right-medium"` | Slide Right Medium | Slide from the right + fade, 50px offset |
| `"slide-top"` | Slide Top 100% | Slide from above, offset = 100% of the element height |
| `"slide-bottom"` | Slide Bottom 100% | Slide from below, offset = 100% of the element height |
| `"slide-left"` | Slide Left 100% | Slide from the left, offset = 100% of the element width |
| `"slide-right"` | Slide Right 100% | Slide from the right, offset = 100% of the element width |

---

## `animation_delay` prop — section

| Prop | Type | Example | Description |
|---|---|---|---|
| `animation_delay` | numeric string | `"150"` | Delay in ms between child element animations. Creates automatic staggering. Requires `animation` to be set. |

Typical values: `"100"`, `"150"`, `"200"`, `"300"`. `"0"` = no delay.

---

## `animation` prop — element (override)

Set on any **child element** to override the section animation.

| Value | Behaviour |
|---|---|
| `""` | **Inherit** — uses the section animation (default) |
| `"none"` | **None** — disables the animation on this element |
| `"parallax"` | **Parallax** — enables element parallax (requires `parallax_*` props) |
| any animation value | Overrides the section animation for this element |

The same animation values as the section are available as element overrides. Without a section
`animation`, every non-parallax element value is reset to `'none'` at render time — see
`../../builder/wiki/props/animation.md`.

---

## `item_animation` prop — grid and gallery

| Prop | Type | Default | Description |
|---|---|---|---|
| `item_animation` | boolean | `true` | Animates each grid/gallery item separately, in sequence. No effect when `animation` is `"none"` or `"parallax"`. |

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

---

## Recommended usage

| Scenario | Recommended configuration |
|---|---|
| Hero section — elegant entrance | `animation: "fade"`, `animation_delay: "100"` |
| Services grid — staggered slide | `animation: "slide-bottom-small"`, `animation_delay: "150"`, `item_animation: true` |
| Key text — slide from the left | `animation: "slide-left-small"` on the section or the headline element |
| Section already visible on load | Do not set `animation` (or use `""`) |
| Disable on a single element | `animation: "none"` on that element |
