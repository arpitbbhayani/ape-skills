---
name: ape-help-me-understand
description: Digests dense content -- a post, paper, doc, or thread -- into a TLDR that keeps the numbers and caveats, a so-what naming why it matters, the key points, and an analogy with its breaking point. Trigger on "ape understand", "tldr this", "help me understand this", "give me an analogy", or when the user shares a post, paper, doc, or thread and asks to digest or summarize it. Do not trigger for plain questions that want a direct answer, not a digest.
---

# Understand Skill

Reads dense content and hands back understanding, not just compression. The output has four layers: a TLDR you can repeat to a colleague in the hallway, a so-what naming what the reader should do or believe differently, the key points that must survive the summary, and an analogy that gives the concept a shape -- with an honest note on where the analogy stops being true.

The difference between this and a generic summary: a generic summary preserves the vibe and loses the substance. This skill does the opposite. The numbers, the caveats, the trade-offs, and the one surprising claim survive; the padding, the tone, and the structure of the original do not.

## What Must Survive

When compressing, these carry the meaning and must never be dropped or blurred:

- **Numbers**: latencies, percentages, scale figures, benchmark results, costs, dataset sizes. "Significantly faster" is a loss; "3.2x faster on reads, 11% slower on writes" is the point.
- **Caveats and conditions**: the "only when", "except if", "assuming that" clauses. A claim stripped of its condition is a different, usually wrong, claim.
- **Trade-offs**: what was given up to get what was gained. If the original paid a price, the summary names the price.
- **The mechanism**: not just what happens but the one-sentence why. "The cache made it faster" loses the mechanism; "moving the lookup off the request path made it faster" keeps it.
- **The surprising claim**: the one thing in the content a knowledgeable reader would not have guessed. This is usually the reason the content exists; find it and lead with it.
- **Named things**: systems, algorithms, papers, tools the content builds on. These are the reader's hooks for going deeper.

What does not survive: the author's windup, the recap paragraphs, the third example of the same point, the section structure, and any sentence that exists for tone rather than information.

## Input Handling

The user may provide input in any of these forms. Identify which it is before doing anything else.

1. **File path on disk**: a path ending in `.md`, `.txt`, `.rst`, or similar. Read the file directly.
2. **A URL**: a string starting with `http://` or `https://`. Use `WebFetch` to download the content, then strip navigation, sidebars, footers, and comments before working on the body. If the URL points to a PDF (research paper), download it with `curl` and extract the text -- prefer `pdftotext` if available; otherwise read the PDF directly with the `Read` tool.
3. **Pasted content**: raw text in the message. Work on it in-memory.
4. **Ambiguous**: if it is unclear whether the input is a path, URL, or pasted text, ask once. Do not guess.

For file and URL inputs, surface the source at the top of the output (one line: `Source: <path or URL>`). For pasted content, skip that line.

## How to Understand

Read the whole input once before writing anything. The first read is for finding the spine: what is the central claim, what evidence carries it, what would a sharp reader push back on, and what is the one thing here that was not obvious before reading. Everything in the output hangs off that spine.

Then build the four layers:

- **The TLDR** is at most 5 lines. It states the central claim, the strongest piece of evidence (with its number), and the biggest caveat. Test it by asking: if the reader gets only these lines, do they walk away with a true and useful belief? If the TLDR would mislead without a caveat, the caveat goes in the TLDR, not below it.
- **The so-what** is 1-3 lines answering the question the TLDR does not: why should the reader care. It names what to do, build, or believe differently now that the claim is known -- and for whom. If the honest answer is "nothing changes for you unless you operate under condition Y", say exactly that; a narrow so-what is more useful than an inflated one.
- **The key points** are the facts that must survive, as listed above -- each one a single self-contained sentence a reader can absorb without the original. Order them by importance, not by where they appear in the source. Five to ten points for a blog post; up to fifteen for a dense paper. Every number from the source that matters appears here exactly as the source stated it. Every point must also pass the so-what test: a fact that changes nothing the reader would do or believe is trivia, however interesting -- cut it.
- **The analogy** maps the core mechanism onto something the reader already understands from everyday life or from a well-known system. A good analogy is load-bearing: the reader can reason inside it and reach correct conclusions about the real thing. Every analogy is followed by a "breaks down" note naming the point where reasoning inside the analogy starts producing wrong conclusions. An analogy without its breaking point is a trap, not a teaching aid. Give one analogy by default; give a second only if the concept has two genuinely distinct aspects that no single analogy covers.

Rules:

- **Never invent.** Every number, name, and claim in the output must appear in the source. If the source is vague, the summary is honestly vague -- do not sharpen a "much faster" into a made-up figure.
- **Never flatten a caveat.** If the source says X holds only under condition Y, the output says so. Dropping Y to make the point cleaner is the one unforgivable move.
- **Compression is selection, not paraphrase-shrinking.** Decide what matters, keep it at full fidelity, and drop the rest entirely. A summary where everything got 40% shorter is worse than one where 60% got cut and 40% survived intact.
- **Never inflate the so-what.** If the content matters only to a narrow audience or under a specific condition, the so-what names that audience and that condition. Manufacturing universal relevance is a form of inventing.
- **Analogies map mechanisms, not vocabulary.** "A cache is like a notebook" is vocabulary; "a write-ahead log is like writing the cheque stub before handing over the cheque -- if you are interrupted, the stub tells you what you were doing" maps the mechanism.
- **If the content contradicts itself or a claim looks wrong**, note it in one line under the key points. Understanding includes noticing what does not add up.
- **Do not pad short input.** If the source is already tight -- a paragraph, an abstract, a short note -- do not stretch it into four layers. Give the TLDR, the so-what, and, if the mechanism deserves one, the analogy. Say in one line that the source was already close to its own summary.
- **Format the final output through [[ape-style-markdown]]** before printing or writing to file.

## Output Structure

Before anything else, print a one-line flavour string on what the skill is doing. It starts with "Ape is" and describes the current task in one punchy sentence. Examples: "Ape is digesting the paper so you do not have to read it twice.", "Ape is boiling this down to what actually matters.", "Ape is finding the spine of this post."

If the input was a file or URL, print one line under the flavour string:

```
Source: <path or URL>
```

Then print the four layers:

```
## TLDR

[at most 5 lines: central claim, strongest evidence with its number, biggest caveat]

## So What

[1-3 lines: what the reader should do, build, or believe differently, and for whom]

## Key Points

- [self-contained fact, ordered by importance]
- [...]

## Analogy

[the analogy, 2-5 sentences, mapping the core mechanism]

Breaks down: [where reasoning inside the analogy starts giving wrong answers about the real thing]
```

If the content is purely factual with no mechanism to map (a changelog, a list of announcements), skip the analogy section entirely rather than forcing one. Say in one line why it was skipped.

Before printing, run one fidelity check: for every number and caveat in the output, confirm it appears in the source and means the same thing there. If a key point cannot be traced back to a specific passage, cut it. The so-what gets the same check: it must follow from a claim the source actually makes, not from general enthusiasm -- if the source does not support the recommendation, narrow the so-what until it does.

Close with a single line:

```
Ape done.
```

## When Writing Back to a File

If the input was a file on disk and the user asks for the output as a file, write it to a sibling file with `-understood.md` appended to the stem (`paper.pdf` becomes `paper-understood.md`). Never overwrite the original. The file contains only the three layers -- no flavour string, no `Source:` line, no `Ape done.` line. By default, the response in chat is the deliverable; write a file only when asked.

## Example

**Input** (excerpt from a systems paper):

> We evaluate our approach on three production workloads. By speculatively executing dependent transactions and validating at commit time, throughput improves by up to 2.4x over two-phase locking, though the benefit disappears under high contention (above roughly 30% conflicting transactions), where wasted speculative work dominates. Our technique requires deterministic transaction logic and does not support interactive transactions.

**Output:**

## TLDR

Speculative execution of dependent transactions, validated at commit time, gives up to 2.4x the throughput of two-phase locking on production workloads. The win vanishes under high contention -- above roughly 30% conflicting transactions, wasted speculation dominates. It only works for deterministic, non-interactive transactions.

## So What

If your workload is deterministic and conflicts are rare, this class of technique buys real throughput over two-phase locking. If your transactions are interactive or contention is high, nothing here applies to you.

## Key Points

- Throughput improves up to 2.4x over two-phase locking, measured on three production workloads.
- The gain disappears above roughly 30% conflicting transactions, where wasted speculative work dominates.
- Requires deterministic transaction logic; interactive transactions are not supported.

## Analogy

It is like a kitchen that starts cooking the next order while the current one is still awaiting the customer's final confirmation. Most of the time the confirmation comes and the food is already halfway done, so orders move faster. When customers keep changing their orders, the kitchen throws away half of what it cooks and ends up slower than just waiting.

Breaks down: in the kitchen, throwing food away costs ingredients; in the system, aborted speculation costs only CPU and can be retried instantly, so the penalty for a wrong guess is milder than the analogy suggests.

Notes on the example:
- the 2.4x, the 30% threshold, and both caveats survive at full fidelity
- the biggest caveat lives in the TLDR itself, because the claim misleads without it
- the so-what names both who this matters to and who it does not -- narrow and honest, not inflated
- the analogy maps the mechanism (speculate, then confirm or discard) and names where it stops being true

## Philosophy

- Understanding is being able to repeat the claim, defend it with the evidence, and name the catch. The output exists to make the reader capable of all three.
- The caveat is the claim. A summary that keeps the headline and drops the condition has produced a falsehood with a citation.
- Numbers are sacred. Everything else in a technical text is negotiable prose; the numbers are the content.
- A fact that changes nothing is trivia. The so-what test is the filter between understanding and trivia collection.
- An analogy the reader cannot break is one the reader cannot trust. Naming where it fails is what makes it safe to use.
- Shorter by selection, not by dilution. Cut whole ideas that do not matter; never thin out the ones that do.
