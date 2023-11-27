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
    @EnvironmentObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var productID: String = "com.marcelo.squarehabits.monthly"
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("xmark.circle.fill")
                    Text("PayWall_view_title")
                        .foregroundStyle(Color("blackPure"))
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                        .padding(.top, UIScreen.main.bounds.height * 0.09)
                    
                    Text("PayWall_view_Subtitle")
                        .foregroundStyle(Color("blackPure").opacity(0.8))
                        .font(.system(size: 12, weight: .light))
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width*0.65)
                        .padding(.bottom, 8)
                                    
                    ForEach(storeVM.products) { product in
                        if product.id == productID {
                            HStack(spacing: 4) {
                                Spacer()
                                Text("PayWall_view_only")
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.blackPure)
                                Text("\(product.displayPrice) /")
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.blackPure)
                                Text("PayWall_view_month")
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.blackPure)
                                Spacer()
                            }
                            .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 10, height: 10)
                                    Text("PayWall_view_Unlimited_habits")
                                        .font(.system(size: 16, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 10, height: 10)
                                    Text("PayWall_view_Feature_request_priority")
                                        .font(.system(size: 16, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 10, height: 10)
                                    Text("PayWall_view_ads_free")
                                        .font(.system(size: 16, weight: .light))
                                }
                                .padding(.bottom, 40)
                                
                                Text("COMING_SOON")
                                    .foregroundStyle(.gray)
                                    .padding(.bottom, 16)
                                
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                    Text("PayWall_view_Widgets")
                                        .font(.system(size: 10, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                    Text("PayWall_view_Lembretes")
                                        .font(.system(size: 10, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                    Text("PayWall_view_Desafios_com_amigos")
                                        .font(.system(size: 10, weight: .light))
                                }
                            }
                            .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                            
                            HStack {
                                Spacer()
                                Text("PayWall_view_Unlock_all_PRO_features")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                Task {
                                    await buy(product: product)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 32)
                        }
                    }
                    
                    HStack(spacing: 2) {
                        Spacer()
                        Text("PayWall_view_Read_the")
                            .font(.system(size: 12, weight: .regular))
                        Text("PayWall_view_Terms_of_use_(EULA)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        Text("PayWall_view_and")
                            .font(.system(size: 12, weight: .regular))
                        Text("PayWall_view_Privacy_Policy")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://docs.google.com/document/d/16cEeM8HDoHj9pF290_pdwhhwTJf238zGiFaNsSmANd8/edit?usp=sharing") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        Spacer()
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
                            Text("PayWall_view_Loading")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        Spacer()
                    }
                }.background(.black.opacity(0.6))
            }
        }
        .background(Image("paywallbackground").resizable().ignoresSafeArea().scaledToFill())
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
        .environmentObject(StoreKitViewModel())
        .environmentObject(SettingsViewModel())
}
