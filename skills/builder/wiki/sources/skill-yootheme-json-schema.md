---
title: skill yootheme-json-schema
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["skills/json-schema/"]
tags: [source, skill, canonical, baseline, schema]
updated: 2026-07-29
---

# skill `json-schema`

The **canonical baseline** for the layout JSON format, declared as such in `CLAUDE.md`. It lives
entirely in this repo, at `skills/json-schema/`, self-contained with no external original
to track. It is deliberately *not* copied into `raw/`: it is cited in place and never restated in
the wiki. Since 2026-07-29 it **can be edited, but only with the user's explicit approval**, routed
through an `issues/` page first (see the edit policy in `CLAUDE.md`).

Written in Italian. Anything summarised here is translated; identifiers stay verbatim.

## Version history

- **v2.0.0** — the version originally ingested.
- **v2.1.0** (2026-07-29, user-approved) — the six contradictions of
  [[issues/element-types-skill-vs-source]] (A1–A6) patched; the two root formats (array vs `layout`
  object) documented; `references/schema-spec.md` **rewritten** — the old file was a pre-2.0 relic
  that mandated UUID `id` fields, `builder_*` type prefixes, object-valued `image`/`link` and
  `items` arrays in `props`, all frontally contradicting the invariants of the skill's own
  `SKILL.md`; a new "Layout da prompt" mode added (brief → section outline → JSON, targeted
  questions only when essential information is missing, no HTML preview step); the mechanical
  validation check (jq/grep) added to the checklist.

## What it contains

| File | Lines | Covers |
|---|---|---|
| `SKILL.md` | 278 | Node shape, hierarchy, the hard invariants, the layout-from-prompt workflow |
| `references/element-types.md` | 1389 | ~34 element types grouped by purpose, with prop tables and importable JSON examples |
| `references/field-types.md` | 279 | How field types serialise into `props` |
| `references/schema-spec.md` | 247 | The two root formats, node grammar, serialisation, validation (rewritten in v2.1.0) |
| `examples/example-layout.json` | — | A complete layout |

## The invariants it establishes

Restated in `CLAUDE.md` and binding on every JSON snippet in this wiki:

- no `id` field on a node — see the disambiguation in [[props/advanced-group]], because an element
  *prop* called `id` does exist and is a different thing
- `props` is always an object, `children` always an array
- `image` and `link` are strings, never objects — see [[props/link]]
- no `null` values anywhere
- `row.layout` uses only valid UIkit fractions, never twelfths

The theme source corroborates all of these.

## Its relationship to the theme source

The skill is an **authoring guide distilled from practice**; [[sources/yootheme-pro-5.0.33-source]]
is the product definition. On everything the wiki has checked so far the skill is correct in
substance — its prop tables are curated subsets, listing the props worth using rather than all of
them.

That curation is the right call for an authoring skill and the wrong assumption for a reference, so
the wiki records the gaps. Where the skill's stated *values* diverge from the source rather than
merely being fewer, it is a contradiction and goes to [[issues/element-types-skill-vs-source]].

## How the wiki uses it

Element pages **extend** the skill, they do not restate it. Each one links back here and adds only
what the skill does not carry: the complete prop surface from `element.php`, the UIkit output read
from the templates, prop interdependencies from the `enable`/`show` expressions, version history
from `updates.php`, and observed real-world usage.

Pages extending it: [[elements/section]] · [[elements/grid]] · [[elements/grid_item]] ·
[[elements/panel]]

## Sibling canonical skill

`skills/animations/` is the second declared baseline, covering
scrollspy, parallax and special effects. Not yet ingested — the `animation`, `animation_delay` and
`item_animation` props surfaced by the pilot pages all belong to it.
