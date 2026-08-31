#!/usr/bin/env bash
# ape-present verifier. Usage: verify.sh out.html [source.md]
# Prints one line per check: PASS / FAIL / INFO. Exit 1 if any FAIL.
# Portable across macOS (BSD grep) and Linux: uses perl for anything BSD grep lacks.
set -u
OUT="${1:?usage: verify.sh out.html [source.md]}"
SRC="${2:-}"
fail=0
pass() { printf 'PASS  %s\n' "$1"; }
failm() { printf 'FAIL  %s\n' "$1"; fail=1; }
info() { printf 'INFO  %s\n' "$1"; }

text() { perl -0pe 's/<style>.*?<\/style>//s; s/<script.*?<\/script>//sg; s/<[^>]+>//g' "$OUT"; }

# Idea count: h3s when parts are used, else h2s in the body section. Needed for the
# word budget and for picking which heading level the sentence check applies to.
ideas=$(perl -0ne 'my ($b)=/(id="body".*?<\/section>)/s; $b//=""; my $h3=()=$b=~/<h3/g; my $h2=()=$b=~/<h2/g; print $h3>0?$h3:$h2' "$OUT")

# --- word budget (SKILL.md Step 3: 100-250 words per idea plus 200-400) ------------
if [ -n "$SRC" ] && [ -f "$SRC" ]; then
  s=$(wc -w < "$SRC" | tr -d ' '); d=$(text | wc -w | tr -d ' ')
  r=$(perl -e "printf '%.2f', $d/$s")
  lo=$((ideas*100+200)); hi=$((ideas*250+400))
  if [ "$d" -ge "$lo" ]; then pass "words $d for $ideas ideas (baseline $lo-$hi, source $s, ratio $r)"; else info "words $d for $ideas ideas (baseline $lo-$hi, source $s, ratio $r)"; fi
else info "no source given; word ratio skipped"; fi

# --- numbers grounded in the source -------------------------------------------------
if [ -n "$SRC" ] && [ -f "$SRC" ]; then
  # Every number in document prose (not attributes, CSS, JS) and every stat value
  # (data-to) must appear in the source text. Unit-suffixed source numbers ("1.5s",
  # "10x", "100GB") count. Ignores folio-style two-digit labels 00-99 alone.
  srcnums=$(perl -CSD -ne 'while (/(?<![\w.])(\d[\d,]*(?:\.\d+)?)/g) { my $n=$1; $n=~s/,//g; print "$n\n" }' "$SRC" | sort -u)
  docnums=$( (text | perl -CSD -ne 'while (/(?<![\w.#])(\d[\d,]*(?:\.\d+)?)/g) { my $n=$1; $n=~s/,//g; next if $n =~ /^\d{1,2}$/; print "$n\n" }'; \
              perl -ne 'while (/data-to="([\d.,]+)"/g) { my $n=$1; $n=~s/,//g; print "$n\n" }' "$OUT") | sort -u)
  missing=$(printf '%s\n' "$docnums" | while read -r n; do [ -n "$n" ] || continue; printf '%s\n' "$srcnums" | grep -qx -- "$n" || echo "$n"; done | tr '\n' ' ')
  [ -z "$missing" ] && pass "every number in prose and stats appears in the source" || failm "numbers in prose/stats not found in source: $missing"
fi

# --- colours --------------------------------------------------------------------
hex=$(perl -0ne 'my $s=$_; $s =~ s/:root[^{]*\{[^}]*\}//g; $s =~ s/\@media[^{]*\{\s*:root[^{]*\{[^}]*\}\s*\}//g; while ($s =~ /(?<=[\s:(,])(#[0-9a-fA-F]{3,8})\b/g) { print "$1\n" }' "$OUT" | sort -u | tr '\n' ' ')
[ -z "$hex" ] && pass "no hex colours outside :root" || failm "hex outside :root: $hex"

# --- externals ------------------------------------------------------------------
ext=$(perl -ne 'while (/(?:src|href)="(https?:\/\/[^"]+)"/g) { print "$1\n" }' "$OUT" \
  | grep -vE '^https?://(fonts\.googleapis\.com|fonts\.gstatic\.com|cdn\.jsdelivr\.net/npm/mathjax@3\.2\.2/)' \
  | while read -r u; do U="$u" perl -0ne 'exit(/<a [^>]*href="\Q$ENV{U}\E"/ ? 0 : 1)' "$OUT" || echo "$u"; done)
[ -z "$ext" ] && pass "no external resources beyond fonts + pinned MathJax (anchor links allowed)" || failm "unexpected external refs:\n$ext"
grep -qE 'url\(\s*["'"'"']?(https?:|data:)|@import' "$OUT" && failm "css url(http|data)/@import present" || pass "no css url(http|data)/@import"
formulas=$(grep -c 'class="formula"' "$OUT"); mj=$(grep -ic 'mathjax' "$OUT")
if [ "$formulas" -eq 0 ] && [ "$mj" -gt 0 ]; then failm "MathJax included but no .formula"
elif [ "$formulas" -gt 0 ] && [ "$mj" -eq 0 ]; then failm "$formulas .formula but MathJax script missing"
else pass "MathJax present iff .formula ($formulas formulas)"; fi
if [ "$formulas" -gt 0 ]; then
  plains=$(grep -c 'data-plain=' "$OUT")
  [ "$plains" -ge "$formulas" ] && pass "every .formula has a data-plain fallback" || failm "$formulas formulas but only $plains data-plain fallbacks"
fi
n=$(grep -cE '<img|<iframe' "$OUT"); [ "$n" -eq 0 ] && pass "no <img>/<iframe>" || failm "$n <img>/<iframe> tags"
n=$(grep -c '<link' "$OUT"); [ "$n" -eq 3 ] && pass "exactly 3 <link> (fonts)" || failm "$n <link> tags (expect 3)"

# --- content hygiene --------------------------------------------------------------
e=$(perl -CSD -ne 'print "$.\n" if /[\x{1F300}-\x{1FAFF}\x{2600}-\x{2712}\x{2719}-\x{27BF}]/' "$OUT" | tr '\n' ' ')
[ -z "$e" ] && pass "no emoji" || failm "emoji on lines: $e"
n=$(text | grep -cE '\{\{|\bTODO\b|\bTBD\b|lorem ipsum|\[insert'); [ "$n" -eq 0 ] && pass "no slots/TODO/placeholders" || failm "$n placeholder lines"
# Raw check too: catches unreplaced {{BASE_CSS}}/{{RUNTIME_JS}} markers inside <style>/<script>.
n=$(grep -c '{{' "$OUT"); [ "$n" -eq 0 ] && pass "no {{ anywhere (markers injected)" || failm "$n lines still contain {{ (unfilled slot or injection marker)"
n=$(grep -c 'data-example' "$OUT"); [ "$n" -eq 0 ] && pass "no skeleton examples left" || failm "$n data-example blocks left from the skeleton"

# --- structure --------------------------------------------------------------------
for s in summary context body caveats sources; do
  grep -q "<section id=\"$s\"" "$OUT" && pass "section $s" || failm "missing section $s"
done
n=$(grep -c '<h1' "$OUT"); [ "$n" -eq 1 ] && pass "one h1" || failm "$n h1"
perl -0ne 'exit((/id="sources".*?<li /s)?0:1)' "$OUT" && pass "has a source entry" || failm "no source entry"
f=$(grep -c '<figure' "$OUT"); c=$(grep -c '<figcaption' "$OUT")
[ "$f" -eq "$c" ] && pass "$f figures, all captioned" || failm "$f figures vs $c captions"
r=$(grep -c 'role="img"' "$OUT"); a=$(grep -c 'aria-label=' "$OUT"); svgs=$(grep -c '<svg' "$OUT")
[ "$r" -eq "$svgs" ] && [ "$a" -ge "$svgs" ] && pass "$svgs SVGs with role+aria-label" || failm "$svgs svg / $r role / $a aria-label"
m=$(perl -0pe 's/<style>.*?<\/style>//s; s/<script.*?<\/script>//sg' "$OUT" | grep -oE 'animateMotion|class="[^"]*pulse|data-cycle|class="[^"]*flowing' | wc -l | tr -d ' ')
info "$m motion primitives across $svgs SVGs (every mechanism diagram needs >= 1)"
# Box labels (font-size 18) longer than 14 chars usually overflow a w=160 box.
long=$(perl -0ne 'while (/<text[^>]*font-size="18"[^>]*>(.*?)<\/text>/gs) { my $t=$1; $t =~ s/<[^>]+>//g; print "$t\n" if length($t) > 14 }' "$OUT" | sort -u | tr '\n' '|')
[ -z "$long" ] && pass "no box label over 14 chars" || info "box labels over 14 chars (w=192 box or shorter word?): $long"
# Idea headings: h3 when parts are used, else h2. Part h2s and the fixed section h2s are exempt.
if [ "${ideas:-0}" -gt 0 ] && grep -q '<h3' "$OUT"; then lvl=h3; else lvl=h2; fi
heads=$(perl -0ne 'my ($b)=/(id="body".*?<\/section>)/s; $b//=""; while ($b =~ /<'"$lvl"'[^>]*>(.*?)<\/'"$lvl"'>/g) { my $t=$1; $t =~ s/<[^>]+>//g; print "$t\n" }' "$OUT")
short=$(printf '%s\n' "$heads" | awk 'NF<5')
[ -z "$short" ] && pass "idea headings ($lvl) read as sentences" || info "short idea headings (topics, not sentences?): $(printf '%s' "$short" | tr '\n' '|')"

# --- base.css / runtime.js unmodified? ---------------------------------------------
here=$(cd "$(dirname "$0")" && pwd)
if [ -f "$here/base.css" ]; then
  if perl -0ne 'exit(index($_, do { local(@ARGV,$/)=("'"$here"'/base.css"); my $c=<>; $c =~ s/--accent:(\s+)#[0-9a-fA-F]+;/--accent:$1#ACCENT;/g; $c }) >= 0 ? 0 : 1)' <(perl -0pe 's/--accent:(\s+)#[0-9a-fA-F]+;/--accent:$1#ACCENT;/g' "$OUT"); then pass "base.css embedded verbatim (accent aside)"; else failm "base.css not embedded verbatim (modified beyond the two --accent lines?)"; fi
fi
if [ -f "$here/runtime.js" ]; then
  if perl -0ne 'exit(index($_, do { local(@ARGV,$/)=("'"$here"'/runtime.js"); <> }) >= 0 ? 0 : 1)' "$OUT"; then pass "runtime.js embedded verbatim"; else failm "runtime.js not embedded verbatim"; fi
fi

exit $fail
