---
title: children key wrongly required on leaf nodes — it must be absent, not []
type: issue
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [issue, correction, children, schema-spec, leaf-node]
updated: 2026-09-08
---

# `children` — wrongly required on leaf nodes; must be absent, not `[]`

**Status: resolved — wiki and canonical skill corrected 2026-09-08.** Same pattern as
[[issues/column-width-props]] and [[issues/name-prop-node-level]], but this claim predates this
session — it was already `verified` in the wiki before any of today's changes, which makes it a
more foundational correction than the `name` one.

## The wrong claim

`schema-spec.md`'s "Base node" section stated, as a bolded invariant: **"`children` is always an
array — never `null`, never omitted"** — i.e. every node, including leaf content elements like
`headline`, `text`, `image` and `button_item`, must carry `"children": []`. The same rule appeared
in the "Import Validation Checklist" of both `schema-spec.md` and both `SKILL.md` files ("Every
`children` is always an array, `[]` on leaf nodes too"), and is exactly what all three
generated client layout files (home, contact and about pages) followed.

## How it was caught

`homepage.json` — uploaded directly as a `.json` file, not pasted — failed to import in the user's
real YOOtheme installation with `invalid argument expected string`. The user supplied a genuine
reference export (`Home healt fitness (1).json`, YOOtheme 5.0.43, 111KB) to compare against. An
Explore pass found no classic JSON type mismatch (string vs int/null/array) on any shared prop, but
did find that the reference file's leaf-type nodes (`headline`, `text`, `image`, `button_item`,
`grid_item`, `panel`, `divider`, `gallery_item`, `overlay-slider_item`) carry **no `children` key
at all** — their key-set is exactly `["props","type"]`.

Re-checking the wiki's own pre-existing corpus the same day (`raw/websites-demo/dennis-miller/*.json`,
8 files, independent of the user's file) confirmed it a second time, with zero exceptions:

```
jq '[.. | objects | select(has("type")) | select(.type=="headline" or .type=="text" or .type=="image" or .type=="button_item") | has("children")] | group_by(.) | map({has_children: .[0], count: length})'
```
returned `has_children: false` for every single instance in every one of the 8 files — 126 leaf
nodes total, no exceptions.

**Two independent real sources, ~330+ combined leaf-node instances, zero exceptions either way.**

## The actual mechanism

Neither source's PHP loader/normalize code was read line-by-line for this issue (unlike
[[issues/column-width-props]], which had `template.php`/`updates.php` citations) — the correction
here rests on export evidence, not a traced PHP mechanism. What the evidence supports: YOOtheme's
own export routine only ever emits `children` on node types that are genuinely containers in the
builder (`section`, `row`, `column`, `fragment`, `button`, `grid`, `list`, `map`, `table`, `gallery`,
`overlay-slider`, `accordion`, `switcher`, `panel-slider`, `slideshow`, `nav`, `subnav`, `social`,
and the page-root `layout` wrapper). Leaf/content element types never carry the key, empty or not.
Whether the *importer* would also accept `"children": []` on a leaf node leniently is untested —
what's established is that **real exports never produce that shape**, and a generated file that
does deviates from every real file examined so far, in the one file (`homepage.json`) that is
confirmed to have failed to import.

## What was corrected

- `skills/json-schema/references/schema-spec.md` — "Nodo Base" section rewritten to show
  two distinct node shapes (container vs. leaf); "Regole" and "Validazione JSON" checklist updated;
  the "Esempio Completo: Sezione Hero" example's `headline`/`text`/`button_item` nodes no longer
  carry `"children": []`
- `skills/json-schema/SKILL.md` — "Required Fields on Every Node", "Prop critiche da
  ricordare" → renamed section, "Generazione JSON valido" point 3, "Import Validation Checklist"
  and its mechanical `jq` check all updated; **version bumped 2.3.0 → 2.4.0**
- `yootheme-wiki/SKILL.md` (top-level) — "Validation" section and "Common mistakes" table gained a
  row for this specific mistake
- The three client layout files were regenerated with `children` removed from every leaf
  node

## Still open

`skills/json-schema/examples/example-layout.json` was checked and found **already
correct** on this dimension (zero leaf nodes carry `children`) — it did not need fixing, and stands
as a third independent confirmation. No PHP source citation for the underlying mechanism yet —
if this comes up again, the next step would be reading `NormalizeTransform`/`Builder::load()` in
`raw/yootheme-pro-5.0.33/packages/builder/src/Builder/` to find exactly what happens when a leaf
node is given an empty `children` array on import, rather than relying on export-shape evidence
alone.

## Related

[[issues/name-prop-node-level]] · [[issues/column-width-props]] ·
[[sources/skill-yootheme-json-schema]]
