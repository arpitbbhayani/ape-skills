# SVG Templates

Copy the template for the idea shape, change only the labels, counts, and highlighted
elements. Do not change stroke widths, radii, font sizes, or the grid. The visuals look
good because they all obey the same grammar; a "creative" deviation is what makes a
document look amateur.

## Grammar (applies to every diagram)

- `viewBox` on an 8px grid. Widths: `960` for full-width diagrams, `640` for narrow.
  Height as needed, usually 240-420. Never set `width`/`height` attributes; CSS sizes it.
- Boxes: `rx="10"`, `stroke-width="1.5"`, `fill="var(--surface)"`, `stroke="var(--line)"`.
  The box the idea is about: `stroke="var(--accent)"`, `fill="var(--accent-soft)"`.
  A failing box: `stroke="var(--err)"`.
- Box size: `w=160 h=64` default. Text centred: `text-anchor="middle" dominant-baseline="middle"`.
- Text: `font-size="18"` for labels inside boxes, `font-size="14" fill="var(--muted)"`
  for arrow labels and annotations. Never below 13. A box label is at most 14 characters
  at `w=160`; longer labels use the `w=192` positions below or a shorter word. Never more
  than 3 words in a box.
- Arrow labels: at most 8 characters, centred above the arrow's midpoint (`y = arrow_y - 14`).
  A label that will not fit in 8 characters goes in the figcaption instead.
- Arrows: `stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"`,
  class `draw`. Orthogonal or straight only; a diagonal arrow means the layout is wrong.
  The arrow the idea is about: `stroke="var(--accent)"` with `marker-end="url(#arr-a)"`.
- Gap between boxes: 64 horizontally, 48 vertically. Max 7 boxes per diagram; if the
  system has more, the diagram is about a subsystem.
- Every diagram: `role="img"` and `aria-label` stating the idea, not the shapes.
- Every diagram sits inside `<figure>` (add `class="wide"` for 960-wide diagrams so they
  break out of the prose column) with a `<figcaption>` beneath it.
- Stagger: `data-i`/`style="--i:n"` on each `.pop` and `.draw` in reading order.

Marker definitions -- include once per SVG that has arrows:

```html
<defs>
  <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
    <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
  </marker>
  <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
    <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
  </marker>
</defs>
```

Box + label group (repeat, translate to position):

```html
<g class="pop" style="--i:0" transform="translate(40 88)">
  <rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
  <text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Client</text>
</g>
```

## 1. Pipeline / request flow (left to right)

Three to five boxes on one row, arrows labelled with what flows.

```html
<svg viewBox="0 0 960 240" role="img" aria-label="Writes go to the log before the table">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <g class="pop" style="--i:0" transform="translate(40 88)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Client</text></g>
  <path class="draw" style="--i:1" d="M200 120H264" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="232" y="106" text-anchor="middle" font-size="14" fill="var(--muted)">write</text>
  <g class="pop" style="--i:2" transform="translate(264 88)"><rect width="160" height="64" rx="10" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">WAL</text></g>
  <path class="draw" style="--i:3" d="M424 120H488" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <text x="456" y="106" text-anchor="middle" font-size="14" fill="var(--muted)">fsync</text>
  <g class="pop" style="--i:4" transform="translate(488 88)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Memtable</text></g>
  <path class="draw" style="--i:5" d="M648 120H712" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="680" y="106" text-anchor="middle" font-size="14" fill="var(--muted)">flush</text>
  <g class="pop" style="--i:6" transform="translate(712 88)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">SSTable</text></g>
</svg>
```

Positions for N boxes across 960 wide (w=160, gap=64): start `x = (960 - (N*160 + (N-1)*64)) / 2`, then `x += 224` each.
N=3: 176, 400, 624. N=4: 64, 288, 512, 736. N=5: use `w=144 gap=48`: 40, 232, 424, 616, 808.
Long labels (`w=192 gap=64`): N=3: 96, 352, 608. N=4: not possible at 960 -- shorten the labels.

### 1b. Branching pipeline (one source, two targets)

Source box on the left, vertically centred; two targets stacked on the right; orthogonal
elbows. The taken or important branch is accent.

```html
<svg viewBox="0 0 640 240" role="img" aria-label="A put writes the file and then the index">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <g class="pop" style="--i:0" transform="translate(40 88)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">put(k, v)</text></g>
  <path class="draw" style="--i:1" d="M200 120H280V56H396" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <text x="338" y="42" text-anchor="middle" font-size="14" fill="var(--muted)">append</text>
  <path class="draw" style="--i:2" d="M200 120H280V184H396" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="338" y="170" text-anchor="middle" font-size="14" fill="var(--muted)">update</text>
  <g class="pop" style="--i:3" transform="translate(400 24)"><rect width="160" height="64" rx="10" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">datafile</text></g>
  <g class="pop" style="--i:4" transform="translate(400 152)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">keydir</text></g>
</svg>
```

For two sources into one target, mirror it: targets become sources on the left, the merge
box on the right.

### 1c. Data Flow Graph (Complex tracking through components)

Use for illustrating how data is processed, transformed, or routed through multiple components in a system. Perfect for showing stream processing or event-driven architectures.

```html
<svg viewBox="0 0 960 360" role="img" aria-label="Events are validated, enriched, and fanned out to storage and analytics">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <!-- Nodes -->
  <g class="pop" style="--i:0" transform="translate(40 148)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Ingress API</text></g>
  <g class="pop" style="--i:1" transform="translate(280 148)"><circle cx="80" cy="32" r="32" fill="var(--surface0)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="14">Validate</text></g>
  <g class="pop" style="--i:2" transform="translate(460 148)"><rect width="160" height="64" rx="10" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Event Bus</text></g>
  <g class="pop" style="--i:3" transform="translate(720 52)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Data Lake</text></g>
  <g class="pop" style="--i:4" transform="translate(720 244)"><rect width="160" height="64" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Real-time DB</text></g>
  <!-- Edges -->
  <path id="df1" class="draw" style="--i:5" d="M200 180H280" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <path id="df2" class="draw" style="--i:6" d="M360 180H460" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <path id="df3" class="draw" style="--i:7" d="M620 180H670V84H720" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <path id="df4" class="draw" style="--i:8" d="M620 180H670V276H720" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="670" y="156" text-anchor="middle" font-size="14" fill="var(--muted)">fan-out</text>
  <!-- Moving Data Packets -->
  <circle class="packet" r="5"><animateMotion dur="4s" repeatCount="indefinite" begin="0s" keyPoints="0;1" keyTimes="0;1"><mpath href="#df1"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="4s" repeatCount="indefinite" begin="1s" keyPoints="0;1" keyTimes="0;1"><mpath href="#df2"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="4s" repeatCount="indefinite" begin="2.5s" keyPoints="0;1" keyTimes="0;1"><mpath href="#df3"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="4s" repeatCount="indefinite" begin="2.5s" keyPoints="0;1" keyTimes="0;1"><mpath href="#df4"/></animateMotion></circle>
</svg>
```

### 1d. Hub-and-Spoke / Pub-Sub Broadcast

Use for message brokers, load balancing, fan-in/fan-out, or pub/sub topics (e.g. Kafka, RabbitMQ).

```html
<svg viewBox="0 0 640 360" role="img" aria-label="A central message broker routes events to multiple subscribers">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>

  <!-- Producers -->
  <g class="pop" style="--i:0" transform="translate(60 100)"><rect width="120" height="48" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="60" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15">Producer A</text></g>
  <g class="pop" style="--i:0" transform="translate(60 212)"><rect width="120" height="48" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="60" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15">Producer B</text></g>

  <!-- The Broker -->
  <g class="pop" style="--i:1" transform="translate(260 148)"><rect width="120" height="64" rx="10" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" dominant-baseline="middle" font-size="18">Broker</text></g>

  <!-- Subscribers -->
  <g class="pop" style="--i:2" transform="translate(460 48)"><rect width="120" height="48" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="60" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15">Sub 1</text></g>
  <g class="pop" style="--i:2" transform="translate(460 156)"><rect width="120" height="48" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="60" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15">Sub 2</text></g>
  <g class="pop" style="--i:2" transform="translate(460 264)"><rect width="120" height="48" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="60" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15">Sub 3</text></g>

  <!-- Arrows -->
  <path id="hub1" class="draw" style="--i:3" d="M180 124 L 260 160" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <path id="hub2" class="draw" style="--i:4" d="M180 236 L 260 200" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  
  <path id="hub3" class="draw" style="--i:5" d="M380 160 L 460 72" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <path id="hub4" class="draw" style="--i:6" d="M380 180 L 460 180" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <path id="hub5" class="draw" style="--i:7" d="M380 200 L 460 288" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>

  <!-- Moving Messages -->
  <circle class="packet" r="5"><animateMotion dur="2s" repeatCount="indefinite" begin="0s"><mpath href="#hub1"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="2s" repeatCount="indefinite" begin="1s"><mpath href="#hub2"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="2s" repeatCount="indefinite" begin="2.5s"><mpath href="#hub3"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="2s" repeatCount="indefinite" begin="2.5s"><mpath href="#hub4"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="2s" repeatCount="indefinite" begin="2.5s"><mpath href="#hub5"/></animateMotion></circle>
</svg>
```

## 2. Sequence diagram (two or three actors, time downward)

Use for request/response, handshake, consensus round, race.

```html
<svg viewBox="0 0 960 360" role="img" aria-label="Leader replicates to a follower before acknowledging">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <!-- actor headers -->
  <g class="pop" style="--i:0" transform="translate(120 24)"><rect width="160" height="48" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="24" text-anchor="middle" dominant-baseline="middle" font-size="18">Client</text></g>
  <g class="pop" style="--i:0" transform="translate(400 24)"><rect width="160" height="48" rx="10" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="80" y="24" text-anchor="middle" dominant-baseline="middle" font-size="18">Leader</text></g>
  <g class="pop" style="--i:0" transform="translate(680 24)"><rect width="160" height="48" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="24" text-anchor="middle" dominant-baseline="middle" font-size="18">Follower</text></g>
  <!-- lifelines -->
  <path d="M200 72V336 M480 72V336 M760 72V336" stroke="var(--line)" stroke-width="1.5" stroke-dasharray="4 6"/>
  <!-- messages: y increases 56 per step -->
  <path id="seq1" class="draw" style="--i:1" d="M200 120H476" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="340" y="108" text-anchor="middle" font-size="14" fill="var(--muted)">put(k, v)</text>
  <path id="seq2" class="draw" style="--i:2" d="M480 176H756" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <text x="620" y="164" text-anchor="middle" font-size="14" fill="var(--muted)">append</text>
  <path id="seq3" class="draw" style="--i:3" d="M760 232H484" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="620" y="220" text-anchor="middle" font-size="14" fill="var(--muted)">ack</text>
  <path id="seq4" class="draw" style="--i:4" d="M480 288H204" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="340" y="276" text-anchor="middle" font-size="14" fill="var(--muted)">ok</text>
  <!-- multi-hop packet loop -->
  <circle class="packet" r="5"><animateMotion dur="2.4s" begin="0.2s" repeatCount="indefinite"><mpath href="#seq1"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="2.4s" begin="0.8s" repeatCount="indefinite"><mpath href="#seq2"/></animateMotion></circle>
  <circle class="packet ok" r="5"><animateMotion dur="2.4s" begin="1.4s" repeatCount="indefinite"><mpath href="#seq3"/></animateMotion></circle>
  <circle class="packet ok" r="5"><animateMotion dur="2.4s" begin="1.9s" repeatCount="indefinite"><mpath href="#seq4"/></animateMotion></circle>
</svg>
```

For a race / bug: two message arrows that cross, both in `var(--err)` with `url(#arr-e)` (define a third marker with `fill="var(--err)"`), and one annotation in `var(--err)` naming the bad state.

### 2b. Parallel Execution / Concurrency Swimlanes

Use for illustrating asynchronous tasks, blocking vs non-blocking I/O, parallelism, and latency bottlenecks. Time flows left-to-right.

```html
<svg viewBox="0 0 640 240" role="img" aria-label="Async I/O allows Thread A to do other work instead of blocking">
  <!-- Axis -->
  <line x1="120" y1="200" x2="600" y2="200" stroke="var(--line)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <text x="600" y="222" text-anchor="end" font-size="12" fill="var(--muted)">Time →</text>
  <!-- Labels -->
  <text x="100" y="44" text-anchor="end" dominant-baseline="middle" font-size="14">Thread A</text>
  <text x="100" y="104" text-anchor="end" dominant-baseline="middle" font-size="14">Thread B</text>
  <text x="100" y="164" text-anchor="end" dominant-baseline="middle" font-size="14">Network I/O</text>

  <!-- Thread A tasks -->
  <g class="pop" style="--i:0">
    <rect x="120" y="28" width="60" height="32" rx="4" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/>
    <text x="150" y="44" text-anchor="middle" dominant-baseline="middle" font-size="12" fill="var(--accent)">Req 1</text>
  </g>
  <!-- Network starts after Req 1 -->
  <path class="draw" style="--i:1" d="M180 44 L 190 44 L 190 164 L 200 164" stroke="var(--muted)" stroke-width="1.5" fill="none"/>
  <g class="pop" style="--i:2">
    <rect x="200" y="148" width="200" height="32" rx="4" fill="var(--surface0)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="300" y="164" text-anchor="middle" dominant-baseline="middle" font-size="12">Wait (async)</text>
  </g>
  <!-- Thread A does other work while Network is waiting -->
  <g class="pop" style="--i:3">
    <rect x="200" y="28" width="80" height="32" rx="4" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="240" y="44" text-anchor="middle" dominant-baseline="middle" font-size="12">Req 2</text>
  </g>
  <!-- Thread B picks up processing -->
  <g class="pop" style="--i:4">
    <rect x="290" y="88" width="100" height="32" rx="4" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="340" y="104" text-anchor="middle" dominant-baseline="middle" font-size="12">Process 2</text>
  </g>
  <!-- Network completes, Thread A handles response -->
  <path class="draw" style="--i:5" d="M400 164 L 410 164 L 410 44 L 420 44" stroke="var(--muted)" stroke-width="1.5" fill="none"/>
  <g class="pop" style="--i:6">
    <rect x="420" y="28" width="60" height="32" rx="4" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/>
    <text x="450" y="44" text-anchor="middle" dominant-baseline="middle" font-size="12" fill="var(--accent)">Resp 1</text>
  </g>
</svg>
```

## 3. Bar chart (comparison of magnitudes)

Label bars directly. No axes lines except a baseline. No legend. Bars `class="grow"`.

```html
<svg viewBox="0 0 960 320" role="img" aria-label="p99 latency: 41 ms before, 12 ms after">
  <line x1="80" y1="260" x2="880" y2="260" stroke="var(--line)" stroke-width="1.5"/>
  <rect class="grow" style="--i:0" x="280" y="60" width="120" height="200" rx="6" fill="var(--muted)"/>
  <text x="340" y="44" text-anchor="middle" font-size="18" font-family="var(--mono)">41 ms</text>
  <text x="340" y="292" text-anchor="middle" font-size="14" fill="var(--muted)">before</text>
  <rect class="grow" style="--i:1" x="560" y="201" width="120" height="59" rx="6" fill="var(--accent)"/>
  <text x="620" y="185" text-anchor="middle" font-size="18" font-family="var(--mono)">12 ms</text>
  <text x="620" y="292" text-anchor="middle" font-size="14" fill="var(--muted)">after</text>
</svg>
```

### 3a. Benchmark Race Bars (HTML/CSS, preferred for throughput/speed comparisons)

Animated horizontal meters that race across to target positions on reveal.

```html
<div class="race-bars">
  <div class="race-item">
    <span class="race-label">Bitcask</span>
    <div class="race-track"><div class="race-fill accent" data-pct="92%"></div></div>
    <span class="race-val">41.2 kops/s</span>
  </div>
  <div class="race-item">
    <span class="race-label">LevelDB</span>
    <div class="race-track"><div class="race-fill" data-pct="54%"></div></div>
    <span class="race-val">24.1 kops/s</span>
  </div>
  <div class="race-item">
    <span class="race-label">B-Tree</span>
    <div class="race-track"><div class="race-fill" data-pct="28%"></div></div>
    <span class="race-val">12.5 kops/s</span>
  </div>
</div>
```

### 3b. 2x2 Trade-off Matrix / Quadrants

Ideal for comparing systems across two conflicting axes (e.g. Write Throughput vs Read Latency, Consistency vs Availability).

```html
<svg viewBox="0 0 640 400" role="img" aria-label="Trade-off space: Append-only stores maximize write throughput with low write latency" class="quadrant-svg">
  <!-- Outer border -->
  <rect x="40" y="40" width="560" height="320" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
  <!-- Crosshair axes -->
  <line x1="40" y1="200" x2="600" y2="200" stroke="var(--line)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <line x1="320" y1="40" x2="320" y2="360" stroke="var(--line)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <!-- Quadrant Labels -->
  <text x="60" y="66" font-size="12" fill="var(--muted)" font-family="var(--mono)" letter-spacing="0.08em" text-transform="uppercase">High Cost / High Durability</text>
  <text x="580" y="66" text-anchor="end" font-size="12" fill="var(--accent)" font-family="var(--mono)" letter-spacing="0.08em" text-transform="uppercase">Target: Low Latency + Fast Writes</text>
  <text x="60" y="344" font-size="12" fill="var(--muted)" font-family="var(--mono)" letter-spacing="0.08em" text-transform="uppercase">Simple / Ephemeral</text>
  <text x="580" y="344" text-anchor="end" font-size="12" fill="var(--muted)" font-family="var(--mono)" letter-spacing="0.08em" text-transform="uppercase">High Seek Overhead</text>
  <!-- Positioned System Nodes -->
  <g class="pop quadrant-node" style="--i:1" transform="translate(180 280)">
    <circle cx="0" cy="0" r="24" fill="var(--surface0)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="0" y="4" text-anchor="middle" font-size="14">B-Tree</text>
  </g>
  <g class="pop quadrant-node" style="--i:2" transform="translate(260 120)">
    <circle cx="0" cy="0" r="24" fill="var(--surface0)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="0" y="4" text-anchor="middle" font-size="14">LSM</text>
  </g>
  <g class="pop quadrant-node" style="--i:3" transform="translate(480 110)">
    <circle cx="0" cy="0" r="28" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="2"/>
    <text x="0" y="4" text-anchor="middle" font-size="15" font-weight="600" fill="var(--accent)">Bitcask</text>
  </g>
</svg>
```

### 3c. Architecture Stack/Layer Breakdown

Use for system overviews, stack architectures, or layered compositions (e.g. App -> API -> Cache -> DB).

```html
<svg viewBox="0 0 640 420" role="img" aria-label="A modern three-tier web architecture">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
  </defs>
  <!-- Base layer (DB / Storage) -->
  <g class="pop" style="--i:0" transform="translate(160 300)">
    <rect width="320" height="80" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="160" y="40" text-anchor="middle" dominant-baseline="middle" font-size="18">Database (Persistent)</text>
  </g>
  <!-- Middle layer (API / Logic) with split elements -->
  <g class="pop" style="--i:1" transform="translate(160 170)">
    <rect width="320" height="100" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5" stroke-dasharray="4 4"/>
    <text x="160" y="24" text-anchor="middle" dominant-baseline="middle" font-size="14" fill="var(--muted)">Application Layer</text>
  </g>
  <g class="pop" style="--i:2" transform="translate(180 200)">
    <rect width="130" height="48" rx="8" fill="var(--surface0)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="65" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15">API Service</text>
  </g>
  <g class="pop" style="--i:3" transform="translate(330 200)">
    <rect width="130" height="48" rx="8" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/>
    <text x="65" y="24" text-anchor="middle" dominant-baseline="middle" font-size="15" fill="var(--accent)">Cache</text>
  </g>
  <!-- Top layer (Client / Front-end) -->
  <g class="pop" style="--i:4" transform="translate(200 40)">
    <rect width="240" height="70" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="120" y="35" text-anchor="middle" dominant-baseline="middle" font-size="18">Client Application</text>
  </g>
  <!-- Connectors -->
  <path id="arch1" class="draw" style="--i:5" d="M320 110V170" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <path id="arch2" class="draw" style="--i:6" d="M320 270V300" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <!-- Motion -->
  <circle class="packet" r="5"><animateMotion dur="2.8s" repeatCount="indefinite" begin="0.2s"><mpath href="#arch1"/></animateMotion></circle>
  <circle class="packet" r="5"><animateMotion dur="2.8s" repeatCount="indefinite" begin="1.4s"><mpath href="#arch2"/></animateMotion></circle>
</svg>
```

### 3d. Function curve (a quantity against another)

One accent curve, a baseline and a left axis in `--line`, two or three labelled points.

```html
<svg viewBox="0 0 640 320" role="img" aria-label="IDF falls as document frequency rises and reaches zero when every document has the term">
  <line x1="72" y1="272" x2="600" y2="272" stroke="var(--line)" stroke-width="1.5"/>
  <line x1="72" y1="32" x2="72" y2="272" stroke="var(--line)" stroke-width="1.5"/>
  <text x="600" y="296" text-anchor="end" font-size="14" fill="var(--muted)">df(t) →</text>
  <text x="60" y="40" text-anchor="end" font-size="14" fill="var(--muted)">idf</text>
  <path id="c1" class="draw" style="--i:0" d="M96 48 C 160 200, 320 250, 584 268" stroke="var(--accent)" stroke-width="2" fill="none"/>
  <circle cx="96" cy="48" r="5" fill="var(--accent)"/><text x="112" y="52" font-size="14" fill="var(--muted)">rare term</text>
  <circle cx="584" cy="268" r="5" fill="var(--muted)"/><text x="572" y="256" text-anchor="end" font-size="14" fill="var(--muted)">in every doc: 0</text>
  <circle class="packet" r="5"><animateMotion dur="3s" repeatCount="indefinite"><mpath href="#c1"/></animateMotion></circle>
</svg>
```

### 3e. Latency waterfall (where the time goes)

Sequential spans of one operation, each starting where the previous ended, on one time
axis. Evidence, not mechanism: **static, no motion**. The span the idea is about gets
the accent; every value label must be stated by the post. Spans scale linearly with
their values; the name sits left of the row, the value at the span's end.

```html
<svg viewBox="0 0 960 300" role="img" aria-label="The server phase dominates the 200 ms request">
  <line x1="120" y1="260" x2="880" y2="260" stroke="var(--line)" stroke-width="1.5"/>
  <text x="880" y="288" text-anchor="end" font-size="14" fill="var(--muted)">time →</text>
  <g class="pop" style="--i:0">
    <rect x="120" y="48" width="46" height="32" rx="6" fill="var(--muted)"/>
    <text x="112" y="64" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">DNS</text>
    <text x="174" y="64" dominant-baseline="middle" font-size="14" fill="var(--muted)">12 ms</text>
  </g>
  <g class="pop" style="--i:1">
    <rect x="166" y="96" width="144" height="32" rx="6" fill="var(--muted)"/>
    <text x="112" y="112" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">TLS</text>
    <text x="318" y="112" dominant-baseline="middle" font-size="14" fill="var(--muted)">38 ms</text>
  </g>
  <g class="pop" style="--i:2">
    <rect x="310" y="144" width="361" height="32" rx="6" fill="var(--accent)"/>
    <text x="112" y="160" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">server</text>
    <text x="679" y="160" dominant-baseline="middle" font-size="14" fill="var(--accent)">95 ms</text>
  </g>
  <g class="pop" style="--i:3">
    <rect x="671" y="192" width="209" height="32" rx="6" fill="var(--muted)"/>
    <text x="112" y="208" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">transfer</text>
    <text x="872" y="208" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--bg)">55 ms</text>
  </g>
  <line x1="880" y1="40" x2="880" y2="260" stroke="var(--line)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <text x="872" y="32" text-anchor="end" font-size="14" fill="var(--muted)">200 ms total</text>
</svg>
```

### 3f. Histogram with percentile markers (the shape of a distribution)

The shape — the cluster and the tail — is the idea. Bars in `--muted`; the percentile
the idea is about gets an accent dashed marker. **Static.** Bar heights sketch the
distribution; only the marker labels carry values, and only values the post states.

```html
<svg viewBox="0 0 960 320" role="img" aria-label="Most requests finish near 2 ms but the p99 tail reaches 40 ms">
  <line x1="80" y1="260" x2="880" y2="260" stroke="var(--line)" stroke-width="1.5"/>
  <text x="880" y="288" text-anchor="end" font-size="14" fill="var(--muted)">latency →</text>
  <rect class="grow" style="--i:0"  x="88"  y="200" width="40" height="60"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:1"  x="136" y="120" width="40" height="140" rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:2"  x="184" y="60"  width="40" height="200" rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:3"  x="232" y="40"  width="40" height="220" rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:4"  x="280" y="70"  width="40" height="190" rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:5"  x="328" y="110" width="40" height="150" rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:6"  x="376" y="150" width="40" height="110" rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:7"  x="424" y="180" width="40" height="80"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:8"  x="472" y="205" width="40" height="55"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:9"  x="520" y="222" width="40" height="38"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:10" x="568" y="234" width="40" height="26"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:11" x="616" y="242" width="40" height="18"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:12" x="664" y="248" width="40" height="12"  rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:13" x="712" y="252" width="40" height="8"   rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:14" x="760" y="254" width="40" height="6"   rx="4" fill="var(--muted)"/>
  <rect class="grow" style="--i:15" x="808" y="256" width="40" height="4"   rx="4" fill="var(--muted)"/>
  <line x1="252" y1="24" x2="252" y2="260" stroke="var(--muted)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <text x="260" y="32" font-size="14" fill="var(--muted)">p50 2 ms</text>
  <line x1="828" y1="24" x2="828" y2="260" stroke="var(--accent)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <text x="820" y="32" text-anchor="end" font-size="14" fill="var(--accent)">p99 40 ms</text>
</svg>
```

### 3g. Magnitude ladder (values spanning orders of magnitude)

Horizontal bars with length proportional to **log10** of the value — linear bars go
blank across orders of magnitude. This is the only non-linear template; it must keep
the "log scale" annotation. The row the idea is about gets the accent. **Static.**
Bar length: `60 + log10(value in the smallest unit) * 86`.

```html
<svg viewBox="0 0 960 280" role="img" aria-label="A disk seek costs ten million times an L1 hit">
  <g class="pop" style="--i:0">
    <rect class="grow-x" style="--i:0" x="200" y="40" width="60" height="32" rx="6" fill="var(--muted)"/>
    <text x="192" y="56" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">L1 hit</text>
    <text x="268" y="56" dominant-baseline="middle" font-size="14" fill="var(--muted)">1 ns</text>
  </g>
  <g class="pop" style="--i:1">
    <rect class="grow-x" style="--i:1" x="200" y="96" width="232" height="32" rx="6" fill="var(--muted)"/>
    <text x="192" y="112" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">RAM read</text>
    <text x="440" y="112" dominant-baseline="middle" font-size="14" fill="var(--muted)">100 ns</text>
  </g>
  <g class="pop" style="--i:2">
    <rect class="grow-x" style="--i:2" x="200" y="152" width="490" height="32" rx="6" fill="var(--muted)"/>
    <text x="192" y="168" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">SSD read</text>
    <text x="698" y="168" dominant-baseline="middle" font-size="14" fill="var(--muted)">100 µs</text>
  </g>
  <g class="pop" style="--i:3">
    <rect class="grow-x" style="--i:3" x="200" y="208" width="662" height="32" rx="6" fill="var(--accent)"/>
    <text x="192" y="224" text-anchor="end" dominant-baseline="middle" font-size="14" fill="var(--muted)">disk seek</text>
    <text x="870" y="224" dominant-baseline="middle" font-size="14" fill="var(--accent)">10 ms</text>
  </g>
  <text x="880" y="264" text-anchor="end" font-size="14" fill="var(--muted)">log scale →</text>
</svg>
```

### 3h. Multi-curve comparison (two or three growth shapes against each other)

Same axes as §3d. The curve the idea is about is accent solid; the others are
`--muted`, the third dashed. Endpoint labels name the curves. **Static — no packet.**

```html
<svg viewBox="0 0 640 320" role="img" aria-label="Scan cost grows with n while the index stays near-flat">
  <line x1="72" y1="272" x2="600" y2="272" stroke="var(--line)" stroke-width="1.5"/>
  <line x1="72" y1="32" x2="72" y2="272" stroke="var(--line)" stroke-width="1.5"/>
  <text x="600" y="296" text-anchor="end" font-size="14" fill="var(--muted)">n →</text>
  <text x="60" y="40" text-anchor="end" font-size="14" fill="var(--muted)">cost</text>
  <path class="draw" style="--i:0" d="M96 256 L 560 56" stroke="var(--muted)" stroke-width="2" fill="none"/>
  <text x="548" y="44" text-anchor="end" font-size="14" fill="var(--muted)">scan O(n)</text>
  <path class="draw" style="--i:1" d="M96 264 C 240 216, 400 208, 560 204" stroke="var(--accent)" stroke-width="2" fill="none"/>
  <text x="548" y="192" text-anchor="end" font-size="14" fill="var(--accent)">index O(log n)</text>
</svg>
```

### 3i. Annotated time series (a metric over time, with events)

One accent curve, dashed vertical markers at the events the post names, a dot where
the marker meets the curve. **Static.** Label only events and values the post states;
a long event label goes in the figcaption.

```html
<svg viewBox="0 0 960 320" role="img" aria-label="Throughput doubles after the deploy and holds through the cache flush">
  <line x1="80" y1="260" x2="880" y2="260" stroke="var(--line)" stroke-width="1.5"/>
  <text x="880" y="288" text-anchor="end" font-size="14" fill="var(--muted)">time →</text>
  <path class="draw" style="--i:0" d="M96 200 C 200 196, 300 192, 380 188 C 420 120, 480 96, 600 92 C 700 90, 800 94, 864 92" stroke="var(--accent)" stroke-width="2" fill="none"/>
  <line x1="380" y1="48" x2="380" y2="260" stroke="var(--muted)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <circle cx="380" cy="188" r="5" fill="var(--accent)"/>
  <text x="388" y="56" font-size="14" fill="var(--muted)">deploy</text>
  <line x1="640" y1="48" x2="640" y2="260" stroke="var(--muted)" stroke-width="1.5" stroke-dasharray="4 4"/>
  <circle cx="640" cy="91" r="5" fill="var(--accent)"/>
  <text x="648" y="56" font-size="14" fill="var(--muted)">cache flush</text>
</svg>
```

## 4. Tree / hash / linked structure

```html
<svg viewBox="0 0 640 320" role="img" aria-label="Lookup walks root to leaf in three hops">
  <path class="draw" style="--i:1" d="M320 64L192 160 M320 64L448 160 M192 160L128 256 M192 160L256 256" stroke="var(--line)" stroke-width="1.5" fill="none"/>
  <g class="pop" style="--i:0"><circle cx="320" cy="64" r="28" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="320" y="64" text-anchor="middle" dominant-baseline="middle" font-size="18">50</text></g>
  <g class="pop" style="--i:2"><circle cx="192" cy="160" r="28" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="192" y="160" text-anchor="middle" dominant-baseline="middle" font-size="18">20</text></g>
  <g class="pop" style="--i:2"><circle cx="448" cy="160" r="28" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="448" y="160" text-anchor="middle" dominant-baseline="middle" font-size="18">70</text></g>
  <g class="pop" style="--i:3"><circle cx="128" cy="256" r="28" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="128" y="256" text-anchor="middle" dominant-baseline="middle" font-size="18">10</text></g>
  <g class="pop" style="--i:3"><circle cx="256" cy="256" r="28" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="256" y="256" text-anchor="middle" dominant-baseline="middle" font-size="18">30</text></g>
</svg>
```

### 4b. Ring Topology (Consistent Hashing / Distributed Nodes)

Use for distributed hashing partitions, leader election rings, or circular peer-to-peer relationships.

```html
<svg viewBox="0 0 400 400" role="img" aria-label="Consistent hashing ring distributes keys across three nodes">
  <!-- The Ring -->
  <circle cx="200" cy="200" r="120" fill="none" stroke="var(--line)" stroke-width="2" stroke-dasharray="6 6"/>
  <!-- Highlight region for N1 -->
  <path class="draw" style="--i:3" d="M 96 260 A 120 120 0 0 1 200 80" fill="none" stroke="var(--accent)" stroke-width="4"/>
  <!-- Node N1: Top -->
  <g class="pop" style="--i:0" transform="translate(200 80)">
    <circle cx="0" cy="0" r="28" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/>
    <text x="0" y="2" text-anchor="middle" dominant-baseline="middle" font-size="14" font-weight="bold" fill="var(--accent)">N1</text>
  </g>
  <!-- Node N2: Bottom Right -->
  <g class="pop" style="--i:1" transform="translate(304 260)">
    <circle cx="0" cy="0" r="28" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="0" y="2" text-anchor="middle" dominant-baseline="middle" font-size="14" font-weight="bold">N2</text>
  </g>
  <!-- Node N3: Bottom Left -->
  <g class="pop" style="--i:2" transform="translate(96 260)">
    <circle cx="0" cy="0" r="28" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="0" y="2" text-anchor="middle" dominant-baseline="middle" font-size="14" font-weight="bold">N3</text>
  </g>
  <!-- An incoming Key assignment -->
  <g class="pop pulse" style="--i:4" transform="translate(105 110)">
    <circle cx="0" cy="0" r="8" fill="var(--accent)"/>
    <text x="-12" y="-4" text-anchor="end" font-size="14" fill="var(--accent)" font-family="var(--mono)">Key K</text>
  </g>
  <text x="200" y="200" text-anchor="middle" dominant-baseline="middle" font-size="15" fill="var(--muted)">Hash Space</text>
</svg>
```

### 4c. Nested Boundaries / Containment Structure

Use for Virtual Machines, Docker containers, Kubernetes pods, sandbox isolation, or Domain-Driven Design bounding contexts.

```html
<svg viewBox="0 0 640 400" role="img" aria-label="A physical node hosts multiple pods, which contain application containers">
  <!-- Outer Boundary (e.g. Node) -->
  <rect style="--i:0" class="pop" x="40" y="40" width="560" height="320" rx="12" fill="var(--surface0)" stroke="var(--muted)" stroke-width="2" stroke-dasharray="6 6"/>
  <text style="--i:0" class="pop" x="60" y="70" font-size="14" fill="var(--muted)" font-family="var(--mono)" letter-spacing="0.1em" text-transform="uppercase">Physical Host Node</text>

  <!-- Level 2 Boundary: Pod A -->
  <g class="pop" style="--i:1" transform="translate(80 100)">
    <rect width="220" height="220" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="20" y="30" font-size="14" font-weight="bold">Pod A</text>
    
    <!-- Level 3 Boundary: Containers -->
    <rect class="pop" style="--i:2" x="20" y="50" width="180" height="70" rx="6" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/>
    <text class="pop" style="--i:2" x="110" y="85" text-anchor="middle" dominant-baseline="middle" font-size="16" fill="var(--accent)">App Container</text>

    <rect class="pop" style="--i:3" x="20" y="130" width="180" height="70" rx="6" fill="var(--surface0)" stroke="var(--line)" stroke-width="1.5"/>
    <text class="pop" style="--i:3" x="110" y="165" text-anchor="middle" dominant-baseline="middle" font-size="16">Sidecar</text>
  </g>

  <!-- Level 2 Boundary: Pod B -->
  <g class="pop" style="--i:4" transform="translate(340 100)">
    <rect width="220" height="120" rx="8" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <text x="20" y="30" font-size="14" font-weight="bold">Pod B</text>
    
    <rect class="pop" style="--i:5" x="20" y="50" width="180" height="50" rx="6" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/>
    <text class="pop" style="--i:5" x="110" y="75" text-anchor="middle" dominant-baseline="middle" font-size="16" fill="var(--accent)">Data Service</text>
  </g>
</svg>
```

### 4d. Schema / record relations (tables with fields)

Titled boxes with field rows, an accent arrow from the referencing field to the key it
points at. The linking field gets an accent-soft highlight. Arrow label at most 8
characters (`FK`); the full relation goes in the figcaption. Max 3 boxes; a wider
schema is about a sub-relation.

```html
<svg viewBox="0 0 640 280" role="img" aria-label="Orders reference users through user_id">
  <defs>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <g class="pop" style="--i:0" transform="translate(48 56)">
    <rect width="192" height="152" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <line x1="0" y1="40" x2="192" y2="40" stroke="var(--line)" stroke-width="1.5"/>
    <text x="96" y="20" text-anchor="middle" dominant-baseline="middle" font-size="16" font-weight="600">users</text>
    <rect x="8" y="52" width="176" height="26" rx="4" fill="var(--accent-soft)"/>
    <text x="20" y="65" dominant-baseline="middle" font-size="14">id</text>
    <text x="20" y="97" dominant-baseline="middle" font-size="14" fill="var(--muted)">email</text>
    <text x="20" y="127" dominant-baseline="middle" font-size="14" fill="var(--muted)">created_at</text>
  </g>
  <g class="pop" style="--i:1" transform="translate(400 56)">
    <rect width="192" height="152" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/>
    <line x1="0" y1="40" x2="192" y2="40" stroke="var(--line)" stroke-width="1.5"/>
    <text x="96" y="20" text-anchor="middle" dominant-baseline="middle" font-size="16" font-weight="600">orders</text>
    <text x="20" y="65" dominant-baseline="middle" font-size="14" fill="var(--muted)">id</text>
    <rect x="8" y="84" width="176" height="26" rx="4" fill="var(--accent-soft)"/>
    <text x="20" y="97" dominant-baseline="middle" font-size="14">user_id</text>
    <text x="20" y="127" dominant-baseline="middle" font-size="14" fill="var(--muted)">amount</text>
  </g>
  <path class="draw" style="--i:2" d="M408 153 H320 V121 H244" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <text x="322" y="107" text-anchor="middle" font-size="14" fill="var(--muted)">FK</text>
</svg>
```

## 5. Options compared (Matrix)

```html
<table class="matrix">
  <thead><tr><th></th><th>Latency</th><th>Durability</th><th>Ops cost</th></tr></thead>
  <tbody>
    <tr style="--i:0"><th>Sync replication</th><td>✗ high</td><td>✓</td><td>✓</td></tr>
    <tr style="--i:1" class="chosen"><th>Async + WAL</th><td>✓ low</td><td>✓</td><td>✓</td></tr>
    <tr style="--i:2"><th>Fire and forget</th><td>✓ low</td><td>✗</td><td>✓</td></tr>
  </tbody>
</table>
```

## 6. Memory / buffer layout & compaction

```html
<div class="cells row">
  <div class="cell">crc</div><div class="cell">tstamp</div><div class="cell">ksz</div><div class="cell on">vsz</div>
  <div class="cell var">key</div><div class="cell var">value</div>
</div>
```

### 6b. Heatmap cells (intensity across a grid)

Load skew, hot shards, cache hit patterns. Three intensity steps of the one accent hue
(`heat-1` faint → `heat-3` hot); a cold cell stays plain. **Static** — the skew is
evidence, not a mechanism. Fix the column count to the grid the post describes; label
cells only if the post names them.

```html
<div class="cells" style="grid-template-columns: repeat(8, minmax(2.75rem, 1fr));">
  <div class="cell heat-1">s0</div><div class="cell">s1</div><div class="cell heat-2">s2</div><div class="cell heat-3">s3</div>
  <div class="cell heat-3">s4</div><div class="cell heat-1">s5</div><div class="cell">s6</div><div class="cell heat-1">s7</div>
</div>
```

## 7. Flowchart (decision)

```html
<svg viewBox="0 0 640 400" role="img" aria-label="A read checks the keydir before touching disk">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <g class="pop" style="--i:0" transform="translate(240 16)"><rect width="160" height="56" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="28" text-anchor="middle" dominant-baseline="middle" font-size="18">get(key)</text></g>
  <path id="f1" class="draw" style="--i:1" d="M320 72V120" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <g class="pop pulse" style="--i:2" transform="translate(240 124)"><path d="M80 0L160 40L80 80L0 40z" fill="var(--accent-soft)" stroke="var(--accent)" stroke-width="1.5"/><text x="80" y="40" text-anchor="middle" dominant-baseline="middle" font-size="16">in keydir?</text></g>
  <path id="f2" class="draw" style="--i:3" d="M240 164H128V232" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="176" y="154" text-anchor="middle" font-size="14" fill="var(--muted)">no</text>
  <path id="f3" class="draw" style="--i:3" d="M400 164H512V232" stroke="var(--accent)" stroke-width="1.5" fill="none" marker-end="url(#arr-a)"/>
  <text x="464" y="154" text-anchor="middle" font-size="14" fill="var(--muted)">yes</text>
  <g class="pop" style="--i:4" transform="translate(48 236)"><rect width="160" height="56" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="28" text-anchor="middle" dominant-baseline="middle" font-size="18">not found</text></g>
  <g class="pop" style="--i:4" transform="translate(432 236)"><rect width="160" height="56" rx="10" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="80" y="28" text-anchor="middle" dominant-baseline="middle" font-size="18">1 disk seek</text></g>
  <circle class="packet" r="5"><animateMotion dur="2.4s" repeatCount="indefinite" keyPoints="0;1" keyTimes="0;1"><mpath href="#f3"/></animateMotion></circle>
</svg>
```

## 8. State machine

```html
<svg viewBox="0 0 960 300" role="img" aria-label="A file moves from active to immutable to merged">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--muted)"/>
    </marker>
    <marker id="arr-a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0 0L10 5L0 10z" fill="var(--accent)"/>
    </marker>
  </defs>
  <g data-cycle="1400">
    <g class="pop" style="--i:0"><circle cx="160" cy="150" r="44" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="160" y="150" text-anchor="middle" dominant-baseline="middle" font-size="16">active</text></g>
    <g class="pop" style="--i:2"><circle cx="480" cy="150" r="44" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="480" y="150" text-anchor="middle" dominant-baseline="middle" font-size="16">immutable</text></g>
    <g class="pop" style="--i:4"><circle cx="800" cy="150" r="44" fill="var(--surface)" stroke="var(--line)" stroke-width="1.5"/><text x="800" y="150" text-anchor="middle" dominant-baseline="middle" font-size="16">merged</text></g>
  </g>
  <path class="draw" style="--i:1" d="M204 150H436" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="318" y="136" text-anchor="middle" font-size="14" fill="var(--muted)">size &gt; limit</text>
  <path class="draw" style="--i:3" d="M524 150H756" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="638" y="136" text-anchor="middle" font-size="14" fill="var(--muted)">compaction</text>
  <path class="draw" style="--i:1" d="M136 108C112 48 208 48 184 106" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr)"/>
  <text x="160" y="52" text-anchor="middle" font-size="14" fill="var(--muted)">put()</text>
</svg>
```

## 9. Timeline (history, phases over time)

```html
<svg viewBox="0 0 960 200" role="img" aria-label="Three generations of the storage engine">
  <line class="draw" x1="80" y1="110" x2="880" y2="110" stroke="var(--line)" stroke-width="1.5"/>
  <g class="pop" style="--i:1"><circle cx="160" cy="110" r="8" fill="var(--muted)"/><text x="160" y="80" text-anchor="middle" font-size="16">B-tree</text><text x="160" y="146" text-anchor="middle" font-size="14" fill="var(--muted)">2016</text></g>
  <g class="pop" style="--i:2"><circle cx="480" cy="110" r="8" fill="var(--muted)"/><text x="480" y="80" text-anchor="middle" font-size="16">LSM</text><text x="480" y="146" text-anchor="middle" font-size="14" fill="var(--muted)">2019</text></g>
  <g class="pop" style="--i:3"><circle cx="800" cy="110" r="10" fill="var(--accent)"/><text x="800" y="80" text-anchor="middle" font-size="16">Bitcask</text><text x="800" y="146" text-anchor="middle" font-size="14" fill="var(--muted)">2022</text></g>
</svg>
```

## 10. Making a diagram move

Every diagram that shows a *mechanism* animates continuously while on screen:

**Packet** -- a dot travelling along an arrow:
```html
<circle class="packet" r="5">
  <animateMotion dur="1.8s" repeatCount="indefinite" begin="0.3s"><mpath href="#p1"/></animateMotion>
</circle>
```

**Pulse & Glow** -- `class="pulse"` or `class="pulse-glow"` on the active component.

**Cycle** -- `data-cycle="900"` on a parent; its children take `.lit` in turn.

**Streaming channel** -- `class="stream-channel"` or `class="flowing"` on continuous pipeline paths.
