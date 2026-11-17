#!/usr/bin/env bash
# Validator regression tests: every file in fixtures/valid must pass, every file in fixtures/invalid must fail.
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
validate="$here/../skills/builder/scripts/validate.sh"
fail=0
for f in "$here"/fixtures/valid/*.json "$here"/../skills/*/examples/*.json; do
  if ! bash "$validate" --quiet "$f" >/dev/null; then echo "FAIL (expected pass): $f"; bash "$validate" "$f"; fail=1; fi
done
for f in "$here"/fixtures/invalid/*.json; do
  if bash "$validate" --quiet "$f" >/dev/null; then echo "FAIL (expected error): $f"; fail=1; fi
done
[[ $fail -eq 0 ]] && echo "All validator tests passed." || exit 1
