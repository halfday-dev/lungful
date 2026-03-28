import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Drives a breathing session: cycles through phases, exposes progress for UI binding.
/// Designed to be driven by `TimelineView(.animation)` — call `update(at:)` each frame.
@MainActor
public final class BreathSessionViewModel: ObservableObject {

    // MARK: - Published State

    @Published public private(set) var currentPhase: BreathPhase = .inhale
    @Published public private(set) var phaseProgress: Double = 0.0  // 0.0 → 1.0
    @Published public private(set) var currentCycle: Int = 1
    @Published public private(set) var isRunning: Bool = false
    @Published public private(set) var isComplete: Bool = false
    @Published public private(set) var isPaused: Bool = false
    @Published public private(set) var isCompletionAnimating: Bool = false

    /// Scale value for the breath circle (0.35 → 1.0), computed each frame.
    @Published public private(set) var circleScale: CGFloat = 0.35

    /// Seconds remaining in the current phase, updated each frame.
    @Published public private(set) var phaseTimeRemaining: TimeInterval = 0

    // MARK: - Configuration

    public let pattern: BreathPattern

    public var totalCycles: Int { pattern.cycles }

    // MARK: - Private

    private var phaseStartDate: Date = .now
    private var currentPhaseDuration: TimeInterval = 0
    private var pauseElapsed: TimeInterval = 0
    private var lastUpdateDate: Date = .now
    private var displayTimer: Timer?

    // MARK: - Init

    public init(pattern: BreathPattern) {
        self.pattern = pattern
    }

    // MARK: - Public Methods

    public func start() {
        guard !isRunning else { return }
        reset()
        isRunning = true
        isComplete = false
        beginPhase(pattern.activePhases.first ?? .inhale, at: .now)
        startTimer()
    }

    public func pause() {
        guard isRunning, !isPaused else { return }
        isPaused = true
        pauseElapsed = lastUpdateDate.timeIntervalSince(phaseStartDate)
        stopTimer()
    }

    public func resume() {
        guard isRunning, isPaused else { return }
        isPaused = false
        phaseStartDate = Date.now.addingTimeInterval(-pauseElapsed)
        startTimer()
    }

    public func stop() {
        stopTimer()
        isRunning = false
        isPaused = false
        reset()
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.update(at: .now)
            }
        }
    }

    private func stopTimer() {
        displayTimer?.invalidate()
        displayTimer = nil
    }

    /// Called by timer. Computes elapsed time and advances phases.
    @discardableResult
    func update(at date: Date) -> Bool {
        guard isRunning, !isPaused else { return false }

        // Limit phase advances per frame to prevent infinite loops
        var advances = 0
        let maxAdvances = pattern.activePhases.count * pattern.cycles

        while isRunning, advances <= maxAdvances {
            guard currentPhaseDuration > 0 else {
                advancePhase(at: date)
                advances += 1
                continue
            }

            let elapsed = date.timeIntervalSince(phaseStartDate)
            phaseTimeRemaining = max(0, currentPhaseDuration - elapsed)
            let progress = min(elapsed / currentPhaseDuration, 1.0)
            phaseProgress = progress

            // Interpolate circle scale with eased progress for organic feel
            let startScale = scaleForPhase(previousPhase(before: currentPhase))
            let endScale = scaleForPhase(currentPhase)
            let easedProgress = easeBreath(progress)
            circleScale = startScale + (endScale - startScale) * easedProgress

            if progress >= 1.0 {
                // Advance with the exact end time of this phase for accurate chaining
                let phaseEndDate = phaseStartDate.addingTimeInterval(currentPhaseDuration)
                advancePhase(at: phaseEndDate)
                advances += 1
            } else {
                break
            }
        }
        lastUpdateDate = date
        return true
    }

    // MARK: - Phase Management

    private func beginPhase(_ phase: BreathPhase, at date: Date) {
        currentPhase = phase
        currentPhaseDuration = pattern.duration(for: phase)
        phaseProgress = 0.0
        phaseTimeRemaining = currentPhaseDuration
        phaseStartDate = date
        pauseElapsed = 0
        playPhaseHaptic(phase)
    }

    // MARK: - Haptics

    private func playPhaseHaptic(_ phase: BreathPhase) {
        #if canImport(UIKit) && !os(macOS)
        switch phase {
        case .inhale:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .holdIn:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .exhale:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .holdOut:
            // Silence IS the experience — no haptic for hold-out.
            break
        }
        #endif
    }

    /// Fire a completion haptic when session ends.
    private func playCompletionHaptic() {
        #if canImport(UIKit) && !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    private func advancePhase(at date: Date) {
        if let next = pattern.nextPhase(after: currentPhase) {
            beginPhase(next, at: date)
        } else {
            // Cycle complete
            if currentCycle < pattern.cycles {
                currentCycle += 1
                beginPhase(pattern.activePhases.first ?? .inhale, at: date)
            } else {
                // Session complete
                phaseProgress = 1.0
                phaseTimeRemaining = 0
                isRunning = false
                isCompletionAnimating = true
                isComplete = true
                stopTimer()
                playCompletionHaptic()
            }
        }
    }

    private func reset() {
        currentPhase = pattern.activePhases.first ?? .inhale
        phaseProgress = 0.0
        phaseTimeRemaining = 0
        currentCycle = 1
        isComplete = false
        isCompletionAnimating = false
        isPaused = false
        circleScale = 0.35
        pauseElapsed = 0
    }

    // MARK: - Easing

    /// Asymmetric ease for organic breath feel: slow start, smooth acceleration, gentle landing.
    /// First half is quadratic ease-in, second half is quadratic ease-out.
    private func easeBreath(_ t: Double) -> Double {
        if t < 0.5 {
            return 2 * t * t
        } else {
            return 1 - pow(-2 * t + 2, 2) / 2
        }
    }

    // MARK: - Scale Helpers

    /// Target scale for a given phase.
    private func scaleForPhase(_ phase: BreathPhase) -> CGFloat {
        switch phase {
        case .inhale, .holdIn:  return 1.0
        case .exhale, .holdOut: return 0.35
        }
    }

    /// The phase that comes before the given phase in the active sequence,
    /// used to determine the starting scale for interpolation.
    private func previousPhase(before phase: BreathPhase) -> BreathPhase {
        let active = pattern.activePhases
        guard let idx = active.firstIndex(of: phase), idx > 0 else {
            // First phase or not found — use last phase of previous cycle
            return active.last ?? .holdOut
        }
        return active[idx - 1]
    }
}
