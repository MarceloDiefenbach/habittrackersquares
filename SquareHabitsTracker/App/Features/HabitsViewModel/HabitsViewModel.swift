//
//  HabitsViewModel.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 25/11/23.
//

import SwiftUI
import Combine

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedHabit: Habit?
    @Published var isFetching: Bool = true
    
    private let url = "http://gpt-treinador.herokuapp.com/"
    private let ownerID: String = UserDefaults.standard.string(forKey: "userCredential") ?? "no"
    
    func addNewHabit(title: String, color: String, emoji: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "\(url)api/habits")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["title": title, "color": color, "ownerID": ownerID, "emoji": emoji, "date": formatDateToString(Date.now)]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                completion(false, error)
                return
            }
            
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let habitID = jsonResponse["id"] as? Int {
                        print("Habit ID: \(habitID)")
                        self.habits.append(Habit(color: color, id: habitID, marks: [], ownerID: ownerID, title: title, emoji: emoji))
                        self.habits = Array(self.habits)
                        completion(true, nil)
                    }
                } catch {
                    print("Error parsing response data: \(error)")
                    completion(false, error)
                }
            }
        }.resume()
    }

    
    private func containsMark(for dateString: String, in marks: [Habit.Mark]) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard let targetDate = formatter.date(from: dateString) else {
            // Retorna false se a string da data não puder ser convertida em um objeto Date
            return false
        }
        
        let calendar = Calendar.current
        
        return marks.contains(where: { calendar.isDate($0.date, inSameDayAs: targetDate) })
    }
    
    func addMarkToHabit(date: String, value: Double, completion: @escaping (Bool, Error?) -> Void) {
        
        let index = habits.firstIndex(of: self.selectedHabit!) ?? 0
        
        let contains = containsMark(for: date, in: self.habits[index].marks)
        
        if contains {
            self.habits[index].marks[self.habits[index].marks.count-1].value += value
            self.habits[index] = self.habits[index]
            self.habits[index].marks = self.habits[index].marks
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" // Updated format
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            self.habits[index].marks.append(Habit.Mark(date: Date.now, habitID: selectedHabit!.id, id: Int.random(in: 100...2000000), ownerID: ownerID, value: value))
        }
        
        let url = URL(string: "\(url)api/marks")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["date": date, "value": value, "habitID": selectedHabit!.id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }.resume()
    }
    
    func deleteHabit(habitID: Int, completion: @escaping (Bool, Error?) -> Void) {
        
        let url = URL(string: "\(url)api/habits/\(habitID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
                completion(false, error)
                return
            }
            let index = self.habits.firstIndex(of: self.selectedHabit!) ?? 0
            self.habits.remove(at: index)
            self.habits = Array(self.habits)
            completion(true, nil)
        }.resume()
    }
    
    private func addOneDay(to date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: date) ?? date
    }
    
    func fetchHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
        let urlString = "\(url)api/habits/\(ownerID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Dados não encontrados"])))
                return
            }
            
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy" // Updated format
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]] {
                    var habits: [Habit] = []
                    for habitData in jsonResult {
                        guard let id = habitData["id"] as? Int,
                              let ownerID = habitData["ownerID"] as? String,
                              let title = habitData["title"] as? String,
                              let color = habitData["color"] as? String,
                              let emoji = habitData["emoji"] as? String,
                              let marksData = habitData["marks"] as? [[String: AnyObject]] else {
                            continue
                        }
                        
                        let marks = marksData.compactMap { markData -> Habit.Mark? in
                            
                            guard let id = markData["id"] as? Int,
                                  let habitID = markData["habitID"] as? Int,
                                  let ownerID = markData["ownerID"] as? String,
                                  let dateString = markData["date"] as? String,
                                  let value = markData["value"] as? Double,
                                  let date = dateFormatter.date(from: dateString) else {
                                return nil
                            }
                            return Habit.Mark(date: self.addOneDay(to: date), habitID: habitID, id: id, ownerID: ownerID, value: value)
                        }.sorted { $0.date < $1.date }
                        
                        var habit = Habit(color: color, id: id, marks: marks, ownerID: ownerID, title: title, emoji: emoji)
                        if habit.marks.isEmpty {
                            habit.marks.append(Habit.Mark(date: Date.now, habitID: habit.id, id: Int.random(in: 100...2000000), ownerID: "1", value: 0))
                        }
                        habits.append(habit)
                    }
                    self.habits = habits
                    completion(.success(habits))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erro ao analisar JSON"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
