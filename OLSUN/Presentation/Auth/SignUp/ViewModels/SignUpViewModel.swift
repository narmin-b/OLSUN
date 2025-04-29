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
    private var authSessionUse: AuthSessionUseCase
    
    init(navigation: AuthNavigation, authSessionUse: AuthSessionUseCase) {
        self.navigation = navigation
        self.authSessionUse = authSessionUse
    }
    
    func popControllerBack() {
        navigation?.popbackScreen()
    }
    
    func showHomeTabBar() {
        navigation?.didCompleteAuthentication()
    }
    
    func showShowLaunchScreen(auth: Auth, loginUser: LoginDataModel?, googleUser: GoogleUser?) {
        switch auth {
        case .google:
            navigation?.showLaunch(auth: auth, loginModel: nil, googleModel: googleUser)
        case .local:
            navigation?.showLaunch(auth: auth, loginModel: loginUser, googleModel: nil)
        case .guest:
            return
        }
    }
    
    func googleEmailCheck(user: GoogleUser) {
        requestCallback?(.loading)
        authSessionUse.googleEmailCheck(idToken: user.idToken) { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                print("dto:", dto ?? "No resp")
                if dto?.status == .email {
                    self.showShowLaunchScreen(auth: .google, loginUser: nil, googleUser: user)
                } else {
                    UserDefaultsHelper.setString(key: .userID, value: dto?.message ?? "")
                    self.requestCallback?(.success)
                }
            }
        }
    }
}
