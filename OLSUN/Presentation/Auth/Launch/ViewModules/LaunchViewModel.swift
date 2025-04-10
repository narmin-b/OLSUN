//
//  LaunchViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import Foundation

final class LaunchViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
    private var authSessionUse: AuthSessionUseCase
    private var email: String?
    private var password: String?
   
    init(navigation: AuthNavigation, authSessionUse: AuthSessionUseCase, email: String?, password: String?) {
        self.navigation = navigation
        self.authSessionUse = authSessionUse
        self.email = email
        self.password = password
    }
    
    func createUser(user: RegisterDataModel) {
        var user = user
        user.email = email
        user.password = password

        print(user)
        requestCallback?(.loading)
        authSessionUse.createUser(user: user) { [weak self] dto, error in
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
    
    func showSignupScreen() {
        navigation?.showSignUp()
    }
    
    func backToOnboarding() {
        navigation?.popToRoot()
    }
}
