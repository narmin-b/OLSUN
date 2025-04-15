//
//  PlanningCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation
import UIKit.UINavigationController

final class PlanningCoordinator: Coordinator {
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
        let controller = PlanningViewController(
            viewModel: .init(
                navigation: self
            )
        )
        showController(vc: controller)
    }
}

extension PlanningCoordinator: PlanningNavigation {
    func showTask(taskItem: TaskItem) {
        let vc = TaskViewController(viewModel: .init(navigation: self, taskItem: taskItem))
        showController(vc: vc)
    }
    
    func showAddTask() {
        let vc = AddTaskViewController(viewModel: .init(navigation: self))
        showController(vc: vc)
    }
}
