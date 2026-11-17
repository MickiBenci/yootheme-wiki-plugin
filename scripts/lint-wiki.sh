#!/usr/bin/env bash
# lint-wiki.sh — structural health checks for the knowledge base in skills/builder.
# Fails on: broken wikilinks (except wanted pages), orphan pages, pages missing from index.md,
# pages without frontmatter status, and invalid JSON code blocks in recipes.
set -uo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
kb="$root/skills/builder"
wanted="$root/scripts/wanted-pages.txt"
cd "$kb" || exit 2
errors=0
err() { echo "error: $*"; errors=$((errors + 1)); }

# 1. Broken wikilinks
while read -r link; do
  [[ -f "wiki/$link.md" ]] && continue
  grep -qxF "$link" "$wanted" && { echo "wanted: $link"; continue; }
  err "broken wikilink [[${link}]]"
done < <(grep -rhoE '\[\[[^]|#]+' wiki index.md | sed 's/\[\[//' | sort -u)

# 2. Orphans, index coverage, frontmatter
while read -r f; do
  page=${f#wiki/}; page=${page%.md}
  grep -rqF "[[$page]]" wiki index.md || err "orphan page $page (no inbound links)"
  grep -qF "[[$page]]" index.md || err "page $page is not listed in index.md"
  head -1 "$f" | grep -qx -- '---' || err "page $page has no frontmatter"
  grep -q '^status: \(verified\|documented\|inferred\|contested\)$' "$f" || err "page $page has no valid status"
done < <(find wiki -name '*.md' | sort)

# 3. JSON code blocks in recipes must parse (illustrative fragments are marked ```jsonc or ```text)
if command -v python3 >/dev/null 2>&1; then
  while IFS= read -r line; do err "$line"; done < <(python3 -I - wiki/recipes <<'PY'
import json, pathlib, re, sys
for p in sorted(pathlib.Path(sys.argv[1]).glob("*.md")):
    for i, block in enumerate(re.findall(r"```json\n(.*?)\n```", p.read_text(encoding="utf-8"), re.S), 1):
        try: json.loads(block)
        except Exception as e: print(f"{p.name}: json block {i} does not parse ({e})")
PY
)
fi

echo "inventory: $(grep -rh '^status:' wiki | sort | uniq -c | tr -s ' ' | tr '\n' ';')"
if [[ $errors -gt 0 ]]; then echo "✗ wiki lint: $errors error(s)"; exit 1; fi
echo "✓ wiki lint passed"
