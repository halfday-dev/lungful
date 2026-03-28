import SwiftUI

/// The breathing circle — expands on inhale, contracts on exhale.
/// Uses a Timer to drive updates outside of view body evaluation.
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
                // Outer glow
                Circle()
                    .fill(phaseColor.opacity(0.15))
                    .frame(width: baseSize * 1.14, height: baseSize * 1.14)
                    .scaleEffect(viewModel.circleScale)
                    .blur(radius: 30)

                // Main circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [phaseColor.opacity(0.8), phaseColor.opacity(0.3)],
                            center: .center,
                            startRadius: 0,
                            endRadius: baseSize / 2
                        )
                    )
                    .frame(width: baseSize, height: baseSize)
                    .scaleEffect(viewModel.circleScale)

                // Inner ring
                Circle()
                    .strokeBorder(phaseColor.opacity(0.6), lineWidth: 2)
                    .frame(width: baseSize * 0.93, height: baseSize * 0.93)
                    .scaleEffect(viewModel.circleScale)

                // Phase label + cycle count
                VStack(spacing: 8) {
                    Text(viewModel.currentPhase.label)
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundStyle(Theme.bone)
                        .contentTransition(.numericText())
                        .accessibilityLabel(viewModel.currentPhase.accessibilityLabel)

                    if viewModel.isRunning || viewModel.isComplete {
                        Text("\(viewModel.currentCycle) of \(viewModel.totalCycles)")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(Theme.dust)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            // DR-2: No animation on circleScale — the 30fps timer interpolation
            // provides smooth animation at the pace of the actual breath phase.
            // Only animate phase color transitions with a 0.8s cross-fade.
            .animation(.easeInOut(duration: 0.8), value: viewModel.currentPhase)
        }
    }

    private var phaseColor: Color {
        Theme.color(for: viewModel.currentPhase)
    }
}
