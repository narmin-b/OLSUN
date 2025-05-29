//
//  PartnersViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import Foundation

final class PartnersViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PartnersNavigation?
//    private var taskUseCase: PlanningUseCase
    var taskList: [ListCellProtocol] = []
    
    init(navigation: PartnersNavigation/*, taskUseCase: PlanningUseCase*/) {
        self.navigation = navigation
//        self.taskUseCase = taskUseCase
    }
    
    // MARK: Navigations
    func showPartnerDetailVC(partner: Partner) {
        navigation?.showPartnerDetail(partner: partner)
    }
    
    func showProfileScreen() {
        navigation?.showProfile()
    }
}
