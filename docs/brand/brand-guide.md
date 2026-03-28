# lungful brand guide

---

## the breath ring

the primary mark for lungful is the **breath ring**: a nearly-complete circle with a gap at 12 o'clock. stroke weight varies continuously around the circumference — thickest at the bottom (grounded, exhale) and thinnest at the gap (where breath enters and exits). the thickness IS the rhythm.

the ring communicates: cycle, precision, organic rhythm. it's a metronome rendered as a shape.

**source files:**
- `breath-ring.svg` — standalone mark, bone on transparent, 100x100 viewbox
- `app-icon.svg` — app icon composition, 1024x1024

---

## logo usage

### minimum size
- **digital:** 20px height minimum (nav bar usage)
- **print:** 10mm height minimum

### clear space
maintain clear space equal to **25% of the ring diameter** on all sides. nothing enters this zone — no text, no other UI elements, no edge of frame.

### what NOT to do
- do not rotate the ring (the gap must stay at top)
- do not stretch or distort the aspect ratio
- do not add drop shadows, glows, or outlines to the mark
- do not place the ring on busy or mid-tone backgrounds where contrast is lost
- do not recreate the ring with a uniform stroke — the variable thickness is the identity
- do not fill the interior of the ring
- do not animate the ring opening/closing in marketing (the session circle animates; the logo does not)

---

## the wordmark

**"lungful"** — always lowercase, always one word.

### typography
- **face:** SF Pro Light (system) or Instrument Sans Light (custom). no rounded variants.
- **tracking:** +2% letter-spacing. the extra air between letters is intentional.
- **weight:** light only. never regular, never bold.

### the ring as "o"
at display sizes (32pt+), the breath ring can replace the letter "o" in "lungful":

```
lungf[ring]l
```

rules for this treatment:
- the ring must be optically centered on the baseline, matching the x-height of the surrounding letters
- ring height = x-height of the typeface at that size
- maintain the same tracking on either side of the ring as between other letters
- only use this at sizes where the ring's variable thickness is clearly visible (32pt+)
- at small sizes (nav bar, tab bar), use the ring mark alone or the plain text wordmark — never the combined version

---

## color versions

### 1. mono bone on dark (primary)
- ring: bone `#E8E0D4`
- background: deep stone `#1A1714`
- **use for:** app icon, in-app nav bar, dark marketing materials, app store listing

### 2. mono deep stone on light
- ring: deep stone `#1A1714`
- background: white or bone
- **use for:** light-background print, website light mode (future), press kit

### 3. phase-color gradient (marketing only)
at large sizes (hero images, app store feature graphic, social headers), the ring uses a subtle gradient that follows the breath phases around the circumference:

| arc segment | color | hex |
|-------------|-------|-----|
| bottom-right (7-5 o'clock) | terracotta (exhale) | `#B87B5E` |
| right (5-2 o'clock) | sage (inhale) | `#8BA888` |
| top-right to gap (2-12 o'clock) | amber (hold) | `#C4A96A` |
| top-left from gap (12-10 o'clock) | slate (hold out) | `#7A8B8F` |
| left (10-7 o'clock) | terracotta blend | `#B87B5E` |

transitions between colors should be smooth (~30 degrees of blend). the gradient is subtle — phase colors are already muted earth tones, so this reads as a warm shift, not a rainbow.

**never use the gradient version at small sizes.** below 64px the gradient becomes muddy. use mono.

---

## color palette reference

### backgrounds
| name | hex | role |
|------|-----|------|
| deep stone | `#1A1714` | primary background |
| warm clay | `#252119` | cards, elevated surfaces |
| kiln edge | `#3A332A` | subtle borders |

### text
| name | hex | role |
|------|-----|------|
| bone | `#E8E0D4` | primary text, headings |
| dust | `#9C9286` | secondary text, descriptions |
| shadow | `#6B6259` | tertiary text, timestamps |

### phase colors
| name | hex | phase |
|------|-----|-------|
| sage | `#8BA888` | inhale |
| amber | `#C4A96A` | hold in |
| terracotta | `#B87B5E` | exhale |
| slate | `#7A8B8F` | hold out |

### accent
| name | hex | role |
|------|-----|------|
| ochre | `#D4A754` | CTA buttons, custom card highlight |

---

## app icon

### composition
- **background:** deep stone `#1A1714`, full bleed
- **mark:** bone breath ring, centered, filling ~60% of icon area
- **no text** in the icon — the ring is the mark

### sizes
apple applies the continuous-corner (squircle) mask automatically. the SVG source is 1024x1024 with square corners.

| context | size | notes |
|---------|------|-------|
| app store | 1024x1024 | source asset |
| home screen (iPhone) | 60x60 @3x | auto-scaled |
| home screen (iPad) | 76x76 @2x | auto-scaled |
| spotlight | 40x40 @3x | ring still legible at this size |
| settings | 29x29 @3x | smallest; ring reads as broken circle |

### do not
- add a gradient background to the icon
- place the wordmark inside the icon
- use phase colors in the icon for v1 (mono only)

---

## where the logo appears

### in-app
| location | treatment | size |
|----------|-----------|------|
| nav bar (pattern list) | breath ring mark only | 20pt height |
| about screen | ring + wordmark (combined) | 48pt wordmark |

### app store
| asset | treatment |
|-------|-----------|
| app icon | ring on deep stone (as specified above) |
| screenshots | ring watermark in corner, 24pt, bone at 40% opacity |
| feature graphic | full gradient ring, centered, with wordmark below |

### web / marketing
| location | treatment |
|----------|-----------|
| halfday.dev product page | ring + wordmark, bone on deep stone hero |
| social headers | gradient ring, large |
| favicon | ring mark only, 32x32, bone on deep stone |
| open graph image | gradient ring + wordmark + tagline |

---

*this guide evolves with the product. update as the brand develops.*
