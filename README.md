# Lungful

An iPad-first breathwork app built with SwiftUI. Universal (iPhone + iPad), dark-only, no dependencies, no network calls of its own.

Pricing model: 7-day full trial → Box Breathing + Physiological Sigh free forever → $4.99 one-time IAP ("Full Toolkit") unlocks everything.

## Patterns

- **Box Breathing** — 4-4-4-4, 8 cycles (focus)
- **4-7-8 Relaxation** — inhale 4, hold 7, exhale 8 (wind-down)
- **Resonant Breathing** — 5.5 in, 5.5 out, 10 cycles (HRV)
- **Dutch Power Breath** — 30 power breaths + retention hold + recovery breath
- **Physiological Sigh** — double inhale + long exhale, 5 cycles (quick calm)
- **Custom** — build your own; saved patterns persist on the main list

## Requirements

- iOS 17+ / iPadOS 17+
- Xcode 15+
- Swift 5.9+

## Build

```bash
# Compile (library only, no app host)
swift build

# Run tests
swift test
```

### App target (App Store distribution)

The shippable app lives in `App/` + `project.yml` (XcodeGen):

```bash
brew install xcodegen   # once
xcodegen generate
open Lungful.xcodeproj
```

See `docs/appstore/submission-runbook.md` for the full release checklist.

## Architecture

- **Models** — `BreathPattern`, `BreathPhase`, `PatternStore` (UserDefaults persistence), `AccessManager` (trial/unlock state), `StoreService` (StoreKit 2)
- **ViewModels** — `BreathSessionViewModel` (timer-driven state machine)
- **Views** — `ContentView` → `PatternListView` → `BreathSessionView` + `BreathCircleView`, `CustomPatternView`, `AboutView`, `UnlockView`
- **App/** — App Store shell: `@main` entry, assets, privacy manifest, Info.plist config

No external dependencies. Pure SwiftUI.
