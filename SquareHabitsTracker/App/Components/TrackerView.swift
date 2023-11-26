import SwiftUI

struct CalendarView: View {
    var habit: Habit!
    var allDaysToShow: [Date] = []
    private let totalDays = 182
    private let daysPerWeek = 7
    private let weeks = 26
    private var maxOpacity: Double = 0.0
    private var color: Color = .black
    
    init(habit: Habit? = nil, allDays: [Date]) {
        self.habit = habit
        self.allDaysToShow = allDays
        self.maxOpacity = habit!.maxMarkValue(habit: habit!)
        self.color = hexToColor(hex: habit?.color ?? "000000")
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 2) {
                ForEach(0..<weeks, id: \.self) { weekIndex in
                    VStack(spacing: 2) {
                        ForEach(0..<daysPerWeek) { dayIndex in
                            let dayNumber = weekIndex * daysPerWeek + dayIndex
                            let actualDay = allDaysToShow[dayNumber]
                            
                            let dayToShow = findMark(in: habit.marks, matching: actualDay)
                            let actualOpacity = (dayToShow?.value ?? 0.0) * 1.0 / maxOpacity
                            let isSameDay = isToday(formatDateToString(actualDay))
                            
                            let widthSquare = geometry.size.width * 0.0325
                            
                            TrackDayView(actualOpacity: actualOpacity, color: color, actualDay: actualDay, width: widthSquare)
                        }
                    }
                }
            }
        }
    }
}
