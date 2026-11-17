---
name: json-schema
description: Use when reading, explaining, generating or validating YOOtheme Pro builder JSON - interpreting an exported layout or section, creating importable builder JSON from a brief (no HTML preview needed), looking up YOOtheme element props or field types, or debugging a builder JSON import error. Activates on any JSON made of YOOtheme builder nodes (type, props, children).
version: 3.0.0
---

# YOOtheme Pro Builder JSON Schema

Reference for the proprietary JSON format the YOOtheme Pro page builder uses for layout, section
and element import/export.

Paths in this file are relative to this skill's base directory. `../builder/` is the sibling
`builder` skill of this plugin, which holds the knowledge base (`../builder/wiki/`) and the
validator (`../builder/scripts/validate.sh`).

## JSON hierarchy

```
Root (object {"type":"layout", "version":"...", "children":[...]} — confirmed by 78/78 real files)
└── Section node
    └── Row node(s)
        └── Column node(s)
            └── Element node(s)  ← actual content
```

## Required fields on every node — two shapes, container and leaf

```jsonc
// CONTAINER (section, row, column, fragment, button, grid, list, map, table, …)
{
  "name": "string",   // in practice only on section (see below)
  "type": "string",   // identifies the node type
  "props": {},        // configuration object (never null)
  "children": []      // child nodes array — REQUIRED, never null
}

// LEAF (headline, text, image, button_item, grid_item, list_item, map_item, table_item, …)
{
  "type": "string",
  "props": {}         // configuration object (never null)
  // NO "children" key — omit it entirely, never "children": []
}
```

**IMPORTANT**: real YOOtheme JSON has **no node-level `id` field**. Never add `id` fields or UUIDs
to nodes. (The `id` *prop* inside `props` is a different thing — the HTML `id` attribute.)

**`children`**: required (an array, never null) on **container** nodes. On **leaf** nodes it is
**omitted entirely** — not `"children": []`. Verified with zero exceptions on 9 independent real
files. Including it on a leaf node is the most likely observed cause of the import error
`invalid argument expected string`. Details → `../builder/wiki/issues/children-key-leaf-nodes.md`.

**`name`**: *declarable* on 48 of the 51 builder element types (the field exists in the PHP
`fields`), but **in observed practice it appears almost only on `section`** (36/41 instances in the
demo corpus, 100% in a second independent real export) — do not generate it by default below
section. `row` and `column` do not declare it at all. Details and source citations →
`../builder/wiki/props/advanced-group.md`, `../builder/wiki/issues/name-prop-node-level.md`.

## Root structure — the `layout` object

An exhaustive check of 77 official demo pages plus a real user export (78 files, zero exceptions)
shows that **the root is always an object**:

```json
{
  "type": "layout",
  "version": "5.0.43",
  "name": "Page name",
  "modified": "2026-09-08T08:14:46.816Z",
  "props": [],
  "children": []
}
```

`type`/`version`/`children` are always present; `name`/`modified` almost always; `props` is
observed as an empty array `[]`, not `{}`. `version` is the builder version at export time — it
varies from file to file and must not be newer than the target installation.

**Always generate this format** for a full layout/page. The bare-array format
`[{ "type": "section", ... }]` has no real-world confirmation — see
`../builder/wiki/issues/root-format-object-not-array.md`.

## ⚠️ Core rule — prefer native elements

**Do not use `html` or raw HTML in `content` when a native element exists.**

| Requested pattern | Native element |
|---|---|
| Card with image / title / text / link | `panel` |
| Grid of cards | `grid` + `grid_item` |
| Photo grid with hover overlay | `overlay-slider` or `gallery` |
| Expandable FAQ | `accordion` + `accordion_item` |
| Tabs with switching content | `switcher` + `switcher_item` |
| List of items (icon, link, image) | `list` + `list_item` |
| Price menu / glossary / dt-dd | `description_list` + `description_list_item` |
| Social links | `social` + `social_item` |
| Video player | `video` |
| Map with markers | `map` + `map_item` |
| Countdown timer | `countdown` |
| Quote / testimonial | `quotation` |
| Notice box / coloured banner | `alert` |
| Standalone icon | `icon` |
| Data table | `table` + `table_item` |
| Custom raw HTML | `html` (**last resort — only if unavoidable**) |

Full props for every element → `references/element-types.md`

---

## Layout from a prompt (no HTML preview)

When the user asks for a layout or landing page from a brief — texts, directions, even just an
idea — generate **the builder JSON directly**, without going through an HTML preview.

1. **Extract from the prompt**: page purpose, requested or implied sections, provided copy,
   available images, CTAs, section styles (`section.style`).
2. **Ask only if essential information is missing** — which sections are needed; real copy or
   placeholders; whether there are images; how many CTAs and where they point. One focused batch
   of questions, never a barrage. If the brief is enough, proceed without asking.
3. **State the outline** before the JSON: one line per section with the chosen native element
   (from the mapping table above) and the assumptions made. E.g. "Hero → `section` + `headline` +
   `button`; Services → `grid` + `grid_item` (3 columns); FAQ → `accordion`".
4. **Generate the JSON**: root `layout` object (see above), copy taken from the prompt; any
   invented placeholder must be declared as such to the user. For every element emitted, check its
   props in `references/element-types.md` — never props from memory.
5. **Validate** with the Import validation checklist and the mechanical check (below), then save
   to a `.json` file ready for import.

## Node types

### Structure

| Type | Level | Description |
|---|---|---|
| `section` | 1 | Full-width section container |
| `row` | 2 | Grid row with columns |
| `column` | 3 | Column with width props |
| `fragment` | 3 | Row container with no visual semantics |

### Content elements

| Type | Description | Children |
|---|---|---|
| `headline` | Heading with style, decoration, inline icon | none |
| `text` | HTML paragraph with style and multi-column | none |
| `image` | Image with border, shadow, lightbox, link | none |
| `icon` | Standalone UIkit icon | none |
| `divider` | Horizontal/vertical separator | none |
| `code` | Source code block | none |
| `html` | Raw HTML (**last resort**) | none |
| `button` | Button group | `button_item` |
| `accordion` | Expandable FAQ panels | `accordion_item` |
| `alert` | Coloured notice box | none |
| `quotation` | Quote with author and footer | none |
| `countdown` | Countdown timer with date | none |
| `panel` | Single card with image/title/link | none |
| `overlay` | Image with text overlay | none |
| `grid` | Multi-item grid with cards and filters | `grid_item` |
| `gallery` | Photo grid with overlay and lightbox | `gallery_item` |
| `list` | Vertical/horizontal list with icon | `list_item` |
| `description_list` | dt-dd list for menus/glossaries/prices | `description_list_item` |
| `slideshow` | Full-width hero slideshow | `slideshow_item` |
| `panel-slider` | Card/news slider | `panel-slider_item` |
| `overlay-slider` | Image slider with overlay | `overlay-slider_item` |
| `nav` | Vertical navigation (sidebar, dropdown) | `nav_item` |
| `subnav` | Compact horizontal navigation | `subnav_item` |
| `switcher` | Tabs with switching content | `switcher_item` |
| `video` | Video player with poster and controls | none |
| `social` | Social links with icons | `social_item` |
| `map` | Map with markers | `map_item` |
| `popover` | Image with hotspot markers | `popover_item` |
| `totop` | Back-to-top button | none |
| `table` | Data table with headers | `table_item` |

## Props by element type — quick reference

| Type | Key props | Children |
|---|---|---|
| `section` | `style`, `padding_top`, `padding_bottom`, `width`, `image`, `image_size`, `image_effect`, `text_color`, `media_overlay`, `height`, `vertical_align` | `row` |
| `row` | `layout` (e.g. `"1-2,1-2"`), `column_gap`, `row_gap`, `margin_top`, `margin_bottom` | `column` |
| `column` | `width_default`/`width_small`/`width_medium`/`width_large`/`width_xlarge`, `vertical_align`, `image` (background), `media_overlay` | elements |
| `headline` | `content` (HTML), `title_element` (h1-h6\|div), `title_style`, `title_color`, `title_decoration`, `icon`, `link`, `class` | none |
| `text` | `content` (HTML), `text_style`, `text_color`, `column` | none |
| `image` | `image` (path string), `image_alt`, `image_border`, `image_box_shadow`, `link`, `lightbox` | none |
| `icon` | `icon`, `icon_color`, `icon_width`, `link`, `link_style` | none |
| `divider` | `divider_style`, `divider_element`, `divider_align` | none |
| `button` | `grid_column_gap`, `button_size` | `button_item` |
| `button_item` | `content` (**NOT `title`**), `button_style` (**NOT `style`**), `link`, `icon`, `icon_align` | none |
| `accordion` | `collapsible`, `multiple`, `show_image`, `link_text` | `accordion_item` |
| `accordion_item` | `title`, `content`, `image`, `link` | none |
| `alert` | `title`, `content`, `alert_style`, `title_element` | none |
| `quotation` | `content`, `author`, `footer`, `link` | none |
| `countdown` | `date`, `countdown_style`, `show_label`, `show_separator` | none |
| `panel` | `title`, `meta`, `content`, `image` (string), `icon`, `link`, `link_text`, `panel_style`, `panel_link`, `image_align`, `title_element`, `meta_align` | none |
| `overlay` | `image` (string), `title`, `overlay_mode`, `overlay_style`, `overlay_position`, `overlay_hover`, `overlay_transition`, `text_color` | none |
| `grid` | `grid_default`, `grid_small`, `grid_medium`, `grid_column_gap`, `panel_style`, `show_*`, `title_element`, `image_align`, `item_animation` | `grid_item` |
| `grid_item` | `title`, `meta`, `content`, `image` (string), `icon`, `link`, `tags` | none |
| `gallery` | `grid_default`, `grid_medium`, `overlay_mode`, `overlay_style`, `filter`, `lightbox` | `gallery_item` |
| `gallery_item` | `image` (string), `image_alt`, `title`, `meta`, `tags` | none |
| `list` | `list_element`, `list_type`, `list_marker`, `list_style`, `image_align`, `icon` | `list_item` |
| `list_item` | `content`, `image`, `icon`, `link` | none |
| `description_list` | `layout`, `list_style`, `title_leader`, `meta_color`, `meta_align` | `description_list_item` |
| `description_list_item` | `title`, `meta`, `content`, `link` | none |
| `slideshow` | `slideshow_autoplay`, `slideshow_min_height`, `height_viewport`, `nav`, `slidenav`, `overlay_position`, `overlay_animation`, `text_color`, `title_element`, `title_style` | `slideshow_item` |
| `slideshow_item` | `image` (string), `title`, `meta`, `content`, `link`, `link_text` | none |
| `panel-slider` | `slider_width_default`, `slider_width_medium`, `slider_gap`, `slidenav`, `panel_style`, `panel_link`, `panel_match` | `panel-slider_item` |
| `panel-slider_item` | `title`, `meta`, `content`, `image` (string), `icon`, `link` | none |
| `overlay-slider` | `slider_width_default`, `slider_width_medium`, `overlay_mode`, `overlay_display`, `overlay_transition`, `nav`, `slidenav` | `overlay-slider_item` |
| `overlay-slider_item` | `image` (string), `title`, `link`, `text_color` | none |
| `switcher` | `nav`, `nav_position`, `nav_align`, `switcher_animation` | `switcher_item` |
| `switcher_item` | `title` (tab text), `content`, `image`, `link`, `label` | none |
| `nav` | `nav_style`, `nav_divider`, `grid` | `nav_item` |
| `nav_item` | `content`, `icon`, `link`, `type` (`''`/`'heading'`/`'divider'`), `active` | none |
| `subnav` | `subnav_style`, `subnav_wrap` | `subnav_item` |
| `subnav_item` | `content`, `icon`, `link`, `active` | none |
| `video` | `video` (URL/path), `poster`, `video_controls`, `video_autoplay`, `video_loading` | none |
| `social` | `link_style`, `grid`, `grid_column_gap` | `social_item` |
| `social_item` | `link`, `icon`, `link_aria_label` | none |
| `map` | `type`, `zoom`, `controls`, `height` | `map_item` |
| `map_item` | `location` (string `"lat, lng"`), `title`, `content`, `link` | none |
| `table` | `table_style`, `table_hover`, `table_responsive`, `table_head_*` | `table_item` |
| `table_item` | `title`, `meta`, `content`, `image`, `link` | none |

**Critical props to remember**:
- `section`: use `padding_top`/`padding_bottom` (NOT `padding`) — always keep the default `''`
  unless there is a reason (e.g. a full-width hero that needs more breathing room).
- `section.style` values: `''`, `'default'`, `'muted'`, `'primary'`, `'secondary'` — default `'default'`.
- **Eyebrow**: a short label above a heading → a separate `headline` element
  (`title_element: "div"`) placed right before the title headline. Never on a `text` element,
  never as an inline span in `content`. Default styling: the element's `css` prop with the
  `.el-element` selector (auto-scoped), e.g.
  `"css": ".el-element { text-transform: uppercase; letter-spacing: 0.1em; }"` — the JSON stays
  self-contained on import, no theme class required. `class: "tm-eyebrow"` only as an alternative
  when the theme already defines that style in LESS. Inside cards (`panel`/`grid`): use `meta` with
  `meta_align: "above-title"`, optionally refined through `css` with `.el-meta`.
- `button_item`: use `content` for the label (NOT `title`), `button_style` (NOT `style`).
- Responsive `row.layout`: `"1-4,1-4,1-4,1-4|1-2,1-2,1-2,1-2"` (desktop|tablet separated by `|`).
- **`row.layout` / `column.width_medium` / `width_small`: ONLY these fractions are valid** (UIkit
  generates no other `uk-width-*` classes): halves `1-2`; thirds `1-3`, `2-3`; quarters `1-4`,
  `3-4`; fifths `1-5`, `2-5`, `3-5`, `4-5`; sixths `1-6`, `5-6`; whole `1-1`; keywords
  `small`/`medium`/`large`/`xlarge`/`2xlarge`/`auto`/`expand`. **NEVER twelfths** (`5-12`, `7-12`,
  `1-12`, …) or other arbitrary fractions — the CSS class does not exist and the column loses its
  width, breaking the layout. For an asymmetric 60/40 use `3-5,2-5` (not `6-10,4-10` or
  `5-12,7-12`). Never copy a fraction from another file without checking it against this list.
- **A fractional `row.layout` must always be paired with the same `width_*` on the child columns**
  (`width_default`/`width_small`/`width_medium`/`width_large`/`width_xlarge`, same fraction as
  `layout`). `row.layout` is editor metadata only: the frontend renders `uk-width-{width_*}` read
  from the columns, falling back to `uk-width-1-1` (full width) when no `width_*` is set. The
  migration that expands `row.layout` into the columns' `width_*` (`row/updates.php`, key
  `2.1.0-beta.0.1`) is **skipped** when the file already declares a newer `version` — i.e. in every
  generated file. Omitting `width_*` yields stacked full-width columns until the fraction is
  re-selected by hand. Real case: `../builder/wiki/issues/column-width-props.md`.
- `grid.grid_default/medium` are numeric strings: `"1"`, `"2"`, `"3"`, etc.
- `panel.image_align` values: `'top'` `'bottom'` `'left'` `'right'` `'between'`.
- `slideshow_min_height` is a 200–800 range, default 300.
- **`section.media_overlay`**: a flat colour (`rgba(...)`/hex), used as CSS `background-color`.
  **NEVER a `linear-gradient()` function here**: a real gradient goes in the separate
  `media_overlay_gradient` field (CSS `background-image`). See
  `../builder/wiki/issues/media-overlay-gradient-string.md`.
- **`name`**: a node key (sibling of `type`/`props`/`children`), NEVER inside `props`.
  *Declarable* on 48 of the 51 element types, but in observed practice it appears almost only on
  `section` — do not add it by default below section.
- **`children`**: required (array) on container nodes; on leaf nodes **omit it entirely**, never
  `[]` — see `../builder/wiki/issues/children-key-leaf-nodes.md`.

Full props with every valid value → `references/element-types.md`

## Field serialisation

```jsonc
// IMAGE → plain string (relative path)
"image": "wp-content/uploads/photo.jpg"   // ✅
"image": {"src": "...", "alt": ""}        // ❌

// LINK → plain string (URL or relative path)
"link": "page/"                            // ✅
"link": {"url": "...", "text": ""}         // ❌

// NUMBER → string
"slideshow_min_height": 300    // ✅ (some accept integers)
"image_height": "300"          // ✅ (prefer strings for consistency)

// CHECKBOX → boolean
"slideshow_autoplay": true     // ✅

// EMPTY → empty string, never null
"title": ""                    // ✅
"title": null                  // ❌
```

## Generating valid JSON

1. **NO node-level `id` fields** — never add UUIDs or identifiers.
2. Root: the `{"type":"layout", "version":"...", "children":[...]}` object — not the bare array.
3. `children` is **required** (array, never null) on container nodes; on **leaf** nodes it is
   **omitted entirely** — never `"children": []`.
4. Every `props` is always an object, `{}` if no props are needed.
5. `image` and `link` are **strings**, not objects.
6. Compound elements (`button`, `grid`, `slideshow`, `panel-slider`) use `children` for their items,
   not arrays inside `props`.
7. Only `section` nodes carry a descriptive `name`, as a sibling key of `type` — never inside
   `props`, never by default on other node types.

## Reading / analysing JSON

1. Parse the hierarchy: count sections, rows per section, columns per row.
2. For each section: style, padding, background type.
3. For each element: type and key content.
4. Flag problems (missing alt text, wrong types, invariant violations).
5. Name the UIkit classes implied by the props.

## Reference example

`examples/example-layout.json` — a complete home page layout (hero slideshow, split section,
statistics grid, services grid, CTA, partner panel-slider, dynamic blog grid, newsletter). Content
is placeholder copy; the structure is from a real production export.

## Import validation checklist

- [ ] Syntactically valid JSON
- [ ] Root is the **object** `{"type":"layout", "version":"...", "children":[...]}` — not an array
- [ ] No node-level `id` fields
- [ ] Every node has `type` and `props`
- [ ] `children` present (array) on container nodes; **absent entirely** (not `[]`) on leaf nodes
      (`headline`, `text`, `image`, `button_item`, `grid_item`, `list_item`, `map_item`,
      `table_item`, …)
- [ ] `props` is always an object
- [ ] `image` fields are strings (not objects)
- [ ] `link` fields are strings (not objects)
- [ ] Correct element types (no `builder_*`)
- [ ] No `null` values
- [ ] `row.layout` / `column.width_*` fractions only from the valid list (never twelfths)
- [ ] Every fractional `row.layout` has matching `width_*` on its columns
- [ ] `name` only on `section` nodes (sibling key of `type`, never inside `props`)

Mechanical check — run it and show the result:

```bash
bash ../builder/scripts/validate.sh layout.json
```

The script runs every check above with `jq` and exits non-zero on any violation. Requires `jq`.
