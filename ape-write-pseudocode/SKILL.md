---
name: ape-write-pseudocode
description: >
  Guidelines for writing pseudocode for functions and algorithms. Use this skill
  whenever the user asks to write pseudocode, sketch out an algorithm, or describe
  the logic of a function at a high level. Trigger on phrases like "write pseudocode",
  "sketch this algorithm", "pseudocode for this function", or "describe the logic".
---

# Pseudocode Style Guide

## Structure of a Function

Every pseudocode function has exactly three parts: input, output, and body. Use Python-like syntax: `def` for the function signature, a docstring-style comment block for input and output, and indented body lines.

```
def function_name(param1, param2, ...):
    # input:  <what each param represents>
    # output: <what the function returns or produces>

    <body>
```

## Body Rules

The body is the core of the pseudocode. Each line describes one logical step at a very high level -- what the step takes as input and what it produces as output. Do not write code. Do not spell out implementation details.

- One line per logical step.
- Each line states what it receives and what it produces or decides.
- No variable declarations, no type annotations, no language syntax.
- No method chains, no intermediate variable names unless a name is essential to connect two steps.
- Never more than one idea per line.

## Control Flow

Use `if`, `elif`, `else`, and loops sparingly and only when the branching or iteration is the point of the logic. Use Python-like keywords and colon-terminated headers.

```
if <condition>:
    <what happens>
else:
    <what happens instead>

for each <item> in <collection>:
    <what is done with item>

while <condition>:
    <what is repeated>
```

Keep conditions at the same high level as the rest of the body -- describe the condition in plain words, not code.

## What to Write on Each Line

Each line should answer: "given what input, produce or decide what output?"

Good patterns:

- `filter nodes by reachability from source`
- `sort entries by timestamp, oldest first`
- `compute shortest path from source to each node`
- `pick the candidate with the highest score`
- `merge left result and right result into sorted list`

Bad patterns (too much detail):

- `dist[v] = dist[u] + weight(u, v)` -- this is code
- `initialize a min-heap priority queue with (0, source)` -- implementation detail
- `list.stream().filter(x -> x > 0).collect(...)` -- this is definitely code

## Examples

**Good:**

```python
def lsm_write(key, value):
    # input:  key and value to store
    # output: acknowledgement that write is recorded

    append key-value pair to memtable
    if memtable exceeds size threshold:
        flush memtable to a new SSTable on disk
        clear memtable
```

```python
def lsm_read(key):
    # input:  key to look up
    # output: value for key, or not found

    check memtable for key
    if found in memtable:
        return value from memtable
    for each SSTable from newest to oldest:
        check bloom filter for key
        if bloom filter says key may exist:
            search SSTable for key
            if found:
                return value
    return not found
```

```python
def lsm_compact(sstables):
    # input:  list of SSTables to merge
    # output: single merged SSTable with duplicates resolved

    open a cursor on each SSTable
    while any cursor has remaining entries:
        pick the entry with the smallest key across all cursors
        if same key appears in multiple SSTables:
            keep only the entry from the newest SSTable
        write chosen entry to output SSTable
    return output SSTable
```

**Bad (do not do this):**

```python
def lsm_write(key: str, value: bytes):  # typed signature -- not pseudocode
    self.lock.acquire()
    self.memtable[key] = value          # this is Python code, not pseudocode
    if len(self.memtable) > self.threshold:
        self.flush()
    self.lock.release()
```

## Checklist Before Writing

- Does each line describe logic, not implementation?
- Can a non-programmer read each line and understand what is happening?
- Are if/else and loops used only where branching or iteration is the actual point?
- Is every line a single idea?

If yes, the pseudocode is done.
