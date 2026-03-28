import SwiftUI

/// Earth-tone color system for Lungful.
/// Replaces default SwiftUI dark-mode colors with a warm, ceramic-inspired palette.
public enum Theme {

    // MARK: - Background Colors

    /// Primary background. Replaces Color.black.
    public static let deepStone = Color(red: 0x1A / 255.0, green: 0x17 / 255.0, blue: 0x14 / 255.0)

    /// Cards and elevated surfaces.
    public static let warmClay = Color(red: 0x25 / 255.0, green: 0x21 / 255.0, blue: 0x19 / 255.0)

    /// Subtle borders.
    public static let kilnEdge = Color(red: 0x3A / 255.0, green: 0x33 / 255.0, blue: 0x2A / 255.0)

    // MARK: - Text Colors

    /// Primary text. Replaces .white.
    public static let bone = Color(red: 0xE8 / 255.0, green: 0xE0 / 255.0, blue: 0xD4 / 255.0)

    /// Secondary text. Replaces .white.opacity(0.6).
    public static let dust = Color(red: 0x9C / 255.0, green: 0x92 / 255.0, blue: 0x86 / 255.0)

    /// Tertiary text. Replaces .white.opacity(0.4).
    public static let shadow = Color(red: 0x6B / 255.0, green: 0x62 / 255.0, blue: 0x59 / 255.0)

    // MARK: - Phase Colors

    /// Inhale — growth, expansion, life.
    public static let sage = Color(red: 0x8B / 255.0, green: 0xA8 / 255.0, blue: 0x88 / 255.0)

    /// Hold in — stillness, warmth, held sunlight.
    public static let amber = Color(red: 0xC4 / 255.0, green: 0xA9 / 255.0, blue: 0x6A / 255.0)

    /// Exhale — release, grounding, earth.
    public static let terracotta = Color(red: 0xB8 / 255.0, green: 0x7B / 255.0, blue: 0x5E / 255.0)

    /// Hold out — quiet, cool, space.
    public static let slate = Color(red: 0x7A / 255.0, green: 0x8B / 255.0, blue: 0x8F / 255.0)

    // MARK: - Accent

    /// Primary CTA color.
    public static let ochre = Color(red: 0xD4 / 255.0, green: 0xA7 / 255.0, blue: 0x54 / 255.0)

    // MARK: - Helpers

    /// Returns the phase color for a given breath phase.
    public static func color(for phase: BreathPhase) -> Color {
        switch phase {
        case .inhale:  return sage
        case .holdIn:  return amber
        case .exhale:  return terracotta
        case .holdOut: return slate
        }
    }
}
