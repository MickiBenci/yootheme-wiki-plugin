---
title: observation — eyebrow via custom css prop
type: source
status: verified
yootheme_version: "5.0.33"
sources: []
tags: [observation, eyebrow, css, advanced, headline]
updated: 2026-07-29
---

# Observation: eyebrow styled with the element `css` prop

User observation captured on 2026-07-29 in `raw/observations/2026-07-29-eyebrow-custom-css.md`,
prompted by a `/yootheme-wiki` landing-page generation that emitted an eyebrow as a `headline` with
`class: "tm-eyebrow"` — which only works if the active theme defines that class in its LESS.

## What it states

An eyebrow does not need a theme CSS class at all: the element's own `css` prop (advanced group)
can carry the styling, using the internal `.el-*` selectors. The generated JSON becomes
self-sufficient on import — no companion LESS required.

## What it confirms

The whole mechanism was already `verified` in [[props/advanced-group]] from the 5.0.33 source:
`css` is auto-scoped by a generated HTML id (`ElementTransform::customCSS()` / `::prefixCSS()`),
`.el-element` is substituted with `#<id>`, and the real sub-part classes (`.el-title`, `.el-meta`,
`.el-item`, …) are prefixed as descendant selectors. The observation adds no new mechanism — it
applies a verified one to the eyebrow pattern.

## What it corrects

The canonical eyebrow rule (`json-schema/SKILL.md:202`, up to v2.1.0) prescribed
`class: "tm-eyebrow"` as the only styling vehicle, silently depending on the theme's LESS. Resolved
by patching the skill to v2.2.0 — see [[issues/eyebrow-styling-approach]].

## Per-element precision the observation glosses over

The observation cites `.el-item`, `.el-title`, `.el-meta` generically. The hints — and more
importantly the classes the templates actually emit — differ per element
(`headline/element.php:303` in `raw/yootheme-pro-5.0.33/`):

| Element | Selectors for an eyebrow |
|---|---|
| `headline` (standalone eyebrow) | `.el-element` only (plus `.el-link`) — there is no `.el-title` inside a headline |
| `panel` | `.el-meta` (the built-in eyebrow slot via `meta_align: "above-title"`) |
| `grid` | `.el-meta`, scoped per-card via `.el-item` if needed |

Operational pattern filed as [[recipes/eyebrow-label]].

## Raw file

`raw/observations/2026-07-29-eyebrow-custom-css.md`
