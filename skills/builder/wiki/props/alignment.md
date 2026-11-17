---
title: alignment and max-width props
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [props, cross-cutting, alignment, maxwidth, responsive, breakpoint]
updated: 2026-07-29
---

# Alignment and max-width

Eight props across ~49 elements, defined at
`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:213-337` and applied by
`ElementTransform::maxWidth()` and `::textAlign()`
(`packages/builder/src/Builder/ElementTransform.php:201-272`).

Two independent things that look alike: **`text_align` aligns the text inside the element**,
**`block_align` aligns the element itself** once `maxwidth` has made it narrower than its column.

## The breakpoint + fallback pattern

All three groups share one shape, and it recurs throughout the builder:

| Prop | Meaning |
|---|---|
| `<name>` | The value that applies **from the breakpoint upward** |
| `<name>_breakpoint` | `''` (Always) `'s'` `'m'` `'l'` `'xl'` |
| `<name>_fallback` | The value **below** the breakpoint |

With `_breakpoint: ''` the main value applies everywhere and the fallback is inert. This is a
responsive pair, not an override: `text_align: 'left'` + `text_align_breakpoint: 'm'` +
`text_align_fallback: 'center'` means *centred on phone and small tablet, left from tablet landscape
up*. The **fallback is the mobile value**, which reads backwards until you internalise it.

## `maxwidth`

| Prop | Values |
|---|---|
| `maxwidth` | `''` `'small'` `'medium'` `'large'` `'xlarge'` `'2xlarge'` |
| `maxwidth_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` — gated on `maxwidth` |

Emits `uk-width-{maxwidth}@{breakpoint}`. Named widths, not fractions — the pixel values come from
UIkit's `@width-*` variables, see [[uikit/uk-grid]].

## `block_align`

| Prop | Values | Gate |
|---|---|---|
| `block_align` | `''` (Left) `'center'` `'right'` | `position != 'absolute' && maxwidth` |
| `block_align_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | idem |
| `block_align_fallback` | `''` `'center'` `'right'` | plus `block_align_breakpoint` |

**`block_align` does nothing without `maxwidth`.** The gate says so, and `maxWidth()` returns early
when `maxwidth` is empty (`:203`) — the entire auto-margin block lives inside that method. An
element at full column width has no free space to be aligned within.

It is implemented as auto margins, not as a text property:

| Alignment | Classes |
|---|---|
| Left (`''`) | `uk-margin-auto-right` + `uk-margin-remove-left` |
| Center | `uk-margin-auto` |
| Right | `uk-margin-auto-left` + `uk-margin-remove-right` |

Which is why it interacts with [[props/margin]]: an element with `block_align` already carries auto
margins on the horizontal axis.

## `text_align`

| Prop | Values |
|---|---|
| `text_align` | `''` `'left'` `'center'` `'right'` — plus `'justify'` on elements referencing `${builder.text_align_justify}` |
| `text_align_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` — gated on `text_align && text_align != 'justify'` |
| `text_align_fallback` | same list as its `text_align` variant |

Two variants exist in the shared library: `text_align` (no justify) and `text_align_justify`.
Elements pick one; `panel`, `grid` and `headline` take the justify variant. **`justify` cannot be
made responsive** — its own gate excludes it from the breakpoint field.

Normally emits `uk-text-{align}@{breakpoint}` with the fallback as a plain `uk-text-*`.

### The image/video exception

`ElementTransform.php:240-265` — on an `image` or `video` element with `height_expand` set and
**no** `maxwidth`, `text_align` stops emitting `uk-text-*` and emits the auto-margin classes
instead, exactly like `block_align`.

The reason is structural: an expanded image is a flex child, and text alignment does not move it.
The consequence is that on those two elements, in that one configuration, `text_align` aligns the
*element* rather than its text. Set `maxwidth` and the behaviour reverts.

### Vertical translation inside panels

`panel` and `grid` convert `text_align` from horizontal words to vertical ones
(`left|center|right` → `top|middle|bottom`) when the panel is in expand mode, to drive
`uk-flex-*` on the column axis. See [[elements/panel]] — the prop is read twice, for two axes.

## What the canonical skill says

[[sources/skill-yootheme-json-schema]] lists all three groups correctly at
`references/element-types.md:46-53`. The gaps here are behavioural, not value-level: the
`maxwidth` dependency of `block_align`, the auto-margin implementation, and the image/video
exception are not in the skill.

## Related

[[props/position]] · [[props/margin]] · [[props/visibility]] · [[uikit/uk-grid]] ·
[[elements/panel]] · [[props/advanced-group]]
