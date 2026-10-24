---
name: ape-write-paper
description: Writes a polished, standard two-column research paper (LaTeX to PDF) from any source material -- code, docs, experiment logs, benchmark files, notes -- optimising for correctness, readability, structure, figures, tables and references. Supports both standalone papers and conference templates (ACM SIGMOD/VLDB, IEEE, NeurIPS). Audits every claim against evidence before writing, reports losses honestly, and renders pages to check them. Trigger on "ape write paper", "write a paper from this", "turn these experiments into a paper", or "draft the paper for this project".
---

# Write Paper Skill

Turns a pile of source material (repo, docs, experiment logs, result JSONs, notes) into a conference-style paper and a compiled PDF. The goal is a paper a skeptical reviewer can follow in one pass and check number by number.

Priorities, in order: **correct, then clear, then polished.** A beautiful paper with one invented number is worse than a plain one with none.

## Workflow

Run these phases in order. Do not start writing prose before phase 2 is done.

### 1. Gather and obey constraints

- Read every project instruction file first (`AGENTS.md`, `CLAUDE.md`, venue notes). Typical rules: target conference, approved title, author identity, layout, forbidden claims, which results may appear. They override this skill.
- **Venue template check**: If a specific conference or journal is targeted (e.g., ACM SIGMOD/VLDB requires `acmart`; IEEE requires `IEEEtran`; NeurIPS/ICML/ACL require their `.sty` packages), use the official conference documentclass and native metadata commands (`\begin{CCSXML}`, `\keywords`, `\author{...}\affiliation{...}`) rather than the standalone title block from `reference/preamble.tex`. See `reference/snippets.md` for the ACM `acmart` skeleton.
- Read the existing draft if there is one. Treat its numbers as **unverified** until traced.
- Read all of: design docs, evaluation files, result JSONs, benchmark scripts, training logs, tests. Read the scripts too, to learn the real protocol (prompts, normalisation, hardware pinning, warmups, metric definitions).
- Find the tooling: `which pdflatex xelatex tectonic typst`. Prefer what is installed. See `reference/preamble.tex` for engine-specific notes.

### 2. Build a claim ledger (before writing)

Make a table in your scratch space: `claim | value | source file | verified?`. Every number, speedup, count, percentage, throughput, latency percentile, and comparison that will appear in the paper gets a row.

Rules:
- A number enters the paper only if it traces to a file you opened, or to a computation you ran from such a file. Recompute derived numbers (speedups, gaps, intervals) yourself.
- Check counts against raw data, not against prose. Draft tables often carry wrong N per category; count the items.
- If a number appears only in a doc and not in a reproducible result file, either use it with its provenance stated ("measured separately") or flag it to the user as unreproducible.
- Delete what has no source: invented curves, estimated costs, baselines never run, market claims ("30-40% of fields..."), competitor tables from memory, hardware names you cannot confirm. Do not soften them, remove them.
- Never add results for systems that were not actually run. A baseline that cannot be run is described qualitatively, or by construction, not with a number.
- **Discrete uncertainty**: Compute Wilson 95% interval for proportions on small samples. State N next to every percentage that matters.
- **Continuous variance**: For continuous measurements (latency, throughput, runtime, loss), report mean $\pm$ standard deviation, confidence intervals, or median with tail percentiles (p95, p99, p99.9) across seeds or repeated runs. Never quote a single cherry-picked run as a general fact without explicitly stating it was an unrepeated single run.
- **Systems & Database metrics**: For systems/DB workloads, track throughput (QPS, ops/sec), tail latency (p99, p99.9), multi-core scalability ($1 \to N$ threads), memory footprint (peak RSS, bytes per record), and write/read amplification.

### 3. Decide the story and the honest framing

Write down, before drafting:
- **One-sentence thesis**: what is new and why it matters.
- **Where the system wins and where it loses**, from the ledger. If a baseline beats it on the headline metric (e.g. baseline has lower memory footprint or higher peak throughput on simple lookups), the paper says so in plain words and argues from the real advantage (speed, cost, determinism, auditability, tail stability), never around the loss.
- **Evidence quality per result**: in-distribution vs held-out, tuned-on vs untouched, N, who ran it. Anything in-distribution or inspected after the fact gets a caveat where it is reported.
- **Title audit**: every word in the title must be defensible. Numeric claims ("sub-15ms", "million-QPS") need a stated statistic (median vs tail), a stated configuration, and a reproducible measurement; otherwise propose a title without the number. Offer the user alternatives instead of silently changing an approved title.

### 4. Write the paper

Standard skeleton (merge or drop sections that do not fit the source):

1. **Abstract**: problem, gap, method in one sentence, headline results with N, the honest limitation/trade-off. Full-width, indented block (or venue environment), bold centred heading, no citations.
2. **Introduction**: a concrete running example early; why existing families fail (one clause each); the key idea; a numbered contribution list. Every contribution points to a section.
3. **Background and related work**: grouped by approach, one paragraph each. Say what you share and what you change. Cite only real, verified works.
4. **Problem formulation / System model**: inputs, outputs, notation, concurrency/consistency model, the metric, and what counts as correct.
5. **Method / system**: a full-width pipeline figure first, then one subsection per stage in data-flow order. Mark which parts are learned and which are deterministic. For systems/database engines, include concise algorithmic pseudocode for core execution loops, operators, or protocols. Equations only where they remove ambiguity.
6. **Worked example**: one input followed end to end through every stage with real system output (a small table plus the trace). This is the section that makes readers understand.
7. **Implementation & Experimental Setup**:
   - For ML/NLP: data generation, hyperparameters, training logs, hardware, runtime.
   - For Systems/Databases: **exhaustive testbed environment** (CPU model, sockets, physical cores vs hyperthreads, L1/L2/L3 cache sizes, RAM capacity and NUMA topology, storage model, filesystem, OS kernel version, compiler and flags `-O3 -march=native`, thread pinning with `numactl`, and cache protocols: dropping OS page cache for cold runs, warmup iterations for warm runs).
   - Standard benchmarks: explicitly state benchmark name, scale factor, and skew parameters (e.g. TPC-H SF=100, YCSB Zipfian $\theta=0.99$, ClickBench).
8. **Experiments**:
   - Macrobenchmarks: end-to-end performance vs industry-standard baselines run under identical hardware and protocols.
   - Microbenchmarks / Factor analysis: isolate the novelty (e.g., SIMD vectorization vs caching vs lock-free index vs query optimizer).
   - Multi-core scalability ($1 \to N$ threads) and sensitivity analysis (varying skew, memory budget, payload size).
   - Resource footprint: peak RSS, memory overhead, and tail latencies (p95, p99, p99.9).
9. **Discussion**: where it fits, how it combines with other systems, **threats to validity** as a numbered list (sample size, inspection after evaluation, hardware-specific optimizations, baseline tuning caveats).
10. **Limitations and future work**: what it cannot express, unhandled workloads, scope of evidence, next steps in order of expected payoff.
11. **Conclusion**: three to five sentences, no new claims.

Prose rules:
- Plain, specific, active. Define a term on first use. One idea per paragraph. Lead paragraphs with the point (use run-in bold `\paragraph{}` heads).
- Quantify comparisons with the number and the unit ("172-437x", "12.5 to 20.8 points", "3.4x higher QPS at 99th percentile"). No "significantly", "dramatically", "state-of-the-art" without a number.
- Say what the evidence does not show. Say when a comparison favours your system for a structural reason (excludes network time, in-distribution data, warm cache).
- Do not claim guarantees broader than what is proved. Separate "the arithmetic is exact" from "the answer is correct".
- Reproducibility: name the files, scripts and commands each result comes from, in table captions or the protocol section.
- No hype adjectives, no marketing, no web-blog elements (no card boxes, coloured callouts around text).

### 5. Figures, tables, equations, algorithms

Figures (draw from real data only):
- **Pipeline figure**, full width (`figure*`), left-to-right, numbered stages matching the method subsections. Two fill tints: one for learned parts, one for deterministic code, with a legend. Show bypass paths (dashed) when something deliberately skips a component. Keep arrow labels short so they never collide with nodes; drop a label rather than let it overlap.
- **Result charts** with pgfplots:
  - Accuracy/Distribution: horizontal bars for per-category accuracy (sorted, value labels, zerofill).
  - Systems/DB trade-offs: Throughput vs p99 Latency curves (log-scale y-axis), Multi-core thread scalability lines.
  - Axis labels with units, grid light, single accent colour, direct labels over legends where possible. Only plot values that exist in a result file.
- Never fabricate a curve to "illustrate" a trend. If a study was not run, the figure does not exist.

Tables:
- `booktabs` rules only (top, mid, bottom). No cell fills, no vertical rules.
- Wide tables use `table*`; keep narrow ones in one column. Put N, scale factors ($SF$), or threads in column headers (`n=48`, `SF=100`). Bold the best value per column sparingly.
- Caption states what is measured, units, data source files, and any caveat (in-distribution, partial coverage, warm-cache).
- Check that each row in the table is a real run. Merge repeated rows when the data is identical.

Algorithms & Equations:
- Number only equations referenced. Define every symbol once.
- For core operators, concurrency control, or protocols, format using `algorithm` + `algpseudocode` (or `algorithm2e`). State preconditions, postconditions, and thread/atomic boundaries explicitly.

### 6. References

- Use a `.bib` file and venue-appropriate bibliography style (e.g. `ACM-Reference-Format` for ACM SIGMOD, numbered with hanging indent for standard article).
- **Zero hallucinated citations**: Cite only works that exist and that you know say what you attribute to them. If adding a reference from scratch, search the web or verify the DOI/ArXiv ID via Crossref before inserting it into `.bib`. Do not guess authors, years, or conference names to make a related work section look longer.
- Run the compile and confirm no `Citation ... undefined` warnings and no unused-but-needed gaps.

### 7. Compile, render, look, fix

1. Compile with the installed engine (`reference/verify.sh`). Zero errors. Zero undefined references or citations. Treat `Overfull \hbox` larger than a few points as a defect.
2. **Render pages to images and look at every page** (`pymupdf` via `uv run --with pymupdf`). Check: title block, abstract width, figure label collisions, float placement, table fit, bar labels, orphaned headings, double punctuation (`models..` from a trailing period in a run-in heading), stray semicolons left by edits, bibliography hanging indent.
3. Fix, recompile, look again. Do not report done from a green compile alone.
4. Re-read the ledger against the final text: every number in the PDF is in the ledger.

### 8. Report to the user

Short and concrete:
- Where the PDF and source are, page count.
- What you **removed** for lack of evidence and what you **corrected** from the old draft.
- The honest framing choices (e.g. "the system loses on accuracy or memory footprint; the paper says so").
- Open items: measurements that are not reproducible from the repo, stale sibling sources (e.g. an old Typst copy), claims that need a new experiment.

## Style defaults (override with project rules)

- For standalone papers: A4 or Letter, two columns, 10 pt, margins about 1.5 cm, column gap about 0.65 cm, Libertinus Serif font.
- For conference submissions: Strictly inherit venue class (`acmart`, `IEEEtran`, etc.) and its default fonts, margins, and bibliography format.
- Run-in bold paragraph heads inside sections; avoid deep nesting beyond 1.1.
- Section cross-references with `\ref`, never hard-coded numbers.
- Figures and tables float to the top, referenced in text before they appear.

## Pitfalls seen in practice

- Using generic `article` when an official venue class (`acmart`, `IEEEtran`) is required.
- Draft numbers copied from a previous version that no longer match the result files.
- Reporting continuous metrics (latency, QPS) from a single run without stating variance, seeds, or tail percentiles (p95, p99).
- Systems papers omitting hardware details (CPU cache sizes, NUMA topology, storage device) or OS page cache drop protocols.
- Per-category counts that do not sum to the total.
- Speedups computed against one backend while the table lists another; say which.
- Latency from different runs shown as one measurement; reconcile or state both.
- Claiming a held-out result after tuning on it; claiming generalisation from in-distribution data.
- "Mathematically eliminated hallucination" style claims; say exactly which component is exact.
- Hallucinating BibTeX citation keys, publication years, or author lists.
- Packages that clash under XeTeX/LuaTeX (see `reference/preamble.tex`).
- Leaving a stale second source (Typst/Word) of the same paper without saying it is stale.

## Files in this skill

- `reference/preamble.tex`: tested preamble (fonts, geometry, headings, captions, bibliography hanging indent, colours, TikZ/pgfplots, listings, algorithms).
- `reference/snippets.md`: copy-ready patterns for standalone & ACM SIGMOD skeletons, pipeline figures, bar charts, throughput/tail-latency plots, scalability curves, algorithms, hardware spec boilerplate, and claim ledgers.
- `reference/verify.sh`: compile, report errors and undefined refs, and render pages to PNG for visual inspection.
