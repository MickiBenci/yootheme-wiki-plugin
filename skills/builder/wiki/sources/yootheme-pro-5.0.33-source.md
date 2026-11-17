---
title: YOOtheme Pro 5.0.33 theme source
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/yootheme-pro-5.0.33/MANIFEST.md"]
tags: [source, primary, builder, elements]
updated: 2026-07-29
---

# YOOtheme Pro 5.0.33 theme source

The **primary source of the whole wiki**. A curated, text-only extraction of the YOOtheme Pro
5.0.33 WordPress theme source lives at `raw/yootheme-pro-5.0.33/` — 432 PHP files, 3 LESS files,
the changelog. Provenance, inclusion rules and checksums are in `raw/yootheme-pro-5.0.33/MANIFEST.md`.

Version 5.0.33 was released **2026-05-21**. Anything read directly from these files is `verified`.

## Why this outranks everything else

YOOtheme Pro is proprietary and its public documentation is partial. Every other kind of evidence
the wiki can hold — exported JSON, forum posts, the authoring skills — is downstream of this code.
`element.php` is not a description of an element's props: it *is* the definition the builder reads.

Consequence, stated in `CLAUDE.md`: where the source and a skill disagree, the source wins in the
wiki, the skill is never edited, and the divergence is filed in `issues/`. See
[[issues/element-types-skill-vs-source]].

## How the source is organised

### `element.php` — the field definition

One per element, at `packages/<package>/elements/<name>/element.php`. It returns a PHP array:

| Key | What it holds |
|---|---|
| `name` | The element `type` as it appears in layout JSON — `panel`, `grid_item`, … |
| `title`, `group`, `icon` | Builder UI metadata only. No effect on output |
| `element` | `true` for elements a user can insert. Absent on structural containers and on item types |
| `container` | `true` if the node accepts arbitrary `children` (`section`, `grid`, `row`, `column`) |
| `defaults` | **Values the builder applies when the prop is absent.** Not the same as "empty" |
| `placeholder` | Dummy content shown for a freshly inserted element. Never present in exported JSON |
| `updates` | Path to `updates.php` — the prop migrations |
| `templates` | `render` (front end) and `content` (builder preview) |
| `transforms` | PHP callbacks run on the node before rendering. Where undocumented behaviour hides |
| `fields` | **The authoritative prop list.** One entry per prop |
| `fieldset` | How fields are grouped into tabs and panels in the builder UI. No effect on output |
| `panels` | Sub-dialogs. Their fields are still **flat props on the same node** |

A `fields` entry is either an inline definition or a `'${builder.<name>}'` reference into the shared
library — see [[props/advanced-group]].

Field keys that matter when reading props:

- `type` — `select`, `checkbox`, `editor`, `image`, `video`, `icon`, `link`, `number`, `range`,
  `color`, `gradient`, `hidden`, `content-items`, `button-panel`. Absent means a plain text field
- `options` — for `select`, a `label => stored value` map. **The stored value is what goes in JSON**,
  and it is frequently `''`
- `enable` / `show` — a JS-ish expression gating the field in the builder UI. It documents prop
  interdependencies, and it is the fastest way to learn which props are mutually exclusive
- `source` — `true` when the field can be bound to dynamic content
- `attrs` — placeholders, min/max, and the `hints` list for the `css` field

### `templates/*.php` — the emitted markup

`template.php` is the render entry point; siblings such as `template-media.php` handle sub-parts.
Classes are declared with an interpolation mini-language:

- `'uk-section-{style}'` — substitutes the prop value
- `'uk-section-overlap {@overlap}'` — emitted only if the prop is truthy
- `'uk-{text_color}' => $cond` — the PHP value is an extra condition
- `'{@panel_style: card-.*}'` — emitted only if the prop matches the pattern
- `'[uk-card-{!panel_padding: |default}]'` — brackets group; `!` negates; `|` separates alternatives

Reading these is the only reliable way to know which UIkit classes a prop actually produces.

### `updates.php` — when a prop changed

Keyed by the version that introduced the change, with a callback mutating the node. This is the
evidence for every "since version X" claim in the wiki. Example, from
`packages/builder/updates.php`, version `5.0.0-beta.0.7`: `margin` was split into `margin_top` and
`margin_bottom`, and `push` became `margin_bottom: auto`. See [[props/margin]].

### `packages/builder/config/builder.php` — the shared field library

Every `'${builder.x}'` reference resolves here. It defines the cross-cutting props that appear on
most elements: the `advanced` group, `margin_top`/`margin_bottom`, `position*`, `maxwidth*`,
`block_align*`, `text_align*`, `animation`, `visibility`, `link`, `html_element`. See
[[props/advanced-group]], [[props/margin]], [[props/link]].

## Element inventory

75 elements across five packages. `packages/builder/` holds the 51 platform-independent ones;
the rest are WordPress-, WooCommerce- and newsletter-specific. Full list in the MANIFEST.

## Pages built from this source so far

[[elements/section]] · [[elements/grid]] · [[elements/grid_item]] · [[elements/panel]] ·
[[props/advanced-group]] · [[props/margin]] · [[props/link]] · [[uikit/uk-card]] · [[uikit/uk-grid]]

## What this source does not tell you

- **Runtime UIkit behaviour.** The templates emit classes and `uk-*` attributes; what those *do* is
  UIkit's business — see the [[uikit/uk-grid]] and [[uikit/uk-card]] pages
- **Which props are used in practice.** Field definitions describe the possible, not the sensible.
  Real usage comes from exported layouts — see [[sources/production-layout-sample]]
- **Joomla differences.** This is the WordPress build

## How to cite it

Point at the file and, where it helps, the line range:
`raw/yootheme-pro-5.0.33/packages/builder/elements/panel/element.php:13-31`. Paths mirror a live
install exactly, so a citation stays valid against the real theme.
