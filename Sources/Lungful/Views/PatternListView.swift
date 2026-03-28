import SwiftUI

/// Grid of available breathing patterns.
public struct PatternListView: View {
    private let patterns = BreathPattern.presets

    public init() {}

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 20)],
                spacing: 20
            ) {
                ForEach(patterns) { pattern in
                    if pattern.name == "Custom" {
                        NavigationLink(value: "custom") {
                            PatternCard(pattern: pattern)
                        }
                    } else {
                        NavigationLink(value: pattern.id) {
                            PatternCard(pattern: pattern)
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(Theme.deepStone)
        .navigationDestination(for: UUID.self) { id in
            if let pattern = patterns.first(where: { $0.id == id }) {
                BreathSessionView(pattern: pattern)
            }
        }
        .navigationDestination(for: String.self) { value in
            if value == "custom" {
                CustomPatternView()
            }
        }
    }
}

// MARK: - Pattern Card

private struct PatternCard: View {
    let pattern: BreathPattern

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(pattern.name)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.bone)

            Text(pattern.description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Theme.dust)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            HStack(spacing: 16) {
                Label("\(pattern.cycles) cycles", systemImage: "repeat")
                Label(formattedDuration(pattern.totalDuration), systemImage: "clock")
            }
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundStyle(Theme.shadow)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.warmClay)
                .strokeBorder(Theme.kilnEdge, lineWidth: 1)
        )
    }

    private func formattedDuration(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        if mins == 0 { return "\(secs)s" }
        if secs == 0 { return "\(mins)m" }
        return "\(mins)m \(secs)s"
    }
}
