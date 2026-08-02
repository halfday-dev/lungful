import SwiftUI

/// Display wordmark for Lungful — plain lowercase text, lightly tracked.
/// The breath ring is used as a standalone mark (see `BreathRingShape`);
/// the ring-as-letter treatment was retired 2026-07-21 after device testing
/// ("lungf◯l" read as odd in the header). Brand guide updated to match.
public struct LungfulWordmark: View {
    var size: CGFloat = 28
    var color: Color = Theme.bone

    public init(size: CGFloat = 28, color: Color = Theme.bone) {
        self.size = size
        self.color = color
    }

    /// Tracking value: +2% letter-spacing per brand guide.
    private var tracking: CGFloat { size * 0.02 }

    public var body: some View {
        Text("lungful")
            .font(.system(size: size, weight: .light, design: .default))
            .foregroundStyle(color)
            .tracking(tracking)
    }
}
