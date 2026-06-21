---
description: Create Excalidraw diagram JSON files for visual arguments
---

# Excalidraw Diagram Creator

Generate `.excalidraw` JSON files that **argue visually**, not just display information.

**Setup:** If the render script hasn't been set up yet:
```bash
cd .github/skills/excalidraw-diagram/references
uv sync
uv run playwright install chromium
```

**Color palette:** All colors and brand-specific styles live in `.github/skills/excalidraw-diagram/references/color-palette.md`. Read it before generating any diagram and use it as the single source of truth for all color choices.

---

## Core Philosophy

**Diagrams should ARGUE, not DISPLAY.**

A diagram isn't formatted text. It's a visual argument that shows relationships, causality, and flow that words alone can't express. The shape should BE the meaning.

**The Isomorphism Test**: If you removed all text, would the structure alone communicate the concept? If not, redesign.

**The Education Test**: Could someone learn something concrete from this diagram, or does it just label boxes? A good diagram teaches.

---

## Depth Assessment (Do This First)

### Simple/Conceptual Diagrams
Use abstract shapes when:
- Explaining a mental model or philosophy
- The audience doesn't need technical specifics
- The concept IS the abstraction

### Comprehensive/Technical Diagrams
Use concrete examples when:
- Diagramming a real system, protocol, or architecture
- The diagram will be used to teach or explain
- You're showing how multiple technologies integrate

**For technical diagrams, you MUST include evidence artifacts** (see below).

---

## Research Mandate (For Technical Diagrams)

**Before drawing anything technical, research the actual specifications.**

If you're diagramming a protocol, API, or framework:
1. Look up the actual JSON/data formats (use WebFetch)
2. Find the real event names, method names, or API endpoints
3. Use real terminology, not generic placeholders

Bad: "Protocol" → "Frontend"
Good: "API streams events (RUN_STARTED, STATE_DELTA)" → "Client renders via handler()"

---

## Evidence Artifacts

| Artifact Type | When to Use | How to Render |
|---------------|-------------|---------------|
| **Code snippets** | APIs, integrations | Dark rectangle + syntax-colored text |
| **Data/JSON examples** | Data formats, schemas | Dark rectangle + colored text |
| **Event/step sequences** | Protocols, workflows | Timeline pattern (line + dots + labels) |
| **UI mockups** | Showing actual output | Nested rectangles mimicking real UI |
| **API/method names** | Real function calls | Use actual names from docs |

---

## Multi-Zoom Architecture

### Level 1: Summary Flow
A simplified overview showing the full pipeline at a glance.

### Level 2: Section Boundaries
Labeled regions that group related components.

### Level 3: Detail Inside Sections
Evidence artifacts, code snippets, and concrete examples within each section.

**For comprehensive diagrams, aim to include all three levels.**

---

## Design Process

### Step 0: Assess Depth Required
Simple/Conceptual vs. Comprehensive/Technical. If comprehensive: research first.

### Step 1: Understand Deeply
For each concept, ask: What does this concept DO? What relationships exist? What's the core transformation?

### Step 2: Map Concepts to Patterns

| If the concept... | Use this pattern |
|-------------------|------------------|
| Spawns multiple outputs | **Fan-out** (radial arrows from center) |
| Combines inputs into one | **Convergence** (funnel, arrows merging) |
| Has hierarchy/nesting | **Tree** (lines + free-floating text) |
| Is a sequence of steps | **Timeline** (line + dots + labels) |
| Loops continuously | **Spiral/Cycle** |
| Is an abstract state | **Cloud** (overlapping ellipses) |
| Transforms input to output | **Assembly line** |
| Compares two things | **Side-by-side** |

### Step 3: Ensure Variety
Each major concept must use a different visual pattern. No uniform cards or grids.

### Step 4: Sketch the Flow
Mentally trace how the eye moves through the diagram.

### Step 5: Generate JSON
Build the JSON section-by-section for large diagrams. Do NOT attempt to generate the entire file in a single pass.

### Step 6: Render & Validate (MANDATORY)
```bash
cd .github/skills/excalidraw-diagram/references && uv run python render_excalidraw.py <path-to-file.excalidraw>
```
Then use Read to view the PNG. Fix what you see. Repeat until passing.

---

## Container vs. Free-Floating Text

**Not every piece of text needs a shape around it.** Default to free-floating text. Add containers only when they serve a purpose.

Use a container when: it's a focal point, needs visual grouping, arrows need to connect to it, or the shape itself carries meaning.

Use free-floating text when: it's a label, supporting detail, section title, or annotation.

**Rule**: Default to no container. Add shapes only when they carry meaning. Aim for <30% of text elements to be inside containers.

---

## JSON Structure

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [...],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 20
  },
  "files": {}
}
```

Text settings: `fontSize: 16`, `fontFamily: 3`, `textAlign: "center"`, `verticalAlign: "middle"`

Roughness: `0` for clean/modern. Opacity: `100` always.

See `.github/skills/excalidraw-diagram/references/element-templates.md` for copy-paste JSON templates.

---

## Render & Validate Loop

After generating JSON, run this cycle until done:
1. **Render & View** — Run render script, then Read the PNG
2. **Audit against vision** — Does visual structure match conceptual design? Does eye flow correctly?
3. **Check for defects** — Text clipped, overlaps, arrows landing wrong, uneven spacing
4. **Fix** — Adjust coordinates, widen containers, add arrow waypoints
5. **Re-render & re-view**
6. **Repeat** — Typically 2-4 iterations. Stop when: rendered matches design, no defects, you'd show it without caveats.

---

## Quality Checklist

### Depth & Evidence
1. Research done (actual specs, formats, event names)?
2. Evidence artifacts present (code snippets, JSON examples, real data)?
3. Multi-zoom (summary flow + section boundaries + detail)?
4. Educational value — could someone learn from this?

### Conceptual
5. Isomorphism — does each visual structure mirror its concept's behavior?
6. Variety — each major concept uses a different visual pattern?
7. No uniform containers — avoided card grids and equal boxes?

### Technical
8. Text clean — `text` contains only readable words
9. Font: `fontFamily: 3`
10. Roughness: `roughness: 0` for clean/modern
11. Opacity: `opacity: 100` for all elements
12. Container ratio: <30% of text elements inside containers

### Visual Validation (Render Required)
13. Rendered to PNG and visually inspected
14. No text overflow, no overlapping elements
15. Arrows connect to intended elements
16. Balanced composition — no large empty voids or overcrowded regions
