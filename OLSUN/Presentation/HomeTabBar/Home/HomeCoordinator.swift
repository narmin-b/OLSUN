//
//  HomeCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation
import UIKit.UINavigationController

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print(#function)
    }
    
    func start() {
        let controller = HomeViewController(
            viewModel: .init(
                navigation: self
            )
        )
        showController(vc: controller)
    }
}

extension HomeCoordinator: HomeNavigation {
    
}
