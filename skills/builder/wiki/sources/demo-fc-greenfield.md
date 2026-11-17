---
title: fc-greenfield demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/fc-greenfield/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-fc-greenfield/"]
tags: [source, demo, sports, fragment, sticky-cover, video]
updated: 2026-07-29
---

# fc-greenfield demo

A football club — team, facility, membership. 5 pages, 618 nodes, 28 element types. `home.json` at
207 nodes is the largest single page in the corpus. Part of [[sources/websites-demo]].

## Element mix

`column` 140 · `row` 84 · `headline` 82 · `grid_item` 62 · `image` 39 · `panel` 31 · `section` 26 ·
**`fragment` 24** · `text` 22 · `grid` 13 · `popover` 1 (+5 items)

The corpus's heaviest `fragment` user, and one of two demos (with glowbar) using
`sticky: "cover"` sections. `popover` — image hotspots with floating labels — appears nowhere else.

## What it teaches

- **`fragment` is the animation/binding wrapper.** The `the-club` history timeline wraps each
  year's `row` in a `fragment` carrying `animation: "parallax"` — one prop animating a whole
  composition. On `home`, fragments carry `source` bindings (21 `panel` nodes bound via `#parent`
  from `matches.customMatches` / `teams.customTeams`) — match fixtures as repeating bound blocks
- **Video hero with stacked viewport units**: section `height_viewport: "80"` + `video` background +
  inner row `height_viewport: "100"` (`the-club.json`) — the section shows 80vh of a 100vh-sized
  composition
- **`height_viewport` as a *boolean* on `image`** (`true` ×6) — sizing an image element to the
  viewport, distinct from the section-level percentage form
- **Giant watermark type**: headlines pushed to `font-size: 400–490px` with `opacity: 0.06` via
  scoped CSS — display typography as texture, far beyond the `heading-*` scale
- `title_element: "div"` ×80 against 63 `title_style: "h5"` — statistics and labels styled as
  headings with no heading semantics, the corpus's decoupling pattern at its most extreme
- `column.style: "card-default"`/`"card-primary"` ×7 — the column-as-card technique (see the
  corrected note in [[sources/websites-demo]])
- Mirrored `visibility` pairs (`s` 17 / `hidden-s` 15) — per-breakpoint element duplication

## `css` usage — 22 nodes, 3,6%

`image` 11 · `headline` 7. Two idioms: `pointer-events: none` ×6 on decorative overlays (the
[[sources/demo-dennis-miller]] pair), and the watermark font-size media queries above. See
[[concepts/custom-css-boundary]].

## The theme — `master-fc-greenfield`

The longest `_import.less` in the corpus at 645 lines.

| | |
|---|---|
| fonts | Sofia Sans Semi Condensed body / Sofia Sans Extra Condensed headings |
| `@global-font-size` | `18px` — the largest base size in the corpus |
| palette | `#060D46` navy text, emphasis and link `#FF3E3E` red, primary `#FF5353` |
| `@global-primary-text-transform` | `uppercase` |
| `@global-2xlarge-font-size` | `55px` |
| `@global-border-radius` | `8px` |

Condensed uppercase headings at 18px base — the sports-poster look is all theme; the JSON only picks
sizes. 5 variants including `dark-blue`.

## Caveats

**The corpus's most version-scattered demo**: `5.0.0-beta.2.1` (×2), `5.0.0-beta.12`, `5.0.3`,
`5.0.17` — no page newer than 5.0.17. Props seen here are the most likely in the corpus to have
been migrated since; check `updates.php` before reuse.
