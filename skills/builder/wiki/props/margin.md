---
title: margin_top and margin_bottom
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [props, cross-cutting, spacing, migration]
updated: 2026-07-29
---

# `margin_top` / `margin_bottom`

Vertical spacing on an element, defined once at
`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:179-212` and referenced as
`'${builder.margin_top}'` / `'${builder.margin_bottom}'` by most elements.

## Values

Identical option sets for both props:

| Builder label | Stored value | Meaning |
|---|---|---|
| Keep existing | `''` | Do not touch the margin. **The absent-value default for most elements** |
| X-Small | `'xsmall'` | |
| Small | `'small'` | |
| Default | `'default'` | The theme's normal element spacing |
| Medium | `'medium'` | |
| Large | `'large'` | |
| X-Large | `'xlarge'` | |
| Remove | `'remove'` | Collapse the margin to zero |
| Auto | `'auto'` | Absorb the free space — pushes siblings apart in a flex column |

Both are gated by `'enable' => "position != 'absolute'"`: on an absolutely positioned element the
fields are greyed out, because `position_top`/`position_bottom` take over. See
[[props/advanced-group]] for the sibling positioning props.

### `''` is "keep existing", not "no margin"

This is the one that catches people. `''` leaves whatever the theme's stylesheet already applies;
to actually zero a margin you need `'remove'`. Two different outcomes for what reads like the same
"empty" value.

### `'auto'` and the expand mechanism

`'auto'` is not a spacing size. In `panel` and `grid` the render templates read
`title_margin_auto`, `meta_margin_auto` and `content_margin_auto` into a `content_expand` flag,
which switches the panel to `uk-flex uk-flex-column` and lets one region absorb the slack — how
cards of unequal text length keep their links aligned along a common baseline. See
[[elements/panel]].

## Element-level defaults differ from the field default

The field's own default is `''`, but several elements override it in their `defaults` array:

| Element | `margin_top` | `margin_bottom` | Source |
|---|---|---|---|
| `panel` | `'default'` | `'default'` | `elements/panel/element.php:29-30` |
| `grid` | `'default'` | `'default'` | `elements/grid/element.php:47-48` |
| `section` | — | — | Uses `padding_top`/`padding_bottom` instead; no margin props |

So a `panel` node with no margin props in its JSON still gets default spacing on both sides. An
exported layout usually shows these written out explicitly — see
[[sources/production-layout-sample]].

## Position in the parent decides whether the margin is emitted at all

`ElementTransform::margin()` (`packages/builder/src/Builder/ElementTransform.php:167-199`) branches
on whether the two values are equal, like `section` padding — but it also drops margins based on
**where the element sits among its siblings**:

| Condition | Behaviour |
|---|---|
| `position == 'absolute'` | Returns immediately. **No margin classes at all** |
| Values equal | One shared class: `uk-margin` for `default`, otherwise `uk-margin-<value>`, with `-vertical` appended for `remove` and `auto` |
| Values differ, element is **first child** | `margin_top` is **skipped** |
| Values differ, element is **last child** | `margin_bottom` is **skipped** |
| Values equal to `'auto'` and element is **first child** | Emits `uk-margin-auto-bottom` instead of the vertical pair |

The two skips are the ones that cause "my margin isn't applying". A top margin on the first element
of a column and a bottom margin on the last are deliberately suppressed — the column's own padding
is meant to provide that spacing. If you genuinely need it there, put it on the column or the row,
not the element.

Note this only holds in the **different-values** branch. Setting both sides to the same value emits
the shared class regardless of position, which is a way to force the margin the skips would remove.

## Not the same as the sub-region margins

`panel` and `grid` also carry `title_margin`, `meta_margin`, `content_margin`, `image_margin` and
`link_margin`. Those are a different family: they take `xsmall|small|''|medium|large|xlarge|remove`
— no `'auto'`, no `'default'` — and each has a `'margin_..._auto'` checkbox beside it for the bottom
side. They space regions *inside* a panel; `margin_top`/`margin_bottom` space the element within its
column.

Their `description` adds a condition worth knowing: *"the margin will only apply if the content
field immediately follows another content field."* A title with nothing above it ignores its
`title_margin`.

## History: since 5.0.0-beta.0.7

`raw/yootheme-pro-5.0.33/packages/builder/updates.php:6-29` migrates four older props into these
two:

| Before 5.0 | After |
|---|---|
| `margin` (single value for both sides) | copied into both `margin_top` and `margin_bottom` |
| `margin: 'remove-vertical'` | normalised to `'remove'` first, then copied |
| `margin_remove_top` (bool) | `margin_top: 'remove'` |
| `margin_remove_bottom` (bool) | `margin_bottom: 'remove'` |
| `push` (bool) | `margin_bottom: 'auto'` |

All four old props are `unset` afterwards. Layouts exported from YOOtheme Pro 4 or earlier still
carry them; the builder migrates on import, so they never need writing by hand. **Do not author
`margin`, `margin_remove_top`, `margin_remove_bottom` or `push` in new JSON** — they are dead props
in 5.x and only survive as migration inputs.

## Contested: the option list in the canonical skill

`references/element-types.md:44-45` of [[sources/skill-yootheme-json-schema]] lists
`'' small default medium large xlarge remove` — **omitting `xsmall` and `auto`**. `'auto'` in
particular is not a cosmetic gap: the equal-height card behaviour depends on it. Filed in
[[issues/element-types-skill-vs-source]].

## Related

[[props/advanced-group]] · [[elements/panel]] · [[elements/grid]] · [[elements/section]]
