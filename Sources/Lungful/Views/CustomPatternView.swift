import SwiftUI

/// Builder UI for creating a custom breathing pattern.
public struct CustomPatternView: View {
    @State private var inhaleDuration: Double = 4.0
    @State private var holdInDuration: Double = 0.0
    @State private var exhaleDuration: Double = 4.0
    @State private var holdOutDuration: Double = 0.0
    @State private var cycles: Int = 6
    @State private var editingPhase: String?

    public init() {}

    public var body: some View {
        ZStack {
            Theme.deepStone
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    // Live preview circle
                    PreviewCircleView(
                        inhaleDuration: inhaleDuration,
                        holdInDuration: holdInDuration,
                        exhaleDuration: exhaleDuration,
                        holdOutDuration: holdOutDuration
                    )
                    .frame(height: 140)

                    // Phase rows — no card backgrounds, generous spacing
                    VStack(spacing: 20) {
                        PhaseRow(
                            label: "Inhale",
                            value: $inhaleDuration,
                            color: Theme.sage,
                            editingPhase: $editingPhase
                        )

                        PhaseRow(
                            label: "Hold In",
                            value: $holdInDuration,
                            color: Theme.amber,
                            editingPhase: $editingPhase
                        )

                        PhaseRow(
                            label: "Exhale",
                            value: $exhaleDuration,
                            color: Theme.terracotta,
                            editingPhase: $editingPhase
                        )

                        PhaseRow(
                            label: "Hold Out",
                            value: $holdOutDuration,
                            color: Theme.slate,
                            editingPhase: $editingPhase
                        )
                    }

                    // Cycles — discrete stepper control
                    HStack {
                        Text("Cycles")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundStyle(Theme.dust)

                        Spacer()

                        HStack(spacing: 20) {
                            Button(action: { if cycles > 1 { cycles -= 1 } }) {
                                Text("\u{2212}")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundStyle(cycles > 1 ? Theme.dust : Theme.shadow)
                            }
                            .disabled(cycles <= 1)

                            Text("\(cycles)")
                                .font(.system(size: 24, weight: .semibold, design: .default))
                                .foregroundStyle(Theme.bone)
                                .frame(minWidth: 44, alignment: .center)

                            Button(action: { if cycles < 60 { cycles += 1 } }) {
                                Text("+")
                                    .font(.system(size: 22, weight: .regular, design: .default))
                                    .foregroundStyle(cycles < 60 ? Theme.dust : Theme.shadow)
                            }
                            .disabled(cycles >= 60)
                        }
                    }

                    // Summary line
                    Text(summaryLine)
                        .font(.system(size: 13, weight: .light, design: .monospaced))
                        .foregroundStyle(Theme.dust)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Start button — solid ochre fill, black text, no gradient
                    NavigationLink(value: buildPattern()) {
                        Text("Start")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Theme.ochre)
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

    /// Compact phase summary like "4-0-4-0"
    private var compactPhaseSummary: String {
        [inhaleDuration, holdInDuration, exhaleDuration, holdOutDuration]
            .map { formatted($0) }
            .joined(separator: "-")
    }

    /// Single summary line: "6 cycles · 48s · 4-0-4-0"
    private var summaryLine: String {
        "\(cycles) cycles \u{00B7} \(formattedDuration(totalDuration)) \u{00B7} \(compactPhaseSummary)"
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

/// Minimal phase control: colored dot, label, tappable value with inline wheel picker.
private struct PhaseRow: View {
    let label: String
    @Binding var value: Double
    let color: Color
    @Binding var editingPhase: String?

    private var isEditing: Bool {
        editingPhase == label
    }

    private static let pickerValues: [Double] = {
        stride(from: 0.0, through: 30.0, by: 0.5).map { $0 }
    }()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)

                Text(label)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundStyle(Theme.dust)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        if isEditing {
                            editingPhase = nil
                        } else {
                            editingPhase = label
                        }
                    }
                } label: {
                    HStack(spacing: 2) {
                        Text(formattedValue)
                            .font(.system(size: 24, weight: .semibold, design: .default))
                            .foregroundStyle(isEditing ? color : Theme.bone)
                            .frame(minWidth: 44, alignment: .trailing)

                        Text("s")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundStyle(isEditing ? color.opacity(0.6) : Theme.shadow)
                    }
                }
                .buttonStyle(.plain)
            }

            if isEditing {
                Picker("", selection: $value) {
                    ForEach(Self.pickerValues, id: \.self) { v in
                        Text(Self.formatPickerValue(v))
                            .tag(v)
                    }
                }
                #if os(iOS)
                .pickerStyle(.wheel)
                #endif
                .frame(height: 140)
                .tint(color)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private var formattedValue: String {
        Self.formatPickerValue(value)
    }

    fileprivate static func formatPickerValue(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", v)
            : String(format: "%.1f", v)
    }
}

// MARK: - Preview Circle

/// Small animated breath circle that loops through the configured pattern.
/// Runs its own timer — no BreathSessionViewModel needed.
private struct PreviewCircleView: View {
    let inhaleDuration: Double
    let holdInDuration: Double
    let exhaleDuration: Double
    let holdOutDuration: Double

    private let diameter: CGFloat = 120

    @State private var currentPhase: BreathPhase = .inhale
    @State private var circleScale: CGFloat = 0.4
    @State private var phaseStartDate: Date = .now
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Depth ring
            Circle()
                .strokeBorder(phaseColor.opacity(0.2), lineWidth: 2)
                .frame(width: diameter * 0.97, height: diameter * 0.97)
                .scaleEffect(circleScale)

            // Main circle — flat fill + thin stroke
            Circle()
                .fill(phaseColor.opacity(0.4))
                .overlay(
                    Circle()
                        .strokeBorder(phaseColor.opacity(0.6), lineWidth: 1.5)
                )
                .frame(width: diameter, height: diameter)
                .scaleEffect(circleScale)
        }
        .animation(.easeInOut(duration: 0.8), value: currentPhase)
        .onAppear { startAnimation() }
        .onDisappear { stopAnimation() }
        .onChange(of: inhaleDuration) { _, _ in restartAnimation() }
        .onChange(of: holdInDuration) { _, _ in restartAnimation() }
        .onChange(of: exhaleDuration) { _, _ in restartAnimation() }
        .onChange(of: holdOutDuration) { _, _ in restartAnimation() }
    }

    private var phaseColor: Color {
        Theme.color(for: currentPhase)
    }

    /// Active phases based on current duration values (skip zero-duration phases).
    private var activePhases: [BreathPhase] {
        var phases: [BreathPhase] = []
        if inhaleDuration > 0 { phases.append(.inhale) }
        if holdInDuration > 0 { phases.append(.holdIn) }
        if exhaleDuration > 0 { phases.append(.exhale) }
        if holdOutDuration > 0 { phases.append(.holdOut) }
        return phases
    }

    private func duration(for phase: BreathPhase) -> Double {
        switch phase {
        case .inhale:  return inhaleDuration
        case .holdIn:  return holdInDuration
        case .exhale:  return exhaleDuration
        case .holdOut: return holdOutDuration
        }
    }

    private func targetScale(for phase: BreathPhase) -> CGFloat {
        switch phase {
        case .inhale, .holdIn:  return 1.0
        case .exhale, .holdOut: return 0.4
        }
    }

    private func previousPhaseScale() -> CGFloat {
        let phases = activePhases
        guard let idx = phases.firstIndex(of: currentPhase), idx > 0 else {
            return phases.last.map { targetScale(for: $0) } ?? 0.4
        }
        return targetScale(for: phases[idx - 1])
    }

    private func startAnimation() {
        let phases = activePhases
        guard !phases.isEmpty else { return }

        currentPhase = phases[0]
        phaseStartDate = .now
        circleScale = previousPhaseScale()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { _ in
            Task { @MainActor in
                tick()
            }
        }
    }

    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }

    private func restartAnimation() {
        stopAnimation()
        startAnimation()
    }

    private func tick() {
        let phases = activePhases
        guard !phases.isEmpty else { return }

        let dur = duration(for: currentPhase)
        guard dur > 0 else {
            advancePhase()
            return
        }

        let elapsed = Date.now.timeIntervalSince(phaseStartDate)
        let progress = min(elapsed / dur, 1.0)

        let startScale = previousPhaseScale()
        let endScale = targetScale(for: currentPhase)
        circleScale = startScale + (endScale - startScale) * progress

        if progress >= 1.0 {
            advancePhase()
        }
    }

    private func advancePhase() {
        let phases = activePhases
        guard !phases.isEmpty else { return }

        if let idx = phases.firstIndex(of: currentPhase) {
            let next = idx + 1
            if next < phases.count {
                currentPhase = phases[next]
            } else {
                // Loop back to first phase
                currentPhase = phases[0]
            }
        } else {
            currentPhase = phases[0]
        }
        phaseStartDate = .now
    }
}
