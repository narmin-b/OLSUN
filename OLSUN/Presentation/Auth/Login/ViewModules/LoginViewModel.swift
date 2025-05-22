//
//  LoginViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation

final class LoginViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case success
        case registerSuccess
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: AuthNavigation?
    private var authSessionUse: AuthSessionUseCase
    
    init(navigation: AuthNavigation?, authSessionUse: AuthSessionUseCase) {
        self.navigation = navigation
        self.authSessionUse = authSessionUse
    }
    
    func logInUser(user: LoginDataModel) {
        requestCallback?(.loading)
        authSessionUse.loginUser(user: user) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                Logger.debug("dto: \(dto ?? "No resp")")
                KeychainHelper.setString(dto ?? "", key: .userID)
                if dto != nil {
                    UserDefaultsHelper.setString(key: .loginType, value: LoginType.user.rawValue)
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func googleEmailCheck(user: SingInUser) {
        requestCallback?(.loading)
        authSessionUse.googleEmailCheck(idToken: user.idToken ?? "") { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                
                if let error = error {
                    self.requestCallback?(.error(message: error))
                    return
                }
                
                guard let dto = dto else {
                    self.requestCallback?(.error(message: "Unexpected error occurred."))
                    return
                }
                
                Logger.debug("dto: \(dto)")
                if dto.status == .email {
                    self.showShowLaunchScreen(auth: .google, user: user)
                }
                else {
                    UserDefaultsHelper.setString(key: .loginType, value: LoginType.user.rawValue)
                    KeychainHelper.setString(dto.message, key: .userID)
                    self.requestCallback?(.success)
                }
            }
        }
    }
    
    func appleEmailCheck(user: SingInUser) {
        let newUser = RegisterDataModel(username: user.name ?? "", email: user.email ?? "")
        requestCallback?(.loading)
        authSessionUse.appleCheck(idToken: user.idToken ?? "", user: newUser) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                
                if let error = error {
                    self.requestCallback?(.error(message: error))
                    return
                }
                
                guard let dto = dto else {
                    self.requestCallback?(.error(message: "Unexpected error occurred."))
                    return
                }
                
                Logger.debug("APPLE DTO: \(dto)")
                if dto.status == .appleId {
                    UserDefaultsHelper.setString(key: .loginType, value: LoginType.user.rawValue)
                    KeychainHelper.setString(dto.message, key: .userID)
                    self.requestCallback?(.registerSuccess)
                }
                else {
                    UserDefaultsHelper.setString(key: .loginType, value: LoginType.user.rawValue)
                    KeychainHelper.setString(dto.message, key: .userID)
                    self.requestCallback?(.success)
                }
            }
        }
    }
      
    func popControllerBack() {
        navigation?.popbackScreen()
    }
    
    func showShowLaunchScreen(auth: Auth, user: SingInUser) {
        navigation?.showLaunch(auth: auth, loginModel: nil, googleModel: user)
    }
    
    func showShowSignUpScreen() {
        navigation?.showSignUp()
    }
    
    func showHomeTabBar() {
        navigation?.didCompleteAuthentication()
    }
}
