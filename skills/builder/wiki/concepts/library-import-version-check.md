---
title: three Library import mechanisms and the version-string check
type: concept
status: verified
yootheme_version: "5.0.43"
sources: ["[[sources/yootheme-pro-5.0.43-source]]"]
tags: [concept, customizer, builder, library, import, error, semver]
updated: 2026-09-08
---

# Three Library import mechanisms — and why `version` must be a string

One admin JS bundle, `assets/admin/js/customizer.js`, backs both the Customize → Style panel and
the Builder → Library panels (Elements, Layouts). It contains **three distinct client-side import
validators**, easy to conflate because they share one file and can throw the same generic-sounding
error class. Verified by reading `raw/yootheme-pro-5.0.43/assets/admin/js/customizer.js` directly
(minified; identified by matching the bundled `compare-versions` npm package's source).

## 1. Style Library import (Customize → Style → Import) — no version check

Documented in [[concepts/customizer-less-map]]. Client-side validation is exactly:
```js
if (!v.name || !v.style) throw new Error("Invalid style.");
```
Only `name` and `style` are required; there is **no `version` field and no semver comparison at
all**. This is the mechanism [[sources/how-to-create-style-json]] and [[sources/style-export-sample]]
document — a `{"style":..., "less":{...}, "modified":..., "name":...}` blob, stored verbatim
server-side by `LibraryController.php::save()` with zero shape validation.

## 2. Element Library import (Builder → Library → Elements) — version required

The uploaded JSON is an array; each top-level item is destructured as `{name, type, version}`:
- missing `name` → `"Name is required"`
- missing `type` → `"Type is required"`
- otherwise: `compareVersions(version, $.customizer.version, ">")` — if the item's `version` is
  newer than the installed theme, `"requires YOOtheme Pro X or newer"` is thrown instead

## 3. Layout Library import (Builder → Library → Layouts) — version required + type check

Same `{name, type, version}` destructuring and `compareVersions` call as #2, plus `type` must be one
of `section` / `layout` / `fragment`.

## The actual error mechanism: `compareVersions` → `validateAndParse`

`compareVersions(a, b, operator)` calls `validateAndParse` on **both** arguments before comparing.
Minified in the bundle (~line 32 at the time of writing) as:

```js
mS = n => {
  if (typeof n != "string") throw new TypeError("Invalid argument expected string");
  const e = n.match(EU); // semver regex
  if (!e) throw new Error(`Invalid argument not valid semver ('${n}' received)`);
  return e.shift(), e;
};
```

The second argument, `$.customizer.version`, is always a valid string — it is set server-side in
`packages/theme/src/Listener/LoadCustomizerData.php:28` to the installed theme's version (e.g.
`"5.0.43"`). **The first argument — the imported item's own `version` field — is always the
culprit** when this throws: it is missing, `null`, a number, or otherwise not a string.

## Rule to avoid this error

> Any JSON imported through the **Element Library** or **Layout Library** must have a `version`
> field, and it must be a **string** (valid semver, e.g. `"5.0.43"`), on every top-level item of the
> uploaded array. The **Style Library** has no such requirement — it only needs `name` and `style`.

## Confirms and supersedes the "still open" mechanism in two earlier issues

[[issues/root-format-object-not-array]] and [[issues/media-overlay-gradient-string]] both chased the
identical `TypeError: Invalid argument expected string` for a layout import, without ever having the
JS source available. This page supplies the missing confirmation:

- A **bare-array root** (`[{type:"section",...}, ...]`) submitted to the Layout Library import is
  the uploaded array itself — each section object is destructured directly for `{name, type,
  version}`. A generated section never carries its own `version` key → `version` is `undefined` for
  the very first item → `mS(undefined)` throws immediately, before any other field (including
  `media_overlay`) is ever inspected.
- Wrapping the layout as a single `{"type":"layout","version":"5.0.43",...}` object (the fix in
  [[issues/root-format-object-not-array]]) works because the uploaded array now has exactly one item,
  and that item carries a real string `version` — the destructuring succeeds and `compareVersions`
  passes.
- This means the `media_overlay` gradient-string bug documented in
  [[issues/media-overlay-gradient-string]] is very likely **not** what produced that session's
  `TypeError` — it is independently real (an invalid CSS value) but was probably never reached,
  since the array-root problem would throw first. See that page's updated "Still open" section.

## Related

[[concepts/customizer-less-map]] · [[issues/root-format-object-not-array]] ·
[[issues/media-overlay-gradient-string]] · [[sources/yootheme-pro-5.0.43-source]]
