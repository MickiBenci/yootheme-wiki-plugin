# Log

Append-only chronological record. Format: `## [YYYY-MM-DD] type | Title`
Types: `ingest` · `query` · `lint` · `refactor`

## [2026-07-29] refactor | Wiki initialisation

Created `CLAUDE.md` (operating schema), the `raw/` + `wiki/` scaffold, `index.md` and `log.md`.
No sources ingested yet.

## [2026-07-29] refactor | Wiki language switched to English

Translated `CLAUDE.md`, `index.md` and `log.md` into English. The operating rule prescribing
Italian page content was inverted: wiki pages are now written in English, with YOOtheme and
UIkit identifiers kept verbatim. The two canonical skills remain in Italian and are out of scope.

## [2026-07-29] refactor | Theme source declared primary; version baseline set to 5.0.33

`CLAUDE.md`: added an "Existing sources of truth → Primary" section declaring the extracted theme
source the highest authority, above the skills (conflicts still go to `issues/`, skills never
edited). Corrected the frontmatter example from `4.5` to `5.0.33`. Relaxed the `raw/` rule to allow
extractions performed on request, immutable once written.

## [2026-07-29] ingest | YOOtheme Pro 5.0.33 theme source — curated extraction

Extracted `frontend-dev-agent-claude/yootheme/` into `raw/yootheme-pro-5.0.33/` (7.8 MB): 75
`element.php`, their templates and `updates.php`, the builder config and node transforms, the
sources API, the theme LESS, and UIkit's own LESS from `vendor/assets`. Binaries, `vendor/` code,
compiled CSS and translation catalogues excluded. `MANIFEST.md` records provenance, the inclusion
rules, the reproduction command and checksums.

Also copied the seven non-canonical skills into `raw/skills-frontend-dev-agent/` with their own
MANIFEST, and one production layout into `raw/implementations-sample/`.

Correction during the run: the first pass excluded all of `vendor/`, which threw away UIkit's LESS
sources — the ground truth for the `uikit/` section. Re-extracted the `.less` and `.json` files from
`vendor/assets` and amended the MANIFEST.

## [2026-07-29] ingest | Pilot slice — section, grid, grid_item, panel

First wiki pages, 13 in total. Sources: [[sources/yootheme-pro-5.0.33-source]],
[[sources/skill-yootheme-json-schema]], [[sources/production-layout-sample]].
Elements: [[elements/section]], [[elements/grid]], [[elements/grid_item]], [[elements/panel]].
Props: [[props/advanced-group]], [[props/margin]], [[props/link]].
UIkit: [[uikit/uk-card]], [[uikit/uk-grid]]. Recipe: [[recipes/service-card-grid]].

Findings worth noting: `grid` is the content-items element, not a layout grid, and `panel` is its
vocabulary for a single item; the element `id` prop is real and distinct from the node `id` that does
not exist; `panel_link` silently strips HTML from title, meta and content; a stored page layout has a
`layout` object at its root while section import uses a root array; undeclared props are carried
silently and do nothing — the production layout contains three of them.

Opened [[issues/element-types-skill-vs-source]] with six contradictions between the skills and the
source. `contested`, decision pending with the user; no skill was modified.

## [2026-07-29] lint | Pilot slice verification

0 broken links, 0 orphans, 0 unindexed pages, frontmatter complete on all 14. Status inventory:
13 `verified`, 1 `contested`. The recipe snippet parses, satisfies every invariant, and each of its
props is declared in the corresponding `element.php`. Five sampled claims in [[elements/panel]]
verified against the exact cited line ranges.

Two fixes applied: the orphan-detection command in `CLAUDE.md` matched a bare basename while
wikilinks carry the path relative to `wiki/`, so it reported all 14 pages as orphans — corrected and
an inbound-link count added. And `striptags` on a linked panel is guarded by `$link && panel_link`,
not `panel_link` alone: tightened in [[props/link]] and [[recipes/service-card-grid]].

## [2026-07-29] refactor | Props-first architecture; WooCommerce out of scope

Gate decision after measuring the pilot slice. Density was right, composition was not: of 525
distinct props across the 59 in-scope elements only 118 are shared by 5+ elements while 253 are
unique to one, and the large elements are 53–98% shared props. Replicating the pilot form across 55
elements would have re-explained `image_align` 33 times.

`CLAUDE.md` gains a **Scope** section (WooCommerce's 16 elements excluded, 59 in scope) and a
**Page architecture: props-first** section defining the delta shape for element pages, with
`elements/panel.md` named as the reference.

## [2026-07-29] ingest | Prop families — 13 new pages in props/

Universal: [[props/position]], [[props/alignment]], [[props/visibility]], [[props/animation]].
Card/content: [[props/image-family]], [[props/title-family]], [[props/content-family]],
[[props/meta-family]], [[props/panel-style]], [[props/show-switches]], [[props/media]].
Component: [[props/lightbox]], [[props/slider-nav]].

The decisive source was `packages/builder/src/Builder/ElementTransform.php`, which is where every
universal prop becomes a class and which no skill covers. It forced two corrections to pages written
during the pilot: the element `css` field is scoped by a **generated HTML id**, not by class — so it
cannot leak page-wide, contrary to what [[props/advanced-group]] said — and `margin_top` is skipped
on a first child while `margin_bottom` is skipped on a last child, which [[props/margin]] now records.

Other findings: `visibility` propagates upward through `child_visibility`, so a column whose elements
are all hidden collapses on its own; element `animation` is overwritten with `'none'` when no ancestor
section has animation enabled; `attributes` silently refuses `id` and `class`.

27 pages. Lint clean.

## [2026-07-29] refactor | Pilot element pages rewritten in delta form

[[elements/panel]], [[elements/grid]], [[elements/grid_item]] and [[elements/section]] now link the
prop families instead of restating them. `panel.md` is the reference shape for the sweep.

Verification 2 of the plan passes: no family value table survives in any element page — no
`title_style` heading list, no `panel_style` enumeration, no `image_border` options.

The line counts did not fall as far as the 60–90 target (panel 174→139, grid 160→129,
grid_item 128→105, section 168→162) and the reason is worth recording. Most of what remains is
genuine element-specific delta — defaults, render resets, markup shape, the empty-render rule — not
duplication. `section` barely moved because only 43% of its props are shared with 5+ elements, the
lowest ratio of any large element: it is mostly its own vocabulary.

One real duplication did surface during the rewrite and was extracted as a **14th family**,
[[props/expand-mechanism]]: `height_expand`, `image_expand` and the three `*_margin_auto` flags span
11 elements and are read by 12 render templates. It also documents that `text_align` is re-read on
the vertical axis in expand mode, driving two axes at once.

28 pages. Lint clean.

## [2026-07-29] ingest | websites-demo — 12 official demos, 77 page exports

Ingested `raw/websites-demo/` (6268 nodes, 47 element types), completing a partial earlier pass that
had produced [[sources/websites-demo]] and two demo pages. Added the 10 missing per-demo pages
(design-bites, design-escapes, devstack, fc-greenfield, framerate, glowbar, kojiiro, line-gallery,
oakville, quantum-flares), [[concepts/dynamic-content]] (the node-level `source` key — 521 bound
nodes, undocumented in the skill), four recipes ([[recipes/fullscreen-hero-slideshow]],
[[recipes/sticky-cover-sections]], [[recipes/price-list-description-list]],
[[recipes/parallax-image-collage]], all snippets machine-validated), and real-world-usage sections
on the four element pages. Two corrections: [[issues/column-width-props]] (the wiki had recorded
`column.width_*` as inert — the demos and `column/templates/template.php:45-51` prove otherwise;
[[recipes/service-card-grid]] carries the fix) and the corpus page's card-style claim reattributed
from `section.style` to `column.style`.

## [2026-07-29] ingest | YOOforged AI guide (first third-party source)
Ingested `raw/The Complete Guide to AI in YOOtheme Pro (2026).md` (yooforged.com marketing post,
author sells the tool). Created [[sources/yooforged-ai-guide-2026]] and
[[concepts/ai-layout-generation]]. Decision with the user: third-party-only claims stay
`inferred` with explicit attribution — no schema change. One promotion inside the concept page:
core-element schema is CMS-agnostic, verified against `packages/builder/` in the 5.0.33 source.

## [2026-07-29] refactor | Repo becomes the /yootheme-wiki skill
Added `SKILL.md` at the repo root (global Claude Code skill, RED/GREEN-tested: layout from
brief/HTML, LESS from preview, JSON validation, observation capture to `raw/observations/` with
ingest on confirmation). Copied the two canonical skills into `skills/` (from
`frontend-dev-agent-claude/skills/`, originals untouched) so every path in `SKILL.md` is relative
to the repo root; updated the "Baseline: two canonical skills" section of `CLAUDE.md` accordingly.
No wiki pages touched. The user will move the whole repo to `~/.claude/skills/yootheme-wiki`.

## [2026-07-29] refactor | Skill yootheme-json-schema v2.1.0 — patch A1–A6+B, layout-from-prompt mode
User-approved edit of the canonical skill (both copies, verified identical with `diff -rq`): fixed
the six contradictions of [[issues/element-types-skill-vs-source]], documented the two root formats,
rewrote `references/schema-spec.md` (pre-2.0 relic mandating `id` UUIDs, `builder_*` prefixes,
object `image`/`link`), added the "Layout da prompt" mode and the mechanical check. Policy change in
`CLAUDE.md` + root `SKILL.md`: skills editable with explicit user approval, copies kept in sync.
Pages touched: issues/element-types-skill-vs-source (resolved), sources/skill-yootheme-json-schema, index.md.

## [2026-07-29] ingest | Eyebrow via custom css prop — observation
User observation (raw/observations/2026-07-29-eyebrow-custom-css.md): style the eyebrow with the
element `css` prop and the `.el-*` selectors instead of the `tm-eyebrow` theme class. New pages:
sources/observation-eyebrow-custom-css, recipes/eyebrow-label, issues/eyebrow-styling-approach
(resolved). Skill yootheme-json-schema patched to v2.2.0 with user approval (both copies, `diff -rq`
clean): css-prop styling is the default, `tm-eyebrow` demoted to theme-provided alternative, card
eyebrow via `meta_align: above-title`. Links added from props/advanced-group and props/meta-family.
Residual: create-section/SKILL.md:118 (non-canonical skill) still states the old rule — flagged.

## [2026-07-29] refactor | Skill made self-sufficient — external repo references removed
The two canonical skills (`skills/json-schema/`, `skills/animations/`) are no longer
described as synchronised copies of an external repo — they are this repo's own, sole canonical
copies. Updated `CLAUDE.md` ("Baseline: two canonical skills" section, theme-source provenance
line) and six wiki pages that named the external repo or its "two copies in sync" policy:
props/animation, uikit/uk-card, sources/skill-yootheme-json-schema, sources/production-layout-sample,
issues/element-types-skill-vs-source, issues/eyebrow-styling-approach (dropped its now out-of-scope
"Residual misalignment" section, about a skill this repo never owned). `raw/` and prior log entries
left untouched — they are immutable/append-only historical record, not operational dependencies.

## [2026-07-29] ingest | how-to-create-style-json — Customizer style JSON wrapper
Ingested `raw/how-to-create-style-json.md` (user-confirmed real Customizer export, truncated).
New pages: [[sources/how-to-create-style-json]], [[concepts/customizer-less-map]] (the "wanted" slot
referenced by index.md, demo-dennis-miller and websites-demo since the pilot). Verified against
`raw/yootheme-pro-5.0.33/packages/styler/`: `LibraryController.php` confirms a real
`styler.library.{id}` custom-style storage, distinct from the physical `theme.<slug>.less` files
`Styler.php` handles; `config/styler.php` gives the authoritative `@`-variable whitelist and `ignore`
list. Root `SKILL.md`'s "LESS from preview" mode now always produces both the existing prose LESS
output and a new importable `style.json`, with its own validation checklist. Links added from
uikit/uk-card and uikit/uk-grid. No `wiki/issues/` page needed — no contradiction, only new coverage.

## [2026-07-29] ingest | style-export-sample.json — second real style export, corrects style.json generation
Ingested `raw/style-export-sample.json` (user-imported, complete, untruncated real Customizer export built from
the official `joline` theme). New page [[sources/style-export-sample]]. It corrects three assumptions
made in the previous entry, all forced by the earlier source's truncation: `style` is the **base
theme's id** (`"joline"`), not a project slug — `name` carries the project label instead; `less` is
**delta-only** against that base theme's `_import.less`, not absolute values; and the rule requiring
every emitted variable to match a `config/styler.php` group was wrong — `@card-border-radius` and
`@navbar-gap-m` match no group (reached via the Customizer's generic custom-variable control), and
`@internal-fonts` matches the `ignore` list yet is real and load-bearing (it drives Google Fonts
loading via `vendor/assets/uikit-themes/master/_import.less:5-8`). `SKILL.md`'s "Output 2: style.json"
rewritten accordingly: base-theme selection reusing `generate-css/SKILL.md`'s Theme Similarity
Matcher, delta-only `less`, corrected variable-validity rule, automatic `@internal-fonts` generation
for custom Google Fonts. [[concepts/customizer-less-map]] and [[sources/how-to-create-style-json]]
updated to match; wrapper status promoted from `documented`/uncertain to fully `verified`.

## [2026-09-08] refactor | `name` prop — corrected node-level location, documented row/column exception

User request while generating three client layouts: every node must carry a `name` label.
Two Explore passes over `raw/yootheme-pro-5.0.33/packages/builder/elements/*/element.php` (51
directories) plus the real exports in `skills/json-schema/examples/example-layout.json`
and `raw/websites-demo/dennis-miller/*.json` found [[props/advanced-group]] imprecise on two
points: `name` is a **node-level key sibling to `type`/`props`/`children`**, not inside `props`
like the other seven advanced fields; and **`row`, `column` and the page-level `layout` wrapper
are the only 3 of 51 element types that don't declare it at all** (48 do).

New page [[issues/name-prop-node-level]] records the correction. Pages updated:
[[props/advanced-group]] (new callout + row/column/layout citations), `schema-spec.md` ("Nodo
Base", the Hero example, the validation checklist), `skills/json-schema/SKILL.md`
(**version 2.2.0 → 2.3.0**: Required Fields, Prop critiche, Generazione JSON valido, Import
Validation Checklist), `SKILL.md` root (Validation section + Common mistakes table),
`references/element-types.md` (one-line caveat on `row`/`column`), `index.md` (new issue row,
updated `advanced-group` summary). The three generated layout JSON files in the user's project
were regenerated with `name` added to every eligible node.

## [2026-09-08] lint | Two `name`/`children` rules corrected after a real import failure

`homepage.json` (the file from the previous entry) failed to import in the user's real YOOtheme
install: `invalid argument expected string`. User supplied a genuine reference export
(`Home healt fitness (1).json`, YOOtheme 5.0.43) for comparison. No classic JSON type mismatch was
found on shared props (map/table/list field types re-checked directly against
`raw/yootheme-pro-5.0.33/packages/builder/elements/{map,table,list}/element.php` and confirmed
correct). Two structural divergences were found and cross-checked against the wiki's own
`raw/websites-demo/dennis-miller/*.json` corpus (8 files) the same day:

1. **`children` must be absent entirely on leaf nodes** (`headline`, `text`, `image`,
   `button_item`, `grid_item`, `list_item`, `map_item`, `table_item`), never `"children": []`.
   Zero exceptions across ~330+ combined leaf-node instances in the user's file + the dennis-miller
   corpus. This contradicts a rule that was `verified` in the wiki *before* this session
   (`schema-spec.md`'s "Regole" and both `SKILL.md`'s validation checklists) — the most likely
   actual cause of the reported error. New page [[issues/children-key-leaf-nodes]].
2. **`name` in real exports is populated almost only on `section`** (36/41 in dennis-miller,
   100% — zero exceptions — in the new reference file), correcting the previous entry's guidance
   ("name on every node except row/column"), which was a valid observation about what the field is
   *declarable* on, over-applied to what should be *generated*. Addendum added to
   [[issues/name-prop-node-level]] rather than a new page.

Pages updated: `schema-spec.md` (Nodo Base rewritten as container-vs-leaf shapes, Hero example,
validation checklist), `skills/json-schema/SKILL.md` (**version 2.3.0 → 2.4.0**: Required
Fields, Prop critiche, Generazione JSON valido, Import Validation Checklist), `SKILL.md` root
(Validation section, Common mistakes table), `props/advanced-group.md` (correction addendum),
`index.md` (new issue row, updated `name-prop-node-level` summary). Checked and found *already
correct*, no fix needed: `skills/json-schema/examples/example-layout.json` (never had the
`children` bug — third independent confirmation). The three client layout JSON files were
regenerated: `name` removed from every non-`section` node, `"children": []` removed from every
leaf node.

## [2026-09-08] lint | Real cause found: `media_overlay` held a `linear-gradient()` function

User re-tested `homepage.json` after the previous entry's fixes — same error,
`TypeError: Invalid argument expected string`. The `children`/`name` fixes were real but
insufficient. Kept digging on the same file instead of re-proposing structural theories: checked
file encoding/BOM (clean, ruled out), then traced `media_overlay` — the Hero section's only use of
this prop across all three files, and the only prop of its kind in the whole set — against source.

`raw/yootheme-pro-5.0.33/packages/builder/config/builder.php:530-538` declares `media_overlay` as
`'type' => 'gradient'` with `'internal' => 'media_overlay_gradient'`; `elements/section/templates/
template.php:144-152` renders `media_overlay` into CSS `background-color` and
`media_overlay_gradient` into `background-image` — **two separate props**. The generated file put a
`linear-gradient(...)` function directly into `media_overlay`, which is not a valid
`background-color` value. Confirmed against the whole `raw/websites-demo/` corpus: every real
`media_overlay` value is a flat colour, zero exceptions; `linear-gradient(...)` values only ever
appear under the separate `media_overlay_gradient` key (`design-escapes/*.json`).

Notably, `wiki/props/media.md` already documented this exact mechanism correctly, `verified`,
*before* this session — this was not a wiki error. The real gap: `skills/json-schema/
references/element-types.md` (the file this skill's own iron rule mandates reading before emitting
a prop) listed `media_overlay` with the ambiguous gloss "gradiente stringa" and never mentioned
`media_overlay_gradient` at all — misleading enough that it was misread instead of properly
consulted. New page [[issues/media-overlay-gradient-string]].

Pages updated: `element-types.md`'s `section` entry (media_overlay/media_overlay_gradient
clarified, full `media_*` family added, warning callout after the section example),
`skills/json-schema/SKILL.md` (**version 2.4.0 → 2.4.1**: new "Prop critiche" bullet),
`index.md` (new issue row). `homepage.json`'s Hero `media_overlay` replaced with the flat-colour
equivalent of its (already-identical) gradient stops.

## [2026-09-08] lint | Real root cause: root must be the `layout` object, never a bare array

User re-tested after the previous fix and still got the same `TypeError`, but this time flagged
something concrete: the structure of their reference file looked "very different" from
`homepage.json`, and asked to re-check against the full `raw/websites-demo` corpus rather than a
sample. That prompted an **exhaustive** (not spot-check) pass over all 77 corpus files:

```
77/77 root type: object          (zero arrays)
77/77 .type: "layout"            (zero other values)
77/77 root keys: [children,type,version]   (identical set on every file)
```

Combined with the user's own real export (also a `{"type":"layout",...}` object, 5 keys) and
`skills/json-schema/examples/example-layout.json` (the wiki's own canonical example —
already an object, never fixed because it was never wrong), that's **78 real files, zero
exceptions**, all contradicting the guidance both `SKILL.md` files and `schema-spec.md` had carried
all session: *"always a root array"* for generated layouts. No source ever backed that claim; it
appears to have been an unverified, plausible-sounding assumption never tested against the corpus
that was sitting right there. The three client layout files had all been generated as bare
arrays and delivered that way — this is very likely the actual root cause the three earlier
same-day fixes ([[issues/children-key-leaf-nodes]], [[issues/name-prop-node-level]],
[[issues/media-overlay-gradient-string]]) were unable to resolve on their own, though all three
remain independently correct and were kept.

New page [[issues/root-format-object-not-array]]. Pages updated: `schema-spec.md` ("Struttura
Gerarchica", root-format section rewritten, Hero example wrapped, validation checklist),
`skills/json-schema/SKILL.md` (**version 2.4.1 → 2.5.0**: JSON Hierarchy, Struttura Root,
Generazione JSON valido, Import Validation Checklist), `SKILL.md` root (shared workflow step 5,
Validation section, Common mistakes table — also added the still-missing `media_overlay` row while
there), `index.md` (new issue row). The three layout JSON files were rewrapped in the `layout`
object, `version: "5.0.43"` taken from the user's real export rather than invented.

## [2026-09-08] ingest | YOOtheme Pro 5.0.43 raw export — diff against 5.0.33

User added `raw/yootheme-pro-5.0.43/`, a raw complete theme export (unlike 5.0.33's curated,
builder-only extraction). Compared both versions across all builder-relevant packages: no elements
added/removed (59 in-scope unchanged), no change to the Style/Customizer JSON shape. Two real content
changes found: a `builder/updates.php` migration `'5.0.37'` that strips a legacy `content` prop from
16 container elements with a `content-items` field (checked all four existing element pages — none
documents that prop, nothing to correct), and a new WooCommerce `filter_attribute_query_type` prop
(since 5.0.37, left undocumented — WooCommerce is out of scope per `CLAUDE.md`). Full targeted ingest
did not fit the earlier corrected/full baseline: no re-ingest of `yootheme-pro-5.0.33-source.md`
needed.

New page [[sources/yootheme-pro-5.0.43-source]]. Pages updated: `index.md` (new source row, baseline
note).

## [2026-09-08] lint | `customizer.js` confirms the Library import version-check mechanism

User reported a real `TypeError: Invalid argument expected string` thrown by `customizer.js:32`
during a JSON import. That file is new material in the 5.0.43 raw export. Read it directly:
line ~32 is the bundled `compare-versions` npm package's `validateAndParse`, called by
`compareVersions(version, $.customizer.version, ">")` in exactly three places — Element Library
import, Layout Library preview, and Layout Library import — none of them the Style Library import
(which only checks `name`+`style`, no version at all). Each destructures `{name, type, version}`
from every top-level item of the uploaded array; a non-string `version` throws exactly this error.
This supplies the JS-source confirmation that [[issues/root-format-object-not-array]] and
[[issues/media-overlay-gradient-string]] were both missing: a bare-array root hands each section
directly to that destructuring with no `version` key, throwing on the first item before
`media_overlay` or any other prop is ever inspected — meaning the root-format fix, not the
`media_overlay` fix, most likely resolved the original `TypeError`.

New page [[concepts/library-import-version-check]]. Pages updated: `issues/root-format-object-not-array.md`
("Still open" replaced with source-confirmed mechanism), `issues/media-overlay-gradient-string.md`
("Still open" replaced — fix kept as independently valid, causal claim withdrawn),
`concepts/customizer-less-map.md` (cross-reference to the new mechanism), `index.md` (new concept
row, two issue rows updated).

## [2026-09-08] ingest | Storia grid 1/2 reselection — missing column width_* on a version-stamped file

Captured `raw/observations/2026-09-08-storia-grid-width-medium-reselect.md`: a hand-authored
`row.layout: "1-2,1-2"` without matching `column.width_*`, on a file declaring `version: "5.0.43"`,
skips the `row/updates.php` migration that would derive the widths, so the builder falls back to
full-width columns until manually reselected. Updated [[issues/column-width-props]] (confirmed
real-world case) and [[concepts/ai-layout-generation]] (new failure-mode bullet); bumped
`skills/yootheme-json-schema` to v2.6.0 (`SKILL.md`, `references/schema-spec.md`) with the rule to
always set matching column `width_*` alongside a fraction `row.layout`.

## [2026-10-01] ingest | Service layouts — missing column width_medium, second occurrence

Captured `raw/observations/2026-10-01-servizi-grid-width-medium.md`: generated `1-2,1-2` rows without
column `width_medium` imported stacked again. Root cause of the recurrence: the rule never reached the
agent's own `SKILL.md` nor `references/element-types.md` (`column` entry). With the user's explicit
approval: root `SKILL.md` patched (invariant, common mistake, red flag, `jq` width check, `name` check
restricted to typed nodes so `source.query.name` is not a false positive); `skills/yootheme-json-schema`
`references/element-types.md` (`row`/`column`) patched and skill bumped to v2.7.0. Updated
[[issues/column-width-props]] with the second case.

## [2026-10-13] ingest | Breadcrumbs element — official docs + theme source

Saved `raw/yootheme-docs-breadcrumbs-element.md`; read `element.php`, templates, `Breadcrumbs.php` (5.0.43), `uk-breadcrumb` LESS and CHANGELOG. New pages [[sources/yootheme-docs-breadcrumbs]] and [[elements/breadcrumbs]]; `index.md` updated. No contradictions with the skills (element absent from `element-types.md`).

## [2026-10-14] ingest | Single element export format (Grid example)

Saved `raw/element-export-grid-example.json` and `raw/observations/2026-10-14-single-element-export-format.md`. New pages [[sources/grid-element-export]], [[concepts/single-element-export-format]], [[recipes/single-grid-element-export]]; `index.md` updated. No contradictions: it confirms the `{name, type, version}` check in [[concepts/library-import-version-check]]. Root `SKILL.md` patched with a *Single element* mode, user-approved.

## [2026-10-30] ingest | YOOtheme Pro 5.0.53 raw export — diff against 5.0.43

User replaced the theme copies in `raw/` with `raw/yootheme_wp_5.0.53/` (5.0.33 and 5.0.43 removed from the working tree, still in git `HEAD`; 5.0.43 extracted from `HEAD` for the diff). No element/prop added, removed or renamed; `builder/config`, `builder/updates.php`, `styler/config`, `less/` unchanged. Notable: `prefixCSS()` no longer breaks `@keyframes` or comment braces in element `css` (5.0.51, tested old vs new in PHP), duplicate `uk-flex` removed from panel-type item cells (5.0.44), panel-slider `show_hover_video` fixed (5.0.47), `panel_link_hover` migration writes a boolean, UIkit 3.25.21 → 3.25.26 (no LESS variable change).
New page [[sources/yootheme-pro-5.0.53-source]]. Pages updated: `props/advanced-group.md`, `props/expand-mechanism.md`, `props/show-switches.md`, `props/panel-style.md`, `concepts/dynamic-content.md`, `index.md`, `SKILL.md` (raw paths → 5.0.53).
