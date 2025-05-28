//
//  PartnersCoordinator.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import Foundation
import UIKit.UINavigationController

final class PartnersCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
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
                navigation: self
            )
        )
        showController(vc: controller)
    }
}

extension PartnersCoordinator: PartnersNavigation {
    func showPartnerGallery(partner: Partner, selectedIndex: Int) {
        let vc = PartnerGalleryViewController(viewModel: .init(navigation: self, partner: partner, selectedIndex: selectedIndex))
        showController(vc: vc)
    }
    
    func showPartnerDetail(partner: Partner) {
        let vc = PartnerDetailViewController(viewModel: .init(navigation: self, partner: partner))
        showController(vc: vc)
    }
    
    func popController() {
        popControllerBack()
    }
}
