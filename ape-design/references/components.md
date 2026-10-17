# Array UI Registry Items & Component APIs

Official Registry: `https://ui.arpitbhayani.me/r/{name}.json`  
LLM Manifest: `https://ui.arpitbhayani.me/llms.txt`  
Full API Docs: `https://ui.arpitbhayani.me/llms-full.txt`  

## Installation

Configure `components.json`:
```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "registries": {
    "@aui": "https://ui.arpitbhayani.me/r/{name}.json"
  }
}
```

Install theme tokens and base font layer:
```bash
npx shadcn@latest add @aui/aui -y
```

Install components autonomously with `-y`:
```bash
npx shadcn@latest add @aui/page-shell @aui/navbar @aui/footer @aui/button @aui/badge @aui/card @aui/terminal @aui/diff-block @aui/ping-status @aui/tooltip @aui/gutter @aui/layout -y
```

---

## Component API Reference

### Layout & Page Shell Primitives
- **`PageShell`** (`@aui/page-shell`): Holistic page frame. Props: `navbar?: ReactNode`, `footer?: ReactNode`, `maxWidth?: "sm" | "md" | "lg" | "xl" | "2xl" | "6xl" | "full" (default "6xl")`, `children: ReactNode`.
- **`Navbar`** (`@aui/navbar`): Sticky responsive header with blur on scroll. Props: `brandName?: string`, `brandHref?: string`, `logo?: ReactNode`, `links?: { label: string; href: string; external?: boolean; badge?: string }[]`, `actions?: ReactNode`, `statusIndicator?: ReactNode`.
- **`Footer`** (`@aui/footer`): Editorial directory footer matching arpitbhayani.me. Props: `columns?: { heading: string; links: { label: string; href: string; hint?: string; external?: boolean; isHighlight?: boolean; isRss?: boolean }[] }[]`, `disclaimer?: ReactNode`, `copyright?: string`, `socialPills?: ReactNode`.
- **`Gutter` / `Spacer`** (`@aui/gutter`): Whitespace blank spacing component (eliminates ad-hoc margin/padding hacks). Props: `size?: "none" | "2xs" (4px) | "xs" (8px) | "sm" (12px) | "md" (24px) | "lg" (36px) | "xl" (48px) | "2xl" (72px) | number | string`, `orientation?: "vertical" | "horizontal"`.
- **`Layout`** (`@aui/layout`): Structural primitives: `<Container size="sm"|"md"|"lg"|"xl"|"full">`, `<Stack gap="xs"|"sm"|"md"|"lg"|"xl">`, `<Row gap="..." justify="..." align="..." wrap>`, `<Grid cols={1|2|3|4|6|12} gap="...">`.
- **`SplitPane`** (`@aui/split-pane`): 2-column asymmetric layout with sticky aside column. Props: `aside: ReactNode`, `stickyFirst?: boolean`, `ratio?: "1/1" | "4/8" | "5/7" | "7/5" | "8/4"`, `children: ReactNode`.

### Core Action & Feedback Primitives
- **`Button`** (`@aui/button`): Tactile action button. Variants: `primary` (signature crimson #e5000f light / #ff3344 dark), `secondary` (hairline border), `outline`, `ghost`, `destructive`. Sizes: `sm`, `default` / `md`, `lg`, `icon`. Props: `icon?: ReactNode`, `leftIcon?: ReactNode`, `rightIcon?: ReactNode`, `loading?: boolean`, `loadingText?: ReactNode`.
- **`Badge`** (`@aui/badge`): Machined monospace status pill. Variants: `primary`, `default`, `secondary`, `outline`, `green`, `amber`, `red`, `blue`, `violet`, `cyan`, `pink`. Props: `href?: string`, `interactive?: boolean`.
- **`Card`** (`@aui/card`): Flat hairline card surface. Subcomponents: `CardHeader`, `CardTitle`, `CardDescription`, `CardContent`, `CardFooter`. Props: `hoverable?: boolean`, `interactive?: boolean`.
- **`Tooltip`** (`@aui/tooltip`): Mandatory hover/focus hint for all buttons and status items. Props: `content: ReactNode`, `side?: "top" | "bottom" | "left" | "right"`, `children: ReactNode`.
- **`Input`** (`@aui/input`): Machined input field. Props: `shortcut?: string` (e.g. `"⌘K"`), standard HTML input props.
- **`Kbd`** (`@aui/kbd`): Monospace keyboard shortcut keycap. Props: `keys: string[]` (e.g. `["⌘", "K"]`).
- **`Alert`** (`@aui/alert`): Inline tinted callout. Variants: `default`, `info`, `warning`, `destructive`. Subcomponents: `AlertTitle`, `AlertDescription`.
- **`Tabs`** (`@aui/tabs`): Underline navigation tabs. Subcomponents: `TabsList`, `TabsTrigger`, `TabsContent`.
- **`Accordion`** (`@aui/accordion`): Collapsible hairline sections (`AccordionItem`, `AccordionTrigger`, `AccordionContent`).
- **`Modal`** (`@aui/modal`): Accessible dialog modal with backdrop blur. Props: `isOpen: boolean`, `onClose: () => void`, `title?: string`, `footer?: ReactNode`.
- **`Dropdown`** (`@aui/dropdown`): Action menu with click-outside dismissal (`trigger`, `children`).

### Developer & Telemetry Primitives
- **`Terminal`** (`@aui/terminal`): Machined telemetry terminal with command dots. Props: `title?: string`, `lines: (string | { text: string; kind?: "cmd" | "out" | "ok" | "err" })[]`.
- **`DiffBlock`** (`@aui/diff-block`): Unified git patch inspector. Props: `file: string`, `status?: "added" | "deleted" | "renamed" | "modified"`, `diff?: string`, `lines?: DiffLine[]`, `view?: "unified" | "split"`.
- **`PingStatus`** (`@aui/ping-status`): Pulsing heartbeat status. Props: `status: "operational" | "degraded" | "outage" | "maintenance"`, `label?: string`, `size?: "sm" | "md" | "lg"`.
- **`PropertyGrid`** (`@aui/property-grid`): Dense key-value metadata inspector with one-click copy. Props: `items: { label: string; value: ReactNode; copyValue?: string }[]`.
- **`FileTree`** (`@aui/file-tree`): Collapsible directory tree. Props: `data: FileTreeNode[]`.
- **`PackageManager`** (`@aui/package-manager`): CLI switcher (`pnpm`, `npm`, `bun`, `yarn`) with one-click copy. Props: `pkg: string`, `defaultManager?: string`.
- **`StatCard`** (`@aui/stat-card`): Metric display card. Props: `value: string`, `label: string`, `description?: string`, `accent?: "emerald" | "rose" | "amber" | "blue"`.

### Editorial & Content Primitives
- **`Maxim`** (`@aui/maxim`): Amber quotation box for engineering principles. Props: `author?: string`, `source?: string`, `sourceUrl?: string`, `children: ReactNode`.
- **`TakeawaysBox`** (`@aui/takeaways-box`): Crimson bulleted key takeaways box. Props: `title?: string`, `items: string[]`.
- **`Hero`** (`@aui/hero`): Editorial portrait hero. Props: `title: string`, `subtitle?: string`, `avatarUrl?: string`, `avatarAlt?: string`, `children: ReactNode`.
- **`SocialPill`** (`@aui/social-pill`): Platform button for YouTube, X/Twitter, GitHub, LinkedIn. Props: `platform: "youtube" | "twitter" | "github" | "linkedin"`, `href: string`, `count?: string`, `label?: string`.
- **`CourseCard`** (`@aui/course-card`): Cohort or product card with tags and CTA. Props: `title: string`, `description: string`, `href: string`, `badge?: string`, `tags?: string[]`, `ctaText?: string`.
- **`EmptyState`** (`@aui/empty-state`): Dashed container for zero-data screens. Props: `title: string`, `description?: string`, `children?: ReactNode`.

### Technical Documentation & Architecture
- **`ApiEndpoint`** (`@aui/api-endpoint`): HTTP/gRPC API specification block. Props: `method: "GET"|"POST"|"PUT"|"DELETE"|"PATCH"`, `path: string`, `description?: string`, `params?: ApiParam[]`, `responses?: ApiResponse[]`.
- **`DocStepper`** (`@aui/doc-stepper`): Connected numbered walkthrough. Props: `steps: { title: string; description?: string }[]`, `activeStep?: number`.
- **`ParamTable`** (`@aui/param-table`): Dense parameter reference table. Props: `items: { name: string; type: string; required?: boolean; default?: string; description: string }[]`.
- **`FeatureMatrix`** (`@aui/feature-matrix`): Matrix comparison table with check/cross/partial indicators.
- **`ArchitectureCanvas`** (`@aui/architecture-canvas`): Interactive node-and-edge graph layout. Props: `nodes: Node[]`, `connections: Edge[]`, `direction?: "LR" | "TB"`.
- **`MemoryLayout`** (`@aui/memory-layout`): Contiguous byte/memory layout visualizer with offsets.
- **`PipelineFlow`** (`@aui/pipeline-flow`): Multi-stage data pipeline flow visualizer with throughput metrics.
- **`BenchmarkDelta`** (`@aui/benchmark-delta`): Baseline vs candidate metric delta comparator.
- **`ClusterState`** (`@aui/cluster-state`): Distributed consensus cluster state machine visualizer.
- **`LatencyDistribution`** (`@aui/latency-distribution`): p50, p90, p99, p99.9 latency percentile distribution visualizer.
