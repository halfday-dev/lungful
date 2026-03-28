import XCTest
@testable import Lungful

@MainActor
final class BreathSessionViewModelTests: XCTestCase {

    private func makeVM(_ pattern: BreathPattern = .boxBreathing) -> BreathSessionViewModel {
        BreathSessionViewModel(pattern: pattern)
    }

    // MARK: - Initial State

    func testInitialState() {
        let vm = makeVM()
        XCTAssertFalse(vm.isRunning)
        XCTAssertFalse(vm.isComplete)
        XCTAssertFalse(vm.isPaused)
        XCTAssertEqual(vm.currentCycle, 1)
        XCTAssertEqual(vm.phaseProgress, 0.0)
        XCTAssertEqual(vm.totalCycles, 8)
    }

    // MARK: - Start

    func testStartSetsRunning() {
        let vm = makeVM()
        vm.start()
        XCTAssertTrue(vm.isRunning)
        XCTAssertFalse(vm.isComplete)
        XCTAssertEqual(vm.currentPhase, .inhale)
        vm.stop()
    }

    // MARK: - Pause / Resume

    func testPauseAndResume() {
        let vm = makeVM()
        vm.start()
        vm.pause()
        XCTAssertTrue(vm.isRunning)
        XCTAssertTrue(vm.isPaused)

        vm.resume()
        XCTAssertTrue(vm.isRunning)
        XCTAssertFalse(vm.isPaused)
        vm.stop()
    }

    // MARK: - Stop

    func testStopResetsState() {
        let vm = makeVM()
        vm.start()
        vm.stop()
        XCTAssertFalse(vm.isRunning)
        XCTAssertFalse(vm.isComplete)
        XCTAssertFalse(vm.isPaused)
        XCTAssertEqual(vm.currentCycle, 1)
    }

    // MARK: - Pattern Without Holds

    func testCoherentBreathingStartsWithInhale() {
        let vm = makeVM(.coherentBreathing)
        vm.start()
        XCTAssertEqual(vm.currentPhase, .inhale)
        vm.stop()
    }

    // MARK: - Total Cycles

    func testTotalCyclesMatchesPattern() {
        let vm = makeVM(.relaxation478)
        XCTAssertEqual(vm.totalCycles, 4)
    }

    // MARK: - Completion via update(at:)

    func testCompletionAfterFullCycle() {
        // 1-cycle pattern: inhale 2s, exhale 2s
        let pattern = BreathPattern(
            name: "Quick",
            description: "Test",
            inhaleDuration: 2,
            exhaleDuration: 2,
            cycles: 1
        )
        let vm = makeVM(pattern)
        vm.start()

        let start = Date.now
        // Advance past inhale (2s)
        vm.update(at: start.addingTimeInterval(2.5))
        XCTAssertEqual(vm.currentPhase, .exhale)
        XCTAssertFalse(vm.isComplete)

        // Advance past exhale (2s more)
        vm.update(at: start.addingTimeInterval(5.0))
        XCTAssertTrue(vm.isComplete)
        XCTAssertFalse(vm.isRunning)
    }

    // MARK: - Pause Timing

    func testPauseDoesNotAdvanceProgress() {
        let pattern = BreathPattern(
            name: "Test",
            description: "Test",
            inhaleDuration: 10,
            exhaleDuration: 10,
            cycles: 1
        )
        let vm = makeVM(pattern)
        vm.start()

        // Advance 2s into inhale (progress ≈ 0.2)
        let t0 = Date.now
        vm.update(at: t0.addingTimeInterval(2.0))
        let progressBeforePause = vm.phaseProgress
        XCTAssertGreaterThan(progressBeforePause, 0.1)
        XCTAssertLessThan(progressBeforePause, 0.3)

        // Pause
        vm.pause()
        XCTAssertTrue(vm.isPaused)

        // Advance 20s while paused — progress should NOT change
        vm.update(at: t0.addingTimeInterval(22.0))
        XCTAssertEqual(vm.phaseProgress, progressBeforePause, accuracy: 0.01,
                        "Progress must not advance while paused")

        // Resume
        vm.resume()
        // Advance 1s after resume — progress should be around where we paused + 0.1
        let resumeTime = Date.now
        vm.update(at: resumeTime.addingTimeInterval(1.0))
        XCTAssertGreaterThan(vm.phaseProgress, progressBeforePause,
                              "Progress should advance after resume")
        XCTAssertLessThan(vm.phaseProgress, 0.5,
                           "Progress should not have jumped far")
        vm.stop()
    }

    // MARK: - Multi-cycle completion

    func testMultiCycleCompletion() {
        let pattern = BreathPattern(
            name: "Multi",
            description: "Test",
            inhaleDuration: 1,
            exhaleDuration: 1,
            cycles: 2
        )
        let vm = makeVM(pattern)
        vm.start()

        let start = Date.now
        // Complete cycle 1
        vm.update(at: start.addingTimeInterval(2.5))
        XCTAssertEqual(vm.currentCycle, 2)
        XCTAssertFalse(vm.isComplete)

        // Complete cycle 2
        vm.update(at: start.addingTimeInterval(5.0))
        XCTAssertTrue(vm.isComplete)
    }
}
