//
//  AuthNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation

protocol AuthNavigation: AnyObject {
    func showLogin()
    func showLaunch()
    func showOnboarding()
    func showSignUp()
    func popbackScreen()
    func didCompleteAuthentication()
}
