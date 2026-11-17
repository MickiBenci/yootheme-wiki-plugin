---
title: AI layout generation
type: concept
status: inferred
yootheme_version: "5.0.33"
sources: ["[[sources/yooforged-ai-guide-2026]]", "[[sources/yootheme-pro-5.0.33-source]]", "[[sources/yootheme-pro-5.0.43-source]]"]
tags: [ai, tooling, json, schema]
updated: 2026-09-08
---

Why generating YOOtheme JSON with an LLM fails naively, and which properties of the format make it
tractable with the right constraints. **Most of this page is `inferred`**: the framing and the
pipeline pattern come from a single third-party marketing source
([[sources/yooforged-ai-guide-2026]], written by the founder of the YOOforged tool). The section on
CMS-agnostic schema is the exception — it is checked against the theme source and marked as such.

This page matters to this wiki directly: producing valid, importable JSON is the wiki's own primary
use case, and the failure modes below are exactly what the canonical `json-schema` skill
invariants prevent.

## Why generic LLMs fail

Asked cold for "a YOOtheme hero section as JSON", a generic LLM produces *plausible* JSON, not
*YOOtheme* JSON (inferred, but consistent with the skill's invariants):

- **Invented element types** — e.g. `hero`, `call_to_action`. No such types exist; the in-scope
  vocabulary is a closed set of 59 types defined by `element.php` files
- **Invented or misnamed props**, missing required fields, broken nesting
  (section → row → column → element is not optional structure)
- **Invalid column widths** — `row.layout` only accepts the fixed UIkit fraction list, never
  twelfths ([[issues/column-width-props]], [[uikit/uk-grid]])
- **Missing column widths** — setting `row.layout` to a fraction split without the matching
  `column.width_*` on each child. The frontend renders from `column.width_*`, not from
  `row.layout` directly; the import migration that would derive one from the other only fires for
  files declaring an old `version`, which a generated file never does. Result: columns silently
  fall back to full width until someone reselects the fraction by hand in the builder — confirmed
  real-world case in [[issues/column-width-props]]

The builder's failure modes are the dangerous part: it either refuses the import or **silently
drops unknown elements**, leaving a section that imports "fine" and renders empty or mangled.
There is no error message pointing at the invalid node.

## Why generation is tractable anyway

The same strictness that breaks naive generation makes constrained generation work (the argument
is the source's; the underlying facts are verified in this wiki):

- **Closed element-type enum** — every valid type is enumerable from the theme source
- **Schema-defined props** — each `element.php` declares every prop, its type, options and
  defaults; validity is mechanically checkable
- **UIkit 3's finite vocabulary** — one canonical way to build a card ([[uikit/uk-card]]), one
  spacing scale, one constrained grid ([[uikit/uk-grid]]). Unlike builders where the same visual
  outcome has many encodings (custom CSS, add-on widgets, theme overrides), YOOtheme output has a
  canonical form, so generated layouts stay editable as if hand-built

## The schema is CMS-agnostic (verified, core elements)

The article claims builder JSON is identical on WordPress and Joomla. Checked against
`raw/yootheme-pro-5.0.33/packages/` ([[sources/yootheme-pro-5.0.33-source]]): the 51 core elements
are defined in `packages/builder/`, which carries no CMS-specific code; `builder-wordpress*`
packages only *add* WordPress elements and sources on top. So for the core vocabulary the schema
is CMS-agnostic by construction — **verified**. The Joomla side itself is absent from the
extraction, so full WordPress↔Joomla equivalence (including platform-specific elements and
dynamic content sources) remains **inferred**.

## Reference pipeline (YOOforged's, inferred)

The architecture the source describes for reliable generation — attributed to YOOforged, not a
YOOtheme fact, but a useful checklist for any generator, this wiki's workflows included:

1. **Classify** the prompt into a section archetype (~50 cover most real prompts)
2. **Template-match** against a curated library of hand-built, schema-valid JSON — start from
   known-good structure instead of generating it from scratch
3. **Generate under constraints** — element types from the enum, props validated against the
   schema, required fields enforced
4. **Normalise** — nesting validation, column-width math, spacing, IDs
5. **Validate before delivery**, retry with corrections on failure — never ship JSON that imports
   but renders garbage

The lesson transfers: when this wiki produces snippets, the equivalent of steps 3–5 is applying
the skill's invariants and preferring structures already observed in `raw/` exports over invented
ones.
