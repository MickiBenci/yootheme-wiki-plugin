---
title: Breadcrumbs — official docs + theme source
type: source
status: verified
yootheme_version: "5.0.43"
sources: ["raw/yootheme-docs-breadcrumbs-element.md", "raw/yootheme-pro-5.0.33/packages/builder-wordpress/elements/breadcrumbs/", "raw/yootheme-pro-5.0.43/packages/theme-wordpress/src/Breadcrumbs.php"]
tags: [source, breadcrumbs, system, wordpress]
updated: 2026-10-13
---

# Breadcrumbs — official docs + theme source

Ingested 2026-10-13 at the user's request: the docs section "Breadcrumbs Element"
(`raw/yootheme-docs-breadcrumbs-element.md`, a condensed WebFetch extraction) cross-read against
the theme code.

**Code read:** `element.php` and `templates/template.php` of the element (identical in 5.0.33 and
5.0.43 — the only diff is an `images/` folder in 5.0.43), the page-level `templates/breadcrumbs.php`
(5.0.33), the `Breadcrumbs::getItems()` class (only in the 5.0.43 extraction, `packages/theme-wordpress/src/Breadcrumbs.php`),
`uikit/src/less/components/breadcrumb.less`, and `CHANGELOG.md`.

## What is new
- First page for this element: [[elements/breadcrumbs]].
- It is a **WordPress system element** (`group: 'system'`, package `builder-wordpress`), not part of
  the 51 core builder elements; items are computed at render time, not stored in JSON.
- Two breadcrumb renderers exist: the element template (schema.org **microdata**) and the theme
  `templates/breadcrumbs.php` (JSON-LD via `Metadata`).

## What it confirms
- The docs list 3 settings (Show Home Link, Show Current Page, Home Text); the code adds the general
  and advanced props inherited from the shared field library.

## Discrepancy (not a contradiction)
- The docs describe "Show Home Link" and "Show Current Page" as separate options with separate
  descriptions; in `element.php` the **single field description** sits on `show_home` ("…home link as
  first item as well as the current page as last item") and `show_current` has only a checkbox label.
  Same behaviour, UI wording differs. No `issues/` page needed.
- The docs' "may collapse" note is confirmed by the template: `<?php if ($items) : ?>` wraps all output.
