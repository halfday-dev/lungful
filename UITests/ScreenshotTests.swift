import XCTest

/// Drives the app through the five App Store shots (docs/appstore/screenshots.md)
/// and writes full-resolution PNGs to $SHOTS_DIR (passed in as
/// TEST_RUNNER_SHOTS_DIR). Run on a freshly installed app so it's in the trial.
///
///   xcodebuild test -project Lungful.xcodeproj -scheme LungfulScreenshots \
///     -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
///     TEST_RUNNER_SHOTS_DIR=$PWD/docs/appstore/shots
final class ScreenshotTests: XCTestCase {

    private var app: XCUIApplication!
    private var prefix = "shot"

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        prefix = UIDevice.current.userInterfaceIdiom == .pad ? "ipad" : "iphone"
    }

    private func relaunch() {
        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["lungful"].waitForExistence(timeout: 10) ||
                      app.buttons["Menu"].waitForExistence(timeout: 10))
    }

    private func save(_ name: String) {
        let png = XCUIScreen.main.screenshot().pngRepresentation
        let attachment = XCTAttachment(data: png, uniformTypeIdentifier: "public.png")
        attachment.name = "\(prefix)-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
        if let dir = ProcessInfo.processInfo.environment["SHOTS_DIR"] {
            let url = URL(fileURLWithPath: dir).appendingPathComponent("\(prefix)-\(name).png")
            try? png.write(to: url)
        }
    }

    private func openPattern(_ name: String) {
        let card = app.buttons.containing(NSPredicate(format: "label CONTAINS %@", name)).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 5), "no card for \(name)\n\(app.debugDescription)")
        if !card.isHittable { app.swipeUp() }
        card.tap()
    }

    private func begin() {
        let begin = app.buttons["Begin"]
        XCTAssertTrue(begin.waitForExistence(timeout: 5), app.debugDescription)
        begin.tap()
    }

    func testAppStoreScreenshots() {
        app.launch()

        // 1. pattern list
        sleep(2)
        save("1-list")

        // 2. box breathing, mid-inhale
        openPattern("Box Breathing")
        begin()
        sleep(3)
        save("2-session")

        // 3. dutch power breath retention hold
        relaunch()
        openPattern("Dutch Power Breath")
        begin()
        let understand = app.buttons["I understand"]
        if understand.waitForExistence(timeout: 3) { understand.tap() }
        XCTAssertTrue(app.buttons["Release"].waitForExistence(timeout: 300), app.debugDescription)
        sleep(7)
        save("3-hold")

        // 4. custom builder with one duration wheel open
        relaunch()
        let custom = app.buttons["Create custom pattern"]
        if !custom.isHittable { app.swipeUp() }
        XCTAssertTrue(custom.waitForExistence(timeout: 5), app.debugDescription)
        custom.tap()
        let duration = app.buttons.matching(NSPredicate(format: "label MATCHES %@", "^[0-9]+(\\.5)?,? ?s$")).firstMatch
        XCTAssertTrue(duration.waitForExistence(timeout: 5), app.debugDescription)
        duration.tap()
        sleep(1)
        save("4-builder")

        // 5. completion (physiological sigh is the shortest)
        relaunch()
        openPattern("Physiological Sigh")
        begin()
        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 180), app.debugDescription)
        sleep(2)
        save("5-complete")
    }
}
