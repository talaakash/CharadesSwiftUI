//
//  IAPManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import StoreKit

typealias FailureCallBack = (String) -> Void

enum ProductLoadError {
    case inValidProductIds /// This case happens whenever productId passed was mismatch with original productIds
    case notLoadedProductIds([String]) /// This case happen while some product not load and return that product id
    case error(String) /// This case return error message
}

enum PurchaseError {
    case pending  /// This case return if transaction goes in pending state
    case userCancelled /// This case happen if user cancel purchase while purchasing product
    case unknown /// This case happen if can't identify error
    case error(String) /// This case return error message
    case unverified /// This case happen if transaction can't verify
}

enum RestoreError {
    case expired /// This case happen if user try restore and purchased was expired
    case neverPurchased /// This case happen if user never purchased any product
    case error(String) /// This case return error message
}

final class IAPManager {
    static let shared = IAPManager()
    private var products: [Product] = []
    var isProductLoaded: Bool = false
    
    var allPlan:[Plan]? = []
    
    private init() {
        self.doInitSetup()
    }
    
    private func doInitSetup() {
        /// Initialise transaction update for listen any transaction update
        self.listenForTransactionUpdates()
        
        /// Initialise handler for promotional offer
        if #available(iOS 16.4, *) {
            self.handlePromotionalOffer(success: { _ in
                
            }, failure: { _ in
                
            })
        }
    }
}

// MARK: - Transaction Listener Method
extension IAPManager {
    
    ///  This Method Listen about pending transaction or some refund transaction so here we can finish that transaction
    private func listenForTransactionUpdates() {
        Task {
            for await verificationResult in Transaction.updates {
                switch verificationResult {
                case .verified(let transaction):
                    Task {
                        await transaction.finish()
                    }
                case .unverified(_, let error):
                    debugPrint("Unverified transaction: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Product load and purchase
extension IAPManager {
    
    func loadAllPlan(success: (([Product]) -> Void)? = nil, failure: ((ProductLoadError) -> Void)? = nil)
    {
        if let planIds: [String] = allPlan?.map({$0.planId}){
            loadProducts(productIDs: planIds,success: success, failure: failure)
        }
    }
    
    /// This Method help to load Products with productIDs supplied in argument
    /// It will return all available Products in success callback
    /// It will return failure in enum if no product loaded Then inValidProductIds if some product is loaded then return Ids of product that not loaded and error if some error occurs in between execution
    func loadProducts(productIDs: [String], success: (([Product]) -> Void)? = nil, failure: ((ProductLoadError) -> Void)? = nil) {
        Task {
            do {
                self.products = try await Product.products(for: productIDs)
                DispatchQueue.main.async {
                    if self.products.count == productIDs.count {
                        for i in 0..<(self.allPlan?.count ?? 0) {
                            if let product = self.products.first(where: { $0.id == self.allPlan?[i].planId }) {
                                self.allPlan?[i].planProduct = product
                            }
                        }
                        self.isProductLoaded = true
                        success?(self.products)
                    } else if self.products.isEmpty {
                        failure?(ProductLoadError.inValidProductIds)
                    } else {
                        let loadedProductIDs = self.products.map { $0.id }
                        let failedProductIDs = productIDs.filter { !loadedProductIDs.contains($0) }
                        failure?(ProductLoadError.notLoadedProductIds(failedProductIDs))
                    }
                }
            } catch {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    failure?(ProductLoadError.error(error.localizedDescription))
                }
            }
        }
    }
    
    /// This function is for purchase Product
    /// This function success completion return current product id if purchase success and verified
    ///  This function failure return PurchaseError enum if transaction have any problem or successful transaction cant verify then it simply return in error variable or if transaction get pending or userCanceled or unknown then return according it
    func purchaseProduct(_ product: Product,viewController:UIViewController, success: @escaping ([String]) -> Void, failure: @escaping (PurchaseError) -> Void) {
        Task {
            do {
                var result:Product.PurchaseResult
                if #available(iOS 18.2, *) {
                    result = try await product.purchase(confirmIn: viewController)
                } else {
                    // Fallback on earlier versions
                    result = try await product.purchase()
                }
                DispatchQueue.main.async {
                    switch result {
                    case let .success(.verified(transaction)):
                        Task {
                            await transaction.finish()
                            debugPrint("Completed purchase with Transaction: \(transaction)")
                            
                            /// For the consumable products only because currentEntitlements not return consumable products
                            if transaction.productType == .consumable {
                                DispatchQueue.main.async {
                                    success([product.id])
                                }
                                return
                            }
                            
                            /// Here we add currentEntitlements so we can re-verify about purchase and unlock premium according that
                            self.getActivePlan(success: { allPurchasedProductIds in
                                DispatchQueue.main.async {
                                    if allPurchasedProductIds.contains(product.id) {
                                        success([product.id])
                                    } else {
                                        failure(PurchaseError.unknown)
                                    }
                                }
                            }, failure: { error in
                                DispatchQueue.main.async {
                                    failure(PurchaseError.error(error))
                                }
                            })
                        }
                    case let .success(.unverified(_, error)):
                        debugPrint("Unverified purchase. Might be jailbroken. Error: \(error.localizedDescription)")
                        failure(PurchaseError.error(error.localizedDescription+"unverified status."))
                        break
                    case .pending:
                        failure(PurchaseError.pending)
                        break
                    case .userCancelled:
                        debugPrint("User Cancelled!")
                        failure(PurchaseError.userCancelled)
                        break
                    @unknown default:
                        debugPrint("Failed to purchase the product!")
                        failure(PurchaseError.unknown)
                    }
                }
                
            } catch {
                debugPrint("Failed to purchase the product! \(error.localizedDescription)")
                DispatchQueue.main.async {
                    failure(PurchaseError.error(error.localizedDescription))
                }
            }
        }
    }
    
    func processPurchaseResult(result:Product.PurchaseResult)
    {
        
    }
}

// MARK: - Transaction Information Methods
extension IAPManager {
    
    /// This function fetch all active transaction
    /// This functions success callback return productIds of currently active plans
    /// This function failure callback return failure message if no plan has been purchased or verified transaction is currently not active
    func getActivePlan(success: @escaping ([String]) -> Void, failure: @escaping FailureCallBack) {
        UserManager.shared.setUserType(type: .free)
        Task {
            var purchasedPlanIds: Set<String> = []
            for await result in Transaction.currentEntitlements {
                switch result {
                case .verified(let transaction):
                    debugPrint(transaction)
                    if transaction.revocationDate == nil{
                        purchasedPlanIds.insert(transaction.productID)
                        UserManager.shared.setUserType(type: .paid)
                    }
                case .unverified(_, let error):
                    debugPrint("Verification Failed: \(error.localizedDescription)")
                    break
                }
            }
            purchasedPlanIds.isEmpty ? failure("No active plan available") : success(Array(purchasedPlanIds))
        }
    }
    
    /// This Function get all transaction details
    /// This function success callback return all purchased plan id
    /// This function failure callback return error message that user never purchased anything
    private func allTransactionOfUser(success: @escaping ([String]) -> Void, failure: @escaping FailureCallBack) {
        Task {
            var allPurchasedProductIds: Set<String> = []
            for await result in Transaction.all {
                switch result {
                case .unverified(_, let error):
                    debugPrint("Unverified Error: \(error.localizedDescription)")
                    break
                case .verified(let transaction):
                    if transaction.revocationDate == nil{
                        allPurchasedProductIds.insert(transaction.productID)
                    }
                }
            }
            allPurchasedProductIds.isEmpty ? failure("No Plan Purchased before") : success(Array(allPurchasedProductIds))
        }
    }
}

// MARK: - Restore Purchase
extension IAPManager {
    
    /// This function is for restore purchase
    /// This functions success callback return available productIds that is currently active
    /// This function failure callback return enum in which if user purchased before but that is expired, user never purchased or any other error message
    func restorePurchases(success: @escaping ([String]) -> Void, failure: @escaping ((RestoreError) -> Void)) {
        Task {
            do {
                try await AppStore.sync()
                self.getActivePlan(success: { purchasedProductIds in
                    DispatchQueue.main.async {
                        success(purchasedProductIds)
                    }
                }, failure: { error in
                    /// Fetching All transaction of user in this app
                    self.allTransactionOfUser(success: { _ in
                        DispatchQueue.main.async {
                            failure(.expired)
                        }
                    }, failure: { _ in
                        DispatchQueue.main.async {
                            failure(.neverPurchased)
                        }
                    })
                })
            } catch {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    failure(.error(error.localizedDescription))
                }
            }
        }
    }
}

// MARK: - Promotional Offer Handler
extension IAPManager {
    
    /// This is for promotional purchase
    /// This function return success completion for productId of try to purchase product if purchased successfully
    /// This function return failure completion for any error in purchase
    @available(iOS 16.4, *)
    private func handlePromotionalOffer(success: @escaping ([String]) -> Void, failure: @escaping (PurchaseError) -> Void) {
        Task {
//            for await purchaseIntent in PurchaseIntent.intents {
//                if let rootController = await appDelegate.window?.rootViewController{
//                    self.purchaseProduct(purchaseIntent.product,viewController: rootController ,success: { purchasedProductIds in
//                        DispatchQueue.main.async {
//                            success(purchasedProductIds)
//                        }
//                    }, failure: { error in
//                        DispatchQueue.main.async {
//                            failure(error)
//                        }
//                    })
//                }
//                
//            }
        }
    }
}

// MARK: - ProductData Fetching
extension IAPManager {
    
    /// This function return available product list
    func getProductsData() -> [Product] {
        return self.products
    }
}


