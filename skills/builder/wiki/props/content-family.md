---
title: content prop family
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, content, typography, columns]
updated: 2026-07-29
---

# The `content_*` family

Eight props on 15 elements. `content` is the rich-text body of a card. Definitions from
`elements/grid/element.php:1003-1104`, rendering from
`elements/panel/templates/template-content.php:35-49`.

| Prop | Values | Emits |
|---|---|---|
| `content_style` | `''` · `text-meta` `text-lead` `text-small` `text-large` · `heading-3xlarge`…`heading-small` · `h1`–`h6` | `uk-{content_style}` |
| `content_align` | bool — "Force left alignment" | `uk-text-left` |
| `content_dropcap` | bool | `uk-dropcap` |
| `content_column` | `''` `1-2` `1-3` `1-4` `1-5` `1-6` | `uk-column-{value}@{breakpoint}` |
| `content_column_divider` | bool | `uk-column-divider` — gated on `content_column` |
| `content_column_breakpoint` | `''` `s` `m` `l` `xl` | Default `'m'` |
| `content_margin` | `xsmall` `small` `''` `medium` `large` `xlarge` `remove` | `uk-margin-{value}-top` |
| `content_margin_auto` | bool | `uk-margin-auto-bottom` |

## The content wrapper is a `uk-panel`

`template-content.php:38` emits `el-content uk-panel` on the wrapping `<div>`. That matters more than
it looks: `uk-panel` establishes a block formatting context and resets the last child's bottom
margin, which is what keeps a card's text from pushing against its lower padding. See
[[uikit/uk-card]] for the surrounding box.

The content prop holds **HTML**, from an `editor` field. It is the only card region that does.

## `content_align` is a boolean, not an alignment

Labelled *"Force left alignment"*, typed `checkbox`. It emits `uk-text-left` and exists to override a
centred `text_align` on the element for the body copy alone — a common card design where the title
and link are centred but the paragraph reads left. There is no "force right" or "force centre"
counterpart; for those, use the element-level `text_align` in [[props/alignment]].

The bracket syntax `'[uk-text-left{@content_align}]'` (`:40`) groups it so it survives the
responsive-suffix machinery intact.

## Text columns

`content_column` splits the body into CSS multi-columns — `1-2` is two columns, `1-6` is six. Not to
be confused with the layout `column` element or with [[props/title-family]]'s sub-grid: this is
`column-count` on the text itself.

`content_column_breakpoint` defaults to `'m'`, so columns apply from tablet landscape up and the text
runs single-column on phones. `''` means always, including phone portrait, which is almost never what
you want for a card.

`content_column_divider` draws a rule between the columns and is gated on `content_column` being set.

## `content_display` and the gating cascade

Where the element has a lightbox, `content_display` decides where the body appears:

| Value | Meaning |
|---|---|
| `''` | Panel **and** lightbox caption |
| `'item'` | Panel only |
| `'lightbox'` | Lightbox caption only |

Every prop on this page is then gated on
`show_content && (content_display != 'lightbox' && lightbox || !lightbox)`. Choosing *Lightbox only*
disables the whole family — the body is no longer rendered in the panel, so there is nothing to
style. See [[props/lightbox]].

## The bottom-margin reset is style-dependent

`template-content.php:45`:

```php
'uk-margin-remove-bottom {@!content_margin_auto}' => str_starts_with($props['content_style'] ?? '', 'h'),
```

Applied **only** when `content_style` is a heading value. With no style, or with a `text-*` style, no
reset is emitted. The equivalent rule differs on title and meta — see [[props/meta-family]].

`content_margin` is a top margin subject to the same *"only if the field immediately follows another
content field"* condition as the rest of the family. `content_margin_auto` is one of the three flags
driving the panel expand mechanism in [[elements/panel]] — the usual choice for keeping card links on
a shared baseline.

## Related

[[props/title-family]] · [[props/meta-family]] · [[props/image-family]] · [[props/alignment]] ·
[[props/margin]] · [[props/lightbox]] · [[props/show-switches]] · [[uikit/uk-card]] ·
[[elements/panel]]
