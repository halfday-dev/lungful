# Lungful

An iPad-first breathwork app built with SwiftUI.

## Patterns

- **Box Breathing** — 4-4-4-4, 8 cycles (military/focus)
- **4-7-8 Relaxation** — inhale 4, hold 7, exhale 8 (Dr. Andrew Weil)
- **Coherent Breathing** — 5.5 in, 5.5 out, 10 cycles (HRV optimization)
- **Wim Hof Power Breath** — 2-0-2-0, 30 cycles (energizing)
- **Physiological Sigh** — double inhale + long exhale, 5 cycles (quick calm)

## Requirements

- iOS 17+ / iPadOS 17+
- Xcode 15+
- Swift 5.9+

## Build

Open `Package.swift` in Xcode, select an iPad simulator, and run.

```bash
# Compile (library only, no app host)
swift build

# Run tests
swift test
```

## Architecture

- **Models** — `BreathPattern`, `BreathPhase`
- **ViewModels** — `BreathSessionViewModel` (timer-driven state machine)
- **Views** — `ContentView` → `PatternListView` → `BreathSessionView` + `BreathCircleView`

No external dependencies. Pure SwiftUI.
