---
title: source — how to create a style json
type: source
status: verified
yootheme_version: "5.0.33"
sources: []
tags: [source, customizer, less, style, json]
updated: 2026-07-29
---

# Source: `raw/how-to-create-style-json.md`

User-supplied note, confirmed by the user to come from a real style export taken from the YOOtheme
Pro Customizer. The raw file is short (19 lines) and **cuts off mid-sentence** at "Use the" — it may
be missing content beyond the wrapper shown below.

## What it states

The Customizer's "style" Library exports/imports a JSON object of this shape:

```json
{
  "style": "{KEY_FOR_THE_STYLE}",
  "less": { "....": "0px" },
  "modified": "{TIMESTAMP}",
  "name": "{NAME_OF_THE_STYLE}"
}
```

Four top-level keys: `style` (an id), `less` (a flat map of LESS variable overrides), `modified`
(a timestamp), `name` (a display name).

## What it confirms

Cross-checked against the real 5.0.33 PHP source (`raw/yootheme-pro-5.0.33/packages/styler/`):

- `LibraryController.php:16-26` — a real storage mechanism exists: `styler.library.{id}` holds an
  arbitrary `style` blob received via POST (`id` + `style`), never validated in shape server-side.
  This is a **different** mechanism from the physical `less/theme.<slug>.less` files handled by
  `Styler.php` (parsed via header comments `Name:`/`Style:`/`Background:`/`Color:`/`Type:`). See
  [[concepts/customizer-less-map]] for the full distinction.
- `config/styler.php` — an index of `@`-prefixed variable groups the Customizer's UI organises itself
  by (`global`, `theme`, `inverse`, `card`, `grid`, `button`, …) plus an `ignore` list
  (`@deprecated`, `@breakpoint-*-max`, `@internal*`, `@heading-primary-*`, `@heading-hero-*`,
  `@woocommerce-*`). **Correction, see [[sources/style-export-sample]]**: this is a UI index, not a
  validity whitelist — real exports contain variables matching no named group (via the Customizer's
  generic "custom variable" control) and variables matching `ignore` (e.g. `@internal-fonts`, which
  is load-bearing). The real constraint is that the variable exists in the LESS chain, not that it
  matches this config file's groups.

So the **existence** of the mechanism and the **variable namespace** are `verified` against source.
The exact **wrapper shape** (these 4 keys, no more, no fewer) was `verified` only insofar as the user
attested the file was a genuine export, since this file itself is truncated — **now fully resolved**
by [[sources/style-export-sample]], a second, complete, untruncated real export: exactly 4 keys, no
more.

## What it does not confirm

Resolved by [[sources/style-export-sample]]: whether keys exist beyond `name` (no — exactly 4), the
serialization of `modified` (JS `Date.prototype.toISOString()`), and that `style` is a project-chosen
id (no — it is the **base theme's** id, see [[concepts/customizer-less-map]]).

Still open: how the client generates a `style` id when the custom style is built from scratch, with
no existing base theme to name.

## Raw file

`raw/how-to-create-style-json.md`
