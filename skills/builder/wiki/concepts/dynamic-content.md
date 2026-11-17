---
title: dynamic content — the source node key
type: concept
status: verified
yootheme_version: "5.0.32"
sources: ["[[sources/websites-demo]]", "[[sources/demo-design-escapes]]", "[[sources/demo-line-gallery]]", "[[sources/yootheme-pro-5.0.53-source]]"]
tags: [concept, dynamic-content, source, serialisation, custom-sources]
updated: 2026-10-30
---

# Dynamic content: the `source` node key

How dynamic content is serialised in layout JSON. Verified on 521 nodes across 11 of the 12 demos
in [[sources/websites-demo]] — the [[sources/skill-yootheme-json-schema]] skill does not document
this key, and no other wiki source had shown it.

**`source` is a node key, a sibling of `type`, `props` and `children` — never inside `props`.**

```json
{
  "type": "panel-slider_item",
  "source": {
    "query": {
      "name": "#parent",
      "field": {
        "name": "accommodations",
        "arguments": { "offset": 0, "limit": 6, "order": "date", "order_direction": "DESC" }
      }
    },
    "props": {
      "image":   { "name": "field.intro_image.url" },
      "image_alt": { "name": "field.intro_image.alt" },
      "link":    { "name": "link" },
      "title":   { "name": "title" },
      "content": { "name": "field.accommodation_guests", "filters": { "after": " Guests" } }
    }
  }
}
```

Verbatim from `raw/websites-demo/design-escapes/discover-italy.json`.

## The two halves

**`query`** selects *what content*. Either a named source —
`accommodations.customAccommodations`, `posts.customPosts`, with optional `arguments`
(`id`, `offset`, `limit`, `order`, `order_direction`, `include_children`, `date_range`,
`date_relative*`) — or **`#parent`**, which inherits the enclosing node's query. `#parent` is the
dominant form: 319 of the 521 bound nodes. A query may carry a `field` sub-object to descend into a
relation of the parent record (as above: the category's `accommodations`).

**`props`** maps element props to fields of the selected record. Keys are ordinary prop names
(`title`, `content`, `image`, `link`, `image_alt`, `meta`, even `text_color`); values are
`{ "name": "<field path>" }` with dotted paths (`field.intro_image.url`, `metaString`, `title`),
plus optional **`filters`** transforming the value.

## Query-only nodes set context

37 nodes carry `source` with a `query` but **no `props`** — sections, rows and fragments that only
establish the record for their descendants' `#parent` queries:

```json
"source": { "query": { "name": "accommodationCats.customAccommodationCat", "arguments": { "id": 35 } } }
```

This is how design-escapes builds six structurally identical country pages from one template — the
top sections pin a different category `id`, everything below binds via `#parent`
([[sources/demo-design-escapes]]).

## Filters observed

| Filter | Occurrences | Effect (as observed) |
|---|---|---|
| `search` | 479 | Serialised as `""` almost everywhere — an inert default written out, not a used feature |
| `date` | 85 | Date formatting |
| `before` / `after` | 43 / 42 | Prefix / suffix the value (`"after": " Guests"`) |
| `condition` | 19 | See `_condition` below |
| `limit` | 6 | Truncate |
| `show_empty`, `preserve` | 3 / 1 | Edge-case display control |

Semantics beyond `before`/`after`/`condition` are inferred from the names and values, not from
source-code reading — treat the third column as `inferred` until the sources API is ingested.

## `_condition`: conditional rendering

A pseudo-prop key, not a real element prop:

```json
"props": { "_condition": { "name": "field.match_result", "filters": { "condition": "!!" } } }
```

`"!!"` renders the node only when the field is truthy; `"!"` only when falsy. fc-greenfield uses
the pair on two sibling columns to switch between a played-match and an upcoming-match layout
([[sources/demo-fc-greenfield]]).

## Which elements can bind

Every field declared with `'source' => true` in `element.php` is bindable — which in practice is
nearly every content prop ([[elements/grid_item]]: all its content props). Observed carriers span
20 node types, including `section` (46 — background images and decorative titles from content),
`column`, `fragment`, `divider` and `map_item` (markers from a source). Binding is not an
item-only feature.

## Caveats

- Custom source definitions (`customAccommodations`, `customMovies`, …) are **site configuration**,
  created in the theme's Custom Sources UI — the export references them by name and cannot resolve
  them alone. Importing such JSON on a site without the source renders the static fallback: nothing
- The observed exports are 5.0.0-beta.x–5.0.32; the serialisation matches across all of them
- The builder-side field definitions (`'source' => true`) are in
  [[sources/yootheme-pro-5.0.33-source]]; the runtime that executes queries lives in
  `raw/yootheme-pro-5.0.33/packages/builder-source/` and `packages/builder-wordpress-source/`,
  neither yet ingested — open work
- Since 5.0.44, two bindings on the same node that query the same field with **different**
  arguments or filters each get their own hashed alias (`<field>_<hash>`), and identical ones
  share one selection. Up to 5.0.43 the code compared a new selection only with the *first* child
  of the same name, so a repeat of an already-aliased variant was added again (changelog:
  *"Fix duplicate aliased selections in dynamic-content source queries"*). Read from
  `builder-source/src/Source/SourceQuery.php` — see [[sources/yootheme-pro-5.0.53-source]]. Nothing
  changes in the exported JSON

## Related

[[sources/websites-demo]] · [[sources/demo-design-escapes]] · [[sources/demo-line-gallery]] ·
[[sources/demo-framerate]] · [[sources/demo-oakville]] · [[elements/grid_item]] ·
[[issues/element-types-skill-vs-source]]
