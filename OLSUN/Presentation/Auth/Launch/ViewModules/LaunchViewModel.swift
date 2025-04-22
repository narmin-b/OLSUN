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
    private var auth: Auth?
    private var loginModel: LoginDataModel?
    private var googleUser: GoogleUser?
    
    init(navigation: AuthNavigation, authSessionUse: AuthSessionUseCase, auth: Auth, loginModel: LoginDataModel, googleUser: GoogleUser) {
        self.navigation = navigation
        self.authSessionUse = authSessionUse
        self.auth = auth
        self.loginModel = loginModel
        self.googleUser = googleUser
    }
    
    func createUser(user: RegisterDataModel) {
        switch auth {
        case .google:
            googleSignIn(idToken: googleUser?.idToken ?? "", user: user)
        case .local:
            createUserLocally(user: user)
        case .guest:
            break
        case .none:
            break
        }
    }
    
    func createUserLocally(user: RegisterDataModel) {
        var user = user
        user.email = loginModel?.email
        user.password = loginModel?.password
        user.auth = .local

        print(user)
        requestCallback?(.loading)
        authSessionUse.createUser(user: user) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                print("dto:", dto ?? "No resp")
                
                if dto != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func googleSignIn(idToken: String, user: RegisterDataModel) {
        var user = user
        user.email = googleUser?.email
        
        print(user)
        requestCallback?(.loading)
        authSessionUse.googleSignIn(idToken: idToken, user: user) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                print("dto:", dto ?? "No resp")
                
                if dto != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func showHomeTabBar() {
        navigation?.didCompleteAuthentication()
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
