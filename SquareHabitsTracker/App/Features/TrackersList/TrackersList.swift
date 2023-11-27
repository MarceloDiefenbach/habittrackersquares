//
//  TrackersList.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 20/11/23.
//

import SwiftUI
import CloudKit

struct TrackersList: View {
    @StateObject var viewModel = HabitsViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var storeKitVM = StoreKitViewModel()

    @State var isShowingNewTrackerView = false
    @State var isShowingMarkView = false
    @State var isShowingSettingView = false
    @State var isShowingEditView = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    if viewModel.isFetching {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            Spacer()
                        }
                    } else if !viewModel.habits.isEmpty {
                        ForEach(viewModel.habits) { habit in
                            VStack {
                                HeaderTrackView(habit: habit, editAction: {
                                    viewModel.selectedHabit = habit
                                    isShowingEditView = true
                                })
                                CalendarView(habit: habit, allDays: generateDateArray(endDay: settingsViewModel.firstDayString.chave))
                                    .onTapGesture {
                                        viewModel.selectedHabit = habit
                                        isShowingMarkView.toggle()
                                    }
                            }
                            .padding(16)
                            .frame(height: UIScreen.main.bounds.width * 0.425)
                            .background(hexToColor(hex: habit.color).opacity(0.1))
                            .overlay(){
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(hexToColor(hex: habit.color).opacity(0.5), lineWidth: 0.5)
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Spacer()
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundStyle(Color("blackPure"))
                                Text("List_View_empty_State_title")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(Color("blackPure"))
                                Text("List_View_empty_State_subtitle")
                                    .font(.system(size: 12, weight: .regular))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.gray)
                                    .frame(width: UIScreen.main.bounds.width * 0.5)
                                Spacer()
                            }
                            .padding(.top, UIScreen.main.bounds.height * 0.3)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .refreshable {
                viewModel.fetchHabits() { result in
                    viewModel.isFetching = false
                    switch result {
                    case .success(let habits):
                        viewModel.habits = habits
                    case .failure(let error):
                        print("Erro: \(error)")
                    }
                }
            }
            .navigationTitle("Square Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Color("blackPure"))
                        .onTapGesture {
                            if viewModel.habits.count >= 1 {
                                settingsViewModel.isShowingPayWallList = true
                            } else {
                                isShowingNewTrackerView = true
                            }
                        }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color("blackPure"))
                        .onTapGesture {
                            isShowingSettingView.toggle()
                        }
                }
            }
            .fullScreenCover(isPresented: $isShowingNewTrackerView) {
                NewTrackerView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $isShowingMarkView) {
                MarkView()
                    .presentationDetents([.medium])
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $isShowingSettingView) {
                SettingsView()
                    .environmentObject(settingsViewModel)
                    .environmentObject(storeKitVM)
            }
            .navigationDestination(isPresented: $isShowingEditView) {
                EditView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $settingsViewModel.isShowingPayWallList) {
                PayWall()
                    .environmentObject(storeKitVM)
                    .environmentObject(settingsViewModel)
            }
        }
        .onAppear {
            viewModel.fetchHabits() { result in
                viewModel.isFetching = false
                switch result {
                case .success(let habits):
                    print("sucesso")
                case .failure(let error):
                    print("Erro: \(error)")
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
