#!/usr/bin/env bash
# Usage: verify.sh path/to/paper.tex [outdir]
# Compiles, reports real problems, and renders pages to PNG for visual inspection.
set -u
TEX="$1"; OUT="${2:-$(mktemp -d)}"; mkdir -p "$OUT"
cd "$(dirname "$TEX")"
if command -v tectonic >/dev/null; then
  tectonic --outdir "$OUT" "$(basename "$TEX")" 2>&1 | tee "$OUT/build.log" >/dev/null
elif command -v latexmk >/dev/null; then
  latexmk -xelatex -outdir="$OUT" "$(basename "$TEX")" >"$OUT/build.log" 2>&1
else
  echo "no TeX engine found (tectonic or latexmk)"; exit 1
fi
echo "== errors / undefined =="
grep -iE "^error|! |undefined|Citation .* undefined|Reference .* undefined" "$OUT/build.log" | sort -u | head -20
echo "== overfull boxes (> 3pt) =="
grep -E "Overfull" "$OUT/build.log" | awk '{ v=$4; gsub(/[^0-9.]/,"",v); if (v+0 > 3) print }' | sort -u | head -20
PDF="$OUT/$(basename "${TEX%.tex}").pdf"
[ -f "$PDF" ] || { echo "no PDF produced"; exit 1; }
uv run --with pymupdf python - "$PDF" "$OUT" <<'PY'
import sys, pymupdf
d = pymupdf.open(sys.argv[1]); print(len(d), "pages")
for i, p in enumerate(d): p.get_pixmap(dpi=90).save(f"{sys.argv[2]}/page{i+1}.png")
print("rendered to", sys.argv[2], "-- open each PNG and look at it")
PY
