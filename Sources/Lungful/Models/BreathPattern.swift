import Foundation

/// A complete breathing pattern definition with phase durations and cycle count.
public struct BreathPattern: Identifiable, Codable, Sendable {
    public let id: UUID
    public var name: String
    public var description: String
    public var inhaleDuration: TimeInterval
    public var holdInDuration: TimeInterval
    public var exhaleDuration: TimeInterval
    public var holdOutDuration: TimeInterval
    public var cycles: Int

    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        inhaleDuration: TimeInterval,
        holdInDuration: TimeInterval = 0,
        exhaleDuration: TimeInterval,
        holdOutDuration: TimeInterval = 0,
        cycles: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.inhaleDuration = inhaleDuration
        self.holdInDuration = holdInDuration
        self.exhaleDuration = exhaleDuration
        self.holdOutDuration = holdOutDuration
        self.cycles = cycles
    }

    /// Duration of a single cycle in seconds.
    public var cycleDuration: TimeInterval {
        inhaleDuration + holdInDuration + exhaleDuration + holdOutDuration
    }

    /// Total session duration in seconds.
    public var totalDuration: TimeInterval {
        cycleDuration * Double(cycles)
    }

    /// Returns the duration for a given phase, skipping phases with zero duration.
    public func duration(for phase: BreathPhase) -> TimeInterval {
        switch phase {
        case .inhale:  return inhaleDuration
        case .holdIn:  return holdInDuration
        case .exhale:  return exhaleDuration
        case .holdOut: return holdOutDuration
        }
    }

    /// Returns the ordered list of active phases (skips phases with 0 duration).
    public var activePhases: [BreathPhase] {
        BreathPhase.allCases.filter { duration(for: $0) > 0 }
    }

    /// Returns the next active phase after the given phase, or `nil` if cycle is complete.
    public func nextPhase(after phase: BreathPhase) -> BreathPhase? {
        let active = activePhases
        guard let idx = active.firstIndex(of: phase) else { return nil }
        let next = idx + 1
        return next < active.count ? active[next] : nil
    }
}

// MARK: - Presets

extension BreathPattern {
    /// All built-in patterns.
    public static let presets: [BreathPattern] = [
        .boxBreathing,
        .relaxation478,
        .coherentBreathing,
        .wimHof,
        .physiologicalSigh,
        .custom
    ]

    public static let boxBreathing = BreathPattern(
        name: "Box Breathing",
        description: "Equal 4-count inhale, hold, exhale, hold. Used by Navy SEALs for focus and calm under pressure.",
        inhaleDuration: 4,
        holdInDuration: 4,
        exhaleDuration: 4,
        holdOutDuration: 4,
        cycles: 8
    )

    public static let relaxation478 = BreathPattern(
        name: "4-7-8 Relaxation",
        description: "Dr. Andrew Weil's technique. Inhale 4, hold 7, exhale 8. A natural tranquilizer for the nervous system.",
        inhaleDuration: 4,
        holdInDuration: 7,
        exhaleDuration: 8,
        holdOutDuration: 0,
        cycles: 4
    )

    public static let coherentBreathing = BreathPattern(
        name: "Coherent Breathing",
        description: "5.5 seconds in, 5.5 seconds out. Optimizes heart rate variability at ~5.5 breaths per minute.",
        inhaleDuration: 5.5,
        holdInDuration: 0,
        exhaleDuration: 5.5,
        holdOutDuration: 0,
        cycles: 10
    )

    public static let wimHof = BreathPattern(
        name: "Wim Hof Power Breath",
        description: "Rapid 2-second cycles for 30 breaths. Energizing controlled hyperventilation followed by a retention hold.",
        inhaleDuration: 2,
        holdInDuration: 0,
        exhaleDuration: 2,
        holdOutDuration: 0,
        cycles: 30
    )

    public static let physiologicalSigh = BreathPattern(
        name: "Physiological Sigh",
        description: "Double inhale through the nose (2+2s), long 6s exhale. The fastest known way to calm down in real-time.",
        inhaleDuration: 4,
        holdInDuration: 0,
        exhaleDuration: 6,
        holdOutDuration: 0,
        cycles: 5
    )

    public static let custom = BreathPattern(
        name: "Custom",
        description: "Create your own breathing pattern.",
        inhaleDuration: 4,
        holdInDuration: 0,
        exhaleDuration: 4,
        holdOutDuration: 0,
        cycles: 6
    )
}
