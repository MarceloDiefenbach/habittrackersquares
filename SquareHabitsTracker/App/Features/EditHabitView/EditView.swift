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
    @State private var currentDate = Date()
    
    @State var isShowingEmojiSelector = false
    @State var selectedEmoji: String = ""
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
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
                        Text("Tap to change the emoji")
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.5), lineWidth: 1)
                    )
                    .onTapGesture {
                        isShowingEmojiSelector = true
                    }
                    
                    HStack {
                        Text(viewModel.selectedHabit!.title)
                        Spacer()
                    }
                    .padding()
                    .background(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.5), lineWidth: 1)
                    )
                    
                    CalendarView2(currentDate: $currentDate)
                        .environmentObject(viewModel)
                        .padding()
                        .background(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(hexToColor(hex: viewModel.selectedHabit!.color).opacity(0.5), lineWidth: 1)
                        )
                    
                    HStack {
                        Spacer()
                        Text("Apagar hábito")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .padding(.top, 56)
                    .onTapGesture {
                        showingDeleteAlert = true
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .sheet(isPresented: $isShowingEmojiSelector) {
                    EmojiPickerView(selectedEmoji: $selectedEmoji, isEdit: true)
                        .environmentObject(viewModel)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(title: Text("Apagar hábito"), message: Text("Tem certeza que deseja apagar? Essa ação não poderá ser desfeita"), primaryButton: .default(Text("Cancelar"), action: {
                        showingDeleteAlert = false
                    }), secondaryButton: .destructive(Text("Apagar"), action: {
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
