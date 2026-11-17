---
title: advanced prop group
type: prop
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]", "[[sources/yootheme-pro-5.0.53-source]]"]
tags: [props, cross-cutting, advanced, css, id, class, name]
updated: 2026-10-30
---

# The `advanced` prop group

Eight props that almost every element carries, defined once in the shared field library at
`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:5-70` and pulled into each element
through a single `'${builder.advanced}'` reference in its `fieldset`.

```php
'advanced' => [
    'title' => 'Advanced',
    'fields' => ['name', 'status', 'source', 'id', 'class', 'attributes', 'css', 'transform'],
],
'advancedItem' => [
    'title' => 'Advanced',
    'fields' => ['name', 'status', 'source', 'id', 'class', 'attributes', 'css'],
],
```

Item types — `grid_item`, `slideshow_item`, `button_item`, … — reference `advancedItem` instead.
The only difference is **`transform`, which items do not have**: transforming a node into a
different element type is an element-level operation.

## The eight props

| Prop | Type | Stored value | Notes |
|---|---|---|---|
| `name` | text | free string | Builder-only label, to identify the node in the layout tree. No effect on output. **Not stored in `props`** — see the callout below |
| `status` | checkbox | `'disabled'` or `''` | **Not a boolean.** Disabled nodes stay in the JSON and are skipped at render |
| `source` | fields | object | Dynamic content binding. Not a plain scalar — see below |
| `id` | text | free string | The **HTML `id` attribute**. See the disambiguation below |
| `class` | text | space-separated | Extra CSS classes. Field key in `element.php` is `class`, library key is `cls` |
| `attributes` | code editor | `name=value` per line | Arbitrary HTML attributes |
| `css` | code editor, `mode: css` | CSS text | Auto-scoped — see below |
| `transform` | button | — | A builder UI action, not stored state |

`id`, `class`, `attributes`, `css` and `source` are all declared `'source' => true`: they can be
bound to dynamic content.

## `name` is a node-level key, not a `props` key — the second trap

Seven of the eight props above are genuinely serialised inside `props`. **`name` is the
exception.** In the real PHP field declaration it looks like any other advanced field —
`'name' => '${builder.name}'` in the element's `fields` array — but on export it lands as a
**sibling of `type`/`props`/`children`** at the node's own level, not nested inside `props`.
Confirmed against real exports, not inferred: `skills/json-schema/examples/example-layout.json:4-7`
and every section of every page in `raw/websites-demo/dennis-miller/*.json` serialise it the same
way:

```json
{
  "name": "Hero",
  "type": "section",
  "props": { "header_transparent": true },
  "children": []
}
```

`{"type": "section", "props": {"name": "Hero"}, "children": []}` is the wrong shape — it imports
without error (an undeclared `props` key is silently inert, per
[[recipes/service-card-grid]] "Gotcha: inert props survive an export"), but the builder never
reads it, so the layer keeps its default outline label. The value is a free-form human label
("Hero", "About", "Call to Action" in the demos) describing the node's role for the builder's
outline panel — it does not need to match the rendered heading text.

## `id` is not the node `id` — the trap

`CLAUDE.md` and [[sources/skill-yootheme-json-schema]] both state, correctly, that **a builder node
has no `id` field**. Nodes are identified by position, and adding `"id"` beside `"type"`, `"props"`
and `"children"` is invalid.

An element *prop* named `id` nonetheless exists, and it is an entirely different thing: the value of
the HTML `id` attribute on the rendered element. It is legal, and it belongs inside `props`.

```json
{
  "type": "section",
  "props": { "id": "contatti" },
  "children": []
}
```

That snippet is valid — it renders `<div id="contatti" class="uk-section-default">`. Anchor links
to `#contatti` are precisely what it is for.

```json
{
  "type": "section",
  "id": "abc123",
  "props": {},
  "children": []
}
```

That one is not. Both rules hold simultaneously: **no `id` key on the node, an optional `id` key
inside `props`.**

## `status` is a string

The checkbox declares `'true-value' => 'disabled'` and `'false-value' => ''`, so the serialised
value is one of two strings:

```json
{
  "type": "panel",
  "props": {
    "status": "disabled"
  }
}
```

Writing `"status": true` does not disable anything. The node still occupies its slot in the layout
and reappears when re-enabled — disabling is not deletion.

## `css` is auto-scoped — by generated ID, not by class

The `css` field is declared inline in each `element.php` rather than shared, because its
`description` and `attrs.hints` list the element's own placeholder selectors:

| Element | Placeholder selectors offered |
|---|---|
| `section` | `.el-section` |
| `panel` | `.el-element`, `.el-title`, `.el-meta`, `.el-content`, `.el-image`, `.el-link`, `.el-hover-image` |
| `grid` | the panel set plus `.el-nav` and `.el-item` |

`.el-item` and `.el-nav` exist on `grid` and not on `panel` because a grid renders repeated items
and a filter navigation; see [[elements/grid]].

`ElementTransform::customCSS()` and `::prefixCSS()`
(`packages/builder/src/Builder/ElementTransform.php:296-420`) show how the scoping actually works,
and it is not what the `.el-*` naming suggests:

1. **If the element has no `id`, one is generated** — `getUniqueId()` produces `<prefix>#<n>`. So
   filling in the `css` field silently gives the element an HTML `id` it did not have
2. `.el-element`, `.el-section`, `.el-row` and `.el-column` are **replaced** by `#<that-id>`
3. **Any other selector is prefixed with `#<that-id> `** as a descendant, not left alone
4. The compiled CSS is then hoisted onto the **root node** of the layout, not emitted in place

The distinction that matters: **only those four are placeholders.** `.el-title`, `.el-meta`,
`.el-content`, `.el-image`, `.el-link`, `.el-item`, `.el-nav` and `.el-hover-image` are **real
classes emitted on the sub-parts** by the templates, and they are not substituted — they are simply
scoped as descendants like any other selector.

```css
.el-element { border: 1px solid; }   →  #el-abc123 { border: 1px solid; }
.el-title   { letter-spacing: .04em; } →  #el-abc123 .el-title { … }
a           { color: red; }          →  #el-abc123 a { … }
```

So the field **cannot leak to the whole page**. What it can do is reach deeper than intended: a bare
`a` styles every link inside the element, nested elements included.

The hint list is also not an inventory of what the templates emit — `el-slidenav`, `el-overlay` and
`el-dialog` appear in the source without being offered as hints. Reading the element's templates is
the only way to know every hook available.

The field's main operational use in generated layouts is making a snippet style-self-sufficient —
e.g. an eyebrow label styled via `.el-element` or `.el-meta` instead of a theme LESS class: see
[[recipes/eyebrow-label]].

`prefixCSS()` recurses, so nested at-rules such as `@media` are prefixed correctly inside.

**Before 5.0.51 `@keyframes` was broken.** The old parser treated every brace block as a rule, so
keyframe steps were scoped too — `@keyframes pulse { #el-x from{…} #el-x to{…} }` is invalid CSS and
the animation silently does nothing. A comment containing braces (`/* a { b } */`) also made the
**next** rule escape scoping. Both were confirmed by running the 5.0.43 and 5.0.53 functions on the
same input — see [[sources/yootheme-pro-5.0.53-source]]. Since 5.0.51 only `@media`, `@supports`,
`@container`, `@layer`, `@starting-style` and `@scope` are recursed into; every other at-rule
(`@keyframes`, `@font-face`, `@property`…) is kept verbatim. On a site older than 5.0.51, put
keyframes in the theme LESS, not in the element `css` field. Braces inside CSS strings
(`content: "{"`) can still confuse the parser on any version.

## `attributes` cannot set `id` or `class`

`::customAttributes()` (`:274-291`) parses one `name=value` per line and explicitly skips `id` and
`class`:

```php
if ($name && !in_array($name, ['id', 'class'])) { … }
```

Use the dedicated `id` and `class` props for those. Quotes around a value are stripped; a name with
no `=` becomes a boolean attribute.

## `source` is an object, not a scalar

Defined in `packages/builder-source/config/builder.php:4`, `source` is `'type' => 'fields'` and
expands into `_source`, `_sourceArgs`, `_sourceField` and related keys. It is the dynamic-content
binding, and it is the one member of the group that does not serialise to a simple string. A
concepts page on the sources API is still to be written.

## Where the group is absent

Not every element carries all eight. Reading the `fields` arrays of the pilot elements:

- `section` declares `status` **inline** rather than taking the shared one, so it can reword the
  label to "Disable section". Same stored values
- `section` has no `transform` — it is a container, not a transformable element
- `grid_item` uses `advancedItem`, so no `transform`

Always check the element's own `fields` array rather than assuming the full group.

### `row`, `column` and the page `layout` wrapper have no `name` at all

Confirmed by reading every `fields` array under `raw/yootheme-pro-5.0.33/packages/builder/elements/`
(51 element directories): **48 declare `name` or `nameItem`. Three do not, and they are the only
three in the whole builder:**

- `row/element.php:359-362` — its Advanced panel is hand-built, not the shared reference:
  `['title' => 'Advanced', 'fields' => ['status', 'source', 'id', 'class', 'attributes', 'css']]`.
  No `name`, no `transform`
- `column/element.php:258-261` — same pattern, even leaner:
  `['title' => 'Advanced', 'fields' => ['source', 'id', 'class', 'attributes', 'css']]`. No `name`,
  no `status`, no `transform`
- the page-level `layout` node (the object wrapper `{"type": "layout", "props": {}, "children":
  [...], "version": ..., "name": ...}` used for a full-page export — see
  [[sources/skill-yootheme-json-schema]]) is a pure structural container (`'container' => true`)
  with **no `fields` array whatsoever** — no Advanced panel, no `name` field on the *element*
  definition. The `name` key that *does* appear at that root level is page metadata (the saved
  page's title), unrelated to this per-node mechanism

**`panel`, despite being usable as a container** (offcanvas/modal targets), is not an exception —
it declares `name` like the other 48. Every element used in a typical generated layout (`section`,
`headline`, `text`, `image`, `button`/`button_item`, `grid`/`grid_item`, `table`/`table_item`,
`list`/`list_item`, `map`/`map_item`, `fragment`, and all the others in
[[sources/skill-yootheme-json-schema]]'s element table) supports `name`. Only `row` and `column`
— the two most structurally common node types in any layout — do not.

### Correction (2026-09-08): declarable ≠ populated — real exports name almost only `section`

The paragraph above is correct about what the `fields` array *declares* (a UI capability), but an
earlier version of this page used it to recommend **generating a `name` value on every eligible
node** in produced JSON. That recommendation was wrong, caught only after it produced a layout that
failed to import (see [[issues/name-prop-node-level]] for the full incident).

Two independent real-file counts settle what real exports actually do:

- `raw/websites-demo/dennis-miller/*.json` (8 files): of ~41 nodes carrying `name`, **36 are
  `section`**. The 5 exceptions are single, isolated instances on `list`, `social` and `image` —
  a node a human specifically renamed in the outline for its own reason, not a rule
- A second, independent real export (YOOtheme 5.0.43, unrelated to this wiki's corpus): **100%** of
  `name` instances are on `section` (or the page-root `layout` wrapper) — zero exceptions across
  `row`, `column`, `grid`, `grid_item`, `headline`, `text`, `image`, `button`, `button_item`,
  `fragment`, `gallery`, `gallery_item`, `panel`, `divider`, `overlay-slider`,
  `overlay-slider_item`

So: the field being declarable on 48 element types means a human *can* rename any of them in the
outline when it's useful to tell two similar nodes apart. It does not mean a generator should
populate it everywhere by default. **Generate `name` only on `section` nodes.**

## Related

[[props/margin]] · [[props/link]] · [[elements/section]] · [[elements/grid]] · [[elements/panel]] ·
[[recipes/eyebrow-label]] · [[issues/name-prop-node-level]]
