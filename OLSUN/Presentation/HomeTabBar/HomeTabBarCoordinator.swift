//
//  HomeTabBarCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class HomeTabBarCoordinator: Coordinator, HomeTabBarCoordinatorDelegate {
    func homeDidFinish() {
        delegate?.homeDidFinish()
    }
    
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    weak var delegate: HomeTabBarCoordinatorDelegate?
    var navigationController: UINavigationController
    private let window: UIWindow

    private let tabBarController = TabBarController()
    private var homeCoordinator: HomeCoordinator?
    private var partnersCoordinator: PartnersCoordinator?
    private var profileCoordinator: UserProfileCoordinator?

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        initializeHomeTabBar()
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }

    deinit {
        Logger.debug("Tabbar deinit")
    }

    private func initializeHomeTabBar() {
        let homeNavigationController = UINavigationController()
        homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator?.parentCoordinator = self
        homeCoordinator?.tabBarDelegate = self
        homeCoordinator?.delegate = self
        children.append(homeCoordinator!)
        
        let partnersNavigationController = UINavigationController()
        partnersCoordinator = PartnersCoordinator(navigationController: partnersNavigationController)
        partnersCoordinator?.parentCoordinator = self
        children.append(partnersCoordinator!)
        
        let profileNavigationController = UINavigationController()
        profileCoordinator = UserProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.parentCoordinator = self
        children.append(profileCoordinator!)

        let homeItem = UITabBarItem()
        homeItem.image = UIImage(named: "Home")
        homeItem.selectedImage = UIImage(named: "HomeFill")
        homeItem.title = OlsunStrings.homeTitle.localized
        homeNavigationController.tabBarItem = homeItem
        homeNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavigationController.navigationBar.shadowImage = UIImage()

        let partnersItem = UITabBarItem()
        partnersItem.title = OlsunStrings.partnersText.localized
        partnersItem.image = UIImage(systemName: "handbag")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        partnersItem.selectedImage = UIImage(systemName: "handbag.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        partnersNavigationController.tabBarItem = partnersItem
        
        let profileItem = UITabBarItem()
        profileItem.title = "Profil"
        profileItem.image = UIImage(named: "DoneFill")?.withTintColor(.black)
        profileItem.selectedImage = UIImage(named: "Done")?.withTintColor(.black)
        profileNavigationController.tabBarItem = profileItem

        tabBarController.viewControllers = [
            homeNavigationController,
            partnersNavigationController,
            profileNavigationController
        ]
        
        homeCoordinator?.start()
        partnersCoordinator?.start()
        profileCoordinator?.start()
    }
    
    func cleanupChildren() {
        children.forEach { child in
            childDidFinish(child)
        }
        children.removeAll()
        
        homeCoordinator = nil
        partnersCoordinator = nil
        profileCoordinator = nil
    }
}

extension HomeTabBarCoordinator: HomeTabBarNavigation {    
    func switchToTab(index: Int) {
        tabBarController.selectedIndex = index
    }
}
