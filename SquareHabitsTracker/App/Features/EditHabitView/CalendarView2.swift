//
//  DetailsView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 29/11/23.
//

import Foundation
import SwiftUI

struct CalendarView2: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    
    @Binding var currentDate: Date
    
    var calendar = Calendar(identifier: .gregorian)
    
    private let daysOfWeek: [LocalizedStringKey] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    private var year: Int {
        Calendar.current.component(.year, from: currentDate)
    }
    
    private var month: Int {
        Calendar.current.component(.month, from: currentDate)
    }
    
    private var daysInMonth: Int {
        let range = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        return range.count
    }
    
    private var firstDayOfMonth: Int {
        let components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        let firstDay = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(monthName), \(String(year).replacingOccurrences(of: ".", with: ""))")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.blackPure)
            }
            .padding(.bottom, 4)
            
            HStack {
                ForEach(Array(calendar.shortWeekdaySymbols.enumerated()), id: \.element) { index, day in
                    VStack {
                        Text(day)
                            .font(.system(size: 12, weight: .light))
                            .frame(width: UIScreen.main.bounds.width * 0.10)
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            VStack(spacing: 4) {
               ForEach(0..<numberOfRows, id: \.self) { row in
                   HStack(spacing: 4) {
                       ForEach(0..<7) { column in
                           dayView(row: row, column: column)
                       }
                   }
               }
           }
        }
    }
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: currentDate)
    }
    
    private var numberOfRows: Int {
        (firstDayOfMonth + daysInMonth - 1 + (7 - (firstDayOfMonth + daysInMonth - 1) % 7) % 7) / 7
    }
    
    private func dayText(row: Int, column: Int) -> (day: String, month: Int, year: Int) {
        let dayNumber = row * 7 + column - firstDayOfMonth + 2
        let dayString = (1...daysInMonth).contains(dayNumber) ? "\(dayNumber)" : ""
        return (dayString, month, year)
    }
    
    private func dayView(row: Int, column: Int) -> some View {
        let (day, month, year) = dayText(row: row, column: column)
        
        let dayToShow = findMarkInside(in: viewModel.selectedHabit!.marks, matching: "\(day)/\(month)/\(year)")
        let maxOpacity = viewModel.selectedHabit!.maxMarkValue(habit: viewModel.selectedHabit!)
        let actualOpacity = (dayToShow?.value ?? 0.0) * 1.0 / maxOpacity
        var color: Color = .black
        if day.isEmpty {
            color = Color.black.opacity(0.1)
        } else if actualOpacity == 0.0 {
            color = Color("HeaderHabitBackground")
        } else {
            color = hexToColor(hex: viewModel.selectedHabit!.color).opacity(actualOpacity)
        }
        
        return Text(day)
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.width * 0.10)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday(day: day, month: month, year: year) ? Color.black : Color.clear, lineWidth: 2)
            )
    }

    private func isToday(day: String, month: Int, year: Int) -> Bool {
        guard let dayInt = Int(day), let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: dayInt)) else {
            return false
        }
        return Calendar.current.isDateInToday(date)
    }
    
    func findMarkInside(in marks: [Habit.Mark], matching dateString: String) -> Habit.Mark? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        guard let targetDate = formatter.date(from: dateString) else {
            // Retorna nil se a string da data não puder ser convertida em um objeto Date
            return nil
        }

        let calendar = Calendar.current

        return marks.first(where: { calendar.isDate($0.date, inSameDayAs: targetDate) })
    }
}

#Preview {
    CalendarView2(currentDate: .constant(Date()))
}
