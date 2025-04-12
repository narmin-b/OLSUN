//
//  HomeTabBarCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class HomeTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
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
        homeItem.image = UIImage(systemName: "homeIcon")
        homeItem.selectedImage = UIImage(systemName: "homeIcon")
        homeNavigationController.tabBarItem = homeItem
        homeNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavigationController.navigationBar.shadowImage = UIImage()

        let planningItem = UITabBarItem()
        planningItem.image = UIImage(systemName: "planningIcon")
        planningItem.selectedImage = UIImage(systemName: "planningIcon")
        planningNavigationController.tabBarItem = planningItem

        let guestsItem = UITabBarItem()
        guestsItem.image = UIImage(systemName: "guestsIcon")
        guestsItem.selectedImage = UIImage(systemName: "guestsIcon")
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
