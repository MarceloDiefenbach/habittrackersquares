//
//  SettingsViewModel.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 26/11/23.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var isPro: Bool = false
    @Published var firstDayString: DayOfWeek = .monday
    
    @Published var isLoadingPurchase = false
    @Published var isShowingPayWall = false
    @Published var isShowingPayWallList = false
    
    init() {
        self.isPro = isPro
        
        if UserDefaults.standard.string(forKey: "firstDay") ?? "Sunday" == "Sunday" {
            self.firstDayString = .sunday
        } else {
            self.firstDayString = .monday
        }
    }
    
}

