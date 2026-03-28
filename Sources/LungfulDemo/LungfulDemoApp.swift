import SwiftUI
import Lungful

@main
struct LungfulDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PatternListView()
                    .navigationTitle("Lungful")
            }
        }
    }
}
