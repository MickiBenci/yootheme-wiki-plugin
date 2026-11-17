#!/usr/bin/env bash
# validate.sh — mechanical import checks for YOOtheme Pro builder JSON.
#
# Usage: validate.sh [--quiet] FILE.json [FILE.json ...]
#
# Detects the file kind automatically:
#   layout   root {"type":"layout", ...}             (Builder → Library → Layouts / page import)
#   element  root {"type":"<element>", name, ...}    (Builder → Library → Elements import)
#   style    root {"style", "less", ...}             (Customizer → Style library import)
#
# Exit status: 0 when every file passes (warnings allowed), 1 on any error, 2 on usage problems.
# Requires: jq >= 1.6

set -euo pipefail

QUIET=0
if [[ "${1:-}" == "--quiet" ]]; then QUIET=1; shift; fi

if [[ $# -eq 0 ]]; then
  echo "usage: $(basename "$0") [--quiet] FILE.json [FILE.json ...]" >&2
  exit 2
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required (https://jqlang.github.io/jq/)" >&2
  exit 2
fi

# jq program: emits one line per finding, "ERROR\t<msg>" or "WARN\t<msg>".
read -r -d '' CHECKS <<'JQ' || true
def valid_fraction:
  test("^(1-1|1-2|1-3|2-3|1-4|3-4|1-5|2-5|3-5|4-5|1-6|5-6|small|medium|large|xlarge|2xlarge|auto|expand)$");
def leaf_types:
  ["headline","text","image","icon","divider","code","html","alert","quotation","countdown",
   "panel","overlay","video","totop","breadcrumbs","newsletter","search","social_item"];
def is_leaf: (.type | type == "string") and ((.type | endswith("_item")) or (.type as $t | leaf_types | index($t) != null));
def structural: ["section","row","column","fragment"];
def nodes: [.. | objects | select(has("type") and has("props"))];
def P: if (.props | type) == "object" then .props else {} end;
def iso_ms: type == "string" and test("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z$");

def node_checks($root):
  ( [.. | nulls] | length ) as $n
  | (if $n > 0 then "ERROR\t\($n) null value(s) — use \"\" for empty values" else empty end),
  ( nodes[] as $node | $node.type as $t |
      (if ($node | has("id")) then "ERROR\tnode-level \"id\" on a \($t) node — remove it (the id prop belongs inside props)" else empty end),
      (if ($t | startswith("builder_")) then "ERROR\ttype \"\($t)\" — element types never carry a builder_ prefix" else empty end),
      (if ($node.props | type) == "object" or $node.props == [] then empty
       else "ERROR\t\($t).props is \($node.props | type) — must be an object" end),
      (if ($node | is_leaf) and ($node | has("children")) then "ERROR\tleaf node \($t) has a \"children\" key — omit it entirely" else empty end),
      (if ($node | has("children")) and (($node.children | type) != "array") then "ERROR\t\($t).children is \($node.children | type) — must be an array" else empty end),
      (if ($node.props | type) == "object" then
         ($node.props | to_entries[] |
           (if (.key == "image" or .key == "link" or .key == "video") and (.value | type) != "string"
              then "ERROR\t\($t).props.\(.key) is \(.value | type) — must be a plain string" else empty end),
           (if .key == "name" then "ERROR\t\($t).props.name — name is a node key (sibling of type), never inside props" else empty end),
           (if .key == "media_overlay" and (.value | type) == "string" and (.value | test("gradient\\("))
              then "ERROR\t\($t).props.media_overlay holds a gradient — use a flat colour; gradients go in media_overlay_gradient" else empty end),
           (if (.key | test("^grid_(default|small|medium|large|xlarge)$")) and (.value | type) == "string" and (.value | test("-"))
              then "ERROR\t\($t).props.\(.key) = \"\(.value)\" — grid columns are counts (\"3\"), not fractions" else empty end)
         )
       else empty end),
      (if $t == "row" then ($node | P | .layout // "") as $layout |
         (if ($layout | type) == "string" and $layout != "" then
           ($layout | split("|")[] | split(",")[] | select(. != "" and (valid_fraction | not))
             | "ERROR\trow.layout fraction \"\(.)\" is not a valid UIkit width (never twelfths)"),
           (if ($layout | split("|")[0] | split(",") | length) > 1
              and ([$node.children[]? | P | select(((.width_default // "") + (.width_small // "") + (.width_medium // "") + (.width_large // "") + (.width_xlarge // "")) == "")] | length) > 0
            then "ERROR\trow.layout \"\($layout)\" has column(s) without width_* — columns will import stacked full-width" else empty end)
          else empty end)
       else empty end),
      (if $t == "column" then
         ($node | P | to_entries[] | select(.key | test("^width_")) | select((.value | type) == "string" and .value != "" and (.value | valid_fraction | not))
           | "ERROR\tcolumn.\(.key) = \"\(.value)\" is not a valid UIkit width")
       else empty end),
      (if ($node | has("name")) and ($t != "section") and ($t != "layout") and ($node != $root)
         then "WARN\t\"name\" on a \($t) node — real exports name almost only sections" else empty end)
  );

if type != "object" then
  "ERROR\troot is \(type) — must be an object (a bare array is never accepted as a layout)"
elif has("style") and has("less") then
  # ---- style.json (Customizer style library) ----
  (if (keys | sort) != ["less","modified","name","style"] then "ERROR\tstyle file keys are \(keys) — expected exactly style, less, modified, name" else empty end),
  (if (.style | type) != "string" or .style == "" then "ERROR\tstyle must be the base theme id (e.g. \"joline\")" else empty end),
  (if (.name | type) != "string" or .name == "" then "ERROR\tname must be a non-empty string" else empty end),
  (if (.modified | iso_ms | not) then "ERROR\tmodified must be ISO 8601 with milliseconds (Date.toISOString())" else empty end),
  (if (.less | type) != "object" then "ERROR\tless must be a flat object" else
     (.less | to_entries[] |
       (if (.key | startswith("@") | not) then "ERROR\tless key \"\(.key)\" must start with @" else empty end),
       (if (.value | type) != "string" then "ERROR\tless value for \(.key) must be a string" else empty end))
   end),
  (if (.less | type) == "object" and ([.less | keys[] | select(endswith("-font-family"))] | length) > 0 and ((.less | has("@internal-fonts")) | not)
     then "WARN\tfont-family overrides without @internal-fonts — Google Fonts will not be loaded unless the base theme already loads them" else empty end)
elif .type == "layout" then
  # ---- full layout ----
  . as $root
  | (if (.version | type) != "string" then "ERROR\tlayout.version must be a string (e.g. \"5.0.43\")" else empty end),
    (if (.children | type) != "array" then "ERROR\tlayout.children must be an array of sections" else
       (.children[] | select(.type != "section") | "ERROR\ttop-level child of type \(.type) — layout children must be sections") end),
    node_checks($root)
elif (.type | type) == "string" then
  # ---- single element (Library > Elements export) ----
  . as $root
  | (if (.type as $t | structural | index($t) != null) then "ERROR\tsingle-element root is a \(.type) — the root must be the element itself" else empty end),
    (if (.name | type) != "string" or .name == "" then "ERROR\tsingle element needs a non-empty name" else empty end),
    (if (.version | type) != "string" then "ERROR\tsingle element needs a string version (import throws \"Invalid argument expected string\" otherwise)" else empty end),
    (if (.modified | iso_ms | not) then "ERROR\tmodified must be ISO 8601 with milliseconds" else empty end),
    node_checks($root)
else
  "ERROR\tunrecognised file: expected a layout, a single element or a style export"
end
JQ

status=0
for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    echo "✗ $file: file not found"; status=1; continue
  fi
  if ! jq empty "$file" 2>/dev/null; then
    echo "✗ $file: invalid JSON — $(jq empty "$file" 2>&1 | head -1)"; status=1; continue
  fi
  kind=$(jq -r 'if type!="object" then "invalid" elif has("style") and has("less") then "style" elif .type=="layout" then "layout" else "element" end' "$file")
  findings=$(jq -r "$CHECKS" "$file")
  errors=$(grep -c '^ERROR' <<<"$findings" || true)
  warns=$(grep -c '^WARN' <<<"$findings" || true)
  if [[ "$errors" -gt 0 ]]; then
    echo "✗ $file ($kind): $errors error(s), $warns warning(s)"; status=1
  else
    if [[ "$warns" -gt 0 ]]; then echo "✓ $file ($kind): passed with $warns warning(s)"; else echo "✓ $file ($kind): passed"; fi
  fi
  if [[ $QUIET -eq 0 && -n "$findings" ]]; then
    sed -e 's/^ERROR\t/    error: /' -e 's/^WARN\t/    warn:  /' <<<"$findings"
  fi
done
exit $status
