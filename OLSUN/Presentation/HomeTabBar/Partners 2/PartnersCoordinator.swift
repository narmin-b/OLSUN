//
//  PartnersCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import Foundation
import UIKit.UINavigationController

final class PartnersCoordinator: Coordinator, UserProfileDelegate {
    var parentCoordinator: Coordinator?
    weak var delegate: HomeTabBarCoordinatorDelegate?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        Logger.debug("PartnersCoordinator deinit")
    }
    
    func start() {
        let controller = PartnersViewController(
            viewModel: .init(
                navigation: self,
                vendorUseCase: VendorAPIService()
            )
        )
        showController(vc: controller)
    }
}

extension PartnersCoordinator: PartnersNavigation, HomeNavigation {
    func didRequestLogout(type: LogoutType) {
        //
    }
    
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
    
    func showPartnerGallery(partner: newPartner, selectedIndex: Int) {
        let vc = PartnerGalleryViewController(viewModel: .init(navigation: self, partner: partner, selectedIndex: selectedIndex))
        showController(vc: vc)
    }
    
    func showPartnerDetail(newPartner: newPartner) {
        let vc = PartnerDetailViewController(viewModel: .init(navigation: self, newPartner: newPartner, vendorUseCase: VendorAPIService()))
        showController(vc: vc)
    }
    
    func popController() {
        popControllerBack()
    }
}
