---
description: "Every process a software team runs was built to manage a scarce resource. For twenty years that resource was engineering time. Waterfall managed it with sequencing. Agile managed it with short cycles and constant renegotiation. Both approaches assume the same thing: writing code is the expensive step, so protect it with process."
slug: ai-first-org
published_at: 2026-08-06
category: engineering-explorations
---
Every process a software team runs was built to manage a scarce resource. For twenty years that resource was engineering time. Waterfall managed it with sequencing. Agile managed it with short cycles and constant renegotiation. Both approaches assume the same thing: writing code is the expensive step, so protect it with process.

That assumption is breaking. At AI first orgs, writing code, writing tests, and refactoring stop being the bottleneck. The bottleneck does not disappear, it moves. Verification, code review, and security start taking up the time that typing code used to take. If your team's process still optimizes for the old bottleneck, it is optimizing for the wrong thing, and it is probably making you slower without anyone noticing.

This is not a call to throw out process. It is a call to look at each process, ask what gap it was closing, and check whether that gap still exists once an AI coding tool is doing most of the typing.

## The Processes That Stops Working

Process rarely gets deleted on its own. A ritual gets added to close a real gap, the gap closes, and the ritual survives out of habit. Nobody schedules a retro to ask "does this still make sense." Once an org adopts agentic coding as the default way of working, several long standing norms stop making sense within weeks. Here is what an AI first org replaces them with, and why.

## Planning

The old norm was heavy upfront planning, because coding time was the expensive part and you wanted to spend it on the right things. A team that writes a solid six month roadmap today will find it out of date by month three, because the tools themselves keep changing what is possible.

AI first orgs plan just in time (JIT), the same idea as JIT compilation: do the minimum planning needed, right before you need it, and let the plan compile against current reality instead of a six month old guess. In practice this looks like:

- Skip the design doc for most features. Build a prototype first, then write down what you learned.
- Get the prototype in front of five to ten internal users within a day or two, not a formal beta cycle.
- Replace the quarterly product review with lightweight decisions inside the pull request thread, where the code and the discussion live together.
- Reserve a full design doc for the rare case where a decision is expensive to reverse, such as a data model change or a public API contract.

The practical test for whether you need a doc: can this decision be undone with one more prototype iteration. If yes, skip the doc and build.

## Ask The Model Before The Person

Before agentic coding, "who wrote this" was the fastest path to an answer, because the author held context nobody else had. Once most pull requests are AI assisted, the author is often not the fastest path anymore. The model watched the whole change happen and can answer directly.

The shift is one extra question before you go looking for a human: what do I actually need to know. "Who wrote this" collapses into several different questions, each with a different best source:

- Who caused this regression, and when. Ask the model to walk the git history and correlate it against the failing test.
- Who is the domain expert on this subsystem. Ask the model to summarize ownership from the codeowners file and recent commit activity, then go talk to that person about judgment calls the model cannot make.
- Why was this decision made. Ask the model to pull the pull request description and linked discussion before pinging anyone.

Once you notice a question repeats, automate it instead of asking it again. A summary of customer feedback channels, for example, does not need a human doing it manually over coffee every morning. It can be a scheduled job that runs before anyone is at their desk. The rule of thumb: if you asked the same category of question three times this month, turn it into a standing job.

## Code Review - Trust But Verify

Code review used to mean a human read every line. That does not scale once code volume goes up an order of magnitude, and it was never a great use of senior engineering time in the first place.

In an AI first org, the model owns:

- Style and linting, with zero human time spent on nits
- Responding to pull request feedback and iterating until comments are resolved
- Catching and fixing bugs before a commit lands
- Writing and updating tests for the change

Humans stay in the loop specifically where domain judgment cannot be automated:

- Legal review for anything touching data handling, licensing, or compliance risk
- Security review for trust boundaries, auth flows, and anything crossing a privilege level
- Product and design review for taste, for whether a feature actually solves the user's problem

A simple test before assigning a human reviewer: would a wrong call here be expensive to reverse, or does it require judgment about risk tolerance rather than correctness. If the answer is no to both, the pull request does not need a human gate.

This split is not static. As models improve, more of what needs a human today will not need one next quarter. Treat the trust versus verify line as something to revisit monthly, not something set once and forgotten.

## Team Makeup - Roles Blur On Purpose

When engineering time was the constraint, roles were drawn around who could write code. Product managers planned, designers designed, engineers coded. Agentic coding erodes that line from both directions. Product managers ship prototypes directly. Engineers pick up content and design work that used to sit strictly outside their lane.

AI first orgs end up hiring for two profiles:

- Creative builders with product sense: people who are curious enough to prototype something new every week and care about whether it actually solves a problem.
- Engineers with deep systems expertise: people who understand the hard constraints, like distributed state, latency budgets, or security boundaries, that a model cannot yet reason about reliably on its own.

Raw throughput matters less, since the model absorbs most of it. The scarce skill becomes knowing where a human still needs to make the call.

## The Few Rules That Should Not Be Negotiable

Not every part of this shift should be left to individual teams to figure out on their own. A small set of org level principles need to hold across the board:

- Everyone, including cross functional partners, uses the AI coding tools daily. Dogfooding is not optional, it is how an org notices what is broken before its users do.
- Keep management flat. Managers should ship real work themselves before they lead a team, so they understand what the work actually feels like now.
- Anyone can question and kill a process that no longer serves its purpose, without needing permission from above.

Inside those rules, individual teams should keep full agency over how they triage work, run standups, and decide which workflows get automated first.

## Metrics That Tell You The New Norms Are Sticking

Three numbers are worth tracking as an org makes this shift:

- Onboarding ramp time. How fast does a new engineer, designer, or product manager ship real work. This should drop from weeks to days once the org is truly AI first.
- Pull request cycle time. Watch this closely, since it often reveals where a build system or CI pipeline cannot keep pace with the new volume of code moving through review.
- Percentage of AI assisted commits. In a mature AI first org this trends toward 100 percent within months.

The last metric is a trap if you stop there. Throughput measures activity, not outcomes. A team can drive AI assisted commits to 100 percent and still ship the wrong thing faster. Pair throughput with a metric tied to the actual problem being solved, whether that is customer retention, incident rate, or feature adoption, so speed serves the goal rather than becoming the goal.

## Audit Your Noisiest Workflow

Pick the workflow your team dreads most. The expensive status meeting, the manual release checklist, the weekly report nobody reads twice. Ask two questions:

- Is this still serving its original purpose.
- If yes, can it be automated instead of run by hand.

Picture a weekly review where everyone has a laptop open the entire time, except for the thirty seconds when it is their turn to give a status update. One question, "why are we having this meeting again," is often enough for the room to realize nobody needs it.

Run that same question against your own noisiest process this week. You will likely find at least one ritual that was built for a bottleneck that no longer exists.

---

Footnote: AI first engineering orgs move the bottleneck from writing code to verifying it, which means planning, context gathering, code review, and team structure all need to change with it. Move planning to just in time prototypes instead of long roadmaps.

Ask the model for context before asking a person, and automate any question asked repeatedly. Let AI tools own style, bugs, and tests, and reserve human review for security, legal, and product judgment. Expect roles to blur, hire for product sense and systems depth, and track onboarding time, pull request cycle time, and AI assisted commits, while treating throughput as a means, not the goal.
