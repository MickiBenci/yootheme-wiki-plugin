# YOOtheme Pro Builder JSON Schema Specification

Annotated formal schema for the YOOtheme Pro builder JSON format.

> This spec follows the canonical invariants: **no node-level `id` field**, **no `builder_`
> prefix**, `image`/`link` are **strings**. Verified against the YOOtheme Pro 5.0.33 → 5.0.53
> source code.

Wiki references below point to the knowledge base in the sibling `builder` skill
(`../../builder/wiki/`, relative to this file).

## Hierarchy

```
Root (object {"type":"layout", "version":"...", "children":[...]} — confirmed by 78/78 real files)
└── Section
    └── Row (one or more per Section)
        └── Column (one or more per Row)
            └── Element (content)
```

## The root format — the `layout` object

**Correction (2026-09-08):** an earlier version of this spec prescribed "always a root array" for
every generated JSON. That rule had **no** real-world confirmation — it was caught only after a file
generated with a root array repeatedly failed to import on a real installation
(`TypeError: Invalid argument expected string`). An exhaustive (not sampled) check of **all** 77
official demo pages plus a real user export (78 files, zero exceptions) shows that **the root is
always an object**:

```text
root type of ALL files:     78 object   (zero arrays)
.type of ALL object roots:  78 "layout" (zero other values)
```

```jsonc
{
  "type": "layout",
  "version": "5.0.43",
  "name": "Page name",
  "modified": "2026-09-08T08:14:46.816Z",
  "props": [],
  "children": [ /* section nodes */ ]
}
```

| Key | Present | Notes |
|---|---|---|
| `type` | always | literal `"layout"` |
| `version` | always | builder version string at export time (e.g. `"5.0.32"`, `"5.0.43"`) — varies per file; never newer than the target installation |
| `children` | always | array of `section` nodes |
| `name` | often, not always | page title — missing in the oldest files (`5.0.0-beta.*` builds), present in recent exports |
| `modified` | as above | ISO 8601 timestamp with milliseconds |
| `props` | as above | observed as `[]` (empty array), not `{}` — likely a PHP serialisation quirk of an empty associative array |

**The root-array format (`[ {section}, … ]`) has no real-world confirmation.** It remains a
plausible option for a different flow (pasting a section snippet into a specific UI spot instead
of uploading a full file), but no examined file shows it. Treat it as **unverified** — see
`issues/root-format-object-not-array.md` — and never use it as the default for a full layout.
**Always generate the `layout` object** unless the user explicitly describes a different import
mechanism.

## Base node — two shapes, container and leaf

**There is no single shape valid for every node.** Two independent real sources — 8 official demo
files (~200+ leaf nodes checked) and a genuine user export (YOOtheme 5.0.43, 111 KB, zero
exceptions across hundreds of nodes) — show **100% consistently** that **container** nodes and
**leaf** nodes have different shapes:

```jsonc
// CONTAINER (section, row, column, fragment, button, grid, list, map, table, … — any type that
// hosts children in practice)
{
  "name": "string",         // almost only on `section` — see below
  "type": "string",         // REQUIRED
  "props": {},              // REQUIRED: object, possibly empty
  "children": [ /* child nodes */ ]   // REQUIRED: array, never null, never omitted
}

// LEAF (headline, text, image, button_item, grid_item, list_item, map_item, table_item, … — any
// type that never hosts children in practice)
{
  "type": "string",         // REQUIRED
  "props": {}               // REQUIRED: object, possibly empty
  // NO "children" key — OMIT it entirely, not "children": []
  // NO "name" key in observed practice — see below
}
```

Rules:
- **There is no node-level `id` field.** Node identity is positional, computed at render time
  (`IndexTransform` derives a `data-id` from the path). A stray `id` is ignored, but never
  generate one.
- `props` is always an object — never `null`, never omitted, on every node type (the root
  `layout`'s `props` is the one exception, observed as `[]`).
- **`children` is required only on container nodes** (never `null` there). **On leaf nodes it is
  omitted entirely** — never present, not even as `[]`. Verified with zero exceptions on 9
  independent real files (see `issues/children-key-leaf-nodes.md`). The old rule "children is
  always present, `[]` on leaf nodes" was wrong and is the most likely cause of an observed
  "invalid argument expected string" import error.
- **`name` is a sibling key of `type`/`props`/`children`, never inside `props`** — see
  `props/advanced-group.md`. It is *declarable* on 48 of the 51 builder element types (the field
  exists in the PHP `fields`), but **in observed practice it appears almost only on `section`**
  (and on the page-level `layout` wrapper): 36 of ~41 instances in the demo corpus, 100% in the
  second reference export. The rare exceptions are nodes renamed by hand in the outline for a
  specific reason — do not generate it by default below `section`. `row` and `column` do not
  declare it at all (see `issues/name-prop-node-level.md`).
- Element `type`s are the bare names (`headline`, `text`, `grid`…) — **never** a `builder_` prefix.
- No `null` values anywhere: empty is `""`.

## Section node

```jsonc
{
  "type": "section",
  "props": {
    "style": "",              // ''|default|muted|primary|secondary
    "padding_top": "",        // ''|xsmall|small|large|xlarge|none  (there is NO 'padding')
    "padding_bottom": "",     // same
    "width": "default",       // default|xsmall|small|large|xlarge|expand|''
    "image": "",              // string: background image path
    "image_size": "",         // cover|contain|auto
    "image_position": "",     // e.g. center-center, top-center…
    "media_overlay": "",      // overlay colour (hex or rgba) — never a gradient
    "text_color": "",         // ''|light|dark — forces uk-light/uk-dark
    "height": "",             // ''|pixels|viewport|section|page
    "vertical_align": ""      // ''|middle|bottom
  },
  "children": [ /* Row nodes */ ]
}
```

## Row node

```jsonc
{
  "type": "row",
  "props": {
    "layout": "1-2,1-2",      // columns per row; responsive with | e.g. "1-4,1-4,1-4,1-4|1-2,1-2"
    "column_gap": "",         // ''|small|medium|large|collapse
    "row_gap": "",            // same
    "divider": false,
    "margin_top": "",
    "margin_bottom": ""
  },
  "children": [ /* Column nodes */ ]
}
```

**Valid fractions** for `layout` and `column.width_*` (UIkit generates no other `uk-width-*`
classes): `1-2` · `1-3` `2-3` · `1-4` `3-4` · `1-5` `2-5` `3-5` `4-5` · `1-6` `5-6` · `1-1` ·
keywords `small`/`medium`/`large`/`xlarge`/`2xlarge`/`auto`/`expand`. **Never twelfths** or
arbitrary fractions.

**`layout` alone is not enough**: the frontend reads widths from the columns' `width_*`
(`uk-width-{width_medium}@m` etc.), falling back to `uk-width-1-1` (full width) when a column has no
`width_*`. `layout` is expanded into the columns' `width_*` by a migration (`row/updates.php`, key
`2.1.0-beta.0.1`) only when the imported file declares a `version` **older** than that key — a file
that already declares the current theme `version` (like every generated file) skips that migration.
**Always set `width_*` on the columns too, with the same fraction as `layout`**; never rely on the
automatic expansion. See `issues/column-width-props.md`.

## Column node

```jsonc
{
  "type": "column",
  "props": {
    "width_small": "",        // fraction @s (see the valid list above)
    "width_medium": "",       // fraction @m
    "vertical_align": "",     // ''|middle|bottom
    "image": "",              // string: column background
    "media_overlay": ""
  },
  "children": [ /* Element nodes */ ]
}
```

## Element nodes

`type`s are the bare element names: `headline`, `text`, `image`, `button`, `panel`, `grid`…
See [element-types.md](element-types.md) for the full list with props.

### Props shared by all elements

```jsonc
{
  "margin_top": "",           // ''|xsmall|small|default|medium|large|xlarge|remove|auto
  "margin_bottom": "",        // same
  "text_align": "",           // ''|left|center|right|justify
  "text_align_breakpoint": "",// ''|s|m|l|xl
  "animation": "",            // scrollspy — see the animations skill
  "visibility": "",           // ''|s|m|l|xl|hidden-s|hidden-m|hidden-l|hidden-xl
  "class": "",                // extra CSS classes
  "css": "",                  // CSS scoped to the element
  "attributes": ""            // extra HTML attributes
}
```

Omit props that stay at their default: the builder fills them from `element.php`.

## Field serialisation

```jsonc
"image": "wp-content/uploads/photo.jpg"   // plain string — NEVER an object {src, alt}
"link": "page/"                            // plain string — NEVER an object {url, text, target}
"slideshow_autoplay": true                 // checkbox → boolean
"image_height": "300"                      // number → numeric string (preferred)
"title": ""                                // empty → empty string, never null
```

Compound elements (`button`, `grid`, `slideshow`, `accordion`, `panel-slider`…) put their items in
`children` as nodes (`button_item`, `grid_item`, …) — **never** an `items` array inside `props`.

## Complete example: hero section

```json
{
  "type": "layout",
  "version": "5.0.43",
  "name": "Homepage",
  "modified": "2026-09-08T08:14:46.816Z",
  "props": [],
  "children": [
    {
      "name": "Hero",
      "type": "section",
      "props": {
        "style": "primary",
        "image": "wp-content/uploads/hero-bg.jpg",
        "image_size": "cover",
        "media_overlay": "rgba(0,0,0,0.4)",
        "text_color": "light"
      },
      "children": [
        {
          "type": "row",
          "props": { "layout": "1-1" },
          "children": [
            {
              "type": "column",
              "props": { "vertical_align": "middle" },
              "children": [
                {
                  "type": "headline",
                  "props": {
                    "content": "Main headline",
                    "title_element": "h1",
                    "title_style": "heading-large",
                    "text_align": "center"
                  }
                },
                {
                  "type": "text",
                  "props": {
                    "content": "<p>A short descriptive subtitle for the hero section.</p>",
                    "text_style": "text-lead",
                    "text_align": "center"
                  }
                },
                {
                  "type": "button",
                  "props": {
                    "button_size": "large",
                    "text_align": "center"
                  },
                  "children": [
                    {
                      "type": "button_item",
                      "props": {
                        "content": "Learn more",
                        "link": "#contact",
                        "button_style": "primary"
                      }
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

Notes on this example:
- The root is the `layout` object — confirmed by 78/78 real files, see above.
- Only the `section` carries `name` ("Hero"). `row`, `column` and every leaf node (`headline`,
  `text`, `button_item`) do not — in observed practice `name` never goes below the `section` level.
- `headline`, `text` and `button_item` — all leaf nodes — **have no `children` key**, not even
  `[]`. Only `button` (a container) carries it, populated.

## JSON validation

Checklist before importing into the builder:

1. The JSON is syntactically valid.
2. Root: the **object** `{"type":"layout", "version":"...", "children":[...]}`. The root-array
   format has no real confirmation — avoid it as a default (see
   `issues/root-format-object-not-array.md`).
3. **No node-level `id` fields.**
4. Every node has `type` and `props` (an object, possibly empty).
5. **`children`**: present and populated (array) on container nodes; **absent entirely** (not
   `[]`) on leaf nodes — see `issues/children-key-leaf-nodes.md`.
6. `props` is always an object (never null).
7. `type`s are bare names — **no `builder_` prefix**.
8. Select-field values match the documented valid options.
9. `image` is a **string** (path), not an object.
10. `link` is a **string** (URL or path), not an object.
11. No `null` values.
12. `row.layout` / `column.width_*` fractions only from the valid list (never twelfths).
13. **`name`**: only on `section` (sibling key of `type`, never inside `props`).

Mechanical check (from this skill's base directory):

```bash
bash ../builder/scripts/validate.sh layout.json
```

## Importing into the builder

1. WordPress admin (or Joomla administrator) → YOOtheme → Builder.
2. Open the page in the builder and open the Library.
3. Choose **Import**, then upload the `.json` file (or paste it where supported).
4. Check the preview before saving.
