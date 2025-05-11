//
//  UserProfileCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import Foundation
import UIKit.UINavigationController

final class UserProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Logger.debug("UserProfileCoordinator deinit")
    }
    
    func start() {
        let controller = UserProfileViewController(
            viewModel: .init(
                navigation: self
            )
        )
        showController(vc: controller)
    }
}

extension UserProfileCoordinator: UserProfileNavigation {
    
}
