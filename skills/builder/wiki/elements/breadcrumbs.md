---
title: breadcrumbs element
type: element
status: verified
yootheme_version: "5.0.43"
sources: ["[[sources/yootheme-docs-breadcrumbs]]", "[[sources/yootheme-pro-5.0.33-source]]", "[[sources/yootheme-pro-5.0.43-source]]"]
tags: [element, system, navigation, wordpress, breadcrumbs]
updated: 2026-10-13
---

# `breadcrumbs`

Breadcrumb trail for the current page. `raw/yootheme-pro-5.0.33/packages/builder-wordpress/elements/breadcrumbs/element.php`
(122 lines). Not in the baseline skill's `element-types.md` — everything below comes from the source.

```php
'name' => 'breadcrumbs',  'title' => 'Breadcrumbs',  'group' => 'system',  'element' => true,
```

A leaf element: no `children`. **WordPress only** (`builder-wordpress`). Docs:
[[sources/yootheme-docs-breadcrumbs]].

## Defaults that are not empty

```php
'defaults' => ['show_home' => true, 'show_current' => true],
```

## Props unique to `breadcrumbs`

| Prop | Type | Notes |
|---|---|---|
| `show_home` | checkbox | Prepends a "Home" item linking to `~theme.site_url` |
| `show_current` | checkbox | Keeps the last item (current page); when off, the last item is popped |
| `home_text` | text | Label of the home link; placeholder/fallback `Home`; only enabled when `show_home` is on (`'enable' => 'show_home'`) |

## Shared prop families

| Props | Page |
|---|---|
| `position`, `position_left/right/top/bottom`, `position_z_index`, `blend` | [[props/position]] |
| `margin_top`, `margin_bottom` | [[props/margin]] |
| `text_align`, `text_align_breakpoint`, `text_align_fallback` | [[props/alignment]] — here emitted as `uk-flex-{…}` on the `ul`, not `uk-text-*` |
| `animation`, `_parallax_button` | [[props/animation]] |
| `visibility` | [[props/visibility]] |
| `name`, `status`, `id`, `class`, `attributes`, `css`, `transform` | [[props/advanced-group]] — `css` hint selector is `.el-element` |

No `maxwidth`/`block_align` props.

## How the trail is built (render transform)

`'transforms' => ['render' => … $node->props['items'] = Breadcrumbs::getItems($node->props)]` — the items
are **never in the JSON**; they are derived from the WordPress query on every render
(`raw/yootheme-pro-5.0.43/packages/theme-wordpress/src/Breadcrumbs.php`):

| Context | Trail |
|---|---|
| Front page | no items (only Home, if `show_home`) |
| Page / posts page | ancestors → current |
| Single post | category chain (first category) → title |
| Other singular (CPT) | post-type archive (if `has_archive`) → term trail → title |
| Category / tag / date / author / search / tax / CPT archive | corresponding chain |

Developers can alter it via the `theme.breadcrumbs|filter` event. The current item's `link` is forced
empty, so it is rendered as `aria-current="page"` text, not a link.

## UIkit output

```html
<nav aria-label="Breadcrumb">
  <ul class="uk-breadcrumb uk-margin-remove-bottom uk-flex-{text_align}" vocab="https://schema.org/" typeof="BreadcrumbList">
    <li property="itemListElement" typeof="ListItem"><a href="…" property="item" typeof="WebPage"><span property="name">Home</span></a><meta property="position" content="1"></li>
    <li class="uk-disabled"><span>…</span></li>   <!-- item without link that is not last -->
    <li …><span property="name" aria-current="page">…</span></li>
  </ul>
</nav>
```

Component `uk-breadcrumb` (`uikit/src/less/components/breadcrumb.less`): variables `@breadcrumb-item-font-size`,
`@breadcrumb-item-color`, `@breadcrumb-item-hover-color`, `@breadcrumb-item-active-color`,
`@breadcrumb-divider` (`"/"`), `@breadcrumb-divider-margin-horizontal`. Structured data comes from the
element markup (microdata); the theme-level `templates/breadcrumbs.php` is a separate renderer that
emits JSON-LD instead.

## Gotchas
- **Empty output:** the whole template is wrapped in `if ($items)`. With `show_home` and `show_current`
  both off, a page with no other ancestors renders nothing (docs: the element "may collapse").
- `home_text` is passed through `__()`: if the string matches a translation it gets translated.
- Typical JSON (props verified against `element.php`; importable inside a column):

```json
{ "type": "breadcrumbs", "props": { "show_home": true, "show_current": true, "text_align": "center" } }
```

## Version history (CHANGELOG)
4.0.0 `nav` element + aria-label + structured data · 4.0.5 empty-link items now in structured data ·
4.4.0 `aria-current` · 4.5.0 home link fix · 4.5.6 paged trail removed from WooCommerce breadcrumbs ·
2.5.0 WooCommerce support · 2.4.7 term trail for taxonomies.
