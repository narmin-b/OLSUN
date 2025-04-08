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
//    
//    var requestCallback : ((ViewState) -> Void?)?
//    private weak var navigation: AuthNavigation?
//        
//    init(navigation: AuthNavigation) {
//        self.navigation = navigation
//    }
//    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
    private var authSessionUse: AuthSessionUseCase
        
    init(navigation: AuthNavigation, authSessionUse: AuthSessionUseCase) {
        self.navigation = navigation
        self.authSessionUse = authSessionUse
    }
    
    func createUser(user: RegisterDataModel) {
        authSessionUse.createUser(user: user) { [weak self] dto, error in
            guard let self = self else { return }
            print(dto ?? "No resp")
            if let dto = dto {
                requestCallback?(.success)
            } else if let error = error {
                requestCallback?(.error(message: error))
            }
        }
    }
    
    func popControllerBack() {
        navigation?.popbackScreen()
    }
    
    func showShowSignUpScreen() {
        navigation?.showSignUp()
    }
}
