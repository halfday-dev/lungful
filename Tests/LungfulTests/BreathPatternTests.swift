import XCTest
@testable import Lungful

final class BreathPatternTests: XCTestCase {

    // MARK: - Properties

    func testCycleDuration() {
        let pattern = BreathPattern.boxBreathing
        XCTAssertEqual(pattern.cycleDuration, 16.0) // 4+4+4+4
    }

    func testTotalDuration() {
        let pattern = BreathPattern.boxBreathing
        XCTAssertEqual(pattern.totalDuration, 128.0) // 16 * 8
    }

    func testCoherentBreathingDuration() {
        let pattern = BreathPattern.coherentBreathing
        XCTAssertEqual(pattern.cycleDuration, 11.0) // 5.5+5.5
        XCTAssertEqual(pattern.totalDuration, 110.0)
    }

    // MARK: - Active Phases

    func testActivePhases_allFour() {
        let pattern = BreathPattern.boxBreathing
        XCTAssertEqual(pattern.activePhases, [.inhale, .holdIn, .exhale, .holdOut])
    }

    func testActivePhases_skipsZeroDuration() {
        let pattern = BreathPattern.coherentBreathing
        XCTAssertEqual(pattern.activePhases, [.inhale, .exhale])
    }

    // MARK: - Next Phase

    func testNextPhase_boxBreathing() {
        let p = BreathPattern.boxBreathing
        XCTAssertEqual(p.nextPhase(after: .inhale), .holdIn)
        XCTAssertEqual(p.nextPhase(after: .holdIn), .exhale)
        XCTAssertEqual(p.nextPhase(after: .exhale), .holdOut)
        XCTAssertNil(p.nextPhase(after: .holdOut))
    }

    func testNextPhase_noHolds() {
        let p = BreathPattern.coherentBreathing
        XCTAssertEqual(p.nextPhase(after: .inhale), .exhale)
        XCTAssertNil(p.nextPhase(after: .exhale))
    }

    // MARK: - Codable

    func testEncodeDecode() throws {
        let original = BreathPattern.boxBreathing
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(BreathPattern.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.name, original.name)
        XCTAssertEqual(decoded.inhaleDuration, original.inhaleDuration)
        XCTAssertEqual(decoded.holdInDuration, original.holdInDuration)
        XCTAssertEqual(decoded.exhaleDuration, original.exhaleDuration)
        XCTAssertEqual(decoded.holdOutDuration, original.holdOutDuration)
        XCTAssertEqual(decoded.cycles, original.cycles)
    }

    // MARK: - Presets

    func testAllPresetsHavePositiveInhaleAndExhale() {
        for preset in BreathPattern.presets {
            XCTAssertGreaterThan(preset.inhaleDuration, 0, "\(preset.name) inhale must be > 0")
            XCTAssertGreaterThan(preset.exhaleDuration, 0, "\(preset.name) exhale must be > 0")
            XCTAssertGreaterThan(preset.cycles, 0, "\(preset.name) cycles must be > 0")
        }
    }

    // MARK: - Single Cycle Pattern

    func testSingleCyclePattern() {
        let pattern = BreathPattern(
            name: "Single",
            description: "One cycle",
            inhaleDuration: 3,
            exhaleDuration: 3,
            cycles: 1
        )
        XCTAssertEqual(pattern.cycles, 1)
        XCTAssertEqual(pattern.cycleDuration, 6.0)
        XCTAssertEqual(pattern.totalDuration, 6.0)
        XCTAssertEqual(pattern.activePhases, [.inhale, .exhale])
    }

    // MARK: - Inhale+Exhale Only (No Holds)

    func testPatternWithNoHolds() {
        let pattern = BreathPattern(
            name: "No Holds",
            description: "Just in and out",
            inhaleDuration: 4,
            holdInDuration: 0,
            exhaleDuration: 6,
            holdOutDuration: 0,
            cycles: 3
        )
        XCTAssertEqual(pattern.activePhases, [.inhale, .exhale])
        XCTAssertEqual(pattern.cycleDuration, 10.0)
        XCTAssertNil(pattern.nextPhase(after: .exhale))
        XCTAssertEqual(pattern.nextPhase(after: .inhale), .exhale)
    }
}
