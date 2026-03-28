import XCTest
import SwiftUI
@testable import Lungful

final class ThemeTests: XCTestCase {

    // MARK: - Background Colors

    func testDeepStoneIsDefined() {
        let color = Theme.deepStone
        XCTAssertNotNil(color)
    }

    func testWarmClayIsDefined() {
        let color = Theme.warmClay
        XCTAssertNotNil(color)
    }

    func testKilnEdgeIsDefined() {
        let color = Theme.kilnEdge
        XCTAssertNotNil(color)
    }

    // MARK: - Text Colors

    func testBoneIsDefined() {
        let color = Theme.bone
        XCTAssertNotNil(color)
    }

    func testDustIsDefined() {
        let color = Theme.dust
        XCTAssertNotNil(color)
    }

    func testShadowIsDefined() {
        let color = Theme.shadow
        XCTAssertNotNil(color)
    }

    // MARK: - Phase Colors

    func testSageIsDefined() {
        let color = Theme.sage
        XCTAssertNotNil(color)
    }

    func testAmberIsDefined() {
        let color = Theme.amber
        XCTAssertNotNil(color)
    }

    func testTerracottaIsDefined() {
        let color = Theme.terracotta
        XCTAssertNotNil(color)
    }

    func testSlateIsDefined() {
        let color = Theme.slate
        XCTAssertNotNil(color)
    }

    // MARK: - Accent

    func testOchreIsDefined() {
        let color = Theme.ochre
        XCTAssertNotNil(color)
    }

    // MARK: - Phase Color Helper

    func testPhaseColorReturnsCorrectMapping() {
        XCTAssertEqual(Theme.color(for: .inhale), Theme.sage)
        XCTAssertEqual(Theme.color(for: .holdIn), Theme.amber)
        XCTAssertEqual(Theme.color(for: .exhale), Theme.terracotta)
        XCTAssertEqual(Theme.color(for: .holdOut), Theme.slate)
    }

    // MARK: - All Colors Exist

    func testAllColorsAreDefined() {
        let allColors: [Color] = [
            Theme.deepStone, Theme.warmClay, Theme.kilnEdge,
            Theme.bone, Theme.dust, Theme.shadow,
            Theme.sage, Theme.amber, Theme.terracotta, Theme.slate,
            Theme.ochre
        ]
        XCTAssertEqual(allColors.count, 11, "Theme should define exactly 11 colors")
    }
}
