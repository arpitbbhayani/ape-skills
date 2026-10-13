---
name: ape-design
description: >-
  Enforces the Array UI (array-ui) editorial systems design system for any frontend,
  UI, website, blog, personal site, SaaS dashboard, or documentation development task.
  Trigger on "ape design", "Array UI", or whenever building, styling, or scaffolding UI
  to guarantee high information density, mathematical precision, editorial typography,
  and 0% custom CSS.
---

# `ape-design`: Editorial Systems Design Skill (Array UI)

This skill enforces strict adherence to **Array UI (`array-ui`)**—the editorial, systems-engineering design system from [ui.arpitbhayani.me](https://ui.arpitbhayani.me).

When building or modifying any website (personal portfolio, engineering blog, SaaS dashboard, technical documentation, or systems explainer), the agent **MUST** follow this design system without exception.

---

## 1. Prime Directive: The 0% Custom CSS Invariant

> [!CAUTION]
> **Custom CSS proportion MUST REMAIN 0% AT ALL TIMES.**
> - **NEVER** create custom `.css` files.
> - **NEVER** write `<style>` blocks or style tags in `.astro`, `.tsx`, `.jsx`, or `.html` files.
> - **NEVER** inject arbitrary ad-hoc inline styles for margins, paddings, colors, or shadows.
> - All layout, typography, blank spacing, telemetry, and interactive controls **MUST** be composed exclusively using native Array UI components (`Card`, `Button`, `Table`, `Badge`, `Terminal`, `PingStatus`, `DiffBlock`, `Gutter`, `Layout`, etc.) and system utility classes (`.aui-grid`, `.aui-stack`, `.aui-row`, `.aui-container`).

---

## 2. LLM-Friendly Endpoints & Context Sources

The website [ui.arpitbhayani.me](https://ui.arpitbhayani.me) provides dedicated endpoints structured specifically for LLMs and autonomous coding agents:

- **Registry Index**: `https://ui.arpitbhayani.me/r/registry.json`
- **Standard Context**: `https://ui.arpitbhayani.me/llms.txt`
- **Full API Specification**: `https://ui.arpitbhayani.me/llms-full.txt`
- **Component Schema**: `https://ui.arpitbhayani.me/r/{name}.json` (e.g. `https://ui.arpitbhayani.me/r/terminal.json`, `https://ui.arpitbhayani.me/r/diff-block.json`)

When an unfamiliar component API or props schema is needed, read `https://ui.arpitbhayani.me/r/{name}.json` or reference `llms-full.txt`.

---

## 3. Two Installation Modes

The agent must autonomously detect whether the project uses **shadcn/ui registry** or a **direct npm package**.

### Mode A: shadcn CLI Registry (Recommended for Next.js, Vite, Tailwind)

No npm package required. Components are installed directly into the project:

1. Configure `components.json`:
   ```json
   {
     "$schema": "https://ui.shadcn.com/schema.json",
     "style": "default",
     "registries": {
       "@aui": "https://ui.arpitbhayani.me/r/{name}.json"
     }
   }
   ```

2. Install core design tokens:
   ```bash
   npx shadcn@latest add @aui/aui -y
   ```

3. Autonomously install needed components with `-y` (do not prompt the user):
   ```bash
   npx shadcn@latest add @aui/button @aui/badge @aui/card @aui/terminal @aui/diff-block @aui/ping-status @aui/gutter @aui/layout -y
   ```

Components are imported from `@/components/ui/*`:
```tsx
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Terminal } from "@/components/ui/terminal";
import { DiffBlock } from "@/components/ui/diff-block";
import { PingStatus } from "@/components/ui/ping-status";
import { Gutter } from "@/components/ui/gutter";
import { Container, Stack, Row, Grid } from "@/components/ui/layout";
```

### Mode B: Direct Package Dependency (Next.js, Astro)

1. Install `array-ui`:
   ```bash
   npm install array-ui
   # or: pnpm add array-ui / bun add array-ui
   ```

2. Import styles in root layout (`layout.tsx`, `_app.tsx`, or `Layout.astro`):
   ```tsx
   import "array-ui/styles.css";
   ```

3. Import components:
   ```tsx
   // Next.js (App Router or Pages Router)
   import { Button, Terminal, DiffBlock, PingStatus, Card, Gutter, Layout } from "array-ui/nextjs";

   // Astro (zero client-JS overhead)
   import Terminal from "array-ui/astro/Terminal.astro";
   import DiffBlock from "array-ui/astro/DiffBlock.astro";
   import PingStatus from "array-ui/astro/PingStatus.astro";
   import Gutter from "array-ui/astro/Gutter.astro";
   ```

---

## 4. Visual Language & Aesthetic Rules

1. **Editorial Palette**:
   - **Light mode**: Paper canvas (`#f9f8f5`), warm hairline borders (`#dfded9`), dark carbon text (`#2b2a30`).
   - **Dark mode**: Obsidian carbon (`#111113`), crisp border (`#27272c`), soft readable white (`#d6d6dc`).
   - **Signature Crimson (`#e5000f` in light, `#e60012` in dark)**: Reserved strictly for primary action buttons, active navigation indicators, and key focus rings.
   - **Amber (`#cc9900`)**: Used exclusively for engineering maxim quotes, philosophy callouts, and warning banners.
   - **Emerald (`#10b981`)**: Used for operational health, ping dots, uptime, and git diff additions.
   - **Rose (`#f43f5e`)**: Used for errors, outages, and git diff deletions.

2. **Typography**:
   - Headings & Body: `Assistant` (dense, disciplined, 15px base size, tracking `-0.015em`).
   - Pull Quotes / Maxims: `Lora` (italic serif).
   - Code & Telemetry: `IBM Plex Mono` / system monospace.

3. **Density & Restraint**:
   - **1px hairline borders** everywhere.
   - Flat, tinted card surfaces (`bg-muted/30` or `var(--aui-bg-secondary)`).
   - **Zero arbitrary gradients, neon colors, or rounded bouncy buttons.**
   - Eliminate external CSS margin/padding hacks:
     - Use `<Gutter size="md" />` for spacing between sections and elements.
     - Use `<Container>`, `<Stack>`, `<Row>`, `<Grid>` from `@aui/layout` for structural alignment.

---

## 5. Component Catalog & Mapping

Use this guide to select the exact Array UI component for every UI requirement:

### Core UI & Action Primitives
- **`Button`** (`@aui/button`): Tactile action button. Variants: `primary` (crimson), `secondary`, `outline`, `ghost`, `destructive`. Supports `icon`, `leftIcon`, `rightIcon`, `loading`.
- **`Badge`** (`@aui/badge`): Machined status pill with monospace typography. Variants: `primary`, `green`, `amber`, `red`, `blue`, `violet`, `cyan`, `pink`. Supports `href` and `interactive`.
- **`Card`** (`@aui/card`): Flat card with hairline border. Subcomponents: `CardHeader`, `CardTitle`, `CardDescription`, `CardContent`, `CardFooter`. Props: `hoverable`, `interactive`.
- **`Input`** (`@aui/input`): Machined text input with subtle focus ring and optional keyboard shortcut badge (`shortcut="⌘K"`).
- **`Kbd`** (`@aui/kbd`): Machined monospace keyboard keycap. E.g. `<Kbd keys={["⌘", "K"]} />`.
- **`Tooltip`** (`@aui/tooltip`): Hover/focus accessible hint.
- **`Alert`** (`@aui/alert`): Status-tinted inline callout (`warning`, `info`, `destructive`).
- **`Tabs`** (`@aui/tabs`): Underline tab navigation (`TabsList`, `TabsTrigger`, `TabsContent`).
- **`Accordion`** (`@aui/accordion`): Collapsible hairline sections.
- **`Gutter` / `Spacer`** (`@aui/gutter`): Whitespace blank spacing component. Sizes: `xs` (8px), `sm` (12px), `md` (24px, default), `lg` (36px), `xl` (48px), `2xl` (72px). Orientations: `vertical` (default), `horizontal`.
- **`Progress`** (`@aui/progress`): Machined linear progress bar with value indicator.
- **`SplitPane`** (`@aui/split-pane`): Two-column responsive layout with sticky aside column and mobile stacking.
- **`Layout`** (`@aui/layout`): Primitives `Container`, `Stack`, `Row`, `Grid` to compose layouts without ad-hoc CSS.
- **`Typography`** (`@aui/typography`): Editorial typography (`Heading`, `Lead`).
- **`StepNav`** (`@aui/step-nav`): Walkthrough/tutorial navigation bar with position counter and next/prev controls.
- **`ThemeToggle`** (`@aui/theme-toggle`) & **`ThemeScript`** (`@aui/theme-script`): Dark/light switch with automated Google Font preconnecting.

### Developer & Telemetry Primitives
- **`Terminal`** (`@aui/terminal`): Machined telemetry terminal with bash command dots and styled outputs (`kind: "cmd" | "out" | "ok" | "err"`).
- **`DiffBlock`** (`@aui/diff-block`): Unified git patch inspector with line gutters, additions, deletions, word-level highlights, and header badges.
- **`PingStatus`** (`@aui/ping-status`): Pulsing heartbeat indicator (`operational`, `degraded`, `outage`, `maintenance`) with latency label.
- **`PropertyGrid`** (`@aui/property-grid`): Dense key-value metadata inspector with one-click copy.
- **`FileTree`** (`@aui/file-tree`): Collapsible directory and file hierarchy tree.
- **`PackageManager`** (`@aui/package-manager`): Multi-manager install command switcher (`pnpm`, `npm`, `bun`, `yarn`) with instant click-to-copy.
- **`StatCard`** (`@aui/stat-card`): Metric display card with optional accents (`emerald`, `rose`, `amber`, `blue`).

### Editorial & Content Primitives
- **`Maxim`** (`@aui/maxim`): Amber quotation callout box for engineering principles.
- **`TakeawaysBox`** (`@aui/takeaways-box`): Crimson bulleted key takeaways box.
- **`Hero`** (`@aui/hero`): Editorial portrait hero with bio, tagline, and social pills.
- **`SocialPill`** (`@aui/social-pill`): Platform pills for YouTube, X/Twitter, GitHub, LinkedIn.
- **`CourseCard`** (`@aui/course-card`): Card for cohorts, projects, and products with tags and CTA.
- **`EmptyState`** (`@aui/empty-state`): Minimalist dashed container for zero-data screens.
- **`Footer`** (`@aui/footer`): Editorial 4-column directory footer with category hints, disclaimer, and social pills.
- **`Navbar`** (`@aui/navbar`): Editorial navbar with brand, links, action buttons, and theme toggle.
- **`Modal`** (`@aui/modal`): Accessible dialog modal with backdrop blur.
- **`Dropdown`** (`@aui/dropdown`): Accessible action menu with keyboard escape support.

### Technical Documentation & Architecture
- **`ApiEndpoint`** (`@aui/api-endpoint`): HTTP/gRPC API specification block with method badges, copyable paths, parameters, and status response tabs.
- **`DocStepper`** (`@aui/doc-stepper`): Connected numbered step walkthrough for tutorials and runbooks.
- **`ParamTable`** (`@aui/param-table`): Dense configuration options and parameter reference table.
- **`FeatureMatrix`** (`@aui/feature-matrix`): Matrix comparison table with check/cross/partial indicators.
- **`VersionSelector`** (`@aui/version-selector`): Documentation version switcher.
- **`ArchitectureCanvas`** / **`Canvas`**: Systems topology and node-and-edge architecture diagrams.
- **`MemoryLayout`**: Byte/memory layout visualizer with offsets and field inspector.
- **`PipelineFlow`**: Multi-stage data pipeline flow visualizer with throughput metrics.
- **`BenchmarkDelta`**: Baseline vs candidate metric delta comparator.

---

## 6. Page Archetypes & Narrative User Journeys

Great technical websites are not a uniform stack of cards. They choreograph a deliberate user journey with rhythm, progressive disclosure, and clear visual anchors.

### The Law of Visual Rhythm (Anti-Card-Soup Invariant)
- **NEVER stack identical layout blocks consecutively** (e.g. never place two 3-card grids in a row, or three identical text callouts sequentially).
- **Alternate visual weight**: Pair dense, machined telemetry (`Terminal`, `DiffBlock`, `ParamTable`, `PropertyGrid`) with airy, editorial moments (`Maxim`, pull quotes, `<Gutter size="xl" />`, `TakeawaysBox`).
- **Use asymmetric composition**: Prefer 2-column asymmetric splits (`SplitPane`, 60/40 hero-to-terminal layouts) over monotonous symmetric grids.

---

### The Action Clarity & Tooltip Invariant (Wrap Every Action)

> [!IMPORTANT]
> **Every interactive control, action button, icon trigger, copy button, and status indicator MUST be wrapped in a `<Tooltip>` (`@aui/tooltip`).**
> - **Icon-Only Buttons**: NEVER leave an icon button bare. Wrap every theme toggle, GitHub link, copy icon, and menu toggle in `<Tooltip content="...">`. Include keyboard shortcuts where applicable (`<Tooltip content="Toggle theme (⌘D)">`).
> - **Primary & Secondary Action CTAs**: Wrap action buttons in tooltips that communicate consequence or expectation (`<Tooltip content="Launches interactive browser sandbox (zero signup required)">`).
> - **Telemetry & Status Dots**: Wrap `<PingStatus>` in a tooltip revealing concrete telemetry (`<Tooltip content="All 12 edge clusters operational · p99 latency < 14ms">`).
> - **Keycaps**: Pair shortcuts with tooltips explaining their trigger scope.

---

### Landing Page Nudges & Micro-Conversion Architecture

Technical users are allergic to empty marketing hype. On landing pages, use **tactile nudges**—subtle, high-signal cues that eliminate friction and demonstrate mechanical competence:

1. **Announcement & Version Nudge (Above Hero)**:
   - Place a compact, clickable badge ribbon above the main headline:
     ```tsx
     <Badge variant="amber" interactive href="/changelog">
       v2.4 Released: Zero-copy streaming engine now live →
     </Badge>
     ```
2. **Friction-Reduction Nudge Row (Below CTAs)**:
   - Directly underneath primary action buttons, place a `<Row>` of subtle, monospace reassurance badges:
     ```tsx
     <Row gap="sm" align="center">
       <Badge variant="secondary">Zero install</Badge>
       <Badge variant="green">Apache 2.0</Badge>
       <Badge variant="blue">Local-first</Badge>
       <Badge variant="secondary">Single static binary</Badge>
     </Row>
     ```
3. **Instant Command Copy Nudge**:
   - Provide an immediate copyable terminal snippet right beside the primary button with instant tactile copy feedback and `<Tooltip content="Copy command to clipboard">`.
4. **Live Telemetry & Social Proof Nudge**:
   - Ground credibility in live system facts rather than adjectives: `<PingStatus status="operational" label="99.99% Uptime" />` and exact operational statistics (`<StatCard accent="emerald" />`).
5. **Exploration Jump Nudge**:
   - A subtle anchor jump button guiding curious users directly to the mechanical proof:
     ```tsx
     <Tooltip content="Jump straight to live telemetry & interactive terminal">
       <Button variant="ghost" size="sm" icon="arrow-down">
         Inspect the live engine ↓
       </Button>
     </Tooltip>
     ```

---

### Archetype 1: Technical Landing & SaaS Product Page
Guide visitors from initial proposition directly into mechanical proof, feature depth, and clear action:

1. **Header / Navbar**: Brand, high-level navigation, live telemetry badge wrapped in `<Tooltip>` (`<PingStatus status="operational" />`), and primary Crimson CTA button wrapped in `<Tooltip>`.
2. **Hero Section with Nudges**: 
   - Top Announcement Nudge: Monospace clickable badge (`<Badge variant="amber" interactive>`).
   - Crisp one-line proposition in dense `Assistant` typography (`<Typography variant="h1">`).
   - One-sentence engineering summary.
   - Primary Crimson action button + secondary outline button, each wrapped in `<Tooltip>`.
   - Friction-Reduction Nudge Row: Monospace pills ("Zero install", "Apache 2.0", "Local-first").
3. **The Live Proof (Immediate Telemetry Breakout)**:
   - Place a live `<Terminal>` with runnable commands or a `<DiffBlock>` directly beneath the hero. Never make users scroll past fluff to see what the system actually does.
4. **Value Pillars (Asymmetric Grid)**:
   - 2-column or 3-column `<Card>` layout with hairline borders, monospace metric badges, and concrete performance stats (`<StatCard>`).
5. **Deep-Dive Mechanism / Architecture**:
   - Use `<SplitPane>` or `<DocStepper>` alongside `<PipelineFlow>` or `<ArchitectureCanvas>` to walk through how the engine functions under the hood.
6. **Engineering Maxim**:
   - An amber quote box (`<Maxim>`) highlighting the core design philosophy or invariant.
7. **Footer**: 
   - 4-column editorial directory (`<Footer>`) with license disclaimer, documentation links, and platform `<SocialPill>`s with tooltips.

---

### Archetype 2: Deep-Dive Engineering Blog / Technical Article
Transform technical writing into an authoritative, publication-grade reading experience:

1. **Header**: Minimal navbar with back navigation link, publication title, and `<ThemeToggle>` wrapped in `<Tooltip>`.
2. **Editorial Meta Header**:
   - Monospace topic badges (`<Badge>`), publication date, reading time, and system version.
   - Article title in `Assistant` font with subtle negative tracking.
   - Lead paragraph: 2-sentence crisp thesis statement set in editorial lead typography.
3. **Rhythmic Narrative Flow (The Reading Spine)**:
   - **Prose Section**: Clean, focused paragraphs capped near 70ch.
   - `<Gutter size="lg" />`
   - **Mechanical Evidence**: Break prose with a `<Terminal>` showing live output, a `<DiffBlock>` showing code changes, or a `<PropertyGrid>` for configuration comparisons.
   - `<Gutter size="lg" />`
   - **Deep Explanation**: Connected step walk-through via `<DocStepper>` or byte layouts via `<MemoryLayout>`.
4. **Key Takeaways Box**:
   - Bulleted summary using `<TakeawaysBox>` with crimson markers.
5. **Postlude**:
   - Author attribution, citations, and related technical deep-dive cards.

---

### Archetype 3: Technical Documentation & Systems Explainer
Optimize for rapid scanning, copyable workflows, and progressive disclosure:

1. **Command & Search Bar**: Quick search `<Input>` with keyboard keycap (`<Kbd keys={["⌘", "K"]} />`) wrapped in `<Tooltip content="Search docs (⌘K)">`, and `<VersionSelector>`.
2. **Two-Column Split Layout**: 
   - Left: Sticky table of contents and section steps (`<StepNav>`).
   - Right: Main documentation payload.
3. **Step-by-Step Walkthrough**:
   - Connected numbered procedures using `<DocStepper>`.
   - Command installation switcher using `<PackageManager>` (`pnpm`, `npm`, `bun`) with copy tooltips.
4. **API & Configuration Specifications**:
   - `<ApiEndpoint>` with HTTP/gRPC badges, copyable endpoints with tooltips, and status tabs.
   - Dense configuration option reference using `<ParamTable>`.
   - Before/after or baseline comparison using `<BenchmarkDelta>`.

---

## 7. Execution Workflow for the Agent

When building or updating any screen or component:
1. **Map the Narrative Journey**: Identify the page archetype (Landing Page, Blog Post, or Technical Docs). Plan the rhythmic progression (Proposition → Proof → Deep-Dive → Takeaway) before placing components.
2. **Never ask the user which components to install**: Autonomously inspect what is needed and run `npx shadcn@latest add @aui/<component> -y` or import from `array-ui`.
3. **Scaffold Layout using Layout Primitives**: Wrap pages in `<Container>`, organize flows in `<Stack>` and `<Row>`, and place spacing rhythm using `<Gutter size="md" | "lg" | "xl" />`.
4. **Apply the Visual Rhythm Rule**: Verify there are no repetitive stacks of identical cards or monotonous blocks. Alternate telemetry breakouts with editorial typography.
5. **Enforce Tooltip & Nudge Discipline**:
   - Wrap EVERY action button, icon trigger, status dot, and copy target in `<Tooltip>`.
   - On landing pages, embed announcement badges, friction-reduction nudge rows ("Zero install", "Apache 2.0"), and live proof jumps.
6. **Audit Against Custom CSS**: Review code before completing—confirm there are zero custom `.css` files, zero `<style>` blocks, and zero arbitrary margin/padding utilities.
7. **Ensure Modern Editorial Polish**: Deliver mathematical hairline borders, signature crimson accents (`#e5000f`), and clean typography.
