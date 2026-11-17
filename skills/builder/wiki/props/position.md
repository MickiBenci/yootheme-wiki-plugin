---
title: position prop family
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [props, cross-cutting, position, layout, blend]
updated: 2026-07-29
---

# The `position` prop family

Seven props on **57 of the 59 in-scope elements** — the widest family in the builder. Defined at
`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:100-178` and applied by
`packages/builder/src/Builder/ElementTransform.php:119-146`.

| Prop | Type | Values | Gate |
|---|---|---|---|
| `position` | select | `''` (Static) `'relative'` `'absolute'` | — |
| `position_left` | range −600…600 | number → px, or any CSS unit as a string | `position && !position_right` |
| `position_right` | range | idem | `position && !position_left` |
| `position_top` | range | idem | `position && !position_bottom` |
| `position_bottom` | range | idem | `position && !position_top` |
| `position_z_index` | select | `'0'` `'1'` `'2'` `'3'` `''` | `position` |
| `blend` | checkbox | bool | — |

## `relative` exists

[[sources/skill-yootheme-json-schema]] lists only `''` and `'absolute'`. The source defines three
values, and `'relative'` — labelled *Relative* in the builder — offsets the element **while keeping
it in the normal flow**: the space it occupied is preserved and siblings do not move. `'absolute'`
takes it out of the flow entirely, positioned against the containing column.

Filed as A2 in [[issues/element-types-skill-vs-source]].

## Opposite edges are mutually exclusive

`position_left` and `position_right` gate each other, as do `top` and `bottom`. You cannot pin both
edges to stretch an element — set one edge and size the element with `maxwidth`, see
[[props/alignment]].

The emitted style declarations mirror the gates exactly:

```php
'left: {position_left}; {@!position_right}',
'right: {position_right}; {@!position_left}',
'top: {position_top}; {@!position_bottom}',
'bottom: {position_bottom}; {@!position_top}',
```

## Bare numbers become pixels

`ElementTransform.php:125-132` appends `px` to any offset that `is_numeric()`. So `50` renders as
`50px`, while `"50%"`, `"5vh"` and `"50vh + 50%"` pass through untouched. The builder's range slider
produces numbers; typing a unit into the field keeps it a string.

## What `absolute` silently switches off

`position: 'absolute'` is not just a positioning choice — three other families stop applying:

| Family | Effect | Source |
|---|---|---|
| [[props/margin]] | `margin_top`/`margin_bottom` skipped entirely | `ElementTransform.php:169-171` |
| `block_align` in [[props/alignment]] | The auto-margin block is skipped; `maxwidth` still applies | `:209` |
| `container_padding_remove` | Skipped | `:319-322` |

It also emits **`uk-width-1-1`** alongside `uk-position-absolute` (`:134`), so an absolutely
positioned element spans the full width of its containing column by default. Constrain it with
`maxwidth`, not with a width prop.

Finally it sets `element_absolute` on the **parent column** (`:143-145`), which the column uses to
decide whether it still needs to reserve height. An element that is the only content of a column and
is absolutely positioned leaves that column with nothing to size itself against.

## `blend` depends on the parent column

`ElementTransform.php:151-162` — the emitted class is not fixed:

| Condition | Class |
|---|---|
| Parent column has `position_sticky` set | `uk-blend-overlay` |
| Otherwise | `uk-blend-difference` |

So the same `blend: true` produces a different blend mode depending on a prop of an ancestor. If a
blended element suddenly looks different after making its column sticky, this is why.

## `position_sticky` is a different family

`column` declares its own `position_sticky`, `position_blend`, `position_sticky_offset`,
`position_sticky_offset_end`, `position_sticky_breakpoint`. Despite the shared prefix these are
**not** part of this family: they are column-only, they stick the column or its elements while
scrolling, and they are documented on the `column` element page.

## Interaction with parallax

When `animation` is `'parallax'`, `ElementTransform.php:102-114` adds
`uk-position-z-index uk-position-relative` (gated on `parallax_zindex`) plus
`uk-transform-origin-*`. A parallax element therefore acquires a positioning context whether or not
`position` was set. See [[props/animation]].

## Related

[[props/alignment]] · [[props/margin]] · [[props/visibility]] · [[props/animation]] ·
[[props/advanced-group]] · [[uikit/uk-grid]]
