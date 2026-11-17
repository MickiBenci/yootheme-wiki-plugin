---
title: name prop — node-level key, not inside props; row/column don't have it
type: issue
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [issue, correction, name, advanced-group, row, column]
updated: 2026-09-08
---

# `name` — node-level key, not inside `props`; `row`/`column` don't have it

**Status: resolved — wiki and canonical skill corrected 2026-09-08.** Kept as the record of an
imprecise claim and the real mechanism, following the same pattern as
[[issues/column-width-props]].

## The imprecise claim

[[props/advanced-group]] listed `name` as one of the "eight props" of the shared `advanced`
fieldset, in the same table and the same narrative as `id`, `class`, `attributes` and `css` — all
of which genuinely serialise **inside `props`**. The page never called out that `name` behaves
differently, so a generated layout could plausibly (and wrongly) end up with
`"props": { "name": "..." }`. Neither of the two canonical skills (`json-schema`,
`animations`) mentioned `name` at all — it was entirely absent from
`references/schema-spec.md`'s "Nodo Base" section and from `SKILL.md`'s "Required Fields on Every
Node".

## What the real exports show

Structurally verified across `skills/json-schema/examples/example-layout.json` and every
page in `raw/websites-demo/dennis-miller/*.json` (`about.json`, `work.json`, `services.json`,
`contact.json`, `daniel-brighton.json`): **`name` is always a key sibling to `type`/`props`/
`children` at the node's own level**, never nested inside `props`:

```json
{ "name": "Hero", "type": "section", "props": { "header_transparent": true }, "children": [...] }
```

Values observed are short human labels naming the section's role — `"Hero"`, `"About"`,
`"Gallery"`, `"Call to Action"`, `"Socials"`, `"Clients"` — not a copy of the rendered heading
text. Used almost exclusively on `section` nodes in that demo, plus occasional use one level
deeper.

## The actual mechanism, verified in the source

- `raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:5-70` declares the shared
  `advanced` fieldset as `['name', 'status', 'source', 'id', 'class', 'attributes', 'css',
  'transform']` (element-level) and `advancedItem` as the same list minus `transform` (item-level,
  e.g. `grid_item`, `button_item`). Each element's own `element.php` pulls this in via
  `'${builder.advanced}'` (or `advancedItem`) in its `fieldset`, and `'name' =>
  '${builder.name}'` (or `nameItem`) in its `fields` array
- On export, `name` — like the node's own `type` — is written by `NormalizeTransform` at the
  node's own level, not folded into the generic `props` bag the way `id`/`class`/`css` are. This
  is why the two behave differently despite both coming from the same `fields` declaration
- A full grep of every `fields` array under
  `raw/yootheme-pro-5.0.33/packages/builder/elements/` (51 element directories) found **48**
  declaring `name` or `nameItem`. The exceptions are exactly three:
  - `row/element.php:359-362` — hand-built Advanced panel:
    `['title' => 'Advanced', 'fields' => ['status', 'source', 'id', 'class', 'attributes',
    'css']]`. No `name`, no `transform`
  - `column/element.php:258-261` — same pattern, leaner still:
    `['title' => 'Advanced', 'fields' => ['source', 'id', 'class', 'attributes', 'css']]`. No
    `name`, no `status`, no `transform`
  - the page-level `layout` wrapper node has **no `fields` array at all** (`'container' =>
    true`) — no Advanced panel, no `name` field on the element definition. Its own root-level
    `name` (in `{"type": "layout", ..., "name": "Page Title"}`) is unrelated page metadata, not
    this per-node mechanism
- `panel`, despite being usable as a container-like element (offcanvas/modal targets), is **not**
  an exception — it declares `name` like the other 48

## What was corrected

- [[props/advanced-group]] — the `name` table row now states it is not stored in `props`; a new
  callout section spells out the sibling-key shape with a real-export example; the "Where the
  group is absent" section now documents `row`/`column`/`layout` with file:line citations
- `skills/json-schema/references/schema-spec.md` — "Nodo Base" now lists `name` as an
  optional fourth key with the row/column/layout caveat; the "Esempio Completo: Sezione Hero" now
  shows `name` in place on the nodes that support it; the "Validazione JSON" checklist and its
  mechanical check gained a `name`-presence rule
- `skills/json-schema/SKILL.md` — "Required Fields on Every Node", "Prop critiche da
  ricordare", "Generazione JSON valido" and "Import Validation Checklist" all gained a `name`
  note/rule; **version bumped 2.2.0 → 2.3.0**
- `yootheme-wiki/SKILL.md` (top-level orchestrator) — mirrored the same checklist bullet, grep
  check and a new "Common mistakes" table row

## Still open

Nothing for this issue. `builder-wordpress/elements`, `builder-wordpress-source/elements`,
`builder-wordpress-woocommerce/elements` and `builder-newsletter/elements` (menu, search,
breadcrumbs, module, comments, pagination, newsletter, WooCommerce elements) were not grepped —
out of scope for this wiki (WooCommerce is explicitly excluded per `CLAUDE.md`; the others are
unlikely to change the row/column/layout finding but haven't been checked).

## Addendum (2026-09-08, same day): "declarable on 48 types" was over-applied to "populate on 48 types"

The resolution above was correct about *where* `name` lives (a node-level sibling key) but its
practical guidance — "always fill it with a short descriptive label" on every node except
`row`/`column` — went further than the evidence supported, and produced three generated layout
files with `name` on every single node (30+ instances each). One of those files
(`homepage.json`) then failed to import in the user's real YOOtheme installation with
`invalid argument expected string`.

Investigating the failure (user supplied a genuine second reference export, YOOtheme 5.0.43)
surfaced the real pattern: **`name` in actual exports is populated almost exclusively on `section`
nodes.** Re-checking the wiki's own pre-existing corpus (`raw/websites-demo/dennis-miller/*.json`,
8 files) the same day confirmed it independently: 36 of ~41 `name` instances are on `section`, the
remaining 5 are one-off manual renames on `list`/`social`/`image`, not a pattern to replicate. The
new reference file has **zero** exceptions at all — 100% of its `name` instances are `section` (or
the page-root `layout` wrapper).

**Corrected recommendation: generate `name` only on `section` nodes.** The field remains genuinely
declarable on 48/51 element types — a human can still rename any of them by hand in the builder
outline when useful — but a generator should not do this by default. This is now reflected in
[[props/advanced-group]], `schema-spec.md`, and both `SKILL.md` files (canonical skill bumped to
`2.4.0`).

This same investigation also surfaced a second, larger, pre-existing wiki error unrelated to
`name` — see [[issues/children-key-leaf-nodes]] — which is the more likely actual cause of the
import failure.

## Related

[[props/advanced-group]] · [[issues/column-width-props]] · [[issues/children-key-leaf-nodes]] ·
[[sources/skill-yootheme-json-schema]]
