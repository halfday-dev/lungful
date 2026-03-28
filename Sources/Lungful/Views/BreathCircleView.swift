import SwiftUI

/// The breathing circle — expands on inhale, contracts on exhale.
/// Uses a Timer to drive updates outside of view body evaluation.
public struct BreathCircleView: View {
    @ObservedObject var viewModel: BreathSessionViewModel

    private let baseSize: CGFloat = 280

    public var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(phaseColor.opacity(0.15))
                .frame(width: baseSize + 40, height: baseSize + 40)
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
                .frame(width: baseSize - 20, height: baseSize - 20)
                .scaleEffect(viewModel.circleScale)

            // Phase label + cycle count
            VStack(spacing: 8) {
                Text(viewModel.currentPhase.label)
                    .font(.system(size: 32, weight: .light, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .accessibilityLabel(viewModel.currentPhase.accessibilityLabel)

                if viewModel.isRunning || viewModel.isComplete {
                    Text("\(viewModel.currentCycle) of \(viewModel.totalCycles)")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .animation(.easeInOut(duration: 0.15), value: viewModel.circleScale)
        .animation(.easeInOut(duration: 0.15), value: viewModel.currentPhase)
    }

    private var phaseColor: Color {
        switch viewModel.currentPhase {
        case .inhale:  return .cyan
        case .holdIn:  return .blue
        case .exhale:  return .indigo
        case .holdOut: return .purple
        }
    }
}
