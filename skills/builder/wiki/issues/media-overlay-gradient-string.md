---
title: media_overlay held a linear-gradient() function — element-types.md's ambiguous wording let it happen
type: issue
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[props/media]]"]
tags: [issue, correction, media_overlay, section, element-types]
updated: 2026-09-08
---

# `media_overlay` — real cause of a confirmed import `TypeError`

**Status: resolved.** Unlike [[issues/name-prop-node-level]] and [[issues/children-key-leaf-nodes]]
from earlier the same day, this one is **not** a wiki correction — `wiki/props/media.md` already
had the right answer, `verified`, since before this session. The gap was in the canonical
reference's per-element table (`element-types.md`), whose wording was ambiguous enough that it was
misread instead of consulted properly.

## What happened

A generated `section` (the Hero of a homepage layout) carried:
```json
"media_overlay": "linear-gradient(0deg, rgba(20,10,10,0.55), rgba(20,10,10,0.55))"
```
The file failed to import into a real YOOtheme 5.0.43 install with `TypeError: Invalid argument
expected string`. Two earlier rounds of investigation the same day (see
[[issues/children-key-leaf-nodes]], [[issues/name-prop-node-level]]) fixed real but insufficient
structural issues — the user re-tested and got the identical error, meaning those weren't the (only)
cause. `media_overlay` turned out to be the **only** prop of its kind used anywhere across the three
generated files, present in exactly the one section of the one file confirmed to fail.

## The actual mechanism, verified in source

- `raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:530-538`:
  ```php
  'media_overlay' => ['label' => 'Overlay Color', 'type' => 'gradient', 'internal' => 'media_overlay_gradient'],
  'media_overlay_gradient' => ['type' => 'hidden'],
  ```
- `elements/section/templates/template.php:144-152` renders:
  ```php
  'background-color: {media_overlay};',
  'background-image: {media_overlay_gradient}; background-clip: padding-box;',
  ```
  `media_overlay` feeds a CSS `background-color` declaration — a `linear-gradient(...)` function is
  not a valid value there. The actual gradient, when configured, lives in the **separate**
  `media_overlay_gradient` prop and feeds `background-image` instead
- Confirmed against the whole `raw/websites-demo/` corpus: every real `"media_overlay"` value is a
  flat colour (`"rgba(0, 0, 0, 0.34)"`, `"rgba(0, 0, 0, 0.75)"`, …) — grepped across all demos, zero
  exceptions. `"media_overlay_gradient"` values, found only in `design-escapes/*.json`, are the ones
  holding `linear-gradient(...)`

## Why the wiki didn't stop this

`wiki/props/media.md` (`verified`, predates this session) already states the mechanism correctly at
lines 36-42: *"a flat colour lands in `media_overlay`, a gradient in `media_overlay_gradient`"* —
this page was simply never consulted while generating the layout.

The file this skill's iron rule actually mandates reading before emitting a prop —
`skills/json-schema/references/element-types.md` — did list `media_overlay`, but with the
ambiguous gloss `"gradiente stringa"` ("gradient string") and no mention of
`media_overlay_gradient` at all. That wording reads as "pass a gradient, as a string" — which is
exactly the wrong value that was generated. A short, misleading table cell was enough to make a
plausible-but-wrong prop value look verified.

## What was corrected

- `skills/json-schema/references/element-types.md` — `section`'s prop table now lists
  `media_overlay` as a **plain colour** with an explicit "MAI `linear-gradient()` qui" warning,
  adds the missing `media_overlay_gradient` (and the rest of the `media_*` family:
  `media_blend_mode`, `media_focal_point`, `media_visibility`), and a callout right after the
  `section` example citing the exact template lines and pointing to [[props/media]]
- `skills/json-schema/SKILL.md` — new bullet in "Prop critiche da ricordare";
  **version bumped 2.4.0 → 2.4.1**
- The failing layout's `media_overlay` value was replaced with the flat-colour equivalent
  (`"rgba(20, 10, 10, 0.55)"` — the two gradient stops were already identical, so the visual result
  is unchanged)

## Update 2026-09-08: probably not the cause of the `TypeError` after all

[[issues/root-format-object-not-array]] (found the same day, after this page) plus
[[concepts/library-import-version-check]] (JS source read from the newly-added
`raw/yootheme-pro-5.0.43/`) together give a more complete picture. The Layout Library import
destructures `{name, type, version}` from each top-level item of the uploaded array *before* any
prop like `media_overlay` is ever inspected — with a bare-array root (the format `homepage.json`
actually used), the very first section object has no `version` key, so `mS(undefined)` throws
`TypeError: Invalid argument expected string` immediately. That means this specific `TypeError` was
most likely already fully explained by the root-format bug, and this page's fix never got the
chance to be exercised by the failing import.

**This correction stands regardless.** `media_overlay` holding a `linear-gradient()` function is a
real, independently-verified bug (§ "The actual mechanism, verified in source" above) — a
`background-color` CSS declaration cannot take a gradient function — and the fix (flat colour, kept
in `props/media.md` and `element-types.md`) is correct on its own merits. It is simply not, with the
evidence now available, the confirmed cause of *this* `TypeError`.

## Related

[[props/media]] · [[elements/section]] · [[issues/children-key-leaf-nodes]] ·
[[issues/name-prop-node-level]] · [[issues/root-format-object-not-array]] ·
[[concepts/library-import-version-check]]
