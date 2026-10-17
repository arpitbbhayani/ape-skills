---
name: ape-design
description: >-
  Enforces the Array UI (array-ui) editorial systems design system for any frontend,
  UI, website, blog, personal site, SaaS dashboard, or documentation development task.
  Trigger on "ape design", "Array UI", or whenever building, styling, or scaffolding UI
  to guarantee high information density, mathematical precision, editorial typography,
  and 0% custom CSS without prompt loops.
---

# `ape-design`: Editorial Systems Design Skill (Array UI)

This skill enforces strict adherence to **Array UI (`array-ui`)**—the editorial, systems-engineering design system inspired by [arpitbhayani.me](https://arpitbhayani.me) and distributed at [ui.arpitbhayani.me](https://ui.arpitbhayani.me).

When building or modifying any website (personal portfolio, engineering blog, SaaS dashboard, technical documentation, or systems explainer), the agent **MUST** follow this workflow and rules without requiring prompt corrections.

---

## 1. The 6 Non-Negotiable Prime Invariants

### Invariant 1: Mandatory Font Enforcement (DO THIS FIRST)
> [!IMPORTANT]
> **Before creating or editing any components, the agent MUST verify that Google Fonts are loaded and applied to `body`.**
> If fonts are missing, the UI will fall back to system sans-serif (Arial/Inter), completely breaking the editorial authority.
>
> 1. **Google Fonts URL**:
>    `https://fonts.googleapis.com/css2?family=Assistant:wght@400;500;600;700;800&family=IBM+Plex+Mono:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Lora:ital,wght@0,400..700;1,400..700&display=swap`
> 2. **In `globals.css`** (or main CSS):
>    ```css
>    @import url("https://fonts.googleapis.com/css2?family=Assistant:wght@400;500;600;700;800&family=IBM+Plex+Mono:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Lora:ital,wght@0,400..700;1,400..700&display=swap");
>    
>    body {
>      font-family: var(--font-sans, "Assistant", -apple-system, sans-serif);
>      -webkit-font-smoothing: antialiased;
>    }
>    ```
> 3. **Or in root layout `<head>`**: Include `<ThemeScript fonts />` from `@aui/theme-script`.

### Invariant 2: 0% Custom CSS Rule
> [!CAUTION]
> **Custom CSS proportion MUST REMAIN 0% AT ALL TIMES.**
> - **NEVER** create custom `.css` files.
> - **NEVER** write `<style>` blocks or style tags in `.astro`, `.tsx`, `.jsx`, or `.html` files.
> - **NEVER** inject arbitrary ad-hoc inline styles for margins, paddings, colors, or shadows.
> - All layout, typography, blank spacing, telemetry, and interactive controls **MUST** be composed exclusively using native Array UI components (`PageShell`, `Navbar`, `Footer`, `Card`, `Button`, `Table`, `Badge`, `Terminal`, `PingStatus`, `DiffBlock`, `Gutter`, `Layout`, etc.) and system utility classes (`.aui-grid`, `.aui-stack`, `.aui-row`, `.aui-container`).

### Invariant 3: Frame Every Page in `<PageShell>`
Never hand-roll outer page containers or guess margin widths. Wrap every full page in:
```tsx
<PageShell navbar={<Navbar ... />} footer={<Footer ... />}>
  {/* Page content */}
</PageShell>
```
`PageShell` (`@aui/page-shell`) automatically provides a centered `max-w-6xl` column, proper horizontal padding, full viewport height (`min-h-screen flex flex-col`), and clean baseline typography.

### Invariant 4: Editorial Footer Discipline
The footer must match [arpitbhayani.me](https://arpitbhayani.me) exactly:
- **Canvas**: Flat paper (`#faf9f5`) or obsidian carbon (`#111113`) canvas (`bg-background`). Never use floating tinted card backgrounds (`bg-card/60`) for the footer.
- **Hairlines**: Exactly 1px `border-t border-border` on top, and `border-t border-border/70` separating disclaimer and bottom bar.
- **Link Layout**: Links are inline items (`inline-flex items-center gap-1.5`) with hover crimson (`text-primary`) and subtle `translate-x-0.5`. Hints are rendered inline in subtle monospace (`text-[11px] font-mono text-muted-foreground/60` like `Projects (Open-source)`). **NEVER** use `justify-between` with boxed badge pills stretching across the column.
- **Bottom Bar**: Copyright on the left, tactile `<SocialPill>`s with tooltips on the right.

### Invariant 5: Wrap Every Action & Status in `<Tooltip>`
- Every action button, icon trigger, theme toggle, copy button, and `<PingStatus>` **MUST** be wrapped in a `<Tooltip content="...">`.
- Communicate consequence, keyboard shortcuts, or live telemetry facts (e.g. `<Tooltip content="Toggle dark / light mode (⌘D)">`).

### Invariant 6: Anti-Card-Soup & Visual Rhythm
- **NEVER** stack identical layout blocks consecutively (e.g. never place two 3-card grids in a row, or three identical text callouts sequentially).
- **Alternate visual weight**: Pair dense, machined telemetry (`Terminal`, `DiffBlock`, `ParamTable`, `PropertyGrid`) with airy, editorial moments (`Maxim`, pull quotes, `<Gutter size="xl" />`, `TakeawaysBox`).
- **Use asymmetric composition**: Prefer 2-column asymmetric splits (`SplitPane`, 60/40 hero-to-terminal layouts) over monotonous symmetric grids.

---

## 2. Palette & Visual Standards

1. **Editorial Palette**:
   - **Light mode**: Paper canvas (`#faf9f5`), warm hairline borders (`#dfded9`), dark carbon text (`#2b2a30`).
   - **Dark mode**: Obsidian carbon (`#111113`), crisp border (`#27272c`), soft readable white (`#d6d6dc`).
   - **Signature Crimson (`#e5000f` in light, `#ff3344` in dark)**: Reserved strictly for primary action buttons, active navigation indicators, and key focus rings.
   - **Amber (`#cc9900`)**: Used exclusively for engineering maxim quotes, philosophy callouts, and warning banners.
   - **Emerald (`#10b981`)**: Used for operational health, ping dots, uptime, and git diff additions.
   - **Rose (`#f43f5e`)**: Used for errors, outages, and git diff deletions.

2. **Typography**:
   - Headings & Body: `Assistant` (dense, disciplined, 15px base size, tracking `-0.015em` on headings).
   - Pull Quotes / Maxims: `Lora` (italic serif).
   - Code & Telemetry: `IBM Plex Mono` / system monospace.

3. **Restraint & Elevation**:
   - **1px hairline borders** everywhere.
   - Flat, tinted card surfaces (`bg-muted/30` or `var(--aui-bg-secondary)`).
   - Zero heavy drop shadows.

---

## 3. Installation & Autonomous Execution

The agent **MUST NOT** ask the user which components to install. Autonomously inspect what is needed and run:

### Mode A: shadcn CLI (Recommended for Next.js, Vite, Tailwind)
1. Add registry to `components.json`:
   ```json
   {
     "$schema": "https://ui.shadcn.com/schema.json",
     "style": "default",
     "registries": {
       "@aui": "https://ui.arpitbhayani.me/r/{name}.json"
     }
   }
   ```
2. Install theme & base layer:
   ```bash
   npx shadcn@latest add @aui/aui -y
   ```
3. Install required components autonomously with `-y`:
   ```bash
   npx shadcn@latest add @aui/page-shell @aui/navbar @aui/footer @aui/button @aui/badge @aui/card @aui/terminal @aui/diff-block @aui/ping-status @aui/tooltip @aui/gutter @aui/layout -y
   ```

### Mode B: Direct Package Dependency (Next.js, Astro)
```bash
npm install array-ui
```
Import styles in root layout:
```tsx
import "array-ui/styles.css";
```

---

## 4. Production Layout Recipes

### Recipe 1: PageShell & Global Navigation Scaffold
```tsx
import { PageShell } from "@/components/ui/page-shell";
import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Tooltip } from "@/components/ui/tooltip";
import { PingStatus } from "@/components/ui/ping-status";
import { ThemeToggle } from "@/components/ui/theme-toggle";
import { SocialPill } from "@/components/ui/social-pill";

export function SiteShell({ children }: { children: React.ReactNode }) {
  return (
    <PageShell
      navbar={
        <Navbar
          brandName="VectorMesh"
          brandHref="/"
          links={[
            { label: "Architecture", href: "/architecture" },
            { label: "Telemetry", href: "/telemetry" },
            { label: "Writings", href: "/writings" },
            { label: "Docs", href: "/docs" },
          ]}
          statusIndicator={
            <Tooltip content="All 16 quorum nodes operational · p99 < 12ms">
              <PingStatus status="operational" label="99.99% Live" size="sm" />
            </Tooltip>
          }
          actions={
            <div className="flex items-center gap-2">
              <Tooltip content="Toggle theme (⌘D)">
                <ThemeToggle variant="ghost" size="sm" />
              </Tooltip>
              <Tooltip content="Launch interactive browser cluster">
                <Button variant="primary" size="sm">
                  Deploy
                </Button>
              </Tooltip>
            </div>
          }
        />
      }
      footer={
        <Footer
          columns={[
            {
              heading: "Engine",
              links: [
                { label: "Consensus", href: "/consensus", hint: "Raft" },
                { label: "Storage Engine", href: "/storage", hint: "LSM" },
                { label: "WAL", href: "/wal" },
              ],
            },
            {
              heading: "Resources",
              links: [
                { label: "Documentation", href: "/docs" },
                { label: "API Reference", href: "/api", hint: "v2.4" },
                { label: "Benchmarks", href: "/benchmarks" },
              ],
            },
            {
              heading: "Open Source",
              links: [
                { label: "GitHub", href: "https://github.com", external: true },
                { label: "RFCs", href: "/rfcs" },
                { label: "Changelog", href: "/changelog" },
              ],
            },
          ]}
          disclaimer="VectorMesh is an open-source distributed log replication engine built for zero-copy streaming workloads. MIT Licensed."
          copyright={`© ${new Date().getFullYear()} VectorMesh. Built for curious engineers.`}
          socialPills={
            <>
              <Tooltip content="Watch deep-dives on YouTube">
                <SocialPill platform="youtube" href="https://youtube.com" count="210k" />
              </Tooltip>
              <Tooltip content="Follow engineering on X">
                <SocialPill platform="twitter" href="https://twitter.com" count="120k" />
              </Tooltip>
              <Tooltip content="Star on GitHub">
                <SocialPill platform="github" href="https://github.com" count="7k" />
              </Tooltip>
            </>
          }
        />
      }
    >
      {children}
    </PageShell>
  );
}
```

### Recipe 2: High-Converting Technical Landing Page
```tsx
import { Gutter } from "@/components/ui/gutter";
import { Container, Stack, Row, Grid } from "@/components/ui/layout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Terminal } from "@/components/ui/terminal";
import { Maxim } from "@/components/ui/maxim";
import { Tooltip } from "@/components/ui/tooltip";
import { StatCard } from "@/components/ui/stat-card";

export default function LandingPage() {
  return (
    <Stack gap="xl">
      {/* 1. Top Announcement Nudge */}
      <Row justify="start">
        <Tooltip content="Read the v2.4 zero-copy streaming benchmark report">
          <Badge variant="amber" interactive href="/changelog">
            v2.4 Released: Zero-copy disk streaming engine is live →
          </Badge>
        </Tooltip>
      </Row>

      {/* 2. Hero Proposition */}
      <Stack gap="md" className="max-w-3xl">
        <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold font-heading tracking-tight leading-[1.08]">
          Deterministic consensus at <span className="text-primary">hardware speed</span>.
        </h1>
        <p className="text-lg text-muted-foreground leading-relaxed font-sans">
          A high-density distributed write-ahead log with strict Raft quorum, zero GC pauses, and sub-millisecond p99 replication latency.
        </p>

        {/* Action CTAs wrapped in Tooltips */}
        <Row gap="sm" align="center" wrap>
          <Tooltip content="Launches live interactive telemetry cluster (zero signup required)">
            <Button variant="primary" size="lg">
              Launch Sandbox Quorum
            </Button>
          </Tooltip>
          <Tooltip content="Read architectural whitepaper and formal TLA+ proofs">
            <Button variant="secondary" size="lg">
              Read Architecture RFC →
            </Button>
          </Tooltip>
        </Row>

        {/* Friction-Reduction Reassurance Nudge Row */}
        <Row gap="xs" align="center" wrap>
          <Badge variant="secondary">Zero external dependencies</Badge>
          <Badge variant="green">Apache 2.0</Badge>
          <Badge variant="blue">Single static binary</Badge>
          <Badge variant="secondary">Sub-10ms failover</Badge>
        </Row>
      </Stack>

      <Gutter size="md" />

      {/* 3. The Live Mechanical Proof (Terminal Breakout) */}
      <Terminal
        title="~/vectormesh (cluster: eu-west-1)"
        lines={[
          "vmesh cluster bootstrap --peers 3 --wal-dir /data/wal",
          { text: "✔ Node 1 [Leader]: Quorum established (term=42, index=108420)", kind: "ok" },
          { text: "✔ Node 2 [Follower]: Log synchronized in 0.84ms", kind: "ok" },
          { text: "✔ Node 3 [Follower]: Heartbeat acknowledged, fsync verified", kind: "ok" },
          { text: "Cluster status: HEALTHY · Throughput: 420,000 ops/sec", kind: "out" },
        ]}
      />

      <Gutter size="lg" />

      {/* 4. Concrete Metric Pillars */}
      <Grid cols={3} gap="md">
        <StatCard value="420k" label="ops / second" description="sustained write throughput" accent="emerald" />
        <StatCard value="0.84ms" label="p99 replication" description="cross-region Raft quorum" accent="blue" />
        <StatCard value="Zero" label="memory allocations" description="ring-buffer page cache" accent="rose" />
      </Grid>

      <Gutter size="lg" />

      {/* 5. Asymmetric Deep-Dive Cards */}
      <Grid cols={2} gap="lg">
        <Card hoverable>
          <CardHeader>
            <Badge variant="violet" className="w-fit mb-2">Storage Engine</Badge>
            <CardTitle>Memory-Mapped Append Log</CardTitle>
          </CardHeader>
          <CardContent className="text-muted-foreground text-sm leading-relaxed">
            Direct I/O bypasses OS page cache jitter. Writes are sequentially appended to 64MB pre-allocated segments with hardware-enforced crc32 checksum verification.
          </CardContent>
        </Card>

        <Card hoverable>
          <CardHeader>
            <Badge variant="cyan" className="w-fit mb-2">Consensus</Badge>
            <CardTitle>Pipelined Raft Replication</CardTitle>
          </CardHeader>
          <CardContent className="text-muted-foreground text-sm leading-relaxed">
            Entries are optimistically transmitted to quorum followers in lock-free ring buffers while the leader executes fsync concurrently, eliminating network round-trip bottlenecks.
          </CardContent>
        </Card>
      </Grid>

      <Gutter size="lg" />

      {/* 6. Engineering Maxim Quote */}
      <Maxim author="Arpit Bhayani" source="Asli Engineering">
        Simplicity is a prerequisite for reliability. Complex systems fail in complex, unexpected ways.
      </Maxim>
    </Stack>
  );
}
```

---

## 5. Self-Audit Checklist (Verify Before Concluding)

Before declaring any UI task done, the agent **MUST** verify every item:
- [ ] **Fonts Enforced**: Google Fonts (`Assistant`, `IBM Plex Mono`, `Lora`) loaded in `globals.css` or `<head>`, and `body { font-family: var(--font-sans) }` active.
- [ ] **0% Custom CSS**: Zero `.css` files created, zero `<style>` blocks written, zero ad-hoc margin/padding styles.
- [ ] **PageShell Enforced**: Screen is framed in `<PageShell>` with centered `max-w-6xl` bounds.
- [ ] **Footer Editorial**: Footer is flat on `bg-background` with hairline border, inline links with `(hint)`, and social pills.
- [ ] **Tooltips Wrapped**: Every action button, theme toggle, copy button, and `<PingStatus>` has a `<Tooltip>`.
- [ ] **Visual Rhythm**: No consecutive stacks of identical cards; telemetry breakouts and maxims alternate with prose.
