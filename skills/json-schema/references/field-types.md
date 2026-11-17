# YOOtheme Pro Builder Field Types

How YOOtheme builder field types serialise in builder JSON.

> **Correction (v3.0.0):** an earlier version of this page described `image`, `video`, `link` and
> `location` as objects (`{src, alt}`, `{url, text, target}`, `{lat, lng}`), item lists as an
> `items` array inside `props`, and element types with a `builder_` prefix. None of that matches
> real exports: every real layout examined (78 files, YOOtheme Pro 5.0.x) stores those fields as
> **plain strings** and items as **child nodes**. This page now documents the verified format.

## 1. `text` — single-line text

Serialises as a **string**.

```json
{ "title": "My title" }
{ "link_text": "Read more" }
```

## 2. `textarea` — multi-line text

Serialises as a **string** (may contain `\n`).

```json
{ "meta": "First line\nSecond line" }
```

## 3. `editor` — HTML / code editor

Serialises as an **HTML string**.

```json
{ "content": "<p>Paragraph with <strong>bold</strong> and <a href=\"#\">a link</a>.</p>" }
{ "css": ".el-element { border-radius: 8px; }" }
```

The element `css` and `attributes` fields are always strings.

## 4. `checkbox` — boolean

Serialises as a **boolean** `true` or `false`.

```json
{ "slideshow_autoplay": true }
{ "grid_divider": false }
```

## 5. `select` — option select

Serialises as the **string value** of the option (never its label).

```json
{ "style": "primary" }        // not "Primary"
{ "title_element": "h2" }
```

When the default (empty) option is selected:

```json
{ "style": "" }               // empty string, never null
```

## 6. `radio` / `select-img` — option group

Serialises as a **string**, same as `select`.

```json
{ "image_align": "top" }
{ "text_align": "center" }
```

## 7. `number` — number

Prefer a **numeric string**. Real exports contain both forms for some fields; strings are always
accepted.

```json
{ "image_height": "300" }
{ "zoom": "14" }
```

## 8. `range` — numeric slider

Serialises like `number`.

```json
{ "slideshow_min_height": 300 }
{ "parallax_opacity_start": "0.8" }
```

## 9. `color` — colour picker

Serialises as a **hex or rgba string**.

```json
{ "media_overlay": "rgba(0,0,0,0.5)" }
{ "media_background": "#f5f5f5" }
```

A colour field never holds a CSS function such as `linear-gradient()` — gradients have their own
fields (e.g. `media_overlay_gradient`).

## 10. `image` — image picker

Serialises as a **plain string**: the path or URL. Alt text lives in a separate `*_alt` prop.

```json
{ "image": "wp-content/uploads/2024/01/photo.jpg", "image_alt": "Image description" }
{ "image": "" }
```

## 11. `video` — video picker

Serialises as a **plain string** (file path or YouTube/Vimeo URL).

```json
{ "video": "https://www.youtube.com/watch?v=VIDEO_ID" }
{ "video": "wp-content/uploads/video.mp4" }
```

## 12. `link` — link picker

Serialises as a **plain string** (URL, relative path or `#anchor`). Link text, target and ARIA
label live in separate props (`link_text`, `link_target`, `link_aria_label`, …).

```json
{ "link": "contact/", "link_text": "Contact us" }
{ "link": "https://example.com", "link_target": true }
```

## 13. `icon` — UIkit icon picker

Serialises as a **string** with the UIkit icon name.

```json
{ "icon": "arrow-right" }
{ "icon": "" }
```

## 14. `font` — font picker

Serialises as a **string** with the font name.

```json
{ "font": "Roboto" }
```

## 15. `location` — map location

Serialises as a **string** `"lat, lng"`.

```json
{ "location": "45.4642, 9.1900" }
```

## Item lists are child nodes

Multi-item elements (`grid`, `accordion`, `slideshow`, `button`, …) store their items as **child
nodes** in `children`, never as an array inside `props`:

```json
{
  "type": "grid",
  "props": { "grid_default": "1", "grid_medium": "3" },
  "children": [
    { "type": "grid_item", "props": { "title": "Item 1", "content": "<p>Text…</p>", "image": "img1.jpg", "link": "#" } },
    { "type": "grid_item", "props": { "title": "Item 2", "content": "<p>Text…</p>", "image": "img2.jpg", "link": "#" } }
  ]
}
```

## Quick summary

| Field type | JSON serialisation | Example value |
|---|---|---|
| text | string | `"Title"` |
| textarea | string | `"First\nSecond"` |
| editor | HTML string | `"<p>Text</p>"` |
| checkbox | boolean | `true` / `false` |
| select / radio | string | `"primary"` |
| number / range | numeric string (preferred) | `"2"` |
| color | string | `"rgba(0,0,0,0.5)"` |
| image | string | `"wp-content/uploads/img.jpg"` |
| video | string | `"https://youtu.be/…"` |
| link | string | `"contact/"` |
| icon | string | `"home"` |
| font | string | `"Roboto"` |
| location | string | `"45.4, 9.1"` |

## Common mistakes

- ❌ `"hover": 1` → ✅ `"hover": true` (checkbox is boolean)
- ❌ `"image": {"src": "/img.jpg", "alt": ""}` → ✅ `"image": "img.jpg"` + `"image_alt": ""`
- ❌ `"link": {"url": "#", "text": "", "target": ""}` → ✅ `"link": "#"` + `"link_text": ""`
- ❌ `"items": [...]` inside `props` → ✅ item nodes in `children`
- ❌ `"type": "builder_grid"` → ✅ `"type": "grid"`
- ❌ `"icon": null` → ✅ `"icon": ""` (never null, use an empty string)
