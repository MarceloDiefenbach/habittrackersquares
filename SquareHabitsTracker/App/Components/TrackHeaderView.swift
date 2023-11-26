//
//  TrackHeaderView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import Foundation
import SwiftUI

struct HeaderTrackView: View {
    var habit: Habit
    var editAction: () -> Void

    var body: some View {
        HStack {
            let emoji = String(UnicodeScalar(Int(habit.emoji, radix: 16)!)!)
            Text(emoji)
                .font(.system(size: 12, weight: .light))
            Text(habit.title)
                .font(.system(size: 12, weight: .light))
            Spacer()
            Image(systemName: "pencil.circle")
                .font(.system(size: 16, weight: .light))
                .onTapGesture {
                    editAction()
                }
        }
        .padding(.all, 8)
        .background(Color("HeaderHabitBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.bottom, 4)
    }
}
