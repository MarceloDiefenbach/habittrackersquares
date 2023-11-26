//
//  PayWall.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import SwiftUI
import StoreKit

struct PayWall: View {
    @EnvironmentObject var storeVM: StoreKitViewModel
    @State var productID: String
    @State var purchaseButtonLabel: LocalizedStringKey
    @State var titleLabel: String
    @State var subtitleLabel: LocalizedStringKey
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text(LocalizedStringKey(titleLabel))
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                Text(subtitleLabel)
                    .font(.system(size: 18, weight: .light))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width*0.8)
                    .padding(.bottom, 8)
                    .onAppear() {
                        print(productID)
                    }
                
                
                ForEach(storeVM.products) { product in
                    if product.id == productID {
                        Text("Only \(product.displayPrice)")
                            .font(.system(size: 24, weight: .regular))
                            .padding(.horizontal, 16)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        HStack {
                            Text("Read the")
                                .font(.system(size: 12, weight: .regular))
                            Text("Terms of use (EULA)")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            Text("and")
                                .font(.system(size: 12, weight: .regular))
                            Text("Privacy Policy")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    if let url = URL(string: "https://docs.google.com/document/d/16cEeM8HDoHj9pF290_pdwhhwTJf238zGiFaNsSmANd8/edit?usp=sharing") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                        .padding(.bottom, 40)
                        .padding(.top, 40)
                    
                        if product.id != "com.marcelo.wordcoach.unlockall" {
                            Text("Restore product")
                                .padding(.bottom, 24)
                                .onTapGesture {
                                    Task {
                                        await buy(product: product)
                                    }
                                }
                        }
                    ButtonComponent(label: purchaseButtonLabel, isRounded: true, action: {
                        Task {
                            await buy(product: product)
                        }
                    })
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                    }
                }
            }
            if viewModel.isLoadingPurchase == true {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            ProgressView()
                                .tint(.white)
                            Text("Loading")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        Spacer()
                    }
                }.background(.black.opacity(0.6))
            }
        }
    }
    
    func buy(product: Product) async {
        viewModel.isLoadingPurchase = true
        do {
            if let transaction = try await storeVM.purchase(product) {
                viewModel.isLoadingPurchase = false
                self.dismiss()
            } else {
                viewModel.isLoadingPurchase = false
                self.dismiss()
            }
        } catch {
            viewModel.isLoadingPurchase = false
            self.dismiss()
        }
        
    }
}

#Preview {
    PayWall()
}
