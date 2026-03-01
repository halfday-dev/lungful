import Foundation
import Combine
import SwiftUI

/// Drives a breathing session: cycles through phases on a timer, exposes progress for UI binding.
@MainActor
public final class BreathSessionViewModel: ObservableObject {

    // MARK: - Published State

    @Published public private(set) var currentPhase: BreathPhase = .inhale
    @Published public private(set) var phaseProgress: Double = 0.0  // 0.0 → 1.0
    @Published public private(set) var currentCycle: Int = 1
    @Published public private(set) var isRunning: Bool = false
    @Published public private(set) var isComplete: Bool = false

    /// Animated scale value for the breath circle (0.35 → 1.0).
    @Published public private(set) var circleScale: CGFloat = 0.35

    // MARK: - Configuration

    public let pattern: BreathPattern

    public var totalCycles: Int { pattern.cycles }

    // MARK: - Private

    private var displayLink: AnyCancellable?
    private var phaseStartDate: Date = .now
    private var currentPhaseDuration: TimeInterval = 0
    private var isPaused: Bool = false
    private var pauseElapsed: TimeInterval = 0

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
        beginPhase(pattern.activePhases.first ?? .inhale)
        startTimer()
    }

    public func pause() {
        guard isRunning, !isPaused else { return }
        isPaused = true
        pauseElapsed = Date.now.timeIntervalSince(phaseStartDate)
        stopTimer()
    }

    public func resume() {
        guard isRunning, isPaused else { return }
        isPaused = false
        phaseStartDate = Date.now.addingTimeInterval(-pauseElapsed)
        startTimer()
    }

    public func stop() {
        isRunning = false
        isPaused = false
        stopTimer()
        reset()
    }

    // MARK: - Timer

    private func startTimer() {
        // ~60fps via Timer on the main run loop
        displayLink = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTimer() {
        displayLink?.cancel()
        displayLink = nil
    }

    private func tick() {
        let elapsed = Date.now.timeIntervalSince(phaseStartDate)
        guard currentPhaseDuration > 0 else {
            advancePhase()
            return
        }

        let progress = min(elapsed / currentPhaseDuration, 1.0)
        phaseProgress = progress

        // Interpolate circle scale
        let startScale = scaleAtPhaseStart(currentPhase)
        let endScale = currentPhase.targetScale
        withAnimation(.linear(duration: 1.0 / 60.0)) {
            circleScale = startScale + (endScale - startScale) * progress
        }

        if progress >= 1.0 {
            advancePhase()
        }
    }

    // MARK: - Phase Management

    private func beginPhase(_ phase: BreathPhase) {
        currentPhase = phase
        currentPhaseDuration = pattern.duration(for: phase)
        phaseProgress = 0.0
        phaseStartDate = .now
        pauseElapsed = 0
    }

    private func advancePhase() {
        if let next = pattern.nextPhase(after: currentPhase) {
            beginPhase(next)
        } else {
            // Cycle complete
            if currentCycle < pattern.cycles {
                currentCycle += 1
                beginPhase(pattern.activePhases.first ?? .inhale)
            } else {
                // Session complete
                phaseProgress = 1.0
                isRunning = false
                isComplete = true
                stopTimer()
            }
        }
    }

    private func reset() {
        currentPhase = pattern.activePhases.first ?? .inhale
        phaseProgress = 0.0
        currentCycle = 1
        isComplete = false
        circleScale = 0.35
        pauseElapsed = 0
    }

    /// The circle scale at the *start* of a given phase.
    private func scaleAtPhaseStart(_ phase: BreathPhase) -> CGFloat {
        switch phase {
        case .inhale:  return 0.35
        case .holdIn:  return 1.0
        case .exhale:  return 1.0
        case .holdOut: return 0.35
        }
    }
}
