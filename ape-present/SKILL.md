---
name: ape-present
description: Converts a blog post into a single self-contained HTML document -- a readable long-form document with animated diagrams and just enough text to carry the idea. Trigger on "ape present", "make this presentable", or "turn this post into a doc I can walk people through".
---

# Present Skill

Takes a blog post and produces one HTML file that reads like a well-made internal document: a title, a summary, real headings and short paragraphs, and a figure for every idea -- diagrams that move to show the mechanism, numbers set large, a formula typeset where the formula is the point. The author opens it and walks people through it, or shares the link and people read it alone. Both must work.

It is a document, not a deck. No full-screen sections, no hero, no scroll-snapping, no progress bar, no slide feel. The first screen is the title and the summary, and the page scrolls like any other. Single file, real selectable text, comfortable line length with defined width limits (`--measure` for prose column, with visual elements permitted to break out to `--wide` or `--max-width`), full theme support matching `present-md`, and a fixed section skeleton -- summary, context, body, caveats, sources -- so every document has the same shape.

It is not the blog either. The post explained; this document shows and teaches. Ensure a natural flow optimized for human understanding. Be empathetic to the reader's cognitive load, making sure every section is well explained. Add more details and clarifying context if required to make sure we help people truly understand the concepts, prioritizing clarity and comprehension over strict brevity.

## The one rule that makes it look good

**Do not design. Assemble.** The `reference/` directory next to this file holds a finished design system: `base.css`, `runtime.js`, `skeleton.html`, `svg-templates.md`, and a `verify.sh` that checks the result. The document is built by pasting those verbatim and filling the slots. Every visual is a template from `svg-templates.md` with the labels changed. A document that follows the templates exactly looks deliberate; a document that "improves" on them looks like every other AI-generated page. The design decisions have already been made -- the only creative work left is picking the right visual for each idea and writing the sentences around it.

Read `skeleton.html`, `svg-templates.md`, at least one post in `reference/examples/` so you know what a source looks like, and `examples/bitcask.spine.md` -- a real spine for one of them, with the wrong spines it avoids -- before starting. Do not skip this because the task looks simple. Do **not** read `base.css` or `runtime.js` in full: they are injected mechanically in Step 5, never retyped, and everything you need from them (the component classes, the theme tokens) is documented in this file, the catalogue, and the skeleton's examples.

## Input Handling

The user may provide input in any of these forms. Identify which it is before doing anything else.

1. **File path on disk**: a path ending in `.md`, `.txt`, `.html`, or similar. Read the file directly.
2. **A URL**: a string starting with `http://` or `https://`. Use `WebFetch` to download the content, then strip navigation, sidebars, footers, and comments before working on the body. If the URL points to a PDF, download it with `curl` and extract the text -- prefer `pdftotext` if available; otherwise read the PDF with the `Read` tool.
3. **Pasted content**: raw text in the message. Work on it in-memory.
4. **Ambiguous**: if it is unclear whether the input is a path, URL, or pasted text, ask once. Do not guess.

Optional modifiers the user may add anywhere in the request:

- **Audience**: "for execs", "for new grads", "for the platform team". Changes how much is assumed and which numbers lead. Default: senior engineers who have not read the post.
- **Length**: "short" (the claim, the surprising idea, the main mechanism, the biggest number; 4-6 ideas) or "full" (every idea in the post). Default: full.
- **Theme**: "midnight", "tokyo", "nord", "dracula", "gruvbox", "rosepine", "forest", "neon", "daylight", "arctic", "solarized", "paper", "rosequartz", "swiss" (matching `present-md`), or an accent hue ("amber", "teal", "violet"). Default: no theme -- the page follows the OS (daylight on light, midnight on dark). See "Applying a theme or accent" below.
- **Output path**: "write it to ~/docs/wal.html". Default: `<slug-of-title>.html` next to the source file; in the current directory for URL or pasted input.

### Applying a theme or accent

A **named theme** is applied as `data-theme` on the html element: `<html lang="en" data-theme="nord">`. Omit the attribute for the default OS-following behaviour. Each named theme brings its own display font, which must replace Space Grotesk in the fonts `<link>` (IBM Plex Mono stays):

| Theme | Display font | Theme | Display font |
|---|---|---|---|
| midnight, daylight, neon | Space Grotesk (default link) | forest, solarized | Outfit |
| tokyo | Sora | rosepine, paper | Fraunces |
| nord, arctic | Manrope | rosequartz | Playfair Display |
| dracula | Syne | swiss | Archivo |
| gruvbox | Bricolage Grotesque | | |

An **accent hue** changes only the two `--accent` lines in the pasted `base.css` -- the one in the midnight block and the one in the daylight block (`--accent-soft`, `--accent-line`, and `--glow` derive from it automatically). Use these pairs; do not invent hexes:

| Accent | midnight (dark) | daylight (light) |
|---|---|---|
| violet (default) | `#cba6f7` | `#8839ef` |
| blue | `#89b4fa` | `#1e66f5` |
| sky | `#89dceb` | `#04a5e5` |
| teal | `#94e2d5` | `#179299` |
| green | `#a6e3a1` | `#40a02b` |
| amber | `#f9e2af` | `#df8e1d` |
| orange | `#fab387` | `#fe640b` |
| red | `#f38ba8` | `#d20f39` |
| rose | `#f5c2e7` | `#ea76cb` |

## Step 1: Find the Spine

Read the whole post once before writing anything. Extract, in this order:

1. **The one-line claim.** What the author would say with ten seconds. This is the dek under the title.
2. **The ideas, in order.** Each idea is one thing the reader must understand to believe the claim. A typical post has 5-12. Each becomes one `h2` in the body. The test for an idea: *it is something a reader could be wrong about.* "The write path" is a topic; "every write is appended, never seeks, and the index lives in memory" is an idea. One idea per paragraph, per heading, or per section of the blog are all wrong spines -- ideas cut across the post's structure.
3. **For each idea, its visual form**, chosen from the catalogue in Step 2. If no picture carries it, the idea is a number (stat row), a sentence (quote), or context (prose only, no figure) -- or not an idea, and it is cut.
4. **The numbers.** Every figure in the post that matters. These are the only things allowed in large type.
5. **The surprising claim.** The thing a knowledgeable reader would not have guessed. It gets its own `h2` and the quote treatment.
6. **The code or pseudocode, if any.**
   - *Retain critical code*: When the blog contains code snippets that are essential to understanding the mechanism, retain them so the reader can follow along. Trim to the essential lines that matter with `...` for the rest, highlighting the key lines with `.hl`. Never more than 20 lines.
   - *Summarize complex code as pseudocode*: When the actual code is too complex, verbose, or bogged down in implementation details, simplify and express it as clear, readable pseudocode following [[ape-write-pseudocode]] (`def` signature, docstring input/output, and Pythonic `object.verb()` calls capturing intent over implementation).
7. **The post's own figures.** For each image, chart, or diagram in the source: if it carries an idea, it is redrawn from a template (never embedded, never linked, never base64); if it is decorative, it is dropped. Note the decision per figure. To read an image: `curl -sL <url> -o <scratchpad>/figN.png`, then open it with the `Read` tool and transcribe what it shows (a formula to LaTeX, a plot to its shape and labelled points, a table to rows). If the download fails, work from the surrounding prose and say so in the closing block.
8. **Tables and maths.** A table in the source becomes the matrix figure with the relevant row highlighted. Inline maths stays as Unicode (`O(log n)`, `λ = 0.7`). A formula that *is* the idea of a section becomes a `.formula` figure typeset with MathJax. Formulas the source shows as images are transcribed to LaTeX from the image; if the image cannot be read, the formula is written from the surrounding prose and flagged in the closing block.
9. **The caveats.** Every "only when", "except if", "we have not tested" in the post. Each attaches to its idea as an aside, and all of them are collected again in the `caveats` section.
10. **The sources.** The post itself, plus anything the post cites that the document mentions.

Write the spine as a plain list (`NN. idea as sentence -> visual form`) and print it. **If the source is over 2,500 words or the spine has more than 10 ideas, stop here and wait for the user to confirm or trim.** Otherwise the spine is informational and the build proceeds immediately.

**Heading levels.** Up to 8 ideas: each idea is an `h2`. More than 8: group them into 2-4 parts; each part is a short `h2` (`Structure`, `Operations` -- the one place a topic heading is allowed) and each idea beneath it is an `h3`. Whatever the level, *idea* headings are sentences; the sentence rule in the checklist applies to idea headings only.

## Step 2: Visual Catalogue

Every figure comes from one of these. The template reference is where to copy from.

| Idea shape | Visual | Template |
|---|---|---|
| System, pipeline, request flow | Boxes and arrows, left to right, packets moving along it | `svg-templates.md` §1 + §10 |
| Data flow across complex components (stream processing, multi-stage routing) | Data Flow Graph, multiple components with fanning packets | §1c + §10 |
| Pub/Sub Broadcast, central message bus, hub-and-spoke | Central broker radiating out to multiple subscribers | §1d + §10 |
| Request/response, handshake, consensus round, race condition | Sequence diagram, time downward, packets per message | §2 + §10 (race: crossing `--err` arrows) |
| Parallel execution, blocking vs async, concurrency | Gantt / Swimlane diagram over time | §2b |
| Comparison of 2-6 magnitudes, before/after numbers | Race bars (horizontal meters filling to their targets) | §3a + `skeleton.html` race-bars example |
| Comparison of more than 6 magnitudes | SVG bar chart, labels on bars, no legend | §3 |
| Comparison of two conflicting axes (e.g. Write vs Read) | 2x2 Trade-off Matrix / Quadrants | §3b |
| Architecture Stack/Layer Breakdown (system overview, multi-tier comp) | Stack diagram of logical layers / modules | §3c + §10 |
| One quantity against another, a function's shape, a plot in the post | Function curve, one accent path, labelled endpoints | §3d |
| Sequential cost of one operation, "where the time goes" | Latency waterfall (static) | §3e |
| A distribution and its tail, percentiles (p50/p99) | Histogram with percentile markers (static) | §3f |
| Values spanning orders of magnitude ("ns to ms") | Magnitude ladder, log scale (static) | §3g |
| Two or three growth shapes compared (O(n) vs O(log n)) | Multi-curve comparison (static) | §3h |
| A metric over time with events marked ("then we deployed") | Annotated time series (static) | §3i |
| Tree, hash, linked, graph structure | Node-and-edge diagram | §4 |
| Circular distribution, consistent hashing, peer-to-peer rings | Ring Topology / Distributed Ring | §4b + §10 |
| Nested environments, Virtual Machines, Containers, sandboxes | Nested Boundaries / Containment Structure | §4c |
| Records/tables and the fields linking them (schema) | Titled boxes with field rows, FK arrow | §4d |
| Decision, branching logic, "if X then Y" | Flowchart with diamonds, packet on the taken branch | §7 + §10 |
| Lifecycle, modes, status transitions | State machine, states cycling | §8 + §10 |
| History, phases, "first we…, then we…" | Timeline | §9 |
| Several options, one chosen | Matrix table with `.chosen` row (`figure.wide` above 3 columns) | §5 |
| Memory, bytes, slots, array, hash buckets | Cell grid with `.on` / `.bad` cells, probe sequence cycling | §6 + §10 |
| Record, header, or wire-format layout | `.cells.row` with named fields | §6 |
| Load skew, hot spots, hit patterns across a grid | Heatmap cells, 3 accent intensity steps (static) | §6b |
| One source feeding two targets (or two into one) | Branching pipeline | §1b + §10 |
| A number that matters | Stat row with count-up | `skeleton.html` stats example |
| Sequence of steps, algorithm phases | `.steps` list (numbered) | `base.css .steps` |
| Principles, rules, requirements, "the N things" (not sequential) | `.rules` list (dashed) | `base.css .rules` |
| Two things contrasted (before/after, old/new, profile A/profile B) | Side-by-side `.panels` | `base.css .panels` |
| The key insight, the surprising claim, in the post's own words | `.quote` | `skeleton.html` quote example |
| A section's core takeaway that is not a quotation | `.callout.insight` with `.hl-pill` terms | `skeleton.html` callout example |
| Multi-phase mechanism the reader steps through (3-6 phases on one diagram) | `.stepper` panes + `data-step` highlights on the figure's SVG | `skeleton.html` stepper example |
| Mechanism in code / Pseudocode | `pre` with hand-wrapped spans, 1-3 `.hl` lines | `skeleton.html` code example |
| The exact code change the post made (before/after lines) | `pre.diff` with `.add`/`.del` lines | `skeleton.html` diff example |
| A shell session the post shows (command and output) | `pre.term` with `.prompt`/`.out` | `skeleton.html` terminal example |
| Optional depth a skimmer can skip | `<details class="deep-dive">` after the idea's figure | `skeleton.html` deep-dive example |
| A formula that is the point | `.formula` figure, MathJax, key term in accent | `skeleton.html` formula example |

Rules:

- **Every mechanism diagram moves; every evidence figure stays still.** A mechanism shows where data goes -- pipeline, sequence, flowchart, state machine, tree lookup, cell grid: add at least one motion primitive from `svg-templates.md` §10 (a packet along the accent arrow at minimum), running only while the figure is on screen and never under reduced-motion. An evidence figure proves a claim -- stats, quotes, bar and race charts, waterfall, histogram, magnitude ladder, curves, time series, heatmap, matrices, timelines, schema, code / diff / terminal: no motion beyond the reveal, and every value or event label on it must be stated by the post. The magnitude ladder is the one non-linear scale permitted and keeps its "log scale" annotation.
- **Code and Pseudocode**: Retain critical code snippets from the blog that are essential for following the mechanism. When actual source code is overly verbose, complex, or full of boilerplate, summarize it into clean, high-level pseudocode following [[ape-write-pseudocode]] (`def`, input/output docstrings, Pythonic `object.verb()` calls). Use `<pre><code>` with hand-wrapped spans (`span.k` for keywords, `span.s` for strings, `span.c` for comments, `span.n` for names/numbers) and 1-3 `.hl` lines marking the key operation. When the post's point *is* a change, show it as `pre.diff` -- the post's own before/after lines, `+`/`-` prefixes typed in the text, `.add`/`.del` per line, same 20-line cap. A shell session is `pre.term` with `.prompt` on command lines and `.out` on output, transcribed exactly -- output numbers are claims.
- **Deep-dives** (`<details class="deep-dive">`): optional depth a skimmer can skip, attached under an idea after its figure. Never a caveat, never load-bearing -- the body must read complete with every deep-dive closed. At most two per document.
- One figure per idea. An idea that needs two figures is two ideas.
- Every SVG and table sits in a `<figure>` with a `<figcaption>`; 960-wide diagrams get `class="wide"`.
- Stats: one row per idea, at most three numbers in it, and only for figures the post actually states. A metric without a value ("cycle time", "weeks to days") is not a stat -- it goes in prose or a `.rules` list.
- If an idea genuinely fits no row, draw a custom SVG **that obeys the grammar in `svg-templates.md`** (8px grid, box sizes, stroke widths, colours, max 7 boxes). Custom means new arrangement, not new style.
- A `.stepper` is user-driven interaction, not animation: use it when one diagram carries 3-6 phases the reader should walk at their own pace, with `data-step="1..N"` on the SVG groups each phase is about. Each pane is prose and obeys the fidelity rules. At most one stepper per document; a mechanism with 2 phases is `.panels`, with continuous motion it is §10.
- **Two external resources are permitted, no others.** The Google Fonts link from `skeleton.html` (IBM Plex Mono for text; Space Grotesk for title and headings on the default themes -- a named theme swaps in its own display font per the table above; system fallbacks make the page readable offline), and MathJax -- only when the document has at least one `.formula`, with the exact pinned tags from `skeleton.html`. Every `.formula` carries a plain-text fallback in `data-plain`.

## Step 3: Document Structure

Follow `skeleton.html` exactly. Direct start (no chrome bars, eyebrows, or author clutter at the top):

```
<article class="doc">
  <header class="doc-header">        h1 · dek (the one-line claim) -- clean, immediate start
  <section id="summary">            .summary: 3-5 sentences
  <section id="context">            h2 + 1-3 short paragraphs, the first with class="dropcap", optional .inspect-node links
  <section id="body">               one heading per idea with data-n="NN" (margin folio): prose · figure + figcaption · optional aside; ends with <p class="end-mark">■</p>
  <section id="caveats">            h2 "Where this stops being true" + list
  <section id="sources">            h2 + <li cite="…"> one per source
</article>
<script> MathJax tags (only with a .formula), then runtime.js verbatim
```

Per-idea rules:

- **Heading** (`h2`, or `h3` under parts): carries `data-n="NN"` (two digits, numbered across the whole body) so the folio prints in the margin; the idea as a full sentence. "Every write goes to the log first", not "Write path". Stable across versions -- reviewers anchor comments to headings.
- **Prose**: Write empathetic, well-explained paragraphs with a natural flow. What happens, in what order, why it works. Add extra details or bridging explanations if they help the reader understand the core idea. Real sentences with the numbers in them. This is a document; it must read well without anyone talking over it and never leave the reader struggling to connect the dots. When the figure fully carries the idea, the prose gets shorter -- never restate in words what the picture already shows; point at it and move on. Depth that only some readers want goes in a deep-dive, not the paragraph.
- **Figure**: from Step 2. The figcaption opens with a bold 3-6 word label, then one sentence saying what the picture shows that the prose cannot. A `.formula` figure also carries a `.formula-legend` naming each symbol in one phrase (`N documents in corpus`), and its `\class{term}{…}` marks the one term the idea is about. A code or pseudocode figure wraps in `<pre><code>` with hand-wrapped spans and an explanatory figcaption highlighting what the critical lines accomplish.
- **Aside**: only if the post had a caveat for this idea. Never drop a caveat to make a section cleaner. `.aside.err` for a failure condition.
- **Stagger**: `style="--i:n"` on each `.pop`/`.draw` inside an SVG, in reading order. Nothing else needs `--i`.

Word budget: the whole document (summary to sources, captions and diagram labels included) is generally **100-250 words per idea plus 200-400** for summary, context, caveats, and sources. Use as many words as needed to ensure the explanation is empathetic, thorough, and completely clear to the reader. `verify.sh` will compute a baseline, but you may exceed it if the extra detail is genuinely needed for human understanding.

## Step 4: What Not To Do

These are the patterns that make generated pages look generated, or turn a document into a deck. Each is a build failure.

- Full-viewport sections, a hero, a scroll hint, a progress bar, keyboard "slide" navigation. It is a document.
- Centred body text. Prose is left-aligned; only figcaptions and formulas centre.
- Gradients of any kind. Glassmorphism, blur, noise textures, drop shadows, glow. Emoji. Icon sets. (The graph-paper ground in `base.css` is the only texture; it is not optional and not adjustable.)
- Cards for everything. `.panel` is for a two-way contrast; `.stat` for numbers the post states. Paragraphs are paragraphs.
- More than one accent colour. `--err` and `--ok` are the only other hues.
- Any hex colour outside the `:root` blocks.
- Your own theme toggle UI. Theme follows the OS, or the `t` key -- no button.
- Hover-only content, tilt, parallax, particles, typewriter, scramble or glitch text. (`.inspect-node` cross-highlighting is a permitted enhancement, not content: the prose reads fully without it, and every inspect-node carries `tabindex="0"` so keyboard and touch reach it.) The header stagger on load, figure reveals, diagram motion from §10, and `.stepper` pane switches are the only animation permitted; at most three moving things per diagram, no loop faster than 1.5 s.
- Changing anything in `base.css` other than the two `--accent` lines. Adding or swapping fonts. Loading anything from a URL except the fonts link and the MathJax tags.
- Inventing a number, a claim, an example, or a caveat that is not in the post.
- Headings that are topics ("Architecture", "Results", "Conclusion").
- `TODO`, `TBD`, `[insert …]`, lorem ipsum, or any unfilled `{{slot}}`.

## Step 5: Build and Verify

Write the content once, inject the design system mechanically, then verify with real commands. Do not paste HTML into the conversation, and **never retype `base.css` or `runtime.js` through the Write tool** -- they are injected from disk, which is both cheaper and the only way the verbatim check can pass.

Assembly:

1. Start from `skeleton.html` and write the *content* file: header, summary, context, one heading block per spine item, caveats, sources -- with the `{{BASE_CSS}}` and `{{RUNTIME_JS}}` markers left in place. Delete every block marked `data-example` (`verify.sh` fails if one survives). The source link comes from the post's frontmatter or the user; a local file with no URL is credited as `adapted from <code>filename.md</code>` -- never guess a URL.
2. Fill each figure from its template. Change labels, counts, positions, highlighted elements only. Add motion to every mechanism diagram.
3. If a named theme was requested, set `data-theme` on `<html>` and swap the display font in the fonts link; if an accent was requested, plan the two `--accent` hexes from the table above. Remove the MathJax tags if there is no `.formula`.
4. Inject the design system with one command (run from the document's directory, `REF` = the skill's `reference/` dir), applying the accent afterwards only via the two `--accent` lines:

   ```bash
   python3 - <<'EOF'
   from pathlib import Path
   ref = Path("REF"); doc = Path("out.html")
   html = doc.read_text()
   html = html.replace("{{BASE_CSS}}", (ref/"base.css").read_text())
   html = html.replace("{{RUNTIME_JS}}", (ref/"runtime.js").read_text())
   doc.write_text(html)
   EOF
   ```

5. Grep for double curly brackets and expect zero hits.

Verification -- run the verifier and fix until every line is PASS:

```bash
bash <skill-dir>/reference/verify.sh out.html source.md
```

It checks, portably on macOS and Linux: the word budget from the heading count (though you may exceed it for clarity); leftover `data-example` blocks; hex colours outside `:root`; external resources beyond the fonts link and pinned MathJax; MathJax present exactly when a `.formula` exists, each with a `data-plain` fallback; `<img>`/`<iframe>`; emoji; unfilled `{{slots}}` (including un-injected `{{BASE_CSS}}`/`{{RUNTIME_JS}}` markers), `TODO`, `TBD`, placeholders; the five sections (`summary`, `context`, `body`, `caveats`, `sources`), one `h1`, at least one source entry; every `<figure>` captioned; every `<svg>` with `role="img"` and `aria-label`; the count of motion primitives (must be at least the number of mechanism diagrams -- check this by eye); box labels too long for their boxes; `h2`s that look like topics; every number in prose and every stat `data-to` value present in the source; and that `base.css` (accent aside) and `runtime.js` are embedded verbatim. Skip `source.md` for pasted input and state that the word budget and number checks were not run. There is no rendering step: the templates are the tested layout, so a document that passes `verify.sh` and the fidelity pass is done.

## Step 6: Fidelity Pass

The document says only what the post says. After the build verifies clean, check that -- and iterate until it holds.

1. Extract every claim from the document: each sentence of the summary, context, prose and asides; each figcaption; each stat, matrix cell, formula, and diagram label; each takeaway in caveats. Number them.
2. For each claim, find the sentence(s) in the source that support it. Quote the source span. Three outcomes:
   - **Supported**: the source states it, in the same direction and with the same qualifier. Keep.
   - **Drifted**: the source states something near it but the document sharpened, generalised, dropped a condition, or changed a number. Rewrite the claim to match the source exactly, then re-check.
   - **Unsupported**: nothing in the source says it -- an added example, an inferred mechanism, a "typically", a figure the post never gave. Delete it, or replace it with what the post actually says.
3. Diagrams are claims too: every box, arrow and label must correspond to something the post names; an arrow the post does not describe is an invention. Fix the SVG, not the caption.
4. Re-run `verify.sh` after edits (word budget and structure can shift), then repeat from step 1 on the changed claims. Stop when a full pass produces zero drifted or unsupported claims. Two passes is normal; more than three means the spine was wrong -- rebuild the affected idea from the source rather than patching sentences.
5. Record the result for the closing block: claims checked, drifted fixed, unsupported removed, and the pass count.

`verify.sh` backstops this mechanically: every number in the document's prose and stats must appear in the source text. It cannot check words -- that is what this pass is for.

Do not pad the document with fluff, but do add bridging explanations and explanatory context if they improve human understanding. Fidelity means nothing false, not everything true. Adding empathetic detail to ensure clarity is permitted, even if the final document ends up around the same length or slightly longer than the source.

## Checklist

Every item is checked by the commands above or by opening the file; none is ticked from memory.

- [ ] One figure per idea, from a template, obeying the grammar; every figure captioned.
- [ ] Every mechanism diagram has at least one motion primitive; none has more than three.
- [ ] Every evidence figure (waterfall, histogram, ladder, curves, series, heatmap, schema, diff, terminal) is static, and every value or event label on it is stated by the post.
- [ ] Deep-dives: at most two, nothing load-bearing inside, body reads complete with all of them closed.
- [ ] Every idea heading is a sentence a reader could be wrong about (part headings, when used, are exempt).
- [ ] Prose per idea is sufficiently detailed to be fully understood, empathetic to the reader, and reads smoothly without a presenter.
- [ ] Every number that matters is present, exact, in prose and as a stat or on a chart.
- [ ] Every caveat survives as an aside on its idea and in caveats.
- [ ] Fidelity pass completed to ensure accuracy without sacrificing necessary bridging explanations; every number in prose appears in the source (`verify.sh`).
- [ ] Word count measured, but sufficient detail was included to ensure comprehensive understanding.
- [ ] Essential code retained (trimmed to <= 20 lines) or simplified into clean pseudocode via [[ape-write-pseudocode]]; syntax styled with hand-wrapped spans (`.k`, `.s`, `.c`, `.n`) and 1-3 `.hl` lines.
- [ ] All five sections present; exactly one `h1`; at least one source entry.
- [ ] Zero hex outside `:root`, zero network references beyond the fonts link and MathJax (only with a `.formula`), zero `<img>`, zero emoji, zero `{{` -- by command.
- [ ] `base.css` and `runtime.js` injected mechanically over the skeleton markers, unmodified except the two `--accent` lines (`verify.sh` fails otherwise).
- [ ] Every `.inspect-node` carries `tabindex="0"`; a `.stepper`, if used, points its `data-svg` at a real SVG id with matching `data-step` groups.
- [ ] Nothing from Step 4 present.

## Output Structure

Before anything else, print a one-line flavour string on what the skill is doing. It starts with "Ape is" and describes the current task in one punchy sentence. Examples: "Ape is turning this post into a doc you can walk people through.", "Ape is drawing the pictures the words were hiding.", "Ape is making the mechanism move."

Then, in order:

1. `Source: <path or URL>` (skip for pasted content).
2. The spine: `NN. <idea as sentence> -> <visual form>`, plus one line per source figure saying redrawn or dropped. Pause here only under the long-source rule in Step 1.
3. Build and verify (Step 5), then the fidelity pass (Step 6).
4. A closing block, formatted through [[ape-style-markdown]]:
   - Output path.
   - Whether MathJax is included (fonts and MathJax load from the network; offline the page falls back to system fonts and plain-text formulas), and any formula transcribed from prose rather than read from an image.
   - Source words, document words, and the budget range for the idea count.
   - Idea list with the figure used for each.
   - Anything deliberately dropped from the post and why, one line each.
   - Fidelity: claims checked, drifted fixed, unsupported removed, passes taken.
   - Which `verify.sh` checks were skipped (pasted input has no source to measure against).
   - How to use it: open in a browser (or present via `present-md`); theme follows the OS or `present-md` theme, `t` flips it.

## Iteration

The user will ask for changes after seeing it: "idea 4 needs a diagram not a quote", "the state machine should cycle", "cut ideas 7 and 8", "teal". Apply targeted edits to the file on disk, keep everything else byte-identical, keep headings stable unless asked (reviewers anchor to them), and re-run the checks the change could affect. Print only what changed.
