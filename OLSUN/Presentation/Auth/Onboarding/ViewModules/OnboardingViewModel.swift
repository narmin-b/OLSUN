//
//  OnboardingViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import Foundation

final class OnboardingViewModel {
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
    
    func popControllerBack() {
        navigation?.popbackScreen()
    }
    
    func showLoginScreen() {
        navigation?.showLogin()
    }
    
    func showShowSignUpScreen() {
        navigation?.showSignUp()
    }
    
    func showHomeTabBar() {
        navigation?.didCompleteAuthentication()
    }
    
    func guestLogin() {
        let user = RegisterDataModel(username: "", gender: nil, coupleName: "", coupleGender: nil, auth: .guest)
        requestCallback?(.loading)
        authSessionUse.createUser(user: user) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                Logger.debug("dto: \(dto ?? "No resp")")
                
                if dto != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
