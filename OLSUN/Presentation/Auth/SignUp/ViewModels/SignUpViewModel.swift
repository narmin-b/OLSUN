//
//  SignUpViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import Foundation

final class SignUpViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }

    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
        
    init(navigation: AuthNavigation) {
        self.navigation = navigation
    }
    
    func popControllerBack() {
        navigation?.popbackScreen()
    }
        
    func showShowLaunchScreen(email: String, password: String) {
        navigation?.showLaunch(email: email, password: password)
    }
}
