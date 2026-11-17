---
title: visibility and element wrapper props
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [props, cross-cutting, visibility, responsive, semantics]
updated: 2026-07-29
---

# `visibility`, `html_element`, `container_padding_remove`

Three unrelated props grouped here because each is a single field that most elements carry.

## `visibility`

`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:434-450`. Nine values in one select:

| Label | Value | Emits |
|---|---|---|
| Always | `''` | — |
| Visible Small … X-Large | `'s'` `'m'` `'l'` `'xl'` | `uk-visible@<bp>` — shown **from** that width up |
| Hidden Small … X-Large | `'hidden-s'` `'hidden-m'` `'hidden-l'` `'hidden-xl'` | `uk-hidden@<bp>` — hidden **from** that width up |

Both halves are "from this width and larger". There is no "only below" value: hiding on desktop is
`hidden-l`, hiding on mobile is `'l'`.

### Visibility propagates upward

The interesting part, and it is not in any field description.
`packages/builder/src/Builder/VisibilityTransform.php` treats visibility as a **range** `[lower,
upper]` rather than a single class, and walks it up the tree:

```php
$node->attrs['class']['uk-visible@{0}'] = $visibility[0];
$node->attrs['class']['uk-hidden@{0}'] = $visibility[1];

$parent->props['child_visibility'] = $this->merge($visibility, $parent->props['child_visibility'] ?? null);
```

Each node **intersects** its own visibility with the `child_visibility` accumulated from its
children, then **merges** the result into its parent. The practical outcome, which the field
description states without explaining: *"If all elements are hidden, columns, rows and sections will
hide accordingly."*

So a column whose every element is `hidden-m` collapses at `m` on its own — you do not, and should
not, also set `visibility` on the column. Setting it there as well narrows the range further by
intersection and can hide more than intended.

`column` adds one more wrinkle: with `prevent_collapse` set and no children, the transform
(`:31-43`) derives visibility from the first non-`1-1` `width_*` prop instead.

## `html_element`

`builder.php:71-99`. Two variants:

| Reference | Options |
|---|---|
| `${builder.html_element}` — elements and containers | `''` (div) `address` `article` `aside` `footer` `header` `hgroup` `nav` `section` |
| `${builder.html_element_item}` — item types | `''` (div) `address` `article` `section` |

Purely semantic: it changes the wrapper tag and nothing else. `''` is `div`.

Two places where it is not inert:

- `section` adds `uk-margin-remove` when `html_element` is `address` — the browser default margin on
  `<address>` would otherwise break the section box (`elements/section/templates/template.php:29`)
- `list` uses it to decide whether the list is wrapped, which changes its margin handling
  (`elements/list/templates/template.php:7,24`)

`nav`, `column` and `fragment` pass it straight to their root tag.

## `container_padding_remove`

`builder.php:451-458`. A checkbox, gated on `position != 'absolute'`, labelled *"Remove left or
right padding"* under a **Section/Row** heading.

`ElementTransform::containerPadding()` (`:317-371`) shows how narrow its applicability is. It emits
`uk-container-item-padding-remove-left` or `-right` only when **all** of these hold:

1. The element is an `element`, not a container
2. An ancestor `row` or `section` has `width` in `default|small|large|xlarge`
3. That same ancestor has `width_expand` set to `left` or `right`
4. The element's parent column is the first (for `left`) or last (for `right`) in the row,
   accounting for any column with `order_first`

Miss any one and the prop does nothing, silently. It exists for one layout: a constrained section
with one side expanded edge-to-edge, where a particular element in the outermost column should reach
the viewport edge. See [[elements/section]] for `width_expand`.

## Related

[[props/position]] · [[props/alignment]] · [[props/advanced-group]] · [[elements/section]] ·
[[uikit/uk-grid]]
