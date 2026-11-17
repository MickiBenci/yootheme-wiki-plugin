---
title: customizer LESS map — the two style mechanisms
type: concept
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/how-to-create-style-json]]", "[[sources/style-export-sample]]", "[[sources/demo-dennis-miller]]", "[[sources/websites-demo]]", "[[sources/yootheme-pro-5.0.43-source]]"]
tags: [concept, customizer, less, style, json, uikit]
updated: 2026-09-08
---

# Customizer LESS map: two distinct style mechanisms

YOOtheme Pro's Customize → Style panel is backed by **two separate mechanisms** that are easy to
conflate. Both are verified from `raw/yootheme-pro-5.0.33/packages/styler/`.

## 1. Physical theme files — `less/theme.<slug>.less`

Handled by `Styler.php::getThemes()`/`getTheme()`. Each file in the child/root theme's `less/`
directory is a complete LESS theme (import chain + variable overrides), selectable in the
Customizer's Style Library. `getMeta()` (`Styler.php:97-125`) parses a header comment for
`Name:`/`Style:`/`Background:`/`Color:`/`Type:`/`Preview:` to populate that library entry.

This is the mechanism `raw/skills-frontend-dev-agent/generate-css/SKILL.md` already targets when it
generates a full `theme.{name}.less`, using the domain-without-TLD slug convention. Use this when the
user wants a **new selectable base theme**, not a one-off override.

## 2. The style Library — `styler.library.{id}`

Handled by `LibraryController.php`. `save()` (lines 16-26) accepts `id` + `style` from a POST and
stores the `style` value verbatim under `storage("styler.library.{id}")` — the PHP side never
validates its internal shape, it's an opaque blob to the backend. `index()` (lines 11-14) returns
the whole `styler.library` map as-is. This is the mechanism behind **custom style export/import** —
the override set a user builds interactively with the Customizer's color pickers, exportable/importable
as JSON, layered on top of whichever base theme is active.

[[sources/how-to-create-style-json]] first documented the shape of that JSON from a real but
truncated export. [[sources/style-export-sample]] is a **second, complete, untruncated** real export
that resolves every open point the first one left:

```json
{
  "style": "joline",
  "less": { "@global-primary-background": "#A75C2F", "@internal-fonts": "~'Cormorant+Garamond:400,500,600,700|Jost:300,400,500|Lato'" },
  "modified": "2026-07-29T14:55:20.985Z",
  "name": "Sample style"
}
```

| Key | Status |
|---|---|
| Exactly 4 top-level keys (`style`, `less`, `modified`, `name`), no more | `verified` — style-export-sample.json is complete, not truncated |
| `style` = the id of the **base theme** being customized, not a project slug | `verified` — `"style": "joline"` matches the real official theme `vendor/assets/uikit-themes/master-joline/`, while `"name": "Sample style"` is the user's own label. These are independent axes |
| `less` values as `@variable: value` overrides, **delta-only** against the base theme | `verified` — every one of the sample style's 46 overrides was checked against `master-joline/_import.less`; each key differs from that theme's default (e.g. `@global-font-family` default `'Open Sans'` → override `'Jost'`), and no variable identical to the default is repeated |
| `modified` format | `verified` as `Date.prototype.toISOString()` — millisecond precision, `Z` suffix, e.g. `2026-07-29T14:55:20.985Z` |

Use this mechanism when the request is "give me the importable style JSON for the Customizer" — see
`SKILL.md` → "LESS from preview" → "Output 2: style.json", which now includes the base-theme
selection and delta-only generation this second export forced.

**Not to be confused with the Builder Library.** This Style Library import path validates only
`name` + `style` and has no `version` field at all. The separate Element/Layout Library import
(Builder → Library) requires a **string** `version` on every imported item and throws
`TypeError: Invalid argument expected string` when it is missing — see
[[concepts/library-import-version-check]].

## The variable whitelist — `config/styler.php`

The authoritative index of every `@`-prefixed variable the Customizer exposes, grouped by UIkit
component, plus an `ignore` list of patterns that are hidden from the Customizer UI (but still valid
LESS variables): `@deprecated`, `@breakpoint-*-max`, `@internal*`, `@heading-primary-*`,
`@heading-hero-*`, `@woocommerce-*`.

Top-level components (each with its own group of `@component-*` patterns — see the file directly for
the full glob list, do not duplicate it here):

`global`, `theme`, `inverse`, `accordion`, `alert`, `align`, `animation`, `article`, `background`,
`badge`, `base`, `breadcrumb`, `button`, `card`, `close`, `column`, `comment`, `container`,
`countdown`, `description-list`, `divider`, `dotnav`, `drop`, `dropdown`, `dropbar`, `form`, `grid`,
`heading`, `height`, `icon`, `iconnav`, `label`, `leader`, `lightbox`, `link`, `list`, `margin`,
`marker`, `modal`, `nav`, `navbar`, `notification`, `offcanvas`, `overlay`, `padding`, `pagination`,
`placeholder`, `position`, `progress`, `search`, `section`, `slidenav`, `sortable`, `spinner`,
`sticky`, `subnav`, `tab`, `table`, `text`, `thumbnav`, `tile`, `tooltip`, `totop`, `transition`,
`utility`, `width`.

`card`'s and `grid`'s own variables are already documented per-component in [[uikit/uk-card]] and
[[uikit/uk-grid]] — this page indexes the mechanism, not every variable (props-first architecture,
see `CLAUDE.md`).

## Gotcha: `ignore` hides from the UI, it does not invalidate the variable

A variable matching an `ignore` pattern (e.g. `@internal-*`) is still a real LESS variable that
compiles normally — `ignore` only controls whether it appears in the Customizer's grouped visual
panels. **[[sources/style-export-sample]] proves this**: its `less` map contains `@internal-fonts`,
which matches the `ignore` pattern `@internal*`, yet it is present in a real export and is
load-bearing (see the Google Fonts gotcha below). Two more of the sample style's variables
(`@card-border-radius`, `@navbar-gap-m`) match **no** named group in `config/styler.php` at all —
they reach the Customizer through its generic "custom variable" control, the config file's final
catch-all entry `['type' => 'text', 'vars' => '*', ...]`, which accepts any `@`-prefixed name
regardless of grouping. Neither `ignore` nor the group list is therefore a validity filter — they
only describe the Customizer's own UI organisation. The real constraint is simpler: **the variable
must actually exist somewhere in the LESS chain** (the base theme's `_import.less`,
`less/theme.less`, or UIkit's own `.less` sources) — verified by reading/grepping it, never by
analogy with a naming pattern.

## Gotcha: Google Fonts only load via `@internal-fonts`

`vendor/assets/uikit-themes/master/_import.less:5-8`:

```less
@internal-fonts: ~'';

.font() when not (@internal-fonts = ~'') {
    @import (css) 'https://fonts.googleapis.com/css?family=@{internal-fonts}';
}
```

Every official theme preset sets its own `@internal-fonts` on line 1 of its `_import.less`
(`master-joline/_import.less:1`: `@internal-fonts: 'Poppins:300,400|Open+Sans:300|Lora'`) — the
Google Fonts API `family` query string for every custom font the theme uses, families joined by
`|` and weights by `,`. Setting a `*-font-family` variable to a Google Font **does not load it** on
its own: [[sources/style-export-sample]] overrides three font families and correspondingly rewrites
`@internal-fonts` to `~'Cormorant+Garamond:400,500,600,700|Jost:300,400,500|Lato'` — every custom
family, all its weights, none of `joline`'s original fonts, **with the tilde-escape kept as part of
the JSON string value** (not LESS source — the export stores it verbatim). Any style-JSON generation
that sets a custom Google Font must update `@internal-fonts` to match, or the font is named in the
compiled CSS but never actually fetched.
