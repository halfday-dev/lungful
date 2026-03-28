# lungful post-sprint design review

**reviewer:** UI/UX design consultant (contractor)
**date:** 2026-03-27
**grade:** A-
**status:** 80% App Store ready. remaining 20% is feel/refinement.

---

## top 5 polish items for App Store ready

### POL-1: custom easing curve for breath circle
replace linear scale interpolation with bezier-eased progress. the circle should breathe (slow start, smooth acceleration, gentle landing), not ramp linearly. apply `cubicBezier(0.4, 0.0, 0.2, 1.0)` to the progress value before interpolating scale.

### POL-2: remove .design(.rounded) everywhere
brand guide says no rounded variants. replace `.design(.rounded)` with `.design(.default)` across BreathSessionView controls, CustomPatternView labels, cycle counter, and any other places it appears.

### POL-3: session completion transition
when last phase ends: gently scale circle to 0.5x over 1.5s, cross-fade phase label to "Complete" in bone color, fade background tint to neutral. give the user a moment before showing "Again" / "Done" controls.

### POL-4: tappable phase duration input
replace sliders in custom builder with tappable numbers that open a picker (0-30 in 0.5 increments). sliders are imprecise for values that matter in breathwork.

### POL-5: full wordmark with embedded breath ring
for display contexts (about screen, first launch, marketing), create the combined wordmark where the breath ring replaces a letter in "lungful". current nav bar treatment (ring + text) is correct for that context.
