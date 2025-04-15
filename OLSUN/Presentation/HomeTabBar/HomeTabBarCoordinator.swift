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
    private var planningCoordinator: PlanningCoordinator?
    private var guestsCoordinator: GuestsCoordinator?

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        initializeHomeTabBar()
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }

    deinit {
        print("tabbar")
    }

    private func initializeHomeTabBar() {
        let homeNavigationController = UINavigationController()
        homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator?.parentCoordinator = self
        homeCoordinator?.tabBarDelegate = self
        homeCoordinator?.delegate = self
        children.append(homeCoordinator!)
        
        let planningNavigationController = UINavigationController()
        planningCoordinator = PlanningCoordinator(navigationController: planningNavigationController)
        planningCoordinator?.parentCoordinator = self
        children.append(planningCoordinator!)

        let guestsNavigationController = UINavigationController()
        guestsCoordinator = GuestsCoordinator(navigationController: guestsNavigationController)
        guestsCoordinator?.parentCoordinator = self
        children.append(guestsCoordinator!)

        let homeItem = UITabBarItem()
        homeItem.image = UIImage(named: "Home")
        homeItem.selectedImage = UIImage(named: "HomeFill")
        homeNavigationController.tabBarItem = homeItem
        homeNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavigationController.navigationBar.shadowImage = UIImage()

        let planningItem = UITabBarItem()
        planningItem.image = UIImage(named: "DoneFill")
        planningItem.selectedImage = UIImage(named: "Done")
        planningNavigationController.tabBarItem = planningItem

        let guestsItem = UITabBarItem()
        guestsItem.image = UIImage(named: "3People")
        guestsItem.selectedImage = UIImage(named: "3PeopleFill")
        guestsNavigationController.tabBarItem = guestsItem

        tabBarController.viewControllers = [
            homeNavigationController,
            planningNavigationController,
            guestsNavigationController
        ]
        
        homeCoordinator?.start()
        planningCoordinator?.start()
        guestsCoordinator?.start()
    }
    
    func cleanupChildren() {
        children.forEach { child in
            childDidFinish(child)
        }
        children.removeAll()
        
        homeCoordinator = nil
        planningCoordinator = nil
        guestsCoordinator = nil
    }
}

extension HomeTabBarCoordinator: HomeTabBarNavigation {    
    func switchToTab(index: Int) {
        tabBarController.selectedIndex = index
    }
}
