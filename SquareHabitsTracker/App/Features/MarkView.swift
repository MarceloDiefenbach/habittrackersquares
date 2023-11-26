//
//  MarkView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 25/11/23.
//

import SwiftUI

struct MarkView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Environment(\.dismiss) var dismiss

    @State var number: Int = 1
    
    var body: some View {
        VStack {
            Text(viewModel.selectedHabit!.title)
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 24)
            Text(getFormattedDate())
                .font(.system(size: 10, weight: .light))
                .padding(.top, 4)
            Spacer()
            HStack {
                Text("-")
                    .font(.system(size: 32, weight: .medium))
                    .onTapGesture {
                        if number >= 2 {
                            number -= 1
                        }
                    }
                    .padding(16)
                    .padding(.horizontal, 8)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Text("\(number)")
                    .font(.system(size: 120, weight: .heavy))
                    .padding(.horizontal, 32)
                Text("+")
                    .font(.system(size: 32, weight: .medium))
                    .onTapGesture {
                        number += 1
                    }
                    .padding(16)
                    .padding(.horizontal, 8)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Text("Mark")
                    .padding(.trailing, 2)
                    .foregroundStyle(.white)
                Text("\(number)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 24)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .onTapGesture {
                let today = Date.now
                let todayString = formatDateToString(today)
                print(todayString)
                viewModel.addMarkToHabit(date: todayString, value: Double(self.number)) { result,err  in
                    print(result)
                }
                dismiss()
            }
        }
    }
    func getFormattedDate() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: Date())
        }
}

#Preview {
    MarkView()
        .environmentObject(HabitsViewModel())
}
