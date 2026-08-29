# Worked example: the spine for `bitcask.md`

Source: `bitcask.md`, 1,376 words, 2 figures ("Datafiles", "KeyDir"), no tables, no maths.
Ten ideas, so grouped into four parts (`h2` parts, `h3` ideas). Budget: 850-1,600 words.

Claim (dek): *Append every write, keep every key in memory, and any value is one disk seek away.*

## Structure
01. Bitcask is a directory of append-only files plus one in-memory index -> pipeline §1 (client -> active file, client -> keydir), two packets
02. A datafile entry is a fixed record, so it can be scanned without an index -> `.cells.row` (crc · tstamp · ksz · vsz · key · value); source figure "Datafiles" redrawn
03. A datafile is active, then immutable, then merged away -> state machine §8, `data-cycle`
04. KeyDir maps every key to a file, an offset and a timestamp -> pipeline §1 (key -> keydir entry -> datafile -> value); source figure "KeyDir" redrawn

## Operations
05. A put is one append plus one KeyDir update, performed atomically -> sequence §2 (client, active file, keydir), three packets
06. A read is exactly one disk read -> flowchart §7 (in keydir? yes -> 1 disk read -> check crc), pulse on the diamond, packet on "yes"
07. Updates and deletes leave old entries dangling until compaction -> `.cells` with `.bad` for superseded entries and a tombstone; aside: tombstone value must not collide with real values

## Housekeeping
08. Merge rewrites immutable files keeping only the latest live version of each key -> `.panels` before/after (7 entries across 3 files -> 3 entries in 1 file)
09. Hint files make boot fast and bounded -> pipeline §1 (datafile -> hint file -> keydir -> bitcask)

## Limits
10. The whole keyspace must fit in RAM -> `.quote` + aside (shard keys to scale)

## What a wrong spine looks like for this post

- One idea per post heading ("Introduction", "Datafiles", "KeyDir", "Operations", ...): topics, not claims.
- One idea per paragraph: 25 sections, half of them restating the previous one.
- Everything as a pipeline diagram: the record layout is a row of cells, the lifecycle is a state machine, the read is a decision -- the shape of the idea picks the visual.
