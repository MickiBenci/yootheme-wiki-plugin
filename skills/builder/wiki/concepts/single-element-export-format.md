---
title: single element export format (Library > Elements)
type: concept
status: verified
yootheme_version: "5.0.51"
sources: ["[[sources/grid-element-export]]"]
tags: [concept, library, import, export, element]
updated: 2026-10-14
---

# Single element export format

A page layout is `{"type":"layout","version":…,"children":[sections]}` ([[issues/root-format-object-not-array]]).
An element saved to **Builder → Library → Elements** is exported differently: the root *is* the element.

```json
{ "type": "<element>", "props": { …full set… }, "children": [ … ],
  "modified": "<ISO 8601 with ms>", "name": "<label>", "version": "<installed version>" }
```

| Key | Rule |
|---|---|
| `type` | The element type (`grid`, `accordion`, …). Not `layout`, not wrapped in an array or a section |
| `props` | Full prop set with defaults, as the editor serialises it. Emit only props read in this session |
| `children` | Container elements only; leaf items (`grid_item`, …) omit the key |
| `name` | Library label, sibling of `type` (see [[issues/name-prop-node-level]]) |
| `modified` | `new Date().toISOString()` format |
| `version` | **String**, ≤ installed theme version, otherwise the import throws (see [[concepts/library-import-version-check]]) |

Only the root carries `name`/`modified`/`version`. When the same element is placed inside a layout page,
drop those three keys: nested nodes are just `type`/`props`/`children`.

Recipe: [[recipes/single-grid-element-export]].
