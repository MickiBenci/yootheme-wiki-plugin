---
title: link prop family
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [props, cross-cutting, link, accessibility]
updated: 2026-07-29
---

# The `link` prop family

`link` itself is defined once at
`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:476-484` and referenced as
`'${builder.link}'` by every element that can carry one. The `link_*` companions are declared
per element, because which of them exist depends on what the element does with the link.

```php
'link' => [
    'label' => 'Link',
    'type' => 'link',
    'description' => 'Enter or pick a link, an image or a video file.',
    'attrs' => ['placeholder' => 'http://'],
    'source' => true,
],
```

## `link` is a plain string

`'type' => 'link'` describes the **builder widget** — a text input with a picker attached — not the
serialised shape. What lands in `props` is a string:

```json
{
  "type": "panel",
  "props": {
    "link": "corso-allenamento-funzionale/"
  }
}
```

A site-relative path, an absolute URL, a `#anchor`, or a path to an image or video file (the picker
accepts media, which is how lightbox and inline-video links are authored). Never an object, never
`null` — one of the invariants in [[sources/skill-yootheme-json-schema]], and confirmed across the
real export in [[sources/production-layout-sample]].

`'source' => true`: the value can be bound to dynamic content instead of typed.

## The `link_*` companions

Read off `panel` (`elements/panel/element.php:826-897`); `grid` carries the same set plus a couple
of extras, `grid_item` a reduced one.

| Prop | Type | Values | Notes |
|---|---|---|---|
| `link_text` | text | free string | The visible label. Default `'Read more'` on `panel` and `grid` |
| `link_aria_label` | text | free string | For links with no visible text. Renders as `aria-label` |
| `link_target` | checkbox | bool | Emits `target="_blank"` |
| `link_download` | checkbox | bool | Emits the `download` attribute |
| `link_rel_nofollow` | checkbox | bool | Adds `nofollow` to `rel` |
| `link_rel_noreferrer` | checkbox | bool | Adds `noreferrer` to `rel` |
| `link_style` | select | see below | Button or link appearance |
| `link_size` | select | `'small'` `''` `'large'` | Button size. Disabled for the two link styles |
| `link_fullwidth` | checkbox | bool | `uk-width-1-1` on the button |
| `link_margin` | select | `xsmall\|small\|''\|medium\|large\|xlarge\|remove` | Top margin of the link region — see [[props/margin]] |

### `link_style`

| Label | Stored value |
|---|---|
| Button Default | `'default'` — **the default on `panel` and `grid`** |
| Button Primary | `'primary'` |
| Button Secondary | `'secondary'` |
| Button Danger | `'danger'` |
| Button Text | `'text'` |
| Link | `''` |
| Link Muted | `'link-muted'` |
| Link Text | `'link-text'` |

`''` means "plain link", not "unset" — the empty value is a real, selectable style here. `link_size`
and `link_fullwidth` are gated by `!$match(link_style, 'link-(muted|text)')`, so they have no effect
on the two link-flavoured styles.

## `panel_link` changes what gets wrapped

`panel_link` is a separate checkbox that makes the **whole panel** the clickable surface instead of
just the link text. `elements/panel/templates/template-link.php` shows the consequences, and they
are not obvious:

- the `<a>` becomes the panel's outer container and takes `uk-link-toggle`
- the link region degrades to a `<div>` — it still looks like a button but is no longer a link, so
  the markup stays valid with no nested anchors
- `title`, `meta` and `content` are passed through `striptags()`. **Any inline HTML in the panel's
  content is silently stripped** — nested anchors would be invalid, so the whole tag set goes. The
  guard is `if ($link && $props['panel_link'])`: it takes both a non-empty `link` *and*
  `panel_link`, so a panel with `panel_link` set but no link value keeps its markup intact
- `template.php:9-12` resets `title_link` and `image_link` to `''`: they are redundant and would
  nest anchors

`panel_link_hover` adds `uk-card-hover` or `uk-tile-hover`, and is gated on `panel_style` matching
`card-(default|primary|secondary|overlay)|tile-` — it does nothing on `card-hover` (already hovering)
or on a blank panel. See [[uikit/uk-card]].

## `uk-scroll` is added automatically

`template-link.php:12`: if the link value contains `#`, the anchor gets `uk-scroll`, giving smooth
scrolling for free. It is string containment, not a prefix test — a URL with a query fragment picks
it up too.

## Item-level overrides

`grid_item` carries its own `link`, `link_text`, `link_aria_label` and `link_style`, each described
as *"Set a different … for this item"*. The parent `grid` supplies the defaults; an item overrides
only what it sets. `grid_item.link_style` also has a `'None' => ''` option that the parent's list
lacks, since at item level `''` means "inherit".

## Where the link is suppressed entirely

`grid.show_link` is a master switch. When `false`, `grid_item`'s render transform
(`elements/grid_item/element.php:28-40`) blanks the item's `link` prop before rendering. The item's
own link value survives in the JSON — it is simply not rendered. [[sources/production-layout-sample]]
shows exactly this: grids with `show_link: false` still carry `link_text: "Read more"`.

## Related

[[props/advanced-group]] · [[props/margin]] · [[elements/panel]] · [[elements/grid]] ·
[[elements/grid_item]] · [[uikit/uk-card]]
