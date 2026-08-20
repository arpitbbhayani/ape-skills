---
name: ape-cli-terminal-experience
description: >
  Designs the terminal experience of a CLI app the way Claude Code does it -- palette,
  status glyphs, spinners, progress narration, prompts, confirmations, listings, key
  hints, and full-screen TUI views. Trigger on "ape cli terminal experience", or
  whenever the task involves printing to a terminal from a CLI: adding or restyling
  output, adding a spinner or progress indicator, writing a prompt or confirmation,
  building a TUI, choosing exit codes, or deciding stdout vs stderr. Also trigger on
  casual phrasings like "make the output nicer", "add colour", "this CLI looks ugly".
  Read this before writing the first line of output code.
---

# CLI Terminal Experience

A terminal UI that reads like Claude Code: mostly grey, a few deliberate accents, one
line per fact, animation only while something is actually happening, and a plain-text
fallback the moment the output stops being a terminal.

Every rule below is enforceable and testable. Follow them exactly rather than
approximating the vibe.

---

## 1. The two laws

**Subtle by default.** Colour marks meaning -- a failure, a value the user will act on
-- and nothing else. Labels, units, paths, and chrome are dim; values are plain. A full
screen of output should read as mostly grey with a handful of accents, never as a
colour test page. If you cannot say what a colour *means*, remove it.

**Plain when not a terminal.** Pipe the program anywhere and every escape sequence
disappears, glyphs fall back to bracketed ASCII, rules vanish, and the spinner goes
silent. Output stays greppable; a script parsing it never sees a byte of styling.

Three consequences that people get wrong:

- Colour detection and terminal detection are **different questions**. `FORCE_COLOR`
  should add colour to piped output, but carriage-return redraws still make no sense
  there. Gate colour on `color_enabled()`, gate animation on `is_tty()`.
- **Only colour is a colour question.** Glyph shape, rules, and the spinner are terminal
  questions -- they gate on `is_tty()`. Conflating the two is the single most common bug
  in this module: `NO_COLOR=1` in a real terminal then degrades `✓` to `[OK]`, and
  `FORCE_COLOR=1 | cat` draws a horizontal rule into a pipe. `--no-color` on a terminal
  must keep `✓` and keep the rule, and just drop the escapes.
- `--json` output is data. Turn colour off for it globally, never decorate it.

---

## 2. One voice module

All user-facing output goes through a single presentation module (`ui.py`, `ui.go`,
`ui.ts` -- one file). Logic modules never call `print`. They raise typed errors and
return data; the CLI layer decides how it looks.

```
cli.py        argument parsing, flag wiring, orchestration, the exit-code map
ui.py         colours, glyphs, line shapes, listings, prompts, spinner, run()
everything    pure functions and typed exceptions -- zero output calls
else
```

The payoff is real: the whole program has one voice, `--no-color` is one switch, and
the logic is testable without capturing stdout. Grep your logic modules for `print` --
a hit is a bug.

---

## 3. Palette

256-colour codes, deliberately narrow: one accent, four semantics, two greys. Do not
add a colour without deleting one.

| Role     | Code  | Meaning                                                   |
|----------|-------|-----------------------------------------------------------|
| accent   | `208` | amber -- the program's own voice: prompts, commands to copy, selected row, values worth acting on |
| ok       | `71`  | muted green -- something passed or was created            |
| err      | `167` | muted red -- a failure                                    |
| warn     | `179` | muted amber-yellow -- worth knowing, not a failure        |
| info     | `110` | muted blue -- neutral narration                           |
| dim      | `245` | labels, units, secondary text, anything the eye skips     |
| faint    | `240` | chrome: rules, separators, the least important thing      |

Muted variants, not the terminal's default bright ANSI 1-7. Bright green on a
successful check is shouting.

Emit as `\033[38;5;<code>m ... \033[0m`, with `\033[1m` prepended for bold. Bold with no
colour (`strong`) is the right emphasis inside an otherwise plain block -- section
titles use it, so they survive `NO_COLOR` intact.

**Never use emoji** in CLI output or error messages. Glyphs below carry the semantics.

---

## 4. Glyphs

| Role | TTY | Piped    | Colour |
|------|-----|----------|--------|
| ok   | `✓` | `[OK]`   | ok     |
| err  | `✗` | `[FAIL]` | err    |
| warn | `!` | `[WARN]` | warn   |
| info | `·` | `[INFO]` | info   |
| step | `›` | `>`      | accent |

The ASCII fallback is bracketed on purpose: `[OK] credentials` is greppable,
`✓ credentials` is not reliably so.

The two columns are independent. **Shape follows the terminal, colour follows the
palette** -- `glyph()` picks `✓` vs `[OK]` on `is_tty()` and paints it on
`color_enabled()`. So `--no-color` in a terminal gives a plain `✓`, and
`FORCE_COLOR=1 | cat` gives a coloured `[OK]`. Both are correct.

---

## 5. Line grammar

Exactly seven shapes. Compose screens out of these; do not invent an eighth without a
reason you can state.

**Status line** -- `<glyph> <message>[  <dim detail>]`

```
✓ credentials       mode 0o600
✗ connections       gmail is INITIATED
! npx not found on PATH   Node.js is required for `skills` -- https://nodejs.org
```

The optional `width` argument pads *the message only*, so a batch of checks aligns
their details into a column. Compute the width once from the whole batch
(`max(len(name) for name in checks)`) -- never format a row in isolation, or the
columns jitter.

**Heading** -- one blank line above, bold text, no box, no banner, no rule underneath.

```

tools selected (3)
```

Counts belong in the heading, parenthesised and **dim while the title stays bold** --
`heading("workflows", 7)`, not `heading("workflows (7)")`. Pass the count as an argument
so it can be dimmed separately; interpolating it into the title bolds it too.

**Rule** -- `─` repeated to `min(terminal_width, 80)`, faint. Skipped entirely when not
a terminal -- a terminal question, so `FORCE_COLOR` does not resurrect it in a pipe. Use
it for full-screen TUI chrome; almost never in linear output.

**Key/value** -- two-space indent, dim `label:` (padded to a shared width), plain value.
The label is dim so the value reads first.

```
  harness:  claude -p
  store:    /Users/x/.px0
```

**Bullet** -- two-space indent, faint `·`, then text.

**Hint** -- a blank line, then dim text at column 0, describing what to do next. Always
the last thing in a block.

**Command** -- two-space indent, accent colour, nothing else on the line. This is the
one thing on screen the user is expected to copy, so it gets the accent and stands
alone.

```

try next:
  px0 doctor
  px0 new "describe what you want"
```

`hint` + `command` is the standard closing couplet for any command that finishes
successfully. Every terminal state should answer "and now what?".

---

## 6. Spinner

The single animation. Everything about it is deliberate.

- Frames: `⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏`, cycled at **0.08s**. Braille, because it occupies one cell and
  does not jitter the line width.
- Rendered as `\r<accent frame> <message><dim timer>` -- carriage return, no newline.
- **The elapsed timer is held back for the first second.** `(0s)` reads as broken. After
  1s show ` (3s)`, dim, integer seconds.
- Always writes to **stderr**, so a spinner never lands in output the user is capturing.
- **A no-op unless stderr is a terminal.** Piped, it prints exactly one plain line --
  its own message followed by `...` (`Verifying key...`) -- at the start and nothing
  else, so logs stay readable. In quiet mode (`--quiet`, `--json`) it prints nothing at
  all.
- **Truncated to the terminal width**, with `…` when it does not fit. A line that wraps
  cannot be erased: `\r` returns to the start of the *last* row, so the first row's text
  stays on screen forever. Recompute the width every frame -- terminals get resized
  mid-run.
- Runs on a daemon thread; joins with a timeout on stop.
- On stop it **erases its own line** (`\r` + spaces to terminal width + `\r`) before
  anything else prints. On an exception it erases *before the exception propagates*, so
  a traceback never lands on top of a half-drawn spinner.
- `stop(final)` optionally replaces the line with a status line, appending `(1.4s)` as
  the dim detail when the operation took a second or more.

Use it as a context manager so the erase is unconditional:

```python
with ui.spinner("Verifying Composio API key"):
    setup_composio(home, key)
ui.ok("Composio API key stored")
```

**Message style.** Spinner labels are capitalised present participles naming the work,
with a count when there is one:

```
Checking the request for gaps
Searching Composio's catalogue (3 queries)
Choosing from 40 candidates
Writing the workflow plan
```

Resolved status lines are lowercase and past tense: `✓ reindexed  412 passages`. The
contrast between the two is what makes a long flow legible -- capitalised means "in
flight", lowercase means "settled".

**Never nest spinners.** One at a time; update the message instead
(`sp.update("Now doing the next thing")`).

---

## 7. Progress narration

A multi-step flow is a sequence of spinner-then-result, with headings between phases.
The screen grows downward and never redraws what has scrolled past. This is what makes
it feel like Claude Code: the transcript of what happened stays on screen, and only the
live line animates.

```
⠹ Checking the request for gaps (2s)          <- transient, erased
✓ the request is clear   nothing to clarify   <- permanent

  · github: list pull requests
  · slack: send message

⠼ Searching Composio's catalogue (2 queries) (4s)

tools selected (3)
  1.  read         github.pulls.list      List pull requests for a repository
  2.  write        slack.messages.send    Post a message to a channel
! this workflow could change things outside px0   slack.messages.send

Enter accepts all; list numbers to drop (e.g. 2,3); n aborts
› keep all?
```

Rules:

- One spinner per unit of work the user would name. Not per HTTP call.
- Resolve every spinner with a status line or a heading -- never let one vanish silently.
- A skipped step still prints: `✓ no external service needed   this runs on its input alone`.
- Report the shape of what came back (`3 queries`, `40 candidates`), not raw dumps.

---

## 8. Prompts and interaction

Prompt prefix is the `step` glyph -- accent `›` in a terminal, `>` when piped --
followed by the question. Returns the input stripped.

```
› workflow id [new-workflow]:
```

**Defaults are shown dim in square brackets** and Enter takes them.

**Yes/no** capitalises the default: `[Y/n]` when Enter means yes, `[y/N]` when Enter
means no. Accept `y`/`yes`/`n`/`no`, case-insensitive, and re-ask on anything else --
never read garbage as a no. Anything destructive or outward-facing defaults to no.

**Secrets** echo masked with an explicit keep affordance:

```
› Composio API key [sk-1...9fa2, Enter to keep]:
```

Mask as `first4...last4`, or all asterisks when the value is 8 characters or shorter.
The *stored* value is what echoes masked; what the user types does not echo at all
(`getpass`), so it never lands in a screen recording or a scrollback buffer.

**Numbered menus** accent the number so a follow-up answer can refer to it:

```
harnesses
  1. claude     claude -p          installed
  2. gemini     gemini -p          not on PATH
  3. custom command

› pick [1-3]:
```

**Multi-select by exception.** When the program has already chosen well, do not make
the user re-pick. Show the choice, let Enter accept all of it, and take numbers to
*drop*: `Enter accepts all; list numbers to drop (e.g. 2,3); n aborts`. Parse digits out
of whatever they type. If they drop everything, that is an error, not an empty run.

**Multi-line entry** is terminated by a blank line, and you say so first:
`type the replacement body; a blank line finishes`.

**Cancelling is not an error.** `ui.info("cancelled")` and exit 0. Model it as a typed
`Cancelled` exception the top-level handler turns into that line, so a prompt buried
four calls deep can decline without threading a sentinel back up.

**Confirmation gates.** Anything that writes outside the program's own store, grants
write access, or costs money gets an explicit confirmation *after* a warning naming
exactly what is at stake:

```
! this workflow could change things outside px0   slack.messages.send
```

Route those warnings to **stdout** when they are part of an interactive review the user
is reading top-to-bottom, even though `warn` defaults to stderr -- otherwise they
interleave wrongly against the prompt.

**`--yes` skips every prompt.** Open-ended prompts take their default; **confirmations
answer yes.** Those are two different rules and the distinction matters: `--yes` exists
to unblock CI and cron, so if a destructive gate defaulted to no and `--yes` "took the
default", the flag would abort exactly the runs it was added to enable. A gate too
dangerous to pass under `--yes` needs its own flag (`--force`), not a default of no.

Implement `--yes` inside the prompt helpers, not at the call sites. One
`ui.set_yes(True)` at startup then covers every flow, including the ones added later.
Every interactive flow must have this path, and it must be tested with stdin closed.

---

## 9. Streams, buffering, exit codes

- **stdout** is the program's output -- the answer, the JSON, the generated text. Anything
  a pipe consumer wants.
- **stderr** is narration -- spinners, errors, warnings, progress. `err` and `warn`
  default there.
- Ambiguous case: a run summary like `✓ summarize success  run-1a2b` is narration. Send
  it to stderr and let the actual output own stdout.
- **Line-buffer stdout at startup** (`sys.stdout.reconfigure(line_buffering=True)`).
  Without it, stdout is block-buffered when piped while stderr is not, and the two
  interleave out of order. This is a one-line fix for a bug that looks like chaos.
- Flush every print.

Exit codes are a stable API. Give each failure category its own:

```
0  success (including a user-cancelled prompt)
1  user error -- bad input, missing store, failed precondition
2  connector / external service error
3  model or backend error
4  integrity error -- checks failed
130 interrupted
```

Map exceptions to codes in one place, at the top-level `main`, not scattered through
handlers -- `sys.exit(ui.run(main, {StoreMissing: 1, ConnectorError: 2}))`. That wrapper
owns Ctrl-C, `Cancelled`, and EOF-on-a-prompt as well, so those three never need a
handler anywhere else.

**An unmapped exception should still traceback.** It means a bug in your code, not a
condition the user can fix, and a swallowed stack trace costs you the only evidence you
had. Catch categories you named; let the rest through.

---

## 10. Failure modes to handle explicitly

**Ctrl-C.** Catch `KeyboardInterrupt` at the top level, print a newline to stderr (the
spinner has already cleared its own line), then `! interrupted`. Never a traceback.

**EOF on a prompt.** Piped stdin, CI, cron, `curl | sh`. This is the most-missed case in
the whole document, because every prompt helper is one `input()` call that raises
`EOFError` by default -- and an `EOFError` traceback is the exact failure this section
exists to prevent. **Catch it inside the prompt helper**, not at the call sites, and
convert it to a typed `NoInput`. Then there are two correct responses:

- If the command can still finish usefully, warn and continue:
  `! no terminal to prompt on; skipping Composio setup` + hint + command to do it later.
  A prompt with a default does this for free -- it takes the default on EOF.
- If it cannot, fail with the fix:
  `✗ this command needs an answer and stdin is exhausted` /
  `run it interactively, or pass --yes to accept the defaults`.

**Every error message names the fix.** The message is what went wrong; the dim detail is
the specifics; the hint and command are what to do. Three lines, no traceback.

```
✗ no px0 store at /Users/x/.px0
create one with:
  px0 init
```

**Never abort over something recoverable.** A pending OAuth consent should not throw away
four model passes of work -- finish, record what is pending, and tell the user what
completes it.

---

## 11. Tables and listings

Two-space indent, two-space column separators, `ljust` to widths computed over the whole
batch. No box-drawing, no borders, no headers unless there are more than three columns.

```
  read   github.pulls.list      List pull requests for a repository   ready
  write  slack.messages.send    Post a message to a channel           not authorized
```

One column may carry colour -- pick the one that changes behaviour (write access,
authorization state, outcome). Descriptions are dim. Ids are plain.

**Share the row formatter between the plain listing and any TUI** that shows the same
records, so both render identically and stay in sync. That means `row()` returns a
*string* and does not print -- the listing prints it, the TUI hands it to `addstr`. Give
it an explicit `stream`: colour depends on where the text is going, and a formatter that
silently asks about `sys.stdout` will emit plain text into a coloured destination.

Close a listing with a hint that summarises the risk or the gap:

```

3 of 12 tools can change things outside px0
```

Diffs get pager colours: `+` in ok, `-` in err, `@@` dim, `+++`/`---` bold.
Log timestamps get faint-ed so the message reads first.

---

## 12. Full-screen TUI (curses)

When a listing needs filtering and drill-down, go full-screen -- but keep the same
palette, so the TUI and the plain commands read as one program. Initialise colour pairs
with the same 256-colour codes and `use_default_colors()` so the terminal's own
background shows through. Fall back to `A_DIM`/`A_BOLD` when the terminal has no colour.

Layout:

```
 px0 runs · 12 of 47                     <- row 0: accent bold title, count after a dim ·
 outcome=failed  writes only             <- row 1: dim active-filter summary, or "no filters"
─────────────────────────────────────    <- row 2: faint rule
                                          
 › run-1a2b  summarize  manual  failed   <- rows: accent pointer + row text
   run-3c4d  digest     cron    success
                                          
─────────────────────────────────────    <- height-2: faint rule
 ↑↓ move  enter detail  / workflow  q quit  <- height-1: accent key, dim label
```

Rules:

- **The selection is a pointer (`›`), not a highlight bar.** Less flicker, and the row's
  own semantic colour (failures red, in-flight dim) stays readable.
- Key hints live on the last row: accent the key, dim the label, two spaces between
  pairs, truncate rather than wrap.
- Accept both arrows and `j`/`k`. `q` and `esc` both leave.
- Empty state is a dim sentence in the list area: `no runs match these filters`.
- Filters are single keystrokes that cycle or prompt; show the active set in the header
  and give one key (`c`) to clear everything.
- **Suspend curses for anything that writes to the real terminal** (a pager, a rerun, a
  provenance dump): `endwin()`, run it, print `Press any key to resume...`, read a key,
  `initscr().refresh()`. Do this in a context manager with a `finally`, so an exception
  in a keystroke handler can never leave the terminal in raw mode with no cursor.
- Swallow and display errors from keystroke handlers -- a failed pager returns you to the
  list, it does not tear the TUI down.
- Hide the cursor (`curs_set(0)`); show it only while a prompt is accepting text.
- Clamp every `addstr` to the window width and wrap it in a `try/except curses.error`;
  writing to the last cell of the last line raises.

---

## 13. Global flags every CLI gets

| Flag | Effect |
|------|--------|
| `--no-color` | force colour off, overriding detection. Glyphs stay Unicode, rules stay drawn -- only the escapes go |
| `--json` | machine-readable output on stdout, colour forced off, spinners quiet |
| `--quiet` | suppress narration, keep the actual output. Errors and warnings still print -- a silent failure is worse than a noisy one |
| `--yes` | defaults for prompts, yes for confirmations, never block |

Environment, honoured in this order: forced setting (`--no-color`) > `NO_COLOR` >
`FORCE_COLOR` > `TERM=dumb` (disables) > `isatty()`.

Get the two variables' semantics exactly right, because both are widely mis-implemented:

- **`NO_COLOR` disables when it is present *and non-empty*** -- that is what
  no-color.org specifies, and the empty case is the whole point of the wording. Users set
  `NO_COLOR=` to *undo* an inherited `NO_COLOR=1` for one command. Testing
  `is not None` breaks that escape hatch and there is no other way out of it.
- **`FORCE_COLOR=0` and `FORCE_COLOR=false` disable colour**, even on a terminal; any
  other value (including empty) enables it, even in a pipe. This is the Node/chalk
  convention the variable comes from, and `FORCE_COLOR=0` is how CI systems ask for
  clean logs. Treating any value as "on" turns that request into its opposite.

Wrap `isatty()` in `try/except (AttributeError, ValueError)` -- it raises on a closed
stream, and detection must absorb that rather than crash the program.

A root-level flag must survive subcommand parsing: `prog --json cmd` and
`prog cmd --json` must both work. If each subparser declares its own `--json`, the
subparser's default resets the root value. Test this.

---

## 14. Reference implementation

Copy this, adjust names, delete nothing. It is ~400 lines, it has no dependencies,
and it is the whole style -- palette, glyphs, the seven line shapes, the listing
formatter, every prompt in section 8, the spinner, and the exit-code mapper. Section
15 is its test suite.

```python
"""Terminal presentation: colours, glyphs, prompts, listings, and the spinner.

Python 3.10+ (PEP 604 unions). No dependencies.
"""

import getpass, itertools, os, re, shutil, sys, threading, time
from contextlib import contextmanager

_ACCENT, _OK, _ERR, _WARN, _INFO, _DIM, _FAINT = "208", "71", "167", "179", "110", "245", "240"
_forced: bool | None = None
_quiet = False
_assume_yes = False


class Cancelled(Exception):
    """The user declined. Not an error -- exit 0."""


class NoInput(Exception):
    """stdin is exhausted and the question has no safe default."""


def init() -> None:
    """Line-buffer stdout so it interleaves in order with unbuffered stderr."""
    try:
        sys.stdout.reconfigure(line_buffering=True)
    except (AttributeError, ValueError):
        pass


def set_color(enabled: bool | None) -> None:
    global _forced
    _forced = enabled


def set_quiet(enabled: bool) -> None:
    """--quiet: suppress narration. Errors and warnings still print."""
    global _quiet
    _quiet = enabled


def set_yes(enabled: bool) -> None:
    """--yes: never block on a prompt."""
    global _assume_yes
    _assume_yes = enabled


# --- detection: colour and terminal are different questions ------------------

def is_tty(stream=None) -> bool:
    """True when `stream` is a real terminal, regardless of colour settings."""
    stream = stream or sys.stdout
    try:
        return bool(stream.isatty())
    except (AttributeError, ValueError):
        return False


def color_enabled(stream=None) -> bool:
    if _forced is not None:
        return _forced
    if os.environ.get("NO_COLOR"):            # present and non-empty -- the spec
        return False
    force = os.environ.get("FORCE_COLOR")
    if force is not None:                     # 0/false disable, anything else enables
        return force not in ("0", "false")
    if os.environ.get("TERM") == "dumb":
        return False
    return is_tty(stream)


def paint(text: str, code: str, *, bold: bool = False, stream=None) -> str:
    if not text or not color_enabled(stream):
        return text
    prefix = "\033[1m" if bold else ""
    return f"{prefix}\033[38;5;{code}m{text}\033[0m"


def dim(t, **kw):    return paint(t, _DIM, **kw)
def faint(t, **kw):  return paint(t, _FAINT, **kw)
def accent(t, **kw): return paint(t, _ACCENT, **kw)
def strong(t, **kw):
    return f"\033[1m{t}\033[0m" if color_enabled(kw.get("stream")) else t


# --- lines ------------------------------------------------------------------

_GLYPHS = {"ok": ("✓", "[OK]", _OK), "err": ("✗", "[FAIL]", _ERR),
           "warn": ("!", "[WARN]", _WARN), "info": ("·", "[INFO]", _INFO),
           "step": ("›", ">", _ACCENT)}


def glyph(role, stream=None):
    """Shape follows the terminal; colour follows the palette. Two questions."""
    mark, fallback, code = _GLYPHS[role]
    return paint(mark if is_tty(stream) else fallback, code, stream=stream)


def _status(role, message, detail="", *, width=0, stream=None):
    stream = stream or sys.stdout
    line = f"{glyph(role, stream)} {message.ljust(width) if width else message}"
    if detail:
        line += f"  {dim(detail, stream=stream)}"
    print(line, file=stream, flush=True)


def ok(m, d="", **kw):
    if not _quiet: _status("ok", m, d, **kw)
def info(m, d="", **kw):
    if not _quiet: _status("info", m, d, **kw)
def step(m, d="", **kw):
    if not _quiet: _status("step", m, d, **kw)
def err(m, d="", **kw):  kw.setdefault("stream", sys.stderr); _status("err", m, d, **kw)
def warn(m, d="", **kw): kw.setdefault("stream", sys.stderr); _status("warn", m, d, **kw)


def heading(text, count=None, *, stream=None):
    """Bold title, blank line above. The count is dim and parenthesised."""
    stream = stream or sys.stdout
    if _quiet:
        return
    line = strong(text, stream=stream)
    if count is not None:
        line += f" {dim(f'({count})', stream=stream)}"
    print(file=stream)
    print(line, file=stream, flush=True)


def rule(stream=None):
    stream = stream or sys.stdout
    if _quiet or not is_tty(stream):          # a terminal question, not a colour one
        return
    width = min(shutil.get_terminal_size((80, 24)).columns, 80)
    print(faint("─" * width, stream=stream), file=stream, flush=True)


def kv(label, value, *, width=0, stream=None):
    stream = stream or sys.stdout
    if _quiet:
        return
    text = f"{label}:".ljust(width) if width else f"{label}:"
    print(f"  {dim(text, stream=stream)} {value}", file=stream, flush=True)


def bullet(text, stream=None):
    stream = stream or sys.stdout
    if _quiet:
        return
    print(f"  {faint('·', stream=stream)} {text}", file=stream, flush=True)


def hint(text, stream=None):
    stream = stream or sys.stdout
    if _quiet:
        return
    print(file=stream)
    print(dim(text, stream=stream), file=stream, flush=True)


def command(text, stream=None):
    stream = stream or sys.stdout
    if _quiet:
        return
    print(f"  {accent(text, stream=stream)}", file=stream, flush=True)


# --- listings: one formatter, shared with the TUI ---------------------------

def widths(rows) -> list[int]:
    """Column widths over the whole batch -- never format a row in isolation."""
    return [max(len(str(c)) for c in col) for col in zip(*rows)] if rows else []


def row(cells, widths, *, color=None, dims=(), stream=None) -> str:
    """One listing row as a string, so the plain listing and the TUI stay in sync.

    `color` is (index, fn) for the single column that carries colour, where fn(cell)
    returns a palette code or None. `dims` are the indices to dim.
    """
    out = []
    last = len(cells) - 1
    for i, cell in enumerate(cells):
        text = str(cell)
        if i != last and i < len(widths):
            text = text.ljust(widths[i])
        if color and i == color[0]:
            code = color[1](str(cell))
            text = paint(text, code, stream=stream) if code else text
        elif i in dims:
            text = dim(text, stream=stream)
        out.append(text)
    return "  " + "  ".join(out)


def table(rows, *, color=None, dims=(), stream=None):
    stream = stream or sys.stdout
    w = widths(rows)
    for cells in rows:
        print(row(cells, w, color=color, dims=dims, stream=stream), file=stream, flush=True)


# --- prompts ----------------------------------------------------------------

def prompt(text, default="") -> str:
    """Ask a question. Returns the answer stripped, or `default` on Enter.

    Never raises EOFError: with a default it takes it, without one it raises NoInput.
    """
    if _assume_yes:
        return default
    suffix = f" {dim(f'[{default}]')}" if default else ""
    try:
        answer = input(f"{glyph('step')} {text}{suffix}: ").strip()
    except EOFError:
        print(file=sys.stderr)
        if default:
            return default
        raise NoInput(text) from None
    return answer or default


def confirm(question, *, default=False) -> bool:
    """Yes/no. Anything destructive or outward-facing passes default=False.

    `--yes` answers yes -- it exists to unblock automation. A gate too dangerous for
    `--yes` needs its own explicit flag, not a default of no.
    """
    if _assume_yes:
        return True
    marks = "[Y/n]" if default else "[y/N]"
    while True:
        try:
            answer = input(f"{glyph('step')} {question} {dim(marks)} ").strip().lower()
        except EOFError:
            print(file=sys.stderr)
            raise NoInput(question) from None
        if not answer:
            return default
        if answer in ("y", "yes"):
            return True
        if answer in ("n", "no"):
            return False
        warn("answer y or n")


def mask(value: str) -> str:
    if not value:
        return ""
    return "*" * len(value) if len(value) <= 8 else f"{value[:4]}...{value[-4:]}"


def secret(label, current="") -> str:
    """Prompt for a secret. The existing value echoes masked, with a keep affordance."""
    if _assume_yes:
        return current
    suffix = f" {dim(f'[{mask(current)}, Enter to keep]')}" if current else ""
    try:
        answer = getpass.getpass(f"{glyph('step')} {label}{suffix}: ").strip()
    except EOFError:
        print(file=sys.stderr)
        if current:
            return current
        raise NoInput(label) from None
    return answer or current


def menu(title, rows, *, default=1) -> int:
    """Numbered menu over (label, detail) rows. Returns the 1-based choice."""
    heading(title)
    w = max((len(label) for label, _ in rows), default=0)
    for i, (label, detail) in enumerate(rows, 1):
        line = f"  {accent(f'{i}.')} {label.ljust(w)}"
        if detail:
            line += f"  {dim(detail)}"
        print(line, flush=True)
    while True:
        answer = prompt(f"pick [1-{len(rows)}]", str(default))
        if answer.isdigit() and 1 <= int(answer) <= len(rows):
            return int(answer)
        warn(f"pick a number between 1 and {len(rows)}")


def keep_all_but(count, *, noun="items") -> list[int]:
    """Multi-select by exception. Enter keeps all, digits drop rows, n aborts.

    Returns the 1-based indices to keep. Raises Cancelled on abort or an empty result.
    """
    hint("Enter accepts all; list numbers to drop (e.g. 2,3); n aborts")
    answer = prompt("keep all?")
    if answer.lower() in ("n", "no"):
        raise Cancelled("cancelled")
    dropped = {int(d) for d in re.findall(r"\d+", answer)}
    kept = [i for i in range(1, count + 1) if i not in dropped]
    if not kept:
        raise Cancelled(f"all {count} {noun} were dropped -- nothing left to run")
    return kept


# --- spinner ----------------------------------------------------------------

_FRAMES, _INTERVAL = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏", 0.08


class Spinner:
    def __init__(self, message, *, quiet=None, stream=None):
        self.message, self.stream = message, stream or sys.stderr
        self.quiet = _quiet if quiet is None else quiet
        self.animated = not self.quiet and is_tty(self.stream)   # a TTY, not colour
        self._stop = threading.Event()
        self._thread, self._started = None, 0.0

    def _spin(self):
        for frame in itertools.cycle(_FRAMES):
            if self._stop.is_set():
                return
            elapsed = time.monotonic() - self._started
            timer = f" ({elapsed:.0f}s)" if elapsed >= 1 else ""
            # Truncate: a wrapped line cannot be erased with one \r.
            room = max(8, shutil.get_terminal_size((80, 24)).columns - len(timer) - 3)
            message = self.message
            if len(message) > room:
                message = message[:room - 1] + "…"
            self.stream.write(f"\r{accent(frame, stream=self.stream)} {message}"
                              f"{dim(timer, stream=self.stream)}")
            self.stream.flush()
            self._stop.wait(_INTERVAL)

    def start(self):
        self._started = time.monotonic()
        if self.animated:
            self._thread = threading.Thread(target=self._spin, daemon=True)
            self._thread.start()
        elif not self.quiet:
            print(f"{self.message}...", file=self.stream, flush=True)
        return self

    def _erase(self):
        if not self.animated:
            return
        width = shutil.get_terminal_size((80, 24)).columns
        self.stream.write("\r" + " " * (width - 1) + "\r")
        self.stream.flush()

    def stop(self, final=None, role="ok"):
        self._stop.set()
        if self._thread is not None:
            self._thread.join(timeout=1.0)
        self._erase()
        if final and not self.quiet:
            elapsed = time.monotonic() - self._started
            _status(role, final, f"({elapsed:.1f}s)" if elapsed >= 1.0 else "",
                    stream=self.stream)

    def update(self, message):
        if self.animated:
            self._erase()
        self.message = message


@contextmanager
def spinner(message, *, done=None, quiet=None, stream=None):
    sp = Spinner(message, quiet=quiet, stream=stream).start()
    try:
        yield sp
    except BaseException:
        sp.stop()      # erase before the traceback lands
        raise
    else:
        sp.stop(done)


# --- exit codes: mapped in one place ----------------------------------------

def run(main, codes=None) -> int:
    """Wrap the top-level entry point. `codes` maps exception types to exit codes.

    Usage: sys.exit(ui.run(main, {StoreMissing: 1, ConnectorError: 2}))
    """
    try:
        return main() or 0
    except KeyboardInterrupt:
        print(file=sys.stderr)          # the spinner cleared its own line already
        warn("interrupted")
        return 130
    except Cancelled as e:
        info(str(e) or "cancelled")
        return 0
    except NoInput as e:
        err("this command needs an answer and stdin is exhausted", str(e))
        hint("run it interactively, or pass --yes to accept the defaults")
        return 1
    except Exception as e:
        for kind, code in (codes or {}).items():
            if isinstance(e, kind):
                err(str(e))
                return code
        raise                            # unmapped means a bug: let it traceback
```

**Porting.** Go: `fatih/color` or raw SGR strings, `golang.org/x/term.IsTerminal`,
`bubbletea` only for the full-screen view. Node: raw escape strings or `picocolors`,
`process.stdout.isTTY`, no `ora`/`chalk` stacks -- the whole spinner is 30 lines.
Rust: `anstyle` + a hand-rolled spinner. Do not pull in a heavyweight TUI framework for
linear output.

---

## 15. Tests to write

These are the invariants that keep the style from rotting. Write them alongside the
module; all 45 run in under a second with no terminal, using a `StringIO` subclass whose
`isatty()` you control.

**Detection**

- Piped output contains no `\x1b` and uses `[OK]` / `[FAIL]`.
- TTY output contains `\x1b[38;5;` and `✓`, and never `[OK]`.
- `NO_COLOR=1` disables colour; **`NO_COLOR=""` does not** (present *and non-empty*).
- `FORCE_COLOR=1` colours a pipe, leaves `is_tty()` false, keeps glyphs bracketed, and
  leaves the spinner inert.
- `FORCE_COLOR=0` disables colour even on a TTY.
- `TERM=dumb` disables colour on a TTY.
- `--no-color` on a TTY drops every escape but keeps `✓` and still draws the rule.
- `isatty()` on a closed stream does not raise.

**Lines and listings**

- `width` pads the message only: two status lines with the same width start their
  details at the same column.
- `kv` dims the label and leaves the value unstyled.
- `heading` bolds the title and dims the count separately.
- `err`/`warn` go to stderr, `ok` goes to stdout.
- `row()` with shared widths aligns every column across a batch.
- `table()` colours exactly one column, honouring the target stream.

**Prompts**

- A prompt on exhausted stdin raises the typed `NoInput`, never `EOFError`.
- A prompt with a default takes it on both EOF and Enter.
- `confirm` takes the capitalised default on Enter, accepts `YES`/`No` case-insensitively,
  re-asks on garbage, and raises `NoInput` on EOF.
- `mask` gives all asterisks at 8 characters or fewer, `first4...last4` above that.
- Multi-select by exception: Enter keeps all, `2,3` drops those two, `n` raises
  `Cancelled`, and dropping every row raises rather than returning an empty list.
- With `--yes` set, every prompt and confirmation returns **without reading stdin at
  all** -- assert this with stdin closed, or the test passes for the wrong reason.
- With `--quiet` set, narration writes nothing and errors still write.

**Spinner**

- On a pipe it writes exactly one line, `<message>...\n`, and no `\r`.
- In quiet mode it writes nothing.
- On a TTY it writes `\r`, at least one frame character, and ends with the `done` text.
- No rendered line exceeds the terminal width (set `COLUMNS` narrow and assert on the
  escape-stripped length).
- It erases before an exception propagates (last write ends in `\r`).
- The thread is dead when the block exits.
- `(0s)` never appears.
- `rule()` writes nothing when not a terminal, *even with* `FORCE_COLOR=1`.

**Exit codes**

- Success is 0; a mapped exception returns its own code with no traceback.
- Ctrl-C is 130 and prints one `! interrupted`.
- `Cancelled` is 0, `NoInput` is 1 with a hint naming `--yes`.
- An unmapped exception still tracebacks.
- `prog --json cmd` and `prog cmd --json` both parse to `json=True`.

---

## 16. Anti-patterns

| Do not | Because |
|--------|---------|
| Emoji anywhere in output | The glyph set carries the semantics; emoji break alignment and read as unserious |
| Boxes, banners, ASCII-art headers, `Panel.fit` | Chrome without information; a bold line does the same job |
| Bright default ANSI colours | Shouting; use the muted 256-colour codes |
| Progress bars for unknown-duration work | A spinner with an elapsed counter is honest; a fake bar is not |
| Nested or concurrent spinners | Two carriage returns fighting over one line |
| Spinners on stdout | They land in the user's captured output |
| Printing from logic modules | Breaks the single voice and makes the logic untestable |
| Colour on a value with no meaning attached | Turns the screen into a colour test page |
| A traceback as an error message | Say what broke and what fixes it |
| `print("Done!")` with no next step | Every terminal state answers "and now what?" |
| Re-drawing scrolled output | Only the live line animates; the transcript is permanent |
| A prompt with no `--yes` path | Breaks CI, cron, and `curl \| sh` |
| Silent truncation of a list | Say `showing 20 of 143` |
| Gating glyph shape or the rule on `color_enabled()` | Those are terminal questions; `--no-color` should not turn `✓` into `[OK]` |
| `NO_COLOR is not None`, or `FORCE_COLOR=0` meaning on | Breaks the two escape hatches users actually reach for |
| Bare `input()` in a prompt helper | Raises `EOFError` in CI -- the traceback this whole document forbids |
| `--yes` answering no to a destructive confirm | Aborts exactly the automated runs the flag was added to unblock |
| Handling Ctrl-C or EOF at each call site | It belongs once, in the top-level wrapper |
| Catching every exception to avoid a traceback | Unmapped means a bug; swallowing it destroys the only evidence |
| A spinner message longer than the terminal | It wraps, and a wrapped line can never be erased |
| A row formatter that prints, or that reads `sys.stdout` | The TUI cannot reuse it, and colour follows the wrong stream |

---

## 17. Checklist before shipping a command

1. Does every long operation have a spinner, and does every spinner resolve into a
   status line?
2. Does the command end with a hint and a copyable command?
3. Piped through `cat`: no escapes, no `\r`, ASCII glyphs, parseable?
4. Under `--json`: pure data on stdout, nothing else?
5. Under `--yes`: no prompt blocks?
6. With stdin closed: a clear message, not an `EOFError` traceback?
7. Ctrl-C mid-run: one clean `! interrupted` line?
8. On failure: the right exit code, and a message naming the fix?
9. Are errors and warnings on stderr, and the actual output on stdout?
10. Does anything outward-facing or destructive get a named warning and an explicit
    confirmation first?
11. Under `--no-color` in a real terminal: escapes gone, but `✓` and the rules still
    there?
12. In a 40-column terminal: does the spinner line still erase cleanly?
13. Under `--quiet`: narration gone, errors still visible?
