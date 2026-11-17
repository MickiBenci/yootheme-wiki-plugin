---
title: title prop family
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [props, cross-cutting, title, heading, typography]
updated: 2026-07-29
---

# The `title_*` family

Fourteen props on 18 elements — every element that renders a card-like title: [[elements/panel]],
[[elements/grid]], `gallery`, `slideshow`, `panel-slider`, `overlay-slider`, `overlay`, `switcher`,
`popover`, `table`, `accordion`, `map`, `list`, `alert`, `quotation`, `countdown` and the item
variants. Definitions read from `elements/grid/element.php:704-910`, rendering from
`elements/panel/templates/template-content.php:4-19`.

## Appearance

| Prop | Values | Emits |
|---|---|---|
| `title_style` | `''` · `heading-3xlarge` `heading-2xlarge` `heading-xlarge` `heading-large` `heading-medium` `heading-small` · `h1`–`h6` · `text-meta` `text-lead` `text-small` `text-large` | `uk-{title_style}` |
| `title_decoration` | `''` `'divider'` `'bullet'` `'line'` | `uk-heading-{value}` |
| `title_font_family` | `''` `'default'` `'primary'` `'secondary'` `'tertiary'` | `uk-font-{value}` |
| `title_color` | `''` `muted` `emphasis` `primary` `secondary` `success` `warning` `danger` `background` | `uk-text-{value}` |
| `title_element` | `h1`–`h6` `div` | The tag itself. Default `'h3'` on most elements |

**Style and element are independent.** `title_style: 'h2'` with `title_element: 'div'` gives H2
appearance with no heading semantics — the right choice for a number in a statistics strip or a card
title that is not a document heading. Conversely `title_element: 'h2'` with `title_style: ''` inside
a styled panel falls back to `uk-card-title` (`template-content.php:9`), because a card supplies its
own title sizing.

The description of `title_style` is worth quoting: *"Title styles differ in font-size but may also
come with a predefined color, size and font."* Picking a style can silently override `title_color`
and `title_font_family`.

### Two values that add a `<span>`

`template-content.php:108-114` wraps the text differently for two of them:

- `title_color: 'background'` → `<span class="uk-text-background">` inside the heading. The
  description notes that styles without a background image fall back to the primary colour
- `title_decoration: 'line'` → a bare `<span>`, which is what the vertically-centred line rule needs
  to attach to

Both mean the title text is no longer a direct child of the heading tag — relevant when writing CSS
in the element's `css` field, see [[props/advanced-group]].

## Linking

| Prop | Values | Gate |
|---|---|---|
| `title_link` | bool | `show_link` and the title is displayed |
| `title_hover_style` | `'reset'` (None) `'heading'` (Heading Link) `''` (Default Link) | plus `title_link \|\| panel_link` |

`title_hover_style` defaults to `'reset'`, and the value mapping is inverted from what the labels
suggest: **`'reset'` means no link styling, `''` means the default link style.** The empty string is
a real choice here, not an unset.

`uk-link-{title_hover_style}` is emitted on the heading itself rather than on the anchor. The source
comment explains why: *"Set here to style links which already come with dynamic content (WP taxonomy
links)"* — a title bound to a taxonomy field arrives with its own `<a>` already inside.

When `panel_link` is on, [[props/link]] takes over: `title_link` is reset and the title text is
passed through `striptags()`.

## Layout: `title_align` and the title sub-grid

| Prop | Values | Gate |
|---|---|---|
| `title_align` | `'top'` `'left'` | — |
| `title_grid_width` | `auto` `expand` `4-5` `3-4` `2-3` `3-5` `1-2` `2-5` `1-3` `1-4` `1-5` `small` `medium` `large` `xlarge` `2xlarge` | `title_align == 'left'` |
| `title_grid_column_gap` / `title_grid_row_gap` | `small` `medium` `''` `large` `collapse` | idem |
| `title_grid_breakpoint` | `''` `s` `m` `l` `xl` | idem |

With `title_align: 'left'` the title and the rest of the content become two cells of a `uk-grid`
(`template-content.php:62-93`) — title on the left, content on the right, stacking below the
breakpoint. All four `title_grid_*` props are inert when alignment is `top`.

This is the recurring **sub-grid pattern**: `<prefix>_grid_width` + `_grid_column_gap` +
`_grid_row_gap` + `_grid_breakpoint`. It appears identically as `image_grid_*` (see
[[props/image-family]]) and `filter_grid_*` (see [[elements/grid]]). Same four props, same
equal-gap/split-gap branch, same `uk-width-*@<bp>` output. See [[uikit/uk-grid]].

`title_grid_width: 'expand'` inverts the sizing: the title cell expands and the content cell becomes
`uk-width-auto` (`:78, :88`).

## Spacing

| Prop | Values |
|---|---|
| `title_margin` | `xsmall` `small` `''` `medium` `large` `xlarge` `remove` |
| `title_margin_auto` | bool — labelled "Margin Bottom: Auto" |

`title_margin` is a **top** margin, and its description carries a condition: *"the margin will only
apply if the content field immediately follows another content field."* A title with nothing above
it ignores it.

`title_margin_auto` is one of the three flags feeding the panel expand mechanism — see
[[props/margin]] and [[elements/panel]]. It emits `uk-margin-auto-bottom`; without it the heading
gets `uk-margin-remove-bottom`.

## Display gating

Where a `lightbox` exists, most of these props are gated on
`(title_display != 'lightbox' && lightbox || !lightbox)`. Choosing *Lightbox only* for the title
disables the entire panel-side styling group. See [[props/lightbox]].

`show_title: false` blanks the title prop before render — see [[props/show-switches]].

## Related

[[props/meta-family]] · [[props/content-family]] · [[props/image-family]] · [[props/panel-style]] ·
[[props/link]] · [[props/margin]] · [[props/lightbox]] · [[elements/panel]] · [[elements/grid]] ·
[[uikit/uk-grid]]
