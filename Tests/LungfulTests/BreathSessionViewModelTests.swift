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
        // Still "running" (session active) but paused internally
        XCTAssertTrue(vm.isRunning)

        vm.resume()
        XCTAssertTrue(vm.isRunning)
        vm.stop()
    }

    // MARK: - Stop

    func testStopResetsState() {
        let vm = makeVM()
        vm.start()
        vm.stop()
        XCTAssertFalse(vm.isRunning)
        XCTAssertFalse(vm.isComplete)
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
}
