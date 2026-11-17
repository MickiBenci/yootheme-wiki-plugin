---
title: animation props — how the builder applies them
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, animation, scrollspy, parallax]
updated: 2026-07-29
---

# `animation`, `animation_delay`, `item_animation`

**The canonical reference for animation values, parallax panels and recipes is the
`animations` skill** at `skills/animations/` — declared a
baseline in `CLAUDE.md`. It covers the option lists, the four parallax panels
(`builder-parallax`, `image-parallax`, `background-parallax`, `media-overlay-parallax`), the stop
format, the UIkit animation classes and the LESS variables. None of that is repeated here.

This page adds only what the skill does not carry: **the mechanism by which the builder turns these
props into attributes**, read from `packages/builder/src/Builder/ElementTransform.php:58-114`.

## The section dependency is enforced, not advisory

The field description says the element-level `animation` *"won't have any effect unless animations
are enabled for this section."* The transform shows this is a hard gate, and what happens when it
fails:

```php
if ($builder->parent($path, 'section', 'animation')) {
    $attr = 'uk-scrollspy-class';
    $value = in_array($value, ['none','parallax']) ? false
           : (!empty($value) ? ['uk-animation-{0}' => $value] : true);
} else {
    // …
    if (($node->props['animation'] ?? null) !== 'parallax') {
        $node->props['animation'] = 'none';
    }
}
```

Two consequences:

1. Without an ancestor `section` carrying `animation`, the element's own `animation` prop is
   **overwritten with `'none'`** before rendering. It is not merely ignored — it is erased, so
   anything downstream that reads it sees `'none'`
2. `'parallax'` is the exception. Parallax is handled separately (`::parallax()`, `:102-114`) and
   works with no section animation at all

So: scrollspy animations are opt-in **per section**, parallax is opt-in per element.

## Where the attribute lands

The element does not get `uk-scrollspy`. It gets **`uk-scrollspy-class`**, and the section is what
carries `uk-scrollspy` with `target: [uk-scrollspy-class]`
(`elements/section/templates/template.php:62-68`). The section drives, the elements declare.

| Element `animation` | Emitted on the element |
|---|---|
| `''` (Inherit) | `uk-scrollspy-class` with no value — uses the section's animation |
| A named animation | `uk-scrollspy-class="uk-animation-<value>"` |
| `'none'` | nothing — the element opts out |
| `'parallax'` | nothing from this path; `uk-parallax` from `::parallax()` |

## `item_animation` moves the attribute to the children

```php
foreach (!empty($node->props['item_animation']) ? $node->children : [$node] as $child) {
    $child->attrs[$attr] = $value;
}
```

With `item_animation` set the scrollspy attribute is written on **each child node instead of the
element**, so a grid's cards animate one after another rather than the grid animating as one block.
The field is gated `'show' => "!$match(animation, 'none|parallax')"` — it disappears from the UI
when the element opts out or goes parallax.

`grid` defaults it to `true`; check each element's `defaults`.

## SVG stroke animation is routed through the same path

`:64-71` — when both `image_svg_inline` and `image_svg_animate` are set, the `image_svg_inline` prop
is **rewritten from a boolean into a configuration string**:

```php
$node->props['image_svg_inline'] = ['stroke-animation: true; attributes: uk-scrollspy-class:uk-animation-stroke'];
```

And if there is no section animation, the element still gets `uk-scrollspy` directly with
`target: [uk-scrollspy-class]` (`:83-86`) — stroke animation is the one case that bootstraps its own
scrollspy. See the skill's *SVG Stroke Animation* section for the props; the rewrite is the part it
does not mention.

## Parallax adds a positioning context

`::parallax()` prepends `uk-position-z-index uk-position-relative` (gated on `parallax_zindex`) and
`uk-transform-origin-{parallax_transform_origin}`. A parallax element therefore acquires a stacking
and positioning context whether or not `position` was set — relevant when it starts overlapping
neighbours unexpectedly. See [[props/position]].

## Related

[[props/position]] · [[elements/section]] · [[elements/grid]] · [[props/advanced-group]]
