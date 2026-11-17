---
name: builder
description: Use when generating YOOtheme Pro builder JSON - full layouts or landing pages from a brief, texts or an existing HTML page, single importable elements for the Library, or a Customizer style (LESS + style.json) from an HTML/CSS preview - when validating or fixing builder JSON before import, or when the user reports YOOtheme Pro behaviour worth recording. Grounded in a verified YOOtheme Pro knowledge base.
argument-hint: <brief | HTML file | JSON to validate | observation — e.g. "landing page for a yoga studio with these texts…">
version: 1.0.0
---

# YOOtheme Pro builder — generation grounded in a verified knowledge base

Generate importable YOOtheme Pro builder JSON (and LESS / Customizer style JSON) from a curated
knowledge base, and validate it mechanically before delivery.

## Where things are

All paths are relative to this skill's **base directory** (announced when the skill loads). Your
shell cwd is usually the user's project, so always build **absolute paths from the base
directory** when reading files or running scripts.

| Alias | Path | Contents |
|---|---|---|
| `KB` | `.` | `index.md` (catalogue — start here), `wiki/` (elements, props, concepts, uikit, recipes, sources, issues) |
| `EXAMPLES` | `examples/` | `grid-element-export.json` (real single-element export), `style-export-sample.json` (real Customizer style export) |
| `VALIDATE` | `scripts/validate.sh` | Mechanical import checks for layouts, single elements and style JSON |
| `SCHEMA_SKILL` | `../json-schema` | Node hierarchy, native-element mapping, serialisation, `references/element-types.md` |
| `ANIM_SKILL` | `../animations` | Scrollspy, parallax, special effects |

Wiki pages link to each other with double-bracket wikilinks to `folder/page` — that is the file `wiki/folder/page.md`.

**Optional: the user's YOOtheme Pro installation.** The knowledge base was built from the theme
source (5.0.33 → 5.0.53), which this plugin does not redistribute. When exact defaults or LESS
variables matter, use the user's own copy if available: the `YOOTHEME_PRO_PATH` environment
variable, or ask once for the path to the theme directory (`wp-content/themes/yootheme` on
WordPress, `templates/yootheme` on Joomla). Useful files there:

- `packages/builder/elements/<name>/element.php` — every prop, option and default of an element
- `vendor/assets/uikit-themes/master-<id>/_import.less` — a base style's LESS defaults
- `less/theme.*.less` — the headers (`Name / Background / Color / Type`) of the bundled styles
- `vendor/assets/uikit/src/less/` — every UIkit LESS variable

Without it, work from the knowledge base and say which values you could not verify.

**Authority order:** wiki pages with `status: verified` > the `json-schema` / `animations` skills >
`documented` > `inferred`. Where they conflict, a `wiki/issues/` page explains — check it before
choosing.

**The iron rule: every prop you emit must have been read in this session** in
`SCHEMA_SKILL/references/element-types.md`, a wiki page, or the user's theme source. Model memory
produces plausible-but-wrong props (see *Common mistakes*) — it is not a source.

## Mode selection

| Request looks like | Mode |
|---|---|
| "Layout / landing page with these texts…" | Layout from brief |
| "Convert this HTML / rebuild this page in YOOtheme" | Layout from HTML |
| "Make the LESS / theme styles for this preview" | LESS from preview (always both outputs) |
| "Check / fix this builder JSON" | Validate only |
| "A single importable element" (a grid, accordion… for Library → Elements) | Single element |
| The user states a fact or correction about YOOtheme behaviour | Observation capture |

## Shared workflow (both layout modes)

1. Read `index.md` to locate the relevant pages.
2. Open matching `wiki/recipes/` pages first — they contain importable JSON to adapt. Then the
   `wiki/elements/` and `wiki/props/` pages for what you will build.
3. Read `SCHEMA_SKILL/SKILL.md` (hierarchy, native-element mapping, serialisation, valid
   `row.layout` fractions). Then read the entry in `SCHEMA_SKILL/references/element-types.md` for
   **every element type you will emit** — no exceptions, even for elements you think you know.
4. For animations/parallax: `ANIM_SKILL/SKILL.md` (scrollspy vs parallax, `item_animation` for
   staggered grids).
5. Ask for the user's YOOtheme Pro version if unknown — `version` in the file must not be newer
   than the installed theme. Default to `"5.0.43"` and say so.
6. Generate the JSON, save it to a file in the cwd (or the path the user gave), run **Validation**
   and fix every error before delivering. Root is the
   `{"type":"layout", "version":"...", "children":[...]}` object
   ([[issues/root-format-object-not-array]]).

### Layout from brief

Choose native elements from the mapping table in `SCHEMA_SKILL/SKILL.md` (card grid →
`grid`+`grid_item`, FAQ → `accordion`, testimonial → `quotation`, …). Prefer a recipe's proven prop
set over composing from scratch. Before the JSON, state a one-line-per-section outline and the
recipes/pages you used. Declare any placeholder copy or image path you invented.

### Layout from HTML

Parse the HTML and map each pattern to a native element with the same mapping table; the `html`
element is the last resort, only when no native element fits. Extract texts, image paths and links
into the right props (`image`/`link` are plain strings). Drop the source page's CSS classes —
styling comes from element props; page-level custom CSS belongs to the LESS mode.

## Single element

Output is one element importable through **Builder → Library → Elements → Import**, not a page.
Same steps as the shared workflow (index → [[recipes/single-grid-element-export]] →
`element-types.md` for the element **and its children** → validation), with these differences,
from [[concepts/single-element-export-format]]:

- Root is the element: `{"type":"grid","props":{…},"children":[…],"modified":"…","name":"…","version":"…"}`
  — never wrapped in `layout`/`section`/`row`/`column`, never a bare array.
- `props` = the element's full prop set with defaults. For `grid`, copy the set from
  `examples/grid-element-export.json`; for other elements read the defaults in the user's
  `element.php` if available, otherwise emit the props you need plus the non-empty defaults
  listed in `element-types.md`, and say so.
- `name` = readable library label; `modified` = ISO 8601 with milliseconds
  (`date -u +%Y-%m-%dT%H:%M:%S.000Z`); `version` = string, the user's installed version if known,
  else `"5.0.43"`. A `version` newer than the installed theme makes the import fail
  ([[concepts/library-import-version-check]]).
- Inside a layout, the same element is just `type`/`props`/`children`: drop `name`/`modified`/`version`.
- Save as `<slug>.json`. When the same content must also live in a page, generate both from one
  script so they stay identical.

## LESS from preview

Extract design tokens from the HTML/CSS preview — colours, font families, type scale, spacing,
border radii. Every request in this mode produces **both** outputs below, however it is phrased.

Read first:

1. [[concepts/customizer-less-map]] — the two style mechanisms (physical `theme.<slug>.less` files
   vs the Customizer's style-library JSON) and which output maps to which.
2. The `wiki/uikit/` pages for the components in the preview (e.g. the `color-mode` trap in
   [[uikit/uk-card]]) and [[sources/websites-demo]] for how official demos pair LESS with layouts.

### Output 1: LESS overrides

UIkit LESS variable overrides plus, when needed, `.tm-*` custom hooks. **Mark every variable you
could not verify** (in a wiki page or the user's theme source) **with a `// UNVERIFIED` comment**
and list them for the user.

### Output 2: style.json (Customizer import)

The importable JSON for the Customizer's style library, shaped exactly like the real export in
`examples/style-export-sample.json`:

```json
{
  "style": "{base style id}",
  "less": { "@variable-name": "value" },
  "modified": "{ISO 8601 timestamp with milliseconds}",
  "name": "{Readable name}"
}
```

**Step 0 — choose the base style.** `style` is **not** a project slug: it is the id of an existing
base style (`vendor/assets/uikit-themes/master-<id>/`) that the custom style layers on top of. In
the sample, `"style": "joline"` is an official style while `name` is the project's own label. Unless
the user names a style, pick one with the matcher:

1. From the preview, extract: background (White / Light / Dark / Black), primary colour family
   (warm / cool / neutral), visual type (Flat / Modern / Skeuomorphic).
2. If the theme source is available, read the header comment (`Name / Background / Color / Type`)
   of each `less/theme.*.less` and score: background match +3, type match +2, primary colour in the
   same family +1.
3. Quick reference when the source is not available:

   | Type | Background | Suggested base |
   |---|---|---|
   | Flat | White | `balou`, `craft`, `fjord` |
   | Flat | Dark / Black | `district`, `devstack`, `fuse` |
   | Modern | White | `morgan-consulting`, `makai` |
   | Skeuomorphic | Black | `circle` |
   | Minimal | White, neutral | `uikit` (plain base) |

4. Score ≥ 4 → use that style as the base. Below 4 → use `uikit`, the plain base. Tell the user
   which base you chose and why.

**`less` is delta-only.** Read the chosen base's `_import.less` for its defaults (when available)
and emit **only** variables whose value differs from the base — never repeat a default. The sample
overrides ~46 variables out of the hundreds its base defines.

**Variable validity.** Every `@variable` you emit must have been read this session — in the base
style's `_import.less`, the theme's `less/theme.less`, `vendor/assets/uikit/src/less/**`, or a
`wiki/uikit/` page — never produced by analogy. Variables absent from every Customizer panel group
are still legitimate: the Customizer's generic "custom variable" control accepts any `@` name.

**Google Fonts — `@internal-fonts`.** When a `*-font-family` override names a Google Font the base
style does not already load, also set `@internal-fonts` to the Google Fonts query string for every
custom family in use, joined with `|`, each with only the weights actually referenced —
**including the LESS tilde-escape**, exactly as the sample stores it:
`"~'Family:weight1,weight2|Family2:weight1'"` (the `~'...'` is part of the JSON string value).
Without it the font is named in CSS but never loaded.

- `less` is a **flat** map, `"@variable": "literal value"`.
- `modified` = ISO 8601 with milliseconds, like JS `Date.prototype.toISOString()`.
- The JSON is strict — no comments. Report uncertainty about individual variables in chat.
- Save as `style.<name-slug>.json` next to the layout JSON if one was generated.

## Validate only

Run the validator on the user's file, explain each finding with a link to the relevant wiki page
(`wiki/issues/*` covers most of them), and offer a fixed copy. Never overwrite the user's file
without asking.

## Validation — mandatory before delivering any JSON

Run the validator and show its output:

```bash
bash "<base directory>/scripts/validate.sh" path/to/file.json
```

It detects layouts, single elements and style files, and checks every canonical invariant: object
root, no node-level `id`, no `null`, `props` an object, leaf nodes without `children`,
`image`/`link`/`video` as strings, valid UIkit fractions (never twelfths), `width_*` on the columns
of every fractional row, `grid_*` as counts, no gradient in `media_overlay`, `name` never inside
`props`, plus the single-element wrapper (`name`, string `version`, ISO `modified`) and the
four-key style wrapper. Errors must be fixed; warnings must be justified. The validator was tested
against 80 real YOOtheme exports with zero false positives. It needs `jq`; if `jq` is missing, ask
the user to install it rather than skipping validation.

What the script cannot check — verify by reading:

- Every prop name and select value exists in `element-types.md` / the wiki for that element type.
- `button_item` uses `content` + `button_style` (never `title`/`style`/`link_style`); size is
  `button_size` on the parent `button`.
- For style files: every `less` key was found by name in a LESS source, not merely plausible.

## Common mistakes (observed when generating without this skill)

| Wrong (plausible from memory) | Right (from the references) |
|---|---|
| `grid` with `panel` children | `grid` with `grid_item` children |
| `grid_default: "1-3"` | `grid_default: "3"` |
| `section.padding: "xlarge"` | `section.padding_top` / `padding_bottom` |
| `quotation.meta: "Laura M."` | `quotation.author` (+ `footer`) |
| `button_item.link_style` / `link_size` | `button_item.button_style`; `button.button_size` |
| `animation_delay: true` on `grid` for stagger | `grid.item_animation` |
| `props: { "name": "..." }`, or `name` on every node | `"name"` as a sibling key of `type`, only on `section` nodes |
| `"children": []` on a leaf node (`headline`, `text`, `image`, `button_item`, …) | omit `children` entirely on leaf nodes |
| A single element wrapped in `layout`/`section`, or without `name`/`modified`/`version` | root is the element itself plus those three keys |
| Root as a bare array `[{ "type": "section", ... }]` | the `{"type":"layout", "version":"...", "children":[...]}` object |
| `row.layout: "1-2,1-2"` alone, columns with only `vertical_align` | the same fraction on every column too: `"width_medium": "1-2"` |
| `section.media_overlay: "linear-gradient(...)"` | a plain colour; a gradient goes in `media_overlay_gradient` |

Each of these came from analogy with real props. If you did not just read the prop, look it up.

## Observation capture

When the user reports a behaviour, correction or discovery ("this prop doesn't work like that", "on
my install X happens"):

1. **Capture it immediately** to
   `${YOOTHEME_WIKI_HOME:-$HOME/.yootheme-wiki}/observations/YYYY-MM-DD-<slug>.md` (create the
   directory if missing; never write inside the plugin directory — it is replaced on update).
   Include: the observation verbatim, the JSON/LESS involved, the YOOtheme version if known, the
   date, and what prompted it.
2. Check the knowledge base: does a wiki page already cover it, confirm it, or contradict it? Tell
   the user, and from now on in this session prefer the observation over a contradicted page —
   stating that you are doing so.
3. Offer to draft a GitHub issue for the plugin repository (title, observation, evidence, affected
   wiki pages) so it can be verified and merged into the shared knowledge base. Do not open it
   yourself unless asked.

Maintainers working in a clone of the repository follow the supervised ingest workflow in the
repository's `CLAUDE.md` instead.

## Red flags — stop and re-read

- Emitting a prop you have not read in this session
- "This element surely works like `panel`" — analogy is how the wrong props above were born
- A fraction not in the valid UIkit list, or a fraction in a `grid_*` breakpoint prop
- A `row` with a fractional `layout` whose columns have no `width_*`
- A `version` newer than the user's installed theme
- Delivering JSON without running `scripts/validate.sh`
- Writing anything inside the plugin's own directory
