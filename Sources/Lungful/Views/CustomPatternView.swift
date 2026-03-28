import SwiftUI

/// Builder UI for creating a custom breathing pattern.
public struct CustomPatternView: View {
    @State private var inhaleDuration: Double = 4.0
    @State private var holdInDuration: Double = 0.0
    @State private var exhaleDuration: Double = 4.0
    @State private var holdOutDuration: Double = 0.0
    @State private var cycles: Int = 6

    public init() {}

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 24) {
                        PhaseRow(
                            label: "Inhale",
                            value: $inhaleDuration,
                            color: .cyan
                        )

                        PhaseRow(
                            label: "Hold In",
                            value: $holdInDuration,
                            color: .blue
                        )

                        PhaseRow(
                            label: "Exhale",
                            value: $exhaleDuration,
                            color: .indigo
                        )

                        PhaseRow(
                            label: "Hold Out",
                            value: $holdOutDuration,
                            color: .purple
                        )
                    }

                    // Cycles
                    VStack(spacing: 8) {
                        HStack {
                            Text("Cycles")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))

                            Spacer()

                            Text("\(cycles)")
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(minWidth: 44, alignment: .trailing)
                        }

                        HStack(spacing: 16) {
                            Button(action: { if cycles > 1 { cycles -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white.opacity(cycles > 1 ? 0.6 : 0.2))
                            }
                            .disabled(cycles <= 1)

                            Slider(
                                value: Binding(
                                    get: { Double(cycles) },
                                    set: { cycles = Int($0) }
                                ),
                                in: 1...60,
                                step: 1
                            )
                            .tint(.cyan)

                            Button(action: { if cycles < 60 { cycles += 1 } }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white.opacity(cycles < 60 ? 0.6 : 0.2))
                            }
                            .disabled(cycles >= 60)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.white.opacity(0.06))
                            .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                    )

                    // Session summary
                    HStack(spacing: 24) {
                        SummaryItem(
                            icon: "clock",
                            label: formattedDuration(totalDuration)
                        )

                        SummaryItem(
                            icon: "repeat",
                            label: "\(cycles) cycles"
                        )

                        SummaryItem(
                            icon: "lungs",
                            label: phaseSummary
                        )
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white.opacity(0.04))
                    )

                    // Start button
                    NavigationLink(value: buildPattern()) {
                        Text("Start")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [.cyan, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1.0 : 0.4)
                }
                .padding(24)
            }
        }
        .navigationTitle("Custom Pattern")
        #if !os(macOS)
        .toolbarColorScheme(.dark, for: .navigationBar)
        #endif
        .preferredColorScheme(.dark)
        .navigationDestination(for: BreathPattern.self) { pattern in
            BreathSessionView(pattern: pattern)
        }
    }

    // MARK: - Computed

    private var isValid: Bool {
        inhaleDuration + exhaleDuration > 0
    }

    private var cycleDuration: TimeInterval {
        inhaleDuration + holdInDuration + exhaleDuration + holdOutDuration
    }

    private var totalDuration: TimeInterval {
        cycleDuration * Double(cycles)
    }

    private var phaseSummary: String {
        let parts = [
            ("In", inhaleDuration),
            ("Hold", holdInDuration),
            ("Out", exhaleDuration),
            ("Hold", holdOutDuration)
        ]
        .filter { $0.1 > 0 }
        .map { "\($0.0) \(formatted($0.1))" }

        return parts.joined(separator: "-")
    }

    private func buildPattern() -> BreathPattern {
        BreathPattern(
            name: "Custom",
            description: "Custom breathing pattern.",
            inhaleDuration: inhaleDuration,
            holdInDuration: holdInDuration,
            exhaleDuration: exhaleDuration,
            holdOutDuration: holdOutDuration,
            cycles: cycles
        )
    }

    private func formattedDuration(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        if mins == 0 { return "\(secs)s" }
        if secs == 0 { return "\(mins)m" }
        return "\(mins)m \(secs)s"
    }

    private func formatted(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
    }
}

// MARK: - Phase Row

private struct PhaseRow: View {
    let label: String
    @Binding var value: Double
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)

                Text(label)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))

                Spacer()

                Text(formattedValue)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(minWidth: 44, alignment: .trailing)

                Text("s")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.4))
            }

            HStack(spacing: 16) {
                Button(action: { if value > 0 { value = max(0, value - 0.5) } }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(value > 0 ? 0.6 : 0.2))
                }
                .disabled(value <= 0)

                Slider(value: $value, in: 0...30, step: 0.5)
                    .tint(color)

                Button(action: { if value < 30 { value = min(30, value + 0.5) } }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(value < 30 ? 0.6 : 0.2))
                }
                .disabled(value >= 30)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.06))
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }

    private var formattedValue: String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
    }
}

// MARK: - Summary Item

private struct SummaryItem: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))

            Text(label)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}
