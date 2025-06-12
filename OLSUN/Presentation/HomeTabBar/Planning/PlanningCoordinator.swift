//
//  PlanningCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation
import UIKit.UINavigationController

final class PlanningCoordinator: Coordinator, HomeNavigation, UserProfileDelegate {
    func didRequestLogout(type: LogoutType) {
        //
    }
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    weak var delegate: HomeTabBarCoordinatorDelegate?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Logger.debug("PlanningCoordinator deinit")
    }
    
    func start() {
        let controller = PlanningViewController(
            viewModel: .init(
                navigation: self,
                taskUseCase: PlanningAPIService()
            )
        )
        showController(vc: controller)
    }
}

extension PlanningCoordinator: PlanningNavigation, UserProfileNavigation {
    func showAuth() {
        delegate?.homeDidFinish()
        
        parentCoordinator?.childDidFinish(self)
    }
    
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
    
    func popController() {
        popControllerBack()
    }
    
    func popTwoControllersBack() {
        if navigationController.viewControllers.count >= 3 {
            let targetVC = navigationController.viewControllers[navigationController.viewControllers.count - 3]
            navigationController.popToViewController(targetVC, animated: true)
        }
    }
    
    func showEditTask(taskItem: ListCellProtocol, onUpdate: @escaping (ListCellProtocol) -> Void) {
        let vc = AddTaskViewController(viewModel: .init(navigation: self, taskUseCase: PlanningAPIService(), taskMode: .edit, taskItem: taskItem))
        vc.onTaskUpdate = onUpdate
        showController(vc: vc)
    }
    
    func showAddTask() {
        let vc = AddTaskViewController(viewModel: .init(navigation: self, taskUseCase: PlanningAPIService(), taskMode: .add, taskItem: ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0)))
        showController(vc: vc)
    }
    
    func showTask(taskItem: ListCellProtocol) {
        let vc = TaskViewController(viewModel: .init(navigation: self, taskUseCase: PlanningAPIService(), taskItem: taskItem))
        showController(vc: vc)
    }
}
