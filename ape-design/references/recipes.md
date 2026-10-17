# Array UI Production Recipes

Use these recipes to scaffold pages and layouts without guessing. Every recipe is 100% component and token driven with **0% Custom CSS**.

---

## 1. Font Enforcement & Root Layout Recipe

### In Next.js (App Router `app/layout.tsx` & `app/globals.css`):

```css
/* app/globals.css */
@import url("https://fonts.googleapis.com/css2?family=Assistant:wght@400;500;600;700;800&family=IBM+Plex+Mono:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Lora:ital,wght@0,400..700;1,400..700&display=swap");

@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  body {
    background-color: var(--background);
    color: var(--foreground);
    font-family: var(--font-sans, "Assistant", -apple-system, sans-serif);
    -webkit-font-smoothing: antialiased;
  }
}
```

```tsx
// app/layout.tsx
import "@/app/globals.css";
import { ThemeScript } from "@/components/ui/theme-script";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <ThemeScript fonts />
      </head>
      <body className="font-sans bg-background text-foreground min-h-screen">
        {children}
      </body>
    </html>
  );
}
```

---

## 2. PageShell & Global Navigation Recipe

Wrap every page in `<PageShell>` to eliminate layout guessing and guarantee centered 6xl max-width with proper hairline boundaries.

```tsx
import { PageShell } from "@/components/ui/page-shell";
import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Tooltip } from "@/components/ui/tooltip";
import { PingStatus } from "@/components/ui/ping-status";
import { ThemeToggle } from "@/components/ui/theme-toggle";
import { SocialPill } from "@/components/ui/social-pill";

const navLinks = [
  { label: "Systems", href: "/systems" },
  { label: "Architecture", href: "/architecture" },
  { label: "Writings", href: "/writings" },
  { label: "Docs", href: "/docs" },
];

const footerColumns = [
  {
    heading: "Systems",
    links: [
      { label: "Consensus Engine", href: "/systems/consensus", hint: "Raft" },
      { label: "Storage Engine", href: "/systems/storage", hint: "LSM" },
      { label: "Distributed WAL", href: "/systems/wal" },
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
      { label: "GitHub Repository", href: "https://github.com", external: true },
      { label: "Architecture RFCs", href: "/rfcs" },
      { label: "Changelog", href: "/changelog" },
    ],
  },
];

export function LayoutShell({ children }: { children: React.ReactNode }) {
  return (
    <PageShell
      navbar={
        <Navbar
          brandName="VectorMesh"
          brandHref="/"
          links={navLinks}
          statusIndicator={
            <Tooltip content="All 16 quorum nodes operational · p99 < 12ms">
              <PingStatus status="operational" label="99.99% Live" size="sm" />
            </Tooltip>
          }
          actions={
            <div className="flex items-center gap-2">
              <Tooltip content="Toggle dark / light mode">
                <ThemeToggle variant="ghost" size="sm" />
              </Tooltip>
              <Tooltip content="Inspect open-source source code">
                <Button variant="secondary" size="sm" href="https://github.com" target="_blank">
                  GitHub
                </Button>
              </Tooltip>
              <Tooltip content="Deploy isolated sandbox cluster">
                <Button variant="primary" size="sm">
                  Deploy Cluster
                </Button>
              </Tooltip>
            </div>
          }
        />
      }
      footer={
        <Footer
          columns={footerColumns}
          disclaimer="VectorMesh is an open-source distributed log replication engine built for zero-copy streaming workloads. MIT Licensed."
          copyright={`© ${new Date().getFullYear()} VectorMesh. Built for systems engineers.`}
          socialPills={
            <>
              <Tooltip content="Watch architectural deep-dives on YouTube">
                <SocialPill platform="youtube" href="https://youtube.com" count="210k" />
              </Tooltip>
              <Tooltip content="Follow engineering updates on X">
                <SocialPill platform="twitter" href="https://twitter.com" count="120k" />
              </Tooltip>
              <Tooltip content="Star the project on GitHub">
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

---

## 3. High-Converting Technical Landing Page Recipe

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
      {/* 1. Announcement Nudge Ribbon */}
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
