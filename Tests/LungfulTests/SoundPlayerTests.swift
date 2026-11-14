import XCTest
@testable import Lungful

final class SoundPlayerTests: XCTestCase {

    private let suiteName = "SoundPlayerTests"

    /// Fresh, isolated UserDefaults per test — never touches .standard.
    private func makeDefaults() -> UserDefaults {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    @MainActor
    func testSoundDefaultsToEnabled() {
        // No stored value → sounds are on. iPads have no haptic engine, so
        // sound must be the out-of-the-box non-visual cue.
        let player = SoundPlayer(defaults: makeDefaults())
        XCTAssertTrue(player.isEnabled)
    }

    @MainActor
    func testTogglePersistsAcrossInstances() {
        let defaults = makeDefaults()
        let player = SoundPlayer(defaults: defaults)

        player.isEnabled = false
        XCTAssertFalse(player.isEnabled)

        // A fresh instance over the same store sees the stored choice.
        let second = SoundPlayer(defaults: defaults)
        XCTAssertFalse(second.isEnabled)

        second.isEnabled = true
        XCTAssertTrue(SoundPlayer(defaults: defaults).isEnabled)
    }
}
