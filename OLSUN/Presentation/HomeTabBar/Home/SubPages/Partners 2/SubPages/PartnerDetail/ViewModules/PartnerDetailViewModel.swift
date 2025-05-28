//
//  PartnerDetailViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import Foundation

final class PartnerDetailViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PartnersNavigation?
    var partner: Partner?
    
    init(navigation: PartnersNavigation, partner: Partner) {
        self.navigation = navigation
        self.partner = partner
    }
    
    func showPartnerGallery(partner: Partner, index: Int) {
        navigation?.showPartnerGallery(partner: partner, selectedIndex: index)
    }
}
