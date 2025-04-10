//
//  LoginViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation

final class LoginViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
    private var authSessionUse: AuthSessionUseCase
        
    init(navigation: AuthNavigation, authSessionUse: AuthSessionUseCase) {
        self.navigation = navigation
        self.authSessionUse = authSessionUse
    }
    
    func logInUser(user: LoginDataModel) {
        requestCallback?(.loading)
        authSessionUse.loginUser(user: user) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                print("dto:", dto ?? "No resp")
                
                if let dto = dto {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
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
