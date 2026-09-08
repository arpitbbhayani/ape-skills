---
name: ape-present
description: Converts a blog post into a single self-contained HTML document -- a visual-heavy, readable walkthrough with custom animated diagrams, short and crisp bullet points, and a natural explanation flow from first principles. Trigger on "ape present", "make this presentable", or "turn this post into a doc I can walk people through".
---

# Present Skill

Takes a blog post and produces one self-contained HTML file designed for intuitive learning: a clean header, short crisp bullet points, and visual-first explanations. Diagrams take center stage, featuring custom animations that visually demonstrate the underlying mechanics, followed by numbers set large and wire layouts or pseudocode where relevant.

It is a document, not a deck. No full-screen hero sections, no scroll-snapping, and no slide feel. Single file, comfortable reading width (`--measure`), full theme support, and a fixed section skeleton -- illustration, context, body, sources -- so every document has a coherent shape.

It is not the blog either. The post merely recorded or explained; this document **teaches**. Write it as an expert engineer explaining the concept to a sharp peer:
- **Visuals carry the heavy lifting**: Every idea is anchored by a diagram, custom animation, code snippet, or layout.
- **Short, crisp bullet points**: No verbose paragraphs or walls of text. Use punchy, high-signal bullets that explain the invariant, the causal steps, and the trade-off.
- **Custom animations**: You are free and encouraged to design custom SVG/CSS animations tailored directly to what the concept needs to make the mechanism click.
- **Natural, causal flow**: Ideas progress logically, where each section resolves a constraint or trade-off raised by the previous one.

Audience: practicing engineers. Ground explanations in first principles and systems realities (disk seeks, memory hierarchies, network hops).

## Design System & Custom Animations

The `reference/` directory next to this file holds the design system: `base.css`, `runtime.js`, `skeleton.html`, `svg-templates.md`, and `verify.sh`.

- **Visual-first presentation**: Every idea gets at least one visual figure. Multiple visuals per idea (e.g. animated flow + pseudocode, diagram + trade-off matrix) are welcomed whenever helpful.
- **Custom animated diagrams encouraged**: While `svg-templates.md` provides a fast catalogue of standard shapes, do not feel constrained by it. When a concept calls for a specialized layout, data movement, or custom state cycle, **design a custom animated SVG**.
- **Cohesive tokens**: Build custom visuals using only the CSS variables defined in `base.css` (`var(--surface)`, `var(--line)`, `var(--accent)`, `var(--accent-soft)`, `var(--muted)`, `var(--err)`, `var(--ok)`). Never invent arbitrary hex colors outside `:root`.
- **Motion with purpose**: Motion exists to make mechanisms intuitive. Animate data packets moving along paths (`animateMotion`), pulsing nodes (`class="pulse"`), flowing channels (`class="stream-channel"`), or cycling active states (`data-cycle`). Keep motion purposeful and loops reasonable (1.5s - 3s). Static evidence charts (bars, tables, quotes) stay still.

## Input Handling

The user may provide input in any of these forms:

1. **File path on disk**: a path ending in `.md`, `.txt`, `.html`, or similar. Read the file directly.
2. **A URL**: fetch using web tools, then strip navigation and sidebars before working on the body.
3. **Pasted content**: raw text in the message.
4. **Ambiguous**: if unclear, ask once. Do not guess.

Optional modifiers:
- **Audience**: e.g., "for execs", "for new grads". Default: software engineers with 5-8 years of experience.
- **Length**: "short" (4-6 key ideas) or "full" (all core ideas). Default: full.
- **Theme**: "midnight", "tokyo", "nord", "dracula", "gruvbox", "rosepine", "forest", "neon", "daylight", "arctic", "solarized", "paper", "rosequartz", "swiss" (applied via `<html lang="en" data-theme="theme">`). Default: OS-following.
- **Layout**: `data-layout="left"` for left-aligned body with rightward breakouts. Default: centered.

## Step 1: Find the Spine & Natural Flow

Read the source material once. Extract:

1. **The one-line claim**: The central thesis in one punchy sentence (the dek).
2. **The lead visual illustration concept**: A simple, iconic visual motif representing the topic (e.g. an append stream entering an active block, a single heartbeat pulse, an index pointer). Keep it simple and focused — never try to map the entire blog post or full architecture into this one visual.
3. **The ideas in natural explanatory flow**: 4 to 10 progressive milestones. Each milestone represents one logical step in understanding:
   - What fundamental constraint makes this hard?
   - The central intuition / naive attempt breakdown.
   - The core mechanism (how the gears turn).
   - How edge cases, concurrency, or scale are solved.
   - The primary trade-off or production reality.
   *Every idea heading is a clear, read-aloud sentence capturing the insight.*
4. **The visual & animation concept for each idea**: A template from `svg-templates.md` or a custom animated design that illuminates the specific mechanics.
5. **Key numbers & invariants**: Exact stats, orders of magnitude, and core formulas.
6. **Concrete code / layout**: Trimmed code (<= 20 lines) or clean pseudocode; record/wire format diagrams.

Print the spine:
- Lead Illustration: `<super-visual description capturing the talk>`
- `NN. <idea as sentence> -> <visual / custom animation description>`.

## Step 2: Document Structure & Writing Style

Follow `skeleton.html`:

```html
<article class="doc">
  <header class="doc-header">
    <h1>{{TITLE}}</h1>
    <p class="dek">{{ONE-LINE CLAIM}}</p>
  </header>

  <section id="illustration">
    <figure class="wide lead-art">
      <!-- High-impact visual illustration that conceptually represents the talk/article.
           Not a text summary, but an evocative, animated visual scene capturing the topic. -->
      {{LEAD SVG ILLUSTRATION}}
      <figcaption><strong>{{Illustration Title, 3-6 words.}}</strong> {{One crisp sentence capturing what the visual represents about the talk.}}</figcaption>
    </figure>
  </section>

  <section id="context">
    <h2>{{CONTEXT HEADING as a sentence}}</h2>
    <div class="context-body">
      <!-- 2-4 crisp bullets grounding the problem in first principles -->
      <ul class="rules">
        <li><strong>The Fundamental Invariant</strong>: ...</li>
        <li><strong>Why Naive Approaches Fail</strong>: ...</li>
      </ul>
    </div>
  </section>

  <section id="body">
    <!-- One section per idea, numbered data-n="01", data-n="02", etc. -->
    <h2 data-n="01">{{IDEA AS A READ-ALOUD SENTENCE}}</h2>
    
    <!-- Short, crisp bullet points explaining the concept -->
    <ul class="rules">
      <li><strong>Core Intuition</strong>: [The immediate mental model or physics constraint]</li>
      <li><strong>Mechanism</strong>: [Causal step-by-step: what happens, in what order]</li>
      <li><strong>Trade-off / Invariant</strong>: [What is gained vs. what is sacrificed]</li>
    </ul>

    <!-- Visual: Animated SVG (custom or template), Code, Layout, or Matrix -->
    <figure class="wide">
      {{ANIMATED SVG OR VISUAL}}
      <figcaption><strong>{{Label, 3-6 words.}}</strong> {{One sentence explaining what the visual demonstrates.}}</figcaption>
    </figure>

    <!-- Optional: Second visual element if helpful (pseudocode, stat row, trade-off matrix, wire format) -->
    <!-- Optional: Caveat aside if the source had one -->
    <div class="aside"><p>{{The caveat or boundary condition}}</p></div>
  </section>

  <section id="sources">
    <h2>Sources & References</h2>
    <ul>
      <li cite="...">...</li>
    </ul>
  </section>
</article>
```

### Writing Rules: Short, Crisp, Intuitive

- **No walls of prose**: Never write dense multi-paragraph text. Explain ideas through tight, bulleted points (`.rules` or `.steps`).
- **Focus heavily on explanation**: Frame every concept from first principles. What invariant makes this hard? What naive assumption broke? How does this design restore the guarantee?
- **Natural progression**: Section N+1 should naturally answer the challenge or trade-off left open by Section N.
- **Cross-link text to visuals**: Use `<span class="inspect-node" tabindex="0" data-target="node-id">` to connect bullet points directly to highlighted diagram elements.
- **Truthful to the source**: Use the post's exact numbers, benchmarks, and claims. Never fabricate facts or benchmarks.

## Step 3: Crafting Visuals & Custom Animations

- **Crafting the Lead Visual Illustration (Simplicity First)**:
  - The talk opens with a simple, iconic visual anchor, never a text summary or TL;DR box.
  - **Do NOT map the whole blog post into one complex diagram**: Do not attempt to fit multiple systems, stages, or edge cases into this illustration. Body sections will explain mechanisms one step at a time.
  - **Aim for simplicity & elegance**: 2 to 3 clean elements max. A focused visual motif that sets the mood/theme of the talk (e.g., an append stream entering an active block, a clean pulse between two nodes, or a pointer to an index cell).
  - **Subtle, purposeful motion**: A single moving packet or gentle pulse. Keep it calm, clean, and fast to parse visually.
- **Use the templates or invent custom designs**: Standard templates in `reference/svg-templates.md` work well for basic pipelines, tables, and trees. When the idea has a distinct spatial or mechanical dynamic, **write a custom animated SVG**.
- **Animation primitives**:
  - `animateMotion`: Move packets, offsets, or requests along SVG paths (`<mpath href="#path-id"/>`).
  - `class="pulse"` or `class="pulse-glow"`: Highlight active buffers, locks, or workers.
  - `data-cycle="ms"`: Step sequentially through state machines, ring tokens, or phased protocols.
  - `class="flowing"`: Show continuous streams or data pipes.
- **Keep diagrams clean and legible**:
  - 8px grid alignment, `viewBox="0 0 960 H"` (or `640` for narrow).
  - Clear typography: labels inside elements at font-size 16-18, annotations at 14.
  - Accessible: every `<svg>` must have `role="img"` and a descriptive `aria-label`.
  - Captioned: every visual sits in a `<figure>` with a `<figcaption>`.

## Step 4: Assemble and Verify

1. **Write content file**: Start with `skeleton.html`, write headers, bullets, and figures. Leave `{{BASE_CSS}}` and `{{RUNTIME_JS}}` in place. Remove skeleton `data-example` blocks.
2. **Inject CSS & JS mechanically**:
   ```bash
   python3 - <<'EOF'
   from pathlib import Path
   ref = Path("REF") # path to reference/
   doc = Path("out.html")
   html = doc.read_text()
   html = html.replace("{{BASE_CSS}}", (ref/"base.css").read_text())
   html = html.replace("{{RUNTIME_JS}}", (ref/"runtime.js").read_text())
   doc.write_text(html)
   EOF
   ```
3. **Verify with script**:
   ```bash
   bash <skill-dir>/reference/verify.sh out.html source.md
   ```
   Fix any structural issues (missing sections, unclosed tags, leftover `{{` markers, or ungrounded numbers).
4. **Factual review**: Confirm that all numbers, algorithmic steps, and trade-offs faithfully reflect the source material without hallucinations.

## Checklist

- [ ] Visual-heavy presentation: at least one visual figure per idea; custom animated designs used where helpful to show mechanism.
- [ ] Simple, iconic lead visual illustration under the header (not an overloaded architectural diagram summarizing the whole blog post).
- [ ] Short, crisp bullets instead of dense prose paragraphs.
- [ ] Natural explanatory flow: ideas progress logically from problem to mechanism to edge cases and trade-offs.
- [ ] Visuals built cleanly using design system CSS variables (`--surface`, `--line`, `--accent`, etc.).
- [ ] Mechanism diagrams move purposefully; static evidence figures remain still.
- [ ] Every figure has a `<figcaption>` with a bold label and clear takeaway.
- [ ] Four required sections present (`illustration`, `context`, `body`, `sources`), exactly one `h1`.
- [ ] Design system (`base.css` and `runtime.js`) injected cleanly with zero leftover `{{` markers.
- [ ] Numbers, benchmarks, and claims grounded in the source material.

## Output Structure

1. Print one punchy flavour line starting with "Ape is": e.g., "Ape is turning this post into a visual-heavy walkthrough with custom animations."
2. Print the spine showing the natural flow of ideas and their visual/animated forms.
3. Build the self-contained HTML file and run verification.
4. Print a concise summary with:
   - Output file path
   - Key ideas and the animated/visual forms used
   - Confirmation of factual alignment and verification status
