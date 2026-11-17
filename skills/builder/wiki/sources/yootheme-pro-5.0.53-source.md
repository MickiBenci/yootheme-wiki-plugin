---
title: YOOtheme Pro 5.0.53 theme source — diff against 5.0.43
type: source
status: verified
yootheme_version: "5.0.53"
sources: ["raw/yootheme_wp_5.0.53/config.php", "raw/yootheme_wp_5.0.53/CHANGELOG.md"]
tags: [source, diff, builder, custom-css, uikit, wordpress]
updated: 2026-10-30
---

# YOOtheme Pro 5.0.53 theme source — diff against 5.0.43

The user added `raw/yootheme_wp_5.0.53/` — version confirmed by `config.php` (`'version' =>
'5.0.53'`, released 2026-10-21 per `CHANGELOG.md`). Like [[sources/yootheme-pro-5.0.43-source]] it
is a **raw, complete WordPress theme export** (3,219 files): assets, JS bundles, every package.

At the same time the user removed `raw/yootheme-pro-5.0.33/` and `raw/yootheme-pro-5.0.43/` from the
working tree. Both remain in git `HEAD`; this diff was made by extracting 5.0.43 from `HEAD` into a
scratch folder and comparing it file by file. See § "Raw paths cited elsewhere" below.

## Scope of the change

Ten releases (5.0.44 → 5.0.53), almost all bug fixes and four security releases. **Unchanged**,
byte for byte:

- `packages/builder/config/` (the shared field library) and `packages/builder/updates.php`
- `packages/styler/config/` and the theme `less/` folder — the Style JSON / LESS map in
  [[concepts/customizer-less-map]] is unaffected
- every element folder of `builder-wordpress`, `builder-newsletter`
- the list of elements: **no element added or removed**, the 59 in-scope elements are unchanged

No prop was added, removed or renamed in any in-scope `element.php`. Everything below is template
output, migration or rendering-pipeline behaviour.

## Builder changes that matter to the wiki

| Since | Change | File | Wiki impact |
|---|---|---|---|
| 5.0.51 | Element custom CSS: `@keyframes` and descriptor at-rules no longer prefixed; comments with braces no longer break the next rule | `builder/src/Builder/ElementTransform.php` `prefixCSS()` | [[props/advanced-group]] |
| 5.0.44 | Duplicate `uk-flex` classes removed from the image/content grid cells of panel-type items | `panel`, `grid_item`, `panel-slider_item` `templates/template.php` | [[props/expand-mechanism]] |
| 5.0.47 | `panel-slider` `show_hover_video` now actually blanks the item's `hover_video` | `panel-slider_item/element.php` | [[props/show-switches]] |
| 5.0.43→53 | Legacy `4.5.0-beta.0.3` migration writes `panel_link_hover` as boolean `true`, not string `'true'` | `panel`, `grid`, `panel-slider` `updates.php` | [[props/panel-style]] |
| 5.0.43→53 | Legacy `grid` icon→image migration now always sets `image_width`, falling back to `80` | `grid/updates.php` | none — pre-4.x JSON only |
| 5.0.44 | Dynamic content: duplicate aliased selections in source queries fixed | `builder-source/src/Source/SourceQuery.php` | [[concepts/dynamic-content]] |

`5.0.43→53` = present in the 5.0.53 code but not attributed to a specific release by the changelog.

### Custom CSS prefixing — tested, not only read

The old and new `prefixCSS()` were extracted and run on the same input with PHP:

```css
@media (min-width: 960px) { .el-title { font-size: 2rem; } }
@keyframes pulse { from { opacity: 0; } to { opacity: 1; } }
.el-meta { animation: pulse 1s; /* a { brace } */ }
```

| | `@media` | `@keyframes` | rule after a comment with `{ }` |
|---|---|---|---|
| 5.0.43 | inner rule scoped ✔ | `#el-x from{…}` — **invalid CSS, animation dropped** | `.el-meta` **left unscoped** |
| 5.0.53 | inner rule scoped ✔ | kept as written ✔ | `#el-x .el-meta` ✔ |

5.0.53 recurses only into `@media`, `@supports`, `@container`, `@layer`, `@starting-style` and
`@scope`; every other at-rule block (`@keyframes`, `@font-face`, `@property`, `@page`…) is kept
untouched. The source comment admits the parser is still regex-based: braces or comment-like text
**inside strings** (e.g. `content: "{"`) can still confuse it.

### Smaller template fixes (no wiki page affected)

- `grid` / `gallery` `template-nav.php`: filter tag names are now HTML-escaped (`$this->e($name)`).
  A tag containing `<` or `&` rendered raw before.
- `map` / `video` `template.php`: `consent_content` now passes through `$this->trans()` (5.0.44).
- `map/element.php`: the builder placeholder child was `list_item`, now `map_item` — a typo in the
  "add element" preview, not in the JSON schema. The child type of `map` was always `map_item`.
- `section/templates/template.php`: the vertical section `title` is rendered via
  `$this->el('div')->render($props, …)` instead of a raw echo.
- `fragment/templates/template.php`: inline `<style>` is emitted only when `$props['root']` is set.
- 25 `range` fields across `gallery`, `grid`, `map`, `overlay`, `overlay-slider`, `panel-slider`,
  `popover_item`, `slideshow` gained `'attrs' => ['type' => 'number']` — a builder UI change (number
  input beside the slider). **Values stay numbers**; nothing changes in the JSON.
- `image/updates.php`: a regex escape cleanup, behaviour unchanged.

## Outside the builder

- **WordPress block editor** (5.0.49): new `builder-wordpress/src/Listener/EscapeLayoutContent.php`.
  Its docblock confirms how a builder page is stored on WordPress: *"Builder layouts are stored as
  JSON inside an HTML comment"* in the post content, and Gutenberg's `wp.autop()` could insert line
  breaks into that JSON when the post was opened in the block editor. Before 5.0.49, opening a
  builder page in Gutenberg could corrupt its layout.
- **UIkit 3.25.21 → 3.25.26.** The LESS diff only removes legacy vendor prefixes and old-browser
  normalisations (`-moz-focus-inner`, `-moz-placeholder`, `-webkit-overflow-scrolling`, the
  HTML5 `display` resets). **No LESS variable changed.**
- Theme settings: `Consent Service ID` now has `pattern: \S*` (no whitespace, 5.0.51).
- Child theme loading moved from `theme-wordpress` to `theme/src/Listener/LoadChildTheme.php`;
  new `RefreshCustomizerTokens` (WordPress) and Polylang `FilterMenuItems` listeners.
- Security: CVE-2026-102785 (5.0.53, unauthenticated RCE via the image handler). Upgrading is not
  optional for live sites.

## Raw paths cited elsewhere

42 wiki pages cite files as `raw/yootheme-pro-5.0.33/…`, and `SKILL.md` pointed to
`raw/yootheme-pro-5.0.43/`. Those folders no longer exist in the working tree. Since builder config,
element definitions and `less/` are unchanged apart from the files listed above, every such citation
resolves to the same content under `raw/yootheme_wp_5.0.53/` (same relative path inside the theme).
Earlier versions are still readable with `git show HEAD:raw/yootheme-pro-5.0.43/<path>`.

## Verdict

No re-ingest of earlier pages needed. Four prop/concept pages get a version-tagged note; no page is
contested and no skill is contradicted.
