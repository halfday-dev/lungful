import SwiftUI
import Lungful

/// App Store distribution entry point. All product code lives in the
/// `Lungful` package — this target is just the shell that wraps it with
/// a bundle ID, icon, launch screen, and privacy manifest.
@main
struct LungfulAppMain: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
