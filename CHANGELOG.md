# Changelog

All notable changes to this plugin are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses
[Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-11-17

First public release as a Claude Code plugin.

### Added
- Plugin manifest and marketplace manifest (`/plugin marketplace add MickiBenci/yootheme-wiki-plugin`).
- `builder` skill: layouts from a brief or HTML, single Library elements, LESS + Customizer
  `style.json`, validate-only mode, observation capture to `~/.yootheme-wiki/observations/`.
- `scripts/validate.sh`: mechanical import checks for layouts, single elements and style files,
  tested against 80 real YOOtheme Pro exports with zero false positives.
- Validator regression fixtures (`tests/`), wiki lint (`scripts/lint-wiki.sh`) and CI.
- Optional `YOOTHEME_PRO_PATH` to read defaults and LESS variables from the user's own installation.

### Changed
- Everything translated to English, including the `json-schema` (v3.0.0) and `animations`
  (v2.0.0) skills, formerly `yootheme-json-schema` and `apply-animations`.
- `json-schema/references/field-types.md` rewritten: `image`, `link`, `video` and `location`
  serialise as plain strings and item lists as child nodes, matching every real export.
- Element reference and animation examples: leaf nodes no longer carry `"children": []`; examples
  use the `{"type":"layout", …}` root and set `width_*` on the columns of fractional rows.
- Wiki recipes converted from bare-array roots to importable `layout` objects.
- Theme-similarity matcher for choosing a Customizer base style is now built into the skill.

### Removed
- The raw source corpus (YOOtheme Pro source code, official demo exports, third-party articles,
  client layouts). It is copyrighted or private; the wiki keeps its own summaries and citations.
- Client names, copy, images and URLs from every example and page.
