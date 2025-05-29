//
//  PartnerGalleryViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import Foundation

final class PartnerGalleryViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PartnersNavigation?
    var partner: Partner?
    var selectedIndex: Int
    
    init(navigation: PartnersNavigation, partner: Partner, selectedIndex: Int) {
        self.navigation = navigation
        self.partner = partner
        self.selectedIndex = selectedIndex
    }
    
    func popBackController() {
        navigation?.popController()
    }
}
