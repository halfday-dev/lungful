import Foundation
import Combine
import StoreKit

/// StoreKit 2 wrapper for the single one-time purchase.
/// Note: `StoreKit.Transaction` is spelled explicitly throughout — plain
/// `Transaction` is ambiguous wherever SwiftUI is also visible.
@MainActor
public final class StoreService: ObservableObject {

    public static let shared = StoreService()

    /// The one product: permanent full-toolkit unlock. Non-consumable.
    /// Must match the product id configured in App Store Connect.
    public static let unlockProductID = "dev.halfday.lungful.unlock"

    /// User-facing outcome of a purchase/restore attempt. Consumed by
    /// `UnlockView` as an alert; nil when there's nothing to report.
    public enum Feedback: Equatable {
        case purchaseFailed(String)
        case restoreFailed(String)
        case nothingToRestore
    }

    @Published public private(set) var unlockProduct: Product?
    @Published public private(set) var purchaseInFlight = false
    @Published public private(set) var restoreInFlight = false
    @Published public var feedback: Feedback?

    private var updatesTask: Task<Void, Never>?

    private init() {
        // Listen for transactions that arrive outside a purchase flow
        // (restores on other devices, Ask to Buy approvals, refunds).
        updatesTask = Task { [weak self] in
            for await result in StoreKit.Transaction.updates {
                await self?.handle(result)
            }
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    // MARK: - Public API

    /// Loads the product and applies any existing entitlement.
    /// Safe to call repeatedly; the app calls it once at launch and
    /// UnlockView retries it when the product failed to load.
    public func refresh() async {
        if unlockProduct == nil {
            unlockProduct = try? await Product.products(for: [Self.unlockProductID]).first
        }

        for await result in StoreKit.Transaction.currentEntitlements {
            await handle(result)
        }
    }

    /// Runs the purchase flow for the unlock. Errors surface via `feedback`;
    /// user cancellation stays silent.
    public func purchase() async {
        guard let product = unlockProduct, !purchaseInFlight else { return }
        purchaseInFlight = true
        defer { purchaseInFlight = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification)
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            feedback = .purchaseFailed(error.localizedDescription)
        }
    }

    /// Restores purchases (required by App Review for any IAP).
    /// Success unlocks via the entitlement check (UnlockView dismisses);
    /// every other outcome reports through `feedback`.
    public func restore() async {
        guard !restoreInFlight else { return }
        restoreInFlight = true
        defer { restoreInFlight = false }

        do {
            try await AppStore.sync()
        } catch {
            // sync() also throws when the user cancels the sign-in sheet —
            // still worth reporting; the message makes the cause clear.
            feedback = .restoreFailed(error.localizedDescription)
            return
        }

        await refresh()

        if AccessManager.shared.access != .unlocked {
            feedback = .nothingToRestore
        }
    }

    // MARK: - Private

    private func handle(_ result: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = result,
              transaction.productID == Self.unlockProductID else { return }

        AccessManager.shared.setUnlocked(transaction.revocationDate == nil)
        await transaction.finish()
    }
}
