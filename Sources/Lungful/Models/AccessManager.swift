import Foundation
import Combine

/// Access model: 7-day full trial → lapses to the free-forever patterns →
/// a one-time purchase unlocks everything permanently.
///
/// All state lives in `UserDefaults`. The trial start date is set on first
/// launch; deleting and reinstalling the app resets it. That's accepted —
/// at this price, fighting it would cost more than it saves.
@MainActor
public final class AccessManager: ObservableObject {

    /// Shared instance used by the app.
    public static let shared = AccessManager()

    public enum Access: Equatable {
        case trial(daysRemaining: Int)
        case lapsed
        case unlocked
    }

    @Published public private(set) var access: Access = .trial(daysRemaining: 7)

    /// Trial length: 7 days.
    public static let trialLength: TimeInterval = 7 * 86_400

    /// Patterns that stay free forever after the trial lapses.
    /// Matched by name — preset UUIDs are not stable across launches.
    public static let freeForeverNames: Set<String> = [
        BreathPattern.boxBreathing.name,
        BreathPattern.physiologicalSigh.name
    ]

    private let defaults: UserDefaults
    private let now: () -> Date
    private let trialStartKey = "lungful.trialStartDate"
    private let unlockedKey = "lungful.unlocked"

    /// - Parameters:
    ///   - defaults: Backing store. Injectable for tests.
    ///   - now: Clock. Injectable for tests.
    public init(defaults: UserDefaults = .standard, now: @escaping () -> Date = { Date() }) {
        self.defaults = defaults
        self.now = now
        refresh()
    }

    // MARK: - State

    /// Recomputes access from stored state and the current date.
    /// Call on appear so day boundaries are picked up.
    public func refresh() {
        if defaults.bool(forKey: unlockedKey) {
            access = .unlocked
            return
        }

        let start: Date
        if let stored = defaults.object(forKey: trialStartKey) as? Date {
            start = stored
        } else {
            start = now()
            defaults.set(start, forKey: trialStartKey)
        }

        let elapsed = now().timeIntervalSince(start)
        if elapsed < Self.trialLength {
            // Negative elapsed (clock set backwards) clamps to the full trial.
            let remaining = Self.trialLength - max(0, elapsed)
            let days = Int(ceil(remaining / 86_400))
            access = .trial(daysRemaining: min(7, max(1, days)))
        } else {
            access = .lapsed
        }
    }

    /// Marks the one-time purchase as owned (or revoked) and refreshes.
    /// Called by `StoreService` on purchase, restore, and entitlement checks.
    public func setUnlocked(_ unlocked: Bool) {
        defaults.set(unlocked, forKey: unlockedKey)
        refresh()
    }

    // MARK: - Queries

    /// True during the trial and after purchase.
    public var isFullAccess: Bool {
        switch access {
        case .trial, .unlocked: return true
        case .lapsed:           return false
        }
    }

    /// Whether a given pattern can be started right now.
    public func canUse(_ pattern: BreathPattern) -> Bool {
        isFullAccess || Self.freeForeverNames.contains(pattern.name)
    }

    /// The custom pattern builder is part of the paid toolkit.
    public var canUseBuilder: Bool { isFullAccess }
}
