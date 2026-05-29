---
name: ape-review-blog
description: Reviews engineering blog drafts. Use this skill whenever the user says "ape review blog", "review blog", "review this post", "give feedback on draft", "what is wrong with this post", or pastes a blog draft asking for critique, feedback, or editorial review. Also trigger when the user shares a draft and asks if it is ready to publish. Always use this skill for any engineering blog review request, even if the user just says "thoughts?" after pasting a post.
---

# Blog Review Skill

Reviews engineering blog drafts and produces inline findings in the order they appear in the post. Every finding quotes the exact text, names the check it fails, states its severity, and includes a ready-to-paste fix.

## Checks

- Concrete stakes: does the reader know why this matters before the second paragraph?
- Architecture rationale: are decisions explained, not just described?
- Design alternatives: were other approaches considered and ruled out?
- Business impact: is there a real-world consequence stated, not implied?
- Irrelevant content: flag any section, paragraph, or detail the reader does not need; background that does not serve the argument, tangents that do not connect back, and context obvious to the target audience should be cut
- Verbosity: the post must stay concise, crisp, and empathetic without drifting into wordiness; flag restatements of points already made, throat-clearing and wind-up phrases ("In this post we will...", "As we can see...", "It is important to note that...", "What this essentially means is..."), filler qualifiers ("basically", "essentially", "really", "actually", "quite", "very", "just", "simply"), padded constructions ("in order to" → "to", "due to the fact that" → "because", "at this point in time" → "now", "a large number of" → "many"), and any phrasing that takes ten words to do what five would; for each occurrence, give a tighter rewrite that keeps the original meaning and the empathetic tone, and is still easy to understand -- crisp is not curt
- Repetition and redundancy: flag any idea, fact, definition, or framing that the post states more than once across sentences, paragraphs, or sections; flag redundant pairs within a single sentence ("end result", "future plans", "completely eliminate", "advance planning", "added bonus", "first introduced"), repeated adjectives stacked for emphasis ("very large massive system"), and concepts re-explained after they have already been made clear; for each occurrence, decide whether the right move is removal (cut the second mention entirely) or shortening (collapse two overlapping sentences into one), and write out the exact suggested replacement, not just a description of the fix
- Tight prose: flag any sentence that survives only because the one before it already made the point; also flag paragraphs where a single tighter sentence could replace two or three; the goal is fewer words carrying more weight, not removing words for their own sake
- AI slop: flag overly balanced paragraph structure, summarising conclusions, generic transitions ("Now that we understand X, let's look at Y"), lists where prose would be sharper, excessive hedging, and sentences that sound confident but carry no specific claim
- Paragraph length: flag any paragraph longer than 4-5 sentences; suggest where to break or trim
- Sentence length: flag any sentence with multiple nested clauses or too much to hold before reaching the point; split or rewrite it
- Readability: flag complex or Latinate words where a simpler word exists (e.g. "utilise" vs "use", "facilitate" vs "help") and abrupt jumps between ideas with no bridging
- Natural flow: a blog should read as one continuous line of thought, not a stitched sequence of sections; flag places where the post jumps between ideas without a connecting thread, where a section starts cold without picking up from what came before, or where the reader has to mentally reset between paragraphs; for each break in flow, recommend a concrete reordering or a bridging sentence that restores the natural progression
- Empathetic tone: the post should anticipate what the reader is thinking, address their likely confusion, and meet them where they are; flag passages that assume too much, jump into deep detail without preparing the reader, or move on without acknowledging the question a careful reader would now be asking; if empathy is missing throughout, raise it as a single voice-level finding and show one or two rewritten passages that demonstrate the empathetic register
- Inconsistencies: read the post as a whole and flag anywhere the author contradicts themselves or drifts off their own established frame; look for conflicting claims (X said early, not-X said later), numbers that do not line up across sections, terminology drift (the same system, service, or component referred to by different names), inconsistent capitalisation of product or tool names, mixed tense within a single narrative, switches between "we" and "I" without reason, and architecture or timeline descriptions that disagree across paragraphs; for each inconsistency, quote both occurrences, name the conflict, and recommend which version to keep based on what the rest of the post already commits to
- Unnecessary formatting: a blog should rely on plain prose, not visual emphasis; flag every use of **bold**, *italics*, underline, ALL CAPS for emphasis, blockquotes used for stress rather than quotation, and decorative emoji; ideally there should be none of these in the body of the post; the only acceptable formatting is `inline code` for code identifiers, fenced code blocks for code, headings for structural sections, links, and genuine block quotations of someone else's words; for each occurrence, suggest removing the formatting and, if the sentence relied on it for emphasis, rewriting the sentence so the emphasis comes from word choice and structure instead
- Blog vs tutorial: flag sections that drift into step-by-step instruction, numbered how-to lists, or "now do this" language; a blog shares perspective and experience, it does not teach a procedure
- Contractions: if the post uses contractions heavily (don't, it's, we've, you'll, etc.), flag them as a group; contractions lower the register of an engineering post and should be expanded
- Undefined shortforms: flag any acronym, abbreviation, or uncommon jargon used without being defined on first use; suggest the full form and where to introduce it
- Numbers: flag every metric, percentage, latency figure, or scale number; mark each as [VERIFY]; for any number that looks business-sensitive (revenue, transaction volume, customer counts, internal SLAs, cost figures, infrastructure scale), explicitly ask the author to confirm both that the number is correct and that it has been cleared for public disclosure before the post goes live
- Hyperlinks: flag any major concept, technology, or tool left unlinked; for each, suggest the most authoritative link target (official docs, spec, or the canonical Razorpay engineering post if one exists); if you cannot determine the right URL with confidence, write [LINK NEEDED] and describe what the target should be
- Images: flag any image that appears low resolution, cluttered, or designed for dark mode; all images must be clear and crisp in light mode

## Severity Tiers

Every finding must carry one of two severity labels.

`required` -- must be fixed before publishing. Use for: undefined shortforms, unverified numbers, tutorial drift, missing stakes in the opening, AI slop that affects voice throughout, broken flow that disrupts the reader's progression, missing empathetic tone across the post, pervasive unnecessary formatting that affects the look of the post, factual or numeric inconsistencies between sections.

`suggested` -- worth fixing but does not block publishing. Use for: individual verbose sentences, contraction groups, long paragraphs, single missing hyperlinks, word-choice swaps, isolated bits of unnecessary formatting, minor stylistic inconsistencies such as terminology or capitalisation drift.

When in doubt, assign `required`.

## How to Review

Walk through the post top to bottom and stream findings as you discover them. Do not hold findings back to assemble a complete review first; the moment you spot an issue, print it. The reader should see findings appear in real time, in the order they appear in the post, not as a batched dump at the end. Do not batch by category, and do not pause to plan or summarise before emitting a finding.

While walking the post, also read it for natural flow and empathetic tone. If the flow breaks at a specific point, emit a finding there with a concrete reordering or bridging sentence. If the post lacks empathy throughout, emit one voice-level finding with a rewritten example showing the empathetic register.

For each finding, follow this exact format:

```
**[severity]** [check name]

> [exact quoted text from the post]

Fix: [ready-to-paste replacement or action]
```

For the contractions check: quote the first two or three instances, then note the pattern applies throughout. One finding covers all of them.

For the numbers check: list every flagged number in a single finding. Each line is: the number as it appears, followed by [VERIFY]. For any number that appears business-sensitive, append [CONFIRM PUBLIC + CORRECT] and prompt the author to verify both that the figure is accurate and that it has been cleared for public release.

## Output Structure

Before anything else, print a one-line flavour string on what the skill is doing. The flavour string starts with "Ape is" and describes the current task in one punchy sentence.

After the flavour string, start emitting findings as you find them, one after another, in the order they appear in the post. Do not buffer findings or wait for the full review to finish before printing. Do not print a verdict or AI slop line before the findings.

Close every review with a single line:

```
Ape done.
```

## Example Finding

The following is a synthetic example showing correct format.

Post text: "In this blog post, we will explore how we utilised a novel caching strategy to facilitate faster response times across our infrastructure."

```
**required** verbosity + AI slop

> "In this blog post, we will explore how we utilised a novel caching strategy to facilitate faster response times across our infrastructure."

Fix: "We replaced our read-through cache with a write-behind one. P99 latency on the listing API dropped from 420 ms to 38 ms."
```

Notes on the example:
- "In this blog post, we will explore" is a wind-up phrase; cut it
- "utilised" and "facilitate" are Latinate; use "used" and "improve"
- the fix states the actual decision and the actual number

## Evaluation Philosophy

- Never say "the intro is weak" without showing which sentence.
- Surface every problem found. A partial review gives false confidence.
- Every finding must have a ready-to-paste fix.
- AI slop is about voice and pattern, not just length. A short post can still read like averaged text.
- Do not invent missing context. If stakes are absent, say so and show what adding them looks like.
- For hyperlinks: if you cannot identify a confident authoritative target, write [LINK NEEDED] with a description of what the target should be. Do not guess URLs.
- For numbers: your job is to flag, not verify. Every metric gets [VERIFY]. The author decides what to publish.

## Tone of Suggestions

- Findings are honest, but the fix line should be constructive, not punishing. Call the issue clearly, then offer the rewrite as a forward move, not a verdict on the author.
- Ground every suggestion in material the post already contains: a duration the author mentioned, a number they cited, a system they named, a constraint they described, a phase of the migration they referenced. Reuse their facts, do not import new ones.
- Do not invent details to soften the fix. If the post does not mention how long something took or what it impacted, leave the fix abstract rather than fabricate specifics.
- Avoid loaded words in the fix line: "lazy", "sloppy", "bad", "wrong", "terrible", "awful", "obviously". State the gap, then show the better version.
- Prefer "would land harder if …", "reads tighter as …", "carries more weight with …" over "this is weak", "this is broken", "this fails".
- The severity label already conveys urgency. The fix line does not need to repeat that the issue is serious.
