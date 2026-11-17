---
title: grid_item element
type: element
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]", "[[sources/production-layout-sample]]", "[[sources/websites-demo]]"]
tags: [element, item, grid, card]
updated: 2026-07-29
---

# `grid_item`

One card inside a [[elements/grid]].
`raw/yootheme-pro-5.0.33/packages/builder/elements/grid_item/element.php` — 326 lines against the
grid's 1766, which is the whole story: **the item carries content, the parent carries styling.**

```php
'name' => 'grid_item',  'title' => 'Item',
// no 'element'   → cannot be inserted on its own
// no 'container' → children are not meaningful
// no 'defaults'  → every prop starts empty
```

`grid_item` is also the **worked example for the 16 item types** — see the item types page for the
shared core and the per-type deltas.

## Content props

| Prop | Type | Notes |
|---|---|---|
| `title` `meta` `content` | text / text / editor | |
| `image` / `video` | media | Mutually exclusive (`'show' => '!video'` / `'!image'`) |
| `image_alt` | text | `'show' => 'image && !video'` |
| `icon` | icon | `'enable' => '!image && !video'` — the media slot's fallback |
| `hover_image` / `hover_video` | media | `'enable' => 'image \|\| video'` |
| `link` `link_text` `link_aria_label` | | "Set a different … for this item" |
| `tags` | text | Comma-separated; drives the parent's filter |

Every one is `'source' => true` — an item is the natural binding point for dynamic content, which is
what makes a grid the element that renders a post loop. In [[sources/websites-demo]] 55 `grid_item`
nodes are bound via the node-level `source` key, typically `#parent` mapping `title`, `image`,
`link` and `content` from the enclosing query — the serialised shape is in
[[concepts/dynamic-content]].

## Props unique to the item

Five settings, each overriding the parent for that card alone:

| Prop | Notes |
|---|---|
| `panel_style` | The ten values **without `tile-checked`** — alternation is a collection property. See [[props/panel-style]] |
| `item_element` | `''` `address` `article` `section` — the shorter `html_element_item` list, no `header`/`footer`/`nav`/`aside` |
| `link_style` | The eight values **plus `'None' => ''`** — at item level `''` means inherit, so it needs an explicit None. See [[props/link]] |
| `image_focal_point`, `hover_image_focal_point`, `lightbox_image_focal_point` | Per-image cropping. See [[props/image-family]], [[props/lightbox]] |
| `image_text_color`, `lightbox_text_color` | `''` `light` `dark` |

Everything else — columns, gaps, `image_align`, `title_element`, padding, the `show_*` switches — is
a [[elements/grid]] prop and cannot vary per item.

## The render transform

`element.php:28-72` does three things, none of them visible from the field definitions.

**1. The parent's `show_*` switches blank the item's props.** Documented in
[[props/show-switches]] — including the consequence that an item whose only populated fields are
switched off **disappears entirely** rather than rendering empty.

**2. Media type auto-correction**, identical to [[elements/panel]] — see [[props/media]].

**3. The empty-render rule** (`:66-71`): nothing is emitted unless one of `title`, `meta`,
`content`, `image`, `video`, `icon` is non-empty. `link` and `tags` alone are not enough.

## Advanced group

`advancedItem`, so `name`, `status`, `source`, `id`, `class`, `attributes`, `css` — **no
`transform`**. See [[props/advanced-group]]. `status: 'disabled'` hides one card while leaving it in
the layout.

## Serialised shape

An item with no children omits `children` altogether in exported layouts:

```json
{
  "type": "grid_item",
  "props": {
    "meta": "Funzionale",
    "title": "Allenamento Funzionale",
    "content": "<p>Mobility & Postural, WTA Functional Training…</p>",
    "image": "wp-content/uploads/PLACEHOLDER_500x360.jpg",
    "image_alt": "Allenamento Funzionale",
    "link": "corso-allenamento-funzionale/",
    "link_text": "Scopri",
    "link_style": "text"
  }
}
```

Verbatim from [[sources/production-layout-sample]]. Both forms import fine; the wiki's own
snippets keep `"children": []` per the invariant in [[sources/skill-yootheme-json-schema]].

`element.php:9-21` gives a freshly inserted item `title: 'Title'` and lorem ipsum content.
Placeholders never appear in exported JSON.

## Related

[[elements/grid]] · [[elements/panel]] · [[recipes/service-card-grid]] · [[props/show-switches]] ·
[[props/panel-style]] · [[props/link]] · [[props/advanced-group]]
