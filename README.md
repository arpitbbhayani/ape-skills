# Ape Skills

Skills for apes like us, so we can do our jobs better and make our lives easier.

## Installation

Install a skill with `npx skills`.

```bash
npx skills add https://github.com/arpitbbhayani/ape-skills/tree/master/<skill-name>
```

For example, to install `ape-commit`:

```bash
npx skills add https://github.com/arpitbbhayani/ape-skills/tree/master/ape-commit
```

Or you can download the skill directory and copy it into your Claude skills folder:

```bash
cp -r ape-commit ~/.claude/skills/
```

Each subdirectory is a self-contained skill and can be installed individually.

## Usage

Just say `ape ...` and the matching skill takes over. For example, `ape commit` triggers the commit formatting skill.

You can also tag a skill explicitly with `/skill`, e.g. `/ape-commit`.

## Skills

| Skill                                      | Description                                                                |
| ------------------------------------------ | -------------------------------------------------------------------------- |
| [ape-commit](./ape-commit)                 | Formats git commit messages with a crisp summary and imperative bullets.   |
| [ape-style-markdown](./ape-style-markdown)         | Applies consistent, professional Markdown formatting rules to any output.  |
| [ape-write-pseudocode](./ape-write-pseudocode) | Writes high-level pseudocode for functions and algorithms.                 |
| [ape-quiz-me](./ape-quiz-me)               | Quizzes you on content you claim to have read -- Socratic, hints that narrow but never reveal, ending with an understood-vs-recited verdict. |
| [ape-cli-terminal-experience](./ape-cli-terminal-experience) | Designs a CLI's terminal experience the Claude Code way -- palette, glyphs, spinners, prompts, listings, and full-screen TUI views. |
| [ape-present](./ape-present)               | Converts a blog post into a single self-contained, readable HTML document -- animated diagrams, large numbers, typeset formulas, just enough text to carry the idea. Requires the `reference/` directory alongside `SKILL.md`. |
| [ape-design](./ape-design)                 | Enforces the Array UI editorial systems design system -- page archetypes, mathematical density, signature palette, and 0% custom CSS. |
| [ape-write-paper](./ape-write-paper)       | Writes a polished two-column LaTeX paper and PDF from any source material -- audits every claim against evidence first, reports losses honestly, builds figures and tables from real data, and renders pages to check them. Requires the `reference/` directory alongside `SKILL.md`. |


## License

MIT License. See [LICENSE](./LICENSE).
