//
//  HomeCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation
import UIKit.UINavigationController

protocol HomeTabBarCoordinatorDelegate: AnyObject {
    func homeDidFinish()
}

final class HomeCoordinator: Coordinator, UserProfileDelegate {
    var parentCoordinator: Coordinator?
    weak var delegate: HomeTabBarCoordinatorDelegate?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    weak var tabBarDelegate: HomeTabBarNavigation?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Logger.debug("HomeCoordinator deinit")
    }
    
    func start() {
        let controller = HomeViewController(
            viewModel: .init(
                navigation: self,
                tabBarDelegate: tabBarDelegate,
            )
        )
        showController(vc: controller)
    }
}

extension HomeCoordinator: HomeNavigation, UserProfileNavigation {
    func showProfile() {
        let vc = UserProfileViewController(
            viewModel: .init(
                navigation: self,
                accountUseCase: AccountSessionAPIService()
            )
        )
        vc.logoutDelegate = self
        showController(vc: vc)
    }
    
    func showAuth() {
        delegate?.homeDidFinish()
        
        parentCoordinator?.childDidFinish(self)
    }
    
    func didRequestLogout(type: LogoutType) {
        showAuth()
    }
}
