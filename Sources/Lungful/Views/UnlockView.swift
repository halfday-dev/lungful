import SwiftUI

/// The unlock screen — one honest sheet, no countdown theater.
/// Every purchase/restore outcome is visible: errors alert, an unreachable
/// App Store disables the button and says so, success dismisses the sheet.
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
                .disabled(purchaseDisabled)
                .opacity(purchaseDisabled ? 0.5 : 1.0)

                if store.unlockProduct == nil {
                    // Product didn't load — offline, or the App Store is
                    // unreachable. Say so instead of a dead button.
                    Text("can't reach the App Store right now — check your connection")
                        .font(.system(size: 12, weight: .light, design: .monospaced))
                        .foregroundStyle(Theme.shadow)
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)

                    Button("Try Again") {
                        Task { await store.refresh() }
                    }
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(Theme.dust)
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                } else {
                    Text("one-time purchase · no subscription")
                        .font(.system(size: 12, weight: .light, design: .monospaced))
                        .foregroundStyle(Theme.shadow)
                        .padding(.top, 12)
                }

                Button(store.restoreInFlight ? "Restoring…" : "Restore Purchases") {
                    Task { await store.restore() }
                }
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundStyle(Theme.dust)
                .buttonStyle(.plain)
                .disabled(store.restoreInFlight)
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
        .alert(feedbackTitle, isPresented: feedbackShown) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(feedbackMessage)
        }
    }

    // MARK: - Feedback

    private var feedbackShown: Binding<Bool> {
        Binding(
            get: { store.feedback != nil },
            set: { if !$0 { store.feedback = nil } }
        )
    }

    private var feedbackTitle: String {
        switch store.feedback {
        case .purchaseFailed:   return "purchase didn't complete"
        case .restoreFailed:    return "restore didn't complete"
        case .nothingToRestore: return "no purchase found"
        case nil:               return ""
        }
    }

    private var feedbackMessage: String {
        switch store.feedback {
        case .purchaseFailed(let detail):
            return "You weren't charged. \(detail)"
        case .restoreFailed(let detail):
            return detail
        case .nothingToRestore:
            return "There's no previous purchase on this Apple ID. If you bought the unlock with a different Apple ID, sign in to it in Settings and restore again."
        case nil:
            return ""
        }
    }

    // MARK: - Helpers

    private var purchaseDisabled: Bool {
        store.purchaseInFlight || store.unlockProduct == nil
    }

    private var purchaseLabel: String {
        if store.purchaseInFlight {
            return "Unlocking…"
        }
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
