---
title: YOOtheme Pro 5.0.43 theme source — diff against 5.0.33
type: source
status: verified
yootheme_version: "5.0.43"
sources: ["raw/yootheme-pro-5.0.43/config.php"]
tags: [source, diff, builder, customizer, admin-js]
updated: 2026-09-08
---

# YOOtheme Pro 5.0.43 theme source — diff against 5.0.33

The user added `raw/yootheme-pro-5.0.43/` — version confirmed by `config.php` (`'version' =>
'5.0.43'`). Unlike [[sources/yootheme-pro-5.0.33-source]], which is a **curated** text-only
extraction limited to builder-relevant `packages/*`, this one is a **raw, complete** theme export:
assets, CSS, JS bundles, images, and every package including WordPress/WooCommerce infrastructure
ones. That scope difference explains most of the file-list delta between the two folders — it is
not evidence of anything removed from the theme.

## What this diff found

**No new elements.** `packages/builder/elements/`, `builder-wordpress/elements/`,
`builder-wordpress-woocommerce/elements/` and `builder-newsletter/elements/` are identical between
5.0.33 and 5.0.43. The 59 in-scope elements in `index.md` are unaffected.

**Two real content changes**, both from the 5.0.34→5.0.43 changelog range:

1. `packages/builder/updates.php`, new migration key `'5.0.37'`:
   ```php
   '5.0.37' => function ($node, array $params) {
       $type = $params['type'];
       if (($type->container ?? false) &&
           ($type->fields['content']['type'] ?? '') === 'content-items'
       ) {
           unset($node->props['content']);
       }
   },
   ```
   Strips a legacy `content` prop from container nodes whose `content` field is of type
   `content-items` — 16 elements match that field shape (`accordion`, `grid`, `list`, `table`,
   `nav`, `subnav`, `switcher`, `gallery`, `slideshow`, `social`, `map`, `button`, `popover`,
   `panel-slider`, `overlay-slider`, `description_list`). Checked against every existing
   `wiki/elements/*.md` page (only `grid.md`, `grid_item.md`, `panel.md`, `section.md` exist today):
   none documents a `content` prop for these elements, so there is nothing stale to correct. This is
   a pure legacy-JSON cleanup migration, not a documented prop being removed.
2. `packages/builder-wordpress-woocommerce/elements/filter/element.php`: new prop
   `filter_attribute_query_type` (select, AND/OR), since 5.0.37. **Not documented** — WooCommerce's
   16 elements are explicitly out of scope (see `CLAUDE.md` → Scope). Noted here only so the decision
   to skip it is traceable.

**No change** to `packages/builder/config/builder.php`, `packages/styler/config/customizer.php`, or
`packages/theme-settings/config/customizer.php` — the Style Library JSON shape (`style`/`less`/
`modified`/`name`) documented in [[concepts/customizer-less-map]] is unaffected.

## New source material this export unlocked

5.0.43 is the first raw source to include `assets/admin/js/customizer.js` — the built, minified
admin JS bundle covering the Customizer panel *and* the Builder Library (Element/Layout import).
Reading it resolved the exact client-side mechanism behind the `TypeError: Invalid argument expected
string` chased in [[issues/root-format-object-not-array]] and
[[issues/media-overlay-gradient-string]] — see [[concepts/library-import-version-check]].
`packages/theme/src/Listener/LoadCustomizerData.php:28` (also new to this export) supplies the
server side of that mechanism: it sets `$.customizer.version` to the installed theme's version
string, the value every Element/Layout Library import compares an uploaded item's `version` field
against.

## Verdict

No full re-ingest needed. This page plus the two updates above (§ "What this diff found") and the
new [[concepts/library-import-version-check]] page cover everything of wiki relevance in this
export.
