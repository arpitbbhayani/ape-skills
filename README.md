# Ape Skills

Skills for apes like us, so we can do our jobs better and make our lives easier.

## Installation

Install a skill with `npx skills`.

```bash
npx skills add https://github.com/arpitbbhayani/ape-skills/tree/master/<skill-name>
```

For example, to install `ape-review-blog`:

```bash
npx skills add https://github.com/arpitbbhayani/ape-skills/tree/master/ape-review-blog
```

Or you can download the skill directory and copy it into your Claude skills folder:

```bash
cp -r ape-review-blog ~/.claude/skills/
```

Each subdirectory is a self-contained skill and can be installed individually.

## Usage

Just say `ape ...` and the matching skill takes over. For example, `ape review blog` triggers the blog review skill.

You can also tag a skill explicitly with `/skill`, e.g. `/ape-review-blog`.

## Skills

| Skill                                      | Description                                                                |
| ------------------------------------------ | -------------------------------------------------------------------------- |
| [ape-review-blog](./ape-review-blog)       | Reviews engineering blog drafts.                                           |
| [ape-rewrite-blog](./ape-rewrite-blog)     | Rewrites a blog draft by applying every fix from `ape-review-blog`.        |
| [ape-commit](./ape-commit)                 | Formats git commit messages with a crisp summary and imperative bullets.   |
| [ape-style-markdown](./ape-style-markdown)         | Applies consistent, professional Markdown formatting rules to any output.  |
| [ape-write-pseudocode](./ape-write-pseudocode) | Writes high-level pseudocode for functions and algorithms.                 |
| [ape-cut-fluff](./ape-cut-fluff)           | Strips fluff and redundancy to drive writing to the bare minimum word count. |

## License

MIT License. See [LICENSE](./LICENSE).
