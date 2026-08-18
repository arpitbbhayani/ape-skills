---
name: ape-plan-project
description: >
  Splits a product + engineering spec into phases, each a working vertical
  slice with its own agent-ready design doc. Use for "ape plan project",
  "plan this project", "phase this spec", or "split this into milestones for
  an agent to build".
---

# Phased Spec Decomposition

Take one product + engineering spec and turn it into an ordered sequence of
phases, each with its own standalone design document. The output is meant to
be handed to a coding agent one phase at a time -- every document must be
implementable on its own, with no unresolved questions.

**North star:** every phase document should leave zero design decisions for
the implementer. Not "an agent probably wouldn't need to ask a question" --
an agent literally cannot make a different reasonable choice than the one the
document specifies, because every choice is already made and written down.

## Input

Accept a PRD, an engineering design doc, a combined spec, or rough notes that
mix product intent with technical detail. If the input only covers product
intent, infer a reasonable engineering approach and mark it as an assumption.
If it only covers engineering, infer the product framing (who benefits, what
they can now do) for each phase.

## Verify Before Writing

If a codebase is available, read it before writing any engineering content.
Cite what exists today with `path:line`, not from memory or from what the
spec assumes. A phase document that describes "current state" without having
read the current state is a guess, not a spec. If no codebase exists yet
(greenfield), say so explicitly and proceed on the spec alone.

For each phase, note **what already exists** that the phase can reuse --
an existing service, table, endpoint, or library that solves part of the
problem. Never let a phase rebuild something the codebase already has.

## Tech Stack Choices

**Brownfield (existing codebase):** the stack is not a decision to make --
it's whatever Verify Before Writing found. Match the existing language,
framework, database, and libraries. Introducing a new one requires a stated
reason (the existing stack genuinely cannot do what this phase needs), never
preference or unfamiliarity with what's there.

**Greenfield (no codebase yet):** Phase 1's document must pin the full stack
once -- language, framework, database, hosting/deploy target, and any
non-trivial third-party library -- each with a one-line rationale. Every
later phase inherits this silently as a given; never re-open or re-litigate
the stack in a later phase's document.

**Default to boring.** Prefer established, widely-used technology over novel
tools unless the spec states a hard requirement only the novel choice
satisfies -- name that requirement explicitly when it justifies the
departure. A phased handoff is the wrong place to spend the project's
appetite for risk on tooling.

**A stack change mid-project is a decision, not a detail.** If a later phase
needs a new language, datastore, or framework the earlier phases didn't use,
call it out as its own explicit decision in that phase's document: the
reason, the alternative considered, and the migration cost to anything
already built in the old stack.

## Core Principle: Vertical Slices, Not Layers

Never phase by layer ("schema, then API, then UI" or "backend, then
frontend"). A layer-based phase produces nothing a user or downstream system
can exercise until every layer is done. Instead, cut vertically: each phase
touches every layer it needs -- however thinly -- and ends with something that
runs end to end and demonstrates real behavior.

Phase 1 is a walking skeleton: the thinnest possible path through the full
system for the single most important scenario, wired for real (real network
calls, real storage, real auth if auth gates the flow), not stubbed. Every
phase after that adds one more increment of capability on top of a system
that already works.

**Example -- a URL shortener spec.**

Bad (layer-based -- nothing works until phase 3):

- Phase 1: database schema for `urls` and `clicks`.
- Phase 2: REST API for create/redirect/stats.
- Phase 3: frontend page to create and view links.

Good (vertical slices -- each phase is a working product):

- Phase 1: paste a long URL into a form, get a short code back, visiting the
  short code redirects to the long URL. Real storage, no auth, no stats yet.
- Phase 2: short codes are scoped to a logged-in user's account (adds auth
  end to end: login, ownership check, per-user list view).
- Phase 3: click count and last-accessed time shown on each link (adds the
  `clicks` table, an increment-on-redirect write, and a stats row in the UI).

Every phase in the good version can be demoed to a user. None of the phases
in the bad version can.

## Sequencing Rules

1. **Phase 1 is a working skeleton.** It should touch every architectural
   component the final system needs, at minimal depth, for one real scenario.
2. **Each phase adds exactly one coherent capability.** If a phase description
   needs "and" to summarize it in one sentence, it is probably two phases.
3. **Order by dependency, not by convenience.** A phase may only depend on
   capabilities delivered in strictly earlier phases -- never on a phase that
   comes after it. When dependency order leaves a tie, do the riskiest or
   least-certain part first -- incremental and reversible beats big-bang;
   surface unknowns while there is still time to change course.
4. **Every phase ends in a working, demoable state.** Stopping after any
   phase should never leave the system half-built or non-functional.
5. **Fold plumbing into the phase that needs it.** Do not create a
   phase whose sole content is infrastructure, schema, or scaffolding with no
   observable behavior -- attach that work to the first phase that exercises it.
6. **Name cross-cutting concerns explicitly.** For auth, observability,
   validation, rate limiting, and error handling, state per phase whether a
   minimal version is enough or the full version is required, and call out
   which later phase upgrades it.
7. **Let complexity set the phase count.** Do not force a round number of
   phases. Count independent capabilities, integration points, and risk areas
   in the source spec, and let that count drive how many phases exist.
8. **Bound each phase's size.** A phase should be implementable in roughly
   1-3 focused agent sessions and land as one PR. If a phase touches more
   than ~8 files or introduces more than 2 new services/classes, treat that
   as a signal to split it further, not as a reason to write a longer doc.
9. **Don't design what already exists.** Before specifying a new pattern,
   queue, cache, or abstraction inside a phase, check whether the stack
   already has a built-in or established pattern for it. Reach for the
   existing tool before inventing a new one.

## Per-Phase Design Document

Every phase gets its own complete document. A reader with zero context on the
other phases must be able to implement this one from this document alone.

### Product Section

- **Phase goal** -- one sentence: what this phase unlocks that did not exist
  before.
- **User story / job-to-be-done** -- who benefits and what they can now do.
- **In scope** -- an exhaustive, explicit list of behavior this phase delivers.
- **Out of scope** -- what looks related but is explicitly deferred, and to
  which later phase.
- **Acceptance criteria** -- numbered, binary, testable statements with real
  numbers where relevant. "Returns 409 when the slug already exists" and
  "list endpoint responds in under 200ms for 10k rows" pass; "handles
  conflicts well" and "is performant" do not.
- **UX flow** -- for user-facing phases, describe the flow step by step
  (screens, states, transitions) even without visual mockups.

### Engineering Section

- **What already exists** -- code, services, or libraries this phase reuses
  rather than rebuilds (see Verify Before Writing).
- **Components touched** -- every service, module, or repo this phase creates
  or modifies.
- **Data model** -- schemas, fields, types, constraints, and migrations,
  written out in full (as a table or code block), not summarized.
- **API contracts** -- every endpoint or interface added or changed: method,
  path, request shape, response shape, status/error codes. Use a table or
  code block per endpoint.
- **Key flows** -- the sequence of operations for the happy path and for each
  major edge case (empty input, conflict, timeout, partial failure, retry).
- **Dependencies on prior phases** -- the exact interfaces this phase
  consumes from earlier phases; nothing implicit.
- **Non-functional requirements** -- only the ones this phase must actually
  satisfy (latency budget, concurrency, idempotency), stated as numbers or
  concrete rules, not adjectives.
- **File reference table** -- every file this phase touches, with the change,
  as a table (`path:line` when referencing existing logic):

  | File | Change |
  | --- | --- |
  | `path/to/file.ts:42` | Add null check before dispatch |

- **Failure modes** -- for each new or changed codepath, name one realistic
  way it fails in production (timeout, nil reference, race, stale data) and
  state whether a test covers it, whether error handling exists, and whether
  the failure is visible to the caller or silent. Flag any silent, untested,
  unhandled failure as a gap to close before the phase is done.
- **Test plan** -- as a table across the testing pyramid:

  | Layer | What | Count |
  | --- | --- | --- |
  | Unit | `service.method()` behavior | +N |
  | Integration | cross-component flow | +N |
  | E2E | user-visible journey | +N |

- **Rollout** -- feature flags, migration order, backward-compatibility
  requirements. If the phase touches data, infrastructure, or shared state,
  state the rollback plan explicitly -- even "revert the PR" counts, but say
  it.
- **Definition of done** -- a checklist that maps one-to-one to the
  acceptance criteria above.

## Resolving Ambiguity

The source spec will have gaps. Never write "TBD," "decide later," or "up to
implementer" -- a phase document with an open question is not ready to hand
off. But not every gap should be closed the same way; sort each one by
stakes before deciding how to close it.

**Low-stakes or reversible** (a default page size, a naming convention, a
field's exact wording, which existing utility to call) -- make the most
reasonable decision yourself, state it as an explicit assumption at the top
of the affected phase document, and move on. Don't stop to ask.

**High-stakes or hard-to-reverse** (tech stack, data model shape that other
phases build on, auth/security posture, a breaking API change, anything
touching money or irreversible data loss) -- do not silently assume. Stop
and ask the user before writing the affected phase document. A wrong silent
guess here doesn't cost one phase, it compounds through every phase built on
top of it. Name the decision, the options, and your recommendation in one
short question; don't bury it inside a long draft the user has to comb
through to find it.

Where a number is missing (a latency budget, a row count, a concurrency
limit) and cannot be derived or safely assumed, say so explicitly and state
how to measure it -- never leave it as a vague adjective.

## Output Structure

1. **Overview** -- one paragraph per phase (goal + what it unlocks), followed
   by an ASCII dependency diagram across phases plus a one-paragraph
   sequencing rationale explaining what would break if the order changed.
2. **Parallelization note** -- if two or more phases (or workstreams within a
   phase) touch disjoint modules and share no dependency, call this out as an
   opportunity to hand them to separate agents/worktrees in parallel; group
   into lanes (`Lane A: phase 2 -> phase 4 (sequential)`, `Lane B: phase 3
   (independent)`). If everything is strictly sequential, say so in one line
   instead of forcing a diagram.
3. **One fully expanded design document per phase**, in phase order, each
   self-contained per the template above.

### Where to Write Output

Default to printing the overview and all phase documents inline in the
response, separated by a horizontal rule (`---`), unless the user asks for
files on disk.

When the user asks for files (or the input itself was a file path), write
them next to the source spec:

- If the source spec lives at `some/dir/spec.md`, write to
  `some/dir/phases/phase-N-<slug>.md`.
- If there is no source file (spec was pasted or described), ask the user
  where to write, or default to `./phases/` in the current working directory.
- Always write an index file, `phases/README.md`, containing the Overview
  section (phase summaries, dependency diagram, parallelization note) with
  links to each `phase-N-<slug>.md` -- an agent or human should be able to
  open the index and navigate straight to the phase they're implementing.

Follow `ape-style-markdown` for headings, tables, and code block formatting
in the output.

## Handoff Readiness Checklist

Before returning the result, verify for every phase document:

- No "TBD," "later," or unresolved open question remains.
- Every high-stakes ambiguity (stack, shared data model, auth posture,
  breaking changes) was resolved by asking the user, not by silent guess.
- The tech stack is either inherited from the existing codebase or pinned
  explicitly in phase 1 with a rationale -- never implicit, never re-decided
  per phase.
- Current-state claims are backed by `path:line`, not assumed from the spec.
- Every data field and API shape has a concrete type, not just a name.
- Acceptance criteria are testable by inspection or automated test, not by
  judgment call, and use real numbers wherever a number applies.
- Every failure mode identified has a stated test-coverage and
  error-handling status -- none left as an open question.
- A rollback plan is stated for any phase touching data, infra, or shared
  state.
- The phase depends only on interfaces defined in earlier phases -- check for
  forward references.
- The phase's file count and new-component count fall within the sizing
  bound, or the oversized phase has been split.

**Final self-check.** For each phase document, actually switch perspective:
read it as the implementing agent would, with zero other context beyond the
completed prior phases. Try to name one design decision you would still have
to make. If you can name one, the document is not done -- go back and decide
it. Only move on once you cannot find one.
