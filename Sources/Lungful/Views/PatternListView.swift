import SwiftUI

/// Single-column list of available breathing patterns.
public struct PatternListView: View {
    private let patterns = BreathPattern.presets

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                // Custom header
                Text("lungful")
                    .font(.system(size: 28, weight: .light, design: .default))
                    .foregroundStyle(Theme.bone)

                Text("\(patterns.count) patterns")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(Theme.shadow)
            }
            .frame(maxWidth: 600, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)

            LazyVStack(spacing: 20) {
                ForEach(patterns) { pattern in
                    if pattern.name == "Custom" {
                        NavigationLink(value: "custom") {
                            CustomCard()
                        }
                    } else {
                        NavigationLink(value: pattern.id) {
                            PatternCard(pattern: pattern)
                        }
                    }
                }
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Theme.deepStone)
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
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
            // Top row: name + duration badge
            HStack(alignment: .top) {
                Text(pattern.name)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(Theme.bone)

                Spacer()

                // Duration badge
                Text(formattedDuration(pattern.totalDuration))
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundStyle(Theme.shadow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Theme.kilnEdge)
                    )
            }

            Text(pattern.description)
                .font(.system(size: 15, weight: .light, design: .default))
                .foregroundStyle(Theme.dust)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // Phase indicator strip
            PhaseStrip(pattern: pattern)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
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

// MARK: - Phase Indicator Strip

private struct PhaseStrip: View {
    let pattern: BreathPattern

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                let total = pattern.cycleDuration
                if total > 0 {
                    if pattern.inhaleDuration > 0 {
                        Theme.sage
                            .frame(width: geometry.size.width * pattern.inhaleDuration / total)
                    }
                    if pattern.holdInDuration > 0 {
                        Theme.amber
                            .frame(width: geometry.size.width * pattern.holdInDuration / total)
                    }
                    if pattern.exhaleDuration > 0 {
                        Theme.terracotta
                            .frame(width: geometry.size.width * pattern.exhaleDuration / total)
                    }
                    if pattern.holdOutDuration > 0 {
                        Theme.slate
                            .frame(width: geometry.size.width * pattern.holdOutDuration / total)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
        }
        .frame(height: 4)
    }
}

// MARK: - Custom Card

private struct CustomCard: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(Theme.ochre)

            Text("Custom")
                .font(.system(size: 15, weight: .light, design: .default))
                .foregroundStyle(Theme.dust)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Theme.ochre, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
        )
    }
}
