//
//  AppCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation
import UIKit.UINavigationController

final class AppCoordinator: Coordinator, AuthCoordinatorDelegate {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    private var isLogin: Bool = false
    private var authCoordinator: AuthCoordinator?
//    private var homeCoordinator: HomeTabBarCoordinator?
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
//        setupObserver()
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self)
        print("AppCoordinator deinit")
    }
    
//    private func setupObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(listener), name: .sessionExpired, object: nil)
//    }
    
    func start() {
//        isLogin = UserDefaultsHelper.getBool(key: .isLoggedIn)
        
//        if isLogin {
//            showHome()
//        } else {
            showAuth()
//        }
    }

    private func showAuth() {
//        if let homeCoord = homeCoordinator {
//            homeCoord.cleanupChildren()
//            childDidFinish(homeCoord)
//            homeCoordinator = nil
//        }
//        
        authCoordinator = nil
//        homeCoordinator = nil

        navigationController.viewControllers = []

        window.rootViewController = nil

        let newAuthCoordinator = AuthCoordinator(
            window: window,
            navigationController: navigationController
        )
        
        newAuthCoordinator.parentCoordinator = self
        newAuthCoordinator.delegate = self
        authCoordinator = newAuthCoordinator
        children.append(newAuthCoordinator)
        newAuthCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

//    private func showHome() {
//        if let authCoord = authCoordinator {
//            childDidFinish(authCoord)
//        }
//
//        authCoordinator = nil
//        homeCoordinator = nil
//
//        navigationController.viewControllers = []
//        navigationController.setNavigationBarHidden(true, animated: false)
//        
//        window.rootViewController = nil
//
//        let newHomeCoordinator = HomeTabBarCoordinator(
//            window: window,
//            navigationController: navigationController
//        )
//
//        newHomeCoordinator.parentCoordinator = self
//        newHomeCoordinator.delegate = self
//        homeCoordinator = newHomeCoordinator
//        children.append(newHomeCoordinator)
//        newHomeCoordinator.start()
//
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }

    func authDidFinish() {
//        showHome()
    }
    
//    func homeTabBarDidFinish() {
//        showAuth()
//    }

//    @objc private func listener() {
//        print(#function)
//        DispatchQueue.main.async {
//            self.showAuth()
//        }
//    }
}
