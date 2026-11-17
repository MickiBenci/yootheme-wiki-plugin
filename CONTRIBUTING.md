# Contributing

Thanks for helping keep the knowledge base accurate. YOOtheme Pro is proprietary and its builder
JSON is largely undocumented, so **real-world evidence is the most valuable contribution**.

## Reporting an observation or a correction

Open an issue with the **YOOtheme behaviour observation** template. Include:

- what you expected and what actually happened;
- your YOOtheme Pro version and platform;
- the smallest JSON or LESS snippet that shows it — **remove client names, copy, images and URLs**.

If you use the plugin, the `builder` skill can draft the issue for you from an observation you
report in chat.

An observation is verified before it changes a `verified` page. Until then it can be recorded as
`inferred`.

## Changing the repository

1. Read [`CLAUDE.md`](CLAUDE.md) — it defines the wiki conventions (frontmatter, `status`,
   props-first page architecture, wikilinks) and the ingest workflow. Claude Code reads it
   automatically when you work in a clone.
2. Keep pages in English; keep YOOtheme and UIkit identifiers verbatim.
3. Every JSON snippet in `wiki/recipes/` must be importable as-is and pass the validator.
4. A change to a canonical invariant must update, together: the `json-schema` skill, the
   validator (`skills/builder/scripts/validate.sh`), a fixture in `tests/fixtures/`, and an
   `issues/` page explaining the evidence.
5. Run the checks before opening a pull request:

   ```bash
   bash tests/run.sh
   bash scripts/lint-wiki.sh
   claude plugin validate .
   ```

6. Add a line to `CHANGELOG.md` under an `Unreleased` heading, and to `WIKI-LOG.md` for wiki work.

## What must never be committed

- YOOtheme Pro source code, compiled assets or official demo content.
- Third-party articles or documentation copied verbatim.
- Client data of any kind.

Primary sources live in a local, git-ignored `raw/` directory. The wiki summarises them in its own
words and cites the file path so anyone with a licensed copy can verify the claim.

## Releases

Maintainers bump `version` in `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
(CI checks they match), move the `Unreleased` changelog entries under the new version, and tag
`vX.Y.Z`.
