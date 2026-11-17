---
title: eyebrow styling approach — theme class vs css prop
type: issue
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/observation-eyebrow-custom-css]]", "[[sources/yootheme-pro-5.0.33-source]]"]
tags: [issue, resolved, eyebrow, css, skill-edit]
updated: 2026-07-29
---

# Eyebrow styling: `tm-eyebrow` theme class vs element `css` prop — **Resolved**

## The problem

Up to v2.1.0, the canonical `json-schema` skill (`SKILL.md:202`) prescribed one styling
vehicle for the eyebrow headline: `class: "tm-eyebrow"`. The class is a **theme convention, not a
YOOtheme built-in** — nothing in the 5.0.33 source or in UIkit defines it. Generated JSON imported
on a theme without that LESS rule renders the eyebrow as a plain unstyled `text-meta` line, with no
error and no hint of why.

## The observation (2026-07-29)

User observation ([[sources/observation-eyebrow-custom-css]], raw in
`raw/observations/2026-07-29-eyebrow-custom-css.md`): the element's own `css` prop can carry the
styling through the internal `.el-*` selectors, so no theme class is needed and the snippet is
self-sufficient. The mechanism was already `verified` in [[props/advanced-group]]; the per-element
selector detail (only `.el-element`/`.el-link` on `headline`; `.el-meta` on `panel`/`grid`) comes
from the element definitions in `raw/yootheme-pro-5.0.33/`.

## Resolution — skill patched to v2.2.0, with the user's explicit approval

The Eyebrow bullet in `SKILL.md` (Prop critiche) now reads, in summary:

1. structure unchanged: separate `headline` (`title_element: "div"`), never `text`, never inline span;
2. **default styling: the `css` prop with `.el-element`** — import-self-sufficient;
3. `class: "tm-eyebrow"` demoted to an alternative for themes that already define the style in LESS;
4. inside cards: the built-in `meta` slot (`meta_align: "above-title"`), refined via `.el-meta` when
   needed.

Applied to `skills/json-schema/` in this repo, `version` bumped 2.1.0 → 2.2.0.
Operational pattern with importable JSON: [[recipes/eyebrow-label]].

## Related

[[recipes/eyebrow-label]] · [[props/advanced-group]] · [[props/meta-family]] ·
[[sources/skill-yootheme-json-schema]] · [[issues/element-types-skill-vs-source]]
