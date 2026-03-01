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
        case .holdIn:  return "Hold"
        case .exhale:  return "Exhale"
        case .holdOut: return "Hold"
        }
    }

    /// Target scale for the breath circle animation (0.0–1.0 range mapped to min/max).
    public var targetScale: CGFloat {
        switch self {
        case .inhale:  return 1.0
        case .holdIn:  return 1.0
        case .exhale:  return 0.35
        case .holdOut: return 0.35
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
