---
title: root format — always the layout object, never a bare array; no real file ever used the array
type: issue
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/websites-demo]]", "[[sources/skill-yootheme-json-schema]]"]
tags: [issue, correction, root, layout, import, structural]
updated: 2026-09-08
---

# Root format — the `layout` object, not a bare array

**Status: resolved.** The most consequential correction of the day's investigation into a real
import failure. Unlike the three earlier corrections from the same debugging thread
([[issues/children-key-leaf-nodes]], [[issues/name-prop-node-level]],
[[issues/media-overlay-gradient-string]]), each of which was real but individually insufficient,
this one addresses the actual structural shape of the whole file.

## The wrong claim

Both `SKILL.md` files and `schema-spec.md` stated, as settled guidance carried through the entire
session: generated JSON should always use a **bare array root** —
`[{ "type": "section", "props": {...}, "children": [...] }]` — reserving the `{"type":"layout",
...}` object only for "reconstructing a full page export". The prose was explicit: *"To generate importable
sections: always a root array"* / *"This is the format every generated snippet must use"*
(translated from the original Italian).

Three client layout files were generated with this bare-array root and delivered to the
user. `homepage.json` failed to import with `TypeError: Invalid argument expected string`. Two
rounds of narrower fixes ([[issues/children-key-leaf-nodes]], [[issues/name-prop-node-level]],
[[issues/media-overlay-gradient-string]]) were applied and the user re-tested each time — the error
persisted (or at least was not confirmed fixed) until the user pointed out, unprompted, that the
*structure* of their reference file looked "very different" from `homepage.json` and asked for
another pass against `raw/websites-demo`.

## What an exhaustive check found

Previous rounds this same day had only spot-checked a handful of demo files. This time, every file
was checked, not a sample:

```bash
find raw/websites-demo -name "*.json" | wc -l
# 77

find raw/websites-demo -name "*.json" | while read f; do jq -r 'type' "$f"; done | sort | uniq -c
#   77 object          ← zero arrays

find raw/websites-demo -name "*.json" | while read f; do jq -r 'if type=="object" then .type else empty end' "$f"; done | sort | uniq -c
#   77 "layout"         ← zero other values

find raw/websites-demo -name "*.json" | while read f; do jq -c 'if type=="object" then (keys|sort) else "ARRAY" end' "$f"; done | sort | uniq -c
#   77 ["children","type","version"]   ← identical key set on every single file
```

The user's own reference export (`Home healt fitness (1).json`, YOOtheme 5.0.43) matches the same
shape with two extra optional keys:
```json
{"type":"layout","version":"5.0.43","name":"Home healt fitness","modified":"2026-05-26T17:20:02.938Z","props":[]}
```

**78 real files, zero exceptions, all objects, all `type: "layout"`.** No file examined anywhere in
this wiki's material — corpus or user-supplied — is ever a bare array at the root.

A third, independent confirmation: `skills/json-schema/examples/example-layout.json` — the
wiki's own canonical reference example, held up throughout the session as "a complete working
layout" — was **already** an object (`{"type":"layout","version":"4.3.8","props":[],"modified":
"...","name":"New Home",...}`). The example was right; only the prose describing when to use each
format was wrong, and the wrong prose is what got followed when generating fresh layouts, not the
correct example sitting one directory over.

## Where the wrong claim came from

Not established with certainty — no PHP source citation backs "root array is what the Import tab
accepts" anywhere in the wiki's existing pages, and this session's attempts to verify it turned up
nothing. It reads as a plausible-sounding generic claim about page-builder JSON import UIs (many
builders do accept a bare array of blocks for a "paste snippet" action) that was never actually
checked against this specific corpus before today, despite the corpus being available since the
wiki's initial pilot in July.

It is **not proven wrong that some import action somewhere accepts an array** (e.g. pasting a
single section snippet into an existing page might use a narrower endpoint) — only that **no real
file demonstrates it**, and that treating it as the default for a complete generated layout was
unsupported and, in this case, produced a file that failed to import.

## What was corrected

- `skills/json-schema/references/schema-spec.md` — "Struttura Gerarchica" and "I due
  formati root" (renamed) rewritten around the object format as the confirmed default; Hero example
  wrapped; validation checklist and mechanical check updated
- `skills/json-schema/SKILL.md` — "JSON Hierarchy", "Struttura Root", "Generazione JSON
  valido" point 2, "Import Validation Checklist" all updated; **version bumped 2.4.1 → 2.5.0**
- `SKILL.md` root (top-level orchestrator) — step 5 of the shared workflow, "Validation" section,
  "Common mistakes" table (also picked up the still-missing `media_overlay` row while here)
- The three client layout JSON files were rewrapped: each now has root `{"type":"layout",
  "version":"5.0.43", "name":"<page title>", "modified":"<timestamp>", "props":[],
  "children":[...5 or 4 sections...]}` — `version: "5.0.43"` taken verbatim from the user's own real
  export rather than invented

## Update 2026-09-08: confirmed at the JS source level

`raw/yootheme-pro-5.0.43/assets/admin/js/customizer.js` (new raw material, not available when this
page was first written) supplies the mechanism this section was waiting on. See
[[concepts/library-import-version-check]] for the full trace: the Layout Library import
destructures `{name, type, version}` from each top-level item of the uploaded array. A bare-array
root — exactly the format this page documents as wrong — hands each section object to that
destructuring directly; a generated section never carries its own `version` key, so `version` is
`undefined` on the first item and the bundled `compareVersions` call throws
`TypeError: Invalid argument expected string` immediately. Wrapping the layout in the single
`{"type":"layout","version":"5.0.43",...}` object (the fix below) works precisely because the
uploaded array then has one item, and that item's `version` is a real string. This is now the
best-supported explanation for the failure this page set out to fix, and it also means
[[issues/media-overlay-gradient-string]]'s fix was very likely addressing an independently real but
non-causal bug — see that page's own updated "Still open" section.

## Related

[[issues/children-key-leaf-nodes]] · [[issues/name-prop-node-level]] ·
[[issues/media-overlay-gradient-string]] · [[concepts/library-import-version-check]] ·
[[sources/skill-yootheme-json-schema]] · [[sources/websites-demo]]
