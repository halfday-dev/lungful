# lungful — screenshot plan

**status:** capture on T's Mac (simulator), then upload to App Store Connect
**date:** 2026-07-18

---

## required sizes (universal app)

| device class | simulator to use | pixels (portrait) |
|---|---|---|
| iPad 13" (required) | iPad Pro 13-inch (M4) | 2064 × 2752 |
| iPhone 6.9" (required) | iPhone 16 Pro Max (or newest Pro Max) | 1320 × 2868 |

App Store Connect scales these down for smaller devices automatically. capture 5 shots per device class (10 total). in the simulator: **Cmd+S** saves a screenshot to the desktop at full device resolution.

## the five shots (same sequence both devices)

1. **pattern list** — home screen, all five presets + custom card visible. shows the phase-strip cards and wordmark. (the anchor shot: this is the "intentional product" frame.)
2. **session, mid-inhale** — box breathing, circle ~80% expanded, sage phase color, "Inhale" label with countdown. start a session and screenshot at ~3s into an inhale.
3. **dutch power breath retention** — the "Hold" screen with the count-up timer and Release control. the most distinctive feature; competitors don't have open-ended retention.
4. **custom builder** — with one phase wheel open (tap a duration) so the live preview circle + tappable numbers + summary line are all visible.
5. **completion** — the "Complete" moment (circle contracted at 0.5, bone label) with Again/Done controls faded in.

## captions (if using App Store Connect's plain screenshots, skip; if framing with text later, use these)

1. five patterns with a reason to exist
2. a circle that breathes at exactly your pace
3. retention holds, timed until you release
4. build your own, in half-second steps
5. no streaks. no coach. just breath.

## rules

- dark screenshots straight from the app — no device frames or marketing borders needed for v1 (the app IS dark and composed; it reads as designed)
- brand guide allows a ring watermark in a corner (24pt, bone at 40%) — optional, skip if it clutters
- status bar: hidden during sessions already; for the list shots, simulator status bar is fine, or clean it with `xcrun simctl status_bar "iPad Pro 13-inch (M4)" override --time "9:41" --batteryLevel 100`
