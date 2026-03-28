# lungful design review

**reviewer:** UI/UX design consultant (contractor)
**date:** 2026-03-27
**status:** delivered, pending T's review
**T REVIEW**: LGTM. Let's break this up into tasks first and then begin working on implementing.

---

## 1. current state critique

**what works:**
- structural bones are sound. three-screen architecture (list → session, or list → builder → session) is right for a tool.
- breathing circle concept (expand/contract) is correct and universally understood.
- pattern descriptions are well-written and give context.
- control layout (play/pause/stop) is clean.

**what doesn't:**
- **looks like a developer prototype.** pure black + white text at various opacities + system cyan/blue/indigo/purple = dark-mode SwiftUI defaults with the serial numbers filed off.
- **color story is wrong.** cyan/blue/indigo/purple are cold, digital, screen-y. "tech dashboard," not "breathwork tool." fundamental mismatch between content (ancient breathing techniques) and visual language (sci-fi HUD).
- **typography has no character.** SF Rounded at various sizes for everything. flat, undifferentiated hierarchy. the phase label ("Inhale") is the most important word on screen and it's styled like everything else, just bigger.
- **pattern cards are generic dark-mode boxes.** interchangeable rectangles. nothing makes box breathing feel different from 4-7-8.
- **breath circle is underwhelming.** radial gradient + thin stroke + blur glow. 0.15s animation is too fast to be smooth, too slow to be snappy. for the core visual element, this needs to be considerably more refined.
- **custom builder is dense.** no visual breathing room (ironic for a breathing app). every element has the same visual weight.
- **start button gradient reads "fintech CTA,"** not "begin meditation."
- **no visual identity.** no logo, no mark. the app could be called anything.
- **iPad sizing is undercooked.** 280pt circle on a 12.9" screen feels small and lost.

---

## 2. design direction

### the feeling

like a well-made ceramic object. earthy, warm, tactile, deliberate. not spiritual (no incense/lotus). not clinical (no medical device). something you pick up, use, put down. a japanese tea bowl, not a goop candle.

### reference points

- **noisli** — warm palette, simple controls, ambient without being precious
- **endel** — slow color shifts, organic shapes, calm
- **muji product design** — reduction to essence, warm neutrals, visible quality
- **teenage engineering** — a tool can be beautiful and opinionated without being complicated

### color palette

| role | name | hex | usage |
|------|------|-----|-------|
| background | deep stone | `#1A1714` | primary background (replaces pure black) |
| surface | warm clay | `#252119` | cards, elevated surfaces |
| surface border | kiln edge | `#3A332A` | subtle borders |
| primary text | bone | `#E8E0D4` | headings, phase labels |
| secondary text | dust | `#9C9286` | descriptions, metadata |
| tertiary text | shadow | `#6B6259` | timestamps, hints |

**phase colors:**

| phase | name | hex | feeling |
|-------|------|-----|---------|
| inhale | sage | `#8BA888` | growth, expansion, life |
| hold in | amber | `#C4A96A` | stillness, warmth, held sunlight |
| exhale | terracotta | `#B87B5E` | release, grounding, earth |
| hold out | slate | `#7A8B8F` | quiet, cool, space |

**accent:** ochre `#D4A754` — primary CTA and custom card highlight only. the only color that "pops."

### typography

1. **primary/UI:** instrument sans or DM sans (free). or SF Pro Text (not rounded) if staying system-only.
2. **phase label/display:** SF Pro Display Ultralight at 38-42pt (iPad). extreme thinness implies air/breath. or instrument serif for editorial contrast.
3. **data/mono:** SF Mono Light for phase summaries ("In 4s / Hold 7s / Out 8s"). should feel like an engraving on the back of a device.

---

## 3. pattern list redesign

- **single-column list, not grid.** centered, max-width ~600pt. magazine-like. each pattern feels substantial.
- **card design:** pattern name + description + phase indicator strip (thin horizontal bar segmented proportionally by phase duration, colored with phase colors). makes each card visually unique at a glance. duration badge in top-right corner. remove cycle count and clock icon from card face.
- **card surface:** warm clay fill, 1px kiln edge border, 12pt corners.
- **custom card:** visually distinct — outlined card (no fill, dashed border in ochre) with centered `+` mark and "Custom" below. blank template feel.
- **header:** custom header with lungful wordmark top-left. no large title. single line of secondary text below.

---

## 4. breathing session redesign

### background
deep stone (`#1A1714`). during session, background shifts imperceptibly toward current phase hue. barely-there tint, like last light of sunset touching a stone wall.

### breath circle
- **size:** `min(screenWidth, screenHeight) * 0.45` on iPad (~450-500pt). cap at 280pt on iPhone.
- **remove:** outer blur glow, radial gradient, inner ring.
- **replace with:** single flat fill of phase color at ~40% opacity + thin (1.5px) stroke at phase color 60% opacity. watercolor circle feel.
- **subtle depth ring:** second ring at 0.97x scale, 2px stroke, phase color at 20% opacity.

### animation
- circle expansion/contraction matches phase duration exactly (4s inhale = 4s expansion)
- custom easing: `timingCurve(0.4, 0.0, 0.2, 1.0)` — slow start, smooth acceleration, gentle landing
- phase color cross-fades over ~0.8 seconds
- scale range: 0.4 to 1.0
- **never use spring animations** in session. breath does not bounce.

### phase label
- SF Pro Display Ultralight, 38pt (iPad) / 28pt (iPhone), bone color
- below: phase countdown ("3.2s") in SF Mono Light, 16pt, dust color
- cycle count ("3 of 8") moves to tiny indicator at top of screen

### controls
- bottom of screen, centered
- text buttons ("Pause" / "End"), secondary text color, no background. controls should nearly disappear during session.
- pre-session: single large "Begin" below circle in ochre. no play icon. words are warmer than icons.

---

## 5. custom pattern builder

- **remove +/- buttons.** make the number tappable for exact input via popover.
- **remove card backgrounds.** just slider + label, separated by generous spacing (32pt).
- **add live preview:** small breath circle (120pt) at top that animates through the pattern as you adjust. direct manipulation with visible results.
- **cycles:** replace slider with segmented stepper or tap-to-increment number. slider is too imprecise for integers.
- **summary:** single line of SF Mono Light: "6 cycles / 48 seconds / 4-0-4-0"
- **start button:** solid ochre (`#D4A754`) fill, black text. no gradient.

---

## 6. logo concepts

### concept A: "the lungful mark"
single continuous brush-stroke line tracing two abstracted lungs. calligraphic, variable weight (thicker at base, thinning at top). like a zen enso. ochre dot at center where shapes almost meet. **feeling:** craft, breath, hand-made.

### concept B: "the breath ring" (RECOMMENDED)
nearly-complete circle with gap at top. stroke weight varies: thickest at bottom (exhale, grounded), thinnest at gap (where breath enters/exits). the thickness *is* the rhythm. at larger sizes, ring uses subtle phase color gradient around circumference. can replace the "o" in "lungful" wordmark. **feeling:** cycle, rhythm, precision. most aligned with metronome positioning.
[T: Concept be sgtm. Let's try it.]
### concept C: "the stack"
three horizontal lines of decreasing length, stacked vertically. rounded endpoints, slightly off-center rightward. extremely minimal. **feeling:** reduction, breath-as-data, tool-like. most "teenage engineering."

---

## 7. design system

### spacing (8pt base grid)

| token | value | usage |
|-------|-------|-------|
| xs | 4pt | inline, icon-to-text |
| sm | 8pt | tight grouping |
| md | 16pt | standard element spacing |
| lg | 24pt | section spacing within view |
| xl | 32pt | major section breaks |
| 2xl | 48pt | screen-level iPad padding |
| 3xl | 64pt | breathing room around circle |

### corners
- sm: 8pt (pills, badges)
- md: 12pt (cards, buttons)
- lg: 16pt (modals, large containers)
- always `.continuous` style

### depth
- **no drop shadows.** layered opacity for depth (background → surface → element).
- borders only on interactive cards/containers that need definition.
- breath circle glow is the only light-emitting element. singular.

### animation philosophy
- phase transitions: duration matches breath phase. not a UI animation — a visualization of time.
- color transitions: 0.6-0.8s cross-fades. colors bleed, not switch.
- UI transitions: standard 0.3s ease-in-out.
- micro-interactions: 0.15s snappy.
- default easing: `timingCurve(0.4, 0.0, 0.2, 1.0)`
- never spring in session. never linear for anything visible.

### haptic language

| event | haptic |
|-------|--------|
| inhale begin | `.medium` impact |
| hold begin | `.rigid` (short, precise) |
| exhale begin | `.soft` impact |
| hold-out begin | none (true stillness) |
| session complete | `.success` notification |
| button tap | `.light` impact |

### dark only for v1
entire palette built around it. meditative use case favors dark. don't waste time on light theme for MVP.

---

## top 3 priorities

if you implement nothing else:

1. **replace the color palette.** earth tones transform the app from "developer prototype" to "intentional product."
2. **fix breath circle animation timing.** expansion/contraction should match phase duration with proper easing, not a 0.15s UI animation.
3. **increase circle size on iPad.** proportional to viewport, not hardcoded 280pt.

---

*saved from contractor UI/UX review. reference for builder implementation.*
