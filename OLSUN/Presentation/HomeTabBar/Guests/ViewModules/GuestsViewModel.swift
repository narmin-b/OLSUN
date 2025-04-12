//
//  GuestsViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

final class GuestsViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }

    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: GuestsNavigation?
        
    init(navigation: GuestsNavigation) {
        self.navigation = navigation
    }
}
