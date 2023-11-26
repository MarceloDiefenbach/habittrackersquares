//
//  EditView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var isLoadingDelete = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            let emoji = emojiFromString(viewModel.selectedHabit!.emoji)
                            Text(emoji)
                                .font(.largeTitle)
                                .padding(16)
                                .background(Color("EmojiBackground"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.03))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.5), lineWidth: 1)
                        )
                        
                        HStack {
                            Text(viewModel.selectedHabit!.title)
                            Spacer()
                        }
                        .padding()
                        .background(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.03))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.5), lineWidth: 1)
                        )
                        
                        Text("EditView_coming_soon_label")
                            .font(.system(size: 12, weight: .light))
                            .padding(.top, 40)
                    }
                    .padding(.horizontal, 16)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("EditView_delete_button_label")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .onTapGesture {
                        showingDeleteAlert = true
                    }
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(title: Text("Edit_delete_alert_title"), message: Text("Edit_delete_alert_message"), primaryButton: .default(Text("Edit_delete_cancel_button"), action: {
                            showingDeleteAlert = false
                        }), secondaryButton: .destructive(Text("Edit_delete_confirm_button"), action: {
                            showingDeleteAlert = false
                            isLoadingDelete = true
                            viewModel.deleteHabit(habitID: viewModel.selectedHabit!.id) { result,err  in
                                print(err)
                                print(result)
                                isLoadingDelete = false
                                DispatchQueue.main.async {
                                    dismiss()
                                }
                            }
                        }))
                    }
                }
                .padding(.bottom, 8)
            }
            .interactiveDismissDisabled(true)
            if isLoadingDelete {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }.background(Color.black.opacity(0.6))
            }
        }
    }
}

#Preview {
    EditView()
        .environmentObject(HabitsViewModel())
}
