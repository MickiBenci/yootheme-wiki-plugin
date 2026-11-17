---
title: skill prop tables vs theme source
type: issue
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/skill-yootheme-json-schema]]", "[[sources/production-layout-sample]]"]
tags: [issue, resolved, skill, divergence]
updated: 2026-07-29
---

# Skill prop tables vs the theme source

**Resolved 2026-07-29 — option 2 applied with the user's approval. See Resolution below.**

Comparing the prop tables in the skills against `element.php` in
[[sources/yootheme-pro-5.0.33-source]] turns up divergences of three different kinds. Only the first
is a contradiction; the other two are gaps and ambiguities. Per `CLAUDE.md` the skills have not been
touched.

Scope so far: the four pilot elements — `section`, `panel`, `grid`, `grid_item` — plus the shared
field library. Twelve of the remaining 71 elements have not been checked.

---

## A. Contradictions — a stated value is wrong or incomplete

These matter: following the skill produces JSON that silently does not do what was intended.

### A1. `margin_top` / `margin_bottom` are missing two values

`yootheme-json-schema/references/element-types.md:44-45` lists
`'' small default medium large xlarge remove`.

`packages/builder/config/builder.php:179-212` defines
`'' xsmall small default medium large xlarge remove auto`.

**`xsmall` and `auto` are absent from the skill.** `auto` is not cosmetic: it is what makes a card's
link sit on a common baseline across a row of unequal cards. See [[props/margin]].

### A2. `position` is missing `relative`

The skill's global table (line 58) lists `'' 'absolute'`.

`builder.php:100-110` defines `'' 'relative' 'absolute'` — Static, Relative, Absolute. `relative`
offsets an element while keeping it in the flow, which is a materially different behaviour from
`absolute`.

### A3. `grid.panel_style` is missing `tile-checked`

The skill's grid table (line 641) lists ten values, the same ten as `panel`.

`elements/grid/element.php:618-635` defines **eleven** — the extra one is `tile-checked`,
alternating `uk-tile-default` and `uk-tile-muted` across items. It is grid-only, and it is the one
panel style that loads JavaScript (`element.php:118-123`). See [[elements/grid]].

### A4. `image_loading` polarity is inverted in the description

The skill's global table (line 61) reads *"bool `false` — disables lazy loading on the element
image"*.

The source (`grid/element.php:1119-1126`, and the same wording on every element that has it) is a
checkbox labelled **"Load image eagerly"**, with the description *"By default, images are loaded
lazy. Enable eager loading for images in the initial viewport."*

So `image_loading: true` means **eager**. Reading the skill's phrasing as "set it to false to
disable lazy loading" gets the polarity backwards, and lazy-loads the hero image.

### A5. `grid.show_*` — three of the eight switches are missing

The skill (line 646) lists `show_title show_meta show_content show_image show_link`.

`grid/element.php:14-22` defines eight, all defaulting to `true`:
**`show_video`, `show_hover_image`, `show_hover_video`** are also there — and
[[sources/production-layout-sample]] sets all three explicitly on every grid, so this is not a
theoretical gap.

### A6. The `id` field in the import/export example

`import-layout/references/import-export-format.md:10-18`, a **non-canonical** skill, shows the
export format as:

```json
[ { "type": "section", "id": "...", "props": { }, "children": [ ] } ]
```

That `id` contradicts the invariant stated in `CLAUDE.md` and in
[[sources/skill-yootheme-json-schema]] — both of which say a node has no `id`.

The source agrees with the invariant: `Builder/IndexTransform.php` derives a positional `data-id`
path at render time (`prefix#root`, then `prefix#-…`), so node identity is positional and nothing is
stored. `Builder/NormalizeTransform.php` carries unknown keys through untouched, which is why an
`id` key does no visible harm — it is simply ignored.

**Two skills in the same plugin disagree with each other.** The canonical one is right.

---

## B. The root shape is two formats, not one

Not a contradiction so much as a missing distinction, and it affects every snippet the wiki writes.

| Format | Shape | Where it occurs |
|---|---|---|
| **Section import/export** | `[ {section}, … ]` — a root **array** | The builder's Import tab, the layout library, `.json` files exchanged between sites |
| **Stored page layout** | `{ "type": "layout", "props": {}, "children": [sections] }` — a root **object** | What the builder saves; what an exported full-page layout file contains |

Evidence for the second: `Builder::load()` at
`packages/builder/src/Builder.php:88-97` returns `null` unless the decoded root **is an object**, and
defaults an empty `type` to `'layout'`. There is a `layout` element type
(`elements/layout/element.php`) with `'container' => true` and no fields at all — a pure wrapper.

Confirmed on the real file: `raw/implementations-sample/<client-site>/layout.json` has a
`layout` object at its root, not an array.

Both skills describe the array form, correctly, for section import. Neither mentions the layout node.
The wiki's own snippets stay with the array form, as `CLAUDE.md` requires.

---

## C. Gaps — props the skill simply does not list

Not errors. The skill's tables are a curated "props worth using" subset, which is right for an
authoring skill and misleading if read as a reference. Recorded so the element pages are known to be
the fuller account.

`section` alone: `title`, `title_position`, `title_rotation`, `title_breakpoint`, `overlap`,
`width_expand`, `padding_remove_horizontal`, `background_color`, `header_transparent_noplaceholder`,
`header_transparent_text_color`, `html_element`, `media_focal_point`, `media_blend_mode`,
`media_visibility`, `image_width`, `image_height`, `image_loading`.

`grid`: the seventeen `filter_*`, the twelve `lightbox_*`, `grid_masonry`, `grid_parallax*`,
`title_display`, `content_display`, `panel_content_width`, `container_padding_remove`.

`grid_item`: `video`, `hover_image`, `hover_video`, `image_alt`, `link_aria_label`, `item_element`,
`link_style`, and the three focal-point props.

Roughly: the skill covers 30–40% of the prop surface of the large elements. Reasonable for authoring,
which is why the element pages extend rather than replace it.

---

## Decision needed

The wiki now carries the fuller and more accurate account. What should happen to the skills?

1. **Leave them, rely on the wiki.** The skills stay lean authoring guides; the wiki is the
   reference. Cost: A1–A6 keep producing subtly wrong JSON when the skill is used without the wiki
2. **Patch only the contradictions (A1–A6).** Six small edits, no restructuring. The gaps in C stay
   as they are, deliberately
3. **Regenerate `element-types.md` from the source.** Complete and accurate, but ~10× longer and no
   longer a curated authoring guide — arguably a different artefact

Recommendation: **option 2.** A1–A6 are cheap to fix and each is a real defect; C is a legitimate
editorial choice that the wiki now backfills.

Whatever is decided, `CLAUDE.md` forbids the wiki from editing the skills — this needs the user's go-ahead.

---

## Resolution (2026-07-29)

The user approved **option 2** plus documenting the root formats (B). Skill bumped to **v2.1.0**,
`skills/json-schema/` patched:

- **A1–A5** fixed in `references/element-types.md`: `xsmall`/`auto` added to `margin_top` (global
  table and `row`), `relative` added to `position`, `image_loading` polarity corrected to "Load
  image eagerly", `tile-checked` added to `grid.panel_style` (flagged grid-only), the three
  missing `show_*` switches added to `grid`.
- **B** documented in `SKILL.md` (Struttura Root — due formati) and `references/schema-spec.md`.
- **A6** stays open only for the non-canonical `import-layout` skill, which is outside this repo's
  scope. But the check surfaced something worse: **`references/schema-spec.md` in the canonical
  skill itself was a pre-2.0 relic** mandating UUID `id` fields, `builder_*` type prefixes,
  object-valued `image`/`link` and `items` arrays in `props` — contradicting the invariants of its
  own `SKILL.md` wholesale. The file was rewritten from scratch against the canonical invariants
  and the 5.0.33 source.
- **C** (the curated gaps) remains a deliberate editorial choice: the skill stays a lean authoring
  guide, the wiki element pages are the fuller reference.

The `CLAUDE.md` policy changed accordingly: the canonical skills are no longer immutable — they can
be edited **only with the user's explicit approval**, contradictions still routed through an
`issues/` page first, and the two copies kept in sync.

## Affected pages

[[props/margin]] (A1) · [[props/advanced-group]] (A2, A6) · [[elements/grid]] (A3, A5) ·
[[elements/section]] (A4, C) · [[elements/grid_item]] (C) · [[elements/panel]] (C) ·
[[recipes/service-card-grid]] (B)
