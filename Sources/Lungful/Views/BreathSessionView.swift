import SwiftUI

/// Full-screen breathing session — circle centered, controls at bottom.
public struct BreathSessionView: View {
    @StateObject private var viewModel: BreathSessionViewModel
    @Environment(\.dismiss) private var dismiss

    private let pattern: BreathPattern

    public init(pattern: BreathPattern) {
        self.pattern = pattern
        _viewModel = StateObject(wrappedValue: BreathSessionViewModel(pattern: pattern))
    }

    public var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Breath circle
                BreathCircleView(viewModel: viewModel)
                    .frame(maxWidth: .infinity)

                Spacer()

                // Pattern info
                VStack(spacing: 4) {
                    Text(pattern.name)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))

                    Text(phaseSummary)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.4))
                }
                .padding(.bottom, 32)

                // Controls
                HStack(spacing: 40) {
                    if viewModel.isRunning {
                        Button(action: { viewModel.pause() }) {
                            controlIcon("pause.fill")
                        }

                        Button(action: { viewModel.stop() }) {
                            controlIcon("stop.fill")
                        }
                    } else if viewModel.isComplete {
                        Button(action: { viewModel.start() }) {
                            controlIcon("arrow.counterclockwise")
                        }

                        Button(action: { dismiss() }) {
                            controlIcon("xmark")
                        }
                    } else {
                        Button(action: { viewModel.start() }) {
                            controlIcon("play.fill")
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .navigationBarBackButtonHidden(viewModel.isRunning)
        #if !os(macOS)
        .statusBarHidden(viewModel.isRunning)
        #endif
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

    private func controlIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 28, weight: .medium))
            .foregroundStyle(.white)
            .frame(width: 64, height: 64)
            .background(Circle().fill(.white.opacity(0.1)))
    }
}
