import Foundation

/// Represents a single phase within a breathing cycle.
public enum BreathPhase: String, Codable, CaseIterable, Sendable {
    case inhale
    case holdIn
    case exhale
    case holdOut

    /// Human-readable label for display.
    public var label: String {
        switch self {
        case .inhale:  return "Inhale"
        case .holdIn:  return "Hold In"
        case .exhale:  return "Exhale"
        case .holdOut: return "Hold Out"
        }
    }

    /// Descriptive label for VoiceOver that distinguishes hold phases.
    public var accessibilityLabel: String {
        switch self {
        case .inhale:  return "Inhale"
        case .holdIn:  return "Hold In"
        case .exhale:  return "Exhale"
        case .holdOut: return "Hold Out"
        }
    }

    /// The next phase in the cycle. Returns `nil` after `holdOut` (cycle complete).
    public var next: BreathPhase? {
        switch self {
        case .inhale:  return .holdIn
        case .holdIn:  return .exhale
        case .exhale:  return .holdOut
        case .holdOut: return nil
        }
    }
}
