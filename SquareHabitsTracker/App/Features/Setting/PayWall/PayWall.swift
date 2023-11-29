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
                    Text("Assinatura mensal")
                        .foregroundStyle(Color("blackPure"))
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                        .padding(.top, UIScreen.main.bounds.height * 0.09)
                    
                    Text("Tenha acesso a todas as funcionalidade do app antes de todo mundo")
                        .foregroundStyle(Color("blackPure").opacity(0.8))
                        .font(.system(size: 12, weight: .light))
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width*0.65)
                        .padding(.bottom, 8)
                                    
                    ForEach(storeVM.products) { product in
                        if product.id == productID {
                            HStack(spacing: 4) {
                                Spacer()
                                Text("Apenas \(product.displayPrice) / mês")
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
                                    Text("Hábitos ilimitados")
                                        .font(.system(size: 16, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 10, height: 10)
                                    Text("Peça novas funcionalidades")
                                        .font(.system(size: 16, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 10, height: 10)
                                    Text("Sem anúncios")
                                        .font(.system(size: 16, weight: .light))
                                }
                                .padding(.bottom, 40)
                                
                                Text("Em breve")
                                    .foregroundStyle(.gray)
                                    .padding(.bottom, 16)
                                
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                    Text("Widgets")
                                        .font(.system(size: 10, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                    Text("Lembretes")
                                        .font(.system(size: 10, weight: .light))
                                }
                                HStack {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                    Text("Desafie amigos")
                                        .font(.system(size: 10, weight: .light))
                                }
                            }
                            .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                            
                            HStack {
                                Spacer()
                                Text("Assinar agora")
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
                    
                    VStack(spacing: 4) {
                        Text("Termos de uso (EULA)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        Text("Política de privacidade")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://docs.google.com/document/d/16cEeM8HDoHj9pF290_pdwhhwTJf238zGiFaNsSmANd8/edit?usp=sharing") {
                                    UIApplication.shared.open(url)
                                }
                            }
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
                            Text("Carregando")
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
