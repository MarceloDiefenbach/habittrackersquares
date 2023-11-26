//
//  Functions.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import Foundation
import SwiftUI

func generateDateArray(endDay: String) -> [Date] {
    var dates: [Date] = []
    let calendar = Calendar.current

    // Adicionando o dia atual
    let today = Date()
    dates.append(today)

    // Adicionando os dias até o próximo domingo ou segunda-feira
    var nextDate = today
    let endWeekday = endDay == "Sunday" ? 1 : 2 // 1 para domingo, 2 para segunda-feira
    while calendar.component(.weekday, from: nextDate) != endWeekday {
        nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
        dates.append(nextDate)
    }

    // Adicionando dias anteriores até completar 182 dias
    while dates.count < 182 {
        let previousDate = calendar.date(byAdding: .day, value: -1, to: dates.first!)!
        dates.insert(previousDate, at: 0)
    }

    return dates
}

func hexToColor(hex: String) -> Color {
    var cleanedHexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    cleanedHexString = cleanedHexString.replacingOccurrences(of: "#", with: "")

    var rgbValue: UInt64 = 0
    Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0

    return Color(red: red, green: green, blue: blue)
}

func formatDateToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date)
}

func findMark(in marks: [Habit.Mark], matching date: Date) -> Habit.Mark? {
    
    let dateString = formatDateToString(date)
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"

    guard let targetDate = formatter.date(from: dateString) else {
        // Retorna nil se a string da data não puder ser convertida em um objeto Date
        return nil
    }

    let calendar = Calendar.current

    return marks.first(where: { calendar.isDate($0.date, inSameDayAs: targetDate) })
}

func isToday(_ dateString: String) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    
    guard let date = formatter.date(from: dateString) else {
        // Retorna false se a string da data não for válida
        return false
    }

    return Calendar.current.isDateInToday(date)
}
