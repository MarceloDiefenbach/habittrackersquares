//
//  StoreKit.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import Foundation
import StoreKit

//alias
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo //The Product.SubscriptionInfo.RenewalInfo provides information about the next subscription renewal period.
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState // the renewal states of auto-renewable subscriptions.

class StoreKitViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    @Published var isPRO: Bool = false
    
    private let productIds: [String] = ["com.marcelo.squarehabits.monthly"]
    
    var updateListenerTask : Task<Void, Error>? = nil

    init() {
        
        //start a transaction listern as close to app launch as possible so you don't miss a transaction
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    if transaction.productID == "com.marcelo.wordcoach.airport" {
                        //TODO: - liberar
                    }

                    // deliver products to the user
                    await self.updateCustomerProductStatus()
                    
                    await transaction.finish()
                } catch {
                    print("transaction failed verification")
                }
            }
        }
    }
    
    // Request the products
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIds)
        } catch {
            print("Failed product request from app store server: \(error)")
        }
    }
    
    // purchase the product
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
            case .success(let verification):
                //Check whether the transaction is verified. If it isn't, this function rethrows the verification error.
                let transaction = try checkVerified(verification)
                print(transaction)
                
                //The transaction is verified. Deliver content to the user.
                await updateCustomerProductStatus()
                
                //Always finish a transaction.
                await transaction.finish()
                print("Sucessfull purchase")
                return transaction
            case .pending:
                print("Pending payment")
                return nil
            case .userCancelled:
                print("User cancel purchase")
                return nil
            default:
                print("Generic error")
                return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                //Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .consumable:
                    if transaction.productID == "" {}
                case .nonConsumable:
                    if transaction.productID == "" {}
                case .autoRenewable:
                    if transaction.productID == "com.marcelo.squarehabits.monthly" {
                        isPRO = true
                    }
                default:
                    break
                }
                //Always finish a transaction.
                await transaction.finish()
            } catch {
                print("failed updating products")
            }
        }
    }

}


public enum StoreError: Error {
    case failedVerification
}
