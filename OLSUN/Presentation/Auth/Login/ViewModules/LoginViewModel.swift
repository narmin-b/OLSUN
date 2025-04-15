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
        case launch
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
                UserDefaultsHelper.setString(key: .userID, value: dto ?? "")
                if dto != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func googleEmailCheck(user: GoogleUser) {
        requestCallback?(.loading)
        authSessionUse.googleEmailCheck(idToken: user.idToken) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                print("dto:", dto ?? "No resp")
                UserDefaultsHelper.setString(key: .userID, value: dto ?? "")
                if dto != nil {
                    self.requestCallback?(.success)
                } else {
                    self.showShowLaunchScreen(user: user)
                }
            }
        }
    }
    
    func popControllerBack() {
        navigation?.popbackScreen()
    }
    
    func showShowLaunchScreen(user: GoogleUser) {
        navigation?.showLaunch(auth: .google, loginModel: nil, googleModel: user)
    }
    
    func showShowSignUpScreen() {
        navigation?.showSignUp()
    }
    
    func showHomeTabBar() {
        navigation?.didCompleteAuthentication()
    }
}
