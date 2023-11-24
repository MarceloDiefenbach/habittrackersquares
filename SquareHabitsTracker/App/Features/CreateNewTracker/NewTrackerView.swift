//
//  NewTrackerView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 20/11/23.
//

import SwiftUI

struct MeasureDropdownMenuView: View {
    var body: some View {
        Menu("Measure") {
            Button("Unity", action: { /* Ação para Opção 1 */ })
            Button("Liters", action: { /* Ação para Opção 2 */ })
            Button("Meters", action: { /* Ação para Opção 3 */ })
            Button("Hours", action: { /* Ação para Opção 3 */ })
            Button("Minutes", action: { /* Ação para Opção 3 */ })
        }
    }
}

struct NewTrackerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var measure: String = "Tap to change"
    @State var color: Color = .blue
    @State var colorLabel: String = "Tap to change"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
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
                            Text("Measure")
                            Spacer()
                            Menu {
                                Button("Unity", action: { measure = "Unity" })
                                Button("Liters", action: { measure = "Liters" })
                                Button("Meters", action: { measure = "Meters" })
                                Button("Hours", action: { measure = "Hours" })
                                Button("Minutes", action: { measure = "Minutes" })
                            } label: {
                                HStack {
                                    Text(measure)
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
                .navigationTitle("Create")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Cancel")
                            .foregroundStyle(.red)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text("Create")
                            .foregroundStyle(.blue)
                    }
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
