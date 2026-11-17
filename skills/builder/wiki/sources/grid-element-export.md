---
title: source — Grid example.json (single element export)
type: source
status: verified
yootheme_version: "5.0.51"
sources: []
tags: [source, library, export, grid, element]
updated: 2026-10-14
---

# Source: `raw/element-export-grid-example.json`

Real export of one `grid` element (5 colour cards, `grid_item` children) from the Builder, provided by
the user. Captured through `raw/observations/2026-10-14-single-element-export-format.md`.

## What it states

- Root is the **element itself** (`type: "grid"`), not a `layout` wrapper.
- Three extra root keys next to `type`/`props`/`children`: `name` (library label), `modified` (ISO 8601 with
  milliseconds), `version` (string, installed theme version at export time — here `5.0.51`).
- `props` holds the **complete** prop set with defaults (e.g. `filter_*`, `lightbox_bg_close`,
  `link_text: "Read more"`, `title_hover_style`), not just the modified ones.
- `grid_item` leaves carry only `content`, `meta`, `title` and **no `children` key** — consistent with
  [[issues/children-key-leaf-nodes]].
- No `id` fields, no `null`.

## What it confirms

The `{name, type, version}` destructuring of the Element Library import in
[[concepts/library-import-version-check]]: this file supplies all three.

See [[concepts/single-element-export-format]] and [[recipes/single-grid-element-export]].
