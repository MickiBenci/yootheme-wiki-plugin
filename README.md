# YOOtheme Wiki — Claude Code plugin for YOOtheme Pro

Generate **importable YOOtheme Pro builder JSON** with Claude Code: full layouts and landing pages,
single Library elements, and Customizer styles (LESS + `style.json`). Every output is grounded in a
verified knowledge base about the YOOtheme Pro builder and checked by a validator before it reaches
you.

Generic LLMs write YOOtheme JSON that looks right and fails on import: props that do not exist,
`image` as an object, `"children": []` on leaf nodes, twelfth-width columns, a bare-array root.
This plugin exists to stop that. It was built by reverse-engineering the YOOtheme Pro 5.0.x source
and checking the results against 80 real exports.

## What you get

| Skill | Invoke | Use it for |
|---|---|---|
| `builder` | `/yootheme-wiki:builder` | Layouts from a brief or an HTML page, single Library elements, LESS + Customizer `style.json` from a preview, validating/fixing JSON, recording YOOtheme behaviour you observe |
| `json-schema` | `/yootheme-wiki:json-schema` | Reading, explaining and debugging builder JSON; full element and prop reference |
| `animations` | `/yootheme-wiki:animations` | Scrollspy entrances, staggered grids, parallax, SVG stroke, Ken Burns |

Skills also trigger on their own when you ask Claude for something they cover.

Under the hood:

- **A knowledge base** (`skills/builder/wiki/`) of 67 pages — elements, prop families, concepts,
  UIkit, importable recipes, source summaries and resolved issues — each tagged `verified`,
  `documented`, `inferred` or `contested`.
- **A validator** (`skills/builder/scripts/validate.sh`) that catches the import-breaking mistakes
  above for layouts, single elements and style files. Zero false positives on 80 real YOOtheme
  exports.
- **Worked examples**: a complete home page layout, a real single-element export, a real Customizer
  style export, and animation samples.

## Installation

Requires [Claude Code](https://claude.com/claude-code) and [`jq`](https://jqlang.github.io/jq/)
(`brew install jq`, `apt install jq`, `winget install jqlang.jq`).

```text
/plugin marketplace add MickiBenci/yootheme-wiki-plugin
/plugin install yootheme-wiki@yootheme-wiki
```

Update later with `/plugin marketplace update yootheme-wiki`.

## Usage

```text
/yootheme-wiki:builder landing page for a yoga studio: hero with a CTA, three class cards,
pricing table, FAQ and a contact section. Real copy below: …

/yootheme-wiki:builder convert ./preview/index.html into a YOOtheme layout and a matching style

/yootheme-wiki:builder validate ./exports/home.json

/yootheme-wiki:animations staggered slide-up on the services grid in ./home.json
```

The builder skill states an outline before generating, saves the JSON to your working directory,
runs the validator and shows the result. Import the file in YOOtheme Pro through
**Builder → Library → Import** (layouts and elements) or **Customizer → Style → Library**
(`style.*.json`).

You can also run the validator yourself:

```bash
bash ~/.claude/plugins/cache/*/yootheme-wiki/*/skills/builder/scripts/validate.sh layout.json
```

### Optional configuration

| Variable | Purpose |
|---|---|
| `YOOTHEME_PRO_PATH` | Path to your YOOtheme Pro theme directory (e.g. `wp-content/themes/yootheme`). When set, Claude reads exact element defaults and LESS variables from your own installation instead of relying on the knowledge base alone. |
| `YOOTHEME_WIKI_HOME` | Where observations you report are saved (default `~/.yootheme-wiki`). |

Tell Claude your installed YOOtheme Pro version: an exported file whose `version` is newer than
the theme fails to import. The default is `5.0.43`.

## How it stays accurate

1. **Every prop is looked up, never recalled.** The skill requires Claude to read the reference
   entry for every element type it emits.
2. **Status discipline.** Pages say whether a fact was verified in the theme source or a real
   export, documented by YOOtheme, or only inferred.
3. **Mechanical validation** before delivery, with fixes for every error.
4. **Observations feed back.** When you tell Claude "this prop behaves differently on my install",
   it saves the observation locally and offers to draft a GitHub issue so the knowledge base can be
   corrected for everyone.

## Compatibility

- Verified against **YOOtheme Pro 5.0.33 – 5.0.53** (WordPress). The builder JSON format is shared
  with the Joomla edition; WordPress-specific elements are marked as such.
- WooCommerce builder elements are out of scope.

## Contributing

Corrections are the most valuable contribution: open an issue with what you observed, your
YOOtheme Pro version and the JSON involved. See [CONTRIBUTING.md](CONTRIBUTING.md) for the
knowledge-base conventions and the maintainer workflow.

## Disclaimer

This is an independent community project, not affiliated with or endorsed by YOOtheme GmbH.
"YOOtheme" and "YOOtheme Pro" are trademarks of their owner. The repository contains no YOOtheme
source code, assets or demo content: the knowledge base describes the builder's JSON format in its
own words and cites file paths for verification against your own licensed copy.

## License

[MIT](LICENSE)
