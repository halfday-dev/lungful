import SwiftUI

/// The Lungful breath ring logo — a nearly-complete circle with variable thickness.
/// Thickest at bottom (exhale/grounded), thinnest at gap (breath entry).
/// Converted from docs/brand/breath-ring.svg.
public struct BreathRingShape: Shape {
    public func path(in rect: CGRect) -> Path {
        let scaleX = rect.width / 100.0
        let scaleY = rect.height / 100.0

        var path = Path()

        // Outer contour (clockwise from right side of gap)
        path.move(to: CGPoint(x: 61.43 * scaleX, y: 13.76 * scaleY))
        path.addLine(to: CGPoint(x: 69.00 * scaleX, y: 17.09 * scaleY))
        path.addLine(to: CGPoint(x: 76.87 * scaleX, y: 23.13 * scaleY))
        path.addLine(to: CGPoint(x: 82.91 * scaleX, y: 31.00 * scaleY))
        path.addLine(to: CGPoint(x: 86.70 * scaleX, y: 40.17 * scaleY))
        path.addLine(to: CGPoint(x: 88.00 * scaleX, y: 50.00 * scaleY))
        path.addLine(to: CGPoint(x: 86.70 * scaleX, y: 59.83 * scaleY))
        path.addLine(to: CGPoint(x: 82.91 * scaleX, y: 69.00 * scaleY))
        path.addLine(to: CGPoint(x: 76.87 * scaleX, y: 76.87 * scaleY))
        path.addLine(to: CGPoint(x: 69.00 * scaleX, y: 82.91 * scaleY))
        path.addLine(to: CGPoint(x: 59.83 * scaleX, y: 86.70 * scaleY))
        path.addLine(to: CGPoint(x: 50.00 * scaleX, y: 88.00 * scaleY))
        path.addLine(to: CGPoint(x: 40.17 * scaleX, y: 86.70 * scaleY))
        path.addLine(to: CGPoint(x: 31.00 * scaleX, y: 82.91 * scaleY))
        path.addLine(to: CGPoint(x: 23.13 * scaleX, y: 76.87 * scaleY))
        path.addLine(to: CGPoint(x: 17.09 * scaleX, y: 69.00 * scaleY))
        path.addLine(to: CGPoint(x: 13.30 * scaleX, y: 59.83 * scaleY))
        path.addLine(to: CGPoint(x: 12.00 * scaleX, y: 50.00 * scaleY))
        path.addLine(to: CGPoint(x: 13.30 * scaleX, y: 40.17 * scaleY))
        path.addLine(to: CGPoint(x: 17.09 * scaleX, y: 31.00 * scaleY))
        path.addLine(to: CGPoint(x: 23.13 * scaleX, y: 23.13 * scaleY))
        path.addLine(to: CGPoint(x: 31.00 * scaleX, y: 17.09 * scaleY))
        path.addLine(to: CGPoint(x: 38.57 * scaleX, y: 13.76 * scaleY))

        // Inner contour (counter-clockwise back to start)
        path.addLine(to: CGPoint(x: 39.12 * scaleX, y: 15.52 * scaleY))
        path.addLine(to: CGPoint(x: 31.97 * scaleX, y: 18.77 * scaleY))
        path.addLine(to: CGPoint(x: 24.61 * scaleX, y: 24.61 * scaleY))
        path.addLine(to: CGPoint(x: 19.10 * scaleX, y: 32.16 * scaleY))
        path.addLine(to: CGPoint(x: 15.82 * scaleX, y: 40.84 * scaleY))
        path.addLine(to: CGPoint(x: 14.97 * scaleX, y: 50.00 * scaleY))
        path.addLine(to: CGPoint(x: 16.58 * scaleX, y: 58.95 * scaleY))
        path.addLine(to: CGPoint(x: 20.46 * scaleX, y: 67.06 * scaleY))
        path.addLine(to: CGPoint(x: 26.27 * scaleX, y: 73.73 * scaleY))
        path.addLine(to: CGPoint(x: 33.53 * scaleX, y: 78.52 * scaleY))
        path.addLine(to: CGPoint(x: 41.65 * scaleX, y: 81.15 * scaleY))
        path.addLine(to: CGPoint(x: 50.00 * scaleX, y: 81.50 * scaleY))
        path.addLine(to: CGPoint(x: 58.35 * scaleX, y: 81.15 * scaleY))
        path.addLine(to: CGPoint(x: 66.47 * scaleX, y: 78.52 * scaleY))
        path.addLine(to: CGPoint(x: 73.73 * scaleX, y: 73.73 * scaleY))
        path.addLine(to: CGPoint(x: 79.54 * scaleX, y: 67.06 * scaleY))
        path.addLine(to: CGPoint(x: 83.42 * scaleX, y: 58.95 * scaleY))
        path.addLine(to: CGPoint(x: 85.03 * scaleX, y: 50.00 * scaleY))
        path.addLine(to: CGPoint(x: 84.18 * scaleX, y: 40.84 * scaleY))
        path.addLine(to: CGPoint(x: 80.90 * scaleX, y: 32.16 * scaleY))
        path.addLine(to: CGPoint(x: 75.39 * scaleX, y: 24.61 * scaleY))
        path.addLine(to: CGPoint(x: 68.03 * scaleX, y: 18.77 * scaleY))
        path.addLine(to: CGPoint(x: 60.88 * scaleX, y: 15.52 * scaleY))

        path.closeSubpath()
        return path
    }
}

/// The breath ring logo as a reusable view.
public struct BreathRingLogo: View {
    var size: CGFloat = 24
    var color: Color = Theme.bone

    public var body: some View {
        BreathRingShape()
            .fill(color)
            .frame(width: size, height: size)
    }
}
