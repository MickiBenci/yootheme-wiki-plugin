# Index — YOOtheme Pro Wiki

Catalogue of every page in the wiki. Entry point for all queries. Pages live in `wiki/`; a wikilink to `folder/page` is the file `wiki/folder/page.md`.
`status` legend: `verified` · `documented` · `inferred` · `contested`.

Paths such as `raw/…` or `element.php` cited inside pages refer to the maintainers' local source
corpus (YOOtheme Pro source and real exports), which is not redistributed. To check a claim, open
the same path in your own YOOtheme Pro installation.

Current baseline: **YOOtheme Pro 5.0.33** (released 2026-05-21). Diffed against **5.0.43** on
2026-09-08 and against **5.0.53** (2026-10-21) on 2026-10-30 — no element or prop added/removed/renamed; template, migration and custom-CSS fixes only, see
[[sources/yootheme-pro-5.0.43-source]] and [[sources/yootheme-pro-5.0.53-source]].

## Elements (`wiki/elements/`)

| Page | Summary | status |
|---|---|---|
| [[elements/section]] | Top-level structural container: style, padding, height, media, sticky, decorative title | `verified` |
| [[elements/grid]] | Collection of cards built from `grid_item` children — columns, filter, lightbox, masonry. Not a layout grid | `verified` |
| [[elements/grid_item]] | One card inside a grid. Carries content; the parent carries styling | `verified` |
| [[elements/breadcrumbs]] | WordPress system element: `show_home`, `show_current`, `home_text`; trail computed at render, never stored in JSON | `verified` |
| [[elements/panel]] | The single card. Shares its prop vocabulary with `grid` | `verified` |

_Canonical baseline for all element types: the `json-schema` skill. 54 of the 59 in-scope
elements still to be documented._

**WooCommerce is deliberately out of scope** — the 16 elements of
`packages/builder-wordpress-woocommerce/` are not documented. See the Scope section of the repository's `CLAUDE.md`.

## Props and field types (`wiki/props/`)

Prop families are documented here **once** and linked from the element pages — see the
"Page architecture" section of the repository's `CLAUDE.md` for why.

**Universal** — on 40+ elements:

| Page | Summary | status |
|---|---|---|
| [[props/advanced-group]] | `name` `status` `source` `id` `class` `attributes` `css` `transform`. Why the `id` prop is not a node `id`, why `name` is a sibling key not a `props` key, why `row`/`column` have neither, and how `css` is scoped by generated ID | `verified` |
| [[props/position]] | `position_*` and `blend`; what `absolute` silently switches off | `verified` |
| [[props/margin]] | `margin_top` / `margin_bottom`, the `auto` expand mechanism, the first/last-child skips, the pre-5.0 migration | `verified` |
| [[props/alignment]] | `text_align*`, `block_align*`, `maxwidth*` and the breakpoint + fallback pattern | `verified` |
| [[props/visibility]] | `visibility` and its upward propagation, `html_element`, `container_padding_remove` | `verified` |
| [[props/animation]] | How the builder turns animation props into attributes. Extends the canonical `animations` skill | `verified` |
| [[props/link]] | `link` and its companions; what `panel_link` changes and silently strips | `verified` |

**Card and content families** — the bulk of every large element:

| Page | Summary | status |
|---|---|---|
| [[props/image-family]] | 28 props on 33 elements: sizing, frame, hover, sub-grid, SVG | `verified` |
| [[props/title-family]] | Appearance, linking, the title sub-grid, spacing | `verified` |
| [[props/content-family]] | Body text, columns, drop cap, display gating | `verified` |
| [[props/meta-family]] | The eyebrow label and its four placement slots | `verified` |
| [[props/panel-style]] | Card vs tile vs blank, and how `panel_padding` differs between them | `verified` |
| [[props/show-switches]] | The `show_*` masters — how they blank child props and can delete items | `verified` |
| [[props/expand-mechanism]] | `height_expand`, `image_expand` and the `*_margin_auto` flags — how cards align their links on a shared baseline | `verified` |
| [[props/media]] | Background media and video playback on containers | `verified` |

**Component families** — on several elements each:

| Page | Summary | status |
|---|---|---|
| [[props/lightbox]] | The eleven `lightbox_*`, plus `title_display` / `content_display` and what they gate | `verified` |
| [[props/slider-nav]] | `nav_*` vs `slidenav_*` vs `thumbnav_*`, and the carousel-only `slider_*` set | `verified` |

## Concepts (`wiki/concepts/`)

| Page | Summary | status |
|---|---|---|
| [[concepts/dynamic-content]] | The node-level `source` key: query, `#parent`, prop mapping, filters, `_condition`. First verified documentation | `verified` |
| [[concepts/ai-layout-generation]] | Why generic LLMs fail at YOOtheme JSON, why constrained generation works; core schema is CMS-agnostic | `inferred` |
| [[concepts/customizer-less-map]] | The two Customizer style mechanisms — physical `theme.<slug>.less` files vs the `styler.library.{id}` custom-style JSON (base theme + delta-only overrides) — plus the `@internal-fonts` Google Fonts gotcha | `verified` |
| [[concepts/single-element-export-format]] | Root of a Library > Elements export is the element itself (`type: grid`…) plus `name`/`modified`/`version`; full default props; leaf items without `children` | `verified` |
| [[concepts/library-import-version-check]] | Three Builder/Customizer Library import validators sharing one JS bundle; Element/Layout Library requires a string `version` per item — confirmed source of a real `TypeError: Invalid argument expected string` | `verified` |

_Wanted: the CSS override hierarchy ([[concepts/custom-css-boundary]], [[concepts/styling-hierarchy]],
[[concepts/el-classes]] are referenced by the demo pages and still to write), template parts, the two
layout import/export formats, the sources API runtime (`packages/builder-source/`)._

## UIkit (`wiki/uikit/`)

| Page | Summary | status |
|---|---|---|
| [[uikit/uk-card]] | What `panel_style` emits; card vs tile; LESS variables and the `color-mode` trap | `verified` |
| [[uikit/uk-grid]] | Gutters, `uk-child-width-*`, `uk-grid-match`, dividers; where else the builder emits a grid | `verified` |

## Recipes (`wiki/recipes/`)

| Page | Summary | status |
|---|---|---|
| [[recipes/single-grid-element-export]] | Standalone Grid element (12 text cards) in Library export format, from a real export | `verified` |
| [[recipes/service-card-grid]] | Responsive clickable card grid, importable JSON, every prop justified | `verified` |
| [[recipes/fullscreen-hero-slideshow]] | Full-viewport slideshow behind a transparent header, from the balou demo | `verified` |
| [[recipes/sticky-cover-sections]] | Pinned sections covered by the next, with the `parallax_target` trick, from glowbar | `verified` |
| [[recipes/price-list-description-list]] | Price/menu lists with `title_leader`, from glowbar and balou | `verified` |
| [[recipes/parallax-image-collage]] | Absolute-positioned parallax decorations plus `vw` image sizing, five demos | `verified` |
| [[recipes/eyebrow-label]] | The label above a heading: `css` prop with `.el-element`, the `meta` slot, or the `tm-eyebrow` theme class | `verified` |

## Sources (`wiki/sources/`)

| Page | Summary | status |
|---|---|---|
| [[sources/yootheme-pro-5.0.33-source]] | **The primary source.** How to read `element.php`, the templates and `updates.php` | `verified` |
| [[sources/yootheme-pro-5.0.43-source]] | Diff against 5.0.33: no new elements, one legacy-JSON migration cleanup, one out-of-scope WooCommerce prop; unlocks `customizer.js` for the Library import mechanism | `verified` |
| [[sources/yootheme-pro-5.0.53-source]] | Diff against 5.0.43: no prop changes; custom-CSS `@keyframes` prefixing fixed (5.0.51), duplicate `uk-flex` removed, panel-slider `show_hover_video` fixed, UIkit 3.25.26 | `verified` |
| [[sources/yootheme-docs-breadcrumbs]] | Official docs section + theme code for the Breadcrumbs element | `verified` |
| [[sources/skill-yootheme-json-schema]] | The canonical baseline skill — invariants, and how the wiki extends it | `verified` |
| [[sources/production-layout-sample]] | A production layout export: three grids, three configurations | `verified` |
| [[sources/websites-demo]] | **The demo corpus.** 77 pages from 12 official demos: statistics, LESS pairing, dynamic content, recurring techniques | `verified` |
| [[sources/demo-balou]] | Knitwear shop: parallax-only motion, `vw` image sizing, hero slideshow | `verified` |
| [[sources/demo-dennis-miller]] | Portfolio: `width: expand`, decorative click-through images, pill buttons from LESS | `verified` |
| [[sources/demo-design-bites]] | Resources site: muted sections, `newsletter`, accordion FAQ | `verified` |
| [[sources/demo-design-escapes]] | Travel platform: 236 bound nodes, six country pages from one template | `verified` |
| [[sources/demo-devstack]] | SaaS: `subnav`/`search`/`html` rarities, floating-UI collage, off-white ground | `verified` |
| [[sources/demo-fc-greenfield]] | Football club: `fragment` wrappers, `sticky: cover`, watermark type, `popover` | `verified` |
| [[sources/demo-framerate]] | Film magazine: dynamic slideshow heroes, 0,7% CSS — the corpus minimum | `verified` |
| [[sources/demo-glowbar]] | Beauty salon: 11 sticky-cover sections, 37 price lists, editorial stagger CSS | `verified` |
| [[sources/demo-kojiiro]] | Restaurant: scroll-over rows, `heading-*` typography, `&shy;` control | `verified` |
| [[sources/demo-line-gallery]] | Art gallery: `list`+`source` archives, 9,8% CSS — the corpus maximum | `verified` |
| [[sources/demo-oakville]] | Municipality: `fragment` duplication, `grid_default: auto`, date columns | `verified` |
| [[sources/demo-quantum-flares]] | Band: dark theme ground, `countdown`/`table`, `visibility: xl` duplication peak | `verified` |
| [[sources/yooforged-ai-guide-2026]] | **First third-party source** (marketing, conflict of interest declared): AI tooling landscape, why generic LLMs fail at YOOtheme JSON | `verified` |
| [[sources/observation-eyebrow-custom-css]] | User observation: style the eyebrow with the element `css` prop instead of a theme class | `verified` |
| [[sources/how-to-create-style-json]] | User-confirmed real Customizer style export (truncated): the `style`/`less`/`modified`/`name` wrapper for `styler.library.{id}` | `verified` |
| [[sources/style-export-sample]] | Second, complete real style export (base theme `joline`): confirms the wrapper is exactly 4 keys, `style` is the base theme id not a project slug, `less` is delta-only, and corrects the variable-validity rule | `verified` |
| [[sources/grid-element-export]] | Real single-element export (`grid`): element-as-root, `name`/`modified`/`version` wrapper, full default props | `verified` |

## Open issues (`wiki/issues/`)

| Page | Summary | status |
|---|---|---|
| [[issues/element-types-skill-vs-source]] | Six contradictions, the two root formats, the coverage gaps. **Resolved**: skill patched to v2.1.0, schema-spec.md rewritten | `verified` |
| [[issues/column-width-props]] | `column.width_*` wrongly recorded as inert; the real row↔column width mechanism. **Resolved** | `verified` |
| [[issues/eyebrow-styling-approach]] | `tm-eyebrow` theme class depended on theme LESS; default moved to the `css` prop. **Resolved**: skill patched to v2.2.0 | `verified` |
| [[issues/name-prop-node-level]] | `name` wrongly implied to live inside `props`; `row`/`column`/`layout` don't declare it at all. Addendum: declarable on 48 types ≠ populated — real exports name almost only `section`. **Resolved**: skill patched to v2.4.0 | `verified` |
| [[issues/children-key-leaf-nodes]] | `children` wrongly required on every node incl. leaves; real exports omit it entirely on leaf nodes. Likely cause of a real import failure. **Resolved**: skill patched to v2.4.0 | `verified` |
| [[issues/media-overlay-gradient-string]] | `media_overlay` held a `linear-gradient()` function instead of a plain colour — real, independent CSS bug, but source-level analysis now suggests it was probably not the actual cause of that session's `TypeError`. **Resolved**: skill patched to v2.4.1 | `verified` |
| [[issues/root-format-object-not-array]] | Root wrongly prescribed as a bare array; 78/78 real files (77-file corpus + a user export) are always the `{"type":"layout",...}` object, zero exceptions. **Resolved and source-confirmed**: skill patched to v2.5.0, mechanism verified against `customizer.js` in [[concepts/library-import-version-check]] | `verified` |
