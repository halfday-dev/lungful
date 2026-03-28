import SwiftUI

/// Root view — navigation stack with pattern list.
public struct ContentView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            PatternListView()
                .navigationTitle("Lungful")
                #if !os(macOS)
                .toolbarColorScheme(.dark, for: .navigationBar)
                #endif
                .preferredColorScheme(.dark)
        }
    }
}
