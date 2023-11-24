//
//  TrackersList.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 20/11/23.
//

import SwiftUI
import CloudKit

struct TrackersList: View {
    
    @State var isShowingNewTrackerView = false
    
    @State var habit: Habit = Habit(
        title: "Water",
        marks: [
            Mark(date: createDate(from: "20-11-2023"), value: 1),
            Mark(date: createDate(from: "19-11-2023"), value: 10),
            Mark(date: createDate(from: "12-11-2023"), value: 15),
            Mark(date: createDate(from: "20-09-2023"), value: 2),
        ],
        measure: "liters",
        color: .green
    )

    func fetchICloudEmail(completion: @escaping (String?) -> Void) {
        // Acessa o container padrão do iCloud
        let container = CKContainer.default()

        // Solicita as informações da conta do iCloud
        container.fetchUserRecordID { recordID, error in
            if let error = error {
                print("Erro ao acessar iCloud: \(error)")
                completion(nil)
            } else if let recordID = recordID {
                // Busca o registro público associado ao usuário
                container.publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
                    if let error = error {
                        print("Erro ao buscar registro do usuário: \(error)")
                        completion(nil)
                    } else if let email = record?.object(forKey: "email") as? String {
                        // Retorna o e-mail associado ao iCloud
                        print(email)
                        completion(email)
                    }
                }
            }
        }
    }

    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    TrackerView(habit: habit)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("SquareHabits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.black)
                        .onTapGesture {
                            isShowingNewTrackerView.toggle()
                        }
                }
            }
            .fullScreenCover(isPresented: $isShowingNewTrackerView) {
                NewTrackerView()
            }
            .onAppear{
                fetchICloudEmail() { result in
                    print(result)
                }
            }
        }
    }
}

#Preview {
    TrackersList()
}

func createDate(from dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Isso garante que o formato de data não dependa das configurações de localização do usuário
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ajuste isso conforme necessário
    return dateFormatter.date(from: dateString)!
}
