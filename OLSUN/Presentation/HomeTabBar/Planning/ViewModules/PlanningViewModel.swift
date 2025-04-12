//
//  PlanningViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

final class PlanningViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }

    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PlanningNavigation?
        
    init(navigation: PlanningNavigation) {
        self.navigation = navigation
    }
}
