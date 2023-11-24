import SwiftUI

struct HabitView: View {
    var habit: Habit
    var maxValue: Double
    var color: Color
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<habit.marks.count, id: \.self) { index in
                VStack(spacing: 2) {
                    ForEach(0..<7) { row in
                        if index * 7 + row < habit.marks.count {
                            DayMarkView(dayTrack: habit.marks[index * 7 + row], opacity: habit.marks[index * 7 + row].value * 1 / maxValue, color: color)
                        }
                    }
                    
                }
            }
        }
    }
}

struct DayMarkView: View {
    var dayTrack: Mark
    var opacity: Double
    var color: Color
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 10, height: 10)
                .foregroundStyle(opacity == 0.0 ? .white : color.opacity(opacity))
        }
    }
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}()

struct TrackerView: View {
    
    @State private var habit: Habit
    @State private var maxValue: Double
    
    init(habit: Habit){
        self.habit = habit
        self.maxValue = Double(habit.maxDayTrackValue())
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(habit.title)
                    .foregroundStyle(.black)
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "pencil.circle")
                    .foregroundStyle(.black)
                    .font(.system(size: 12, weight: .regular))
            }
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HabitView(habit: fillMissingDays(for: &habit), maxValue: maxValue, color: habit.color)
            }.rotationEffect(Angle(degrees: 180.0))
        }
        .padding(16)
        .background(habit.color.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(habit.color.opacity(0.1), lineWidth: 1)
        )
    }
    
    // Modifica a função para retornar o Habit preenchido
    func fillMissingDays(for habit: inout Habit) -> Habit {
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(byAdding: .day, value: -363, to: Date()) else { return habit }
        
        var allDates = Set<Date>()
        for dayOffset in 0...363 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                allDates.insert(calendar.startOfDay(for: date))
            }
        }
        
        for mark in habit.marks {
            allDates.remove(calendar.startOfDay(for: mark.date))
        }
        
        for date in allDates {
            habit.marks.append(Mark(date: date, value: 0))
        }
        
        habit.marks.sort { $0.date > $1.date }
        return habit
    }
}
