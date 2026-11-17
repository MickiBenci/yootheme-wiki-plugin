# CLAUDE.md

Guidance for Claude Code when **maintaining** this repository. (Plugin users never read this file:
they get the skills under `skills/`.)

---

This repository is a Claude Code plugin built around an **LLM Wiki** about YOOtheme Pro: a
markdown knowledge base that Claude writes and maintains, while maintainers curate the sources and
ask the questions. The value lies in **accumulation**: every ingested source and every useful
answer becomes a permanent page, not text that disappears into chat history.

## Repository layout

```
.claude-plugin/
  plugin.json             # plugin manifest
  marketplace.json        # lets the repo be added as a marketplace
skills/
  builder/                # main skill: generation, validation, observation capture
    SKILL.md
    index.md              # catalogue of the whole wiki — entry point for every query
    wiki/
      elements/           # one page per builder element type
      props/              # cross-cutting prop families
      concepts/           # dynamic content, style/customizer, import formats…
      uikit/              # UIkit components, classes and LESS variables
      recipes/            # solved patterns with importable JSON
      sources/            # one summary page per ingested source
      issues/             # gotchas, contradictions, undocumented behaviour
    examples/             # real export samples (sanitised)
    scripts/validate.sh   # mechanical import checks
  json-schema/            # canonical baseline: node hierarchy, element types, serialisation
  animations/             # canonical baseline: scrollspy, parallax, effects
tests/                    # validator fixtures + runner
WIKI-LOG.md               # append-only chronological record of wiki work
raw/                      # LOCAL ONLY, git-ignored: primary sources (see below)
```

## Three layers

| Layer | Location | Who writes |
|---|---|---|
| Raw sources | `raw/` (local, git-ignored) | Maintainers, plus extractions Claude performs **only when explicitly asked**. **Immutable once written.** |
| Wiki | `skills/builder/wiki/`, `skills/builder/index.md`, `WIKI-LOG.md` | Claude, entirely |
| Schema | `CLAUDE.md` (this file) | Claude and maintainers, co-evolved |

**`raw/` is never committed.** It holds copyrighted material — the YOOtheme Pro source code,
official demo exports, third-party articles, client layouts — that cannot be redistributed. The
wiki summarises and cites it; `sources/` pages name the raw file they came from so a maintainer
with their own copy can re-check any claim. Anything that must ship with the plugin (an example
export, for instance) goes to `skills/builder/examples/` only after removing client names, copy,
images and URLs.

## Page conventions

Every page in `wiki/` has YAML frontmatter (Obsidian Dataview compatible):

```yaml
---
title: panel element
type: element          # element | prop | concept | uikit | recipe | source | issue
status: verified       # see below
yootheme_version: "5.0.33"   # version the fact was observed on
sources: ["[[sources/yootheme-pro-5.0.33-source]]"]
tags: [builder, card]
updated: 2026-07-29
---
```

**`status` is the most important convention.** YOOtheme Pro is proprietary and its documentation
is incomplete: much of what we know comes from exported JSON and reverse engineering. Never present
an inference as a fact.

| status | Meaning |
|---|---|
| `verified` | Observed on a real installation, in the theme source, or in a real export |
| `documented` | Stated by the official YOOtheme docs, not independently verified |
| `inferred` | Deduced from patterns or analogy. Must always be flagged as such in the body |
| `contested` | Sources disagree, or behaviour changed across versions → has a page in `issues/` |

Other rules:
- **Naming**: kebab-case filenames, name = slug of the entity (`panel.md`, `dynamic-content.md`).
- **Wikilinks**: `[[elements/panel]]`, path relative to `wiki/`. A link to a page that does not
  exist yet signals work to be done, not an error.
- **Citations**: every non-obvious claim points to the `sources/` page it came from.
- **Versioning**: when a fact only holds from a given version on, say so in the body (`since 4.4:`).
- **JSON snippets**: valid and importable as-is — `{"type":"layout",…}` root, no node `id`, leaf
  nodes without `children`. If a snippet is illustrative only, say so explicitly.
- **Language**: English. YOOtheme and UIkit identifiers — element types, props, CSS classes, LESS
  variables — stay in their exact original form.
- **No private data**: no client names, domains, copy or personal details in any committed file.
- Never delete a superseded claim: mark it and explain what replaced it.

## Sources of truth

### Primary: the theme source

A maintainer's local extraction of the YOOtheme Pro source (`raw/yootheme_wp_<version>/`) is the
highest authority:

- `packages/*/elements/<name>/element.php` — every prop, its `type`, `options`, `defaults` and
  conditional `enable` rules
- `packages/*/elements/<name>/templates/*.php` — the HTML and UIkit classes actually emitted
- `packages/*/elements/<name>/updates.php`, `packages/builder/updates.php` — prop migrations keyed
  by version: the definitive answer to "since when"
- `packages/builder/config/builder.php` — the shared field library referenced by every element

A fact read directly from these files is `verified`. **The source outranks the skills.**

### Baseline: two canonical skills

`skills/json-schema/` (node hierarchy, element types, props, serialisation) and
`skills/animations/` (scrollspy, parallax, effects) are the **canonical baseline**. Do not rewrite
them into the wiki: pages under `wiki/elements/*` **extend** them (use cases, gotchas,
interactions, observed behaviour) and link back.

If a source **contradicts** a skill, never patch the skill silently: open a page in
`wiki/issues/` and raise it with the maintainer. Skills are edited only with explicit approval; the
issue page records the resolution and the skill's `version` is bumped. Any change to an invariant
must also be reflected in `skills/builder/scripts/validate.sh` and covered by a fixture in
`tests/fixtures/`.

Canonical invariants: no node-level `id`; `props` always an object (real exports serialise empty
props as `[]`, which import accepts); `children` an array on containers and absent on leaves;
`image`/`link` strings; no `null`; `row.layout` fractions only from the valid UIkit list, mirrored
as `width_*` on the columns.

## Scope

**WooCommerce is out of scope.** The 16 elements of `packages/builder-wordpress-woocommerce/` are
deliberately not documented; their absence from `index.md` is a decision, not a gap.

In scope: **59 elements** — the 51 of `packages/builder/`, the 5 WordPress ones, the 2
WordPress-source ones, and `newsletter`.

## Page architecture: props-first

Prop families are documented **once** in `props/` and linked from element pages. Across the 59
in-scope elements there are 525 distinct props, only 118 shared by 5+ elements while 253 are unique
to one. Large elements are mostly shared props: `panel` 93%, `headline` 98%, `accordion` 96%,
`image` 93%, `grid` 63%.

An `elements/` page therefore carries only the **delta**:

1. Identity — what the element is, its `group`, `container` or `element`
2. Non-empty `defaults` — values that surprise when absent from the JSON
3. Props unique to this element
4. A table linking the prop families it uses, noting local differences only
5. Resets and transforms from its templates
6. The UIkit output, linking `uikit/`
7. Gotchas and interactions with other elements

Target 60–90 lines for a large element. `elements/panel.md` is the reference shape.

## Workflow: ingest

Default: **one source at a time, supervised.**

1. The source must live in `raw/` first — the wiki is never the only copy of a source.
2. Read it in full.
3. **Discuss the takeaways before writing**: which pages you will touch, what it contradicts.
4. Write `wiki/sources/<slug>.md`: summary, what is new, what it confirms, what it contradicts.
5. **Propagate** (typically 5–15 pages): elements, props, uikit, recipes; promote `status` of pages
   the source verifies.
6. **Contradictions**: never overwrite silently — open/update an `issues/` page, set
   `status: contested`, record both versions with their YOOtheme versions.
7. Update `skills/builder/index.md`.
8. Append to `WIKI-LOG.md`.

**Community observations** arrive as GitHub issues (the plugin drafts them from
`~/.yootheme-wiki/observations/`). Treat each one as a source: save it to `raw/observations/`, then
ingest as above. An unverified observation becomes at most an `inferred` page.

## Workflow: query

1. Read `index.md`, then the pages. Do not answer from memory.
2. If the wiki does not cover the question, say so, and separate wiki facts from inference.
3. Cite with wikilinks.
4. If the answer has lasting value, offer to file it as a `recipes/` or `concepts/` page.

## Workflow: lint

On request, run the commands below and report broken links, orphans, pages without `status`, stale
`inferred` pages, open `contested` pages, missing concept pages, outdated `yootheme_version`s.
Lint **proposes**; it does not rewrite on its own.

## WIKI-LOG.md

Chronological and append-only, with a strict greppable prefix:

```
## [2026-07-29] ingest | Official builder elements documentation
```

Valid types: `ingest`, `query`, `lint`, `refactor`, `release`. Below the heading, 1–3 lines.

## Commands

Run from the repository root.

```bash
# Validator regression tests (also run in CI)
bash tests/run.sh

# Validate a generated file
bash skills/builder/scripts/validate.sh path/to/file.json

# Wiki lint (broken links, orphans, frontmatter, index coverage)
bash scripts/lint-wiki.sh

# Most recent wiki activity
grep "^## \[" WIKI-LOG.md | tail -5

# Inventory by verification status
grep -rh "^status:" skills/builder/wiki --include="*.md" | sort | uniq -c
```

## Releasing

1. Bump `version` in `.claude-plugin/plugin.json` (semver) and add a `CHANGELOG.md` entry.
2. `bash tests/run.sh && bash scripts/lint-wiki.sh` must pass.
3. Tag `vX.Y.Z` and push; users update with `/plugin marketplace update`.
