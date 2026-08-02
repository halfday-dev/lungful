import Foundation

/// Represents a single phase within a breathing cycle.
public enum BreathPhase: String, Codable, CaseIterable, Sendable {
    case inhale
    case holdIn
    case exhale
    case holdOut

    /// Human-readable label for display.
    /// Both holds read simply "Hold" on screen — mid-session, the distinction
    /// is carried by the circle (expanded vs contracted) and the phase color,
    /// not the words.
    public var label: String {
        switch self {
        case .inhale:  return "Inhale"
        case .holdIn:  return "Hold"
        case .exhale:  return "Exhale"
        case .holdOut: return "Hold"
        }
    }

    /// Descriptive label for VoiceOver. Unlike the visual label, this keeps
    /// the two holds distinct — a VoiceOver user can't see the circle, so the
    /// words have to carry which hold this is.
    public var accessibilityLabel: String {
        switch self {
        case .inhale:  return "Inhale"
        case .holdIn:  return "Hold, lungs full"
        case .exhale:  return "Exhale"
        case .holdOut: return "Hold, lungs empty"
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
