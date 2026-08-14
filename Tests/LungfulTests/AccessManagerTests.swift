import XCTest
@testable import Lungful

final class AccessManagerTests: XCTestCase {

    private let suiteName = "AccessManagerTests"

    private func makeDefaults() -> UserDefaults {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    /// A controllable clock starting at a fixed reference date.
    private final class Clock {
        var current = Date(timeIntervalSinceReferenceDate: 800_000_000)
        func advance(days: Double) { current.addTimeInterval(days * 86_400) }
    }

    @MainActor
    private func makeManager(defaults: UserDefaults, clock: Clock) -> AccessManager {
        AccessManager(defaults: defaults, now: { clock.current })
    }

    // MARK: - Trial

    @MainActor
    func testFirstLaunchStartsSevenDayTrial() {
        let manager = makeManager(defaults: makeDefaults(), clock: Clock())
        XCTAssertEqual(manager.access, .trial(daysRemaining: 7))
        XCTAssertTrue(manager.isFullAccess)
    }

    @MainActor
    func testTrialCountsDown() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)

        clock.advance(days: 2.5)
        manager.refresh()
        XCTAssertEqual(manager.access, .trial(daysRemaining: 5))

        clock.advance(days: 4.4)   // total 6.9 days
        manager.refresh()
        XCTAssertEqual(manager.access, .trial(daysRemaining: 1))
    }

    @MainActor
    func testTrialLapsesAfterSevenDays() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)

        clock.advance(days: 7.01)
        manager.refresh()
        XCTAssertEqual(manager.access, .lapsed)
        XCTAssertFalse(manager.isFullAccess)
    }

    @MainActor
    func testTrialStartPersistsAcrossInstances() {
        let defaults = makeDefaults()
        let clock = Clock()
        _ = makeManager(defaults: defaults, clock: clock)

        clock.advance(days: 3)
        let second = makeManager(defaults: defaults, clock: clock)
        XCTAssertEqual(second.access, .trial(daysRemaining: 4))
    }

    @MainActor
    func testClockSetBackwardsClampsToFullTrial() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)

        clock.advance(days: -30)
        manager.refresh()
        XCTAssertEqual(manager.access, .trial(daysRemaining: 7))
    }

    // MARK: - Unlock

    @MainActor
    func testUnlockOverridesLapse() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)

        clock.advance(days: 30)
        manager.refresh()
        XCTAssertEqual(manager.access, .lapsed)

        manager.setUnlocked(true)
        XCTAssertEqual(manager.access, .unlocked)
        XCTAssertTrue(manager.isFullAccess)
        XCTAssertTrue(manager.canUseBuilder)
    }

    @MainActor
    func testUnlockPersistsAcrossInstances() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)
        manager.setUnlocked(true)

        clock.advance(days: 400)
        let second = makeManager(defaults: defaults, clock: clock)
        XCTAssertEqual(second.access, .unlocked)
    }

    @MainActor
    func testRevocationReturnsToTrialStateMachine() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)
        manager.setUnlocked(true)

        clock.advance(days: 30)
        manager.setUnlocked(false)
        XCTAssertEqual(manager.access, .lapsed)
    }

    // MARK: - Pattern gating

    @MainActor
    func testEverythingUsableDuringTrial() {
        let manager = makeManager(defaults: makeDefaults(), clock: Clock())
        for pattern in BreathPattern.presets {
            XCTAssertTrue(manager.canUse(pattern), "\(pattern.name) should be usable in trial")
        }
        XCTAssertTrue(manager.canUseBuilder)
    }

    @MainActor
    func testOnlyFreeForeverPatternsUsableAfterLapse() {
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)
        clock.advance(days: 8)
        manager.refresh()

        XCTAssertTrue(manager.canUse(.boxBreathing))
        XCTAssertTrue(manager.canUse(.physiologicalSigh))
        XCTAssertFalse(manager.canUse(.relaxation478))
        XCTAssertFalse(manager.canUse(.coherentBreathing))
        XCTAssertFalse(manager.canUse(.wimHof))
        XCTAssertFalse(manager.canUseBuilder)

        // Saved customs are part of the paid toolkit — locked when lapsed.
        let custom = BreathPattern(
            name: "My Pattern",
            description: "Saved custom.",
            inhaleDuration: 4,
            exhaleDuration: 4,
            cycles: 6
        )
        XCTAssertFalse(manager.canUse(custom))
    }

    @MainActor
    func testSavedCustomNamedLikePresetStaysLockedAfterLapse() {
        // Gating is by preset identity, not name — naming a custom pattern
        // "Box Breathing" must not make it free.
        let defaults = makeDefaults()
        let clock = Clock()
        let manager = makeManager(defaults: defaults, clock: clock)
        clock.advance(days: 8)
        manager.refresh()

        let imposter = BreathPattern(
            name: "Box Breathing",
            description: "A saved custom wearing a preset's name.",
            inhaleDuration: 10,
            exhaleDuration: 10,
            cycles: 30
        )
        XCTAssertFalse(manager.canUse(imposter))
        XCTAssertTrue(manager.canUse(.boxBreathing))
    }
}
