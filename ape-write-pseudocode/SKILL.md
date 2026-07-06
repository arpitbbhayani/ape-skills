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

The body is the core of the pseudocode. Each line is a pythonic, non-functional call that names the operation and its operands -- not English prose. Invent clear, intuitive method or function names. The goal is code that reads like intent, not implementation.

- One call per logical step.
- Use `object.verb(args)` or `verb(args)` style -- never English sentences.
- No type annotations, no real data-structure internals, no language-specific APIs.
- Intermediate variable names are fine when they connect two steps.
- Never more than one idea per line.

## Control Flow

Use `if`, `elif`, `else`, and loops sparingly and only when the branching or iteration is the point of the logic. Conditions are also written as code-like expressions, not prose.

```
if condition_call(args):
    ...
else:
    ...

for item in collection:
    ...

while not done():
    ...
```

## What to Write on Each Line

Each line should look like a call you would recognise but cannot actually run.

Good patterns:

- `nodes.filter_reachable_from(source)`
- `entries.sort_by(timestamp, order=ASC)`
- `graph.shortest_path(source)`
- `candidates.pick_highest_score()`
- `merge_sorted(left, right)`

Bad patterns:

- `"filter nodes by reachability from source"` -- English sentence, not code
- `dist[v] = dist[u] + weight(u, v)` -- actual implementation code
- `initialize a min-heap priority queue with (0, source)` -- prose + detail
- `list.stream().filter(x -> x > 0).collect(...)` -- real language API

## Examples

**Good:**

```python
def lsm_write(key, value):
    # input:  key and value to store
    # output: acknowledgement that write is recorded

    memtable.append(key, value)
    if memtable.exceeds_threshold():
        sstable = memtable.flush_to_disk()
        memtable.clear()
```

```python
def lsm_read(key):
    # input:  key to look up
    # output: value for key, or NOT_FOUND

    if memtable.contains(key):
        return memtable.get(key)
    for sstable in sstables.newest_first():
        if sstable.bloom_filter.might_contain(key):
            value = sstable.search(key)
            if value:
                return value
    return NOT_FOUND
```

```python
def lsm_compact(sstables):
    # input:  list of SSTables to merge
    # output: single merged SSTable with duplicates resolved

    cursors = sstables.open_cursors()
    while cursors.any_remaining():
        entry = cursors.pick_min_key()
        if cursors.has_duplicates(entry.key):
            entry = cursors.keep_newest(entry.key)
        output.write(entry)
    return output.finalise()
```

**Bad (do not do this):**

```python
def lsm_write(key, value):
    append key-value pair to memtable          # English sentence -- wrong
    if memtable exceeds size threshold:        # English condition -- wrong
        flush memtable to a new SSTable        # English sentence -- wrong
```

```python
def lsm_write(key: str, value: bytes):  # typed signature + real Python -- wrong
    self.lock.acquire()
    self.memtable[key] = value
    if len(self.memtable) > self.threshold:
        self.flush()
    self.lock.release()
```

## Checklist Before Writing

- Are all body lines calls (`object.verb(args)` or `verb(args)`), not English sentences?
- Are invented names intuitive -- would a reader guess what they do?
- Are if/else conditions also written as calls or simple expressions, not prose?
- Is every line a single idea?

If yes, the pseudocode is done.
