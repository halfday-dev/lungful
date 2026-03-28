import SwiftUI

/// Display wordmark for Lungful — the breath ring replaces the second "u" in "lungful".
/// At display sizes (28pt+), the ring is visually embedded in the text flow.
public struct LungfulWordmark: View {
    var size: CGFloat = 28
    var color: Color = Theme.bone

    public init(size: CGFloat = 28, color: Color = Theme.bone) {
        self.size = size
        self.color = color
    }

    /// Approximate x-height ratio for SF Pro Light.
    private var ringSize: CGFloat { size * 0.55 }

    /// Tracking value: +2% letter-spacing per brand guide.
    private var tracking: CGFloat { size * 0.02 }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("lungf")
                .font(.system(size: size, weight: .light, design: .default))
                .foregroundStyle(color)
                .tracking(tracking)

            BreathRingShape()
                .fill(color)
                .frame(width: ringSize, height: ringSize)
                // Nudge up slightly so the ring sits on the baseline aligned with x-height
                .offset(y: -size * 0.05)
                .padding(.horizontal, tracking * 0.5)

            Text("l")
                .font(.system(size: size, weight: .light, design: .default))
                .foregroundStyle(color)
                .tracking(tracking)
        }
    }
}
