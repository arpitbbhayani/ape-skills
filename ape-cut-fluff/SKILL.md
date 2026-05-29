---
name: ape-cut-fluff
description: A surgical editor that strips fluff and redundant information out of a piece of writing and drives the word count down to the bare minimum needed to convey the concept. Flags and removes hedging, empty disclaimers, throat-clearing intros, cliché openers, empty subject openers, filler transitions, self-reference and meta-structure, summarising conclusions, rhetorical-question tails, intro-body-conclusion symmetry, padded constructions, nominalisations, filler qualifiers, adjective and intensifier stacks, redundant pairs, restatement and cross-paragraph repetition, redundant examples and analogies, redundant background and context, redundant elaboration, dead sentences, AI-slop framing, code-narration, ceremonial closers, and non-load-bearing filler words (articles, auxiliaries, connective tissue) whose removal does not change meaning. Use this skill whenever the user says "ape cut fluff", "cut the fluff", "trim this", "tighten this", "strip the fluff", "make this crisp", "remove filler", "remove redundancy", "deduplicate this", "edit this down", "bare minimum words", or shares a text file, raw content, blog post, research paper, or URL and asks to cut the fluff. The skill accepts input as a file path, pasted content, or a URL (which it downloads first). Output is the tightened version of the same content, reduced to the fewest words and the fewest ideas that still carry the essence.
---

# Cut Fluff Skill

A surgical, single-pass editor. Walks the input top to bottom and removes every sentence, phrase, or word that delays the point without adding meaning. Cuts only -- does not reinterpret, restructure, or rewrite arguments. The author's voice, facts, and structural intent stay intact; the fat comes off.

The goal is the **bare minimum word count** that still lets a competent reader understand the concept and grasp the essence. If a word can be dropped without changing meaning, drop it. If a sentence can be shrunk into a clause without losing a fact, shrink it. If an idea, example, or piece of context appears more than once, keep only the strongest instance and cut the rest. Aim for prose so dense that every remaining word is doing work and every remaining idea is appearing for the first time.

## What Counts as Fluff

The skill cuts the following on sight. Any phrase, sentence, or paragraph that matches one of these patterns is fluff:

- **Hedging language**: "it is important to note that", "it should be mentioned that", "it is worth pointing out that", "needless to say", "as a matter of fact", "to be honest", "in my opinion", "I think", "perhaps", "arguably" -- when they soften a claim the author is willing to make outright
- **Empty disclaimers**: "of course there are exceptions", "this is a simplification", "your mileage may vary", "obviously this depends on context", "every system is different" -- if the disclaimer does not name a specific exception, cut it; if it names one, keep only the naming clause
- **Throat-clearing intros**: "In this post we will...", "Before we begin...", "Let us first understand...", "As we all know...", "To start with...", "First of all..." -- any windup that delays the first real sentence
- **Cliché openers**: "In today's fast-paced world...", "In the age of AI...", "As engineers, we all know...", "We live in a world where..." -- generic openers that could front any blog; cut and let the first concrete claim be the opener
- **Empty subject openers**: "There is...", "There are...", "It is...that...", "What is interesting is that...", "The thing about X is that..." -- strip the placeholder and let the real subject lead. Example: "There are many systems that fail under load" → "Many systems fail under load."
- **Filler transitions**: "Now that we understand X, let us look at Y", "With that said...", "Having said that...", "Moving on...", "That being said...", "On a related note..."
- **Self-reference and meta-structure**: "in this section", "in the next section we will", "this article will cover", "as we will see", "as discussed earlier", "as mentioned above", "more on this later", "we will return to this", "(spoiler alert)" -- meta-commentary about the structure of the post that adds no information
- **Summarising conclusions**: "As we can see...", "In summary...", "To wrap up...", "In conclusion...", "What this essentially means is..." -- especially when the next sentence repeats what was just said
- **Rhetorical-question tails**: "Right?", "Isn't it?", "Make sense?", "You with me?" -- performative, not informative
- **Intro→body→conclusion symmetry**: the "tell them what you will tell them, tell them, tell them what you told them" pattern; the previewing intro and the summarising closer are usually both fluff and the body carries the argument on its own; cut whichever the body makes redundant, keep the one that earns its place
- **Padded constructions**: "in order to" → "to", "due to the fact that" → "because", "at this point in time" → "now", "a large number of" → "many", "the majority of" → "most", "in the event that" → "if", "with regard to" → "about", "for the purpose of" → "to"
- **Nominalisations**: verbs buried inside noun phrases that bloat the sentence; restore the verb. "make a decision" → "decide", "perform an analysis" → "analyse", "carry out an evaluation" → "evaluate", "give consideration to" → "consider", "reach a conclusion" → "conclude", "have a discussion about" → "discuss", "is in agreement with" → "agrees with"
- **Filler qualifiers**: "basically", "essentially", "really", "actually", "quite", "very", "just", "simply", "literally", "definitely", "totally", "absolutely" -- when they add no information
- **Adjective and intensifier stacks**: "extremely fast", "incredibly difficult", "super important", "really critical", "absolutely essential", "highly significant" -- the noun or adjective carries the weight alone; cut the intensifier or replace the pair with a single stronger word
- **Redundant pairs**: "end result" → "result", "future plans" → "plans", "completely eliminate" → "eliminate", "advance planning" → "planning", "added bonus" → "bonus", "first introduced" → "introduced", "past history" → "history", "free gift" → "gift"
- **Restatement and repetition**: any idea, fact, definition, or framing that the post states more than once -- adjacent sentences that say the same thing, cross-paragraph repeats where the same point reappears sections later, definitional repetition where the same term or acronym is defined twice, and heading-body restatement where a heading and its first sentence carry the same claim ("Why caching matters" → "Caching matters because..."); keep the strongest mention and cut the rest, or collapse overlapping mentions into one sharper sentence
- **Redundant examples and analogies**: when the post offers two or three examples, analogies, or illustrations of the same point, keep the strongest one and cut the others; do not preserve a parallel example just because the author wrote it. The rule of thumb is: if the second example does not introduce a new failure mode, a new trade-off, or a new edge case the first did not surface, it is redundant
- **Redundant background and context**: setup, history, or motivation that the reader already has from earlier in the post, from the title, or from the heading; cut prerequisite explanations that the post itself just covered, recaps that exist only because the author is afraid the reader has forgotten, and "as a refresher" passages that re-explain something stated a few paragraphs above
- **Redundant elaboration**: a claim followed by a longer paragraph that says the same thing in more words without adding mechanism, evidence, or consequence; keep the crisp claim, cut the elaboration. If the elaboration introduces a number, a system name, a failure mode, or a trade-off the claim lacked, keep the new fact and cut the rest
- **Idea redundancy across the whole post**: the most expensive form of redundancy. Two paragraphs in different sections that make the same argument from slightly different angles; a sidebar that repeats the main thread; a "key takeaway" box that restates the section it sits inside. During the first read, flag every place the same idea reappears; in the cutting pass, keep one canonical mention -- usually the earliest or the most concrete -- and cut every echo, even if the echoes are well-written
- **Dead sentences**: any sentence that survives only because the sentence before it already carried the point
- **AI-slop framing**: overly balanced "On one hand... on the other hand..." paragraphs where one side is obviously the answer; symmetric conclusions that restate the intro; generic exhortations ("This is a powerful technique that engineers should consider when designing systems")
- **Code-narration**: prose right after a fenced code block that re-describes what the code does line by line; cut the narration and keep only sentences that add intent, trade-offs, or non-obvious behaviour the code itself does not show
- **Ceremonial closers**: "Thank you for reading", "Hope you found this useful", "Stay tuned for more" -- cut entirely
- **Non-load-bearing filler words**: individual words whose removal does not change meaning -- redundant articles ("the", "a", "an") where the sentence parses without them, auxiliary verbs ("is being used" → "uses", "can be seen to" → ""), expletive subjects, relative pronouns where the clause still works ("the system that we built" → "the system we built"), prepositional padding ("the field of distributed systems" → "distributed systems"), possessive "of" chains ("the design of the system" → "the system design"), and connective tissue ("and so", "and then", "but also") that pads without joining genuinely distinct ideas. Read each sentence and ask: which words can I delete and still leave the same claim standing? Delete them.
- **Verbose phrasings**: prefer the shorter equivalent on sight -- "is able to" → "can", "has the ability to" → "can", "in spite of the fact that" → "though", "despite the fact that" → "though", "the reason is because" → "because", "during the course of" → "during", "on a daily basis" → "daily", "a number of" → "some/many", "a variety of" → "various", "as a means of" → "to", "the question as to whether" → "whether"
- **Compressible sentence frames**: long-form sentence frames that compress into a phrase -- "It is important to understand that X" → "X", "What we need to do is X" → "X" or "Do X", "The way that this works is X" → "It works by X", "One thing to keep in mind is X" → "X". The leading frame is fluff; the embedded clause is the point

## Input Handling

The user may provide input in any of these forms. Identify which it is before doing anything else.

1. **File path on disk**: a path ending in `.md`, `.txt`, `.rst`, or similar. Read the file directly.
2. **A URL**: a string starting with `http://` or `https://`. Use `WebFetch` to download the content, then strip navigation, sidebars, footers, and comments before working on the body. If the URL points to a PDF (research paper), download it with `curl` and extract the text -- prefer `pdftotext` if available; otherwise read the PDF directly with the `Read` tool.
3. **Pasted content**: raw text in the message. Work on it in-memory.
4. **Ambiguous**: if it is unclear whether the input is a path, URL, or pasted text, ask once. Do not guess.

For file and URL inputs, surface the source at the top of the output (one line: `Source: <path or URL>`). For pasted content, skip that line.

## Editing Rules

Read the whole input once before cutting anything. The first read is for mapping: where does the post repeat itself across paragraphs, where does the intro preview the body, where does the closer summarise it, where do the same terms get defined twice, where do headings and their opening sentences say the same thing, which paragraphs make arguments that the post already made elsewhere, which examples illustrate a point already illustrated. Build a mental index of every distinct idea in the post and where each one appears. Hold that map in mind. Then make one editing pass from start to finish. At each sentence, ask two questions: does this carry meaning the reader needs, and is this the first time the post is conveying that meaning? Cut what delays. Cut what repeats. Keep what carries and what is new.

- **Cut, do not rewrite.** Remove fluff phrases, sentences, and paragraphs. Do not rephrase arguments, do not reorder ideas, do not invent new framings. If a sentence is half-fluff, cut the fluff half and stitch the remaining clause back into prose.
- **Preserve voice and facts.** Keep the author's tone, technical claims, numbers, code, examples, and quotations untouched. Never paraphrase a factual statement. Never invent a number, a system name, or a detail that was not in the original.
- **Preserve structure.** Keep section headings, code blocks, fenced examples, links, lists, and genuine block quotations exactly as they appear. Cut fluff inside paragraphs, not the scaffolding around them.
- **Collapse, do not delete sense.** When two adjacent sentences say the same thing, collapse them into the stronger one. Do not delete both. Do not delete the weaker one if it carries a fact the stronger one omits.
- **Deduplicate across the whole post, not just adjacent sentences.** Redundancy is not only a local problem. When the same idea, definition, example, or motivation appears in section 1 and again in section 4, treat it as redundant even though paragraphs separate the two mentions. Keep the earliest or most concrete mention and cut the later echoes. If the later mention adds a fact the first did not have, fold that fact into the earlier mention and delete the later paragraph.
- **One example is usually enough.** When the author offers parallel examples that illustrate the same point (two analogies, three case studies, a list of equivalent failure modes), keep the sharpest one and cut the rest. Preserve multiple examples only when each introduces a genuinely new angle.
- **Keep transitions only when they connect.** A transition that bridges two genuinely different ideas stays. A transition that exists only to acknowledge that a new section has started gets cut.
- **Contractions stay as the author wrote them.** This skill does not change register. It only removes fluff.
- **No editorial commentary.** Do not annotate cuts, do not summarise what was removed, do not leave `<!-- cut: ... -->` comments. The output is the trimmed text, not a diff.
- **Format the final output through [[ape-style-markdown]].** Once the fluff is cut, hand the trimmed text to the `ape-style-markdown` skill before printing or writing to file. That skill enforces ASCII punctuation, no decorative formatting, no hard line wrapping, and the rest of the house style. Skip this step only when the input was plain text with no Markdown structure (no headings, no code blocks, no lists, no links) -- in that case, return the cut text as-is.

## Output Structure

Before anything else, print a one-line flavour string on what the skill is doing. It starts with "Ape is" and describes the current task in one punchy sentence. Examples: "Ape is cutting the fluff out of your draft.", "Ape is trimming filler from the downloaded paper.", "Ape is stripping the hedges and windups."

If the input was a file or URL, print one line under the flavour string:

```
Source: <path or URL>
```

Then print a horizontal separator and start the trimmed output:

```
---
```

Print the trimmed content from start to finish, preserving all markdown structure (headings, lists, code blocks, links). Run the result through [[ape-style-markdown]] before printing so the output already conforms to the house Markdown style (ASCII punctuation only, no hard line wrapping, no decorative formatting). Do not print the original text alongside it. Do not print a side-by-side. Do not print a list of cuts.

After the trimmed content, print a separator and a footer that names the size of the cut and breaks it down by category:

```
---
Ape cut <N>% (<before> → <after> words).

Removed:
- <count> hedges and empty disclaimers
- <count> windups and cliché openers
- <count> empty subject openers
- <count> filler transitions and meta-references
- <count> summarising conclusions and rhetorical tails
- <count> padded constructions and nominalisations
- <count> filler qualifiers and intensifier stacks
- <count> redundant pairs
- <count> restatements and cross-paragraph repeats
- <count> redundant examples and analogies
- <count> redundant background and context passages
- <count> redundant elaborations
- <count> dead sentences and AI-slop paragraphs
- <count> code-narration paragraphs
- <count> ceremonial closers
- <count> non-load-bearing filler words
- <count> verbose phrasings and compressible frames
```

Only list categories where the count is non-zero. Counts are honest estimates of what you actually cut, not exact tallies. The before/after word counts are real -- count them. If the percentage is tiny (under 5%), drop the breakdown and say plainly: `Ape found little to cut. The draft is already tight.`

Close with a single line:

```
Ape done.
```

## When Writing Back to a File

If the input was a file on disk, also write the trimmed version to a sibling file with `-cut.md` appended to the stem. For example, `post.md` becomes `post-cut.md`, `paper.txt` becomes `paper-cut.txt`. Never overwrite the original. If a `-cut` file already exists, overwrite it -- this is a regenerated cut, not a second variant. Print the new file path on the line above `Ape done.`:

```
Trimmed version written to <path>-cut.md.
Ape done.
```

If the input was a URL or pasted content, do not write a file. The trimmed text in the response is the deliverable.

## What Goes in the File vs the Response

The stats footer (the by-category breakdown and the word-count delta) is an interactive-only artefact. It belongs in the chat response so the author can see what was cut, but it does not belong in any document written to disk.

- **File at `<stem>-cut.md`**: contains only the trimmed content. No flavour string, no `Source:` line, no `---` separators, no stats footer, no `Ape done.` line. The file should be a clean, ready-to-publish version of the post.
- **Interactive response (chat, Agent, Claude Code, CLI output)**: print everything -- the "Ape is..." flavour string, the source line, the trimmed content, the stats footer, and the closing `Ape done.` line. This is where the author reads the breakdown and decides what to keep.
- **If the user explicitly says "just write the doc", "only write to file", "don't print the stats", or similar**: skip the stats footer in the response too, and reply with just the file path and `Ape done.`.

The same rule applies when this skill is invoked from another skill or as a sub-step in a longer pipeline -- the consuming skill gets the clean trimmed content, not the diagnostic footer.

## Example

**Input:**

> In this blog post, we are going to explore an interesting topic. It is important to note that distributed systems are notoriously hard to reason about. Basically, when you have multiple nodes communicating over a network, a large number of things can go wrong. What this essentially means is that engineers need to design for failure from day one. Now that we understand the problem, let us look at the solution.

**Output:**

> Distributed systems are hard to reason about. When multiple nodes communicate over a network, many things can go wrong, so engineers need to design for failure from day one.

Notes on the example:
- "In this blog post, we are going to explore an interesting topic." -- windup, cut entirely
- "It is important to note that" -- hedging, cut
- "notoriously" -- filler intensifier, cut
- "Basically" -- filler qualifier, cut
- "a large number of" -- padded, replaced with "many"
- "What this essentially means is that" -- restatement framing, cut; the next clause carries the point
- "Now that we understand the problem, let us look at the solution." -- filler transition, cut

## Philosophy

- Aim for the bare minimum. The target is the fewest words **and the fewest ideas** that still let a competent reader understand the concept. Every remaining word should be load-bearing, and every remaining idea should appear exactly once. If a word can be dropped without changing meaning, drop it. If an idea is already in the post, do not let it appear a second time.
- Crisp is not curt. Bare minimum does not mean telegraphic. The reader must still be able to follow the prose without re-reading. If a sentence reads cold or ambiguous after the cut, restore the smallest connecting word that makes it land -- not a full clause, just the one word.
- Cut the fat, keep the muscle. Numbers, examples, technical specifics, and the author's reasoning are muscle. Hedges, windups, restatements, and connective filler are fat.
- One editing pass only. Read the input first to map repetition and structure, then make a single cutting pass. Do not iterate. Do not second-guess. The first pass is the deliverable.
- Trust the author. If a sentence carries a claim, leave the claim alone. Cut only the words around the claim that delay it.
- When in doubt about meaning, keep. When in doubt about a filler word, cut. A borderline sentence that adds even a small amount of context stays. A borderline word that just smooths cadence goes.
