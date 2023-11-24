//
//  DayTrack.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 20/11/23.
//

import Foundation
import SwiftUI

class Mark {
    var date: Date
    var value: Double
    
    init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
class Habit {
    var title: String
    var measure: String
    var color: Color
    var marks: [Mark]
        
    init(title: String, marks: [Mark], measure: String, color: Color) {
        self.title = title
        self.marks = marks
        self.measure = measure
        self.color = color
    }
    
    func maxDayTrackValue() -> Double {
        // Check if the array is empty
        if self.marks.isEmpty {
            return 0
        }

        // Find the maximum value
        let maxValue = self.marks.max(by: { $0.value < $1.value })?.value
        return maxValue ?? 0
    }
}
