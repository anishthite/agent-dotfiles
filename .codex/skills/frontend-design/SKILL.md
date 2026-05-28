---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces, components, and applications with a bold, intentional aesthetic. Use when building frontend UI that must avoid generic AI-looking output and ship as polished, runnable code.
---

# Frontend Design

Guidance for crafting bold, production-grade frontend code that feels intentional and avoids generic AI aesthetics. License: see LICENSE.txt.

## Quick Start
- Clarify purpose, audience, platform/framework, and performance/accessibility constraints.
- Choose a singular aesthetic direction and commit to it; write a one-line design mantra to steer decisions.
- Sketch the layout (mental or rough wireframe), then implement with real, working code.
- Deliver runnable code (HTML/CSS/JS, React, Vue, etc.) with cohesive visuals and motion that fit the chosen concept.

## Design Thinking
- Purpose: what problem does this interface solve and for whom?
- Tone: pick an extreme (brutalist/raw, editorial/magazine, retro-futuristic neon, organic/pastel, luxury/minimal, industrial/utilitarian, playful/toy-like, art deco/geometric, maximalist chaos, etc.). Commit fully to the choice.
- Constraints: technical stack, performance targets, accessibility needs.
- Differentiation: define the unforgettable hook (e.g., diagonal split hero, kinetic headline, neon grid mesh, glassy cards with grain, custom cursor, dramatic vignette).

## Design Direction
- Pick an extreme tone: brutalist/raw, editorial/magazine, retro-futuristic neon, organic/pastel, luxury/minimal, industrial/utilitarian, playful/toy-like, art deco/geometric, maximalist chaos, etc. Choose one and stick to it.
- Define the unforgettable hook (e.g., diagonal split hero, oversized serif headlines, neon grid mesh, glassy cards with grain, kinetic type).
- Write a tiny style sheet of tokens first: `:root` color vars (3–6 core + accent), spacing scale, border radius rules, shadow style, motion timing.

## Typography
- Pair a distinctive display font with a refined body font. Avoid Inter/Roboto/Arial/system/Space Grotesk unless brand-mandated.
- Use font-loading via `@import` or self-hosted files; set optical sizes/letter-spacing per heading level.
- Establish hierarchy: expressive H1/H2, compact nav, generous line-height for body; limit font weights to 2–3 purposeful choices.

## Color & Background
- Commit to a palette that reinforces the concept; avoid safe purple-on-white defaults.
- Use backgrounds with atmosphere: gradient meshes, subtle noise, layered shapes, grids, vignette, or texture that suits the tone.
- Keep contrast accessible (WCAG AA targets); reserve accent color for calls-to-action and interactive states.

## Layout & Composition
- Prefer asymmetric, grid-breaking compositions or decisive minimal grids—never bland 12-col clones.
- Use generous negative space *or* dense, intentional stacks; avoid middling spacing.
- Layer elements with purposeful overlap, clipped shapes, or diagonals; anchor with a clear rhythm (baseline grid or modular scale).

## Motion
- Plan one high-impact motion moment (page-load stagger, hero parallax, kinetic headline) instead of many trivial fades.
- Use CSS animations/transitions first; for React, leverage a motion library if available.
- Stagger elements with delays tied to spatial order; respect reduced-motion preferences.

## Interaction & States
- Define hover/focus/active/disabled states up front; animate state transitions with consistent timing.
- Use custom cursors or magnetic hover only if they reinforce the concept and remain accessible.
- Ensure keyboard navigation and focus outlines remain visible (customize, don’t remove).

## Accessibility & Performance
- Semantic HTML; aria labels where needed; maintain contrast and readable font sizes.
- Optimize assets (SVGs preferred, compressed images, deferred heavy scripts); avoid layout shift (set dimensions).
- Test responsiveness: mobile-first breakpoints with intentional reflows (not just stack everything).

## Delivery Checklist
- Provide full, runnable code with file paths; include any font imports and asset placeholders.
- Explain the chosen concept and how colors/type/motion execute it.
- Double-check: no generic layouts, no default gray cards, no Inter/Roboto/Arial unless required, no purple gradient cliché.
