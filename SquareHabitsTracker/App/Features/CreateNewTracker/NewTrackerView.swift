//
//  NewTrackerView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 20/11/23.
//

import SwiftUI

func emojiFromString(_ selectedEmoji: String, defaultEmojiCode: String = "1F3A4") -> String {
    guard let code = Int(selectedEmoji, radix: 16),
          let unicodeScalar = UnicodeScalar(code) else {
        return String(UnicodeScalar(Int(defaultEmojiCode, radix: 16)!)!)
    }

    return String(unicodeScalar)
}


struct NewTrackerView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var color: Color = .blue
    @State var colorLabel: LocalizedStringKey = "Blue"
    @State var showEmojiPicker = false
    @State var selectedEmoji = "1F3A4"
    
    @State var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            let emoji = emojiFromString(selectedEmoji)
                            Text(emoji)
                                .font(.largeTitle)
                                .padding(16)
                                .background(Color("EmojiBackground"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .onTapGesture {
                                    selectedEmoji = emoji
                                    dismiss()
                                }
                                .padding(.leading, 8)
                            Spacer()
                            Text("Tap to change the emoji")
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(color.opacity(0.03))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(color.opacity(0.5), lineWidth: 1)
                        )
                        .onTapGesture {
                            showEmojiPicker = true
                        }
                        .sheet(isPresented: $showEmojiPicker) {
                            EmojiPickerView(selectedEmoji: $selectedEmoji)
                        }
                        
                        HStack {
                            TextField("Habit name", text: $name)
                                .padding()
                        }
                        .background(color.opacity(0.03))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(color.opacity(0.5), lineWidth: 1)
                        )
                        HStack {
                            HStack {
                                Text("Color")
                                Spacer()
                                Menu {
                                    Button("Blue", action: {
                                        colorLabel = "Blue"
                                        color = .blue
                                    })
                                    Button("Red", action: {
                                        colorLabel = "Red"
                                        color = .red
                                    })
                                    Button("Orange", action: {
                                        colorLabel = "Orange"
                                        color = .orange
                                    })
                                    Button("Green", action: {
                                        colorLabel = "Green"
                                        color = .green
                                    })
                                    Button("Cyan", action: {
                                        colorLabel = "Cyan"
                                        color = .cyan
                                    })
                                    Button("Pink", action: {
                                        colorLabel = "Pink"
                                        color = .pink
                                    })
                                    Button("Indigo", action: {
                                        colorLabel = "Indigo"
                                        color = .indigo
                                    })
                                } label: {
                                    HStack {
                                        Text(colorLabel)
                                        Image(systemName: "chevron.up.chevron.down")
                                    }
                                }
                                .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        .background(color.opacity(0.03))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(color.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .navigationTitle("NewHabit")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text("Cancel")
                                .foregroundStyle(.red)
                                .onTapGesture {
                                    if !isLoading {
                                        dismiss()
                                    }
                                }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Text("Create")
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    if !isLoading {
                                        isLoading = true
                                        viewModel.addNewHabit(title: name, color: "\(color.toHex()!)", emoji: selectedEmoji) { result,err  in
                                            isLoading = false
                                            dismiss()
                                        }
                                    }
                                }
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Create")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        isLoading = true
                        viewModel.addNewHabit(title: name, color: "\(color.toHex()!)", emoji: selectedEmoji) { result,err  in
                            isLoading = false
                            dismiss()
                        }
                    }
                }
                if isLoading {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()
                    }.background(.black.opacity(0.5))
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NewTrackerView()
    }
}
