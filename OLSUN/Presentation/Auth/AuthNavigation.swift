//
//  AuthNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation

protocol AuthNavigation: AnyObject {
    func showLogin()
    func showLaunch(auth: Auth, loginModel: LoginDataModel?, googleModel: GoogleUser?)
    func showOnboarding()
    func showSignUp()
    func popbackScreen()
    func popToRoot()
    func didCompleteAuthentication()
}
