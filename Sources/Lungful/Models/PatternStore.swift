import Foundation
import Combine

/// Persists user-created custom patterns as JSON in `UserDefaults`.
/// Lungful stores no data anywhere else — no network, no analytics, no accounts.
@MainActor
public final class PatternStore: ObservableObject {

    /// Shared store used by the app. Views observe this single instance so
    /// saves made in the builder appear immediately on the pattern list.
    public static let shared = PatternStore()

    /// User-saved custom patterns, in the order they were saved.
    @Published public private(set) var savedPatterns: [BreathPattern] = []

    private let defaults: UserDefaults
    private let storageKey: String

    /// - Parameters:
    ///   - defaults: Backing store. Injectable for tests.
    ///   - storageKey: Key under which patterns are stored.
    public init(defaults: UserDefaults = .standard, storageKey: String = "lungful.savedPatterns") {
        self.defaults = defaults
        self.storageKey = storageKey
        load()
    }

    // MARK: - Public API

    /// Saves a pattern. If a pattern with the same `id` already exists it is
    /// replaced in place; otherwise the pattern is appended.
    public func save(_ pattern: BreathPattern) {
        if let index = savedPatterns.firstIndex(where: { $0.id == pattern.id }) {
            savedPatterns[index] = pattern
        } else {
            savedPatterns.append(pattern)
        }
        persist()
    }

    /// Removes a saved pattern. Does nothing if the pattern isn't stored.
    public func delete(_ pattern: BreathPattern) {
        savedPatterns.removeAll { $0.id == pattern.id }
        persist()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = defaults.data(forKey: storageKey) else { return }
        // Corrupt or unreadable data degrades to an empty list rather than crashing.
        savedPatterns = (try? JSONDecoder().decode([BreathPattern].self, from: data)) ?? []
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(savedPatterns) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
