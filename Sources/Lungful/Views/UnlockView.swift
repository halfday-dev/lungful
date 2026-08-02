import SwiftUI

/// The unlock screen — one honest sheet, no countdown theater.
@MainActor
public struct UnlockView: View {
    @ObservedObject private var store = StoreService.shared
    @ObservedObject private var access = AccessManager.shared
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        ZStack {
            Theme.deepStone
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                BreathRingShape()
                    .fill(Theme.bone)
                    .frame(width: 56, height: 56)

                Text("the full toolkit")
                    .font(.system(size: 26, weight: .light, design: .default))
                    .foregroundStyle(Theme.bone)
                    .padding(.top, 24)

                VStack(alignment: .leading, spacing: 12) {
                    unlockLine("all five breathing patterns")
                    unlockLine("the custom pattern builder")
                    unlockLine("saved patterns")
                    unlockLine("everything halfday adds next")
                }
                .padding(.top, 32)

                Spacer()

                Button {
                    Task { await store.purchase() }
                } label: {
                    Text(purchaseLabel)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Theme.ochre)
                        )
                }
                .buttonStyle(.plain)
                .disabled(store.purchaseInFlight)
                .opacity(store.purchaseInFlight ? 0.6 : 1.0)

                Text("one-time purchase · no subscription")
                    .font(.system(size: 12, weight: .light, design: .monospaced))
                    .foregroundStyle(Theme.shadow)
                    .padding(.top, 12)

                Button("Restore Purchases") {
                    Task { await store.restore() }
                }
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundStyle(Theme.dust)
                .buttonStyle(.plain)
                .padding(.top, 20)

                Text("box breathing & the physiological sigh stay free forever.")
                    .font(.system(size: 13, weight: .light, design: .default))
                    .foregroundStyle(Theme.shadow)
                    .multilineTextAlignment(.center)
                    .padding(.top, 28)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: 420)
            .padding(.horizontal, 32)
        }
        .preferredColorScheme(.dark)
        .task {
            await store.refresh()
        }
        .onChange(of: access.access) { _, newValue in
            if newValue == .unlocked {
                dismiss()
            }
        }
    }

    // MARK: - Helpers

    private var purchaseLabel: String {
        if let price = store.unlockProduct?.displayPrice {
            return "Unlock · \(price)"
        }
        return "Unlock"
    }

    @ViewBuilder
    private func unlockLine(_ text: String) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Theme.ochre)
                .frame(width: 5, height: 5)

            Text(text)
                .font(.system(size: 16, weight: .light, design: .default))
                .foregroundStyle(Theme.dust)
        }
    }
}
