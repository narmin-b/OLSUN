//
//  GuestsCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation
import UIKit.UINavigationController

final class GuestsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Logger.debug("GuestsCoordinator deinit")
    }
    
    func start() {
        let controller = GuestsViewController(
            viewModel: .init(
                navigation: self, guestUseCase: GuestAPIService()
            )
        )
        showController(vc: controller)
    }
}

extension GuestsCoordinator: GuestsNavigation, UserProfileNavigation {
    func showProfile() {
        let vc = UserProfileViewController(viewModel: .init(navigation: self))
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
    
    func showEditGuest(guestItem: ListCellProtocol, onUpdate: @escaping (ListCellProtocol) -> Void) {
        let vc = AddGuestViewController(viewModel: .init(navigation: self, guestUseCase: GuestAPIService(), guestMode: .edit, guestItem: guestItem))
        vc.onGuestUpdate = onUpdate
        showController(vc: vc)
    }
    
    func showAddGuest() {
        let vc = AddGuestViewController(viewModel: .init(navigation: self, guestUseCase: GuestAPIService(), guestMode: .add, guestItem: ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0)))
        showController(vc: vc)
    }
    
    func showGuest(guestItem: ListCellProtocol) {
        let vc = GuestDetailViewController(viewModel: .init(navigation: self, guestUseCase: GuestAPIService(), taskItem: guestItem))
        showController(vc: vc)
    }
}
