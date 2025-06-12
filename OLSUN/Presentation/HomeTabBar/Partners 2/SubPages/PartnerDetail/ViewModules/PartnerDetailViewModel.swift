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
    private var vendorUseCase: VendorUseCase
    var newPartner: newPartner?
    
    init(navigation: PartnersNavigation, newPartner: newPartner, vendorUseCase: VendorUseCase) {
        self.navigation = navigation
        self.newPartner = newPartner
        self.vendorUseCase = vendorUseCase
    }
    
    func showPartnerGallery(partner: newPartner, index: Int) {
        navigation?.showPartnerGallery(partner: partner, selectedIndex: index)
    }
    
    func addIconClick(dto: clickDataModel) {
        print(#function)
        vendorUseCase.addClickCount(dto: dto) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let result = result {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
