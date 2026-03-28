import SwiftUI

/// The breathing circle — expands on inhale, contracts on exhale.
/// Clean flat circle + thin stroke + subtle depth ring. Warm watercolor feel.
public struct BreathCircleView: View {
    @ObservedObject var viewModel: BreathSessionViewModel

    /// Minimum circle diameter.
    private let minSize: CGFloat = 200
    /// Maximum circle diameter.
    private let maxSize: CGFloat = 500

    public var body: some View {
        GeometryReader { geometry in
            let available = min(geometry.size.width, geometry.size.height)
            let baseSize = min(max(available * 0.45, minSize), maxSize)

            ZStack {
                // Subtle depth ring
                Circle()
                    .strokeBorder(phaseColor.opacity(0.2), lineWidth: 2)
                    .frame(width: baseSize * 0.97, height: baseSize * 0.97)
                    .scaleEffect(viewModel.isComplete ? 0.5 : viewModel.circleScale)

                // Main circle — flat fill + thin stroke overlay
                Circle()
                    .fill(phaseColor.opacity(0.4))
                    .overlay(
                        Circle()
                            .strokeBorder(phaseColor.opacity(0.6), lineWidth: 1.5)
                    )
                    .frame(width: baseSize, height: baseSize)
                    .scaleEffect(viewModel.isComplete ? 0.5 : viewModel.circleScale)

                // Phase label + countdown
                phaseLabels
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            // DR-2: No animation on circleScale — the 30fps timer interpolation
            // provides smooth animation at the pace of the actual breath phase.
            // Only animate phase color transitions with a 0.8s cross-fade.
            .animation(.easeInOut(duration: 0.8), value: viewModel.currentPhase)
            // Completion: gentle contract to 0.5 over 1.5s
            .animation(.easeInOut(duration: 1.5), value: viewModel.isComplete)
        }
    }

    @ViewBuilder
    private var phaseLabels: some View {
        VStack(spacing: 6) {
            if viewModel.isComplete {
                Text("Complete")
                    .font(.system(size: 38, weight: .ultraLight, design: .default))
                    .foregroundStyle(Theme.bone)
                    .transition(.opacity)
            } else {
                Text(viewModel.currentPhase.label)
                    .font(.system(size: 38, weight: .ultraLight, design: .default))
                    .foregroundStyle(Theme.bone)
                    .contentTransition(.numericText())
                    .accessibilityLabel(viewModel.currentPhase.accessibilityLabel)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            }

            if viewModel.isRunning && !viewModel.isPaused && !viewModel.isComplete {
                Text(String(format: "%.1f", viewModel.phaseTimeRemaining))
                    .font(.system(size: 16, weight: .light, design: .monospaced))
                    .foregroundStyle(Theme.dust)
                    .contentTransition(.numericText())
                    .monospacedDigit()
            }
        }
    }

    private var phaseColor: Color {
        Theme.color(for: viewModel.currentPhase)
    }
}
