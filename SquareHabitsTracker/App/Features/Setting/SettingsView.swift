//
//  SettingsView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import SwiftUI

enum DayOfWeek {
    case sunday
    case monday

    var label: LocalizedStringKey {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        }
    }
    
    var chave: String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Unlock PRO")
                            .font(.system(size: 16, weight: .bold))
                        Text("Get all PRO features")
                            .font(.system(size: 10, weight: .regular))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .light))
                }.padding(.vertical, 8)
            } header: {
                Text("PRO FEATURES")
            }
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("First day of week")
                            .font(.system(size: 16, weight: .bold))
                        Text("Set what is the firs day")
                            .font(.system(size: 10, weight: .regular))
                    }
                    Spacer()
                    Menu {
                        Button(DayOfWeek.monday.label, action: {
                            settingsViewModel.firstDayString = .monday
                            UserDefaults.standard.set(settingsViewModel.firstDayString.chave, forKey: "firstDay")
                        })
                        Button(DayOfWeek.sunday.label, action: {
                            settingsViewModel.firstDayString = .sunday
                            UserDefaults.standard.set(settingsViewModel.firstDayString.chave, forKey: "firstDay")
                        })
                    } label: {
                        HStack {
                            Text(settingsViewModel.firstDayString.label)
                                .font(.system(size: 16, weight: .light))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .light))
                        }
                    }
                }.padding(.vertical, 8)
            } header: {
                Text("VIEW SETTINGS")
            }
        }.navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
