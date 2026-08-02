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

    @Published public private(set) var unlockProduct: Product?
    @Published public private(set) var purchaseInFlight = false

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
    /// Safe to call repeatedly; the app calls it once at launch.
    public func refresh() async {
        if unlockProduct == nil {
            unlockProduct = try? await Product.products(for: [Self.unlockProductID]).first
        }

        for await result in StoreKit.Transaction.currentEntitlements {
            await handle(result)
        }
    }

    /// Runs the purchase flow for the unlock.
    public func purchase() async {
        guard let product = unlockProduct, !purchaseInFlight else { return }
        purchaseInFlight = true
        defer { purchaseInFlight = false }

        guard let result = try? await product.purchase() else { return }

        switch result {
        case .success(let verification):
            await handle(verification)
        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }

    /// Restores purchases (required by App Review for any IAP).
    public func restore() async {
        try? await AppStore.sync()
        await refresh()
    }

    // MARK: - Private

    private func handle(_ result: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = result,
              transaction.productID == Self.unlockProductID else { return }

        AccessManager.shared.setUnlocked(transaction.revocationDate == nil)
        await transaction.finish()
    }
}
