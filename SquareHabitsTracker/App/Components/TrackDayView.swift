//
//  TrackDayView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import SwiftUI

struct TrackDayView: View {
    
    var actualOpacity: Double = 0.0
    var color: Color
    var actualDay: Date
    var width: Double
    
    init(actualOpacity: Double, color: Color, actualDay: Date, width: Double) {
        
        if actualOpacity.isNaN {
            self.actualOpacity = 0.0
        } else {
            self.actualOpacity = actualOpacity
        }
        self.color = color
        self.actualDay = actualDay
        self.width = width
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .foregroundColor(actualOpacity == 0.0 ? Color("HeaderHabitBackground") : color.opacity(actualOpacity))
            .frame(width: width, height: width)
            .overlay {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(isToday(formatDateToString(actualDay)) ? Color("blackPure") : Color.clear, lineWidth: 1)
            }
        }
}

#Preview {
    TrackDayView(actualOpacity: 0.0, color: .blue, actualDay: Date.now, width: UIScreen.main.bounds.width)
}
