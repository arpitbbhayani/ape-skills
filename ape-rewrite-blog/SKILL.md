---
name: ape-rewrite-blog
description: Rewrites an engineering blog draft by first running the ape-review-blog skill on it and then applying every suggested fix to produce a revised version. Use this skill whenever the user says "ape rewrite blog", "rewrite blog", "rewrite this post", "apply review suggestions", "fix the draft", "rewrite the draft", or shares a blog file and asks to apply review feedback. Also trigger when the user has already received a review and wants the suggestions implemented in a new file. Always use this skill for any engineering blog rewrite request where the goal is to produce a fixed-up draft, not just a review. The rewrite is written to a sibling file with the `-ape.md` suffix.
---

# Blog Rewrite Skill

Produces a revised version of an engineering blog draft by applying every fix surfaced by [[ape-review-blog]]. The review is the source of truth for what to change; this skill executes the fixes and writes the result to a new file.

## How to Run

1. Identify the source blog file the user is referring to. It must be a path on disk. If the user only pasted text, ask them for the file path before continuing -- the rewrite needs a real file to suffix.
2. Check whether `ape-review-blog` has already run on this exact file earlier in the current conversation and the file has not changed since. Signals that the review is already available: the Ape banner and a stream of `**required**` / `**suggested**` findings followed by `Ape done.` appear in the transcript, against the same path. If so, reuse those findings directly -- do not re-run the review, do not re-emit the banner, do not re-print the findings. Skip straight to step 4.
3. Otherwise, invoke the `ape-review-blog` skill on that file and let it produce its findings end-to-end. Do not skip checks, do not summarise findings, do not collapse the review into a shorter form. The review must run as it normally would.
4. Apply every finding -- both `required` and `suggested` -- to the original text. Use the `Fix:` line from each finding as the replacement. For findings that describe an action rather than a literal replacement (reorderings, paragraph splits, bridging sentences, removing formatting), perform that action faithfully in the new draft.
5. Write the rewritten post to a new file alongside the original, with `-ape` appended to the stem. For example, `post.md` becomes `post-ape.md`, `2026-05-distributed-locks.md` becomes `2026-05-distributed-locks-ape.md`. Never overwrite the original. If a file with the `-ape.md` suffix already exists, overwrite it -- this is a regenerated rewrite, not a second variant.
6. Print the path of the new file at the end.

If the user explicitly asks to "re-review" or "review again before rewriting", treat that as an override and run the review fresh in step 3 even if a prior review exists.

## Rules for the Rewrite

- Apply every finding from the review. Do not cherry-pick. If the review flagged it, fix it.
- For `[VERIFY]` numbers, leave the number as-is in the rewritten draft but add an inline HTML comment `<!-- VERIFY: confirm number is correct -->` next to it. For numbers also tagged `[CONFIRM PUBLIC + CORRECT]`, the comment is `<!-- VERIFY: confirm number is correct AND cleared for public disclosure -->`.
- For `[LINK NEEDED]` hyperlinks, wrap the relevant phrase in a markdown link with the placeholder URL `[LINK NEEDED]`, so the author can spot and fill them in.
- Preserve the author's voice, facts, and structural intent. The rewrite tightens and corrects the draft; it does not reinterpret it. Never invent numbers, systems, or details that were not in the original.
- Keep code blocks, fenced examples, and genuine quotations untouched unless the review explicitly flagged them.
- Expand contractions, strip decorative formatting, and remove tutorial-style instruction wherever the review called them out.
- If two findings touch the same sentence, merge their fixes into one rewritten sentence rather than applying them sequentially.

## Output Structure

If the review has not been run yet for this file in the current conversation, run `ape-review-blog` first and let its full output stream as normal -- banner, findings, and `Ape done.` line included. Then continue with the rewrite section below.

If a prior review for this file is already in the transcript, skip the review output entirely and open with a single line acknowledging the reuse:

```
Ape is reusing the earlier review for this file.
```

Either way, before writing the file, print a short separator and a one-line note that the rewrite is starting:

```
---
Ape is rewriting the post with every fix applied.
```

Then write the new file. Do not print the rewritten post inline; the file is the deliverable.

Close with a single line naming the new file:

```
Rewrite written to <path>-ape.md.
```
