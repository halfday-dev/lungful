import XCTest
@testable import Lungful

final class PatternStoreTests: XCTestCase {

    private let suiteName = "PatternStoreTests"

    /// Fresh, isolated UserDefaults per test — never touches .standard.
    private func makeDefaults() -> UserDefaults {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    private func makePattern(name: String = "Test Pattern") -> BreathPattern {
        BreathPattern(
            name: name,
            description: "Test description.",
            inhaleDuration: 4,
            holdInDuration: 2,
            exhaleDuration: 6,
            holdOutDuration: 0,
            cycles: 5
        )
    }

    @MainActor
    func testStartsEmpty() {
        let store = PatternStore(defaults: makeDefaults())
        XCTAssertTrue(store.savedPatterns.isEmpty)
    }

    @MainActor
    func testSaveAppendsPattern() {
        let store = PatternStore(defaults: makeDefaults())
        let pattern = makePattern()

        store.save(pattern)

        XCTAssertEqual(store.savedPatterns.count, 1)
        XCTAssertEqual(store.savedPatterns.first?.id, pattern.id)
    }

    @MainActor
    func testSaveRoundTripsThroughDefaults() {
        let defaults = makeDefaults()
        let pattern = makePattern(name: "Evening Wind-Down")

        let store = PatternStore(defaults: defaults)
        store.save(pattern)

        // A brand-new store reading the same defaults sees the saved pattern
        // with all fields intact.
        let reloaded = PatternStore(defaults: defaults)
        XCTAssertEqual(reloaded.savedPatterns.count, 1)

        let loaded = reloaded.savedPatterns[0]
        XCTAssertEqual(loaded.id, pattern.id)
        XCTAssertEqual(loaded.name, "Evening Wind-Down")
        XCTAssertEqual(loaded.inhaleDuration, 4)
        XCTAssertEqual(loaded.holdInDuration, 2)
        XCTAssertEqual(loaded.exhaleDuration, 6)
        XCTAssertEqual(loaded.holdOutDuration, 0)
        XCTAssertEqual(loaded.cycles, 5)
    }

    @MainActor
    func testSaveWithExistingIdReplacesInPlace() {
        let store = PatternStore(defaults: makeDefaults())
        var pattern = makePattern(name: "Original")
        store.save(pattern)

        pattern.name = "Renamed"
        pattern.cycles = 9
        store.save(pattern)

        XCTAssertEqual(store.savedPatterns.count, 1)
        XCTAssertEqual(store.savedPatterns.first?.name, "Renamed")
        XCTAssertEqual(store.savedPatterns.first?.cycles, 9)
    }

    @MainActor
    func testDeleteRemovesPattern() {
        let defaults = makeDefaults()
        let store = PatternStore(defaults: defaults)
        let first = makePattern(name: "First")
        let second = makePattern(name: "Second")
        store.save(first)
        store.save(second)

        store.delete(first)

        XCTAssertEqual(store.savedPatterns.count, 1)
        XCTAssertEqual(store.savedPatterns.first?.name, "Second")

        // Deletion persists.
        let reloaded = PatternStore(defaults: defaults)
        XCTAssertEqual(reloaded.savedPatterns.count, 1)
    }

    @MainActor
    func testDeleteUnknownPatternIsNoOp() {
        let store = PatternStore(defaults: makeDefaults())
        store.save(makePattern())

        store.delete(makePattern(name: "Never Saved"))

        XCTAssertEqual(store.savedPatterns.count, 1)
    }

    @MainActor
    func testCorruptDataDegradesToEmptyList() {
        let defaults = makeDefaults()
        defaults.set(Data("not json".utf8), forKey: "lungful.savedPatterns")

        let store = PatternStore(defaults: defaults)

        XCTAssertTrue(store.savedPatterns.isEmpty)

        // Store still works after recovering from corrupt data.
        store.save(makePattern())
        XCTAssertEqual(store.savedPatterns.count, 1)
    }

    @MainActor
    func testSaveOrderIsPreserved() {
        let defaults = makeDefaults()
        let store = PatternStore(defaults: defaults)
        store.save(makePattern(name: "A"))
        store.save(makePattern(name: "B"))
        store.save(makePattern(name: "C"))

        let reloaded = PatternStore(defaults: defaults)
        XCTAssertEqual(reloaded.savedPatterns.map(\.name), ["A", "B", "C"])
    }
}
