---
title: grid element
type: element
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]", "[[sources/production-layout-sample]]", "[[sources/websites-demo]]"]
tags: [element, grid, multiple-items, card, filter, lightbox]
updated: 2026-07-29
---

# `grid`

A collection of cards. `raw/yootheme-pro-5.0.33/packages/builder/elements/grid/element.php` — 1766
lines, ~154 props, the largest element in the builder.

```php
'name' => 'grid',  'title' => 'Grid',  'group' => 'multiple items',
'element' => true,  'container' => true,
```

Baseline prop table: [[sources/skill-yootheme-json-schema]] `references/element-types.md:627-702`.

## `grid` is not a layout grid

The name misleads. `grid` is the **content-items element**: it renders one card per
[[elements/grid_item]] child, styled entirely by props on the parent. Page layout — columns of
arbitrary content — is `row` + `column`, an unrelated pair.

Three consequences:

1. **Children are `grid_item` and nothing else** (`'item' => 'grid_item'` on the `content` field).
   You do not put a [[elements/panel]] inside a grid; the grid *is* the panels
2. **Styling on the parent, content on the children.** An item carries title, meta, content, image,
   link, tags. How those look is a grid prop
3. **`grid` itself goes inside a `column`**, like any other element

[[sources/production-layout-sample]] confirms all three: three grids, all in a `column`, no
`panel` node anywhere in the file.

## Defaults that are not empty

26 entries. The ones that bite: all eight `show_*` default to `true`; `grid_default` is `'1'` and
`grid_medium` is `'3'`, so an unconfigured grid is already responsive 1→3; `item_animation` is
`true`; `margin_top` and `margin_bottom` are `'default'`.

## Props unique to `grid`

Beyond the families, the collection-level machinery:

### Columns

| Prop | Values | Default |
|---|---|---|
| `grid_default` | `'1'`…`'6'` `'auto'` | `'1'` — no "Inherit", nothing smaller to inherit from |
| `grid_small` / `_medium` / `_large` / `_xlarge` | `''` (Inherit) + the above | `grid_medium: '3'` |

`''` above `grid_default` means *inherit the previous breakpoint*, not "no columns". Emits
`uk-child-width-1-{n}@{bp}` — see [[uikit/uk-grid]].

### Gaps and arrangement

`grid_column_gap`, `grid_row_gap` (`small` `medium` `''` `large` `collapse`), `grid_divider`,
`grid_column_align`, `grid_row_align`, `grid_masonry` (`''` `pack` `next`), `grid_parallax` (0–600),
`grid_parallax_justify`, `grid_parallax_start`/`_end`.

Equal gaps emit one `uk-grid-{gap}`; different gaps emit the split
`uk-grid-column-*` + `uk-grid-row-*` pair. `uk-grid-match` is added whenever masonry is **off**, so
cards are equal height by default. `grid_divider` and the centring props are gated on
`!grid_masonry && !grid_parallax`.

`template.php:10-12`: setting only `grid_parallax_justify` forces `grid_parallax` to `'0'`.
`:13-15`: masonry blanks `image_expand` unless the image is left- or right-aligned.

### Filter

`filter` turns the grid into a `uk-filter` driven by each item's `tags` prop, a comma-separated
string. Seventeen companions: `filter_animation` (**"None" stores the string `'false'`**),
`filter_order` + `filter_order_manual` + `filter_reverse`, `filter_style`
(`tab` `subnav` `subnav-divider` `subnav-pill`), `filter_all` + `filter_all_label`,
`filter_position` (`top` `left` `right`), `filter_style_primary`, `filter_wrap`, `filter_align`,
`filter_margin`, and a `filter_grid_*` set.

`element.php:70-116` builds the tag set at render: HTML is stripped from each tag (a guard for
dynamically mapped values), spaces become hyphens in the key, and ordering is `natsort` unless
`filter_order_manual` supplies an explicit list.

With `filter_position` left or right the whole grid is wrapped in a second `uk-grid`, sized by
`filter_grid_width` — the same sub-grid pattern as `title_grid_*` in [[props/title-family]].

### Other

`item_maxwidth`, `panel_content_width`, `item_animation`, `container_padding_remove`.

## Families used

| Family | Notes for `grid` |
|---|---|
| [[props/show-switches]] | **Eight** switches — the widest set in the builder |
| [[props/panel-style]] | Eleven values: the ten of `panel` **plus `tile-checked`**, the only style that loads JavaScript |
| [[props/lightbox]] | Full set of eleven, plus `title_display` / `content_display` |
| [[props/title-family]] · [[props/meta-family]] · [[props/content-family]] · [[props/image-family]] · [[props/link]] | Identical to [[elements/panel]] |
| [[props/media]] | `video_autoplay`, `video_autoplay_restart` |
| [[props/expand-mechanism]] | `image_expand` + the three `*_margin_auto` flags; masonry blanks `image_expand` |
| [[props/margin]] · [[props/position]] · [[props/alignment]] · [[props/visibility]] · [[props/animation]] · [[props/advanced-group]] | Standard |

Read [[elements/panel]] for the card-level props: they behave identically here, applied to every
item at once.

## Real-world usage

The three grids in [[sources/production-layout-sample]] use one element three ways, all via
[[props/show-switches]]: a statistics strip (`show_image: false`, `show_content: false`,
`grid_divider: true`), instructor cards (blank panel, rounded images), and service cards
(`card-default`) — lifted into [[recipes/service-card-grid]].

The 142 grids of [[sources/websites-demo]] add three configurations the production layout did not
show:

- **The one-column loop**: `grid_medium: "1"` ([[sources/demo-framerate]]) — no columns at all, the
  grid used purely as a styled repeating-item list, typically `source`-bound
- **`grid_default: "auto"`** ([[sources/demo-oakville]] ×6) — auto columns for logo strips and link
  lists whose item count comes from a dynamic query
- **`panel_link: true` is the norm on navigational grids** — 54 demo grids set it; card walls are
  expected to be clickable everywhere

Column choices cluster tightly: `grid_default` is `"1"` on 131 of 142, `grid_medium` `"3"` or
`"4"` — the 1→3/4 ramp with `m` as the pivot is the corpus idiom.

## UIkit output and scoped CSS

An outer `<div>` carrying `uk-filter` and `uk-lightbox` where enabled, an inner `uk-grid` with the
`uk-child-width-*` classes, and one bare `<div>` cell per child. See [[uikit/uk-grid]] and
[[uikit/uk-card]].

Scoped selectors: `.el-element` `.el-nav` `.el-item` `.el-title` `.el-meta` `.el-content`
`.el-image` `.el-link` `.el-hover-image`. `.el-item` targets one card, `.el-nav` the filter
navigation — neither exists on `panel`. See [[props/advanced-group]].

## Related

[[elements/grid_item]] · [[elements/panel]] · [[elements/section]] · [[uikit/uk-grid]] ·
[[uikit/uk-card]] · [[recipes/service-card-grid]]
