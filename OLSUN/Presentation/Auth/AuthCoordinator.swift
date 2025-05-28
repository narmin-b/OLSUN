//
//  AuthCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation
import UIKit.UINavigationController

protocol AuthCoordinatorDelegate: AnyObject {
    func authDidFinish()
}

final class AuthCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    weak var delegate: AuthCoordinatorDelegate?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    deinit {
        Logger.debug("AuthCoordinator deinit")
    }
    
    func start() {
        showOnboarding()
    }

    func childDidFinish(_ child: Coordinator) {
        if let index = children.firstIndex(where: { $0 === child }) {
            children.remove(at: index)
        }
    }
}

extension AuthCoordinator: AuthNavigation {
    func didCompleteAuthentication() {
        delegate?.authDidFinish()
        
        parentCoordinator?.childDidFinish(self)
    }

    func popbackScreen() {
        popControllerBack()
    }
    
    func showLogin() {
        let vc = LoginViewController(viewModel: .init(navigation: self, authSessionUse: AuthSessionAPIService()))
        showController(vc: vc)
    }
    
    func showSignUp() {
        let vc = SignUpViewController(viewModel: .init(navigation: self, authSessionUse: AuthSessionAPIService()))
        showController(vc: vc)
    }
    
    func showLaunch(auth: Auth, loginModel: LoginDataModel?, googleModel: SingInUser?) {
        let vc = LaunchViewController(viewModel: .init(navigation: self, authSessionUse: AuthSessionAPIService(), auth: auth, loginModel: loginModel ?? LoginDataModel(email: "", password: ""), googleUser: googleModel ?? SingInUser(name: "", email: "", idToken: "", appleID: nil)))
        showController(vc: vc)
    }
    
    func showOnboarding() {
        let vc = OnboardingViewController(viewModel: .init(navigation: self, authSessionUse: AuthSessionAPIService()))
        showController(vc: vc)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
