//
//  UserProfileViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import Foundation

final class UserProfileViewModel {
    enum ViewState {
        case refreshError(message: String)
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: UserProfileNavigation?
    
    init(navigation: UserProfileNavigation) {
        self.navigation = navigation
    }
    
}
