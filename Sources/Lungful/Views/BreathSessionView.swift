import SwiftUI

/// Full-screen breathing session — circle centered, controls at bottom.
public struct BreathSessionView: View {
    @StateObject private var viewModel: BreathSessionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCompletionControls: Bool = false

    private let pattern: BreathPattern

    public init(pattern: BreathPattern) {
        self.pattern = pattern
        _viewModel = StateObject(wrappedValue: BreathSessionViewModel(pattern: pattern))
    }

    public var body: some View {
        ZStack {
            // Background — deep stone base
            Theme.deepStone
                .ignoresSafeArea()

            // DR-7: Subtle phase-colored tint overlay — fades to neutral on completion
            Rectangle()
                .fill(viewModel.isComplete ? Color.clear : phaseColor.opacity(0.03))
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 2.0), value: viewModel.currentPhase)
                .animation(.easeInOut(duration: 1.5), value: viewModel.isComplete)

            VStack(spacing: 0) {
                // DR-5: Cycle count at the very top of the screen
                if viewModel.isRunning || viewModel.isComplete {
                    Text("\(viewModel.currentCycle) of \(viewModel.totalCycles)")
                        .font(.system(size: 13, weight: .regular, design: .default))
                        .foregroundStyle(Theme.shadow)
                        .padding(.top, 16)
                } else {
                    Spacer().frame(height: 32)
                }

                Spacer()

                // Breath circle
                BreathCircleView(viewModel: viewModel)
                    .frame(maxWidth: .infinity)
                    .frame(height: 500)

                Spacer()

                // Pattern info
                VStack(spacing: 4) {
                    Text(pattern.name)
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundStyle(Theme.bone.opacity(0.8))

                    Text(phaseSummary)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundStyle(Theme.shadow)
                }
                .padding(.bottom, 32)

                // DR-6: Text-only controls
                sessionControls
                    .padding(.bottom, 60)
            }
        }
        .onChange(of: viewModel.isComplete) { _, complete in
            if complete {
                showCompletionControls = false
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(2))
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showCompletionControls = true
                    }
                }
            } else {
                showCompletionControls = false
            }
        }
        .navigationBarBackButtonHidden(viewModel.isRunning)
        #if !os(macOS)
        .statusBarHidden(viewModel.isRunning)
        #endif
    }

    // MARK: - Controls

    @ViewBuilder
    private var sessionControls: some View {
        HStack(spacing: 40) {
            if viewModel.isRunning && viewModel.isPaused {
                // Paused
                Button("Resume") { viewModel.resume() }
                    .foregroundStyle(Theme.dust)

                Button("End") { viewModel.stop() }
                    .foregroundStyle(Theme.dust)
            } else if viewModel.isRunning {
                // Running
                Button("Pause") { viewModel.pause() }
                    .foregroundStyle(Theme.dust)

                Button("End") { viewModel.stop() }
                    .foregroundStyle(Theme.dust)
            } else if viewModel.isComplete && showCompletionControls {
                // Complete — delayed fade-in after moment of stillness
                Button("Again") { viewModel.start() }
                    .foregroundStyle(Theme.ochre)

                Button("Done") { dismiss() }
                    .foregroundStyle(Theme.dust)
            } else if viewModel.isComplete {
                // Completion animating — moment of stillness, no controls
                Color.clear.frame(height: 20)
            } else {
                // Pre-session
                Button("Begin") { viewModel.start() }
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(Theme.ochre)
            }
        }
        .font(.system(size: 17, weight: .regular, design: .default))
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    /// Phase color for background tint.
    private var phaseColor: Color {
        Theme.color(for: viewModel.currentPhase)
    }

    private var phaseSummary: String {
        let parts = [
            ("In", pattern.inhaleDuration),
            ("Hold", pattern.holdInDuration),
            ("Out", pattern.exhaleDuration),
            ("Hold", pattern.holdOutDuration)
        ]
        .filter { $0.1 > 0 }
        .map { "\($0.0) \(formatted($0.1))s" }

        return parts.joined(separator: " · ")
    }

    private func formatted(_ value: TimeInterval) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
    }
}
