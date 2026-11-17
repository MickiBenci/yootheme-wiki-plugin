---
title: show_* master switches
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/production-layout-sample]]", "[[sources/yootheme-pro-5.0.53-source]]"]
tags: [props, cross-cutting, show, visibility, items]
updated: 2026-10-30
---

# The `show_*` master switches

Booleans on the parent element that decide which content fields its **children** render. Present on
the eleven in-scope multi-item elements: [[elements/grid]], `gallery`, `slideshow`, `panel-slider`,
`overlay-slider`, `switcher`, `popover`, `table`, `map`, `description_list`.

All default to `true`. They are the main styling lever in practice — the same element serves very
different purposes depending on which fields are on.

## The set differs per element

There is no universal list. Read the element's own `defaults`:

| Element | Switches |
|---|---|
| `grid`, `panel-slider` | `show_title` `show_meta` `show_content` `show_image` `show_video` `show_link` `show_hover_image` `show_hover_video` — **eight** |
| `gallery`, `overlay-slider` | as above **without** `show_image` and `show_video` |
| `switcher` | `show_title` `show_meta` `show_content` `show_image` `show_link` + `show_label` `show_thumbnail` |
| `slideshow` | `show_title` `show_meta` `show_content` `show_link` + `show_thumbnail` |

`show_thumbnail` on those two is doubly consequential: the `thumbnav_*` props in
[[props/slider-nav]] are gated on it as well as on the navigation type, so switching it off leaves a
thumbnail navigation with nothing to render.
| `map`, `popover`, `table` | `show_title` `show_meta` `show_content` `show_image` `show_link` |
| `description_list` | `show_title` `show_meta` `show_content` `show_link` |

[[sources/skill-yootheme-json-schema]] lists five for `grid`, missing `show_video`,
`show_hover_image` and `show_hover_video` — filed as A5 in
[[issues/element-types-skill-vs-source]]. All three appear in the production export in
[[sources/production-layout-sample]].

## They blank the child's props, they do not hide them

The mechanism lives in the **item's** render transform, not the parent's.
`elements/grid_item/element.php:28-40`:

```php
foreach (['title','meta','content','link','image','video','hover_image','hover_video'] as $key) {
    if (!$params['parent']->props["show_{$key}"]) {
        $node->props[$key] = '';
        if ($key === 'image') { $node->props['icon'] = ''; }
    }
}
```

Three consequences:

1. **The data survives in the JSON.** Turning a switch back on restores every item's field. Nothing
   is lost, which makes the switches safe to toggle while designing
2. **`icon` rides along with `image`.** There is no `show_icon`: the icon is the image slot's
   fallback, so it is governed by the same switch. See [[props/image-family]]
3. The blanking happens **before** the item's emptiness test, which is where it gets interesting

**`panel-slider` before 5.0.47:** `panel-slider_item/element.php` listed `'hover_image'` twice and
`'hover_video'` not at all, so `show_hover_video` off **did not hide** a slide's hover video. Fixed
in 5.0.47 (*"Fix hiding hover videos in Panel Slider items"*) — see
[[sources/yootheme-pro-5.0.53-source]]. `grid_item` was never affected.

## Blanking can delete the item entirely

Every item type ends its transform with a rule like `grid_item`'s (`:66-71`): render nothing unless
one of `title`, `meta`, `content`, `image`, `video`, `icon` is non-empty. `link` and `tags` do not
count.

Since the switches run first, **an item whose only populated fields are switched off disappears**
rather than rendering as an empty card. With `show_title: false` and `show_content: false`, items
that carried only a title and a description vanish; items that also had an image survive. A grid can
therefore lose some of its cards and keep others when a switch is toggled.

## They are the idiom, not an edge case

[[sources/production-layout-sample]] uses them three ways on one page, all with the same
element:

| Configuration | Result |
|---|---|
| `show_image: false`, `show_content: false`, `grid_divider: true` | Statistics strip — big number plus label |
| all on, `panel_style: ""`, `image_border: rounded` | Instructor cards |
| all on, `panel_style: card-default`, `link_style: text` | Service cards — see [[recipes/service-card-grid]] |

Write them explicitly. All three grids in that layout do, and it makes the intent legible in a way
that relying on the `true` defaults does not.

## Related gating

Switches gate the styling props too. Most of [[props/title-family]] is gated on `show_title`, most of
[[props/image-family]] on `show_image || show_video`, and [[props/link]]'s companions on `show_link`.
A styling prop that appears to do nothing is often sitting behind a switched-off field.

Not to be confused with [[props/visibility]], which hides the rendered element responsively, or with
`title_display` / `content_display` in [[props/lightbox]], which move a field between the panel and
the lightbox caption rather than removing it.

## Related

[[props/image-family]] · [[props/title-family]] · [[props/meta-family]] · [[props/content-family]] ·
[[props/link]] · [[props/lightbox]] · [[props/visibility]] · [[elements/grid]] ·
[[elements/grid_item]]
