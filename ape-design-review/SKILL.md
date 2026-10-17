---
name: array-ui-review
description: Review UI code or a running page against the Array UI (array-ui) editorial systems rules (0% custom CSS, hairline borders, Assistant typography, signature crimson, tooltip wrapping, and arpitbhayani.me footer aesthetic) and report what breaks them with file and line. Use when the user asks to review, audit, check, or polish UI built with Array UI or @aui components. Pairs with the array-ui skill.
---

# Array UI Review (`array-ui-review`)

Audit technical frontend code and running pages against the Array UI design rules.
Do not restyle code while auditing; list every violation with file and line number, state the invariant it violates, and provide a one-line fix.

---

## 1. Automated Code Searches

Run these audit commands across `src/` (or the project root):

```bash
# 1. Custom CSS files (Violates Invariant 1: 0% Custom CSS)
find src/ -name "*.css" ! -name "globals.css" ! -name "styles.css" ! -name "tokens.css" ! -name "shadcn.css"

# 2. Page-level <style> blocks (Violates Invariant 1: 0% Custom CSS)
grep -rnE "<style" src/

# 3. Ad-hoc inline margin/padding hacks (Must use <Gutter> or Layout primitives)
grep -rnE "style=\{\{[^}]*(margin|padding|background|color)" src/

# 4. Heavy drop shadows (Array UI uses flat card surfaces with 1px hairlines)
grep -rnE "shadow-(md|lg|xl|2xl)" src/

# 5. Arbitrary gradients (Gradients are strictly prohibited)
grep -rnE "bg-gradient-to|from-[a-z]+-[0-9]+|to-[a-z]+-[0-9]+" src/

# 6. Bouncy / pill buttons (Buttons must be machined with radius-md / 6px)
grep -rnE "rounded-full|rounded-2xl|rounded-3xl" src/

# 7. Unwrapped action buttons or status indicators (Must be wrapped in <Tooltip>)
# Check for bare <Button>, <ThemeToggle>, or <PingStatus> without a parent <Tooltip>
grep -rnE "<Button|<ThemeToggle|<PingStatus" src/

# 8. Outdated dark crimson (#e60012 must be #ff3344 in dark mode)
grep -rnE "#e60012" src/
```

---

## 2. Visual & Architectural Invariants Checklist

1. **Font Enforcement**:
   - Is Google Fonts (`Assistant`, `IBM Plex Mono`, `Lora`) imported in `globals.css` or `<head>`?
   - Does `body` have `font-family: var(--font-sans)`?
   - If missing, text defaults to system Inter/Arial, breaking the editorial look.
2. **PageShell Usage**:
   - Is the page framed inside `<PageShell navbar={<Navbar ... />} footer={<Footer ... />}>`?
   - If a page has custom ad-hoc layout wrappers or manual margins, flag for replacement with `PageShell`.
3. **Footer Elegance**:
   - Is the footer rendered on flat canvas (`bg-background`) with `border-t border-border`?
   - Are links inline with subtle hints `(hint)`, without heavy box badges stretching the row?
   - Are social handles rendered using `<SocialPill>`s with tooltips?
4. **Visual Rhythm (Anti-Card-Soup)**:
   - Are there consecutive stacks of identical cards or symmetric blocks?
   - Did the page alternate prose with dense telemetry (`Terminal`, `DiffBlock`, `ParamTable`) and editorial quotes (`Maxim`)?
5. **Action Clarity (Tooltip Wrapping)**:
   - Is every action button, icon trigger, theme toggle, and status dot wrapped in `<Tooltip content="...">`?

---

## 3. Reporting Format

Output findings as a prioritized numbered list:

```
1. src/pages/index.tsx:34  Bare icon button without <Tooltip>.
   Rule: Every interactive control must be wrapped in <Tooltip>.
   Fix: Wrap <Button size="icon"> in <Tooltip content="Copy commit SHA (⌘C)">.

2. src/app/globals.css:1  Missing Google Fonts import for Assistant and IBM Plex Mono.
   Rule: Mandatory Font Enforcement.
   Fix: Add @import url("https://fonts.googleapis.com/css2?family=Assistant:wght@400;500;600;700;800&family=IBM+Plex+Mono:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Lora:ital,wght@0,400..700;1,400..700&display=swap");

3. src/components/Footer.tsx:18  Footer uses bg-card/60 with heavy padding.
   Rule: Footer must sit on flat canvas (bg-background) with hairline top border.
   Fix: Replace background with bg-background and ensure links are inline with subtle hints.
```
