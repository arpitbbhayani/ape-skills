# Ape Skills

Skills for apes like us, so we can do our jobs better and make our lives easier.

## Installation

Install a skill with `npx skills`.

```bash
npx skills add https://github.com/arpitbbhayani/ape-skills/tree/master/<skill-name>
```

For example, to install `ape-cut-fluff`:

```bash
npx skills add https://github.com/arpitbbhayani/ape-skills/tree/master/ape-cut-fluff
```

Or you can download the skill directory and copy it into your Claude skills folder:

```bash
cp -r ape-cut-fluff ~/.claude/skills/
```

Each subdirectory is a self-contained skill and can be installed individually.

## Usage

Just say `ape ...` and the matching skill takes over. For example, `ape cut fluff` triggers the fluff-cutting skill.

You can also tag a skill explicitly with `/skill`, e.g. `/ape-cut-fluff`.

## Skills

| Skill                                      | Description                                                                |
| ------------------------------------------ | -------------------------------------------------------------------------- |
| [ape-commit](./ape-commit)                 | Formats git commit messages with a crisp summary and imperative bullets.   |
| [ape-style-markdown](./ape-style-markdown)         | Applies consistent, professional Markdown formatting rules to any output.  |
| [ape-write-pseudocode](./ape-write-pseudocode) | Writes high-level pseudocode for functions and algorithms.                 |
| [ape-cut-fluff](./ape-cut-fluff)           | Strips fluff and redundancy to drive writing to the bare minimum word count. |
| [ape-plan-project](./ape-plan-project)     | Splits a spec into phases, each with a full product + engineering design doc for agent handoff. |
| [ape-poke-holes](./ape-poke-holes)         | Adversarially attacks design docs and specs. Finds failure modes, unstated assumptions, and scale cliffs -- no praise, no solutions, only holes. |
| [ape-help-me-understand](./ape-help-me-understand)         | Digests dense content into a TLDR that keeps the numbers and caveats, a so-what naming why it matters, the key points, and an analogy with its breaking point. |
| [ape-quiz-me](./ape-quiz-me)               | Quizzes you on content you claim to have read -- Socratic, hints that narrow but never reveal, ending with an understood-vs-recited verdict. |
| [ape-cli-terminal-experience](./ape-cli-terminal-experience) | Designs a CLI's terminal experience the Claude Code way -- palette, glyphs, spinners, prompts, listings, and full-screen TUI views. |
| [ape-present](./ape-present)               | Converts a blog post into a single self-contained, readable HTML document -- animated diagrams, large numbers, typeset formulas, just enough text to carry the idea. Requires the `reference/` directory alongside `SKILL.md`. |

## License

MIT License. See [LICENSE](./LICENSE).
