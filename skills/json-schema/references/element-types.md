# YOOtheme Pro Builder — Complete Element Reference

> Source of truth: `packages/builder/elements/{type}/element.php` in the YOOtheme Pro theme.
> All enum values are extracted directly from the PHP source.
>
> Leaf nodes in the examples below carry no `children` key — see `SKILL.md`. Wiki references
> point to `../../builder/wiki/` (relative to this file).

---

## ⚠️ RULE — always prefer native elements

**Do NOT use `html` or raw HTML in `content` when a native element exists.**

| Requested pattern | Native element |
|---|---|
| Card with image / title / text / link | `panel` |
| Grid of cards | `grid` + `grid_item` |
| Photo grid with hover overlay | `overlay-slider` o `gallery` |
| Expandable FAQ | `accordion` + `accordion_item` |
| Tabs with switching content | `switcher` + `switcher_item` |
| List of items (with icon, link, image) | `list` + `list_item` |
| Price menu / glossary / dt-dd | `description_list` + `description_list_item` |
| Social links (Instagram, Facebook, …) | `social` + `social_item` |
| Video player (mp4, youtube, vimeo) | `video` |
| Map with markers | `map` + `map_item` |
| Countdown timer | `countdown` |
| Quote / testimonial | `quotation` |
| Notice box / banner | `alert` |
| Standalone icon | `icon` |
| Data table | `table` + `table_item` |
| Vertical navigation / sidebar nav | `nav` + `nav_item` |
| Horizontal subnav / breadcrumb-style | `subnav` + `subnav_item` |
| Full-screen hero image slider | `slideshow` + `slideshow_item` |
| Card / news slider | `panel-slider` + `panel-slider_item` |
| Clickable image with overlay | `overlay` |
| Button / button group | `button` + `button_item` |
| Source code / snippet | `code` |
| **Custom raw HTML** | `html` (**last resort — only if no other element works**) |

---

## Global props — present on every element

| Prop | Values | Note |
|---|---|---|
| `margin_top` | `''` `'xsmall'` `'small'` `'default'` `'medium'` `'large'` `'xlarge'` `'remove'` `'auto'` | `'auto'` pushes the element to the bottom of the column — aligns card links on a shared baseline |
| `margin_bottom` | same | |
| `text_align` | `''` `'left'` `'center'` `'right'` `'justify'` | |
| `text_align_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | Breakpoint from which it applies |
| `text_align_fallback` | `''` `'left'` `'center'` `'right'` `'justify'` | Value below the breakpoint |
| `block_align` | `''` `'left'` `'center'` `'right'` | Auto margins |
| `block_align_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | |
| `block_align_fallback` | `''` `'left'` `'center'` `'right'` | |
| `maxwidth` | `''` `'small'` `'medium'` `'large'` `'xlarge'` `'2xlarge'` | |
| `maxwidth_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | |
| `animation` | see the animations skill | Scrollspy animation |
| `visibility` | `''` `'s'` `'m'` `'l'` `'xl'` `'hidden-s'` `'hidden-m'` `'hidden-l'` `'hidden-xl'` | |
| `class` | string | Extra CSS classes |
| `css` | CSS string | CSS scoped to the element |
| `position` | `''` `'relative'` `'absolute'` | `'relative'` offsets the element while keeping it in the flow |
| `position_top/bottom/left/right` | string (e.g. `"50%"`, `"5vh"`) | |
| `position_z_index` | numeric string | |
| `image_loading` | bool | Checkbox "Load image eagerly": `true` = **eager** loading (for images in the initial viewport, e.g. a hero). Default: lazy |

---

## 1. Structural elements

### `section`
Full-width container with background, padding, height and image.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `style` | `''` `'default'` `'muted'` `'primary'` `'secondary'` | `'default'` |
| `padding_top` | `'xsmall'` `'small'` `''` `'large'` `'xlarge'` `'none'` | `''` |
| `padding_bottom` | same | `''` |
| `width` | `'default'` `'xsmall'` `'small'` `'large'` `'xlarge'` `'expand'` `''` | `'default'` |
| `height` | `''` `'pixels'` `'viewport'` `'section'` `'page'` | `''` |
| `height_viewport` | number | |
| `height_viewport_offset` | bool | |
| `vertical_align` | `''` `'middle'` `'bottom'` | `'middle'` |
| `text_color` | `''` `'light'` `'dark'` | |
| `image` | path string | |
| `image_size` | `''` `'cover'` `'contain'` `'width-1-1'` `'height-1-1'` | |
| `image_position` | `'center-center'` `'top-left'` `'top-center'` ... | `'center-center'` |
| `image_effect` | `''` `'parallax'` `'fixed'` | |
| `media_overlay` | **flat colour** (`rgba(...)`/hex), string — ⚠️ **NEVER a `linear-gradient()` function here**, see the note below | |
| `media_overlay_gradient` | real CSS gradient (`linear-gradient(...)`), string — separate field, hidden in the UI | |
| `media_background` | colour string | |
| `media_blend_mode` | `''` `'multiply'` `'screen'` `'overlay'` `'darken'` `'lighten'` `'color-dodge'` `'color-burn'` `'hard-light'` `'soft-light'` `'difference'` `'exclusion'` `'hue'` `'saturation'` `'color'` `'luminosity'` — inert without `media_background` | |
| `media_focal_point` | 9 positions, `''` = centre | |
| `media_visibility` | `''` `'s'` `'m'` `'l'` `'xl'` | |
| `preserve_color` | bool | |
| `header_transparent` | bool | |
| `sticky` | `''` `'cover'` `'reveal'` | |
| `animation` | scrollspy animation value | |
| `animation_delay` | string (ms) | |

```json
{
  "type": "section",
  "props": {
    "style": "default",
    "padding_top": "large",
    "padding_bottom": "large",
    "width": "default"
  },
  "children": []
}
```

⚠️ **`media_overlay` gotcha** (see `issues/media-overlay-gradient-string.md`): the template renders
`background-color: {media_overlay}` and `background-image: {media_overlay_gradient}`
(`elements/section/templates/template.php:144-152`) — they are **two separate fields**. For a
simple dark overlay: `"media_overlay": "rgba(0, 0, 0, 0.4)"`. For a real CSS gradient, the
`linear-gradient(...)` value goes in `"media_overlay_gradient"`, not in `media_overlay`. Confirmed
across all 77 official demo pages: `media_overlay` only ever holds a flat colour. Details →
`props/media.md`.

---

### `row`
Grid of columns.

⚠️ **Does not declare `name`** — unlike 48 of the 51 builder element types, `row` has no `name`
field in its `fields` (`row/element.php:359-362`). Do not add it here: see `props/advanced-group.md`.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `layout` | `'1-2,1-2'` `'1-3,1-3,1-3'` etc. — responsive with `\|` e.g. `'1-4,1-4,1-4,1-4\|1-2,1-2'` — ⚠️ **not enough on its own**: see `column.width_*` | `''` |
| `column_gap` | `'small'` `'medium'` `''` `'large'` `'collapse'` | `''` |
| `row_gap` | same | `''` |
| `divider` | bool | |
| `alignment` | `''` `'left'` `'center'` `'right'` | |
| `width` | `'default'` `'xsmall'` `'small'` `'large'` `'xlarge'` `'expand'` `''` | |
| `height` | `''` `'pixels'` `'viewport'` | |
| `margin_top` | `''` `'xsmall'` `'small'` `'default'` `'medium'` `'large'` `'xlarge'` `'remove'` `'auto'` | |
| `margin_bottom` | same | |

⚠️ **`layout` is editor metadata only.** The frontend reads widths from the child columns'
`width_*` (fallback `uk-width-1-1` = columns stacked at full width). Every fractional `layout` must
therefore be repeated as `width_medium` on each column (plus `width_small`/… for every extra `|`
level). See `issues/column-width-props.md` — reproduced on real imports on 2026-09-08 and 2026-10-01.

```json
{
  "type": "row",
  "props": {
    "layout": "1-2,1-2",
    "column_gap": "medium"
  },
  "children": [
    {
      "type": "column",
      "props": {
        "width_medium": "1-2"
      },
      "children": []
    },
    {
      "type": "column",
      "props": {
        "width_medium": "1-2"
      },
      "children": []
    }
  ]
}
```

---

### `column`
A column of a row. The rendered width is that of its `width_*` (`child-prop` fields edited from the
row's *Column Layout* panel, but **stored on the column**). Without `width_*` the column is
`uk-width-1-1`, even if the row has `layout: "1-2,1-2"`.

⚠️ **Does not declare `name`** (nor `status`/`transform`) — `column/element.php:258-261` does not
include it. Do not add it here: see `props/advanced-group.md`.

**Key props:**
| Prop | Values |
|---|---|
| `vertical_align` | `''` `'top'` `'middle'` `'bottom'` |
| `width_default` | valid fraction, width below `@s` (e.g. `'1-1'`) |
| `width_small` | fraction `@s` |
| `width_medium` | fraction `@m` — **required** when the row has a fractional `layout` (same fraction) |
| `width_large` / `width_xlarge` | fraction `@l` / `@xl` |
| `image` | path string (column background) |
| `media_overlay` | flat colour |
| `media_background` | colour |

```json
{
  "type": "column",
  "props": {
    "vertical_align": "middle",
    "width_medium": "1-2"
  },
  "children": []
}
```

---

### `fragment`
Row container with no visual semantics — groups several rows inside a column.

```json
{
  "type": "fragment",
  "props": {
    "margin_top": "",
    "margin_bottom": ""
  },
  "children": []
}
```

---

## 2. Text and basic media

### `headline`
Heading with text, style, decoration and an optional inline icon/image.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `content` | HTML string | |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h1'` |
| `title_style` | `''` `'heading-3xlarge'` `'heading-2xlarge'` `'heading-xlarge'` `'heading-large'` `'heading-medium'` `'heading-small'` `'h1'`–`'h6'` `'text-meta'` `'text-lead'` `'text-small'` `'text-large'` | `''` |
| `title_color` | `''` `'muted'` `'emphasis'` `'primary'` `'secondary'` `'success'` `'warning'` `'danger'` `'background'` | |
| `title_decoration` | `''` `'divider'` `'bullet'` `'line'` | |
| `title_font_family` | `''` `'default'` `'primary'` `'secondary'` `'tertiary'` | |
| `title_text_stroke` | bool | |
| `link` | URL string | |
| `link_style` | bool (checkbox — applies link styling to the heading) | |
| `image` | path string | |
| `image_align` | `'left'` `'right'` | `'left'` |
| `image_margin` | `''` `'xsmall'` `'small'` `'medium'` | `'xsmall'` |
| `icon` | UIkit icon name | |

```json
{
  "type": "headline",
  "props": {
    "content": "Main headline",
    "title_element": "h2",
    "title_style": "heading-medium",
    "title_color": "emphasis"
  }
}
```

---

### `text`
HTML paragraph with style and optional multi-column.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `content` | HTML | |
| `text_style` | `''` `'meta'` `'lead'` `'small'` `'large'` | |
| `text_color` | `''` `'muted'` `'emphasis'` `'primary'` `'secondary'` `'success'` `'warning'` `'danger'` | |
| `dropcap` | bool | |
| `column` | `''` `'1-2'` `'1-3'` `'1-4'` `'1-5'` `'1-6'` | |
| `column_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'m'` |
| `html_element` | `''` `'address'` `'aside'` `'footer'` | |

```json
{
  "type": "text",
  "props": {
    "content": "<p>Paragraph text.</p>",
    "text_style": "lead"
  }
}
```

---

### `image`
Standalone image with link, lightbox, border, shadow.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `image` | path string | |
| `image_alt` | string | |
| `image_width` | number | |
| `image_height` | number | |
| `image_focal_point` | `'top-left'` `'top-center'` `'top-right'` `'center-left'` `''` `'center-right'` `'bottom-left'` `'bottom-center'` `'bottom-right'` | |
| `image_border` | `''` `'rounded'` `'circle'` `'pill'` | |
| `image_box_shadow` | `''` `'small'` `'medium'` `'large'` `'xlarge'` | |
| `image_box_decoration` | `''` `'default'` `'primary'` `'secondary'` `'shadow'` `'mask'` | |
| `image_svg_inline` | bool | |
| `image_svg_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | `'emphasis'` |
| `link` | URL string | |
| `lightbox` | bool | |
| `height_viewport` | bool | |

```json
{
  "type": "image",
  "props": {
    "image": "wp-content/uploads/photo.jpg",
    "image_alt": "Description",
    "image_border": "rounded",
    "image_box_shadow": "medium"
  }
}
```

---

### `icon`
Standalone UIkit icon with optional link.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `icon` | UIkit icon name (e.g. `'star'`, `'check'`) | |
| `icon_color` | `''` `'muted'` `'emphasis'` `'primary'` `'secondary'` `'success'` `'warning'` `'danger'` | |
| `icon_width` | number | `60` |
| `link` | URL string | |
| `link_style` | `''` `'button'` `'link'` `'muted'` `'text'` `'reset'` | |

```json
{
  "type": "icon",
  "props": {
    "icon": "star",
    "icon_color": "primary",
    "icon_width": 48
  }
}
```

---

### `divider`
Horizontal or vertical separator.

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `divider_style` | `''` `'icon'` `'small'` `'vertical'` | |
| `divider_element` | `'hr'` `'div'` | `'hr'` |
| `divider_align` | `''` `'left'` `'center'` `'right'` | |

```json
{
  "type": "divider",
  "props": {
    "divider_style": "",
    "margin_top": "medium",
    "margin_bottom": "medium"
  }
}
```

---

### `code`
Source code block with syntax highlighting.

**Props:** only `content` (code string).

```json
{
  "type": "code",
  "props": {
    "content": "console.log('hello');"
  }
}
```

---

### `html` ⚠️ LAST RESORT
Raw HTML. **Use only if no native element covers the case.**

**Props:** only `content` (HTML string).

```json
{
  "type": "html",
  "props": {
    "content": "<div class='custom'>...</div>"
  }
}
```

---

## 3. Interactive UI

### `button` + `button_item`
Button group.

**`button` props:**
| Prop | Values | Default |
|---|---|---|
| `button_size` | `'small'` `''` `'large'` | |
| `grid_column_gap` | `'small'` `'medium'` `''` `'large'` `'collapse'` | `'small'` |
| `grid_row_gap` | same | `'small'` |
| `fullwidth` | bool | |

**`button_item` props:**
| Prop | Values | Default |
|---|---|---|
| `content` | string — **NOT `title`** | |
| `button_style` | `'default'` `'primary'` `'secondary'` `'danger'` `'text'` `''` `'link-muted'` `'link-text'` | `'default'` |
| `link` | URL string | |
| `icon` | icon name | |
| `icon_align` | `'left'` `'right'` | `'left'` |
| `dialog` | HTML (dialog content) | |
| `dialog_layout` | `'modal'` `'offcanvas'` | `'modal'` |

```json
{
  "type": "button",
  "props": {
    "grid_column_gap": "small"
  },
  "children": [
    {
      "type": "button_item",
      "props": {
        "content": "Learn more",
        "link": "/page",
        "button_style": "primary"
      }
    }
  ]
}
```

---

### `accordion` + `accordion_item`
Expandable panels. **Use for FAQs and collapsible content.**

**`accordion` props:**
| Prop | Values | Default |
|---|---|---|
| `multiple` | bool — several panels open at once | |
| `collapsible` | bool — an open panel can be closed again | `true` |
| `show_image` | bool | `true` |
| `show_link` | bool | `true` |
| `content_style` | `''` `'lead'` `'meta'` | |
| `image_align` | `'top'` `'bottom'` `'left'` `'right'` | `'top'` |
| `image_svg_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | `'emphasis'` |
| `link_text` | string | `'Read more'` |
| `link_style` | `'default'` `'primary'` `'secondary'` `'danger'` `'text'` `''` `'link-muted'` `'link-text'` | `'default'` |

**`accordion_item` props:** `title`, `content` (editor), `image`, `link`, `link_text`

```json
{
  "type": "accordion",
  "props": {
    "collapsible": true,
    "multiple": false
  },
  "children": [
    {
      "type": "accordion_item",
      "props": {
        "title": "Question?",
        "content": "<p>Answer to the question.</p>"
      }
    }
  ]
}
```

---

### `alert`
Notice box / coloured message.

**Props:**
| Prop | Values | Default |
|---|---|---|
| `title` | string | |
| `content` | HTML | |
| `link` | URL string | |
| `alert_style` | `''` `'primary'` `'success'` `'warning'` `'danger'` | |
| `alert_size` | bool (large) | |
| `title_style` | `''` `'text-bold'` `'heading-small'` `'h1'`–`'h6'` | |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `content_style` | `''` `'lead'` `'meta'` | |

```json
{
  "type": "alert",
  "props": {
    "title": "Warning",
    "content": "<p>Important message.</p>",
    "alert_style": "warning"
  }
}
```

---

### `quotation`
Quote / testimonial with author and footer.

**Props:**
| Prop | Values |
|---|---|
| `content` | HTML (quote text) |
| `author` | string |
| `footer` | string |
| `link` | URL string |
| `link_style` | `''` `'muted'` `'text'` `'reset'` |

```json
{
  "type": "quotation",
  "props": {
    "content": "<p>Excellent, professional service.</p>",
    "author": "Jane Doe",
    "footer": "Client since 2022"
  }
}
```

---

### `countdown`
Countdown timer to a date.

**Props:**
| Prop | Values | Default |
|---|---|---|
| `date` | ISO 8601 string | |
| `show_label` | bool | `true` |
| `show_separator` | bool | `true` |
| `reload` | bool (reloads the page when it expires) | |
| `countdown_style` | `''` `'text-meta'` `'text-lead'` `'text-small'` `'text-large'` `'heading-3xlarge'` `'heading-2xlarge'` `'heading-xlarge'` `'heading-large'` `'heading-medium'` `'heading-small'` `'h1'`–`'h6'` | `'heading-medium'` |
| `countdown_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | |
| `label_style` | same values as `countdown_style` | |
| `label_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | |
| `label_margin` | `'xsmall'` `'small'` `''` `'medium'` `'remove'` | `'small'` |
| `grid_column_gap` | `'small'` `'medium'` `''` `'large'` `'collapse'` | `'small'` |

```json
{
  "type": "countdown",
  "props": {
    "date": "2025-12-31T00:00:00",
    "countdown_style": "heading-large",
    "show_label": true
  }
}
```

---

## 4. Cards and display

### `panel`
Single card with image, title, meta, content, link, icon.
**Use for every standalone card.**

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `title` | string | |
| `meta` | string | |
| `content` | HTML | |
| `image` | path string | |
| `icon` | icon name | |
| `link` | URL string | |
| `link_text` | string | `'Read more'` |
| `link_style` | `'default'` `'primary'` `'secondary'` `'danger'` `'text'` `''` `'link-muted'` `'link-text'` | `'default'` |
| `panel_style` | `''` `'card-default'` `'card-primary'` `'card-secondary'` `'card-hover'` `'card-overlay'` `'tile-default'` `'tile-muted'` `'tile-primary'` `'tile-secondary'` | |
| `panel_link` | bool (whole panel clickable) | |
| `panel_link_hover` | bool (hover effect on the link) | |
| `panel_padding` | `''` `'small'` `'default'` `'large'` | |
| `panel_image_no_padding` | bool | |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `title_style` | see headline.title_style | |
| `title_color` | see headline.title_color | |
| `title_align` | `'top'` `'left'` | `'top'` |
| `title_hover_style` | `'reset'` `'heading'` `''` | `'reset'` |
| `meta_style` | `''` `'text-meta'` `'text-lead'` `'text-small'` `'text-large'` `'h1'`–`'h6'` | `'text-meta'` |
| `meta_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | |
| `meta_align` | `'above-title'` `'below-title'` `'above-content'` `'below-content'` | `'below-title'` |
| `meta_element` | `'h1'`–`'h6'` `'div'` | `'div'` |
| `image_align` | `'top'` `'bottom'` `'left'` `'right'` `'between'` | `'top'` |
| `image_grid_width` | `'auto'` `'4-5'` `'3-4'` `'2-3'` `'3-5'` `'1-2'` `'2-5'` `'1-3'` `'1-4'` `'1-5'` `'small'` `'medium'` `'large'` `'xlarge'` `'2xlarge'` | `'1-2'` |
| `image_grid_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'m'` |
| `image_border` | `''` `'rounded'` `'circle'` `'pill'` | |
| `image_box_shadow` | `''` `'small'` `'medium'` `'large'` `'xlarge'` | |
| `image_box_decoration` | `''` `'default'` `'primary'` `'secondary'` `'shadow'` `'mask'` | |
| `image_svg_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | `'emphasis'` |
| `height_expand` | bool | |

```json
{
  "type": "panel",
  "props": {
    "title": "Card title",
    "meta": "Category",
    "content": "<p>Description del servizio.</p>",
    "image": "wp-content/uploads/photo.jpg",
    "link": "/service",
    "link_text": "Learn more",
    "link_style": "default",
    "panel_style": "card-default",
    "panel_padding": "default",
    "panel_link": true,
    "title_element": "h3",
    "image_align": "top",
    "meta_align": "below-title"
  }
}
```

---

### `overlay`
Single image with overlay (text on hover or static).

**Key props:**
| Prop | Values | Default |
|---|---|---|
| `image` | path string | |
| `image_alt` | string | |
| `title` | string | |
| `meta` | string | |
| `content` | HTML | |
| `link` | URL string | |
| `link_text` | string | `'Read more'` |
| `overlay_mode` | `'cover'` `'caption'` | `'cover'` |
| `overlay_hover` | bool | `true` |
| `overlay_style` | `''` `'overlay-default'` `'overlay-primary'` `'tile-default'` `'tile-muted'` `'tile-primary'` `'tile-secondary'` | `'overlay-primary'` |
| `overlay_position` | `'top'` `'bottom'` `'left'` `'right'` `'top-left'` `'top-center'` `'top-right'` `'bottom-left'` `'bottom-center'` `'bottom-right'` `'center'` `'center-left'` `'center-right'` | `'center'` |
| `overlay_padding` | `''` `'small'` `'large'` `'none'` | |
| `overlay_transition` | `'fade'` `'scale-up'` `'scale-down'` `'slide-top-small'` `'slide-bottom-small'` `'slide-left-small'` `'slide-right-small'` `'slide-top'` `'slide-bottom'` `'slide-left'` `'slide-right'` | `'fade'` |
| `overlay_transition_background` | bool | |
| `text_color` | `''` `'light'` `'dark'` | `'light'` |
| `image_min_height` | number (200–500) | |
| `image_transition` | `''` `'scale-up'` `'scale-down'` | |
| `image_border` | `''` `'rounded'` `'circle'` `'pill'` | |
| `image_box_shadow` | `''` `'small'` `'medium'` `'large'` `'xlarge'` | |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `title_style` | see headline.title_style | |

```json
{
  "type": "overlay",
  "props": {
    "image": "wp-content/uploads/photo.jpg",
    "title": "Title",
    "title_element": "h3",
    "link": "#",
    "link_text": "Discover",
    "overlay_mode": "cover",
    "overlay_position": "center",
    "overlay_style": "overlay-default",
    "overlay_hover": true,
    "overlay_transition": "fade",
    "text_color": "light"
  }
}
```

---

## 5. Grids and lists

### `grid` + `grid_item`
Multi-item grid with cards, panels, filters, lightbox.

**`grid` props chiave:**
| Prop | Values | Default |
|---|---|---|
| `grid_default` | `'1'` `'2'` `'3'` `'4'` `'5'` `'6'` `'auto'` | `'1'` |
| `grid_small` | `''` + same values | |
| `grid_medium` | `''` + same values | `'3'` |
| `grid_large` | `''` + same values | |
| `grid_xlarge` | `''` + same values | |
| `grid_column_gap` | `'small'` `'medium'` `''` `'large'` `'collapse'` | |
| `grid_row_gap` | same | |
| `grid_divider` | bool | |
| `panel_style` | `''` `'card-default'` `'card-primary'` `'card-secondary'` `'card-hover'` `'card-overlay'` `'tile-default'` `'tile-muted'` `'tile-primary'` `'tile-secondary'` `'tile-checked'` | `'tile-checked'` is `grid`-only: alternates `uk-tile-default`/`uk-tile-muted` across items (the only panel style that loads JavaScript) |
| `panel_link` | bool | |
| `panel_link_hover` | bool | |
| `panel_padding` | `''` `'small'` `'default'` `'large'` | |
| `panel_image_no_padding` | bool | |
| `show_title` `show_meta` `show_content` `show_image` `show_video` `show_hover_image` `show_hover_video` `show_link` | bool | `true` |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `title_style` | see headline.title_style | |
| `title_color` | see headline.title_color | |
| `title_align` | `'top'` `'left'` | `'top'` |
| `meta_style` | `''` `'text-meta'` `'text-lead'` ... | `'text-meta'` |
| `meta_align` | `'above-title'` `'below-title'` `'above-content'` `'below-content'` | `'below-title'` |
| `meta_element` | `'h1'`–`'h6'` `'div'` | `'div'` |
| `image_align` | `'top'` `'bottom'` `'left'` `'right'` `'between'` | `'top'` |
| `image_grid_width` | `'auto'` `'4-5'` ... `'1-5'` `'small'` `'medium'` `'large'` `'xlarge'` `'2xlarge'` | `'1-2'` |
| `image_grid_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'m'` |
| `image_border` | `''` `'rounded'` `'circle'` `'pill'` | |
| `image_box_shadow` | `''` `'small'` `'medium'` `'large'` `'xlarge'` | |
| `image_transition` | `''` `'scale-up'` `'scale-down'` | |
| `image_svg_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | `'emphasis'` |
| `item_animation` | bool | `true` |
| `item_maxwidth` | `''` `'small'` `'medium'` `'large'` `'xlarge'` `'2xlarge'` | |
| `filter` | bool | |
| `filter_style` | `'tab'` `'subnav'` `'subnav-divider'` `'subnav-pill'` | `'tab'` |
| `filter_all` | bool | `true` |
| `filter_position` | `'top'` `'left'` `'right'` | `'top'` |
| `lightbox` | bool | |
| `lightbox_bg_close` | bool | `true` |

**`grid_item` props:** `title`, `meta`, `content`, `image` (path), `icon`, `link`, `link_text`, `tags` (for filters), `panel_style` (per-item override)

```json
{
  "type": "grid",
  "props": {
    "grid_default": "1",
    "grid_small": "2",
    "grid_medium": "3",
    "grid_column_gap": "medium",
    "grid_row_gap": "medium",
    "panel_style": "card-default",
    "show_image": true,
    "show_title": true,
    "show_content": true,
    "title_element": "h3",
    "image_align": "top",
    "item_animation": true
  },
  "children": [
    {
      "type": "grid_item",
      "props": {
        "image": "wp-content/uploads/photo.jpg",
        "title": "Title",
        "content": "<p>Description.</p>",
        "link": "#"
      }
    }
  ]
}
```

---

### `gallery` + `gallery_item`
Photo grid with overlay, tag filters, lightbox.

**`gallery` props chiave:** same grid columns + filter + lightbox + overlay, plus:
| Prop | Values | Default |
|---|---|---|
| `overlay_mode` | `'cover'` `'caption'` | `'cover'` |
| `overlay_hover` | bool | `true` |
| `overlay_style` | `''` `'overlay-default'` `'overlay-primary'` `'tile-default'` `'tile-muted'` `'tile-primary'` `'tile-secondary'` | `'overlay-primary'` |
| `overlay_position` | top/bottom/left/right/center variants | `'center'` |
| `overlay_transition` | fade/scale/slide variants | `'fade'` |
| `text_color` | `''` `'light'` `'dark'` | `'light'` |
| `image_min_height` | number (200–500) | |
| `image_transition` | `''` `'scale-up'` `'scale-down'` | |

**`gallery_item` props:** `image` (path), `video`, `image_alt`, `title`, `meta`, `content`, `link`, `tags` (for filters), `hover_image`

```json
{
  "type": "gallery",
  "props": {
    "grid_default": "2",
    "grid_medium": "3",
    "overlay_mode": "cover",
    "overlay_hover": true,
    "overlay_style": "overlay-primary",
    "text_color": "light",
    "filter": false,
    "lightbox": false,
    "item_animation": true
  },
  "children": [
    {
      "type": "gallery_item",
      "props": {
        "image": "wp-content/uploads/photo.jpg",
        "image_alt": "Alt text",
        "title": "Title",
        "tags": "category-1"
      }
    }
  ]
}
```

---

### `list` + `list_item`
Vertical/horizontal list with icon, image and link.
**Use for: feature lists, links, services, styled bullet points.**

**`list` props:**
| Prop | Values | Default |
|---|---|---|
| `list_element` | `'ul'` `'ol'` | `'ul'` |
| `list_type` | `'vertical'` `'horizontal'` | `'vertical'` |
| `list_marker` | `''` `'disc'` `'circle'` `'square'` `'decimal'` `'hyphen'` `'bullet'` | |
| `list_marker_color` | `''` `'muted'` `'emphasis'` `'primary'` `'secondary'` | |
| `list_style` | `''` `'divider'` `'striped'` | |
| `list_size` | `''` `'large'` `'collapse'` | |
| `show_image` | bool | `true` |
| `show_link` | bool | `true` |
| `image_align` | `'left'` `'right'` | `'left'` |
| `image_vertical_align` | bool | `true` |
| `image_svg_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | `'emphasis'` |
| `icon` | icon name (global for all items) | |
| `link_style` | `''` `'muted'` `'text'` `'heading'` `'reset'` | |
| `column` | `''` `'1-2'` `'1-3'` `'1-4'` `'1-5'` `'1-6'` | |

**`list_item` props:** `content` (HTML), `image` (path), `icon` (per-item override), `link`

```json
{
  "type": "list",
  "props": {
    "list_element": "ul",
    "list_type": "vertical",
    "list_marker": "bullet",
    "list_marker_color": "primary",
    "show_image": false,
    "show_link": true
  },
  "children": [
    {
      "type": "list_item",
      "props": {
        "content": "Key feature",
        "link": "#"
      }
    }
  ]
}
```

---

### `description_list` + `description_list_item`
dt-dd list with title, price/meta, description.
**Use for: restaurant menus, glossaries, price lists, technical specs.**

**`description_list` props:**
| Prop | Values | Default |
|---|---|---|
| `layout` | `'grid-2'` `'grid-2-m'` `'stacked'` | `'grid-2'` |
| `list_style` | `''` `'divider'` `'striped'` | |
| `list_size` | `''` `'large'` `'collapse'` | |
| `show_title` `show_meta` `show_content` `show_link` | bool | `true` |
| `title_style` | `''` `'text-bold'` `'text-meta'` `'text-lead'` `'text-small'` `'text-large'` `'heading-small'` `'h1'`–`'h6'` | |
| `title_leader` | bool (adds a dotted leader between title and meta) | |
| `title_colon` | bool | |
| `meta_style` | `''` `'text-meta'` `'text-lead'` ... | `'text-meta'` |
| `meta_color` | `''` `'muted'` `'emphasis'` `'primary'` ... | |
| `meta_align` | `'above-title'` `'below-title'` `'above-content'` `'below-content'` | `'below-content'` |

**`description_list_item` props:** `title`, `meta`, `content` (HTML), `link`

```json
{
  "type": "description_list",
  "props": {
    "layout": "grid-2-m",
    "list_size": "large",
    "title_leader": true,
    "meta_color": "primary",
    "meta_align": "above-content",
    "show_title": true,
    "show_meta": true,
    "show_content": true
  },
  "children": [
    {
      "type": "description_list_item",
      "props": {
        "title": "Carbonara",
        "meta": "€ 12.50",
        "content": "Cured pork, pecorino, eggs, black pepper."
      }
    }
  ]
}
```

---

## 6. Sliders and carousels

### `slideshow` + `slideshow_item`
Full-screen or fixed-height hero slideshow.

**`slideshow` props chiave:**
| Prop | Values | Default |
|---|---|---|
| `slideshow_animation` | `''` `'pull'` `'push'` `'fade'` `'scale'` | |
| `slideshow_autoplay` | bool | |
| `slideshow_autoplay_interval` | number 5–15 | |
| `slideshow_autoplay_pause` | bool | `true` |
| `slideshow_min_height` | number 200–800, step 50 | `300` |
| `slideshow_kenburns` | `''` `'alternate'` + positions | |
| `height_viewport` | `''` `'viewport'` `'section'` | |
| `height_viewport_offset` | bool | |
| `nav` | `''` `'dotnav'` `'thumbnav'` | `'dotnav'` |
| `nav_position` | `'top-left'` `'top-right'` `'center-left'` `'center-right'` `'bottom-left'` `'bottom-center'` `'bottom-right'` | `'bottom-center'` |
| `nav_align` | `'left'` `'center'` `'right'` | `'center'` |
| `nav_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'s'` |
| `slidenav` | `''` `'default'` `'outside'` `'top-left'` `'top-right'` `'center-left'` `'center-right'` ... | `'default'` |
| `slidenav_hover` | bool | |
| `slidenav_large` | bool | |
| `slidenav_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'s'` |
| `overlay_position` | variants | `'center-left'` |
| `overlay_animation` | `'parallax'` `'fade'` `'scale-up'` `'scale-down'` + slide variants | `'parallax'` |
| `overlay_style` | `''` `'overlay-default'` `'overlay-primary'` `'tile-default'` ... | |
| `show_title` `show_meta` `show_content` `show_link` | bool | `true` |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `title_style` | see headline.title_style | |
| `text_color` | `''` `'light'` `'dark'` | |
| `media_overlay` | flat colour | |
| `image_width` | number | |

**`slideshow_item` props:** `image` (path), `video`, `image_alt`, `title`, `meta`, `content`, `link`, `link_text`, `thumbnail`

```json
{
  "type": "slideshow",
  "props": {
    "slideshow_autoplay": true,
    "slideshow_autoplay_interval": 5,
    "slideshow_autoplay_pause": true,
    "height_viewport": "viewport",
    "height_viewport_offset": true,
    "nav": "dotnav",
    "nav_position": "bottom-center",
    "slidenav": "default",
    "overlay_position": "center",
    "overlay_animation": "parallax",
    "show_title": true,
    "show_content": true,
    "text_color": "light",
    "title_element": "h2",
    "title_style": "heading-2xlarge"
  },
  "children": [
    {
      "type": "slideshow_item",
      "props": {
        "image": "wp-content/uploads/hero.jpg",
        "title": "Slide title",
        "content": "<p>Descriptive subtitle</p>",
        "link": "/page"
      }
    }
  ]
}
```

---

### `panel-slider` + `panel-slider_item`
Slider of cards/panels with content (news, services, products).

**`panel-slider` props chiave:**
| Prop | Values | Default |
|---|---|---|
| `slider_width_default` | `'1-1'` `'5-6'` `'4-5'` `'3-5'` `'1-2'` `'1-3'` `'1-4'` `'1-5'` `'1-6'` | `'1-1'` |
| `slider_width_small` | `''` + same values | |
| `slider_width_medium` | `''` + same values | `'1-3'` |
| `slider_width_large` | `''` + same values | |
| `slider_width_xlarge` | `''` + same values | |
| `slider_gap` | `'small'` `'medium'` `'default'` `'large'` `''` | `'default'` |
| `slider_autoplay` | bool | |
| `slider_autoplay_interval` | number 5–15 | |
| `slider_autoplay_pause` | bool | `true` |
| `slider_finite` | bool | |
| `slider_sets` | bool | |
| `slider_center` | bool | |
| `nav` | `''` `'dotnav'` | `'dotnav'` |
| `nav_align` | `'left'` `'center'` `'right'` | `'center'` |
| `slidenav` | `''` `'default'` `'outside'` + positions | `'outside'` |
| `slidenav_hover` | bool | |
| `slidenav_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'xl'` |
| `panel_style` | see grid.panel_style | |
| `panel_link` | bool | |
| `panel_match` | bool (equalises heights) | `true` |
| `panel_padding` | `''` `'small'` `'default'` `'large'` | |
| `show_title` `show_meta` `show_content` `show_image` `show_link` | bool | `true` |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `image_align` | `'top'` `'bottom'` `'left'` `'right'` `'between'` | `'top'` |
| `image_grid_width` | see grid | `'1-2'` |
| `image_grid_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | `'m'` |

**`panel-slider_item` props:** `title`, `meta`, `content`, `image` (path), `icon`, `link`, `link_text`, `panel_style` (per-item override)

```json
{
  "type": "panel-slider",
  "props": {
    "slider_width_default": "4-5",
    "slider_width_medium": "1-2",
    "slider_width_large": "1-3",
    "slider_gap": "default",
    "slidenav": "outside",
    "panel_link": true,
    "panel_match": true,
    "show_title": true,
    "show_meta": true,
    "show_content": true,
    "title_element": "h3"
  },
  "children": [
    {
      "type": "panel-slider_item",
      "props": {
        "image": "wp-content/uploads/photo.jpg",
        "title": "Article",
        "meta": "23.09.2024",
        "content": "<p>Text preview...</p>",
        "link": "/article"
      }
    }
  ]
}
```

---

### `overlay-slider` + `overlay-slider_item`
Image slider with overlay (portfolio, Instagram-style grid).

**`overlay-slider` props chiave:**
| Prop | Values | Default |
|---|---|---|
| `slider_width_default` | `'1-1'` `'5-6'` `'4-5'` `'3-5'` `'1-2'` `'1-3'` `'1-4'` `'1-5'` `'1-6'` | `'1-1'` |
| `slider_width_medium` | `''` + same values | `'1-3'` |
| `slider_gap` | `'small'` `'medium'` `'default'` `'large'` `''` | `'default'` |
| `slider_autoplay` | bool | |
| `slider_center` | bool | |
| `nav` | `''` `'dotnav'` | `'dotnav'` |
| `nav_below` | bool | `true` |
| `slidenav` | `''` `'default'` `'outside'` + positions | `'default'` |
| `overlay_mode` | `'cover'` `'caption'` | `'cover'` |
| `overlay_display` | `''` `'hover'` `'active'` | |
| `overlay_active_first` | bool | |
| `overlay_style` | `''` `'overlay-default'` `'overlay-primary'` `'tile-default'` `'tile-muted'` `'tile-primary'` `'tile-secondary'` | |
| `overlay_position` | variants | `'center'` |
| `overlay_transition` | fade/scale/slide variants | `'fade'` |
| `text_color` | `''` `'light'` `'dark'` | |
| `show_title` `show_meta` `show_link` | bool | `true` |

**`overlay-slider_item` props:** `image` (path), `video`, `image_alt`, `title`, `meta`, `link`, `hover_image`, `text_color`

```json
{
  "type": "overlay-slider",
  "props": {
    "slider_width_default": "1-2",
    "slider_width_medium": "1-3",
    "slider_gap": "",
    "overlay_mode": "cover",
    "overlay_display": "hover",
    "overlay_transition": "fade",
    "text_color": "light",
    "nav": "dotnav",
    "nav_below": true,
    "show_title": false,
    "show_link": true
  },
  "children": [
    {
      "type": "overlay-slider_item",
      "props": {
        "image": "wp-content/uploads/photo.jpg",
        "link": "https://instagram.com/",
        "text_color": "light"
      }
    }
  ]
}
```

---

## 7. Navigation and tabs

### `nav` + `nav_item`
Vertical navigation (sidebar, dropdown nav).

**`nav` props:**
| Prop | Values | Default |
|---|---|---|
| `nav_style` | `'default'` `'primary'` `'secondary'` `'navbar-dropdown-nav'` | `'default'` |
| `nav_divider` | bool | |
| `nav_size` | `''` `'medium'` `'large'` `'xlarge'` | |
| `grid` | `'1'`–`'6'` (columns) | `'1'` |
| `grid_divider` | bool | |
| `grid_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | |
| `show_image` | bool | `true` |

**`nav_item` props:** `content` (text), `meta`, `icon`, `image` (path), `link`, `type` (`''` `'heading'` `'divider'`), `active`

```json
{
  "type": "nav",
  "props": {
    "nav_style": "primary",
    "nav_divider": true
  },
  "children": [
    {
      "type": "nav_item",
      "props": {
        "content": "Home",
        "link": "/",
        "active": true
      }
    },
    {
      "type": "nav_item",
      "props": {
        "content": "Services",
        "link": "/services"
      }
    }
  ]
}
```

---

### `subnav` + `subnav_item`
Compact horizontal navigation.

**`subnav` props:**
| Prop | Values | Default |
|---|---|---|
| `subnav_style` | `''` `'divider'` `'pill'` `'tab'` | |
| `subnav_wrap` | bool | |
| `show_image` | bool | `true` |

**`subnav_item` props:** `content` (text), `icon`, `image` (path), `link`, `active`

```json
{
  "type": "subnav",
  "props": {
    "subnav_style": "pill"
  },
  "children": [
    {
      "type": "subnav_item",
      "props": {
        "content": "All",
        "link": "#",
        "active": true
      }
    }
  ]
}
```

---

### `switcher` + `switcher_item`
Tabs with switching content. **Use for tabbed sections.**

**`switcher` props:**
| Prop | Values | Default |
|---|---|---|
| `nav` | `'tab'` `'subnav-pill'` `'subnav-divider'` `'subnav'` `'thumbnav'` | `'tab'` |
| `nav_position` | `'top'` `'bottom'` `'left'` `'right'` | `'top'` |
| `nav_align` | `'left'` `'right'` `'center'` `'justify'` | `'left'` |
| `switcher_animation` | `''` `'fade'` `'scale-up'` `'scale-down'` + slide variants | `'fade'` |
| `switcher_height` | bool (equalises panel heights) | `true` |
| `show_title` `show_meta` `show_content` `show_image` `show_link` | bool | `true` |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |
| `image_align` | `'top'` `'bottom'` `'left'` `'right'` | `'top'` |

**`switcher_item` props:** `title` (tab text), `label` (alternative label), `content` (HTML), `image` (path), `link`, `thumbnail`

```json
{
  "type": "switcher",
  "props": {
    "nav": "tab",
    "nav_position": "top",
    "nav_align": "left",
    "switcher_animation": "fade",
    "show_title": false,
    "show_content": true
  },
  "children": [
    {
      "type": "switcher_item",
      "props": {
        "title": "Tab 1",
        "content": "<p>First tab content.</p>"
      }
    }
  ]
}
```

---

## 8. Media and interactive

### `video`
Video player with poster, controls, autoplay.

**Props:**
| Prop | Values | Default |
|---|---|---|
| `video` | video URL or path string | |
| `video_title` | string | |
| `poster` | image path string | |
| `video_width` `video_height` | number | |
| `video_loading` | `''` `'lazy'` `'click'` | `'lazy'` |
| `video_autoplay` | `''` `'true'` `'inview'` `'hover'` | |
| `video_controls` | bool | `true` |
| `video_loop` | bool | |
| `video_muted` | bool | |
| `video_playsinline` | bool | |
| `video_border` | `''` `'rounded'` `'circle'` `'pill'` | |
| `video_box_shadow` | `''` `'small'` `'medium'` `'large'` `'xlarge'` | |
| `video_box_decoration` | `''` `'default'` `'primary'` `'secondary'` `'shadow'` `'mask'` | |
| `height_expand` | bool | |
| `height_viewport` | bool | |

```json
{
  "type": "video",
  "props": {
    "video": "wp-content/uploads/video.mp4",
    "poster": "wp-content/uploads/poster.jpg",
    "video_controls": true,
    "video_loading": "lazy",
    "video_border": "rounded"
  }
}
```

---

### `social` + `social_item`
Social links with UIkit icons or custom images.

**`social` props:**
| Prop | Values | Default |
|---|---|---|
| `link_style` | `''` `'button'` `'link'` `'muted'` `'text'` `'reset'` `'iconnav'` `'thumbnav'` | `'button'` |
| `grid` | `'horizontal'` `'vertical'` | `'horizontal'` |
| `grid_vertical_breakpoint` | `''` `'s'` `'m'` `'l'` `'xl'` | |
| `grid_column_gap` | `'small'` `'medium'` `''` `'large'` `'collapse'` | `'small'` |
| `image_width` `image_height` | number | |

**`social_item` props:** `link` (URL), `link_aria_label`, `icon` (UIkit name — UIkit ships brand icons), `image` (alternative path)

```json
{
  "type": "social",
  "props": {
    "link_style": "iconnav",
    "grid": "horizontal",
    "grid_column_gap": "small"
  },
  "children": [
    {
      "type": "social_item",
      "props": {
        "link": "https://instagram.com/yourprofile",
        "link_aria_label": "Instagram",
        "icon": "instagram"
      }
    }
  ]
}
```

---

### `map` + `map_item`
Map with markers and info popups.

**`map` props:**
| Prop | Values | Default |
|---|---|---|
| `type` | `'roadmap'` `'satellite'` | `'roadmap'` |
| `zoom` | number 0–18 | `10` |
| `fit_bounds` | bool (fits zoom to the markers) | |
| `controls` | bool | `true` |
| `poi` | bool (points of interest) | `false` |
| `zooming` | bool | `false` |
| `dragging` | bool | `false` |
| `width` `height` | number | |
| `height_viewport` | `''` `'viewport'` `'section'` | |
| `clustering` | bool | |
| `styler_hue` | hex colour | |
| `show_title` `show_meta` `show_content` `show_image` `show_link` | bool | `true` |

**`map_item` props:** `location` (string "lat, lng"), `title`, `meta`, `content` (HTML), `image` (path), `link`, `hide`, `show_popup`

```json
{
  "type": "map",
  "props": {
    "type": "roadmap",
    "zoom": 14,
    "controls": true,
    "height": 450,
    "show_title": true,
    "show_content": true
  },
  "children": [
    {
      "type": "map_item",
      "props": {
        "location": "44.6375, 10.9250",
        "title": "Head office",
        "content": "<p>1 Example Street, City</p>"
      }
    }
  ]
}
```

---

### `popover` + `popover_item`
Image with clickable markers that open popovers (e.g. hotspots on a map or photo).

**`popover` props:**
| Prop | Values | Default |
|---|---|---|
| `background_image` | path string | |
| `marker_color` | `''` `'light'` `'dark'` | |
| `drop_mode` | `'click'` `'hover'` | `'hover'` |
| `drop_position` | `'top-center'` `'bottom-center'` `'left-center'` `'right-center'` | `'top-center'` |
| `card_style` | `'default'` `'primary'` `'secondary'` `'overlay'` | `'default'` |
| `show_title` `show_content` `show_image` `show_link` | bool | `true` |
| `title_element` | `'h1'`–`'h6'` `'div'` | `'h3'` |

**`popover_item` props:** `title`, `meta`, `content`, `image` (path), `link`, `position_x` (0–100), `position_y` (0–100), `drop_position` (override)

```json
{
  "type": "popover",
  "props": {
    "background_image": "wp-content/uploads/floor-plan.jpg",
    "drop_mode": "hover",
    "card_style": "default"
  },
  "children": [
    {
      "type": "popover_item",
      "props": {
        "title": "Table 1",
        "content": "<p>Seats: 4</p>",
        "position_x": 35,
        "position_y": 60
      }
    }
  ]
}
```

---

## 9. Utilities

### `totop`
"Back to top" button with optional label.

**Props:** `title` (string), `title_style` (`''` `'small'` `'meta'`), global layout props.

```json
{
  "type": "totop",
  "props": {
    "title": "Back to top"
  }
}
```

---

### `table` + `table_item`
Data table with headers and styles.

**`table` props:**
| Prop | Values | Default |
|---|---|---|
| `table_style` | `''` `'divider'` `'striped'` | |
| `table_hover` | bool | |
| `table_justify` | bool | |
| `table_size` | `''` `'small'` `'large'` | |
| `table_responsive` | `'overflow'` `'responsive'` | `'overflow'` |
| `table_vertical_align` | bool | |
| `table_head_title` | string (title column header) | |
| `table_head_meta` | string | |
| `table_head_content` | string | |
| `table_head_image` | string | |
| `table_head_link` | string | |
| `table_width_title` | `''` `'shrink'` `'small'` `'medium'` | `'shrink'` |
| `table_width_meta` | same | `'shrink'` |
| `show_title` `show_meta` `show_content` `show_image` `show_link` | bool | `true` |

**`table_item` props:** `title`, `meta`, `content` (HTML), `image` (path), `link`, `link_text`

```json
{
  "type": "table",
  "props": {
    "table_style": "divider",
    "table_hover": true,
    "table_responsive": "overflow",
    "table_head_title": "Name",
    "table_head_meta": "Price",
    "table_head_content": "Description"
  },
  "children": [
    {
      "type": "table_item",
      "props": {
        "title": "Product A",
        "meta": "€ 49",
        "content": "Description breve."
      }
    }
  ]
}
```
