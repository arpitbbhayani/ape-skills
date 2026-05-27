---
name: ape-style-markdown
description: >
  Apply consistent, professional Markdown formatting rules whenever producing or reformatting
  Markdown output. Use this skill when generating any Markdown document, when the user asks to
  reformat or clean up existing Markdown, when producing README files, technical docs, notes,
  or any other content that will be rendered as Markdown. Trigger even when the request seems
  simple -- any Markdown output should follow these rules. Do not use this skill for non-Markdown
  outputs such as plain text, HTML, or code-only responses.
---

# Markdown Style Guide

Apply these rules to every piece of Markdown you produce or reformat.

## Core Principles

- Write for a senior engineering audience: clean, precise, no fluff.
- Formatting exists to aid comprehension, not to decorate.
- When in doubt, use less formatting.

## Line Width

Never hard-wrap lines at a fixed column width. Every prose line -- paragraphs, list items, block quotes, table cells -- must be a single unbroken line. Let the renderer handle wrapping. This applies everywhere in the document without exception: do not wrap at 80, 100, 120, or any other column limit.

The only text that may contain newlines is content inside fenced code blocks, where newlines are part of the code itself.

## Prohibited Formatting

- No emojis, ever.
- No bold (`**text**`) unless technically required (e.g. a term being defined inline that would otherwise be ambiguous). Bold for emphasis or decoration is not allowed.
- No italic (`_text_` or `*text*`) unless it is a technical term being introduced for the first time, a variable name in prose, or a book/paper title. Do not italicise for tone or style.
- No HTML embedded in Markdown.

## Punctuation

Use only ASCII punctuation. Do not use Unicode typographic substitutes.

- No em-dash (—). Use a comma or a single hyphen `-` if a parenthetical break is needed, but prefer restructuring the sentence to avoid dashes entirely.
- No en-dash (–). Use a plain hyphen `-` for ranges (e.g. `2-5 seconds`) or rewrite as prose.
- No curly or smart quotes (" " ' '). Use straight ASCII quotes (`"` and `'`) only.
- No ellipsis character (…). Use three plain periods `...` if trailing off is genuinely needed; prefer a complete sentence instead.
- No multiplication sign (×), no bullet dot (•), no other Unicode punctuation substitutes. Use plain ASCII equivalents or rewrite.

When reformatting existing Markdown, replace any prohibited punctuation found in prose with its ASCII equivalent.

## Readability

Write prose that is easy to scan and understand on the first read.

- Keep sentences short. One idea per sentence. If a sentence needs a semicolon, split it into two sentences.
- Use active voice. "The server rejects the request" not "The request is rejected by the server."
- Lead with the most important information. Do not bury the key point at the end of a paragraph.
- Avoid filler qualifiers: never use "basically", "essentially", "simply", "just", "very", "quite", "actually", or "of course."
- Use parallel structure in lists. If the first item starts with a verb, every item starts with a verb.
- Prefer concrete over abstract. "Returns a 404" is better than "indicates the resource was not found."
- Avoid nominalizations. "We decided" not "We made a decision." "This fails" not "This results in a failure."

## Headings

- Use `#`, `##`, `###` etc. with a single space after the `#` character.
- Headings should be descriptive and specific -- avoid generic titles like "Overview" or "Details" when a more precise title is possible.
- Leave exactly one blank line after each heading before the body text begins.
- Do not place a blank line between a heading and its immediately following subheading.

Example:

```
## Installation

Run the following command to install dependencies.

### macOS

Use Homebrew to install the required packages.
```

## Paragraphs

- Separate paragraphs with a single blank line.
- Do not add more than one blank line between any two elements.

## Lists

- Leave one blank line before the entire list (before the first bullet or numbered item).
- Do not add blank lines between individual list items; keep lists compact.
- Do not add a blank line after the last list item unless a new section follows.
- Use `-` for unordered lists. Do not mix `-`, `*`, and `+`.
- Use `1.` for ordered lists; let the renderer handle numbering.
- Nested lists are allowed; indent with two spaces.

Example:

```
The release includes three changes:

- Fix for the authentication timeout bug
- Upgrade of the database driver to v5
- Removal of the legacy config parser
```

## Code

- Use backtick inline code (`` `value` ``) for: command names, file paths, variable names, function names, flags, environment variables, and any literal string that should not be reformatted.
- Use fenced code blocks with an explicit language tag for all multi-line code samples.
- Do not add blank lines inside a fenced code block unless the code itself requires them.
- Preserve all code blocks and inline code exactly when reformatting existing Markdown.

Example:

```bash
export DATABASE_URL="postgres://localhost:5432/mydb"
```

## Math

Use LaTeX syntax for all mathematical expressions. Do not write formulas as plain text or inline code.

- Inline math: wrap in single dollar signs: `$O(n \log n)$`, `$f(x) = x^2 + 1$`.
- Block (display) math: wrap in double dollar signs on their own lines:

```
$$
P(A \mid B) = \frac{P(B \mid A)\,P(A)}{P(B)}
$$
```

Never write formulas as plain text (`O(n log n)`) or as code spans (`` `O(n log n)` ``) unless the expression is inside a code block that is specifically illustrating source code.

## Block Quotes

- Use `>` block quotes for callouts, warnings, or quoted material that genuinely requires visual separation.
- Do not use block quotes as a styling substitute for emphasis.
- Preserve block quotes exactly when reformatting existing Markdown.

## Links

- Use inline links: `[display text](url)`.
- Use reference-style links only when the same URL is referenced more than twice.

## Tables

- Align column separators for readability in the raw Markdown source.
- Every table must have a header row separated by `---`.
- Do not add unnecessary columns or padding rows.

## Blank Lines -- Summary

| Context                       | Rule                             |
| ----------------------------- | -------------------------------- |
| After any heading             | Exactly one blank line           |
| Before a list                 | One blank line                   |
| Between list items            | No blank lines                   |
| Between paragraphs            | One blank line                   |
| Between any two elements      | At most one blank line           |
| Inside a fenced code block    | Only if the code itself requires |

## Reformatting Existing Markdown

When the user asks to reformat or clean up an existing Markdown document:

1. Apply all rules above.
2. Preserve all content: do not add, remove, or reword any text.
3. Preserve all code blocks, inline code, and block quotes verbatim.
4. Fix heading levels only if they are structurally broken (e.g. jumping from `#` to `###`).
5. Do not introduce new sections or headings.
6. Return the reformatted document only, with no preamble or commentary.
