//
//  DayTrack.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 20/11/23.
//

import Foundation
import SwiftUI

struct Habit: Codable, Identifiable, Equatable {
    var color: String
    var id: Int
    var marks: [Mark]
    var ownerID: String
    var title: String
    var emoji: String
    
    struct Mark: Codable, Equatable {
        var date: Date
        var habitID: Int
        var id: Int
        var ownerID: String
        var value: Double
        
        static func == (lhs: Habit.Mark, rhs: Habit.Mark) -> Bool {
                return lhs.id == rhs.id &&
                       lhs.habitID == rhs.habitID &&
                       lhs.ownerID == rhs.ownerID &&
                       lhs.date == rhs.date &&
                       lhs.value == rhs.value
            }
    }
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.title == rhs.title &&
                   lhs.color == rhs.color &&
                   lhs.emoji == rhs.emoji &&
                   lhs.ownerID == rhs.ownerID &&
                   lhs.marks == rhs.marks
        }
    
    func maxMarkValue(habit: Habit) -> Double {
        guard !habit.marks.isEmpty else {
            return 0.0
        }
        
        let maxValue = habit.marks.max(by: { $0.value < $1.value })?.value
        return maxValue ?? 0.0
    }
}
